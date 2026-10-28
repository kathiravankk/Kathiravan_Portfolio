import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_register_provider.dart';

class NewRecruiterRegisterController extends GetxController {
  final RecruiterRegisterProvider? recruiterRegisterProvider;

  NewRecruiterRegisterController(this.recruiterRegisterProvider);

  int getResponseCode() => recruiterRegisterProvider!.responseStatus;

  // ─── TEXT CONTROLLERS ───────────────────────────────────────────

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final designationController = TextEditingController();
  final referralCodeController = TextEditingController();

  // ─── DESIGNATION DROPDOWN ───────────────────────────────────────

  final selectedDesignation = ''.obs;

  final List<String> designationOptions = [
    'Admin',
    'HR Manager',
    'Recruiter',
    'Talent Acquisition',
    'Hiring Manager',
    'Team Lead',
    'Founder / CEO',
    'CTO',
    'Other',
  ];

  // ─── EMAIL VERIFICATION STATE ───────────────────────────────────

  final _sendEmailOtpModel = SendEmailOtpModel().obs;

  SendEmailOtpModel get sendEmailOtpModel => _sendEmailOtpModel.value;

  set sendEmailOtpModel(SendEmailOtpModel value) =>
      _sendEmailOtpModel.value = value;

  final _verifyEmailOtpModel = VerifyEmailOtpModel().obs;

  VerifyEmailOtpModel get verifyEmailOtpModel => _verifyEmailOtpModel.value;

  set verifyEmailOtpModel(VerifyEmailOtpModel value) =>
      _verifyEmailOtpModel.value = value;

  final showEmailOtpField = false.obs;
  final isEmailVerified = false.obs;
  final emailResendSeconds = 0.obs;
  final verifiedEmail = ''.obs;

  final _sendEmailOtpLoading = false.obs;

  bool get sendEmailOtpLoading => _sendEmailOtpLoading.value;

  set sendEmailOtpLoading(bool value) => _sendEmailOtpLoading.value = value;

  final _verifyEmailOtpLoading = false.obs;

  bool get verifyEmailOtpLoading => _verifyEmailOtpLoading.value;

  set verifyEmailOtpLoading(bool value) => _verifyEmailOtpLoading.value = value;

  Timer? _emailTimer;

  // ─── MOBILE VERIFICATION STATE ──────────────────────────────────

  final _sendMobileOtpModel = SendMobileOtpModel().obs;

  SendMobileOtpModel get sendMobileOtpModel => _sendMobileOtpModel.value;

  set sendMobileOtpModel(SendMobileOtpModel value) =>
      _sendMobileOtpModel.value = value;

  final _verifyMobileOtpModel = VerifyMobileOtpModel().obs;

  VerifyMobileOtpModel get verifyMobileOtpModel => _verifyMobileOtpModel.value;

  set verifyMobileOtpModel(VerifyMobileOtpModel value) =>
      _verifyMobileOtpModel.value = value;

  final showMobileOtpField = false.obs;
  final isMobileVerified = false.obs;
  final mobileResendSeconds = 0.obs;
  final verifiedMobile = ''.obs;

  // Country code state (defaults to +91 India)
  final selectedCountryCode = '+91'.obs;
  final selectedCountryFlag = '🇮🇳'.obs;
  final selectedCountryName = 'India'.obs;

  void setCountryCode(String code, String flag, String name) {
    if (selectedCountryCode.value != code) {
      selectedCountryCode.value = code;
      selectedCountryFlag.value = flag;
      selectedCountryName.value = name;
      // Reset mobile verification if country code changed
      isMobileVerified.value = false;
      showMobileOtpField.value = false;
      verifiedMobile.value = '';
    }
  }

  bool get isContinueEnabled =>
      isMobileVerified.value && isEmailVerified.value;

  final _sendMobileOtpLoading = false.obs;

  bool get sendMobileOtpLoading => _sendMobileOtpLoading.value;

  set sendMobileOtpLoading(bool value) => _sendMobileOtpLoading.value = value;

  final _verifyMobileOtpLoading = false.obs;

  bool get verifyMobileOtpLoading => _verifyMobileOtpLoading.value;

  set verifyMobileOtpLoading(bool value) =>
      _verifyMobileOtpLoading.value = value;

  Timer? _mobileTimer;

  // ─── EMAIL OTP METHODS ──────────────────────────────────────────

  Future<void> sendEmailOtp() async {
    final emailError = AppFunctions.validateEmail(
      newEmail: emailController.text,
      currentEmail: null,
    );

    if (emailError != null) {
      AppAlertUtils.showToast(message: emailError, isError: true);
      return;
    }

    final nameError = AppFunctions.validateName(nameController.text);
    if (nameError != null) {
      AppAlertUtils.showToast(
        message: "Please enter your name first",
        isError: true,
      );
      return;
    }

    try {
      sendEmailOtpLoading = true;
      sendEmailOtpModel =
          await recruiterRegisterProvider!.registerEmailSendOtp(
        emailAddress: emailController.text.trim(),
        userName: nameController.text.trim(),
      );
      sendEmailOtpLoading = false;

      if (getResponseCode() == 200 || getResponseCode() == 201) {
        showEmailOtpField.value = true;
        AppAlertUtils.showToast(
          message: "OTP sent to your email",
          isError: false,
        );
        _startEmailResendTimer();
      } else {
        AppFunctions.apiErrorHandling(
          getResponseCode(),
          sendEmailOtpModel.message ?? "Failed to send OTP!",
        );
      }
    } catch (err) {
      sendEmailOtpLoading = false;
      AppFunctions.apiErrorHandling(
        getResponseCode(),
        sendEmailOtpModel.message ?? "Failed to send OTP!",
      );
    }
  }

  Future<void> verifyEmailOtp({required String otpCode}) async {
    try {
      verifyEmailOtpLoading = true;
      verifyEmailOtpModel =
          await recruiterRegisterProvider!.registerEmailVerifyOtp(
        emailAddress: emailController.text.trim(),
        otpNumber: otpCode,
      );
      verifyEmailOtpLoading = false;

      if (getResponseCode() == 200 || getResponseCode() == 201) {
        isEmailVerified.value = true;
        showEmailOtpField.value = false;
        verifiedEmail.value = emailController.text.trim();
        emailResendSeconds.value = 0;
        _emailTimer?.cancel();
        AppAlertUtils.showToast(
          message: "Email verified successfully",
          isError: false,
        );
      } else {
        AppFunctions.apiErrorHandling(
          getResponseCode(),
          verifyEmailOtpModel.message ?? "Failed to verify OTP!",
        );
      }
    } catch (err) {
      verifyEmailOtpLoading = false;
      AppFunctions.apiErrorHandling(
        getResponseCode(),
        verifyEmailOtpModel.message ?? "Failed to verify OTP!",
      );
    }
  }

  void _startEmailResendTimer() {
    emailResendSeconds.value = 30;
    _emailTimer?.cancel();
    _emailTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (emailResendSeconds.value <= 0) {
        timer.cancel();
      } else {
        emailResendSeconds.value--;
      }
    });
  }

  /// Reset email verification if the email text changes after verification
  void onEmailChanged(String value) {
    if (isEmailVerified.value && value.trim() != verifiedEmail.value) {
      isEmailVerified.value = false;
      showEmailOtpField.value = false;
    }
  }

  // ─── MOBILE OTP METHODS ─────────────────────────────────────────

  Future<void> sendMobileOtp() async {
    final mobileError = validateMobileNumber(mobileController.text);

    if (mobileError != null) {
      AppAlertUtils.showToast(message: mobileError, isError: true);
      return;
    }

    try {
      sendMobileOtpLoading = true;
      sendMobileOtpModel =
          await recruiterRegisterProvider!.registerSendMobileOtp(
        mobileNumber: mobileController.text.trim(),
        countryCode: selectedCountryCode.value,
      );
      sendMobileOtpLoading = false;

      if (getResponseCode() == 200 || getResponseCode() == 201) {
        showMobileOtpField.value = true;
        AppAlertUtils.showToast(
          message: "OTP sent to your mobile",
          isError: false,
        );
        _startMobileResendTimer();
      } else {
        AppFunctions.apiErrorHandling(
          getResponseCode(),
          sendMobileOtpModel.message ?? "Failed to send OTP!",
        );
      }
    } catch (err) {
      sendMobileOtpLoading = false;
      AppFunctions.apiErrorHandling(
        getResponseCode(),
        sendMobileOtpModel.message ?? "Failed to send OTP!",
      );
    }
  }

  Future<void> verifyMobileOtp({required String otpCode}) async {
    try {
      verifyMobileOtpLoading = true;
      verifyMobileOtpModel =
          await recruiterRegisterProvider!.registerVerifyMobileOtp(
        mobileNumber: mobileController.text.trim(),
        otpNumber: otpCode,
        countryCode: selectedCountryCode.value,
      );
      verifyMobileOtpLoading = false;

      if (getResponseCode() == 200 || getResponseCode() == 201) {
        isMobileVerified.value = true;
        showMobileOtpField.value = false;
        verifiedMobile.value = mobileController.text.trim();
        mobileResendSeconds.value = 0;
        _mobileTimer?.cancel();
        AppAlertUtils.showToast(
          message: "Mobile verified successfully",
          isError: false,
        );
      } else {
        AppFunctions.apiErrorHandling(
          getResponseCode(),
          verifyMobileOtpModel.message ?? "Failed to verify OTP!",
        );
      }
    } catch (err) {
      verifyMobileOtpLoading = false;
      AppFunctions.apiErrorHandling(
        getResponseCode(),
        verifyMobileOtpModel.message ?? "Failed to verify OTP!",
      );
    }
  }

  void _startMobileResendTimer() {
    mobileResendSeconds.value = 30;
    _mobileTimer?.cancel();
    _mobileTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mobileResendSeconds.value <= 0) {
        timer.cancel();
      } else {
        mobileResendSeconds.value--;
      }
    });
  }

  /// Reset mobile verification if the mobile text changes after verification
  void onMobileChanged(String value) {
    if (isMobileVerified.value && value.trim() != verifiedMobile.value) {
      isMobileVerified.value = false;
      showMobileOtpField.value = false;
    }
  }

  // ─── FORM VALIDATION ───────────────────────────────────────────

  String? validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Mobile number is required";
    }

    final mobile = value.trim();

    if (!RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      return "Only numbers are allowed";
    }

    if (selectedCountryCode.value == "+91") {
      return AppFunctions.validateIndianMobile(mobile);
    } else {
      if (mobile.length < 7 || mobile.length > 15) {
        return "Please enter a valid phone number (7-15 digits)";
      }
    }
    return null;
  }

  String? validateStep1() {
    final nameError = AppFunctions.validateName(nameController.text);
    if (nameError != null) return nameError;

    final emailError = AppFunctions.validateEmail(
      newEmail: emailController.text,
      currentEmail: null,
    );
    if (emailError != null) return emailError;

    if (!isEmailVerified.value) return "Please verify your email";

    final mobileError = validateMobileNumber(mobileController.text);
    if (mobileError != null) return mobileError;

    if (!isMobileVerified.value) return "Please verify your mobile number";

    if (selectedDesignation.value.isEmpty &&
        designationController.text.isEmpty) {
      return "Please select a designation";
    }

    return null;
  }

  /// Collects step 1 data for passing to step 2
  Map<String, dynamic> getStep1Data() {
    return {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "mobile": mobileController.text.trim(),
      "countryCode": selectedCountryCode.value,
      "designation": selectedDesignation.value.isNotEmpty
          ? selectedDesignation.value
          : designationController.text.trim(),
      "referralCode": referralCodeController.text.trim(),
    };
  }

  // ─── HELPER ─────────────────────────────────────────────────────

  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    _emailTimer?.cancel();
    _mobileTimer?.cancel();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    designationController.dispose();
    referralCodeController.dispose();
    super.onClose();
  }
}
