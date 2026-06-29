import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/recruiter_flow/applicants_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';

class InternshipPostProvider {
  final Dio? client;

  InternshipPostProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // GET PROFILE DATA

  Future<InternshipPostModel> fetchPostedInternships(
      {required String recruiterId}) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getPostedInternships(recruiterId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return InternshipPostModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return InternshipPostModel.fromJson(err.response!.data);
    }
  }

  // GET APPLICANTS
  Future<List<ApplicantsModel>> fetchApplicants({required String jobId}) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getJobApplicants(jobId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      
      if (response.data != null && response.data['applications'] != null) {
        return (response.data['applications'] as List)
            .map((e) => ApplicantsModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      rethrow;
    }
  }
}