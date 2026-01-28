import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/models/extracted_data_model.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/controllers/resume_controller.dart';


class RegisterFlowController extends GetxController {
  // RxMap<String, dynamic> resumeData = <String, dynamic>{}.obs;
  ResumeData? resumeData;
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString mobile = ''.obs;
  RxString dob = ''.obs;

  RxBool emailVerified = false.obs;
  RxBool mobileVerified = false.obs;
  
  RxBool isSaving = false.obs;

  Future<void> onSaveAndContinue() async {
    if (resumeData == null) return;
    
    isSaving.value = true;
    final ResumeController resumeController = Get.find<ResumeController>();

    try {
      final success = await resumeController.registerCompleteStudentData(
        resumeData: resumeData!,
        emailVerified: emailVerified.value,
        mobileVerified: mobileVerified.value,
      );

      if (success) {
        Get.offAllNamed(AppRoutes.resumeReportPage);
      } else {
        Get.snackbar(
          "Registration Failed",
          resumeController.resumeAnalyzeModel.message ?? "Unknown error",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong during registration",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
