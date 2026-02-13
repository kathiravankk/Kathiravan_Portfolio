import 'dart:async';
import 'package:get/get.dart';
import 'package:internsharks/app/data/models/account/common_post_model.dart';
import 'package:internsharks/app/data/models/account/kyc_update_model.dart';
import 'package:internsharks/app/data/models/account/profile_update_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/resume_extract_model.dart';
import 'package:internsharks/app/data/models/account/student_profile_model.dart';
import 'package:internsharks/app/data/models/account/student_register_model.dart';
import 'package:internsharks/app/data/providers/register_provider.dart';
import 'package:internsharks/app/data/repositories/resume_storage_service.dart';

class RegisterController extends GetxController {
  final RegisterProvider? registerProvider;

  RegisterController(this.registerProvider);

  int getResponseCode() => registerProvider!.responseStatus;

  final uploadProgress = 0.0.obs;

  // Loading

  final _resumeExtractLoading = false.obs;

  bool get resumeExtractLoading => _resumeExtractLoading.value;

  set resumeExtractLoading(bool value) => _resumeExtractLoading.value = value;

  //Model

  final _resumeExtractModel = ResumeExtractModel().obs;

  ResumeExtractModel get resumeExtractModel => _resumeExtractModel.value;

  set resumeExtractModel(ResumeExtractModel value) =>
      _resumeExtractModel.value = value;

  final _commonPostModel = CommonPostModel().obs;

  CommonPostModel get commonPostModel => _commonPostModel.value;

  set commonPostModel(CommonPostModel value) => _commonPostModel.value = value;

  //UPLOAD RESUME

  Future<void> extractResumeData(String? filePath) async {
    resumeExtractLoading = true;
    uploadProgress.value = 0;
    try {
      resumeExtractModel = await registerProvider!.uploadExtractResume(
        filePath: filePath!,
        onProgress: (sent, total) {
          if (total != 0) {
            uploadProgress.value = sent / total;
          }
        },
      );
      uploadProgress.value = 1.0;
      resumeExtractLoading = false;
    } catch (error) {
      uploadProgress.value = 0;
      resumeExtractLoading = false;
      rethrow;
    }
  }

  // Mobile OTP

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
      commonPostModel = await registerProvider!.registerSendOtp(
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
      commonPostModel = await registerProvider!.registerVerifyOtp(
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

  Future<void> sendEmailOtp({required String emailAddress}) async {
    try {
      sendEmailOtpLoading = true;
      commonPostModel = await registerProvider!.registerSendEmailOtp(
        emailAddress: emailAddress,
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
      commonPostModel = await registerProvider!.registerVerifyEmailOtp(
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

  // STUDENT REGISTER

  final _studentRegisterLoading = false.obs;

  bool get studentRegisterLoading => _studentRegisterLoading.value;

  set studentRegisterLoading(bool value) =>
      _studentRegisterLoading.value = value;

  final _studentRegisterModel = StudentRegisterModel().obs;

  StudentRegisterModel get studentRegisterModel => _studentRegisterModel.value;

  set studentRegisterModel(StudentRegisterModel value) =>
      _studentRegisterModel.value = value;

  Future<void> registerNewStudent({
    required Map<String, dynamic> registerData,
  }) async {
    try {
      studentRegisterLoading = true;
      studentRegisterModel = await registerProvider!.newStudentRegister(
        registerData: registerData,
      );
      if (getResponseCode() == 200 || getResponseCode() == 201) {
        getStudentProfile(studentId: studentRegisterModel.registerData!.id!);
      }
      studentRegisterLoading = false;
    } catch (err) {
      studentRegisterLoading = false;
      rethrow;
    }
  }

  // GET DETAILS FROM ID

  // Loading

  final _studentDetailsLoading = false.obs;

  bool get studentDetailsLoading => _studentDetailsLoading.value;

  set studentDetailsLoading(bool value) => _studentDetailsLoading.value = value;

  //Model

  final _studentProfileModel = StudentProfileModel().obs;

  StudentProfileModel get studentProfileModel => _studentProfileModel.value;

  set studentProfileModel(StudentProfileModel value) =>
      _studentProfileModel.value = value;

  Future<void> getStudentProfile({required String studentId}) async {
    try {
      studentDetailsLoading = true;
      studentProfileModel = await registerProvider!.fetchStudentData(
        studentId: studentId,
      );
      if (getResponseCode() == 200 || getResponseCode() == 201) {
        ResumeStorageService.saveNetworkResume(
          resumeFile: studentProfileModel.studentResume!,
        );
      }
      studentDetailsLoading = false;
    } catch (err) {
      studentDetailsLoading = false;
      rethrow;
    }
  }

  // ANALYZE RESUME SCORE

  // Loading

  final _resumeScoreLoading = false.obs;

  bool get resumeScoreLoading => _resumeScoreLoading.value;

  set resumeScoreLoading(bool value) => _resumeScoreLoading.value = value;

  //Model

  final _resumeAnalyzeModel = ResumeAnalysisModel().obs;

  ResumeAnalysisModel get resumeAnalyzeModel => _resumeAnalyzeModel.value;

  set resumeAnalyzeModel(ResumeAnalysisModel value) =>
      _resumeAnalyzeModel.value = value;

  Future<void> checkResumeScore({required String resumeUrl}) async {
    try {
      resumeScoreLoading = true;
      resumeAnalyzeModel = await registerProvider!.analyzeResumeScore(
        resumeUrl: resumeUrl,
      );
      resumeScoreLoading = false;
    } catch (err) {
      resumeScoreLoading = false;
      rethrow;
    }
  }

  // UPDATE RESUME

  // Loading

  final _updateResumeLoading = false.obs;

  bool get updateResumeLoading => _updateResumeLoading.value;

  set updateResumeLoading(bool value) => _updateResumeLoading.value = value;

  //Model

  final _extractedResumeModel = ExtractedResumeDataModel().obs;

  ExtractedResumeDataModel get extractedResumeModel => _extractedResumeModel.value;

  set extractedResumeModel(ExtractedResumeDataModel value) =>
      _extractedResumeModel.value = value;

  Future<void> updateResumeData({required ExtractedResumeDataModel updateData}) async {
    try {
      updateResumeLoading = true;
      extractedResumeModel = await registerProvider!.postUpdateResume(
        updateData: updateData,
      );
      updateResumeLoading = false;
    } catch (err) {
      updateResumeLoading = false;
      rethrow;
    }
  }

  // UPDATE STUDENT PROFILE

  // Loading

  final _updateProfileLoading = false.obs;

  bool get updateProfileLoading => _updateProfileLoading.value;

  set updateProfileLoading(bool value) => _updateProfileLoading.value = value;

  //Model

  final _updateProfileModel = ProfileUpdateModel().obs;

  ProfileUpdateModel get updateProfileModel => _updateProfileModel.value;

  set updateProfileModel(ProfileUpdateModel value) =>
      _updateProfileModel.value = value;

  Future<void> updateStudentProfileData({required Map<String, dynamic> updateData}) async {
    try {
      updateProfileLoading = true;
      updateProfileModel = await registerProvider!.putUpdateProfile(
        updateData: updateData,
      );
      updateProfileLoading = false;
    } catch (err) {
      updateProfileLoading = false;
      rethrow;
    }
  }

  // RESUME & PROFILE UPDATE

  // Loading

  final _updateResumeTemplateLoading = false.obs;

  bool get updateResumeTemplateLoading => _updateResumeTemplateLoading.value;

  set updateResumeTemplateLoading(bool value) => _updateResumeTemplateLoading.value = value;



  Future<void> updateResumeProfileData({required ExtractedResumeDataModel? updateData}) async {
    try {
      updateResumeTemplateLoading = true;
      updateProfileModel = await registerProvider!.putUpdateResume(
        updateData: updateData,
      );
      updateResumeTemplateLoading = false;
    } catch (err) {
      updateResumeTemplateLoading = false;
      rethrow;
    }
  }

  // KYC VERIFICATION

  // Loading

  final _kycVerificationLoading = false.obs;

  bool get kycVerificationLoading => _kycVerificationLoading.value;

  set kycVerificationLoading(bool value) => _kycVerificationLoading.value = value;

  //Model

  final _kycUpdateModel = KycUpdateModel().obs;

  KycUpdateModel get kycUpdateModel => _kycUpdateModel.value;

  set kycUpdateModel(KycUpdateModel value) =>
      _kycUpdateModel.value = value;

  Future<void> verifyKycData({required Map<String, dynamic> kycData}) async {
    try {
      kycVerificationLoading = true;
      kycUpdateModel = await registerProvider!.kycVerification(
        kycData: kycData,
      );
      kycVerificationLoading = false;
    } catch (err) {
      kycVerificationLoading = false;
      rethrow;
    }
  }
}
