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
import 'package:internsharks/app/modules/recruiter_flow/login/controller/new_recruiter_register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:pinput/pinput.dart';

class NewRecruiterRegisterScreen extends StatefulWidget {
  const NewRecruiterRegisterScreen({super.key});

  @override
  State<NewRecruiterRegisterScreen> createState() =>
      _NewRecruiterRegisterScreenState();
}

class _NewRecruiterRegisterScreenState
    extends State<NewRecruiterRegisterScreen> {
  final NewRecruiterRegisterController controller =
      Get.find<NewRecruiterRegisterController>();

  final TextEditingController emailOtpController = TextEditingController();
  final TextEditingController mobileOtpController = TextEditingController();

  final FocusNode emailOtpFocusNode = FocusNode();
  final FocusNode mobileFocusNode = FocusNode();

  @override
  void dispose() {
    emailOtpController.dispose();
    mobileOtpController.dispose();
    emailOtpFocusNode.dispose();
    mobileFocusNode.dispose();
    super.dispose();
  }

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
        body: SafeArea(
          child: Column(
            children: [
              /// TOP BAR
              _buildTopBar(),

              /// SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      /// HERO SECTION
                      _buildHeroSection(),

                      const SizedBox(height: 20),

                      /// WHY UPLOAD SECTION
                      _buildWhyUploadSection(),

                      const SizedBox(height: 25),

                      /// STEP INDICATOR
                      _buildStepIndicator(),

                      const SizedBox(height: 25),

                      /// FORM TITLE
                      Text(
                        "Create Recruiter Account",
                        style: AppStyles.customTextStyle(
                          size: 18,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Let's start with your basic information.",
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: AppColors.greyTextColor,
                          weight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 22),

                      /// FULL NAME FIELD
                      CustomTextField(
                        controller: controller.nameController,
                        labelText: "Full Name *",
                        hintText: "e.g. Pavithran",
                        isNumberKeyboard: false,
                        prefixWidget: const Icon(
                          CupertinoIcons.person,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// WORK EMAIL FIELD + VERIFICATION
                      _buildEmailSection(),

                      const SizedBox(height: 20),

                      /// MOBILE NUMBER FIELD + VERIFICATION
                      _buildMobileSection(),

                      const SizedBox(height: 20),

                      /// RECRUITER DESIGNATION DROPDOWN
                      // _buildDesignationDropdown(),
                      CustomTextField(
                        controller: controller.designationController,
                        labelText: "Recruiter Designation *",
                        hintText: "e.g. Pavithran",
                        isNumberKeyboard: false,
                        prefixWidget: const Icon(
                          CupertinoIcons.briefcase,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// REFERRAL CODE (OPTIONAL)
                      _buildReferralField(),

                      const SizedBox(height: 30),

                      /// CONTINUE BUTTON
                      _buildContinueButton(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── TOP BAR ────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.whiteColor,
              size: 28,
            ),
            onPressed: () => Get.back(),
          ),
          const Spacer(),
          Text(
            "Step 1 of 3",
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  // ─── HERO SECTION ───────────────────────────────────────────────

  Widget _buildHeroSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LEFT TEXT
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Join 10,000+\nRecruiters",
                style: AppStyles.customTextStyle(
                  size: 24,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w800,
                  lineSpace: 1.25,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Hiring Top Interns",
                style: AppStyles.customTextStyle(
                  size: 22,
                  color: AppColors.primaryColor,
                  weight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Post internships, find skilled talent and\nbuild your future team.",
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                  lineSpace: 1.5,
                ),
              ),
            ],
          ),
        ),

        /// RIGHT IMAGE
        Expanded(
          flex: 4,
          child: Image.asset(
            AssetImages.recRegisterIcon,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  // ─── WHY UPLOAD SECTION ─────────────────────────────────────────

  Widget _buildWhyUploadSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightContColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why upload company profile?",
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _benefitItem(
                  "AI automatically extracts\ncompany details",
                ),
              ),
              Expanded(
                child: _benefitItem("Accurate & error free\nregistration"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _benefitItem("Save 90% of your time")),
              Expanded(
                child: _benefitItem("You can edit anytime before\nsubmitting"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _benefitItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          child: const Icon(
            Icons.check_circle,
            color: AppColors.primaryColor,
            size: 15,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppStyles.customTextStyle(
              size: 11,
              color: AppColors.whiteColor,
              weight: FontWeight.w400,
              lineSpace: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // ─── STEP INDICATOR ─────────────────────────────────────────────

  Widget _buildStepIndicator() {
    final steps = [
      {
        "number": "1",
        "title": "Personal Details",
        "subtitle": "Tell us about yourself",
      },
      {
        "number": "2",
        "title": "Company Information",
        "subtitle": "Add your company details",
      },
      {"number": "3", "title": "Choose Plan", "subtitle": "Select your plan"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isActive = index == 0;

        return Expanded(
          child: Row(
            children: [
              if (index > 0)
                Expanded(
                  child: Container(
                    height: 1,
                    color: AppColors.greyTextColor.withValues(alpha: 0.3),
                  ),
                ),
              Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.primaryColor
                          : AppColors.transparentColor,
                      border: Border.all(
                        color: isActive
                            ? AppColors.primaryColor
                            : AppColors.greyTextColor.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      step["number"]!,
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: isActive
                            ? AppColors.blackColor
                            : AppColors.greyTextColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step["title"]!,
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 10,
                      color: isActive
                          ? AppColors.secondaryColor
                          : AppColors.greyTextColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    step["subtitle"]!,
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 8,
                      color: AppColors.greyTextColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 1,
                    color: AppColors.greyTextColor.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  // ─── EMAIL SECTION ──────────────────────────────────────────────

  Widget _buildEmailSection() {
    return Obx(() {
      final isVerified = controller.isEmailVerified.value;
      final showOtpField = controller.showEmailOtpField.value;
      final isSending = controller.sendEmailOtpLoading;
      final isVerifying = controller.verifyEmailOtpLoading;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// EMAIL INPUT
          CustomTextField(
            controller: controller.emailController,
            labelText: "Work Email *",
            hintText: "alex@company.com",
            isNumberKeyboard: false,
            isEnabled: !isVerified,
            onChanged: controller.onEmailChanged,
            prefixWidget: const Icon(
              CupertinoIcons.mail,
              color: AppColors.primaryColor,
              size: 20,
            ),
            suffixWidget: isVerified
                ? _verifiedBadge()
                : isSending
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CupertinoActivityIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: CustomButtonWidget(
                      buttonFunction: () {controller.sendEmailOtp();},
                      buttonText: showOtpField ? "Resend" : "Verify",
                      height: 35,
                      width: 80,
                    ),
                ),
            // _sendOtpButton(
            //             onTap: controller.sendEmailOtp,
            //             label: showOtpField ? "Resend" : "Verify",
            //           ),
          ),

          /// OTP INPUT
          if (showOtpField && !isVerified) ...[
            const SizedBox(height: 14),
            _buildOtpInputSection(
              otpController: emailOtpController,
              focusNode: emailOtpFocusNode,
              isVerifying: isVerifying,
              resendSeconds: controller.emailResendSeconds.value,
              onVerify: () {
                if (emailOtpController.text.length == 4) {
                  controller.verifyEmailOtp(otpCode: emailOtpController.text);
                }
              },
              onResend: controller.sendEmailOtp,
              formatTime: controller.formatTime,
            ),
          ],
        ],
      );
    });
  }

  // ─── MOBILE SECTION ─────────────────────────────────────────────

  Widget _buildMobileSection() {
    return Obx(() {
      final isVerified = controller.isMobileVerified.value;
      final showOtpField = controller.showMobileOtpField.value;
      final isSending = controller.sendMobileOtpLoading;
      final isVerifying = controller.verifyMobileOtpLoading;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// MOBILE INPUT ROW
          CustomTextField(
            controller: controller.mobileController,
            labelText: "Mobile Number *",
            hintText: "6380172278",
            isEnabled: !isVerified,
            onChanged: controller.onMobileChanged,
            prefixWidget: null,
            suffixWidget: isVerified
                ? _verifiedBadge()
                : isSending
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CupertinoActivityIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CustomButtonWidget(
                buttonFunction: () {controller.sendMobileOtp();},
                buttonText: showOtpField ? "Resend" : "Verify",
                height: 35,
                width: 80,
              ),
            )

        /*    _sendOtpButton(
                    onTap: controller.sendMobileOtp,
                    label: showOtpField ? "Resend" : "Verify",
                  ),*/
          ),

          /// OTP INPUT
          if (showOtpField && !isVerified) ...[
            const SizedBox(height: 14),
            _buildOtpInputSection(
              otpController: mobileOtpController,
              focusNode: mobileFocusNode,
              isVerifying: isVerifying,
              resendSeconds: controller.mobileResendSeconds.value,
              onVerify: () {
                if (mobileOtpController.text.length == 4) {
                  controller.verifyMobileOtp(otpCode: mobileOtpController.text);
                }
              },
              onResend: controller.sendMobileOtp,
              formatTime: controller.formatTime,
            ),
          ],
        ],
      );
    });
  }

  // ─── OTP INPUT SECTION (SHARED) ─────────────────────────────────

  Widget _buildOtpInputSection({
    required TextEditingController otpController,
    required FocusNode focusNode,
    required bool isVerifying,
    required int resendSeconds,
    required VoidCallback onVerify,
    required VoidCallback onResend,
    required String Function(int) formatTime,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter OTP",
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          /// PIN INPUT
          Center(
            child: Pinput(
              controller: otpController,
              focusNode: focusNode,
              length: 4,
              autofocus: true,
              keyboardType: TextInputType.number,
              defaultPinTheme: _defaultPinTheme,
              focusedPinTheme: _focusedPinTheme,
              submittedPinTheme: _submittedPinTheme,
              separatorBuilder: (_) => const SizedBox(width: 12),
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onChanged: (_) => setState(() {}),
              onCompleted: (_) => onVerify(),
            ),
          ),

          const SizedBox(height: 14),

          /// RESEND + VERIFY ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              resendSeconds > 0
                  ? Text(
                      "Resend in ${formatTime(resendSeconds)}",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.greyTextColor,
                        weight: FontWeight.w400,
                      ),
                    )
                  : InkWell(
                      onTap: onResend,
                      child: Text(
                        "Resend OTP",
                        style: AppStyles.customTextStyle(
                          size: 12,
                          color: AppColors.primaryColor,
                          weight: FontWeight.w600,
                          isUnderlined: true,
                          underlineColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
              SizedBox(
                height: 34,
                child: CustomButtonWidget(
                  width: 100,
                  height: 34,
                  buttonText: "Verify",
                  isLoading: isVerifying,
                  disable: otpController.text.length != 4,
                  buttonFunction: onVerify,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── REFERRAL FIELD ─────────────────────────────────────────────

  Widget _buildReferralField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: controller.referralCodeController,
          labelText: "Referral Code (Optional)",
          hintText: "Enter referral code",
          isNumberKeyboard: false,
          prefixWidget: const Icon(
            Icons.call_made_rounded,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
      ],
    );
  }

  // ─── CONTINUE BUTTON ────────────────────────────────────────────

  Widget _buildContinueButton() {
    return CustomButtonWidget(
      buttonText: "Continue",
      buttonFunction: () {
        final error = controller.validateStep1();
        if (error != null) {
          AppAlertUtils.showToast(message: error, isError: true);
          return;
        }

        /// Navigate to step 2 with collected data
        final step1Data = controller.getStep1Data();
        debugPrint("Step 1 Data: $step1Data");

        AppFunctions.navigateScreen(
          context,
          AppRoutes.newRecruiterCompanyInfoScreen,
          arguments: step1Data,
        );
      },
    );
  }

  // ─── SHARED WIDGETS ─────────────────────────────────────────────

  Widget _verifiedBadge() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.correctBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.correctBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.correctText,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            "Verified",
            style: AppStyles.customTextStyle(
              size: 11,
              color: AppColors.correctText,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  // ─── PIN THEMES ─────────────────────────────────────────────────

  PinTheme get _defaultPinTheme => PinTheme(
    width: 55,
    height: 55,
    textStyle: AppStyles.customTextStyle(
      size: 22,
      color: AppColors.whiteColor,
      weight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.fieldBorderColor, width: 1.5),
    ),
  );

  PinTheme get _focusedPinTheme => _defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.primaryColor, width: 1.5),
    ),
  );

  PinTheme get _submittedPinTheme => _defaultPinTheme.copyWith(
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.primaryColor, width: 1.5),
    ),
  );
}
