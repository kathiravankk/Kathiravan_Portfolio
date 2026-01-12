// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:internsharks/core/const_file/api_constants.dart';
// //
// // class LoginService {
// //   static Future<bool> sendOtp(String mobile) async {
// //     try {
// //       final response = await http.post(
// //         Uri.parse(ApiConstants.requestMobileOtp),
// //         headers: {
// //           "Content-Type": "application/json",
// //         },
// //         body: jsonEncode({
// //           "mobile": mobile,
// //         }),
// //       );
// //
// //       final data = jsonDecode(response.body);
// //
// //       return response.statusCode == 200 ;
// //     } catch (e) {
// //       return false;
// //     }
// //   }
// //
// //   static Future<Map<String, dynamic>> verifyOtp({
// //     required String mobile,
// //     required String otp,
// //
// //   }) async {
// //     try {
// //       final response = await http.post(
// //         Uri.parse(ApiConstants.verifyMobileOtp),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "mobile": mobile,
// //           "otp": otp,
// //         }),
// //       );
// //
// //       return {
// //         "statusCode": response.statusCode,
// //         "body": jsonDecode(response.body),
// //       };
// //     } catch (e) {
// //       return {
// //         "statusCode": 500,
// //         "body": {
// //           "status": false,
// //           "message": "Something went wrong",
// //         }
// //       };
// //     }
// //   }
// // }
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:internsharks/core/const_file/api_constants.dart';
//
// class LoginService {
//
//   // 📤 SEND OTP (with proper status handling)
//   static Future<Map<String, dynamic>> sendOtp(String mobile) async {
//     try {
//       final response = await http.post(
//         Uri.parse(ApiConstants.requestMobileOtp),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"mobile": mobile}),
//       );
//
//       final data = jsonDecode(response.body);
//
//       // ✅ Check both statusCode AND response body status
//       bool isSuccess = response.statusCode == 200 ;
//
//       return {
//         "success": isSuccess,
//         "message": data['message'] ??
//             (isSuccess ? "OTP sent successfully" : "Failed to send OTP"),
//         "data": data,
//         "statusCode": response.statusCode,
//       };
//     } catch (e) {
//       print("SendOTP Error: $e"); // Debug purpose
//       return {
//         "success": false,
//         "message": "Network error. Please try again",
//         "data": null,
//         "statusCode": 500,
//       };
//     }
//   }
//
//   // ✅ VERIFY OTP
//   static Future<Map<String, dynamic>> verifyOtp({
//     required String mobile,
//     required String otp,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse(ApiConstants.verifyMobileOtp),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "mobile": mobile,
//           "otp": otp,
//         }),
//       );
//
//       final data = jsonDecode(response.body);
//
//       return {
//         "statusCode": response.statusCode,
//         "success": response.statusCode == 200 ,
//         "body": data,
//       };
//     } catch (e) {
//       print("VerifyOTP Error: $e"); // Debug purpose
//       return {
//         "statusCode": 500,
//         "success": false,
//         "body": {
//           "status": false,
//           "message": "Network error. Please try again",
//         }
//       };
//     }
//   }
// }




import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:internsharks/models/common_post_model.dart';
import '../core/const_file/api_constants.dart';

class LoginProvider {
  final Dio? client;

  LoginProvider({required this.client});

  int? _responseStatus;

  int get responseStatus => _responseStatus!;

  set responseStatus(int value) => _responseStatus = value;

  // ================= MOBILE OTP =================

  /// 📱 Send Mobile OTP
  Future<CommonPostModel> sendMobileOtp(String mobile) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!.post(
        ApiConstants.requestMobileOtp,
        data: {"mobile": mobile},
      );
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data!);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      return CommonPostModel.fromJson(error.response!.data);
    }
    // try {
    //   final response = await http.post(
    //     Uri.parse(ApiConstants.requestMobileOtp),
    //     headers: {"Content-Type": "application/json"},
    //     body: jsonEncode({"mobile": mobile}),
    //   );
    //
    //   return {
    //     "success": response.statusCode == 200,
    //     "body": jsonDecode(response.body),
    //     "statusCode": response.statusCode,
    //   };
    // } catch (e) {
    //   return {
    //     "success": false,
    //     "body": {"message": "Network error"},
    //     "statusCode": 500,
    //   };
    // }
  }


  /// 📱 Verify Mobile OTP
  Future<CommonPostModel> verifyMobileOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!.post(
        ApiConstants.verifyMobileOtp,
        data: { "mobile": mobile,
          "otp": otp},
      );
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      return CommonPostModel.fromJson(error.response!.data);
    }
    // try {
    //   final response = await http.post(
    //     Uri.parse(ApiConstants.verifyMobileOtp),
    //     headers: {"Content-Type": "application/json"},
    //     body: jsonEncode({"mobile": mobile, "otp": otp}),
    //   );
    //
    //   return {
    //     "success": response.statusCode == 200,
    //     "body": jsonDecode(response.body),
    //     "statusCode": response.statusCode,
    //   };
    // } catch (e) {
    //   return {
    //     "success": false,
    //     "body": {"message": "Network error"},
    //     "statusCode": 500,
    //   };
    // }
  }

  // ================= EMAIL OTP =================

  /// 📧 Send Email OTP
  Future<CommonPostModel> sendEmailOtp(String email,) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!.post(
        ApiConstants.requestMailOtp,
        data: { "email": email,
        },
      );
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      return CommonPostModel.fromJson(error.response!.data);
    }
  }


  /// 📧 Verify Email OTP
  Future<CommonPostModel> verifyEmailOtp(String email,
      String otp,) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!.post(
        ApiConstants.requestMailOtp,
        data: { "email": email,
          "otp": otp},
      );
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      return CommonPostModel.fromJson(error.response!.data);
    }
  }
}

