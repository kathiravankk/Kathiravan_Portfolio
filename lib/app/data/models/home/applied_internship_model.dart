import 'package:internsharks/app/data/models/home/recommand_internship_model.dart';

class AppliedInternshipModel {
  String? message;
  int? count;
  List<ApplicationData>? applicationList;

  AppliedInternshipModel({this.count, this.message, this.applicationList});

  AppliedInternshipModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    count = json["count"] ?? 0;
    if (json['applications'] != null) {
      applicationList = <ApplicationData>[];
      json['applications'].forEach((v) {
        applicationList!.add(ApplicationData.fromJson(v));
      });
    }
  }
}

class ApplicationData {
  String? aId;
  RecommentedData? jobData;
  String? studentId;
  String? recruiterId;
  String? status;
  int? currentWeek;
  String? createdAt;
  String? updatedAt;
  int? vId;
  List<ProgressData>? weeklyProgress;

  ApplicationData.fromJson(Map<String, dynamic> json) {
    aId = json["_id"] ?? "";
    studentId = json["student"] ?? "";
    recruiterId = json["recruiter"] ?? "";
    status = json["status"] ?? "";
    createdAt = json["createdAt"] ?? "";
    jobData = json['job'] != null ? RecommentedData.fromJson(json['job']) : null;
    updatedAt = json["updatedAt"] ?? "";
    currentWeek = json["currentWeek"] ?? 0;
    vId = json["__v"] ?? 0;
    if (json['weeklyProgress'] != null) {
      weeklyProgress = <ProgressData>[];
      json['weeklyProgress'].forEach((v) {
        weeklyProgress!.add(ProgressData.fromJson(v));
      });
    }
  }

  ApplicationData({
    this.status,
    this.weeklyProgress,
    this.studentId,
    this.jobData,
    this.vId,
    this.currentWeek,
    this.updatedAt,
    this.createdAt,
    this.recruiterId,
    this.aId,
  });
}

class ProgressData {
  String? status;
  String? completedAt;
  String? sId;
  int? weekNumber;

  ProgressData.fromJson(Map<String, dynamic> json) {
    status = json["status"] ?? "";
    completedAt = json["completedAt"] ?? "";
    sId = json["_id"] ?? "";
    weekNumber = json["weekNumber"] ?? 0;
  }

  ProgressData({this.weekNumber, this.sId, this.completedAt, this.status});
}
