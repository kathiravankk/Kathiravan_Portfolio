import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';

class InternshipProvider {
  final Dio? client;

  InternshipProvider({@required this.client});

  // Response Code

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // GET INTERNSHIP SYLLABUS DATA

  Future<InternshipSyllabusModel> fetchInternshipSyllabus({
    required String studentId,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.header();
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      Response response = await client!.get(
        AppApiUrls.getInternshipData(studentId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode!;
      return InternshipSyllabusModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response!.statusCode!;
      return InternshipSyllabusModel.fromJson(err.response!.data);
    }
  }
}
