import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeStorageService {
  static const _resumePathKey = 'resume_file_path';
  static const _resumeNameKey = 'resume_file_name';
  static const _resumeNetworkFileKey = 'network_resume_file';

  /// Save resume locally after successful upload
  static Future<void> saveResume({
    required String filePath,
    required String fileName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_resumePathKey, filePath);
    await prefs.setString(_resumeNameKey, fileName);
  }

  static Future<void> saveNetworkResume({
    required String resumeFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_resumeNetworkFileKey, resumeFile);
  }

  static Future<String?> getNetworkResume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_resumeNetworkFileKey);
  }

  /// Get resume file path
  static Future<String?> getResumePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_resumePathKey);
  }

  /// Get resume file name
  static Future<String?> getResumeName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_resumeNameKey);
  }

  /// Remove resume (optional)
  static Future<void> clearResume() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_resumePathKey);
    await prefs.remove(_resumeNameKey);
  }

  static Future<String> copyResumeToAppDir(String originalPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = originalPath.split('/').last;
    final newPath = '${directory.path}/$fileName';

    final file = File(originalPath);
    await file.copy(newPath);

    return newPath;
  }

  static Future<FormData> buildResumeFormData() async {
    final resumePath = await ResumeStorageService.getResumePath();

    if (resumePath == null) {
      throw Exception("Resume not available");
    }

    return FormData.fromMap({
      "student_resume": await MultipartFile.fromFile(
        resumePath,
        filename: resumePath.split('/').last,
      ),
    });
  }
}
