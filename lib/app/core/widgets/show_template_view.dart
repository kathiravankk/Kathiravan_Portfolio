import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShowTemplateView extends StatefulWidget {
  final String htmlAssetPath;
  final ExtractedResumeDataModel resumeData;

  const ShowTemplateView({
    super.key,
    required this.htmlAssetPath,
    required this.resumeData,
  });

  @override
  State<ShowTemplateView> createState() =>
      _ShowTemplateViewState();
}

class _ShowTemplateViewState extends State<ShowTemplateView> {
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
        if (_isLoading)  AppAlertUtils.customLoader(),
      ],
    );
  }
}
