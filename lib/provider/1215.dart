// //
// // import 'package:dio/dio.dart';
// // import 'dart:convert';
// //
// // import 'package:flutter/cupertino.dart';
// // import 'package:upgrader/upgrader.dart';
// //
// // import '../core/const_file/api_constants.dart';
// // import '../models/resume_response.dart';
// //
// // class RegisterService {
// //   final Dio _dio = Dio();
// //
// //
// //   // 🔥 Register API with Resume Data
// //   Future<ResumeResponse> registerWithResume({
// //     required String filePath,
// //     required String name,
// //     required String email,
// //     required String phone,
// //     String? location,
// //     String? summary,
// //   }) async {
// //     try {
// //       final formData = FormData();
// //
// //       // File upload
// //       formData.files.add(
// //         MapEntry(
// //           'resume_file',
// //           await MultipartFile.fromFile(
// //             filePath,
// //             filename: filePath.split('/').last,
// //           ),
// //         ),
// //       );
// //
// //       // 🔥 Personal Info (from AI extracted data)
// //       formData.fields.addAll([
// //         MapEntry('name', name),
// //         MapEntry('email', email),
// //         MapEntry('phone', phone),
// //         if (location != null) MapEntry('location', location),
// //         if (summary != null) MapEntry('summary', summary),
// //       ]);
// //
// //       // API call
// //       final response = await _dio.post(
// //         ApiConstants.registerStudent, // Your register endpoint
// //         data: formData,
// //         options: Options(
// //           headers: {
// //             'Content-Type': 'multipart/form-data',
// //           },
// //         ),
// //       );
// //
// //       return {
// //         'success': true,
// //         'message': 'Registration successful',
// //         'data': response.data,
// //       };
// //
// //     } on DioException catch (e) {
// //       debugPrint('Register API Error: ${e.message}');
// //       return {
// //         'success': false,
// //         'message': e.response?.data['message'] ?? 'Registration failed',
// //         'data': null,
// //       };
// //     } catch (e) {
// //       debugPrint('Error: $e');
// //       return {
// //         'success': false,
// //         'message': 'Something went wrong',
// //         'data': null,
// //       };
// //     }
// //   }
// // }
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../core/const_file/api_constants.dart';
// import '../models/resume_response.dart';
//
// class RegisterService {
//   final Dio _dio = Dio();
//
//   /// 🔥 Register API with Resume File + Data
//   Future<ResumeResponse> registerWithResume({
//     required String filePath,
//     required String name,
//     required String email,
//     required String phone,
//     String? location,
//     String? summary,
//   }) async {
//     try {
//       final formData = FormData();
//
//       /// Resume file
//       formData.files.add(
//         MapEntry(
//           'resume_file',
//           await MultipartFile.fromFile(
//             filePath,
//             filename: filePath.split('/').last,
//           ),
//         ),
//       );
//
//       /// Personal info
//       formData.fields.addAll([
//         MapEntry('name', name),
//         MapEntry('email', email),
//         MapEntry('phone', phone),
//         if (location != null) MapEntry('location', location),
//         if (summary != null) MapEntry('summary', summary),
//       ]);
//
//       final response = await _dio.post(
//         ApiConstants.registerStudent,
//         data: formData,
//         options: Options(
//           headers: {'Content-Type': 'multipart/form-data'},
//         ),
//       );
//
//       /// ✅ SUCCESS → MODEL RETURN
//       return ResumeResponse.fromJson(response.data);
//
//     } on DioException catch (e) {
//       debugPrint('Register API Error: ${e.message}');
//
//       /// ❌ ERROR → MODEL RETURN
//       return ResumeResponse(
//
//         message: e.response?.data['message'] ?? 'Registration failed',
//         data: null,
//       );
//
//     } catch (e) {
//       debugPrint('Error: $e');
//
//       /// ❌ ERROR → MODEL RETURN
//       // return ResumeResponse(
//       //   success: false,
//       //   message: 'Something went wrong',
//       //   data: null,
//       // );
//     }
//   }
// }
