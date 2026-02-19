import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppApiHeader {
  static Future<Map<String, String>> header() async {
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('stud_token');
    final token = await LocalStorageService.getToken();

    return {
      if (token != null && token.isNotEmpty)
      "Authorization": "Bearer $token",
      //"Authorization":
          //"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5OTU4Mjg3NzdlOWE0YmE3NGFjNDAzNSIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzcxNDA1OTU5LCJleHAiOjE3NzM5OTc5NTl9.XmkeTZGtivCYQUki3pLzDeBkE6vaoc4xSkDWhhfE7AU",
      "timezone": "Asia/Kolkata",
      "Content-Type": "application/json;charset=utf-8",
    };
  }

  static Future<Map<String, String>> formDataHeader() async {
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('stud_token');
    final token = await LocalStorageService.getToken();
    print("$token.............#############");


    return {
      if (token != null && token.isNotEmpty)
      "Authorization": "Bearer $token",
      //"Authorization":
          //"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5ODMxMjIwMzZlYmI0YWI5Yzc5YzM4ZSIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzcwMTk5NjQzLCJleHAiOjE3NzI3OTE2NDN9.o-rpEgS9vq1yzqMDCXNlEjyQSZqKhmwVqiTvnqPxRVw",
      "timezone": "Asia/Kolkata",
      "Content-Type": "multipart/form-data",
    };
  }
}
