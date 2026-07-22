import '../internship/internship_status_model.dart';
import 'student_list_model.dart';

class ApplicantsListModel {
  bool? success;
  String? message;
  int? count;
  List<ApplicantsData>? applicantsList;

  ApplicantsListModel({
    this.success,
    this.message,
    this.count,
    this.applicantsList,
  });

  ApplicantsListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    count = json['count'] ?? 0;
    if (json['applications'] != null) {
      applicantsList = (json['applications'] as List)
          .map((e) => ApplicantsData.fromJson(e))
          .toList();
    } else {
      applicantsList = [];
    }
  }
}

class ApplicantsData {
  String? id;
  String? job;
  StudentDetails? studentDetails;
  String? recruiter;
  String? status;
  int? currentDay;
  String? jobMessage;
  List<String>? internProjectLink;
  String? createdAt;
  String? updatedAt;
  String? selectedAt;
  bool? isCertificateGenerated;
  int? v;
  List<DailyProgress>? dailyProgress;

  ApplicantsData({
    this.id,
    this.job,
    this.studentDetails,
    this.recruiter,
    this.status,
    this.currentDay,
    this.jobMessage,
    this.internProjectLink,
    this.isCertificateGenerated,
    this.createdAt,
    this.updatedAt,
    this.selectedAt,
    this.v,
    this.dailyProgress,
  });

  ApplicantsData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    job = json['job'];

    studentDetails = json['student'] != null
        ? StudentDetails.fromJson(json['student'])
        : null;

    recruiter = json['recruiter'];
    isCertificateGenerated = json['certificateGenerated']??false;
    status = json['status'];
    currentDay = json['currentDay'] ?? 0;
    jobMessage = json['jobmessage'] ?? "";

    internProjectLink =
        (json['internProjectlink'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    // selectedAt is missing in latest API
    selectedAt = json['selectedAt'];

    v = json['__v'];

    if (json['dailyProgress'] != null) {
      dailyProgress = (json['dailyProgress'] as List)
          .map((e) => DailyProgress.fromJson(e))
          .toList();
    } else {
      dailyProgress = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'job': job,
      'student': studentDetails?.toJson(),
      'recruiter': recruiter,
      'status': status,
      'currentDay': currentDay,
      'jobmessage': jobMessage,
      'internProjectlink': internProjectLink,
      'certificateGenerated': isCertificateGenerated,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'selectedAt': selectedAt,
      '__v': v,
      'dailyProgress': dailyProgress?.map((e) => e.toJson()).toList(),
    };
  }
}
