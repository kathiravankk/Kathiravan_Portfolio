import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/home/all_internship_model.dart';
import 'package:internsharks/app/data/models/home/applied_internship_model.dart';
import 'package:internsharks/app/data/models/home/category_list_model.dart';
import 'package:internsharks/app/data/models/home/category_wise_internship_model.dart';
import 'package:internsharks/app/data/models/home/internship_apply_model.dart';
import 'package:internsharks/app/data/models/home/internship_detail_model.dart';
import 'package:internsharks/app/data/models/home/recommand_internship_model.dart';
import 'package:internsharks/app/data/models/home/review_data_model.dart';
import 'package:internsharks/app/data/models/home/similar_internship_model.dart';
import 'package:internsharks/app/data/models/home/update_chat_model.dart';

class DashboardProvider {
  final Dio? client;

  DashboardProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // GET CATEGORY LIST

  Future<CategoryListModel> fetchCategoryList() async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getCategoryList,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return CategoryListModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CategoryListModel.fromJson(err.response!.data);
    }
  }

  // GET CATEGORY WISE INTERNSHIP LIST

  Future<CategoryWiseInternshipModel> fetchCategoryInternship({
    required String categoryId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.getCategoryInternship(categoryId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return CategoryWiseInternshipModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return CategoryWiseInternshipModel.fromJson(err.response!.data);
    }
  }

  // GET INTERNSHIP DETAILS DATA

  Future<InternshipDetailModel> fetchInternshipViewData({
    required String internshipId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getInternshipViewData(internshipId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return InternshipDetailModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return InternshipDetailModel.fromJson(err.response!.data);
    }
  }

  // APPLY INTERNSHIP

  Future<InternshipApplyModel> postApplyInternship({
    required String internshipId,
    required String studentId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.applyInternship,
        options: Options(headers: header),
        data: {"jobId": internshipId, "studentId": studentId},
      );
      responseStatus = response.statusCode!;
      return InternshipApplyModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return InternshipApplyModel.fromJson(err.response!.data);
    }
  }

  // GET INTERNSHIP DETAILS DATA

  Future<RecommandInternshipModel> fetchRecommandInternship() async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getRecommandInternship,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return RecommandInternshipModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return RecommandInternshipModel.fromJson(err.response!.data);
    }
  }

  // GET APPLIED INTERNSHIP

  Future<AppliedInternshipModel> fetchAppliedInternship({
    required String studentId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getAppliedInternship(studentId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return AppliedInternshipModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return AppliedInternshipModel.fromJson(err.response!.data);
    }
  }

  // GET SIMILAR INTERNSHIP

  Future<SimilarInternshipModel> fetchSimilarInternship({
    required List<String> skillList,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.getSimilarInternship,
        options: Options(headers: header),
        data: {"skills": skillList},
      );
      responseStatus = response.statusCode!;
      return SimilarInternshipModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return SimilarInternshipModel.fromJson(err.response!.data);
    }
  }

  // GET REVIEW DATA

  Future<ReviewDataModel> fetchReviewData({required String jobId}) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getReviewData(jobId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return ReviewDataModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return ReviewDataModel.fromJson(err.response!.data);
    }
  }

  // GET UPDATE RESUME DATA

  Future<UpdateChatModel> fetchUpdateResumeData({
    required Map<String, dynamic> resumeData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        data: resumeData,
        AppApiUrls.getUpdateChatResumeData,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return UpdateChatModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return UpdateChatModel.fromJson(err.response!.data);
    }
  }

  // UPDATE CHAT RESUME DATA

  Future<UpdateChatResumeModel> updateChatResumeData({
    required Map<String, dynamic> resumeData,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        data: resumeData,
        AppApiUrls.updateChatResume,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return UpdateChatResumeModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return UpdateChatResumeModel.fromJson(err.response!.data);
    }
  }

  // GET ALL INTERNSHIP DATA

  Future<AllInternshipModel> fetchAllInternship({
    required String companyState,
    required String companyCity,
    required String qualification,
    required String duration,
    required String stipend,
    required String internshipMode,
    required int page,
    required int limit,
  required String roleType,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getAllInternship(
          companyState,
          companyCity,
          qualification,
          duration,
          stipend,
          internshipMode,
          roleType,
          page,
          limit
        ),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return AllInternshipModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return AllInternshipModel.fromJson(err.response!.data);
    }
  }
}
