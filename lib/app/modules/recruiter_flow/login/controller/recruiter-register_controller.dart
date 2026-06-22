import 'dart:async';

import 'package:get/get.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/add_shortlist-students_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_register_model.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_register_provider.dart';

class RecruiterRegisterController extends GetxController {
  final RecruiterRegisterProvider? recruiterRegisterProvider;

  RecruiterRegisterController(this.recruiterRegisterProvider);

  int getResponseCode() => recruiterRegisterProvider!.responseStatus;

  // Mobile OTP

  //Models

  //SEND OTP

  final _sendMobileOtpModel = SendMobileOtpModel().obs;

  SendMobileOtpModel get sendMobileOtpModel => _sendMobileOtpModel.value;

  set sendMobileOtpModel(SendMobileOtpModel value) =>
      _sendMobileOtpModel.value = value;

  // VERIFY OTP

  final _verifyMobileOtpModel = VerifyMobileOtpModel().obs;

  VerifyMobileOtpModel get verifyMobileOtpModel => _verifyMobileOtpModel.value;

  set verifyMobileOtpModel(VerifyMobileOtpModel value) =>
      _verifyMobileOtpModel.value = value;

  // SEND EMAIL OTP

  final _sendEmailOtpModel = SendEmailOtpModel().obs;

  SendEmailOtpModel get sendEmailOtpModel => _sendEmailOtpModel.value;

  set sendEmailOtpModel(SendEmailOtpModel value) =>
      _sendEmailOtpModel.value = value;

  // VERIFY EMAIL OTP

  final _verifyEmailOtpModel = VerifyEmailOtpModel().obs;

  VerifyEmailOtpModel get verifyEmailOtpModel => _verifyEmailOtpModel.value;

  set verifyEmailOtpModel(VerifyEmailOtpModel value) =>
      _verifyEmailOtpModel.value = value;

  // MOBILE
  final showMobileOtpField = false.obs;
  final isMobileVerified = false.obs;
  final mobileResendSeconds = 0.obs;

  final _sendMobileOtpLoading = false.obs;

  bool get sendMobileOtpLoading => _sendMobileOtpLoading.value;

  set sendMobileOtpLoading(bool value) => _sendMobileOtpLoading.value = value;

  Future<void> sendMobileOtp({required String mobileNumber}) async {
    try {
      sendMobileOtpLoading = true;
      sendMobileOtpModel = await recruiterRegisterProvider!.registerSendMobileOtp(
        mobileNumber: mobileNumber,
      );
      sendMobileOtpLoading = false;

      if (getResponseCode() == 200) {
        showMobileOtpField.value = true;

        startMobileResendTimer();
      }
    } catch (err) {
      sendMobileOtpLoading = false;
      rethrow;
    }
  }

  final _verifyMobileOtpLoading = false.obs;

  bool get verifyMobileOtpLoading => _verifyMobileOtpLoading.value;

  set verifyMobileOtpLoading(bool value) =>
      _verifyMobileOtpLoading.value = value;

  Future<void> verifyMobileOtp({
    required String mobileNumber,
    required String otpNumber,
  }) async {
    try {
      verifyMobileOtpLoading = true;
      verifyMobileOtpModel = await recruiterRegisterProvider!.registerVerifyMobileOtp(
        mobileNumber: mobileNumber,
        otpNumber: otpNumber,
      );
      verifyMobileOtpLoading = false;

      if (getResponseCode() == 200) {
        isMobileVerified.value = true;
        mobileResendSeconds.value = 0;
      }
    } catch (err) {
      verifyMobileOtpLoading = false;
      rethrow;
    }
  }

  void startMobileResendTimer() {
    mobileResendSeconds.value = 30;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mobileResendSeconds.value == 0) {
        timer.cancel();
      } else {
        mobileResendSeconds.value--;
      }
    });
  }

  // Email OTP

  final showEmailOtpField = false.obs;
  final isEmailVerified = false.obs;
  final emailResendSeconds = 0.obs;

  final _sendEmailOtpLoading = false.obs;

  bool get sendEmailOtpLoading => _sendEmailOtpLoading.value;

  set sendEmailOtpLoading(bool value) => _sendEmailOtpLoading.value = value;

  Future<void> sendEmailOtp({required String emailAddress, required String userName}) async {
    try {
      sendEmailOtpLoading = true;
      sendEmailOtpModel = await recruiterRegisterProvider!.registerEmailSendOtp(
        emailAddress: emailAddress,
        userName: userName
      );
      sendEmailOtpLoading = false;
      if (getResponseCode() == 200) {
        showEmailOtpField.value = true;
        startEmailResendTimer();
      }
    } catch (err) {
      sendEmailOtpLoading = false;
      rethrow;
    }
  }

  final _verifyEmailOtpLoading = false.obs;

  bool get verifyEmailOtpLoading => _verifyEmailOtpLoading.value;

  set verifyEmailOtpLoading(bool value) => _verifyEmailOtpLoading.value = value;

  Future<void> verifyEmailOtp({
    required String emailAddress,
    required String otpNumber,
  }) async {
    try {
      verifyEmailOtpLoading = true;
      verifyEmailOtpModel = await recruiterRegisterProvider!.registerEmailVerifyOtp(
        emailAddress: emailAddress,
        otpNumber: otpNumber,
      );
      verifyEmailOtpLoading = false;
      if (getResponseCode() == 200) {
        isEmailVerified.value = true;
        emailResendSeconds.value = 0;
      }
    } catch (err) {
      verifyEmailOtpLoading = false;
      rethrow;
    }
  }

  void startEmailResendTimer() {
    emailResendSeconds.value = 30;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (emailResendSeconds.value == 0) {
        timer.cancel();
      } else {
        emailResendSeconds.value--;
      }
    });
  }

  // CHECK EXIST ACCOUNT

  final _checkExistLoading = false.obs;

  bool get checkExistLoading => _checkExistLoading.value;

  set checkExistLoading(bool value) => _checkExistLoading.value = value;

  // Model

  final _commonPostModel = CommonLoginOtpModel().obs;

  CommonLoginOtpModel get commonPostModel =>
      _commonPostModel.value;

  set commonPostModel(CommonLoginOtpModel value) =>
      _commonPostModel.value = value;

  Future<void> checkExistAccount({
    required String emailAddress,
    required String mobileNumber,
  }) async {
    try {
      checkExistLoading = true;
      commonPostModel = await recruiterRegisterProvider!.checkExistAccount(
        emailAddress: emailAddress,
        mobileNumber: mobileNumber,
      );
      checkExistLoading = false;
    } catch (err) {
      checkExistLoading = false;
      rethrow;
    }
  }

  // RECRUITER REGISTER

  final _registerLoading = false.obs;

  bool get registerLoading => _registerLoading.value;

  set registerLoading(bool value) => _registerLoading.value = value;

  // Model

  final _registerModel = RecruiterRegisterModel().obs;

  RecruiterRegisterModel get registerModel =>
      _registerModel.value;

  set registerModel(RecruiterRegisterModel value) =>
      _registerModel.value = value;

  Future<void> newRecruiterRegister({
    required Map<String, dynamic> registerData,
  }) async {
    try {
      registerLoading = true;
      registerModel = await recruiterRegisterProvider!.newRecruiterRegister(
        registerData: registerData
      );
      registerLoading = false;
    } catch (err) {
      registerLoading = false;
      rethrow;
    }
  }



}