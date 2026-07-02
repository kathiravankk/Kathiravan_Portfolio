import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/recruiter_flow/applicants_list_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/application_status_update_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_student_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/new_internship_data_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/send_request_model.dart';

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

  // POST NEW INTERNSHIP

  Future<NewInternshipDataModel> createNewInternship({
    required Map<String, dynamic> internshipData,
  }) async {
    try {
      Map<String, dynamic> header = await AppApiHeader.recFormDataHeader();

      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      // Convert Map to FormData
      final formData = FormData.fromMap(internshipData);
      for (var f in formData.fields) {
        debugPrint('${f.key} => ${f.value}');
      }

      Response response = await client!
          .post(
            AppApiUrls.newInternPost,
            data: formData,
            options: Options(headers: header),
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return NewInternshipDataModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return NewInternshipDataModel.fromJson(error.response?.data);
    }
  }

  // UPDATE NEW INTERNSHIP

  Future<NewInternshipDataModel> updateNewInternship({
    required String jobId,
    required Map<String, dynamic> internshipData,
  }) async {
    try {
      Map<String, dynamic> header = await AppApiHeader.recFormDataHeader();

      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      // Convert Map to FormData
      final formData = FormData.fromMap(internshipData);
      for (var f in formData.fields) {
        debugPrint('${f.key} => ${f.value}');
      }
      Response response = await client!
          .put(
            AppApiUrls.updateNewInternPost(jobId),
            data: formData,
            options: Options(headers: header),
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return NewInternshipDataModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return NewInternshipDataModel.fromJson(error.response?.data);
    }
  }

  // SEND INTERNSHIP REQUEST

  Future<SendRequestModel> sendInternshipRequest({
    required Map<String, dynamic> internshipData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.sendInternshipRequest,
        options: Options(headers: header),
        data: internshipData,
      );
      responseStatus = response.statusCode!;
      return SendRequestModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return SendRequestModel.fromJson(err.response!.data);
    }
  }

  // UPDATE APPLICATION STATUS

  Future<ApplicationStatusUpdateModel> updateApplicationStatus({
    required String status,
    required String applicationId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.put(
        AppApiUrls.updateApplicationStatus(applicationId),
        options: Options(headers: header),
        data: {"status": status},
      );
      responseStatus = response.statusCode!;
      return ApplicationStatusUpdateModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return ApplicationStatusUpdateModel.fromJson(err.response!.data);
    }
  }
}
