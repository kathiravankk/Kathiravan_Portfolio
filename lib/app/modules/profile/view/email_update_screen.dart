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

class EmailUpdateScreen extends StatefulWidget {
  const EmailUpdateScreen({super.key});

  @override
  State<EmailUpdateScreen> createState() => _EmailUpdateScreenState();
}

class _EmailUpdateScreenState extends State<EmailUpdateScreen> {
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController currentEmailController = TextEditingController();

  final ProfileController profileController = Get.find<ProfileController>();

  final RegisterController registerController = Get.find<RegisterController>();

  @override
  void initState() {
    super.initState();
    currentEmailController.text =
        profileController.profileDataModel.studEmail ?? "";
  }

  bool isisOtpSent = false;

  @override
  void dispose() {
    newEmailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.loginBgImage),
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
            "Change Email",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => registerController.updateProfileLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.secondaryColor,
                  ),
                )
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
                          "Enter a new Email to secure your account!",
                          style: AppStyles.customTextStyle(
                            size: 16,
                            color: AppColors.secondaryColor,
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          prefixWidget: Icon(
                            CupertinoIcons.mail,
                            color: AppColors.primaryColor,
                            size: 23,
                          ),
                          suffixWidget: Icon(
                            Icons.check_circle,
                            color: AppColors.sucTextColor,
                            size: 20,
                          ),
                          controller: currentEmailController,
                          labelText: "Current Email Address",
                          isEnabled: false,
                          onChanged: (value) {},
                        ),
                        CustomTextField(
                          isNumberKeyboard: false,
                          prefixWidget: Icon(
                            CupertinoIcons.mail,
                            color: AppColors.primaryColor,
                            size: 23,
                          ),
                          controller: newEmailController,
                          labelText: "New Email Address",
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
                                    profileController.emailOtpSendLoading,
                                width: 300,
                                buttonFunction: () {
                                  final validationMessage =
                                      AppFunctions.validateEmail(
                                        newEmail: newEmailController.text,
                                        currentEmail:
                                            currentEmailController.text,
                                      );

                                  if (validationMessage != null) {
                                    AppAlertUtils.showToast(
                                      message: validationMessage,
                                      isError: true,
                                    );
                                  } else {
                                    sendEmailOtp();
                                  }
                                },
                                buttonText: "Send OTP",
                              )
                            : CustomButtonWidget(
                                isLoading:
                                    profileController.emailOtpVerifyLoading ||
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
                                buttonText: "Verify & Update",
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

  Future<void> sendEmailOtp() async {
    await profileController.sendUpdateEmailOtp(email: newEmailController.text);
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      isisOtpSent = true;
      AppAlertUtils.showToast(
        message:
            profileController.commonPostModel.message ??
            "OTP sent to your Email!",
      );
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.commonPostModel.message ?? "Something went wrong!",
      );
    }
  }

  Future<void> verifyMobileOtp() async {
    await profileController.verifyUpdateEmailOtp(
      email: newEmailController.text,
      otpNo: otpController.text,
    );
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
            profileController.commonPostModel.message ??
            "OTP Verified & Email updated successfully",
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
      "studemail": newEmailController.text,
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
            "Your Email updated successfully!",
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
