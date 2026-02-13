import 'package:get/get.dart';
import 'package:internsharks/app/data/models/account/common_post_model.dart';
import 'package:internsharks/app/data/models/home/profile_data_model.dart';
import 'package:internsharks/app/data/models/home/saved_internship_model.dart';
import 'package:internsharks/app/data/providers/profile_provider.dart';

class ProfileController extends GetxController {
  final ProfileProvider? profileProvider;

  ProfileController(this.profileProvider);

  int getResponseCode() => profileProvider!.responseStatus;

  // GET STUDENT PROFILE DATA

  // Loading

  final _profileDataLoading = false.obs;

  bool get profileDataLoading => _profileDataLoading.value;

  set profileDataLoading(bool value) => _profileDataLoading.value = value;

  // Model

  final _profileDataModel = ProfileDataModel().obs;

  ProfileDataModel get profileDataModel => _profileDataModel.value;

  set profileDataModel(ProfileDataModel value) =>
      _profileDataModel.value = value;

  Future<void> getProfileData({required String studentId}) async {
    try {
      profileDataLoading = true;
      profileDataModel = await profileProvider!.fetchProfileData(
        studentId: studentId,
      );
      profileDataLoading = false;
    } catch (err) {
      profileDataLoading = false;
      rethrow;
    }
  }

  // SEND UPDATE MOBILE OTP

  // Loading

  final _mobileOtpSendLoading = false.obs;

  bool get mobileOtpSendLoading => _mobileOtpSendLoading.value;

  set mobileOtpSendLoading(bool value) => _mobileOtpSendLoading.value = value;

  // Model

  final _commonPostModel = CommonPostModel().obs;

  CommonPostModel get commonPostModel => _commonPostModel.value;

  set commonPostModel(CommonPostModel value) => _commonPostModel.value = value;

  Future<void> sendUpdateMobileOtp({required String mobileNo}) async {
    try {
      mobileOtpSendLoading = true;
      commonPostModel = await profileProvider!.postUpdateMobileOtp(
        mobileNo: mobileNo,
      );
      mobileOtpSendLoading = false;
    } catch (err) {
      mobileOtpSendLoading = false;
      rethrow;
    }
  }

  // VERIFY UPDATE MOBILE OTP

  // Loading

  final _mobileOtpVerifyLoading = false.obs;

  bool get mobileOtpVerifyLoading => _mobileOtpVerifyLoading.value;

  set mobileOtpVerifyLoading(bool value) =>
      _mobileOtpVerifyLoading.value = value;

  Future<void> verifyUpdateMobileOtp({
    required String mobileNo,
    required String otpNo,
  }) async {
    try {
      mobileOtpVerifyLoading = true;
      commonPostModel = await profileProvider!.verifyUpdateMobileOtp(
        mobileNo: mobileNo,
        otpNo: otpNo,
      );
      mobileOtpVerifyLoading = false;
    } catch (err) {
      mobileOtpVerifyLoading = false;
      rethrow;
    }
  }

  // SEND UPDATE EMAIL OTP

  // Loading

  final _emailOtpSendLoading = false.obs;

  bool get emailOtpSendLoading => _emailOtpSendLoading.value;

  set emailOtpSendLoading(bool value) => _emailOtpSendLoading.value = value;

  Future<void> sendUpdateEmailOtp({required String email}) async {
    try {
      emailOtpSendLoading = true;
      commonPostModel = await profileProvider!.postUpdateEmailOtp(email: email);
      emailOtpSendLoading = false;
    } catch (err) {
      emailOtpSendLoading = false;
      rethrow;
    }
  }

  // VERIFY UPDATE EMAIL OTP

  // Loading

  final _emailOtpVerifyLoading = false.obs;

  bool get emailOtpVerifyLoading => _emailOtpVerifyLoading.value;

  set emailOtpVerifyLoading(bool value) => _emailOtpVerifyLoading.value = value;

  Future<void> verifyUpdateEmailOtp({
    required String email,
    required String otpNo,
  }) async {
    try {
      emailOtpVerifyLoading = true;
      commonPostModel = await profileProvider!.verifyUpdateEmailOtp(
        email: email,
        otpNo: otpNo,
      );
      emailOtpVerifyLoading = false;
    } catch (err) {
      emailOtpVerifyLoading = false;
      rethrow;
    }
  }

  // GET SAVED JOBS

  // Loading

  final _savedJobsLoading = false.obs;

  bool get savedJobsLoading => _savedJobsLoading.value;

  set savedJobsLoading(bool value) => _savedJobsLoading.value = value;

  // Model

  final _savedJobModel = SavedInternshipModel().obs;

  SavedInternshipModel get savedJobModel => _savedJobModel.value;

  set savedJobModel(SavedInternshipModel value) => _savedJobModel.value = value;

  Future<void> getSavedJobsData() async {
    try {
      savedJobsLoading = true;
      savedJobModel = await profileProvider!.fetchSavedJobsData();
      savedJobsLoading = false;
    } catch (err) {
      savedJobsLoading = false;
      rethrow;
    }
  }

  // ADD TO SAVED JOBS

  // Loading

  final _addSavedJobsLoading = false.obs;

  bool get addSavedJobsLoading => _addSavedJobsLoading.value;

  set addSavedJobsLoading(bool value) => _addSavedJobsLoading.value = value;

  // Model

  final _newSavedJobModel = SavedNewInternshipModel().obs;

  SavedNewInternshipModel get newSavedJobModel => _newSavedJobModel.value;

  set newSavedJobModel(SavedNewInternshipModel value) =>
      _newSavedJobModel.value = value;

  Future<void> addSavedJobsData({required String jobId}) async {
    try {
      addSavedJobsLoading = true;
      newSavedJobModel = await profileProvider!.putSavedJobsData(jobId: jobId);
      addSavedJobsLoading = false;
    } catch (err) {
      addSavedJobsLoading = false;
      rethrow;
    }
  }

  // DELETE SAVED JOBS

  // Loading

  final _removeSavedJobsLoading = false.obs;

  bool get removeSavedJobsLoading => _removeSavedJobsLoading.value;

  set removeSavedJobsLoading(bool value) =>
      _removeSavedJobsLoading.value = value;

  Future<void> removeSavedJobsData({required String jobId}) async {
    try {
      removeSavedJobsLoading = true;
      newSavedJobModel = await profileProvider!.deleteSavedJobsData(
        jobId: jobId,
      );
      removeSavedJobsLoading = false;
    } catch (err) {
      removeSavedJobsLoading = false;
      rethrow;
    }
  }
}
