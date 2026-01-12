import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internsharks/core/const_file/api_constants.dart';
import '../models/resume_response.dart'; // Model import matum podhum

class ResumeApiService {
  static Future<ResumeResponse?> analyzeResume(String filePath) async {
    try {
      final url = Uri.parse(ApiConstants.analyzeResume);
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('resume', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return ResumeResponse.fromJson(decoded);
      }
      return null;
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }
}