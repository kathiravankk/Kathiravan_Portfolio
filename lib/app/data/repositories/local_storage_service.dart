import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _tokenKey = 'stud_token';
  static const _studentKey = 'student_data';
  static const _studentIdKey = 'student_id';
  static const studentNameKey = 'student_name';
  static const _isVerifiedKey = 'student_verified';

  /// Save student data after registration
  static Future<void> saveStudent({
    required String token,
    required Map<String, dynamic> student,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
    await prefs.setString(_studentKey, jsonEncode(student));
    await prefs.setString(_studentIdKey, student['id'] ?? '');
    await prefs.setBool(_isVerifiedKey, student['isVerified'] ?? false);
  }

  /// Get token anywhere in app
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get full student data
  static Future<Map<String, dynamic>?> getStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_studentKey);
    if (data == null) return null;
    return jsonDecode(data);
  }

  /// Check verification
  static Future<bool> isVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isVerifiedKey) ?? false;
  }

  /// Clear on logout
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
