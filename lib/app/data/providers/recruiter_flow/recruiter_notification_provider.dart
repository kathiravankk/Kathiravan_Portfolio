import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/notification/recruiter_notification_model.dart';

class RecruiterNotificationProvider {
  final Dio? client;

  RecruiterNotificationProvider({@required this.client});

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  /// GET all recruiter notifications
  Future<RecruiterNotificationListModel> fetchNotifications() async {
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      final headers = await AppApiHeader.recruiterHeader();
      final Response response = await client!.get(
        AppApiUrls.getRecruiterNotifications,
        options: Options(headers: headers),
      );
      responseStatus = response.statusCode!;
      return RecruiterNotificationListModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null) {
        return RecruiterNotificationListModel.fromJson(err.response!.data);
      }
      return RecruiterNotificationListModel();
    }
  }
}
