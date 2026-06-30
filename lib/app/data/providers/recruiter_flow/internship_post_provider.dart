import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/recruiter_flow/applicants_list_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_student_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';

class InternshipPostProvider {
  final Dio? client;

  InternshipPostProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // GET PROFILE DATA

  Future<InternshipPostModel> fetchPostedInternships({
    required String recruiterId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getPostedInternships(recruiterId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return InternshipPostModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return InternshipPostModel.fromJson(err.response!.data);
    }
  }

  // GET APPLICANTS
  Future<ApplicantsListModel> fetchApplicants({required String jobId}) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getJobApplicants(jobId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;

      return ApplicantsListModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return ApplicantsListModel.fromJson(err.response!.data);
    }
  }

  // GET STUDENT PROFILE DATA

  Future<InternStudentProfileModel> fetchInternStudentProfile({
    required String jobId,
    required String studentId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.getInternStudentProfile(jobId),
        options: Options(headers: header),
        data: {"studentId": studentId},
      );
      responseStatus = response.statusCode!;
      return InternStudentProfileModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return InternStudentProfileModel.fromJson(err.response!.data);
    }
  }
}
