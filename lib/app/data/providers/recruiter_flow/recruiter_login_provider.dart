import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/coordinator_data_list_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_login_model.dart';

class RecruiterLoginProvider {
  final Dio? client;

  RecruiterLoginProvider({required this.client});

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
    String userType = "recruiter",
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
      return RecruiterLoginModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 500;
      if (error.response?.data != null &&
          error.response!.data is Map<String, dynamic>) {
        return RecruiterLoginModel.fromJson(error.response!.data);
      }
      return RecruiterLoginModel(
        success: false,
        message: error.message ?? "Connection error",
      );
    }
  }

  // DELETE STUDENT ACCOUNT

  Future<CommonLoginOtpModel> removeRecruiterAccount() async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.delete(
        AppApiUrls.recruiterDeleteAccount,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return CommonLoginOtpModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CommonLoginOtpModel.fromJson(err.response!.data);
    }
  }

  // GET COORDINATOR LIST

  Future<CoordinatorDataListModel> fetchCoordinatorList() async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getAllCoordinators,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return CoordinatorDataListModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CoordinatorDataListModel.fromJson(err.response!.data);
    }
  }


}