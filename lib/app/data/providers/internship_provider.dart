import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/internship/internship_status_model.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';
import 'package:internsharks/app/data/models/internship/mcq_question_model.dart';
import 'package:internsharks/app/data/models/internship/syllabus_data_model.dart';
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

  Future<SyllabusDataModel> fetchSyllabusData({required String jobId}) async {
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
      return SyllabusDataModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return SyllabusDataModel.fromJson(err.response!.data);
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
        AppApiUrls.updateWeeklyStatus,
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
    required List<WeeklyData>? weekData,
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
}
