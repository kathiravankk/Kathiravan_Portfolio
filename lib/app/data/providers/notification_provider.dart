import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/notification/notification_model.dart';

class NotificationProvider {
  final Dio? client;

  NotificationProvider({@required this.client});

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  /// GET all student notifications
  Future<NotificationListModel> fetchNotifications() async {
    try {
      client!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      final headers = await AppApiHeader.studentHeader();
      final Response response = await client!.get(
        AppApiUrls.getStudentNotifications,
        options: Options(headers: headers),
      );
      responseStatus = response.statusCode!;
      return NotificationListModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null) {
        return NotificationListModel.fromJson(err.response!.data);
      }
      return NotificationListModel();
    }
  }
}
