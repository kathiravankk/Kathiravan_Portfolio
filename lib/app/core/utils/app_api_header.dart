import 'package:shared_preferences/shared_preferences.dart';

class AppApiHeader {
  static Future<Map<String, String>> header() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('stud_token');

    return {
      //if (token != null && token.isNotEmpty)
        //"Authorization": "Bearer $token",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NzlmNDU0OTA4NjlhMDgwM2MzMGJlNyIsImlhdCI6MTc2OTYwMDA4NCwiZXhwIjoxNzcyMTkyMDg0fQ.OTSXYFh5a3h9I1c6u7HuW3GA2WcL5N_GOpzJqLdiysM",
      "timezone": "Asia/Kolkata",
      "Content-Type": "application/json;charset=utf-8",
    };
  }

  static Future<Map<String, String>> formDataHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('stud_token');

    return {
      //if (token != null && token.isNotEmpty)
      //"Authorization": "Bearer $token",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NzlmNDU0OTA4NjlhMDgwM2MzMGJlNyIsImlhdCI6MTc2OTYwMDA4NCwiZXhwIjoxNzcyMTkyMDg0fQ.OTSXYFh5a3h9I1c6u7HuW3GA2WcL5N_GOpzJqLdiysM",
      "timezone": "Asia/Kolkata",
      "Content-Type": "multipart/form-data",
    };
  }
}
