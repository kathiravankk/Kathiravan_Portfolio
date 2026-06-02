import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';

class MobileUpdateScreen extends StatefulWidget {
  const MobileUpdateScreen({super.key});

  @override
  State<MobileUpdateScreen> createState() => _MobileUpdateScreenState();
}

class _MobileUpdateScreenState extends State<MobileUpdateScreen> {
  final TextEditingController newMobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController currentMobileController = TextEditingController();

  final ProfileController profileController = Get.find<ProfileController>();

  final RegisterController registerController = Get.find<RegisterController>();

  @override
  void initState() {
    super.initState();
    currentMobileController.text =
        profileController.profileDataModel.studMobileNo ?? "";
  }

  bool isisOtpSent = false;

  @override
  void dispose() {
    newMobileController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Change Mobile Number",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => registerController.updateProfileLoading
              ?AppAlertUtils.customLoader()
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 25,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        Image.asset(
                          AssetImages.appIconImage,
                          height: 100,
                          width: 100,
                        ),
                        Text(
                          "Enter a new number to secure your account!",
                          style: AppStyles.customTextStyle(
                            size: 16,
                            color: AppColors.secondaryColor,
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          prefixWidget: Icon(
                            CupertinoIcons.phone,
                            color: AppColors.primaryColor,
                            size: 23,
                          ),
                          suffixWidget: Icon(
                            Icons.check_circle,
                            color: AppColors.sucTextColor,
                            size: 20,
                          ),
                          controller: currentMobileController,
                          labelText: "Current Mobile Number",
                          isEnabled: false,
                          onChanged: (value) {},
                        ),
                        CustomTextField(
                          prefixWidget: Icon(
                            CupertinoIcons.phone,
                            color: AppColors.primaryColor,
                            size: 23,
                          ),
                          controller: newMobileController,
                          labelText: "New Mobile Number",
                          onChanged: (value) {},
                        ),
                        Visibility(
                          visible: isisOtpSent,
                          child: CustomTextField(
                            maxLength: 4,
                            prefixWidget: Icon(
                              CupertinoIcons.lock_shield,
                              color: AppColors.primaryColor,
                              size: 23,
                            ),
                            controller: otpController,
                            labelText: "Enter OTP",
                            onChanged: (value) {},
                          ),
                        ),
                        //const Spacer(),
                        const SizedBox(height: 30),
                        !isisOtpSent
                            ? CustomButtonWidget(
                                isLoading:
                                    profileController.mobileOtpSendLoading,
                                width: 300,
                                buttonFunction: () {
                                  if (newMobileController.text.isEmpty) {
                                    AppAlertUtils.showToast(
                                      message: 'Please enter a mobile number!',
                                      isError: true,
                                    );
                                  } else if (newMobileController.text ==
                                      currentMobileController.text) {
                                    AppAlertUtils.showToast(
                                      message:
                                          'New number must be different from current!',
                                      isError: true,
                                    );
                                  } else {
                                    sendMobileOtp();
                                  }
                                },
                                buttonText: "Send OTP",
                              )
                            : CustomButtonWidget(
                                isLoading:
                                    profileController.mobileOtpVerifyLoading ||
                                    registerController.updateProfileLoading,
                                width: 300,
                                buttonFunction: () {
                                  if (otpController.text.isEmpty ||
                                      otpController.text.length != 4) {
                                    AppAlertUtils.showToast(
                                      message: "Please enter valid OTP!",
                                      isError: true,
                                    );
                                  } else {
                                    verifyMobileOtp();
                                  }
                                },
                                buttonText: "Verify & update",
                              ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> sendMobileOtp() async {
    await profileController.sendUpdateMobileOtp(
      mobileNo: newMobileController.text,
    );
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      isisOtpSent = true;
      AppAlertUtils.showToast(
        message:
            profileController.commonPostModel.message ??
            "OTP sent to your mobile number!",
      );
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.commonPostModel.message ?? "Something went wrong!",
      );
    }
  }

  Future<void> verifyMobileOtp() async {
    await profileController.verifyUpdateMobileOtp(
      mobileNo: newMobileController.text,
      otpNo: otpController.text,
    );
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
            profileController.commonPostModel.message ??
            "OTP Verified & Mobile updated successfully",
      );
      await updateProfileFunc();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.commonPostModel.message ??
            "Something went wrong!, Please try again!",
      );
    }
  }

  Future<void> updateProfileFunc() async {
    String? studentId = await LocalStorageService.getStudentId() ?? "";
    Map<String, dynamic> updateData = {
      "studmobileno": newMobileController.text,
      "stuid": studentId,
    };
    await registerController.updateStudentProfileData(updateData: updateData);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      isisOtpSent = false;
      await LocalStorageService.saveUpdateStudent(
        student: registerController.updateProfileModel.profileUpdateData!,
      );
      AppAlertUtils.showToast(
        message:
            registerController.updateProfileModel.message ??
            "Your Mobile updated successfully!",
      );
      await profileController.getProfileData(studentId: studentId);
      Get.back();
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.updateProfileModel.message ??
            "Failed to update your profile!",
      );
    }
  }
}
