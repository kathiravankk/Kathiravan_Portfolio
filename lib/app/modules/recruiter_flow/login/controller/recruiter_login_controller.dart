import 'dart:async';
import 'package:get/get.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_login_model.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_login_provider.dart';

class RecruiterLoginController extends GetxController {
  final RecruiterLoginProvider? recruiterLoginProvider;

  RecruiterLoginController(this.recruiterLoginProvider);

  int getResponseCode() => recruiterLoginProvider!.responseStatus;

  // ================= TIMER =================
  final seconds = 30.obs;
  final canResend = false.obs;
  Timer? _timer;

  // ================= INPUT =================
  final mobile = ''.obs;
  final email = ''.obs;
  final otp = ''.obs;
  final usertype = ''.obs;

  // ================= OTP STATE =================

  final _otpSent = false.obs;

  bool get otpSent => _otpSent.value;

  set otpSent(bool v) => _otpSent.value = v;

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

  //Login
  final _loginOtpLoading = false.obs;

  bool get loginOtpLoading => _loginOtpLoading.value;

  set loginOtpLoading(bool value) => _loginOtpLoading.value = value;

  final _commonPostModel = CommonLoginOtpModel().obs;

  CommonLoginOtpModel get commonPostModel => _commonPostModel.value;

  set commonPostModel(CommonLoginOtpModel value) => _commonPostModel.value = value;

  Future<void> sendLoginOtp({required String mobileNumber}) async {
    try {
      otpSent = false;
      loginOtpLoading = true;
      commonPostModel = await recruiterLoginProvider!.postLoginOtp(
        mobileNumber: mobileNumber,
      );
      if (getResponseCode() == 200 || getResponseCode() == 201) {
        otpSent = true;
        startTimer();
      }
      loginOtpLoading = false;
    } catch (err) {
      loginOtpLoading = false;
      rethrow;
    }
  }

  final _loginVerifyLoading = false.obs;

  bool get loginVerifyLoading => _loginVerifyLoading.value;

  set loginVerifyLoading(bool value) => _loginVerifyLoading.value = value;

  //Model

  final _recruiterLoginModel = RecruiterLoginModel().obs;

  RecruiterLoginModel get recruiterLoginModel => _recruiterLoginModel.value;

  set recruiterLoginModel(RecruiterLoginModel value) =>
      _recruiterLoginModel.value = value;

  Future<void> verifyLoginOtp({
    required String mobileNumber,
    required String otpNumber,
    required String userType,
    required String fcmToken,
  }) async {
    try {
      loginVerifyLoading = true;
      recruiterLoginModel = await recruiterLoginProvider!.loginVerifyOtp(
          mobileNumber: mobileNumber,
          otpNumber: otpNumber,
          userType: userType,
          fcmToken: fcmToken
      );
      loginVerifyLoading = false;
    } catch (err) {
      loginVerifyLoading = false;
      rethrow;
    }
  }

}