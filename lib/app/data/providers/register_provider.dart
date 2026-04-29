import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/account/common_post_model.dart';
import 'package:internsharks/app/data/models/account/create_resume_model.dart';
import 'package:internsharks/app/data/models/account/credit_data_model.dart';
import 'package:internsharks/app/data/models/account/kyc_update_model.dart';
import 'package:internsharks/app/data/models/account/profile_update_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/resume_extracted_data_model.dart';
import 'package:internsharks/app/data/models/account/student_profile_model.dart';
import 'package:internsharks/app/data/models/account/student_register_model.dart';

class RegisterProvider {
  final Dio? client;

  RegisterProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  Future<ResumeExtractedDataModel> uploadExtractResume({
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

      return ResumeExtractedDataModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      if (error.type == DioExceptionType.connectionTimeout) {
        return ResumeExtractedDataModel.fromJson(error.response!.data);
      } else {
        return ResumeExtractedDataModel.fromJson(error.response!.data);
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

  // STUDENT REGISTER

  Future<StudentRegisterModel> newStudentRegister({
    required Map<String, dynamic> registerData,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      // Convert Map to FormData
      final formData = FormData();

      registerData.forEach((k, v) {
        debugPrint('$k : ${v.toString()}');
      });
      // registerData.forEach((key, value) {
      //   if (key == "studprogramminglang" && value is List) {
      //     for (var skill in value) {
      //       formData.fields.add(
      //         MapEntry("studprogramminglang", skill.toString()),
      //       );
      //     }
      //   } else {
      //     formData.fields.add(
      //       MapEntry(key, value.toString()),
      //     );
      //   }
      // });
      registerData.forEach((key, value) {
        if (key == "studprogramminglang" && value is List) {
          for (var skill in value) {
            formData.fields.add(
              MapEntry("studprogramminglang", skill.toString()),
            );
          }
        } else if (value is MultipartFile) {
          formData.files.add(MapEntry(key, value));
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      Response response = await client!
          .post(
            AppApiUrls.newStudentRegister,
            data: formData,
            options: Options(contentType: 'multipart/form-data'),
            // options: Options(
            //   headers: {
            //     "Content-Type": "application/json",
            //   },
            // ),
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

  // CHAT RESUME CREATION

  Future<CreateResumeModel> postChatResume({
    required Map<String, dynamic> chatMessage,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .post(AppApiUrls.chatResumeCreation, data: chatMessage)
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return CreateResumeModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return CreateResumeModel.fromJson(error.response?.data);
    }
  }

  // TEMPLATE REFRESH CREDIT

  Future<TemplateRefreshModel> templateRefreshCredit() async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .post(AppApiUrls.templateRefresh, options: Options(headers: header))
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return TemplateRefreshModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return TemplateRefreshModel.fromJson(error.response?.data);
    }
  }

  // CHAT RESUME CREDITS CONSUMPTION

  Future<TemplateRefreshModel> chatResumeCreditUpdate() async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .post(AppApiUrls.chatResumeCredit, options: Options(headers: header))
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return TemplateRefreshModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return TemplateRefreshModel.fromJson(error.response?.data);
    }
  }

  // GET CREDIT DATA

  Future<CreditDataModel> fetchCreditData({required String creditId}) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!
          .get(AppApiUrls.getCreditData(creditId), options: Options(headers: header))
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode!;
      return CreditDataModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 0;
      return CreditDataModel.fromJson(error.response?.data);
    }
  }
}
