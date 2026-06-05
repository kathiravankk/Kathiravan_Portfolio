import 'dart:async';
import 'package:get/get.dart';
import 'package:internsharks/app/data/models/account/common_post_model.dart';
import 'package:internsharks/app/data/models/account/student_register_model.dart';
import 'package:internsharks/app/data/providers/login_provider.dart';

class LoginController extends GetxController {
  final LoginProvider? loginProvider;

  LoginController(this.loginProvider);

  int getResponseCode() => loginProvider!.responseStatus;

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

  final _commonPostModel = CommonPostModel().obs;

  CommonPostModel get commonPostModel => _commonPostModel.value;

  set commonPostModel(CommonPostModel value) => _commonPostModel.value = value;

  Future<void> sendLoginOtp({required String mobileNumber}) async {
    try {
      otpSent = false;
      loginOtpLoading = true;
      commonPostModel = await loginProvider!.postLoginOtp(
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

  final _studentRegisterModel = StudentRegisterModel().obs;

  StudentRegisterModel get studentRegisterModel => _studentRegisterModel.value;

  set studentRegisterModel(StudentRegisterModel value) =>
      _studentRegisterModel.value = value;

  Future<void> verifyLoginOtp({
    required String mobileNumber,
    required String otpNumber,
    required String userType,
    required String fcmToken,
  }) async {
    try {
      loginVerifyLoading = true;
      studentRegisterModel = await loginProvider!.loginVerifyOtp(
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
