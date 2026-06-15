import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
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
        body: ListView(
          padding: const EdgeInsets.all(20),
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
      children: [
        Text(
          "Mobile Verification",
          style: AppStyles.customTextStyle(
            size: 28,
            color: AppColors.secondaryColor,
            weight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Enter OTP sent to +91 $recruiterMobile",
          style: AppStyles.customTextStyle(
            size: 14,
            color: AppColors.greyTextColor,
          ),
        ),

        const SizedBox(height: 30),

        Pinput(
          controller: mobileOtpController,
          focusNode: mobileOtpFocusNode,
          length: 4,
          autofocus: true,
        ),

        const SizedBox(height: 20),

        buildMobileResend(),

        const SizedBox(height: 40),

        CustomButtonWidget(
          buttonText: "Verify Mobile",
          buttonFunction: verifyMobileOtp,
        ),
      ],
    );
  }

  Widget buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email Verification",
          style: AppStyles.customTextStyle(
            size: 28,
            color: AppColors.secondaryColor,
            weight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Enter OTP sent to\n$recruiterEmail",
          style: AppStyles.customTextStyle(
            size: 14,
            color: AppColors.greyTextColor,
          ),
        ),

        const SizedBox(height: 30),

        Pinput(
          controller: emailOtpController,
          focusNode: emailOtpFocusNode,
          length: 4,
          autofocus: true,
        ),

        const SizedBox(height: 20),

        buildEmailResend(),

        const SizedBox(height: 40),

        CustomButtonWidget(
          buttonText: "Complete Registration",
          buttonFunction: verifyEmailOtp,
        ),
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
                  ? AppColors.primaryColor
                  : Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }

  Future<void> sendMobileOtp() async {
    await recruiterController.sendMobileOtp(mobileNumber: recruiterMobile);

    if (recruiterController.getResponseCode() == 200) {
      AppAlertUtils.showToast(message: "OTP sent successfully", isError: false);

      startMobileTimer();
    }
  }

  Future<void> verifyMobileOtp() async {
    await recruiterController.verifyMobileOtp(
      mobileNumber: recruiterMobile,
      otp: mobileOtpController.text,
    );

    if (recruiterController.getResponseCode() == 200) {
      await sendEmailOtp();

      setState(() {
        currentStep = 2;
      });
    }
  }

  Future<void> sendEmailOtp() async {
    await recruiterController.sendEmailOtp(email: recruiterEmail);

    if (recruiterController.getResponseCode() == 200) {
      startEmailTimer();
    }
  }

  Future<void> verifyEmailOtp() async {
    await recruiterController.verifyEmailOtp(
      email: recruiterEmail,
      otp: emailOtpController.text,
    );

    if (recruiterController.getResponseCode() == 200) {
      await registerRecruiter();
    }
  }

  Future<void> registerRecruiter() async {
    await recruiterController.registerRecruiter(
      recruiterName: recruiterName,
      recruiterEmail: recruiterEmail,
      recruiterMobile: recruiterMobile,
      alternateMobile: alternateMobile,
      designation: designation,
      gender: gender,
      employeeCount: employeeCount,
    );

    if (recruiterController.getResponseCode() == 200) {
      AppAlertUtils.showToast(
        message: "Registration Successful",
        isError: false,
      );

      Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
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
}
