import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';

class ResumeViewPage extends StatefulWidget {
  final file;
  const ResumeViewPage({super.key, required this.file});

  @override
  State<ResumeViewPage> createState() => _ResumeViewPageState();
}

class _ResumeViewPageState extends State<ResumeViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resume Preview",style:  AppTextStyles.white24Bold,),
        backgroundColor: Colors.black,
         leading:InkWell ( onTap: () {
           Navigator.pop(context);
         },child: Icon(Icons.arrow_back,size: 25,color: Colors.white,)),
      ),
      body: PDFView(
        filePath: widget.file.path,
      ),
    );
  }
}
