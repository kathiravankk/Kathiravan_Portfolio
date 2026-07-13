import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/home/credit_order_verify_model.dart';
import 'package:internsharks/app/data/models/home/order_create_credit_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/add_shortlist-students_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_credits_plan_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/shortlisted_students_data_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/student_list_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/syllabus_data_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/syllabus_generate_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/syllabus_save_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_test_result_model.dart';

class RecruiterHomeProvider {
  final Dio? client;

  RecruiterHomeProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // GET PROFILE DATA

  Future<RecruiterProfileModel> fetchRecruiterProfile({required String recruiterId}) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.getRecruiterProfile,
        options: Options(headers: header),
        data: {"id": recruiterId},
      );
      responseStatus = response.statusCode!;
      return RecruiterProfileModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return RecruiterProfileModel.fromJson(err.response!.data);
    }
  }

  // GET STUDENT LIST DATA

  Future<StudentListModel> fetchStudentListData() async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getAllStudentsList,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return StudentListModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return StudentListModel.fromJson(err.response!.data);
    }
  }

  // ADD TO SHORTLISTED STUDENTS
  Future addToShortlistStudent({required String studentId}) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .post(
        AppApiUrls.addToShortlistedStudents,
        data: {"studentId": studentId},
        options: Options(headers: header),
      )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return AddShortlistStudentModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return AddShortlistStudentModel.fromJson(error.response!.data);
      } else {
        return AddShortlistStudentModel.fromJson(error.response!.data);
      }
    }
  }

  // REMOVE SHORTLISTED STUDENTS
  Future deleteShortlistStudent({required String studentId}) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .delete(
        AppApiUrls.removeShortlistedStudents,
        data: {"studentId": studentId},
        options: Options(headers: header),
      )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return CommonLoginOtpModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return CommonLoginOtpModel.fromJson(error.response!.data);
      } else {
        return CommonLoginOtpModel.fromJson(error.response!.data);
      }
    }
  }

  // GET SHORTLIST STUDENT LIST DATA

  Future<ShortlistedStudentDataModel> fetchShortlistStudentsList() async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getShortlistedStudents,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return ShortlistedStudentDataModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return ShortlistedStudentDataModel.fromJson(err.response!.data);
    }
  }

  Future<CommonLoginOtpModel> updateRecruiterProfile({
    required Map<String, dynamic> updateData,
  }) async {
    try {
      Map<String, dynamic> header = await AppApiHeader.recFormDataHeader();

      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      // Convert Map to FormData
      final formData = FormData.fromMap(updateData);
      for (var f in formData.fields) {
        debugPrint('${f.key} => ${f.value}');
      }

      Response response = await client!
          .put(
        AppApiUrls.recruiterUpdateProfile,
        data: formData,
        options: Options(headers: header),
      )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return CommonLoginOtpModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return CommonLoginOtpModel.fromJson(error.response?.data);
    }
  }

  // GENERATE SYLLABUS
  Future generateSyllabus({required Map<String, dynamic>requireData}) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true,),
      );
      Response response = await client!
          .post(
        AppApiUrls.generateSyllabus,
        data: requireData,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      debugPrint(response.data.toString(), wrapWidth: 1024);
      return SyllabusGenerateModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return SyllabusGenerateModel.fromJson(error.response!.data);
      } else {
        return SyllabusGenerateModel.fromJson(error.response!.data);
      }
    }
  }

  // SAVE SYLLABUS
  Future saveSyllabus({required SyllabusGenerateModel syllabusData}) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .post(
        AppApiUrls.saveSyllabus,
        data: syllabusData.toJson(),
        options: Options(headers: header),
      )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return SyllabusSaveModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return SyllabusSaveModel.fromJson(error.response!.data);
      } else {
        return SyllabusSaveModel.fromJson(error.response!.data);
      }
    }
  }

  // GET SYLLABUS
  Future fetchSyllabus({required String studentId, required String jobId}) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .get(
        AppApiUrls.getSyllabus(studentId, jobId),
        options: Options(headers: header),
      )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return SyllabusViewDataModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return SyllabusViewDataModel.fromJson(error.response!.data);
      } else {
        return SyllabusViewDataModel.fromJson(error.response!.data);
      }
    }
  }

 //GET STUDENTS RESULT
  Future<InternTestResultModel> fetchStudentResult({
    required String jobId,
    required String studentId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getStudentResult(studentId, jobId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return InternTestResultModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return InternTestResultModel.fromJson(err.response!.data);
    }
  }
  // GET RECRUITER CREDITS PLANS

  Future<RecruiterCreditsPlansModel> fetchRecruiterCreditPlans() async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getRecruiterCreditPlans,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return RecruiterCreditsPlansModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return RecruiterCreditsPlansModel.fromJson(err.response!.data);
    }
  }

  // CREATE CREDIT ORDER

  Future<OrderCreateCreditModel> newCreditPlanOrder({
    required String creditId,
    required String planId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.createRecruiterCreditOrder,
        options: Options(headers: header),
        data: {"creditId": creditId, "planId": planId},
      );
      responseStatus = response.statusCode!;
      return OrderCreateCreditModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return OrderCreateCreditModel.fromJson(err.response!.data);
    }
  }

  // VERIFY CREDIT ORDER

  Future<CreditOrderVerifyModel> verifyCreditPlanOrder({
    required String orderId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.verifyRecruiterCreditOrder,
        options: Options(headers: header),
        data: {"orderId": orderId},
      );
      responseStatus = response.statusCode!;
      return CreditOrderVerifyModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CreditOrderVerifyModel.fromJson(err.response!.data);
    }
  }
  
  
}