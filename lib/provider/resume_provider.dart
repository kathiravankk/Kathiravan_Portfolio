import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:internsharks/core/const_file/api_constants.dart';
import 'package:internsharks/models/resume_analyze_model.dart';

import '../models/resume_response.dart';

class ResumeProvider {
  final Dio? client;

  ResumeProvider({required this.client});

  int? _responseStatus;
  int get responseStatus => _responseStatus!;
  set responseStatus(int value) => _responseStatus = value;

  String? _responseMessage;
  String get responseMessage => _responseMessage!;
  set responseMessage(String value) => _responseMessage = value;

  /// Upload Resume PDF API
  Future<ResumeAnalyzeModel> uploadResumePdf(String filePath) async {
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );

      FormData formData = FormData.fromMap({
        "resume": await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      Response response = await client!.post(
        ApiConstants.analyzeResume,
        data: formData, // ✅ SAME AS POSTMAN
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      return ResumeAnalyzeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Resume upload failed");
    }
  }


  Future<ResumeAnalyzeModel> registerStudent(
      Map<String, dynamic> registerData) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!.post(
        ApiConstants.registerStudent,
        data: FormData.fromMap(registerData),
      );

      responseStatus = response.statusCode!;
      responseMessage = response.statusMessage!;

      return ResumeAnalyzeModel.fromJson(response.data);

    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 500;
      responseMessage =
          error.response?.statusMessage ?? "Registration failed";

      // ✅ FIX HERE
      return ResumeAnalyzeModel.fromJson(
        error.response?.data ?? {},
      );
    }
  }

}
