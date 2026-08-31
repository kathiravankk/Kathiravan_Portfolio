import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/recruiter_login_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';

class RecruiterLoginScreen extends StatefulWidget {
  const RecruiterLoginScreen({super.key});

  @override
  State<RecruiterLoginScreen> createState() => _RecruiterLoginScreenState();
}

class _RecruiterLoginScreenState extends State<RecruiterLoginScreen> {
  final RecruiterLoginController loginController =
  Get.find<RecruiterLoginController>();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appScreenBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Image.asset(AssetImages.appLogoNew, height: 40, width: 160),
                const SizedBox(height: 5),
                Text(
                  "Welcome to",
                  style: AppStyles.customTextStyle(
                    color: AppColors.whiteColor,
                    size: 33,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Hire Talent",
                  style: AppStyles.customTextStyle(
                    color: AppColors.secondaryColor,
                    size: 48,
                    weight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: 100,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.screenDivColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Text(
                  "Find Top Talent and build your dream team. Please login to continue",
                  style: AppStyles.customTextStyle(
                    lineSpace: 1.4,
                    color: AppColors.whiteColor,
                    size: 16,
                    weight: FontWeight.w400,
                  ),
                ),

                /// ---------------- MOBILE FIELD ----------------
                SizedBox(height: 10),
                CustomTextField(
                  labelText: "Mobile Number",
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

                    final error = AppFunctions.validateIndianMobile(val);

                    if (error != null && val.length == 10) {
                      AppAlertUtils.showToast(message: error, isError: true);
                    }
                  },
                ),
                const SizedBox(height: 10),

                /// ---------------- OTP / BUTTON SECTION ----------------
                Obx(() {
                  // ⏳ Loader
                  if (loginController.loginOtpLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(
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

                        const SizedBox(height: 30),

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
                        CustomButtonWidget(
                          height: 50,
                          buttonFunction: loginController.loginVerifyLoading
                              ? () {}
                              : () async {
                            FocusScope.of(context).unfocus();
                            await verifyOtpFunc();
                          },
                          buttonText: loginController.loginVerifyLoading
                              ? "Verifying..."
                              : "Verify & Continue",
                          disable:
                          loginController.loginVerifyLoading ||
                              otpController.text.length != 4,
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                  final isValid =
                      AppFunctions.validateIndianMobile(
                        loginController.mobile.value,
                      ) ==
                          null;

                  // 📤 SEND OTP BUTTON (OTP NOT SENT)
                  return CustomButtonWidget(
                    height: 50,
                    buttonFunction: isValid
                        ? () => sendOtpFunc(mobileNumber: mobileController.text)
                        : () {},
                    buttonText: "Send OTP",
                    disable: !isValid,
                  );
                }),

                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: AppStyles.customTextStyle(
                          color: Colors.grey,
                          weight: FontWeight.w700,
                          size: 16,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),

                /// ---------------- REGISTER LINK ----------------
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don’t have an account? ",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        lineSpace: 1.4,
                        weight: FontWeight.w300,
                        color: AppColors.lightText,
                      ),
                      children: [
                        TextSpan(
                          text: "Register now",
                          style: AppStyles.customTextStyle(
                            size: 15,
                            weight: FontWeight.w300,
                            lineSpace: 1.4,
                            color: AppColors.secondaryColor,
                            isUnderlined: true,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AppFunctions.navigateScreen(
                                context,
                                AppRoutes.recruiterRegisterScreen,
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
    final error = AppFunctions.validateIndianMobile(mobileNumber);

    if (error != null) {
      AppAlertUtils.showToast(message: error, isError: true);
      return;
    }

    try {
      otpController.text = "";
      await loginController.sendLoginOtp(mobileNumber: mobileNumber);

      if (loginController.getResponseCode() == 200 ||
          loginController.getResponseCode() == 201) {
        if (loginController.commonPostModel.userType != "student") {
          final String userType =
              loginController.commonPostModel.userType ?? "recruiter";
          await LocalStorageService.saveUserType(userType: userType);
          AppAlertUtils.showToast(
            message:
            loginController.commonPostModel.message ??
                "OTP successfully sent to your Mobile Number!",
            isError: false,
          );
        } else {
          AppAlertUtils.showAppAlert(
            context: context,
            content:
            "Mobile Number already registered as Student. Please use another Number.",
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

  String? fcmToken = "";

  Future<void> verifyOtpFunc() async {
    try {
      fcmToken = await LocalStorageService.getFcmToken() ?? "";
      debugPrint(fcmToken ?? "");
      await loginController.verifyLoginOtp(
        mobileNumber: mobileController.text,
        otpNumber: otpController.text,
        userType: loginController.commonPostModel.userType ?? "recruiter",
        fcmToken: fcmToken ?? "",
      );
      if (loginController.getResponseCode() == 200 ||
          loginController.getResponseCode() == 201) {
        await LocalStorageService.saveRecruiterToken(
          recruiterToken: loginController.recruiterLoginModel.recToken ?? "",
        );
        final recruiter = loginController.recruiterLoginModel.recruiter;

        if (recruiter?.recruiterInfo != null) {
          // Coordinator Login
          await LocalStorageService.saveRecruiterId(
            recruiterId: recruiter?.coordinatorId ?? "",
          );

          await LocalStorageService.saveRecruiterCreditId(
            creditId: recruiter?.recruiterCreditId ?? "",
          );

          await LocalStorageService.saveUserType(userType: "coordinator");
        } else {
          // Recruiter Login (Old API)
          await LocalStorageService.saveRecruiterId(
            recruiterId: recruiter?.id ?? "",
          );

          await LocalStorageService.saveRecruiterCreditId(
            creditId: recruiter?.recruiterCreditId ?? "",
          );

          final String userType =
              loginController.commonPostModel.userType ?? "recruiter";
          await LocalStorageService.saveUserType(userType: userType);
        }

        AppAlertUtils.showToast(
          message:
          loginController.recruiterLoginModel.message ??
              "OTP verified & Logged in successfully!",
          isError: false,
        );
        final token = await LocalStorageService.getRecruiterToken();
        debugPrint(token);

        // Hide OTP field and reset form state before navigating
        loginController.otpSent = false;
        otpController.clear();

        Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
      } else {
        AppFunctions.apiErrorHandling(
          loginController.getResponseCode(),
          loginController.recruiterLoginModel.message ??
              "Something went wrong!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        loginController.getResponseCode(),
        loginController.recruiterLoginModel.message ?? "Something went wrong!",
      );
    }
  }
}