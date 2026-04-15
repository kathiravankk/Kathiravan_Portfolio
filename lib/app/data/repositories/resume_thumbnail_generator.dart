import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResumeThumbnailGenerator {
  static Future<File> generate({
    required String htmlAssetPath,
    required String fileName,
  }) async {
    final repaintBoundary = GlobalKey();

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset(htmlAssetPath);

    // Render offscreen
    final widget = MaterialApp(
      home: Scaffold(
        body: RepaintBoundary(
          key: repaintBoundary,
          child: SizedBox(
            width: 420, // A4 scaled
            height: 600,
            child: WebViewWidget(controller: controller),
          ),
        ),
      ),
    );

    final renderView = RenderRepaintBoundary();
    await Future.delayed(const Duration(seconds: 2)); // allow full render

    final image = await renderView.toImage(pixelRatio: 2);
    final byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.png');

    await file.writeAsBytes(byteData!.buffer.asUint8List());
    return file;
  }
}

class ResumeTemplate {
  final String id;
  final String title;
  final String htmlAssetPath;

  const ResumeTemplate({
    required this.id,
    required this.title,
    required this.htmlAssetPath,
  });
}

