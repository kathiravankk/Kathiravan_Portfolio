// import 'package:dio/dio.dart';
//
// import '../core/const_file/api_constants.dart';
// import '../models/resume_response.dart';
//
// class StudentRegisterProvider {
//   final Dio? client;
//
//   StudentRegisterProvider({required this.client});
//
//   int? _responseStatus;
//
//   int get responseStatus => _responseStatus!;
//
//   set responseStatus(int value) => _responseStatus = value;
//
//   // ================= STUDENT REGISTER =================
//
//   /// 🧑‍🎓 Student Register
//   Future<ResumeResponse> registerStudent({
//     required String name,
//     required String email,
//     required String mobile,
//     required Map<String, dynamic> resumeReport,
//   }) async {
//     try {
//       client!.interceptors.add(
//         LogInterceptor(requestBody: true, responseBody: true),
//       );
//
//       Response response = await client!.post(
//         ApiConstants.registerStudent, // 👈 your API constant
//         data: {
//           "name": name,
//           "email": email,
//           "phone": mobile,
//           "resume_report": resumeReport,
//         },
//       );
//
//       responseStatus = response.statusCode!;
//       return ResumeResponse.fromJson(response.data);
//
//     } on DioException catch (error) {
//       responseStatus = error.response?.statusCode ?? 500;
//       return ResumeResponse.fromJson(error.response?.data);
//     }
//   }
// }
