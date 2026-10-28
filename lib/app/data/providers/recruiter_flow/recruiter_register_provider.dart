import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/company_document_extracted_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_register_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_subscription_plan_model.dart';

class RecruiterRegisterProvider {
  final Dio? client;

  RecruiterRegisterProvider({required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // MOBILE OTP

  Future registerSendMobileOtp({
    required String mobileNumber,
    String countryCode = '+91',
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!
          .post(
            AppApiUrls.registerMobileSendOtp,
            data: {
              "mobile": mobileNumber,
              "countryCode": countryCode,
            },
          )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return SendMobileOtpModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return SendMobileOtpModel.fromJson(error.response!.data);
      } else {
        return SendMobileOtpModel.fromJson(error.response!.data);
      }
    }
  }

  Future registerVerifyMobileOtp({
    required String mobileNumber,
    required String otpNumber,
    String countryCode = '+91',
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!
          .post(
            AppApiUrls.registerMobileVerifyOtp,
            data: {
              "mobile": mobileNumber,
              "otp": otpNumber,
              "countryCode": countryCode,
            },
          )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return VerifyMobileOtpModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return VerifyMobileOtpModel.fromJson(error.response!.data);
      } else {
        return VerifyMobileOtpModel.fromJson(error.response!.data);
      }
    }
  }

  //EMAIL OTP

  Future registerEmailSendOtp({
    required String emailAddress,
    required String userName,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!
          .post(
            AppApiUrls.registerEmailSendOtp,
            data: {
              "email": emailAddress,
              "userType": "recruiter",
              "name": userName,
            },
          )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return SendEmailOtpModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return SendEmailOtpModel.fromJson(error.response!.data);
      } else {
        return SendEmailOtpModel.fromJson(error.response!.data);
      }
    }
  }

  Future registerEmailVerifyOtp({
    required String emailAddress,
    required String otpNumber,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!
          .post(
            AppApiUrls.registerVerifyEmailOtp,
            data: {
              "email": emailAddress,
              "otp": otpNumber,
              "userType": "recruiter",
            },
          )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return VerifyEmailOtpModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return VerifyEmailOtpModel.fromJson(error.response!.data);
      } else {
        return VerifyEmailOtpModel.fromJson(error.response!.data);
      }
    }
  }

  Future checkExistAccount({
    required String emailAddress,
    required String mobileNumber,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .post(
            AppApiUrls.checkExistAccount,
            data: {"email": emailAddress, "mobileNo": mobileNumber},
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

  Future newRecruiterRegister({
    required Map<String, dynamic> registerData,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      final formData = FormData();

      registerData.forEach((k, v) {
        debugPrint('$k : ${v.toString()}');
      });
      registerData.forEach((key, value) {
        if (value is MultipartFile) {
          formData.files.add(MapEntry(key, value));
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });
      Response response = await client!
          .post(
            AppApiUrls.newRecruiterRegister,
            data: formData,
            options: Options(contentType: 'multipart/form-data'),
          )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return RecruiterRegisterModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return RecruiterRegisterModel.fromJson(error.response!.data);
      } else {
        return RecruiterRegisterModel.fromJson(error.response!.data);
      }
    }
  }

  // EXTRACT DOCUMENT DATA
  Future extractCompanyDocumentData({
    String? filePath,
    String? linkUrl,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      FormData formData;
      if (filePath != null && filePath.isNotEmpty) {
        formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          ),
        });
      } else {
        formData = FormData.fromMap({
          "link": linkUrl ?? "",
        });
      }

      Response response = await client!
          .post(
            AppApiUrls.extractDocumentData,
            data: formData,
            options: Options(contentType: 'multipart/form-data'),
          )
          .timeout(const Duration(seconds: 120));
      responseStatus = response.statusCode!;
      return CompanyDocumentExtractedModel.fromJson(response.data);
    } on DioException catch (error) {
      if (error.response != null) {
        responseStatus = error.response!.statusCode ?? 500;
        return CompanyDocumentExtractedModel.fromJson(error.response!.data);
      } else {
        responseStatus = 500;
        return CompanyDocumentExtractedModel(
          success: false,
          message: error.message ?? "Connection error",
        );
      }
    }
  }

  // GET RECRUITER SUBSCRIPTION PLANS
  Future<RecruiterSubscriptionPlanModel> fetchSubscriptionPlans() async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!
          .get(
            AppApiUrls.getRecruiterSubscriptionPlans,
          )
          .timeout(const Duration(seconds: 30));
      responseStatus = response.statusCode!;
      return RecruiterSubscriptionPlanModel.fromJson(response.data);
    } on DioException catch (error) {
      if (error.response != null) {
        responseStatus = error.response!.statusCode ?? 500;
        return RecruiterSubscriptionPlanModel.fromJson(error.response!.data);
      } else {
        responseStatus = 500;
        return RecruiterSubscriptionPlanModel(
          success: false,
          message: error.message ?? "Connection error",
        );
      }
    }
  }

  // UPDATE RECRUITER REGISTER / SUBSCRIPTION
  Future updateRecruiterSubscription({
    required Map<String, dynamic> updateData,
  }) async {
    try {
      final header = await AppApiHeader.recFormDataHeader();
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      final formData = FormData.fromMap(updateData);

      Response response = await client!
          .put(
            AppApiUrls.recruiterUpdateProfile,
            data: formData,
            options: Options(headers: header),
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return response.data;
    } on DioException catch (error) {
      if (error.response != null) {
        responseStatus = error.response!.statusCode ?? 500;
        return error.response!.data;
      } else {
        responseStatus = 500;
        return {
          "success": false,
          "message": error.message ?? "Connection error",
        };
      }
    }
  }
}
