import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/account/common_post_model.dart';
import 'package:internsharks/app/data/models/account/kyc_update_model.dart';
import 'package:internsharks/app/data/models/account/profile_update_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/resume_extract_model.dart';
import 'package:internsharks/app/data/models/account/student_profile_model.dart';
import 'package:internsharks/app/data/models/account/student_register_model.dart';

class RegisterProvider {
  final Dio? client;

  RegisterProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  Future<ResumeExtractModel> uploadExtractResume({
    required String filePath,
    required Function(int sent, int total) onProgress,
  }) async {
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

      Response response = await client!
          .post(
            AppApiUrls.extractResumeData,
            data: formData,
            options: Options(headers: {"Content-Type": "multipart/form-data"}),
            onSendProgress: onProgress,
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;

      return ResumeExtractModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return ResumeExtractModel.fromJson(error.response!.data);
      } else {
        return ResumeExtractModel.fromJson(error.response!.data);
      }
    }
  }

  // MOBILE OTP

  Future registerSendOtp({required String mobileNumber}) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!
          .post(AppApiUrls.registerSendOtp, data: {"mobile": mobileNumber})
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return CommonPostModel.fromJson(error.response!.data);
      } else {
        return CommonPostModel.fromJson(error.response!.data);
      }
    }
  }

  Future registerVerifyOtp({
    required String mobileNumber,
    required String otpNumber,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!
          .post(
            AppApiUrls.registerVerifyOtp,
            data: {"mobile": mobileNumber, "otp": otpNumber},
          )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return CommonPostModel.fromJson(error.response!.data);
      } else {
        return CommonPostModel.fromJson(error.response!.data);
      }
    }
  }

  //EMAIL OTP

  Future registerSendEmailOtp({required String emailAddress}) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      Response response = await client!
          .post(
            AppApiUrls.registerSendEmailOtp,
            data: {"email": emailAddress, "userType": "student"},
          )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return CommonPostModel.fromJson(error.response!.data);
      } else {
        return CommonPostModel.fromJson(error.response!.data);
      }
    }
  }

  Future registerVerifyEmailOtp({
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
              "userType": "student",
            },
          )
          .timeout(const Duration(seconds: 60));
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return CommonPostModel.fromJson(error.response!.data);
      } else {
        return CommonPostModel.fromJson(error.response!.data);
      }
    }
  }

  // STUDENT REGISTER

  Future<StudentRegisterModel> newStudentRegister({
    required Map<String, dynamic> registerData,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      // Convert Map to FormData
      final formData = FormData.fromMap(registerData);

      Response response = await client!
          .post(
            AppApiUrls.newStudentRegister,
            data: formData,
            options: Options(contentType: 'multipart/form-data'),
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return StudentRegisterModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return StudentRegisterModel.fromJson(error.response?.data);
    }
  }

  // STUDENT PROFILE DATA

  Future fetchStudentData({required String studentId}) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.getStudentProfile,
        data: {"studentId": studentId},
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      if (responseStatus == 200 || responseStatus == 201) {
        return StudentProfileModel.fromJson(response.data);
      }
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return StudentProfileModel.fromJson(err.response!.data);
    }
  }

  // RESUME SCORE ANALYSIS

  Future<ResumeAnalysisModel> analyzeResumeScore({
    required String resumeUrl,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();

    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );

      final formData = FormData.fromMap({"resume": resumeUrl});

      Response response = await client!
          .post(
            AppApiUrls.analyzeResumeScore,
            data: formData,
            options: Options(
              headers: header,
              contentType: 'multipart/form-data',
            ),
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return ResumeAnalysisModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return ResumeAnalysisModel.fromJson(error.response?.data);
    }
  }

  // UPDATE RESUME DATA

  Future postUpdateResume({
    required ExtractedResumeDataModel updateData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.updateResumeData,
        data: updateData.toJson(),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      if (responseStatus == 200 || responseStatus == 201) {
        return ExtractedResumeDataModel.fromJson(response.data);
      }
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return ExtractedResumeDataModel.fromJson(err.response!.data);
    }
  }

  // STUDENT REGISTER

  Future<ProfileUpdateModel> putUpdateProfile({
    required Map<String, dynamic> updateData,
  }) async {
    try {
      Map<String, dynamic> header = await AppApiHeader.formDataHeader();

      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      // Convert Map to FormData
      final formData = FormData.fromMap(updateData);

      Response response = await client!
          .put(
            AppApiUrls.updateStudentRegisterData,
            data: formData,
            options: Options(headers: header),
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return ProfileUpdateModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return ProfileUpdateModel.fromJson(error.response?.data);
    }
  }

  // RESUME UPDATE

  Future<ProfileUpdateModel> putUpdateResume({
    required ExtractedResumeDataModel? updateData,
  }) async {
    try {
      Map<String, dynamic> header = await AppApiHeader.formDataHeader();

      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      // Convert Map to FormData
      final formData = FormData.fromMap(updateData!.toFormDataJson());
      for (var f in formData.fields) {
        debugPrint('${f.key} => ${f.value}');
      }
      Response response = await client!
          .put(
            AppApiUrls.updateStudentRegisterData,
            data: formData,
            options: Options(headers: header),
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return ProfileUpdateModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return ProfileUpdateModel.fromJson(error.response?.data);
    }
  }

  // KYC VERIFICATION

  Future<KycUpdateModel> kycVerification({
    required Map<String, dynamic> kycData,
  }) async {
    try {
      Map<String, dynamic> header = await AppApiHeader.formDataHeader();

      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      // Convert Map to FormData
      final formData = FormData.fromMap(kycData);

      Response response = await client!
          .post(
            AppApiUrls.verifyKycData,
            data: formData,
            options: Options(headers: header),
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return KycUpdateModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return KycUpdateModel.fromJson(error.response?.data);
    }
  }
}
