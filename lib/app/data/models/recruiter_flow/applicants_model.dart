import '../internship/internship_status_model.dart';
import 'student_list_model.dart';

class ApplicantsModel {
  final String id;
  final String job;
  final StudentDetails studentDetails;
  final String recruiter;
  final String status;
  final int currentDay;
  final String jobmessage;
  final List<String> internProjectLink;
  final String createdAt;
  final String updatedAt;
  final String selectedAt;
  final List<DailyProgress> dailyProgress;

  ApplicantsModel({
    required this.id,
    required this.job,
    required this.studentDetails,
    required this.recruiter,
    required this.status,
    required this.currentDay,
    required this.jobmessage,
    required this.internProjectLink,
    required this.createdAt,
    required this.updatedAt,
    required this.selectedAt,
    required this.dailyProgress,
  });

  factory ApplicantsModel.fromJson(Map<String, dynamic> json) {
    return ApplicantsModel(
      id: json['_id'] as String,
      job: json['job'] as String,
      studentDetails: StudentDetails.fromJson(
        json['student'] as Map<String, dynamic>,
      ),
      recruiter: json['recruiter'] as String,
      status: json['status'] as String,
      currentDay: json['currentDay'] as int,
      jobmessage: json['jobmessage'] as String,
      internProjectLink: (json['internProjectlink'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      selectedAt: json['selectedAt'] as String,
      dailyProgress: (json['dailyProgress'] as List<dynamic>? ?? [])
          .map((e) => DailyProgress.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job': job,
      'student': studentDetails.toJson(),
      'recruiter': recruiter,
      'status': status,
      'currentDay': currentDay,
      'jobmessage': jobmessage,
      'internProjectlink': internProjectLink,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'selectedAt': selectedAt,
      'dailyProgress': dailyProgress.map((e) => e.toJson()).toList(),
    };
  }
}
