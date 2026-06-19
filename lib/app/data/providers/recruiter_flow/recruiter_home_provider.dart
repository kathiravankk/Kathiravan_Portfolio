import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/student_list_model.dart';

class RecruiterHomeProvider {
  final Dio? client;

  RecruiterHomeProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // GET PROFILE DATA

  Future<RecruiterProfileModel> fetchRecruiterProfile({required String recruiterId}) async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.post(
        AppApiUrls.getRecruiterProfile,
        options: Options(headers: header),
        data: {"id": recruiterId},
      );
      responseStatus = response.statusCode!;
      return RecruiterProfileModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return RecruiterProfileModel.fromJson(err.response!.data);
    }
  }

  // GET STUDENT LIST DATA

  Future<StudentListModel> fetchStudentListData() async {
    Map<String, dynamic> header = await AppApiHeader.recruiterHeader();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getAllStudentsList,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return StudentListModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return StudentListModel.fromJson(err.response!.data);
    }
  }
  
  
}