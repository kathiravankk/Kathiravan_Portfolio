// // // // // // // import 'dart:async'; // Timer-ku idhu dhaan correct
// // // // // // // import 'dart:convert';
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:get/get.dart';
// // // // // // // import 'package:http/http.dart' as http;
// // // // // // //
// // // // // // // import '../provider/login_provider.dart';
// // // // // // // import '../screens/home_Screen.dart';
// // // // // // //
// // // // // // // class LoginController extends GetxController {
// // // // // // //   // Observables for Text Tracking
// // // // // // //   final mobileCtrlStr = ''.obs;
// // // // // // //   final otpCtrlStr = ''.obs;
// // // // // // //
// // // // // // //   // UI State
// // // // // // //   final isLoading = false.obs;
// // // // // // //   final otpSent = false.obs;
// // // // // // //
// // // // // // //   // Timer
// // // // // // //   final seconds = 30.obs;
// // // // // // //   final canResend = false.obs;
// // // // // // //   Timer? _timer;
// // // // // // //
// // // // // // //   // 🔹 VALIDATIONS (Inge .value use pannuvadhub GetX-ku puriyum)
// // // // // // //   bool get isMobileValid => mobileCtrlStr.value.length == 10;
// // // // // // //   bool get isOtpValid => otpCtrlStr.value.length == 4;
// // // // // // //
// // // // // // //   // 🔹 SEND OTP API
// // // // // // //   Future<void> sendOtp() async {
// // // // // // //     if (!isMobileValid) return;
// // // // // // //
// // // // // // //     isLoading.value = true;
// // // // // // //
// // // // // // //     final success = await LoginService.sendOtp(mobileCtrlStr.value);
// // // // // // //
// // // // // // //     isLoading.value = false;
// // // // // // //
// // // // // // //     if (success) {
// // // // // // //       otpSent.value = true;
// // // // // // //       startTimer();
// // // // // // //       Get.snackbar("Success", "OTP sent successfully");
// // // // // // //     } else {
// // // // // // //       Get.snackbar("Error", "Failed to send OTP");
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   // 🔹 TIMER LOGIC (Clean way)
// // // // // // //   void startTimer() {
// // // // // // //     canResend.value = false;
// // // // // // //     seconds.value = 30;
// // // // // // //     _timer?.cancel();
// // // // // // //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// // // // // // //       if (seconds.value == 0) {
// // // // // // //         canResend.value = true;
// // // // // // //         t.cancel();
// // // // // // //       } else {
// // // // // // //         seconds.value--;
// // // // // // //       }
// // // // // // //     });
// // // // // // //   }
// // // // // // //
// // // // // // //   @override
// // // // // // //   void onClose() {
// // // // // // //     _timer?.cancel();
// // // // // // //     super.onClose();
// // // // // // //   }
// // // // // // //
// // // // // // //
// // // // // // //
// // // // // // //   ///verify
// // // // // // //   final otpCtrl = TextEditingController();
// // // // // // //
// // // // // // //   final isOtpValidRx = false.obs;
// // // // // // //   final isVerifying = false.obs;
// // // // // // //
// // // // // // //   void onOtpChanged(String value) {
// // // // // // //     isOtpValidRx.value = value.length == 4;
// // // // // // //   }
// // // // // // //
// // // // // // //   Future<void> verifyOtp(String mobile) async {
// // // // // // //     if (!isOtpValidRx.value) return;
// // // // // // //
// // // // // // //     isVerifying.value = true;
// // // // // // //
// // // // // // //     await Future.delayed(const Duration(seconds: 1)); // API simulation
// // // // // // //
// // // // // // //     isVerifying.value = false;
// // // // // // //     Get.offAll(() => HomeScreen());
// // // // // // //   }
// // // // // // //
// // // // // // //
// // // // // // // }
// // // // // // import 'dart:async';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:get/get.dart';
// // // // // // import '../provider/login_provider.dart';
// // // // // // import '../screens/home_Screen.dart';
// // // // // //
// // // // // // class LoginController extends GetxController {
// // // // // //   // Text values
// // // // // //   final mobileCtrlStr = ''.obs;
// // // // // //   final otpCtrlStr = ''.obs;
// // // // // //
// // // // // //   // UI State
// // // // // //   final isLoading = false.obs;
// // // // // //   final otpSent = false.obs;
// // // // // //   final isVerifying = false.obs;
// // // // // //
// // // // // //   // Timer
// // // // // //   final seconds = 30.obs;
// // // // // //   final canResend = false.obs;
// // // // // //   Timer? _timer;
// // // // // //
// // // // // //   // ✅ REACTIVE VALIDATIONS
// // // // // //   bool get isMobileValid => mobileCtrlStr.value.length == 10;
// // // // // //
// // // // // //   // ✅ OTP validation-um reactive-ah irukanum
// // // // // //   bool get isOtpValid => otpCtrlStr.value.length == 4;
// // // // // //
// // // // // //   // 📤 SEND OTP
// // // // // //   Future<void> sendOtp() async {
// // // // // //     if (!isMobileValid) return;
// // // // // //
// // // // // //     isLoading.value = true;
// // // // // //     final success = await LoginService.sendOtp(mobileCtrlStr.value);
// // // // // //     isLoading.value = false;
// // // // // //
// // // // // //     if (success) {
// // // // // //       otpSent.value = true;
// // // // // //       startTimer();
// // // // // //       Get.snackbar("Success", "OTP sent successfully");
// // // // // //     } else {
// // // // // //       Get.snackbar("Error", "Failed to send OTP");
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   // ✅ VERIFY OTP
// // // // // //   Future<void> verifyOtp() async {
// // // // // //     if (!isOtpValid) return;
// // // // // //
// // // // // //     isVerifying.value = true;
// // // // // //
// // // // // //     final result = await LoginService.verifyOtp(
// // // // // //       mobile: mobileCtrlStr.value,
// // // // // //       otp: otpCtrlStr.value,
// // // // // //     );
// // // // // //
// // // // // //     isVerifying.value = false;
// // // // // //
// // // // // //     if (result['statusCode'] == 200 ) {
// // // // // //       Get.snackbar("Success", "Login successful");
// // // // // //       Get.offAll(() => const HomeScreen());
// // // // // //     } else {
// // // // // //       Get.snackbar(
// // // // // //         "Error",
// // // // // //         result['body']['message'] ?? "Invalid OTP",
// // // // // //         backgroundColor: Colors.red,
// // // // // //         colorText: Colors.white,
// // // // // //       );
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   // ⏱️ TIMER
// // // // // //   void startTimer() {
// // // // // //     canResend.value = false;
// // // // // //     seconds.value = 30;
// // // // // //     _timer?.cancel();
// // // // // //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// // // // // //       if (seconds.value == 0) {
// // // // // //         canResend.value = true;
// // // // // //         t.cancel();
// // // // // //       } else {
// // // // // //         seconds.value--;
// // // // // //       }
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   void onClose() {
// // // // // //     _timer?.cancel();
// // // // // //     super.onClose();
// // // // // //   }
// // // // // // }
// // // // // import 'dart:async';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:get/get.dart';
// // // // // import '../provider/login_provider.dart';
// // // // // import '../screens/home_Screen.dart';
// // // // //
// // // // // class LoginController extends GetxController {
// // // // //   // Text values
// // // // //   final mobileCtrlStr = ''.obs;
// // // // //   final otpCtrlStr = ''.obs;
// // // // //
// // // // //   // UI State
// // // // //   final isLoading = false.obs;
// // // // //   final otpSent = false.obs;
// // // // //   final isVerifying = false.obs;
// // // // //
// // // // //   // Timer
// // // // //   final seconds = 30.obs;
// // // // //   final canResend = false.obs;
// // // // //   Timer? _timer;
// // // // //
// // // // //   // ✅ REACTIVE VALIDATIONS
// // // // //   bool get isMobileValid => mobileCtrlStr.value.length == 10;
// // // // //
// // // // //   // ✅ OTP validation-um reactive-ah irukanum
// // // // //   bool get isOtpValid => otpCtrlStr.value.length == 4;
// // // // //
// // // // //   // 📤 SEND OTP
// // // // //   Future<void> sendOtp() async {
// // // // //     if (!isMobileValid) return;
// // // // //
// // // // //     isLoading.value = true;
// // // // //     final success = await LoginService.sendOtp(mobileCtrlStr.value);
// // // // //     isLoading.value = false;
// // // // //
// // // // //     if (success) {
// // // // //       otpSent.value = true;
// // // // //       startTimer();
// // // // //       Get.snackbar("Success", "OTP sent successfully");
// // // // //     } else {
// // // // //       Get.snackbar("Error", "Failed to send OTP");
// // // // //     }
// // // // //   }
// // // // //
// // // // //   // ✅ VERIFY OTP
// // // // //   Future<void> verifyOtp() async {
// // // // //     if (!isOtpValid) return;
// // // // //
// // // // //     isVerifying.value = true;
// // // // //
// // // // //     final result = await LoginService.verifyOtp(
// // // // //       mobile: mobileCtrlStr.value,
// // // // //       otp: otpCtrlStr.value,
// // // // //     );
// // // // //
// // // // //     isVerifying.value = false;
// // // // //
// // // // //     if (result['statusCode'] == 200 ) {
// // // // //       result['body']['message'] ;
// // // // //       Get.snackbar("Success", "Login successful");
// // // // //       Get.offAll(() => const HomeScreen());
// // // // //     } else {
// // // // //       Get.snackbar(
// // // // //         "Error",
// // // // //         result['body']['message'] ?? "Invalid OTP",
// // // // //         backgroundColor: Colors.red,
// // // // //         colorText: Colors.white,
// // // // //       );
// // // // //     }
// // // // //   }
// // // // //
// // // // //   // ⏱️ TIMER
// // // // //   void startTimer() {
// // // // //     canResend.value = false;
// // // // //     seconds.value = 30;
// // // // //     _timer?.cancel();
// // // // //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// // // // //       if (seconds.value == 0) {
// // // // //         canResend.value = true;
// // // // //         t.cancel();
// // // // //       } else {
// // // // //         seconds.value--;
// // // // //       }
// // // // //     });
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   void onClose() {
// // // // //     _timer?.cancel();
// // // // //     super.onClose();
// // // // //   }
// // // // // }
// // // // import 'dart:async'; // Timer-ku idhu dhaan correct
// // // // import 'dart:convert';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:http/http.dart' as http;
// // // //
// // // // import '../provider/login_provider.dart';
// // // // import '../screens/home_Screen.dart';
// // // //
// // // // class LoginController extends GetxController {
// // // //   // Observables for Text Tracking
// // // //   final mobileCtrlStr = ''.obs;
// // // //   final otpCtrlStr = ''.obs;
// // // //
// // // //   // UI State
// // // //   final isLoading = false.obs;
// // // //   final otpSent = false.obs;
// // // //
// // // //   // Timer
// // // //   final seconds = 30.obs;
// // // //   final canResend = false.obs;
// // // //   Timer? _timer;
// // // //
// // // //   // 🔹 VALIDATIONS (Inge .value use pannuvadhub GetX-ku puriyum)
// // // //   bool get isMobileValid => mobileCtrlStr.value.length == 10;
// // // //   bool get isOtpValid => otpCtrlStr.value.length == 4;
// // // //
// // // //   // 🔹 SEND OTP API
// // // //   Future<void> sendOtp() async {
// // // //     if (!isMobileValid) return;
// // // //
// // // //     isLoading.value = true;
// // // //
// // // //     final success = await LoginService.sendOtp(mobileCtrlStr.value);
// // // //
// // // //     isLoading.value = false;
// // // //
// // // //     if (success) {
// // // //       otpSent.value = true;
// // // //       startTimer();
// // // //       Get.snackbar("Success", "OTP sent successfully");
// // // //     } else {
// // // //       Get.snackbar("Error", "Failed to send OTP");
// // // //     }
// // // //   }
// // // //
// // // //   // 🔹 TIMER LOGIC (Clean way)
// // // //   void startTimer() {
// // // //     canResend.value = false;
// // // //     seconds.value = 30;
// // // //     _timer?.cancel();
// // // //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// // // //       if (seconds.value == 0) {
// // // //         canResend.value = true;
// // // //         t.cancel();
// // // //       } else {
// // // //         seconds.value--;
// // // //       }
// // // //     });
// // // //   }
// // // //
// // // //   @override
// // // //   void onClose() {
// // // //     _timer?.cancel();
// // // //     super.onClose();
// // // //   }
// // // //
// // // //   ///verify
// // // //   final otpCtrl = TextEditingController();
// // // //
// // // //   final isOtpValidRx = false.obs;
// // // //   final isVerifying = false.obs;
// // // //
// // // //   void onOtpChanged(String value) {
// // // //     isOtpValidRx.value = value.length == 4;
// // // //   }
// // // //
// // // //   Future<void> verifyOtp(String mobile) async {
// // // //     if (!isOtpValidRx.value) return;
// // // //
// // // //     isVerifying.value = true;
// // // //
// // // //     await Future.delayed(const Duration(seconds: 1)); // API simulation
// // // //
// // // //     isVerifying.value = false;
// // // //     Get.offAll(() => HomeScreen());
// // // //   }
// // // //
// // // // }
// // // import 'dart:async';
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import '../provider/login_provider.dart';
// // // import '../screens/home_Screen.dart';
// // //
// // // class LoginController extends GetxController {
// // //   // Text values
// // //   final mobileCtrlStr = ''.obs;
// // //   final otpCtrlStr = ''.obs;
// // //
// // //   // UI State
// // //   final isLoading = false.obs;
// // //   final otpSent = false.obs;
// // //   final isVerifying = false.obs;
// // //
// // //   // Timer
// // //   final seconds = 30.obs;
// // //   final canResend = false.obs;
// // //   Timer? _timer;
// // //
// // //   // ✅ REACTIVE VALIDATIONS
// // //   bool get isMobileValid => mobileCtrlStr.value.length == 10;
// // //
// // //   // ✅ OTP validation-um reactive-ah irukanum
// // //   bool get isOtpValid => otpCtrlStr.value.length == 4;
// // //
// // //   // 📤 SEND OTP
// // //   Future<void> sendOtp() async {
// // //     if (!isMobileValid) return;
// // //
// // //     isLoading.value = true;
// // //     final success = await LoginService.sendOtp(mobileCtrlStr.value);
// // //     isLoading.value = false;
// // //
// // //     if (success) {
// // //       otpSent.value = true;
// // //       startTimer();
// // //       Get.snackbar("Success", "OTP sent successfully");
// // //     } else {
// // //       Get.snackbar("Error", "Failed to send OTP");
// // //     }
// // //   }
// // //
// // //   // ✅ VERIFY OTP
// // //   Future<void> verifyOtp() async {
// // //     if (!isOtpValid) return;
// // //
// // //     isVerifying.value = true;
// // //
// // //     final result = await LoginService.verifyOtp(
// // //       mobile: mobileCtrlStr.value,
// // //       otp: otpCtrlStr.value,
// // //     );
// // //
// // //     isVerifying.value = false;
// // //
// // //     if (result['statusCode'] == 200 ) {
// // //       result['body']['message'] ;
// // //       Get.snackbar("Success", "Login successful");
// // //       Get.offAll(() => const HomeScreen());
// // //     } else {
// // //       Get.snackbar(
// // //         "Error",
// // //         result['body']['message'] ?? "Invalid OTP",
// // //         backgroundColor: Colors.red,
// // //         colorText: Colors.white,
// // //       );
// // //     }
// // //   }
// // //
// // //   // ⏱️ TIMER
// // //   void startTimer() {
// // //     canResend.value = false;
// // //     seconds.value = 30;
// // //     _timer?.cancel();
// // //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// // //       if (seconds.value == 0) {
// // //         canResend.value = true;
// // //         t.cancel();
// // //       } else {
// // //         seconds.value--;
// // //       }
// // //     });
// // //   }
// // //
// // //   @override
// // //   void onClose() {
// // //     _timer?.cancel();
// // //     super.onClose();
// // //   }
// // // }
// // import 'dart:async';
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import '../core/const_file/api_constants.dart';
// // import '../provider/login_provider.dart';
// // import '../view/screens/goto_intern_homepage.dart';
// //
// // class LoginController extends GetxController {
// //
// //   // Text values
// //   final mobileCtrlStr = ''.obs;
// //   final otpCtrlStr = ''.obs;
// //
// //   // UI State
// //   final isLoading = false.obs;
// //   final otpSent = false.obs;
// //   final isVerifying = false.obs;
// //
// //   // Timer
// //   final seconds = 30.obs;
// //   final canResend = false.obs;
// //   Timer? _timer;
// //
// //   // ✅ VALIDATIONS
// //   bool get isMobileValid => mobileCtrlStr.value.length == 10;
// //   bool get isOtpValid => otpCtrlStr.value.length == 4;
// //
// //   // 📤 SEND OTP - ✅ FIXED
// //   Future<void> sendOtp() async {
// //     if (!isMobileValid) {
// //       Get.snackbar(
// //         "Invalid",
// //         "Please enter a valid 10-digit mobile number",
// //       );
// //       return;
// //     }
// //
// //     isLoading.value = true;
// //
// //     try {
// //       final result = await LoginService.sendOtp(mobileCtrlStr.value);
// //
// //       print("Send OTP Result: $result"); // Debug
// //
// //       if (result['success'] == true) {  // ✅ 'success' key use pannunga
// //         otpSent.value = true;  // ✅ இது தான் missing இருந்துச்சு!
// //         startTimer();
// //
// //         Get.snackbar(
// //           "Success",
// //           result['message'] ?? "OTP sent successfully",
// //           backgroundColor: Colors.green,
// //           colorText: Colors.white,
// //         );
// //       } else {
// //         Get.snackbar(
// //           "Failed",
// //           result['message'] ?? "Failed to send OTP",
// //           backgroundColor: Colors.red,
// //           colorText: Colors.white,
// //         );
// //       }
// //     } catch (e) {
// //       print("Send OTP Error: $e"); // Debug
// //       Get.snackbar(
// //         "Error",
// //         "Network error. Please try again",
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   // ✅ VERIFY OTP
// //   Future<void> verifyOtp() async {
// //     if (!isOtpValid) {
// //       Get.snackbar("Invalid", "Please enter 4-digit OTP");
// //       return;
// //     }
// //
// //     isVerifying.value = true;
// //
// //     try {
// //       final result = await LoginService.verifyOtp(
// //         mobile: mobileCtrlStr.value,
// //         otp: otpCtrlStr.value,
// //       );
// //
// //       print("Verify OTP Result: $result"); // Debug
// //
// //       if (result['success'] == true) {  // ✅ 'success' key use pannunga
// //         Get.snackbar(
// //           "Success",
// //           "Login successful",
// //           backgroundColor: Colors.green,
// //           colorText: Colors.white,
// //         );
// //         Get.offAll(() => const InternshipHomePage());
// //       } else {
// //         String errorMsg = result['body']?['message'] ?? "Invalid OTP";
// //
// //         Get.snackbar(
// //           "Error",
// //           errorMsg,
// //           backgroundColor: Colors.red,
// //           colorText: Colors.white,
// //         );
// //       }
// //     } catch (e) {
// //       print("Verify OTP Error: $e"); // Debug
// //       Get.snackbar(
// //         "Error",
// //         "Verification failed",
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );
// //     } finally {
// //       isVerifying.value = false;
// //     }
// //   }
// //
// //   // ⏱️ TIMER
// //   void startTimer() {
// //     canResend.value = false;
// //     seconds.value = 30;
// //     _timer?.cancel();
// //
// //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// //       if (seconds.value == 0) {
// //         canResend.value = true;
// //         t.cancel();
// //       } else {
// //         seconds.value--;
// //       }
// //     });
// //   }
// //
// //   @override
// //   void onClose() {
// //     _timer?.cancel();
// //     super.onClose();
// //   }
// //
// //   static Future<Map<String, dynamic>> sendEmailOtp(String email) async {
// //     try {
// //       final response = await http.post(
// //         Uri.parse(ApiConstants.requestMailOtp),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({"email": email}),
// //       );
// //
// //       final data = jsonDecode(response.body);
// //       bool isSuccess = response.statusCode == 200;
// //
// //       return {
// //         "success": isSuccess,
// //         "message": data['message'] ?? (isSuccess ? "OTP sent successfully" : "Failed to send OTP"),
// //         "data": data,
// //         "statusCode": response.statusCode,
// //       };
// //     } catch (e) {
// //       print("SendEmailOTP Error: $e");
// //       return {
// //         "success": false,
// //         "message": "Network error. Please try again",
// //         "data": null,
// //         "statusCode": 500,
// //       };
// //     }
// //   }
// //
// //   /// ✅ VERIFY EMAIL OTP
// //   static Future<Map<String, dynamic>> verifyEmailOtp({
// //     required String email,
// //     required String otp,
// //   }) async {
// //     try {
// //       final response = await http.post(
// //         Uri.parse(ApiConstants.verifyMailOtp),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "email": email,
// //           "otp": otp,
// //         }),
// //       );
// //
// //       final data = jsonDecode(response.body);
// //
// //       return {
// //         "statusCode": response.statusCode,
// //         "success": response.statusCode == 200,
// //         "body": data,
// //         "message": data['message'] ?? "Email verified successfully",
// //       };
// //     } catch (e) {
// //       print("VerifyEmailOTP Error: $e");
// //       return {
// //         "statusCode": 500,
// //         "success": false,
// //         "body": {"status": false, "message": "Network error"},
// //         "message": "Network error. Please try again",
// //       };
// //     }
// //   }
// // }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:internsharks/models/common_post_model.dart';
// import '../provider/login_provider.dart';
//
// class LoginController extends GetxController {
//   final LoginProvider? loginProvider;
//
//   LoginController(this.loginProvider);
//
//   // ---------------- INPUT ----------------
//   final mobile = ''.obs;
//   final email = ''.obs;
//   final otp = ''.obs;
//
// ///loading
//   final _loginLoading = false.obs;
//
//   bool get loginLoading => _loginLoading.value;
//
//   set loginLoading(bool value) => _loginLoading.value = value;
//
//   //Verify loading
//
//   final _verifyLoading = false.obs;
//
//   bool get verifyLoading => _verifyLoading.value;
//
//   set verifyLoading(bool value) => _verifyLoading.value = value;
//
//   final _mailLoginLoading = false.obs;
//
//   bool get mailLoading => _mailLoginLoading.value;
//
//   set mailLoginLoading(bool value) => _mailLoginLoading.value = value;
//
//   //Verify loading
//
//   final _mailVerifyLoading = false.obs;
//
//   bool get mailVerifyLoading => _mailVerifyLoading.value;
//
//   set mailVerifyLoading(bool value) => _mailVerifyLoading.value = value;
//
//   //Set Model
//   final _commonPostModel = CommonPostModel().obs;
//
//   CommonPostModel get commonPostModel => _commonPostModel.value;
//
//   set commonPostModel(CommonPostModel value) => _commonPostModel.value = value;
//
//   final _isLoading = false.obs;
//   bool get isLoading => _isLoading.value;
//   set isLoading(bool v) => _isLoading.value = v;
//
//   final _otpSent = false.obs;
//
//   bool get otpSent => _otpSent.value;
//
//   set otpSent(bool v) => _otpSent.value = v;
//
//   // ---------------- TIMER ----------------
//   final seconds = 30.obs;
//   final canResend = false.obs;
//   Timer? _timer;
//
//   // ---------------- VALIDATION ----------------
//   bool get isMobileValid => mobile.value.length == 10;
//
//   bool get isEmailValid => email.value.contains("@");
//
//   bool get isOtpValid => otp.value.length == 4;
//
//   // ================= MOBILE OTP =================
//
//   Future<void> sendMobileOtp() async {
//     // if (!isMobileValid) {
//     //   Get.snackbar("Invalid", "Enter valid mobile number");
//     //   return;
//     // }
//
//     loginLoading = true;
//     try {
//       commonPostModel = await loginProvider!.sendMobileOtp(mobile.value);
//
//       // if (res['success']) {
//       //   otpSent = true;
//       //   startTimer();
//       //   Get.snackbar("Success", res['body']['message'] ?? "OTP sent");
//       // } else {
//       //   Get.snackbar("Failed", res['body']['message'] ?? "OTP failed");
//       // }
//       loginLoading = false;
//     } catch (error) {
//       loginLoading = false;
//       rethrow;
//     }
//   }
//
//   Future<void> verifyMobileOtp(String mobile,String otp) async {
//     // if (!isOtpValid) {
//     //   Get.snackbar("Invalid", "Enter valid OTP");
//     //   return;
//     // }
//
//     verifyLoading = true;
//     try {
//       commonPostModel = await loginProvider!.verifyMobileOtp(mobile: mobile, otp: otp);
//       // final res = await loginProvider!.verifyMobileOtp(
//       //   mobile: mobile.value,
//       //   otp: otp.value,
//       // );
//       //
//       // if (res['success']) {
//       //   Get.snackbar("Success", "Mobile verified");
//       // } else {
//       //   Get.snackbar("Error", res['body']['message'] ?? "Invalid OTP");
//       // }
//       verifyLoading = false;
//     } catch (error) {
//       verifyLoading = false;
//       rethrow;
//     }
//   }
//
//   // ================= EMAIL OTP =================
//
//   Future<void> sendEmailOtp(String email) async {
//     // if (!isEmailValid) {
//     //   Get.snackbar("Invalid", "Enter valid email");
//     //   return;
//     // }
//
//     mailLoginLoading = true;
//     try {
//       commonPostModel = await loginProvider!.sendEmailOtp(email);
//
//       // final res = await loginProvider!.sendEmailOtp(email.value);
//       //
//       // if (res['success']) {
//       //   otpSent = true;
//       //   startTimer();
//       //   Get.snackbar("Success", res['body']['message'] ?? "OTP sent");
//       // } else {
//       //   Get.snackbar("Failed", res['body']['message'] ?? "OTP failed");
//       // }
//       mailLoginLoading = false;
//     }
//     catch (error) {
//       mailLoginLoading = false;
//       rethrow;
//     }
//   }
//
//   Future<void> verifyEmailOtp(String? otpValue, String? email) async {
//     // if (!isOtpValid) {
//     //   Get.snackbar("Invalid", "Enter valid OTP");
//     //   return;
//     // }
//
//     mailVerifyLoading = true;
//     try {
//
//       commonPostModel = await loginProvider!.verifyEmailOtp(email!, otpValue!);
//       // final res = await loginProvider!.verifyEmailOtp(
//       //   email: email!,
//       //   otp: otpValue!,
//       // );
//       //
//       // if (res['success']) {
//       //   Get.snackbar("Success", "Email verified");
//       // } else {
//       //   Get.snackbar("Error", res['body']['message'] ?? "Invalid OTP");
//       // }
//       mailVerifyLoading = false;
//     }
//     catch (error) {
//       mailVerifyLoading = false;
//       rethrow;
//     }
//   }
//
//   // ---------------- TIMER ----------------
//   void startTimer() {
//     canResend.value = false;
//     seconds.value = 30;
//     _timer?.cancel();
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (seconds.value == 0) {
//         canResend.value = true;
//         t.cancel();
//       } else {
//         seconds.value--;
//       }
//     });
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }
import 'dart:async';
import 'package:get/get.dart';
import 'package:internsharks/models/common_post_model.dart';
import '../core/const_file/api_error_handling.dart';
import '../provider/login_provider.dart';

class LoginController extends GetxController {
  final LoginProvider? loginProvider;

  LoginController(this.loginProvider);

  int getResponseCode() => loginProvider!.responseStatus;

  // ---------------- INPUT ----------------
  final mobile = ''.obs;
  final email = ''.obs;
  final otp = ''.obs;

  // ---------------- LOADING STATES ----------------
  final _loginLoading = false.obs;

  bool get loginLoading => _loginLoading.value;

  set loginLoading(bool v) => _loginLoading.value = v;

  final _verifyLoading = false.obs;

  bool get verifyLoading => _verifyLoading.value;

  set verifyLoading(bool v) => _verifyLoading.value = v;

  final _mailLoginLoading = false.obs;

  bool get mailLoginLoading => _mailLoginLoading.value;

  set mailLoginLoading(bool v) => _mailLoginLoading.value = v;

  final _mailVerifyLoading = false.obs;

  bool get mailVerifyLoading => _mailVerifyLoading.value;

  set mailVerifyLoading(bool v) => _mailVerifyLoading.value = v;

  // ---------------- MODEL ----------------
  final _commonPostModel = CommonPostModel().obs;

  CommonPostModel get commonPostModel => _commonPostModel.value;

  set commonPostModel(CommonPostModel v) => _commonPostModel.value = v;

  // ---------------- OTP STATE ----------------
  final _otpSent = false.obs;

  bool get otpSent => _otpSent.value;

  set otpSent(bool v) => _otpSent.value = v;

  // ---------------- TIMER ----------------
  final seconds = 30.obs;
  final canResend = false.obs;
  Timer? _timer;

  // ================= SEND MOBILE OTP =================
  Future<void> sendMobileOtp() async {
    loginLoading = true;
    try {
      commonPostModel = await loginProvider!.sendMobileOtp(mobile.value);
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: commonPostModel.message ?? "Something went wrong",
      );
      //
      // final code = commonPostModel.statusCode ?? 500;
      // final msg = commonPostModel.message ?? "OTP failed";
      //
      // if (code == 200 || code == 201) {
      //   otpSent = true;
      //   startTimer();
      // } else {
      //   ApiErrorHandler.handleApiError(responseCode: code, message: msg);
      // }
    } catch (error) {
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: commonPostModel.message ?? "Something went wrong",
      );
      loginLoading = false;
      rethrow;
    } finally {
      loginLoading = false;
    }
  }

  // ================= VERIFY MOBILE OTP =================
  Future<void> verifyMobileOtp(String mobile, String otp) async {
    verifyLoading = true;
    try {
      commonPostModel = await loginProvider!.verifyMobileOtp(
        mobile: mobile,
        otp: otp,
      );
      commonPostModel = await loginProvider!.verifyMobileOtp( mobile: mobile, otp: otp);
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: commonPostModel.message ?? "Something went wrong",
      );

      //
      // final code = commonPostModel.statusCode ?? 500;
      // final msg = commonPostModel.message ?? "Invalid OTP";
      //
      // if (code != 200) {
      //   ApiErrorHandler.handleApiError(
      //     responseCode: code,
      //     message: msg,
      //   );
      // }
    } catch (error) {
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: commonPostModel.message ?? "Something went wrong",
      );
      verifyLoading = false;
      rethrow;
    } finally {
      verifyLoading = false;
    }
  }

  // ================= SEND EMAIL OTP =================
  Future<void> sendEmailOtp(String email) async {
    mailLoginLoading = true;
    try {
      commonPostModel = await loginProvider!.sendEmailOtp(email);
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: commonPostModel.message ?? "Something went wrong",
      );
      // commonPostModel = await loginProvider!.sendEmailOtp(email);
      //
      // final code = commonPostModel.statusCode ?? 500;
      // final msg = commonPostModel.message ?? "OTP failed";
      //
      // if (code == 200 || code == 201) {
      //   otpSent = true;
      //   startTimer();
      // } else {
      //   ApiErrorHandler.handleApiError(responseCode: code, message: msg);
      // }
    } catch (error) {
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: commonPostModel.message ?? "Something went wrong",
      );
      mailLoginLoading = false;
      rethrow;
    } finally {
      mailLoginLoading = false;
    }
  }

  // ================= VERIFY EMAIL OTP =================
  Future<void> verifyEmailOtp(String otpValue, String email) async {
    mailVerifyLoading = true;
    try {
      commonPostModel = await loginProvider!.verifyEmailOtp(otpValue,email);
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: commonPostModel.message ?? "Something went wrong",
      );
      // commonPostModel = await loginProvider!.verifyEmailOtp(email, otpValue);
      //
      // final code = commonPostModel.statusCode ?? 500;
      // final msg = commonPostModel.message ?? "Invalid OTP";
      //
      // if (code != 200) {
      //   ApiErrorHandler.handleApiError(responseCode: code, message: msg);
      // }
    } catch (error) {
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: commonPostModel.message ?? "Something went wrong",
      );
      mailVerifyLoading = false;
      rethrow;
    } finally {
      mailVerifyLoading = false;
    }
  }

  // ---------------- TIMER ----------------
  void startTimer() {
    canResend.value = false;
    seconds.value = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds.value == 0) {
        canResend.value = true;
        t.cancel();
      } else {
        seconds.value--;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
