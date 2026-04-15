import 'package:internsharks/app/data/models/account/extracted_data_model.dart';

class ResumeExtractModel {
  bool? success;
  String? filename;
  String? message;
  ResumeData? resumeData;

  ResumeExtractModel({
    this.success,
    this.filename,
    this.message,
    this.resumeData,
  });

  factory ResumeExtractModel.fromJson(Map<String, dynamic> json) {
    return ResumeExtractModel(
      success: json['success'],
      filename: json['filename'],
      message: json['message'], //map message
      resumeData: json['extracted_data'] != null
          ? ResumeData.fromJson(json['extracted_data'])
          : null,
    );
  }
}
