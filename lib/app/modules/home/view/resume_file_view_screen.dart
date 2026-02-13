import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ResumeFileViewScreen extends StatefulWidget {
  const ResumeFileViewScreen({super.key});

  @override
  State<ResumeFileViewScreen> createState() => _ResumeFileViewScreenState();
}

class _ResumeFileViewScreenState extends State<ResumeFileViewScreen> {
  late String resumeUrl;
  bool isLoading = false;
  final Dio _dio = Dio(); // Reuse Dio instance for better performance

  @override
  void initState() {
    super.initState();
    // Use Get.arguments safely
    resumeUrl = Get.arguments?["resumeUrl"] ?? "";
  }

  Future<File?> _downloadFile() async {
    if (resumeUrl.isEmpty) return null;

    setState(() => isLoading = true);

    try {
      Directory? dir;

      if (Platform.isAndroid) {
        final baseDir = await getExternalStorageDirectory();
        final newPath = "${baseDir!.path.split("Android").first}Download";

        dir = Directory(newPath);
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final filePath =
          "${dir.path}/resume_${DateTime.now().millisecondsSinceEpoch}.pdf";

      await _dio.download(
        resumeUrl,
        filePath,
        onReceiveProgress: (received, total) {
          // optional progress
        },
      );

      return File(filePath);
    } catch (e) {
      debugPrint("Download Error: $e");
      return null;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }


  Future<void> _handleDownload() async {
    final file = await _downloadFile();
    if (file != null) {
      _showSnackBar("Downloaded to: ${file.path}");
      print(file.path);
    } else {
      _showSnackBar("Download failed");
    }
  }

  Future<void> _handleShare() async {
    final file = await _downloadFile();
    if (file != null) {
      // share_plus latest uses XFile
      await Share.shareXFiles([XFile(file.path)], text: 'Check out this resume');
    } else {
      _showSnackBar("Unable to share file");
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparentColor,
      appBar: AppBar(
        backgroundColor: AppColors.transparentColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Your Resume",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.secondaryColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (resumeUrl.isNotEmpty)
            SfPdfViewer.network(
              resumeUrl,
              canShowScrollHead: true,
              canShowScrollStatus: true,
            )
          else
            const Center(child: Text("No PDF URL provided")),

          if (isLoading)
            const ModalBarrier(dismissible: false, color: Colors.black26),
          if (isLoading)
            const Center(child: CircularProgressIndicator.adaptive()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "download",
            onPressed: isLoading ? null : _handleDownload,
            child: const Icon(Icons.download),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "share",
            onPressed: isLoading ? null : _handleShare,
            child: const Icon(Icons.share),
          ),
        ],
      ),
    );
  }
}