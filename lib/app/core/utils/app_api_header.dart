import 'package:shared_preferences/shared_preferences.dart';

class AppApiHeader {
  static Future<Map<String, String>> header() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('stud_token');

    return {
      //if (token != null && token.isNotEmpty)
      //"Authorization": "Bearer $token",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5N2IyZmNlMDFkYjFiMTFmMzQyM2JhMyIsImlhdCI6MTc2OTY4MDg0NiwiZXhwIjoxNzcyMjcyODQ2fQ.ABB3sCdN06eyIzvrR7diy7iBIlvCQnFVHB6DB9myaV4",
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
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5N2IyZmNlMDFkYjFiMTFmMzQyM2JhMyIsImlhdCI6MTc2OTY4MDg0NiwiZXhwIjoxNzcyMjcyODQ2fQ.ABB3sCdN06eyIzvrR7diy7iBIlvCQnFVHB6DB9myaV4",
      "timezone": "Asia/Kolkata",
      "Content-Type": "multipart/form-data",
    };
  }
}
