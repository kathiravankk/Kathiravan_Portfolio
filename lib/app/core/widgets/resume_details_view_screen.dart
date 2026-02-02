import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:internsharks/app/data/models/resume_analyze_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResumeDetailsViewScreen extends StatefulWidget {
  final String htmlAssetPath;
  final ExtractedResumeDataModel resumeData;

  const ResumeDetailsViewScreen({
    super.key,
    required this.htmlAssetPath,
    required this.resumeData,
  });

  @override
  State<ResumeDetailsViewScreen> createState() =>
      _ResumeDetailsViewScreenState();
}

class _ResumeDetailsViewScreenState extends State<ResumeDetailsViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            final jsonData = jsonEncode(widget.resumeData.toJson());

            await _controller.runJavaScript("renderResume($jsonData);");

            setState(() => _isLoading = false);
          },
        ),
      );

    _loadHtml();
  }

  Future<void> _loadHtml() async {
    final htmlString = await DefaultAssetBundle.of(
      context,
    ).loadString(widget.htmlAssetPath);

    await _controller.loadHtmlString(htmlString);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
