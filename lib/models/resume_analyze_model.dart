import 'package:internsharks/models/extracted_data_model.dart';

class ResumeAnalyzeModel {
  bool? success;
  String? filename;
  ResumeData? resumeData;

  ResumeAnalyzeModel({
    this.success,
    this.filename,
    this.resumeData,
  });

  factory ResumeAnalyzeModel.fromJson(Map<String, dynamic> json) {
    return ResumeAnalyzeModel(
      success: json['success'],
      filename: json['filename'],
      resumeData: json['extracted_data'] != null
          ? ResumeData.fromJson(json['extracted_data'])
          : null,
    );
  }
}
