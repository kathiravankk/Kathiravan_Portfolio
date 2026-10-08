import 'package:dio/dio.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';
import 'package:internsharks/app/data/models/webinar/webinar_model.dart';

class WebinarProvider {
  final Dio? client;

  WebinarProvider({required this.client});

  int? _responseStatus;

  int get responseStatus => _responseStatus ?? 0;

  set responseStatus(int value) => _responseStatus = value;

  Future<WebinarModel> fetchWebinars({
    String? status,
    String? webinarType,
    int? page,
    int? limit,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.studentHeader();
    try {
      if (!client!.interceptors.any((i) => i is LogInterceptor)) {
        client!.interceptors.add(
          LogInterceptor(requestBody: true, responseBody: true),
        );
      }

      final Map<String, dynamic> queryParams = {};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (webinarType != null && webinarType.isNotEmpty) {
        queryParams['webinarType'] = webinarType;
      }
      if (page != null) {
        queryParams['page'] = page;
      }
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      Response response = await client!.get(
        AppApiUrls.getWebinars,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode ?? 200;
      return WebinarModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null && err.response!.data is Map<String, dynamic>) {
        return WebinarModel.fromJson(err.response!.data);
      }
      return WebinarModel(
        success: false,
        message: err.message ?? "Failed to fetch webinars",
      );
    } catch (e) {
      responseStatus = 500;
      return WebinarModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<WebinarDetailModel> getWebinarById(String webinarId) async {
    Map<String, dynamic> header = await AppApiHeader.studentHeader();
    try {
      if (!client!.interceptors.any((i) => i is LogInterceptor)) {
        client!.interceptors.add(
          LogInterceptor(requestBody: true, responseBody: true),
        );
      }

      Response response = await client!.get(
        AppApiUrls.getWebinarById(webinarId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode ?? 200;
      return WebinarDetailModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null && err.response!.data is Map<String, dynamic>) {
        return WebinarDetailModel.fromJson(err.response!.data);
      }
      return WebinarDetailModel(
        success: false,
        message: err.message ?? "Failed to fetch webinar details",
      );
    } catch (e) {
      responseStatus = 500;
      return WebinarDetailModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<List<String>> fetchColleges() async {
    try {
      Response response = await client!.get(AppApiUrls.getColleges);
      responseStatus = response.statusCode ?? 200;
      if (response.data != null && response.data['colleges'] is List) {
        return (response.data['colleges'] as List)
            .map((e) => e.toString())
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> registerWebinar(Map<String, dynamic> data) async {
    Map<String, dynamic> header = await AppApiHeader.studentHeader();
    try {
      Response response = await client!.post(
        AppApiUrls.registerWebinar,
        data: data,
        options: Options(headers: header),
      );
      responseStatus = response.statusCode ?? 200;
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {'success': true, 'message': 'Registered successfully'};
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null && err.response!.data is Map<String, dynamic>) {
        return err.response!.data;
      }
      return {'success': false, 'message': err.message ?? "Registration failed"};
    } catch (e) {
      responseStatus = 500;
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> sendWebinarOtp({
    required String webinarId,
    required String mobile,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.studentHeader();
    try {
      Response response = await client!.post(
        AppApiUrls.sendWebinarOtp,
        data: {
          "webinarId": webinarId,
          "mobile": mobile,
        },
        options: Options(headers: header),
      );
      responseStatus = response.statusCode ?? 200;
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {'success': true, 'message': 'OTP sent successfully'};
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null && err.response!.data is Map<String, dynamic>) {
        return err.response!.data;
      }
      return {'success': false, 'message': err.message ?? "Failed to send OTP"};
    } catch (e) {
      responseStatus = 500;
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyWebinarOtp({
    required String webinarId,
    required String otp,
  }) async {
    Map<String, dynamic> header = await AppApiHeader.studentHeader();
    try {
      Response response = await client!.post(
        AppApiUrls.verifyWebinarOtp,
        data: {
          "webinarId": webinarId,
          "otp": otp,
        },
        options: Options(headers: header),
      );
      responseStatus = response.statusCode ?? 200;
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {'success': true, 'message': 'OTP verified successfully'};
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null && err.response!.data is Map<String, dynamic>) {
        return err.response!.data;
      }
      return {'success': false, 'message': err.message ?? "Failed to verify OTP"};
    } catch (e) {
      responseStatus = 500;
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getWebinarMeetingLink(String webinarId) async {
    Map<String, dynamic> header = await AppApiHeader.studentHeader();
    try {
      Response response = await client!.get(
        AppApiUrls.getWebinarMeetingLink(webinarId),
        options: Options(headers: header),
      );
      responseStatus = response.statusCode ?? 200;
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {'success': true, 'message': 'Link fetched successfully'};
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null && err.response!.data is Map<String, dynamic>) {
        return err.response!.data;
      }
      return {'success': false, 'message': err.message ?? "Failed to get meeting link"};
    } catch (e) {
      responseStatus = 500;
      return {'success': false, 'message': e.toString()};
    }
  }
}

