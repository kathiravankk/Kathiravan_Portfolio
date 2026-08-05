import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/ai_chat_response_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/applicants_list_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/application_status_update_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/create_stipend_order_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_student_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/issued_certificate_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/new_internship_data_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_feedback_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_review_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/send_request_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/syllabus_chat_response_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/syllabus_generate_model.dart';

import '../../models/recruiter_flow/syllabus_view_data_model.dart'
    show SyllabusViewData, SyllabusViewDataModel;

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
  Future<ApplicantsListModel> fetchApplicants({
    required String jobId,
    required String status,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getJobApplicants(jobId, status),
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
    required String syllabusId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.put(
        AppApiUrls.updateApplicationStatus(applicationId),
        options: Options(headers: header),
        data: {"status": status, "syllabusId": syllabusId},
      );
      responseStatus = response.statusCode!;
      return ApplicationStatusUpdateModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return ApplicationStatusUpdateModel.fromJson(err.response!.data);
    }
  }

  // UPDATE APPLICATION STATUS

  Future<RecruiterReviewModel> fetchRecruiterReview({
    required String jobId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getRecruiterReview(jobId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return RecruiterReviewModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return RecruiterReviewModel.fromJson(err.response!.data);
    }
  }

  // GET ISSUED CERTIFICATE

  Future<IssuedCertificateModel> fetchIssuedCertificate({
    required String jobId,
    required String studentId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getIssuedCertificate(studentId, jobId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return IssuedCertificateModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return IssuedCertificateModel.fromJson(err.response!.data);
    }
  }

  // GET SYLLABUS CHAT DATA

  Future<SyllabusChatResponseModel> fetchSyllabusChatData({
    required SyllabusViewData syllabusData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.updateSyllabusData,
        options: Options(headers: header),
        data: syllabusData.toJson(),
      );
      responseStatus = response.statusCode!;
      return SyllabusChatResponseModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return SyllabusChatResponseModel.fromJson(err.response!.data);
    }
  }

  // SYLLABUS CHAT MESSAGE

  Future<AiChatResponseModel> syllabusChatMessage({
    required String message,
    required String chatId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.syllabusUpdateChat,
        options: Options(headers: header),
        data: {"user_id": chatId, "message": message},
      );
      responseStatus = response.statusCode!;
      return AiChatResponseModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return AiChatResponseModel.fromJson(err.response!.data);
    }
  }

  // UPDATE SYLLABUS CHAT MESSAGE

  Future<SyllabusViewDataModel> updateSyllabusChatMessage({
    required SyllabusGenerateModel syllabusData,
    required String studentId,
    required String jobId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.put(
        AppApiUrls.syllabusDataUpdate(studentId, jobId),
        options: Options(headers: header),
        data: syllabusData.toJson(),
      );
      responseStatus = response.statusCode!;
      return SyllabusViewDataModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return SyllabusViewDataModel.fromJson(err.response!.data);
    }
  }

  // CHECK STIPEND STATUS

  Future<CommonLoginOtpModel> checkStipendStatus({
    required String studentId,
    required String jobId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.checkStipendStatus(studentId, jobId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return CommonLoginOtpModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CommonLoginOtpModel.fromJson(err.response!.data);
    }
  }

  // CREATE STIPEND PAYMENT ORDER

  Future<CreateStipendOrderModel> createStipendPaymentOrder({
    required String studentId,
    required String jobId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.createStipendOrder,
        options: Options(headers: header),
        data: {"jobId": jobId, "studentId": studentId},
      );
      responseStatus = response.statusCode!;
      return CreateStipendOrderModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CreateStipendOrderModel.fromJson(err.response!.data);
    }
  }

  // VERIFY STIPEND PAYMENT ORDER

  Future<CommonLoginOtpModel> verifyStipendPaymentOrder({
    required String orderId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.verifyStipendOrder,
        options: Options(headers: header),
        data: {
          "orderId": orderId
        }
      );
      responseStatus = response.statusCode!;
      return CommonLoginOtpModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CommonLoginOtpModel.fromJson(err.response!.data);
    }
  }

  // SEND COORDINATOR OTP

  Future<CoordinatorOtpModel> sendCoordinatorOtp({
    required String mobileNumber,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
          AppApiUrls.sendCoordinatorOtp,
          options: Options(headers: header),
          data: {
            "mobile": mobileNumber
          }
      );
      responseStatus = response.statusCode!;
      return CoordinatorOtpModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CoordinatorOtpModel.fromJson(err.response!.data);
    }
  }

  // VERIFY COORDINATOR OTP

  Future<CommonLoginOtpModel> verifyCoordinatorOtp({
    required String mobileNumber,
    required String otpNumber,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
          AppApiUrls.verifyCoordinatorOtp,
          options: Options(headers: header),
          data: {
            "mobile": mobileNumber,
            "otp": otpNumber
          }
      );
      responseStatus = response.statusCode!;
      return CommonLoginOtpModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CommonLoginOtpModel.fromJson(err.response!.data);
    }
  }

  // GIVE RECRUITER FEEDBACK

  Future<RecruiterFeedbackModel> giveRecruiterFeedback({
    required Map<String, dynamic> reviewData
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
          AppApiUrls.giveRecruiterReview,
          options: Options(headers: header),
          data: reviewData
      );
      responseStatus = response.statusCode!;
      return RecruiterFeedbackModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return RecruiterFeedbackModel.fromJson(err.response!.data);
    }
  }
}
