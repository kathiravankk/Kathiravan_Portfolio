import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

class ResumeFileUtils {
  ResumeFileUtils._();

  // ─────────────────────────────────────────────────────────────────────────────
  // 1. GET RENDERED HTML FROM WEBVIEW
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<String?> getRenderedHtml(WebViewController controller) async {
    try {
      final result = await controller.runJavaScriptReturningResult(
        "document.documentElement.outerHTML",
      );
      String html = result.toString();
      if (html.startsWith('"') && html.endsWith('"')) {
        html = json.decode(html);
      }
      return html;
    } catch (e) {
      debugPrint("Error getting HTML: $e");
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 2. INJECT PDF-SAFE CSS — fixes the "blank gap / split 2 pages" bug
  //
  //  WHY this happens:
  //  • Your HTML sets viewport width=900 but Printing.convertHtml renders at
  //    ~595px (A4). Content overflows → wraps → creates extra blank space.
  //  • Fixed-height sections (header banner etc.) reserve px-based space that
  //    doesn't scale to A4, pushing body content far down → page 2.
  //  • Absolute-positioned elements are measured but not "in flow", so they
  //    add invisible height that Chromium/wkhtmltopdf accounts for.
  //
  //  THE FIX:
  //  • Force html/body width to 210mm (A4) so nothing overflows horizontally.
  //  • Remove all fixed heights → auto, overflow → visible.
  //  • Convert absolute → relative so they're in-flow and don't create gaps.
  //  • Disable all page-break rules so content flows as one continuous page.
  // ─────────────────────────────────────────────────────────────────────────────
  static String _injectPdfStyles(String html) {
    const pdfCss = '''
<style id="__pdf_override__">
  /* Force A4 width — nothing overflows horizontally */
  html, body {
    width: 210mm !important;
    max-width: 210mm !important;
    margin: 0 !important;
    padding: 0 !important;
    overflow: visible !important;
    background: white !important;
    -webkit-print-color-adjust: exact !important;
    print-color-adjust: exact !important;
  }

  /* No page breaks anywhere — single continuous page */
  * {
    page-break-inside: avoid !important;
    break-inside: avoid !important;
    page-break-before: avoid !important;
    break-before: avoid !important;
    page-break-after: avoid !important;
    break-after: avoid !important;
  }

  /* Remove fixed heights that push content off-screen */
  section, .section, header, .header,
  .resume-header, .resume-body, .resume-container,
  .container, .wrapper, main, article, .content,
  div[class], div[id] {
    height: auto !important;
    min-height: 0 !important;
    max-height: none !important;
    overflow: visible !important;
  }

  /* Absolute → relative so invisible height gaps are eliminated */
  [style*="position: absolute"],
  [style*="position:absolute"] {
    position: relative !important;
    top: auto !important;
    left: auto !important;
    right: auto !important;
    bottom: auto !important;
  }

  /* Ensure root wrapper fills page naturally */
  body > * {
    width: 100% !important;
    max-width: 100% !important;
    overflow: visible !important;
    position: relative !important;
  }
</style>
''';

    if (html.contains('</head>')) {
      return html.replaceFirst('</head>', '$pdfCss</head>');
    }
    return '$pdfCss$html';
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 3. HTML → PDF BYTES
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<Uint8List> htmlToPdfBytes(String html) async {
    final fixedHtml = _injectPdfStyles(html);
    return await Printing.convertHtml(
      format: PdfPageFormat.a4.copyWith(
        marginTop: 0,
        marginBottom: 0,
        marginLeft: 0,
        marginRight: 0,
      ),
      html: fixedHtml,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 4. FILENAME DIALOG
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<String?> askFileName({
    required BuildContext context,
    String defaultName = "my_resume",
  }) async {
    final controller = TextEditingController(text: defaultName);
    return await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.appBgColor_2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Save Resume As",
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AppStyles.customTextStyle(
            fontFamily: "Roboto",
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Enter file name",
            hintStyle: AppStyles.customTextStyle(
              fontFamily: "Roboto",
              color: AppColors.greyColor,
              size: 12,
              weight: FontWeight.w200,
            ),
            suffixText: ".pdf",
            suffixStyle: AppStyles.customTextStyle(
              fontFamily: "Roboto",
              color: AppColors.whiteColor,
              size: 14,
              weight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.fieldBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            filled: true,
            fillColor: AppColors.fieldBgColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: AppStyles.customTextStyle(
                fontFamily: "Roboto",
                color: AppColors.greyColor,
                size: 14,
                weight: FontWeight.w200,
              ),
            ),
          ),
          CustomButtonWidget(
            height: 35,
            width: 100,
            buttonFunction: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) Navigator.pop(ctx, name);
            },
            buttonText: "Save",
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 5. STORAGE PERMISSION
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;
    final sdk = await _getAndroidSdkVersion();
    if (sdk >= 33) return true;
    if (sdk >= 30) {
      await Permission.storage.request();
      return true; // MediaStore works without it on API 30–32
    }
    return (await Permission.storage.request()).isGranted;
  }

  static Future<int> _getAndroidSdkVersion() async => 33;

  // ─────────────────────────────────────────────────────────────────────────────
  // 6. RESOLVE DOWNLOADS DIRECTORY (real-device safe)
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<Directory> _resolveDownloadsDir() async {
    if (Platform.isIOS) return getApplicationDocumentsDirectory();

    const publicDownloads = '/storage/emulated/0/Download';
    final publicDir = Directory(publicDownloads);
    try {
      if (await publicDir.exists()) {
        final test = File('${publicDir.path}/.write_test');
        await test.writeAsString('x');
        await test.delete();
        return publicDir;
      }
    } catch (_) {}

    try {
      final ext = await getExternalStorageDirectory();
      if (ext != null) {
        final parts = ext.path.split('/');
        final idx = parts.indexOf('Android');
        if (idx > 0) {
          final dir = Directory('${parts.sublist(0, idx).join('/')}/Download');
          if (!await dir.exists()) await dir.create(recursive: true);
          return dir;
        }
        return ext;
      }
    } catch (_) {}

    return getApplicationDocumentsDirectory();
  }

  static Future<String> _generateUniqueFilePath({
    required Directory dir,
    required String fileName,
  }) async {
    final safe = fileName.replaceAll(RegExp(r'[^\w\s\-]'), '_').trim();

    String basePath = '${dir.path}/$safe';
    String filePath = '$basePath.pdf';

    int counter = 1;

    while (await File(filePath).exists()) {
      filePath = '${basePath}_$counter.pdf';
      counter++;
    }

    return filePath;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 7. MEDIA SCAN — makes file appear immediately in Downloads UI on real devices
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<void> _triggerMediaScan(String filePath) async {
    if (!Platform.isAndroid) return;
    try {
      const ch = MethodChannel('com.internsharks/media_scanner');
      await ch.invokeMethod('scanFile', {'path': filePath});
    } catch (e) {
      debugPrint('Media scan skipped: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 8. SAVE PDF TO DOWNLOADS
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<File?> savePdfToDownloads(
      Uint8List bytes,
      String fileName,
      ) async {
    try {
      final dir = await _resolveDownloadsDir();
      if (!await dir.exists()) await dir.create(recursive: true);

      // ✅ Generate unique file path
      final path = await _generateUniqueFilePath(
        dir: dir,
        fileName: fileName,
      );

      final file = File(path);
      await file.writeAsBytes(bytes, flush: true);

      await _triggerMediaScan(path);

      return file;
    } catch (e) {
      debugPrint("Save error: $e");
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 9. DOWNLOAD (WebView) — HomeProfileScreen
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<void> handleDownload({
    required WebViewController webViewController,
    required String fileName,
  }) async {
    try {
      if (!await requestStoragePermission()) {
        AppAlertUtils.showToast(
          message: "❌ Storage permission denied.",
          isError: true,
        );
        return;
      }

      final html = await getRenderedHtml(webViewController);
      if (html == null) {
        AppAlertUtils.showToast(
          message: "❌ Failed to capture resume content",
          isError: true,
        );
        return;
      }

      final file = await savePdfToDownloads(
        await htmlToPdfBytes(html),
        fileName,
      );

      AppAlertUtils.showToast(
        message: file != null
            ? "✅ Saved: ${file.path.split('/').last}"
            : "❌ Download failed.",
        isError: file == null,
      );
    } catch (e) {
      AppAlertUtils.showToast(
        message: "❌ Download failed: $e",
        isError: true,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 10. SHARE (WebView) — HomeProfileScreen
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<void> handleShare({
    required WebViewController webViewController,
    required String fileName,
  }) async {
    try {
      final html = await getRenderedHtml(webViewController);

      if (html == null) {
        AppAlertUtils.showToast(
          message: "❌ Failed to capture resume content",
          isError: true,
        );
        return;
      }

      await _sharePdfBytes(
        await htmlToPdfBytes(html),
        fileName,
      );
    } catch (e) {
      AppAlertUtils.showToast(
        message: "❌ Share failed",
        isError: true,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 11. DOWNLOAD (HTML string) — ChatResumeTemplateScreen
  //     Pass the raw HTML asset string + resume data to generate PDF directly,
  //     no live WebView needed.
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<void> handleDownloadFromHtml({
    required String html,
    required BuildContext context,
    String defaultFileName = "my_resume",
  }) async {
    final fileName = await askFileName(context: context, defaultName: defaultFileName);
    if (fileName == null) return;
    try {
      if (!await requestStoragePermission()) {
        AppAlertUtils.showToast(message: "❌ Storage permission denied.", isError: true);
        return;
      }
      final file = await savePdfToDownloads(await htmlToPdfBytes(html), fileName);
      AppAlertUtils.showToast(
        message: file != null ? "✅ Saved: $fileName.pdf" : "❌ Download failed.",
        isError: file == null,
      );
    } catch (e) {
      AppAlertUtils.showToast(message: "❌ Download failed: $e", isError: true);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // 12. SHARE (HTML string) — ChatResumeTemplateScreen
  // ─────────────────────────────────────────────────────────────────────────────
  static Future<void> handleShareFromHtml({
    required String html,
    String defaultFileName = "my_resume",
  }) async {
    try {
      await _sharePdfBytes(await htmlToPdfBytes(html), defaultFileName);
    } catch (e) {
      AppAlertUtils.showToast(message: "❌ Share failed", isError: true);
    }
  }

  // ─── shared share helper ─────────────────────────────────────────────────────
  static Future<void> _sharePdfBytes(Uint8List bytes, String fileName) async {
    final safe = fileName.replaceAll(RegExp(r'[^\w\s\-]'), '_').trim();
    final tmp = await getTemporaryDirectory();
    final file = File('${tmp.path}/$safe.pdf');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: "$safe.pdf",
      text: "Check out my resume!",
    );
  }
}