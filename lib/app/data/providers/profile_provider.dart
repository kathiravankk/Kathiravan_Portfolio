import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/home/banner_generation_model.dart';
import 'package:internsharks/app/data/models/home/filter_option_model.dart';
import 'package:internsharks/app/data/models/home/profile_information_model.dart';
import 'package:internsharks/app/data/models/home/remove_watermark_model.dart';
import 'package:internsharks/app/data/models/home/saved_internship_model.dart';

import '../models/account/common_post_model.dart';

class ProfileProvider {
  final Dio? client;

  ProfileProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // GET PROFILE DATA

  Future<ProfileDataModel> fetchProfileData({required String studentId}) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.getProfileData,
        options: Options(headers: header),
        data: {"studentId": studentId},
      );
      responseStatus = response.statusCode!;
      return ProfileDataModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return ProfileDataModel.fromJson(err.response!.data);
    }
  }

  // SEND MOBILE UPDATE OTP

  Future<CommonPostModel> postUpdateMobileOtp({
    required String mobileNo,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.sendUpdateMobileOtp,
        options: Options(headers: header),
        data: {"mobile": mobileNo},
      );
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CommonPostModel.fromJson(err.response!.data);
    }
  }

  // VERIFY MOBILE UPDATE OTP

  Future<CommonPostModel> verifyUpdateMobileOtp({
    required String mobileNo,
    required String otpNo,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.verifyUpdateMobileOtp,
        options: Options(headers: header),
        data: {"mobile": mobileNo, "otp": otpNo},
      );
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CommonPostModel.fromJson(err.response!.data);
    }
  }

  // SEND MOBILE UPDATE OTP

  Future<CommonPostModel> postUpdateEmailOtp({required String email}) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.sendUpdateEmailOtp,
        options: Options(headers: header),
        data: {"email": email, "userType": "student"},
      );
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CommonPostModel.fromJson(err.response!.data);
    }
  }

  // VERIFY MOBILE UPDATE OTP

  Future<CommonPostModel> verifyUpdateEmailOtp({
    required String email,
    required String otpNo,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.verifyUpdateEmailOtp,
        options: Options(headers: header),
        data: {"email": email, "userType": "student", "otp": otpNo},
      );
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CommonPostModel.fromJson(err.response!.data);
    }
  }

  // GET SAVED JOBS DATA

  Future<SavedInternshipModel> fetchSavedJobsData() async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getSavedJobs,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return SavedInternshipModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return SavedInternshipModel.fromJson(err.response!.data);
    }
  }

  // ADD SAVED JOBS DATA

  Future<SavedNewInternshipModel> putSavedJobsData({
    required String jobId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.addToSavedJobs,
        options: Options(headers: header),
        data: {"jobId": jobId},
      );
      responseStatus = response.statusCode!;
      return SavedNewInternshipModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return SavedNewInternshipModel.fromJson(err.response!.data);
    }
  }

  // ADD SAVED JOBS DATA

  Future<SavedNewInternshipModel> deleteSavedJobsData({
    required String jobId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.removeSavedJobs,
        options: Options(headers: header),
        data: {"jobId": jobId},
      );
      responseStatus = response.statusCode!;
      return SavedNewInternshipModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return SavedNewInternshipModel.fromJson(err.response!.data);
    }
  }

  // GET FILTER OPTIONS

  Future<FilterOptionModel> fetchFilterOption() async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getFilterOption,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return FilterOptionModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return FilterOptionModel.fromJson(err.response!.data);
    }
  }

  // GENERATE AI BANNER

  Future<BannerGenerationModel> resDpGeneration({required Map<String, dynamic> bannerData}) async {
    Map<String, dynamic> header = await AppApiHeader.formDataHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      final formData = FormData.fromMap(bannerData);
      Response response = await client!.post(
        AppApiUrls.generateResDp,
        options: Options(headers: header),
        data: formData
      );
      responseStatus = response.statusCode!;
      return BannerGenerationModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return BannerGenerationModel.fromJson(err.response!.data);
    }
  }

  // REMOVE WATER MARK

  Future<RemoveWatermarkModel> deleteWaterMark({required String imageUrl}) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
          AppApiUrls.removeWaterMark,
          options: Options(headers: header),
          data: {
            "image_url": imageUrl
          }
      );
      responseStatus = response.statusCode!;
      return RemoveWatermarkModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return RemoveWatermarkModel.fromJson(err.response!.data);
    }
  }
}
