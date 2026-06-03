import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:http/http.dart' hide MultipartFile;
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/data/repositories/resume_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:get/get.dart' hide MultipartFile;
import 'package:pinput/pinput.dart';

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController mobileOtpController = TextEditingController();
  final TextEditingController emailOtpController = TextEditingController();

  final FocusNode mobileOtpFocusNode = FocusNode();
  final FocusNode emailOtpFocusNode = FocusNode();

  final RegisterController registerController = Get.find<RegisterController>();

  // Step: 0 = info entry, 1 = mobile OTP, 2 = email OTP
  int _currentStep = 0;

  Timer? _mobileTimer;
  Timer? _emailTimer;
  int _mobileResendSeconds = 0;
  int _emailResendSeconds = 0;

  @override
  void initState() {
    super.initState();
    _setInitialData();
  }

  void _setInitialData() {
    final data = registerController.resumeExtractModel.extractedData;
    nameController.text = data?.personalInfo?.name ?? "";
    emailController.text = data?.personalInfo?.email ?? "";
    mobileController.text = data?.personalInfo?.phone ?? "";
  }

  @override
  void dispose() {
    _mobileTimer?.cancel();
    _emailTimer?.cancel();
    mobileOtpController.dispose();
    emailOtpController.dispose();
    mobileOtpFocusNode.dispose();
    emailOtpFocusNode.dispose();
    registerController.showMobileOtpField.value = false;
    registerController.showEmailOtpField.value = false;
    registerController.mobileResendSeconds.value = 0;
    registerController.emailResendSeconds.value = 0;
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;

    // padLeft(2, '0') ensures single digits get a leading zero (e.g., 5 becomes 05)
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  void _startMobileResendTimer() {
    setState(() => _mobileResendSeconds = 60);
    _mobileTimer?.cancel();
    _mobileTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_mobileResendSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _mobileResendSeconds--);
      }
    });
  }

  void _startEmailResendTimer() {
    setState(() => _emailResendSeconds = 60);
    _emailTimer?.cancel();
    _emailTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_emailResendSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _emailResendSeconds--);
      }
    });
  }

  bool get _step0Valid =>
      nameController.text.trim().isNotEmpty &&
          mobileController.text.trim().length >= 10 &&
          emailController.text.trim().contains('@');


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
      border: Border.all(
        color: AppColors.fieldBorderColor,
        width: 1.5,
      ),
    ),
  );

  PinTheme get _focusedPinTheme => _defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: AppColors.primaryColor,
        width: 1.5,
      ),
    ),
  );

  PinTheme get _submittedPinTheme => _defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: AppColors.primaryColor,
        width: 1.5,
      ),
    ),
  );

  PinTheme get _errorPinTheme => _defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      color: Colors.red.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: Colors.redAccent,
        width: 1.5,
      ),
    ),
  );

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBgNew),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back,
          //     size: 25,
          //     color: AppColors.whiteColor,
          //   ),
          //   onPressed: () {
          //     if (_currentStep > 0) {
          //       setState(() => _currentStep--);
          //     } else {
          //       Get.back();
          //     }
          //   },
          // ),
          title:  Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(AssetImages.appLogoNew, height: 50, width: 150),
                Text(
                  "Step ${_currentStep + 1} of 3",
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20,15,20, 20),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                const SizedBox(height: 10),
                _buildProgressBar(),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _currentStep == 0
                      ? _buildStep0()
                      : _currentStep == 1
                      ? _buildStep1()
                      : _buildStep2(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // PROGRESS BAR
  // ─────────────────────────────────────────────────────────────

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(3, (i) {
        final filled = i <= _currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
            height: 15,
            decoration: BoxDecoration(
              color: filled
                  ? AppColors.whiteColor
                  : AppColors.whiteColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 0 — Info Entry
  // ─────────────────────────────────────────────────────────────

  Widget _buildStep0() {
    return SingleChildScrollView(
      key: const ValueKey(0),
      //padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Mobile Number and\nEmail for Verification",
            style: AppStyles.customTextStyle(
              size: 24,
              lineSpace: 1.4,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
          Text(
            "Let's start with your contact information to\nsecure your account",
            style: AppStyles.customTextStyle(
              size: 15,
              lineSpace: 1.4,
              color: AppColors.lightText,
              weight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 2),
          CustomTextField(
            controller: nameController,
            labelText: "Name",
            isEnabled: true,
            onChanged: (_) => setState(() {}),
            prefixWidget: const Icon(
              Icons.person_outline_sharp,
              color: AppColors.primaryColor,
              size: 20,
            ),
            isNumberKeyboard: false,
          ),
          const SizedBox(height: 2),
          CustomTextField(
            controller: mobileController,
            labelText: "Mobile Number",
            isEnabled: true,
            prefixWidget: const Icon(
              Icons.phone,
              color: AppColors.primaryColor,
              size: 20,
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isNotEmpty && RegExp(r'^[0-5]').hasMatch(value)) {
                AppAlertUtils.showToast(
                  message: "Number must start from 6-9",
                  isError: true,
                );
                mobileController.clear();
              }
            },
            isNumberKeyboard: true,
          ),
          const SizedBox(height: 2),
          CustomTextField(
            controller: emailController,
            labelText: "Email Address",
            isEnabled: true,
            prefixWidget: const Icon(
              Icons.mail_outline_sharp,
              color: AppColors.primaryColor,
              size: 20,
            ),
            isNumberKeyboard: false,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 30),
          _buildContinueButton(enabled: _step0Valid, onTap: _onStep0Continue),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _onStep0Continue() async {
    final error = AppFunctions.validateIndianMobile(mobileController.text);
    if (error != null) {
      AppAlertUtils.showToast(message: error, isError: true);
      return;
    }
    await _sendMobileOtp();
    if (registerController.getResponseCode() == 200) {
      setState(() => _currentStep = 1);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 1 — Mobile OTP
  // ─────────────────────────────────────────────────────────────

  Widget _buildStep1() {
    return SingleChildScrollView(
      key: const ValueKey(1),
      //padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          //const SizedBox(height: 10),
          Text(
            "Mobile Verification",
            style: AppStyles.customTextStyle(
              size: 24,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
          Text(
            "Enter the One-Time password (OTP) sent to\nyour mobile number +91 ${mobileController.text}",
            style: AppStyles.customTextStyle(
              size: 14,
              lineSpace: 1.4,
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
          Center(
            child: Pinput(
              length: 4,
              controller: mobileOtpController,
              focusNode: mobileOtpFocusNode,
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
          ),
          const SizedBox(height: 10),
          _buildResendRow(
            seconds: _mobileResendSeconds,
            onResend: _sendMobileOtp,
          ),
          const SizedBox(height: 40),
          Obx(
                () => _buildContinueButton(
              enabled: mobileOtpController.text.length == 4,
              isLoading: registerController.verifyMobileOtpLoading,
              onTap: _onStep1Continue,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _onStep1Continue() async {
    await _verifyMobileOtp();
    if (registerController.getResponseCode() == 200) {
      await _sendEmailOtp();
      if (registerController.getResponseCode() == 200) {
        setState(() => _currentStep = 2);
      }
    }
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 2 — Email OTP
  // ─────────────────────────────────────────────────────────────

  Widget _buildStep2() {
    return SingleChildScrollView(
      key: const ValueKey(2),
      //padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
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
            "Enter the code sent to your email address\n${emailController.text} to complete verification",
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
          Center(
            child: Pinput(
              length: 4,
              controller: emailOtpController,
              focusNode: emailOtpFocusNode,
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
          ),
          const SizedBox(height: 10),
          _buildResendRow(
            seconds: _emailResendSeconds,
            onResend: _sendEmailOtp,
          ),
          const SizedBox(height: 40),
          Obx(
                () => _buildContinueButton(
              enabled: emailOtpController.text.length == 4,
              isLoading: registerController.studentRegisterLoading,
              onTap: _onStep2Continue,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _onStep2Continue() async {
    await _verifyEmailOtp();
    if (registerController.getResponseCode() == 200) {
      await _studentRegisterFunc();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // SHARED WIDGETS
  // ─────────────────────────────────────────────────────────────

  Widget _buildResendRow({
    required int seconds,
    required VoidCallback onResend,
  }) {
    return Center(
      child: Column(
        spacing: 15,
        children: [
          Text(
            _formatTime(seconds),
            style: AppStyles.customTextStyle(size: 20, color: AppColors.whiteColor, weight: FontWeight.w700),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Didn't receive the code? ",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: seconds > 0 ? null : onResend,
                child: Text(
                  seconds > 0 ? "Resend OTP" : "Resend OTP",
                  style: AppStyles.customTextStyle(
                    isUnderlined: true,
                    underlineColor: AppColors.secondaryColor,
                    size: 14,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton({
    required bool enabled,
    required VoidCallback onTap,
    bool? isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      child: CustomButtonWidget(
        height: 50,
        buttonText: "Continue",
        disable: !enabled,
        isLoading: isLoading ?? false,
        buttonFunction: enabled ? onTap : () {},
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // API CALLS
  // ─────────────────────────────────────────────────────────────

  Future<void> _sendMobileOtp() async {
    await registerController.sendMobileOtp(mobileNumber: mobileController.text);
    if (registerController.getResponseCode() == 200) {
      AppAlertUtils.showToast(
        message: registerController.sendMobileOtpModel.message ??
            "OTP sent to your mobile!",
        isError: false,
      );
      _startMobileResendTimer();
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.sendMobileOtpModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }

  Future<void> _verifyMobileOtp() async {
    await registerController.verifyMobileOtp(
      mobileNumber: mobileController.text,
      otpNumber: mobileOtpController.text,
    );
    if (registerController.getResponseCode() == 200) {
      AppAlertUtils.showToast(
        message: registerController.verifyMobileOtpModel.message ??
            "OTP verified successfully!",
        isError: false,
      );
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.verifyMobileOtpModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }

  Future<void> _sendEmailOtp() async {
    await registerController.sendEmailOtp(emailAddress: emailController.text);
    if (registerController.getResponseCode() == 200) {
      AppAlertUtils.showToast(
        message: registerController.sendEmailOtpModel.message ??
            "OTP sent to your Email!",
        isError: false,
      );
      _startEmailResendTimer();
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.sendEmailOtpModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }

  Future<void> _verifyEmailOtp() async {
    await registerController.verifyEmailOtp(
      emailAddress: emailController.text,
      otpNumber: emailOtpController.text,
    );
    if (registerController.getResponseCode() == 200) {
      AppAlertUtils.showToast(
        message: registerController.verifyEmailOtpModel.message ??
            "OTP verified successfully!",
        isError: false,
      );
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.verifyEmailOtpModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }

  String? fcmToken = "";

  Future<void> _studentRegisterFunc() async {
    fcmToken = await LocalStorageService.getFcmToken() ?? "";
    final resumePath = await ResumeStorageService.getResumePath();
    final extractedData = registerController.resumeExtractModel.extractedData!;

    Map<String, dynamic> registerData = {
      "studmobileno": mobileController.text,
      "fcmToken": fcmToken ?? "",
      "studemail": emailController.text,
      "studname": nameController.text,
      "studentdegree":
      extractedData.education?.college != null &&
          extractedData.education!.college!.isNotEmpty
          ? extractedData.education!.college!.first.degree ?? ""
          : "",
      "studentcollegename":
      extractedData.education?.college != null &&
          extractedData.education!.college!.isNotEmpty
          ? extractedData.education!.college!.first.institution ?? ""
          : "",
      "studentresume": await MultipartFile.fromFile(
        resumePath!,
        filename: resumePath.split('/').last,
        contentType: MediaType("application", "pdf"),
      ),
      "studprogramminglang": extractedData.skills ?? [],
      "college": jsonEncode(extractedData.education?.college ?? []),
    };

    debugPrint(registerData.toString(), wrapWidth: 1024);
    await registerController.registerNewStudent(registerData: registerData);

    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message: registerController.studentRegisterModel.message ??
            "Student registered successfully!",
        isError: false,
      );
      final prefs = await SharedPreferences.getInstance();
      LocalStorageService.saveStudent(
        token: registerController.studentRegisterModel.studentToken!,
        student: registerController.studentRegisterModel.registerData!,
      );
      await prefs.setString(
        LocalStorageService.studentNameKey,
        registerController.studentRegisterModel.registerData!.studentName ?? "",
      );
      if (mounted) {
        AppFunctions.navigateScreen(
          context,
          AppRoutes.registerResumeReportScreen,
        );
      }
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.studentRegisterModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }
}
