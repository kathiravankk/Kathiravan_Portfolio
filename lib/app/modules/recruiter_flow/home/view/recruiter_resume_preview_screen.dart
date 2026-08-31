import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/utils/common_utils.dart';
import 'package:internsharks/app/core/utils/resume_file_utils.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_student_profile_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecruiterResumePreviewScreen extends StatefulWidget {
  const RecruiterResumePreviewScreen({super.key});

  @override
  State<RecruiterResumePreviewScreen> createState() =>
      _RecruiterResumePreviewScreenState();
}

class _RecruiterResumePreviewScreenState
    extends State<RecruiterResumePreviewScreen> {
  late WebViewController _controller;
  bool _isWebViewReady = false;
  bool isLoading = true;
  late int templateId;
  //NewStudentProfileModel? resumeData;
  final RecruiterHomeController profileController = Get.find<RecruiterHomeController>();
  bool _canWebGoBack = false;
  InternStudentProfileModel? resumeData;


  @override
  void initState() {
    super.initState();
    templateId = Get.arguments["templateId"] ?? 1;
    studentId = Get.arguments["studentId"] ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStudentProfileData();
    });
    //resumeData = Get.arguments["resumeData"];
  }

  String? studentId = "";

  Future<void> getStudentProfileData() async {
    debugPrint(templateId.toString());
    debugPrint(studentId.toString());
    try {
      debugPrint("**************");
      await profileController.getInternProfileData(studentId: studentId!);
      if (profileController.getResponseCode() == 200 ||
          profileController.getResponseCode() == 201) {
        setState(() {
          resumeData = profileController.internProfileModel;
        });
        _initWebview();
      } else {
        AppFunctions.apiErrorHandling(
          profileController.getResponseCode(),
          "Something went wrong!, Try again later",
        );
      }
    } catch (error, stackTrace) {
      debugPrint("+++++++++++++++");
      debugPrint("ERROR: $error");
      debugPrint("STACK: $stackTrace");
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        "Something went wrong!, Try again later",
      );
    }
  }

  void _initWebview() {
    final template = templates.firstWhere((e) => e.id == templateId);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            final canBack = await _controller.canGoBack();
            if (mounted) setState(() => _canWebGoBack = canBack);
          },
          onPageFinished: (String url) async {
            final canBack = await _controller.canGoBack();
            if (mounted) setState(() => _canWebGoBack = canBack);
            if (!canBack && resumeData != null) {
              final jsonData = jsonEncode(resumeData!.toJson());
              await _controller.runJavaScript("renderResume($jsonData);");
            }
            if (mounted) setState(() => isLoading = false);
          },
        ),
      );

    if (mounted) setState(() => _isWebViewReady = true);
    _loadHtml(template.htmlPath);
  }

  Future<void> _handleWebBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      final canBack = await _controller.canGoBack();
      if (!canBack) {
        _initWebview();
      }
      if (mounted) setState(() => _canWebGoBack = canBack);
    } else {
      Get.back();
    }
  }

  Future<void> _loadHtml(String path) async {
    final html = await DefaultAssetBundle.of(context).loadString(path);
    await _controller.loadHtmlString(html);
  }

  // ─── Get fully rendered HTML from WebView ───────────────────────────────────
  // Future<String?> _getRenderedHtml() async {
  //   try {
  //     final result = await _controller.runJavaScriptReturningResult(
  //       "document.documentElement.outerHTML",
  //     );
  //     String html = result.toString();
  //     if (html.startsWith('"') && html.endsWith('"')) {
  //       html = json.decode(html);
  //     }
  //     return html;
  //   } catch (e) {
  //     debugPrint("Error getting HTML: $e");
  //     return null;
  //   }
  // }

  // ─── Convert HTML → Uint8List PDF bytes ─────────────────────────────────────
  // Future<Uint8List> _htmlToPdfBytes(String html) async {
  //   // Printing.convertHtml returns Uint8List directly
  //   final Uint8List bytes = await Printing.convertHtml(
  //     format: const PdfPageFormat(
  //       210 * PdfPageFormat.mm,
  //       297 * PdfPageFormat.mm,
  //       marginAll: 0,
  //     ),
  //     html: html,
  //   );
  //   return bytes;
  // }

  // ─── Show editable filename dialog ──────────────────────────────────────────
  Future<String?> _askFileName() async {
    final firstName = (resumeData!.studName ?? 'resume').split(' ').first;
    final defaultName = "${firstName}_resume";
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

  // ─── Request storage permission based on Android version ────────────────────
  // Future<bool> _requestStoragePermission() async {
  //   if (!Platform.isAndroid) return true;
  //
  //   // Get Android SDK version
  //   final androidInfo = await _getAndroidSdkVersion();
  //
  //   if (androidInfo >= 33) {
  //     // Android 13+ — no storage permission needed for Downloads via File API
  //     // WRITE_EXTERNAL_STORAGE is ignored on 33+, but we can still write to
  //     // /storage/emulated/0/Download directly without permission
  //     return true;
  //   } else if (androidInfo >= 29) {
  //     // Android 10–12 — WRITE_EXTERNAL_STORAGE is restricted but
  //     // /storage/emulated/0/Download is still accessible without it
  //     return true;
  //   } else {
  //     // Android 9 and below — need WRITE_EXTERNAL_STORAGE
  //     final status = await Permission.storage.request();
  //     return status.isGranted;
  //   }
  // }

  /// Returns Android SDK int version, defaults to 33 if unavailable
  Future<int> _getAndroidSdkVersion() async {
    try {
      // Use platform channel result from device_info_plus if available,
      // otherwise fall back to a safe default (treat as modern Android)
      return 33;
    } catch (_) {
      return 33;
    }
  }

  // // ─── Save Uint8List PDF to Downloads folder ──────────────────────────────────
  // Future<File?> _savePdfToDownloads(Uint8List bytes, String fileName) async {
  //   try {
  //     Directory downloadDir;
  //
  //     if (Platform.isAndroid) {
  //       // Standard public Downloads directory — works on Android 9+
  //       // without needing WRITE_EXTERNAL_STORAGE on Android 10+
  //       const downloadsPath = '/storage/emulated/0/Download';
  //       downloadDir = Directory(downloadsPath);
  //
  //       if (!await downloadDir.exists()) {
  //         // Fallback via getExternalStorageDirectory
  //         final extDir = await getExternalStorageDirectory();
  //         if (extDir != null) {
  //           final parts = extDir.path.split('Android');
  //           downloadDir = Directory('${parts.first}Download');
  //         }
  //       }
  //     } else {
  //       // iOS: save to app Documents (visible in Files app)
  //       downloadDir = await getApplicationDocumentsDirectory();
  //     }
  //
  //     if (!await downloadDir.exists()) {
  //       await downloadDir.create(recursive: true);
  //     }
  //
  //     final filePath = '${downloadDir.path}/$fileName.pdf';
  //     final file = File(filePath);
  //     await file.writeAsBytes(bytes); // writeAsBytes accepts Uint8List ✅
  //     return file;
  //   } catch (e) {
  //     debugPrint("Save error: $e");
  //     return null;
  //   }
  // }

  // ─── Handle Download ──────────────────────────────────────────────────────────
  Future<void> _handleDownload() async {
    final fileName = await _askFileName();
    if (fileName == null) return;

    setState(() => isLoading = true);

    try {
      await ResumeFileUtils.handleDownload(
        webViewController: _controller,
        fileName: fileName,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _handleShare() async {
    setState(() => isLoading = true);
    try {
      final firstName = (resumeData!.studName ?? 'resume').split(' ').first;
      await ResumeFileUtils.handleShare(
        webViewController: _controller,
        fileName: "${firstName}_resume",
        shareText: CommonUtils.resumeShareContent,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Future<void> _handleShare() async {
  //   setState(() => isLoading = true);
  //
  //   try {
  //     // ✅ Auto filename (no dialog)
  //     final firstName = (resumeData.personalInfo?.name ?? 'resume')
  //         .split(' ')
  //         .first;
  //     final fileName = "${firstName}_resume";
  //
  //     // ✅ Get rendered HTML
  //     final html = await _getRenderedHtml();
  //     if (html == null) throw Exception("Failed to get HTML");
  //
  //     // ✅ Convert to PDF
  //     final pdfBytes = await _htmlToPdfBytes(html);
  //
  //     // ✅ Save to temp directory (NOT downloads)
  //     final tempDir = await getTemporaryDirectory();
  //     final file = File('${tempDir.path}/$fileName.pdf');
  //     await file.writeAsBytes(pdfBytes);
  //
  //     // ✅ Direct share (no prompt before)
  //     await Share.shareXFiles([XFile(file.path)], text: 'My Resume');
  //   } catch (e) {
  //     debugPrint("Share error: $e");
  //     AppFunctions.showToast(message: "Failed to share resume", isError: true);
  //   } finally {
  //     if (mounted) setState(() => isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_canWebGoBack,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleWebBack();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.appBackgroundImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: AppColors.transparentColor,
          appBar: AppBar(
            backgroundColor: AppColors.transparentColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                if (_canWebGoBack) {
                  await _handleWebBack();
                } else {
                  Get.back();
                }
              },
            ),
            title: Text(
              "Resume Preview",
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.secondaryColor,
                weight: FontWeight.w600,
              ),
            ),
          ),
          body: Obx(
                () => profileController.internProfileLoading
                ? AppAlertUtils.customLoader()
                : !_isWebViewReady
                ? AppAlertUtils.customLoader()
                : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_canWebGoBack)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primaryColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _handleWebBack,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Back to Resume",
                                style: AppStyles.customTextStyle(
                                  size: 13,
                                  color: Colors.white,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (isLoading)
                  Container(
                    color: Colors.black45,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppAlertUtils.customLoader(),
                          SizedBox(height: 12),
                          Text(
                            "Processing...",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: "download",
                backgroundColor: AppColors.primaryColor,
                onPressed: isLoading ? null : _handleDownload,
                tooltip: "Download PDF",
                child: const Icon(Icons.download, color: Colors.white),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: "share",
                backgroundColor: AppColors.primaryColor,
                onPressed: isLoading ? null : _handleShare,
                tooltip: "Share PDF",
                child: const Icon(Icons.share, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResumeTemplateModel {
  final int id;
  final String htmlPath;
  final String thumbnailPath;

  ResumeTemplateModel({
    required this.id,
    required this.htmlPath,
    required this.thumbnailPath,
  });
}

final List<ResumeTemplateModel> templates = List.generate(
  10,
      (index) => ResumeTemplateModel(
    id: index + 1,
    htmlPath: 'assets/images/html_templates/resume_template_${index + 1}.html',
    thumbnailPath:
    'assets/images/templates_thumbnail/resume_thumbnail_${index + 1}.png',
  ),
);
