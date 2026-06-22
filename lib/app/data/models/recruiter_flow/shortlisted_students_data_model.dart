import 'package:internsharks/app/data/models/recruiter_flow/student_list_model.dart';

class ShortlistedStudentDataModel{
  bool? success;
  String? message;
  List<ShortlistedData>? shortlistedData;

  ShortlistedStudentDataModel({
    this.success,
    this.message,
    this.shortlistedData,
  });

  ShortlistedStudentDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success']??false;
    message = json['message']??"";
    shortlistedData = json['data'] != null
        ? List<ShortlistedData>.from(
        json['data'].map((x) => ShortlistedData.fromJson(x)))
        : null;
  }
}

class ShortlistedData {
  String? id;
  StudentDetails? student;
  String? recruiter;
  String? status;
  String? note;
  String? createdAt;
  String? updatedAt;
  int? vId;

  ShortlistedData({
    this.id,
    this.student,
    this.recruiter,
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.vId,
  });

  ShortlistedData.fromJson(Map<String, dynamic> json) {
    id = json['_id']??"";

    student = json['student'] != null
        ? StudentDetails.fromJson(json['student'])
        : null;

    recruiter = json['recruiter']??"";
    status = json['status']??"";
    note = json['note']??"";
    createdAt = json['createdAt']??"";
    updatedAt = json['updatedAt']??"";
    vId = json['__v']??0;
  }
}