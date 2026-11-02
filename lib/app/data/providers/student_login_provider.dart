import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/account/chat_mcq_question_model.dart';
import 'package:internsharks/app/data/models/account/chat_mcq_result_model.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/account/create_new_resume_model.dart';
import 'package:internsharks/app/data/models/account/student_register_model.dart';

class StudentLoginProvider {
  final Dio? client;

  StudentLoginProvider({required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  Future postLoginOtp({
    required String mobileNumber,
    String countryCode = '+91',
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      final Map<String, dynamic> body = {
        "mobile": mobileNumber,
        "userType": null,
        "studentmobilenocode": countryCode,
      };

      Response response = await client!
          .post(AppApiUrls.sendLoginOtp, data: body)
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return CommonLoginOtpModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 500;
      if (error.response?.data != null &&
          error.response!.data is Map<String, dynamic>) {
        return CommonLoginOtpModel.fromJson(error.response!.data);
      }
      return CommonLoginOtpModel(
        success: false,
        message: error.message ?? "Connection error",
      );
    }
  }

  Future loginVerifyOtp({
    required String mobileNumber,
    required String otpNumber,
    String userType = "student",
    required String fcmToken,
    String countryCode = '+91',
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      final Map<String, dynamic> body = {
        "mobile": mobileNumber,
        "otp": otpNumber,
        "userType": userType,
        "studentmobilenocode": countryCode,
        if (fcmToken.isNotEmpty) "fcmToken": fcmToken,
      };

      Response response = await client!
          .post(
            AppApiUrls.verifyLoginOtp,
            data: body,
          )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      debugPrint(response.data.toString(), wrapWidth: 3000);
      return StudentRegisterModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 500;
      if (error.response?.data != null &&
          error.response!.data is Map<String, dynamic>) {
        return StudentRegisterModel.fromJson(error.response!.data);
      }
      return StudentRegisterModel(
        success: false,
        message: error.message ?? "Connection error",
      );
    }
  }

  // CHAT RESUME CREATION

  Future<CreateNewChatResumeModel> makeNewChatResume({
    required Map<String, dynamic> chatRequestData,
  }) async {
    //Map<String, dynamic> header = await AppApiHeader.studentHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.createNewChatResume,
        //options: Options(headers: header),
        data: chatRequestData,
      );
      debugPrint(response.data.toString(),wrapWidth: 1024);
      debugPrint(response.statusCode.toString());
      responseStatus = response.statusCode!;
      return CreateNewChatResumeModel.fromJson(response.data);
    } catch (error) {
      if (error is DioException) {
        responseStatus = error.response?.statusCode ?? 0;
        return CreateNewChatResumeModel.fromJson(error.response?.data);
      }
      debugPrint('Resume Uncaught Exception :${error.toString()}');
      throw TimeoutException('ED');
    }
  }

  // CHAT MCQ QUESTION

  Future<ChatMcqQuestionModel> fetchChatMcqQuestion({
    required Map<String, dynamic> chatRequestData,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .post(AppApiUrls.chatMcqQuestion, data: chatRequestData)
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return ChatMcqQuestionModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return ChatMcqQuestionModel.fromJson(error.response?.data);
    }
  }

  // CHAT MCQ VERIFY

  Future<ChatMcqResultModel> fetchChatMcqResult({
    required Map<String, dynamic> chatRequestData,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .post(AppApiUrls.chatMcqQuestion, data: chatRequestData)
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return ChatMcqResultModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return ChatMcqResultModel.fromJson(error.response?.data);
    }
  }
}
