import 'package:internsharks/models/extracted_data_model.dart';

class ResumeAnalyzeModel {
  bool? success;
  String? filename;
  String? message; // ✅ Added message field
  ResumeData? resumeData;

  ResumeAnalyzeModel({
    this.success,
    this.filename,
    this.message,
    this.resumeData,
  });

  factory ResumeAnalyzeModel.fromJson(Map<String, dynamic> json) {
    return ResumeAnalyzeModel(
      success: json['success'],
      filename: json['filename'],
      message: json['message'], //map message
      resumeData: json['extracted_data'] != null
          ? ResumeData.fromJson(json['extracted_data'])
          : null,
    );
  }
}
