import 'package:dio/dio.dart';
import 'package:internsharks/app/data/models/common_post_model.dart';
import '../core/const_file/api_constants.dart';

class AuthProvider {
  final Dio? client;

  AuthProvider({required this.client});

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
        ApiConstants.registerSendMobileOtp,
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
        ApiConstants.registerVerifyMobileOtp,
        data: {"mobile": mobile, "otp": otp},
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
/// login
  Future<CommonPostModel> loginSendMobileOtp(String mobile) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!.post(
        ApiConstants.loginSendOtp,
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
  Future<CommonPostModel> loginVerifyMobileOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!.post(
        ApiConstants.loginVerifyOtp,
        data: {"mobile": mobile, "otp": otp},
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
  // Future<CommonPostModel> sendEmailOtp(String email) async {
  //   try {
  //     client!.interceptors.add(
  //       LogInterceptor(responseBody: true, requestBody: true),
  //     );
  //     Response response = await client!.post(
  //       ApiConstants.sendMailOtp,
  //       data: {"email": email,"user":"student"},
  //     );
  //     responseStatus = response.statusCode!;
  //     return CommonPostModel.fromJson(response.data);
  //   } on DioException catch (error) {
  //     responseStatus = error.response!.statusCode!;
  //     return CommonPostModel.fromJson(error.response!.data);
  //   }
  // }

  Future<CommonPostModel> sendEmailOtp(String email) async {
    try {
      Response response = await client!.post(
        ApiConstants.sendMailOtp,
        data: {
          "email": email,
          "userType": "student",
        },
      );

      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);

    } on DioException catch (error) {
      responseStatus = error.response?.statusCode ?? 500;
      return CommonPostModel.fromJson(error.response?.data);
    }
  }

  /// 📧 Verify Email OTP
  Future<CommonPostModel> verifyEmailOtp(String email, String otp,String usertype) async {
    try {
      client!.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      Response response = await client!.post(
        ApiConstants.verifyMailOtp,
        data: {"email": email, "otp": otp,"userType":usertype},
      );
      responseStatus = response.statusCode!;
      return CommonPostModel.fromJson(response.data);
    } on DioException catch (error) {
      responseStatus = error.response!.statusCode!;
      return CommonPostModel.fromJson(error.response!.data);
    }
  }

  /// 📧 Verify Email OTP
  // Future<CommonPostModel> studentRegister(ResumeAnalyzeModel resumeData) async {
  //   try {
  //     client!.interceptors.add(
  //       LogInterceptor(responseBody: true, requestBody: true),
  //     );
  //     Response response = await client!.post(
  //       ApiConstants.verifyMailOtp,
  //       data: {"email": email, "otp": otp,"userType":usertype},
  //     );
  //     responseStatus = response.statusCode!;
  //     return CommonPostModel.fromJson(response.data);
  //   } on DioException catch (error) {
  //     responseStatus = error.response!.statusCode!;
  //     return CommonPostModel.fromJson(error.response!.data);
  //   }
  // }
}