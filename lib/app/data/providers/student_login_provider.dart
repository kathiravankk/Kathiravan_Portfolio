import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/account/student_register_model.dart';

class StudentLoginProvider {
  final Dio? client;

  StudentLoginProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  Future postLoginOtp({required String mobileNumber}) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!
          .post(AppApiUrls.sendLoginOtp, data: {"mobile": mobileNumber})
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

  Future loginVerifyOtp({
    required String mobileNumber,
    required String otpNumber,
    required String userType,
    required String fcmToken,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!
          .post(
            AppApiUrls.verifyLoginOtp,
            data: {
              "mobile": mobileNumber,
              "otp": otpNumber,
              "userType": userType,
              "fcmToken": fcmToken,
            },
          )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return StudentRegisterModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return StudentRegisterModel.fromJson(error.response!.data);
      } else {
        return StudentRegisterModel.fromJson(error.response!.data);
      }
    }
  }
}
