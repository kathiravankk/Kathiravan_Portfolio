import 'dart:convert';
import 'package:internsharks/app/data/models/account/student_register_model.dart';
import 'package:internsharks/app/data/models/account/update_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const tokenKey = 'stud_token';
  static const _studentKey = 'student_data';
  static const _studentIdKey = 'student_id';
  static const studentNameKey = 'student_name';
  static const fcmTokenKey = 'fcm_token';
  static const _isVerifiedKey = 'student_verified';
  static const studentCreditId = 'student_creditId';
  static const waterMarkKey = 'isWaterMarkRemoved';

  /// Save student data after registration
  static Future<void> saveStudent({
    required String token,
    required RegisterData student,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    await prefs.setString(_studentKey, jsonEncode(student.toJson()));
    await prefs.setString(_studentIdKey, student.id ?? '');
    await prefs.setBool(_isVerifiedKey, student.isVerified ?? false);
    await prefs.setString(studentNameKey, student.studentName ?? "");
  }

  static Future<void> saveUpdateStudent({
    required UpdateProfileDataModel student,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentKey, jsonEncode(student.toJson()));
    await prefs.setString(_studentIdKey, student.id ?? '');
    await prefs.setBool(_isVerifiedKey, student.isVerified ?? false);
    await prefs.setString(studentNameKey, student.studentName ?? "");
  }

  /// Save student name
  static Future<void> saveName({String? studentName}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentNameKey, studentName ?? "");
  }

  /// Save FCM token
  static Future<void> saveFcmToken({String? fcmToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(fcmTokenKey, fcmToken ?? "");
  }

  ///Get FCM token
  static Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(fcmTokenKey);
  }

  /// Save student creditId
  static Future<void> saveCreditId({String? creditId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentCreditId, creditId ?? "");
  }

  ///Get student credit id
  static Future<String?> getStudentCreditId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(studentCreditId);
  }

  /// Save verified value
  static Future<void> saveVerifiedValue({bool? isVerified}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isVerifiedKey, isVerified ?? false);
  }

  /// Get verified value
  static Future<bool?> getVerifiedValue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isVerifiedKey);
  }

  /// Save watermark value
  static Future<void> saveWatermarkValue({bool? waterMarkValue}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(waterMarkKey, waterMarkValue ?? false);
  }

  /// Get watermark value
  static Future<bool?> getWatermarkValue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(waterMarkKey);
  }

  /// Save student token
  static Future<void> saveStudentToken({String? studentToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, studentToken ?? "");
  }

  /// Save student name
  static Future<void> saveStudentId({String? studentId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentIdKey, studentId ?? "");
  }

  /// Get token anywhere in app
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  ///Get student id
  static Future<String?> getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_studentIdKey);
  }

  ///Get student name
  static Future<String?> getStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(studentNameKey);
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
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
