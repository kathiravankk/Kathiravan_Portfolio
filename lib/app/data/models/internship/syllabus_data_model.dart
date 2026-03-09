import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';

class SyllabusDataModel {
  String? message;
  bool? success;
  SyllabusData? syllabusData;
  int? currentWeek;
  String? internStartDate;
  List<WeeklyProgressData>? weeklyProgressList;

  SyllabusDataModel({
    this.syllabusData,
    this.message,
    this.success,
    this.currentWeek,
    this.internStartDate,
    this.weeklyProgressList,
  });

  SyllabusDataModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    currentWeek = json["currentWeek"] ?? 0;
    internStartDate = json["internstarted"] ?? "";
    success = json["success"] ?? false;
    syllabusData = json['syllabus'] != null
        ? SyllabusData.fromJson(json['syllabus'])
        : null;
    if (json['weeklyprogress'] != null) {
      weeklyProgressList = (json['weeklyprogress'] as List)
          .map((e) => WeeklyProgressData.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "success": success,
      "syllabus": syllabusData,
      "currentWeek": currentWeek,
      "internstarted": internStartDate,
      "weeklyprogress": weeklyProgressList,
    };
  }
}

class WeeklyProgressData {
  int? weekNumber;
  String? status;
  String? completedAt;
  String? id;

  WeeklyProgressData({this.id, this.completedAt, this.status, this.weekNumber});

  WeeklyProgressData.fromJson(Map<String, dynamic> json) {
    weekNumber = json["weekNumber"] ?? 0;
    status = json["status"] ?? "";
    completedAt = json["completedAt"] ?? "";
    id = json["_id"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "completedAt": completedAt,
      "status": status,
      "weekNumber": weekNumber,
    };
  }
}
