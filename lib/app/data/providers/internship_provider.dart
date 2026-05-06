import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/internship/add_review_data_model.dart';
import 'package:internsharks/app/data/models/internship/all_cerifications_model.dart';
import 'package:internsharks/app/data/models/internship/intern_syllabus_response_model.dart';
import 'package:internsharks/app/data/models/internship/internship_status_model.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';
import 'package:internsharks/app/data/models/internship/mcq_question_model.dart';
import 'package:internsharks/app/data/models/internship/payment_create_model.dart';
import 'package:internsharks/app/data/models/internship/payment_status_model.dart';
import 'package:internsharks/app/data/models/internship/save_test_result_model.dart';
import 'package:internsharks/app/data/models/internship/test_result_model.dart';
import 'package:internsharks/app/data/models/internship/weekly_update_model.dart';

class InternshipProvider {
  final Dio? client;

  InternshipProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // GET INTERNSHIP SYLLABUS DATA

  Future<InternshipSyllabusModel> fetchInternshipSyllabus({
    required String studentId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getInternshipData(studentId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return InternshipSyllabusModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return InternshipSyllabusModel.fromJson(err.response!.data);
    }
  }

  // GET INTERNSHIP SYLLABUS DATA

  Future<InternSyllabusResponseModel> fetchSyllabusData({required String jobId}) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getSyllabusData(jobId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return InternSyllabusResponseModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return InternSyllabusResponseModel.fromJson(err.response!.data);
    }
  }

  // GET INTERNSHIP STATUS

  Future<InternshipStatusModel> fetchInternStatus({
    required String jobId,
    required String studentId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.getInternshipStatus,
        options: Options(headers: header),
        data: {"studentId": studentId, "jobId": jobId},
      );
      responseStatus = response.statusCode!;
      return InternshipStatusModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return InternshipStatusModel.fromJson(err.response!.data);
    }
  }

  // UPDATE WEEKLY STATUS

  Future<WeeklyUpdateModel> updateWeeklyInternStatus({
    required Map<String, dynamic> weelyData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.put(
        AppApiUrls.updateDailyStatus,
        options: Options(headers: header),
        data: weelyData,
      );
      responseStatus = response.statusCode!;
      return WeeklyUpdateModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return WeeklyUpdateModel.fromJson(err.response!.data);
    }
  }

  // GET MCQ QUESTIONS

  Future<McqQuestionModel> fetchMcqQuestions({
    required List<dynamic>? weekData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.generateMcqQuestions,
        options: Options(headers: header),
        data: {"data": weekData},
      );
      responseStatus = response.statusCode!;
      return McqQuestionModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return McqQuestionModel.fromJson(err.response!.data);
    }
  }

  // VALIDATE MCQ ANSWERS

  Future<TestResultModel> validateMcqAnswer({
    required Map<String, dynamic>? answerData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.validateMcqAnswer,
        options: Options(headers: header),
        data: answerData,
      );
      responseStatus = response.statusCode!;
      return TestResultModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return TestResultModel.fromJson(err.response!.data);
    }
  }

  // VALIDATE MCQ ANSWERS

  Future<AddReviewDataModel> giveFeedBackReview({
    required Map<String, dynamic>? feedBackData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.addFeedbackReview,
        options: Options(headers: header),
        data: feedBackData,
      );
      responseStatus = response.statusCode!;
      return AddReviewDataModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return AddReviewDataModel.fromJson(err.response!.data);
    }
  }

  // VALIDATE MCQ ANSWERS

  Future<SaveTestResultModel> saveTestResult({
    required Map<String, dynamic>? testData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.saveTestResult,
        options: Options(headers: header),
        data: testData,
      );
      responseStatus = response.statusCode!;
      return SaveTestResultModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return SaveTestResultModel.fromJson(err.response!.data);
    }
  }

  // CHECK PAYMENT STATUS

  Future<PaymentStatusModel> checkPaymentStatus({
    required Map<String, dynamic>? jobData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.paymentCheck,
        options: Options(headers: header),
        data: jobData,
      );
      responseStatus = response.statusCode!;
      return PaymentStatusModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return PaymentStatusModel.fromJson(err.response!.data);
    }
  }

  // CREATE PAYMENT ORDER

  Future<PaymentCreateModel> createPaymentOrder({
    required Map<String, dynamic>? jobData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.createPayment,
        options: Options(headers: header),
        data: jobData,
      );
      responseStatus = response.statusCode!;
      return PaymentCreateModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return PaymentCreateModel.fromJson(err.response!.data);
    }
  }


  // VERIFY PAYMENT ORDER

  Future<PaymentCreateModel> verifyPaymentOrder({
    required Map<String, dynamic>? jobData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.verifyPayment,
        options: Options(headers: header),
        data: jobData,
      );
      responseStatus = response.statusCode!;
      return PaymentCreateModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return PaymentCreateModel.fromJson(err.response!.data);
    }
  }

  // GET ALL CERTIFICATES

  Future<AllCertificationsModel> fetchAllCertificates() async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getAllCertificates,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return AllCertificationsModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return AllCertificationsModel.fromJson(err.response!.data);
    }
  }
}
