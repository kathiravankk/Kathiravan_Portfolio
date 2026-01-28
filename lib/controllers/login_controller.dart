import 'dart:async';
import 'package:get/get.dart';
import 'package:internsharks/app/data/models/common_post_model.dart';
import '../core/const_file/api_error_handling.dart';
import '../provider/auth_provider.dart';

class LoginController extends GetxController {
  final AuthProvider? loginProvider;

  LoginController(this.loginProvider);

  // ================= RESPONSE =================
  int getResponseCode() => loginProvider!.responseStatus;

  // ================= INPUT =================
  final mobile = ''.obs;
  final email = ''.obs;
  final otp = ''.obs;  final usertype = ''.obs;

  // ================= LOADING STATES =================
  final _loginLoading = false.obs;

  bool get loginLoading => _loginLoading.value;

  set loginLoading(bool v) => _loginLoading.value = v;

  final _verifyLoading = false.obs;

  bool get verifyLoading => _verifyLoading.value;

  set verifyLoading(bool v) => _verifyLoading.value = v;

  final _registerLoading = false.obs;

  bool get registerLoading => _registerLoading.value;

  set registerLoading(bool v) => _registerLoading.value = v;

  final _registerVerifyLoading = false.obs;

  bool get registerVerifyLoading => _registerVerifyLoading.value;

  set registerVerifyLoading(bool v) => _registerVerifyLoading.value = v;

  final _mailLoginLoading = false.obs;

  bool get mailLoginLoading => _mailLoginLoading.value;

  set mailLoginLoading(bool v) => _mailLoginLoading.value = v;

  final _mailVerifyLoading = false.obs;

  bool get mailVerifyLoading => _mailVerifyLoading.value;

  set mailVerifyLoading(bool v) => _mailVerifyLoading.value = v;

  // ================= MODEL =================
  final _commonPostModel = CommonPostModel().obs;

  CommonPostModel get commonPostModel => _commonPostModel.value;

  set commonPostModel(CommonPostModel v) => _commonPostModel.value = v;

  // ================= OTP STATE =================

  final _otpSent = false.obs;

  bool get otpSent => _otpSent.value;

  set otpSent(bool v) => _otpSent.value = v;
/// register
  final _mobileOtpSent = false.obs;

  bool get mobileOtpSent => _mobileOtpSent.value;

  set mobileOtpSent(bool v) => _mobileOtpSent.value = v;

  /// mail
  final _emailOtpSent = false.obs;

  bool get emailOtpSent => _emailOtpSent.value;

  set emailOtpSent(bool v) => _emailOtpSent.value = v;

  final _otpVerified = false.obs;

  bool get otpVerified => _otpVerified.value;

  set otpVerified(bool v) => _otpVerified.value = v;

  // ================= TIMER =================
  final seconds = 30.obs;
  final canResend = false.obs;
  Timer? _timer;

  // =====================================================
  // ================= SEND MOBILE OTP ===================
  // =====================================================
  // Future<void> sendMobileOtp() async {
  //   registerLoading = true;
  //   otpSent = false;
  //
  //   try {
  //     commonPostModel = await loginProvider!.sendMobileOtp(mobile.value);
  //
  //     if ((getResponseCode() == 200|| getResponseCode() == 201)&& commonPostModel.success == true) {
  //       otpSent = true; // ✅ OTP FIELD OPEN
  //       startTimer();
  //     } else {
  //       otpSent = false;
  //       ApiErrorHandler.handleApiError(
  //         responseCode: getResponseCode(),
  //         message: commonPostModel.message ?? "Mobile not registered",
  //       );
  //     }
  //   } catch (e) {
  //     otpSent = false;
  //     ApiErrorHandler.handleApiError(
  //       responseCode: getResponseCode(),
  //       message: "Something went wrong",
  //     );
  //   } finally {
  //     registerLoading = false;
  //   }
  // }
  Future<void> sendMobileOtp() async {
    registerLoading = true;
    otpSent = false; // 🔴 ALWAYS RESET

    try {
      commonPostModel = await loginProvider!.sendMobileOtp(mobile.value);

      final message = (commonPostModel.message ?? "").toLowerCase();

      /// ✅ OTP ACTUALLY SENT
      if ((getResponseCode() == 200 || getResponseCode() == 201) &&
          message.contains("otp sent")) {
        otpSent = true; // 🔓 OTP FIELD OPEN
        startTimer();
      }
      /// ❌ MOBILE ALREADY REGISTERED / OTP NOT SENT
      else {
        otpSent = false; // 🔒 OTP FIELD CLOSED
        ApiErrorHandler.handleApiError(
          responseCode: getResponseCode(),
          message: commonPostModel.message ?? "Mobile already registered",
        );
      }
    } catch (e) {
      otpSent = false;
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: "Something went wrong",
      );
    } finally {
      registerLoading = false;
    }
  }

  // =====================================================
  // ================= VERIFY MOBILE OTP =================
  // =====================================================
  Future<void> verifyMobileOtp({
    required String mobile,
    required String otp,
  }) async {
    registerVerifyLoading = true;
    otpVerified = false;

    try {
      commonPostModel = await loginProvider!.verifyMobileOtp(
        mobile: mobile,
        otp: otp,
      );

      if ((getResponseCode() == 200 || getResponseCode() == 201) &&
          commonPostModel.success == true) {
        otpVerified = true; // ✅ OTP VERIFIED
      } else {
        otpVerified = false;
        ApiErrorHandler.handleApiError(
          responseCode: getResponseCode(),
          message: commonPostModel.message ?? "Invalid OTP",
        );
      }
    } catch (e) {
      otpVerified = false;
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: "Something went wrong",
      );
    } finally {
      registerVerifyLoading = false;
    }
  }

  // Future<void> loginSendMobileOtp() async {
  //   loginLoading = true;
  //   otpSent = false;
  //
  //   try {
  //     commonPostModel = await loginProvider!.loginSendMobileOtp(mobile.value);
  //
  //     if (getResponseCode() == 200 && commonPostModel.success == true) {
  //       otpSent = true; // ✅ OTP FIELD OPEN
  //       startTimer();
  //     } else {
  //       otpSent = false;
  //       ApiErrorHandler.handleApiError(
  //         responseCode: getResponseCode(),
  //         message: commonPostModel.message ?? "Mobile not registered",
  //       );
  //     }
  //   } catch (e) {
  //     otpSent = false;
  //     ApiErrorHandler.handleApiError(
  //       responseCode: getResponseCode(),
  //       message: "Something went wrong",
  //     );
  //   } finally {
  //     loginLoading = false;
  //   }
  // }
  Future<void> loginSendMobileOtp() async {
    loginLoading = true;
    mobileOtpSent = false;

    try {
      commonPostModel = await loginProvider!.loginSendMobileOtp(mobile.value);

      if ((getResponseCode() == 200 || getResponseCode() == 201) &&
          commonPostModel.success == true) {
        mobileOtpSent = true; // 🔥 OTP FIELD OPEN
        startTimer();
      } else {
        otpSent = false;
        ApiErrorHandler.handleApiError(
          responseCode: getResponseCode(),
          message: commonPostModel.message ?? "Mobile not registered",
        );
      }
    } catch (e) {
      otpSent = false;
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: "Something went wrong",
      );
    } finally {
      loginLoading = false;
    }
  }

  // =====================================================
  // ================= VERIFY MOBILE OTP =================
  // =====================================================
  Future<void> loginVerifyMobileOtp({
    required String mobile,
    required String otp,
  }) async {
    verifyLoading = true;
    otpVerified = false;

    try {
      commonPostModel = await loginProvider!.loginVerifyMobileOtp(
        mobile: mobile,
        otp: otp,
      );

      if (getResponseCode() == 200 && commonPostModel.success == true) {
        otpVerified = true; // ✅ OTP VERIFIED
      } else {
        otpVerified = false;
        ApiErrorHandler.handleApiError(
          responseCode: getResponseCode(),
          message: commonPostModel.message ?? "Invalid OTP",
        );
      }
    } catch (e) {
      otpVerified = false;
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: "Something went wrong",
      );
    } finally {
      verifyLoading = false;
    }
  }

  // =====================================================
  // ================= SEND EMAIL OTP ====================
  // =====================================================
  // Future<void> sendEmailOtp(String email) async {
  //   mailLoginLoading = true;
  //
  //   try {
  //     commonPostModel = await loginProvider!.sendEmailOtp(email);
  //
  //     if ((getResponseCode() == 200|| getResponseCode() == 201) && commonPostModel.success == true) {
  //       otpSent = true;
  //       startTimer();
  //     } else {
  //       ApiErrorHandler.handleApiError(
  //         responseCode: getResponseCode(),
  //         message: commonPostModel.message ?? "OTP failed",
  //       );
  //     }
  //   } catch (e) {
  //     ApiErrorHandler.handleApiError(
  //       responseCode: getResponseCode(),
  //       message: "Something went wrong",
  //     );
  //   } finally {
  //     mailLoginLoading = false;
  //   }
  // }
  Future<void> sendEmailOtp(String email) async {
    registerLoading = true;
    emailOtpSent = false; // 🔒 Always reset OTP state

    try {
      // API call
      commonPostModel = await loginProvider!.sendEmailOtp(email);

      final int statusCode = getResponseCode();
      final String message =
      (commonPostModel.message ?? "").toLowerCase();

      /// ✅ OTP SENT → EMAIL NOT REGISTERED
      if ((statusCode == 200 || statusCode == 201) &&
          message.contains("otp")) {

        emailOtpSent = true; // 🔓 OPEN OTP FIELD
        startTimer();
      }

      /// ❌ EMAIL ALREADY REGISTERED / OTHER API ERRORS
      else {
        emailOtpSent = false; // 🔒 KEEP OTP FIELD CLOSED

        ApiErrorHandler.handleApiError(
          responseCode: statusCode,
          message: commonPostModel.message ??
              "User already registered with this email",
        );
      }
    } catch (e) {
      // Network / unexpected error
      emailOtpSent = false;

      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: "Something went wrong. Please try again",
      );
    } finally {
      registerLoading = false;
    }
  }

  // Future<void> sendEmailOtp(String email) async {
  //   registerLoading = true;
  //   emailOtpSent = false; // 🔴 always reset
  //
  //   try {
  //     commonPostModel =
  //     await loginProvider!.sendEmailOtp(email);
  //
  //     final message =
  //     (commonPostModel.message ?? "").toLowerCase();
  //
  //     /// ✅ OTP SENT → EMAIL NOT REGISTERED
  //     if ((getResponseCode() == 200 || getResponseCode() == 201) &&
  //         message.contains("otp sent")) {
  //
  //       emailOtpSent = true;   // 🔓 OPEN OTP FIELD
  //       startTimer();
  //     }
  //
  //     /// ❌ EMAIL ALREADY REGISTERED
  //     else {
  //       emailOtpSent = false;  // 🔒 DO NOT OPEN OTP FIELD
  //       ApiErrorHandler.handleApiError(
  //         responseCode: getResponseCode(),
  //         message:
  //         commonPostModel.message ?? "Email already registered",
  //       );
  //     }
  //   } catch (e) {
  //     emailOtpSent = false;
  //     ApiErrorHandler.handleApiError(
  //       responseCode: getResponseCode(),
  //       message: "Something went wrong",
  //     );
  //   } finally {
  //     registerLoading = false;
  //   }
  // }


  // =====================================================
  // ================= VERIFY EMAIL OTP ==================
  // =====================================================
  Future<void> verifyEmailOtp(String otpValue, String email,String usertype) async {
    mailVerifyLoading = true;

    try {
      commonPostModel = await loginProvider!.verifyEmailOtp(otpValue, email,usertype);

      if (getResponseCode() == 200 && commonPostModel.success == true) {
        otpVerified = true;
      } else {
        ApiErrorHandler.handleApiError(
          responseCode: getResponseCode(),
          message: commonPostModel.message ?? "Invalid OTP",
        );
      }
    } catch (e) {
      ApiErrorHandler.handleApiError(
        responseCode: getResponseCode(),
        message: "Something went wrong",
      );
    } finally {
      mailVerifyLoading = false;
    }
  }

  // =====================================================
  // ================= TIMER LOGIC =======================
  // =====================================================
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
