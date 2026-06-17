import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/recruiter-register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:pinput/pinput.dart';

class RecruiterVerificationScreen extends StatefulWidget {
  const RecruiterVerificationScreen({super.key});

  @override
  State<RecruiterVerificationScreen> createState() =>
      _RecruiterVerificationScreenState();
}

class _RecruiterVerificationScreenState
    extends State<RecruiterVerificationScreen> {
  late String recruiterName;
  late String recruiterEmail;
  late String recruiterMobile;
  late String alternateMobile;
  late String designation;
  late String gender;
  late int employeeCount;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    recruiterName = args["name"];
    recruiterEmail = args["email"];
    recruiterMobile = args["mobile"];
    alternateMobile = args["alternateMobile"];
    designation = args["designation"];
    gender = args["gender"];
    employeeCount = args["employeeCount"];
    sendMobileOtp();
  }

  @override
  void dispose() {
    mobileTimer?.cancel();
    emailTimer?.cancel();

    mobileOtpController.dispose();
    emailOtpController.dispose();

    mobileOtpFocusNode.dispose();
    emailOtpFocusNode.dispose();

    super.dispose();
  }

  final RecruiterRegisterController registerController =
      Get.find<RecruiterRegisterController>();

  final TextEditingController mobileOtpController = TextEditingController();

  final TextEditingController emailOtpController = TextEditingController();

  final FocusNode mobileOtpFocusNode = FocusNode();

  final FocusNode emailOtpFocusNode = FocusNode();

  int currentStep = 1;

  Timer? mobileTimer;
  Timer? emailTimer;

  int mobileResendSeconds = 0;
  int emailResendSeconds = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.fill,
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
            "Verification",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 30,
          ),
          children: [
            const SizedBox(height: 20),

            buildProgressBar(),

            const SizedBox(height: 30),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: currentStep == 1 ? buildMobileStep() : buildEmailStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMobileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          "Mobile Verification",
          style: AppStyles.customTextStyle(
            size: 24,
            color: AppColors.secondaryColor,
            weight: FontWeight.w700,
          ),
        ),
        Text(
          "Enter the One-Time password (OTP) sent to\nyour mobile number +91 $recruiterMobile",
          style: AppStyles.customTextStyle(
            size: 14,
            lineSpace: 1.5,
            color: AppColors.lightText,
            weight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Enter the OTP",
          style: AppStyles.customTextStyle(
            size: 14,
            color: AppColors.whiteColor,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(),

        Pinput(
          controller: mobileOtpController,
          focusNode: mobileOtpFocusNode,
          length: 4,
          autofocus: true,
          keyboardType: TextInputType.number,
          defaultPinTheme: _defaultPinTheme,
          focusedPinTheme: _focusedPinTheme,
          submittedPinTheme: _submittedPinTheme,
          errorPinTheme: _errorPinTheme,
          separatorBuilder: (_) => const SizedBox(width: 15),
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onChanged: (_) => setState(() {}),
          onCompleted: (_) => setState(() {}),
        ),

        const SizedBox(height: 20),

        buildMobileResend(),

        const SizedBox(height: 40),

        Obx(
          () => _buildContinueButton(
            buttonText: "Verify Mobile",
            onTap: verifyMobileOtp,
            enabled: mobileOtpController.text.length == 4,
            isLoading: registerController.verifyMobileOtpLoading,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildContinueButton({
    required bool enabled,
    required VoidCallback onTap,
    required String buttonText,
    bool? isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      child: CustomButtonWidget(
        height: 50,
        buttonText: buttonText ?? "Continue",
        disable: !enabled,
        isLoading: isLoading ?? false,
        buttonFunction: enabled ? onTap : () {},
      ),
    );
  }

  Widget buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        //const SizedBox(height: 10),
        Text(
          "Email Verification",
          style: AppStyles.customTextStyle(
            size: 24,
            color: AppColors.secondaryColor,
            weight: FontWeight.w700,
          ),
        ),
        Text(
          "Enter the code sent to your email address\n$recruiterEmail to complete verification",
          style: AppStyles.customTextStyle(
            size: 14,
            lineSpace: 1.5,
            color: AppColors.lightText,
            weight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Enter the OTP",
          style: AppStyles.customTextStyle(
            size: 14,
            color: AppColors.whiteColor,
            weight: FontWeight.w500,
          ),
        ),
        const SizedBox(),

        Pinput(
          controller: emailOtpController,
          focusNode: emailOtpFocusNode,
          length: 4,
          autofocus: true,
          keyboardType: TextInputType.number,
          defaultPinTheme: _defaultPinTheme,
          focusedPinTheme: _focusedPinTheme,
          submittedPinTheme: _submittedPinTheme,
          errorPinTheme: _errorPinTheme,
          separatorBuilder: (_) => const SizedBox(width: 12),
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onChanged: (_) => setState(() {}),
          onCompleted: (_) => setState(() {}),
        ),

        const SizedBox(height: 20),

        buildEmailResend(),

        const SizedBox(height: 40),
        Obx(
          () => _buildContinueButton(
            buttonText: "Verify & Continue",
            onTap: verifyEmailOtp,
            enabled: emailOtpController.text.length == 4,
            isLoading:
                registerController.verifyEmailOtpLoading ||
                registerController.checkExistLoading,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildProgressBar() {
    return Row(
      children: List.generate(2, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == 0 ? 8 : 0),
            height: 10,
            decoration: BoxDecoration(
              color: index < currentStep
                  ? AppColors.whiteColor
                  : AppColors.whiteColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }

  Future<void> sendMobileOtp() async {
    try {
      await registerController.sendMobileOtp(mobileNumber: recruiterMobile);

      if (registerController.getResponseCode() == 200 ||
          registerController.getResponseCode() == 201) {
        AppAlertUtils.showToast(
          message: "OTP sent successfully",
          isError: false,
        );
        startMobileTimer();
      } else {
        AppFunctions.apiErrorHandling(
          registerController.getResponseCode(),
          registerController.sendMobileOtpModel.message ??
              "Failed to send OTP!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.sendMobileOtpModel.message ?? "Failed to send OTP!",
      );
      rethrow;
    }
  }

  Future<void> verifyMobileOtp() async {
    try {
      await registerController.verifyMobileOtp(
        mobileNumber: recruiterMobile,
        otpNumber: mobileOtpController.text,
      );
      if (registerController.getResponseCode() == 200 ||
          registerController.getResponseCode() == 201) {
        await sendEmailOtp();

        setState(() {
          currentStep = 2;
        });
      } else {
        AppFunctions.apiErrorHandling(
          registerController.getResponseCode(),
          registerController.verifyMobileOtpModel.message ??
              "Failed to verify OTP!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.verifyMobileOtpModel.message ??
            "failed to send OTP!",
      );
      rethrow;
    }
  }

  Future<void> sendEmailOtp() async {
    try {
      await registerController.sendEmailOtp(
        emailAddress: recruiterEmail,
        userName: recruiterName ?? "",
      );

      if (registerController.getResponseCode() == 200 ||
          registerController.getResponseCode() == 201) {
        startEmailTimer();
      } else {
        AppFunctions.apiErrorHandling(
          registerController.getResponseCode(),
          registerController.sendEmailOtpModel.message ?? "Failed to send OTP!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.sendEmailOtpModel.message ?? "Failed to send OTP!",
      );
      rethrow;
    }
  }

  Future<void> verifyEmailOtp() async {
    try {
      await registerController.verifyEmailOtp(
        emailAddress: recruiterEmail,
        otpNumber: emailOtpController.text,
      );

      if (registerController.getResponseCode() == 200) {
        await toCheckExistAccount();
      } else {
        AppFunctions.apiErrorHandling(
          registerController.getResponseCode(),
          registerController.verifyEmailOtpModel.message ??
              "Failed to verify OTP!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.verifyEmailOtpModel.message ??
            "Failed to verify OTP!",
      );
      rethrow;
    }
  }

  Future<void> toCheckExistAccount() async {
    try {
      await registerController.checkExistAccount(
        emailAddress: recruiterEmail,
        mobileNumber: recruiterMobile,
      );
      if (registerController.getResponseCode() == 200 ||
          registerController.getResponseCode() == 201) {
        AppFunctions.navigateScreen(context, AppRoutes.companyProfileScreen);
      } else {
        AppFunctions.apiErrorHandling(
          registerController.getResponseCode(),
          registerController.commonPostModel.message ?? "Failed to check!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.commonPostModel.message ?? "Failed to check!",
      );
      rethrow;
    }
  }

  Widget buildMobileResend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        mobileResendSeconds > 0
            ? Text(
                "Resend OTP in ${formatTime(mobileResendSeconds)}",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.primaryColor,
                  weight: FontWeight.w500,
                ),
              )
            : InkWell(
                onTap: sendMobileOtp,
                child: Text(
                  "Resend OTP",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w600,
                    isUnderlined: true,
                    underlineColor: AppColors.primaryColor,
                  ),
                ),
              ),
      ],
    );
  }

  Widget buildEmailResend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        emailResendSeconds > 0
            ? Text(
                "Resend OTP in ${formatTime(emailResendSeconds)}",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.primaryColor,
                  weight: FontWeight.w500,
                ),
              )
            : InkWell(
                onTap: sendEmailOtp,
                child: Text(
                  "Resend OTP",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w600,
                    isUnderlined: true,
                    underlineColor: AppColors.primaryColor,
                  ),
                ),
              ),
      ],
    );
  }

  void startMobileTimer() {
    setState(() {
      mobileResendSeconds = 60;
    });

    mobileTimer?.cancel();

    mobileTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mobileResendSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          mobileResendSeconds--;
        });
      }
    });
  }

  void startEmailTimer() {
    setState(() {
      emailResendSeconds = 60;
    });

    emailTimer?.cancel();

    emailTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (emailResendSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          emailResendSeconds--;
        });
      }
    });
  }

  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  PinTheme get _defaultPinTheme => PinTheme(
    width: 65,
    height: 70,
    textStyle: AppStyles.customTextStyle(
      size: 24,
      color: AppColors.whiteColor,
      weight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: AppColors.fieldBorderColor, width: 1.5),
    ),
  );

  PinTheme get _focusedPinTheme => _defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: AppColors.primaryColor, width: 1.5),
    ),
  );

  PinTheme get _submittedPinTheme => _defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: AppColors.primaryColor, width: 1.5),
    ),
  );

  PinTheme get _errorPinTheme => _defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      color: Colors.red.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.redAccent, width: 1.5),
    ),
  );
}
