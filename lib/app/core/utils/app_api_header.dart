import 'package:internsharks/app/data/repositories/local_storage_service.dart';

class AppApiHeader {
  static Future<Map<String, String>> studentHeader() async {
    final token = await LocalStorageService.getToken();

    return {
      if (token != null && token.isNotEmpty)
      "Authorization": "Bearer $token",
      "timezone": "Asia/Kolkata",
      "Content-Type": "application/json;charset=utf-8",
    };
  }

  static Future<Map<String, String>> recruiterHeader() async {
    final token = await LocalStorageService.getRecruiterToken();

    return {
      if (token != null && token.isNotEmpty)
        "Authorization": "Bearer $token",
      "timezone": "Asia/Kolkata",
      "Content-Type": "application/json;charset=utf-8",
    };
  }

  static Future<Map<String, String>> recFormDataHeader() async {
    final token = await LocalStorageService.getRecruiterToken();
    return {
      if (token != null && token.isNotEmpty)
        "Authorization": "Bearer $token",
      "timezone": "Asia/Kolkata",
      "Content-Type": "multipart/form-data",
    };
  }

  static Future<Map<String, String>> formDataHeader() async {
    final token = await LocalStorageService.getToken();
    return {
      if (token != null && token.isNotEmpty)
      "Authorization": "Bearer $token",
      "timezone": "Asia/Kolkata",
      "Content-Type": "multipart/form-data",
    };
  }
}
