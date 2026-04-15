import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/modules/login/controllers/login_controller.dart';
import 'package:internsharks/app/modules/login/view/resume_template_selection_screen.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/core/const_file/app_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';

import '../../../../core/const_file/app_text_style.dart';
import '../../../core/utils/app_functions.dart' show AppFunctions;
import '../../../data/repositories/local_storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Get.find<LoginController>();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.loginBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Image.asset(AssetImages.appLogoImage, height: 40),
                Text(
                  "Welcome!",
                  style: AppStyles.customTextStyle(
                    color: AppColors.secondaryColor,
                    size: 25,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Secure access portal. \nPlease enter your credentials.",
                  style: AppStyles.customTextStyle(
                    lineSpace: 1.4,
                    color: AppColors.whiteColor,
                    size: 15,
                    weight: FontWeight.w300,
                  ),
                ),

                /// ---------------- MOBILE FIELD ----------------
                SizedBox(height: 10),
                CustomTextField(
                  labelText: "Mobile Number",

                  ///prefixText: "+91",
                  prefixWidget: Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                  hintText: "Enter your mobile number",
                  controller: mobileController,
                  maxLength: 10,
                  onChanged: (val) {
                    loginController.mobile.value = val;
                  },
                ),

                /// ---------------- OTP / BUTTON SECTION ----------------
                Obx(() {
                  // ⏳ Loader
                  if (loginController.loginOtpLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.secondaryColor,
                      ),
                    );
                  }

                  // 🔐 OTP FIELD (OTP SENT TRUE)
                  if (loginController.otpSent == true) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          labelText: "OTP",
                          hintText: "Enter your OTP",
                          prefixWidget: Icon(
                            Icons.lock_outline_sharp,
                            size: 20,
                            color: AppColors.primaryColor,
                          ),
                          controller: otpController,
                          maxLength: 4,
                          onChanged: (val) {
                            loginController.otp.value = val;
                          },
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            loginController.canResend.value
                                ? TextButton(
                                    onPressed: () => sendOtpFunc(
                                      mobileNumber: mobileController.text,
                                    ),
                                    child: Text(
                                      "Resend OTP",
                                      style: AppStyles.customTextStyle(
                                        size: 16,
                                        weight: FontWeight.w500,
                                        color: AppColors.primaryColor,
                                        isUnderlined: true,
                                        underlineColor: AppColors.primaryColor,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Resend OTP in ${loginController.seconds.value}s",
                                    style: AppStyles.customTextStyle(
                                      size: 16,
                                      weight: FontWeight.w500,
                                      color: AppColors.primaryColor,
                                      fontFamily: "Roboto",
                                    ),
                                  ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        AppButton.AppContainerButton(
                          onTap: loginController.loginVerifyLoading
                              ? null
                              : () async {
                                  await verifyOtpFunc();
                                },
                          bgColor: loginController.loginVerifyLoading
                              ? Colors.grey.shade800
                              : AppColors.appBlue,
                          borderRadius: 30,
                          borderColor: Colors.white24,
                          borderWidth: 1,
                          text: loginController.loginVerifyLoading
                              ? "Verifying..."
                              : "Verify & Continue",
                          verticalPadding: 12,
                          textStyle: AppStyles.customTextStyle(
                            size: 18,
                            weight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    );
                  }

                  // 📤 SEND OTP BUTTON (OTP NOT SENT)
                  return AppButton.AppContainerButton(
                    onTap: loginController.mobile.value.length == 10
                        ? () => sendOtpFunc(mobileNumber: mobileController.text)
                        : null,
                    bgColor: loginController.mobile.value.length == 10
                        ? AppColors.appBlue
                        : Colors.grey.shade800,
                    borderRadius: 30,
                    text: "Send OTP",
                    verticalPadding: 12,
                    textStyle: AppStyles.customTextStyle(
                      size: 18,
                      weight: FontWeight.w600,
                      color: AppColors.whiteColor,
                    ),
                  );
                }),

                const SizedBox(height: 10),

                /// ---------------- REGISTER LINK ----------------
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "If you’re new to Internshark, ",
                      style: AppStyles.customTextStyle(
                        size: 15,
                        weight: FontWeight.w300,
                        color: AppColors.whiteColor,
                      ),
                      children: [
                        TextSpan(
                          text: "Register now",
                          style: AppStyles.customTextStyle(
                            size: 15,
                            weight: FontWeight.w300,
                            color: AppColors.secondaryColor,
                            isUnderlined: true,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AppFunctions.navigateScreen(
                                context,
                                AppRoutes.registerResumeUploadScreen,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendOtpFunc({required String mobileNumber}) async {
    try {
      await loginController.sendLoginOtp(mobileNumber: mobileController.text);
      if (loginController.getResponseCode() == 200 ||
          loginController.getResponseCode() == 201) {
        if (loginController.commonPostModel.userType == "student") {
          AppFunctions.showToast(
            message:
                loginController.commonPostModel.message ??
                "OTP successfully sent to your Mobile Number!",
            isError: false,
          );
        } else {
          AppFunctions.showAppAlert(
            context: context,
            content:
            "Mobile Number already registered as Recruiter. Please use another Number.",
            confirmText: "OKAY",
            onConfirm: () {
              mobileController.text = "";
              Get.back();
            },
          );
        }
      } else {
        AppFunctions.apiErrorHandling(
          loginController.getResponseCode(),
          loginController.commonPostModel.message ?? "Something went wrong!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        loginController.getResponseCode(),
        loginController.commonPostModel.message ?? "Something went wrong!",
      );
    }
  }

  Future<void> verifyOtpFunc() async {
    try {
      await loginController.verifyLoginOtp(
        mobileNumber: mobileController.text,
        otpNumber: otpController.text,
        userType: loginController.commonPostModel.userType ?? "student",
      );
      if (loginController.getResponseCode() == 200 ||
          loginController.getResponseCode() == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString(
          LocalStorageService.studentNameKey,
          loginController.studentRegisterModel.registerData!.studentName ?? "",
        );
        LocalStorageService.saveStudent(
          token: loginController.studentRegisterModel.studentToken!,
          student: loginController.studentRegisterModel.registerData!,
        );
        LocalStorageService.saveStudentId(
          studentId:
              loginController.studentRegisterModel.registerData!.id ?? "",
        );
        LocalStorageService.saveCreditId(
          creditId:
              loginController
                  .studentRegisterModel
                  .registerData!
                  .studentCreditId ??
              "",
        );
        AppFunctions.showToast(
          message:
              loginController.studentRegisterModel.message ??
              "OTP verified successfully!",
          isError: false,
        );
        final token = await LocalStorageService.getToken();
        print(token);
        Get.offAllNamed(AppRoutes.dashBoardScreen);
      } else {
        AppFunctions.apiErrorHandling(
          loginController.getResponseCode(),
          loginController.studentRegisterModel.message ??
              "Something went wrong!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        loginController.getResponseCode(),
        loginController.studentRegisterModel.message ?? "Something went wrong!",
      );
    }
  }
}
