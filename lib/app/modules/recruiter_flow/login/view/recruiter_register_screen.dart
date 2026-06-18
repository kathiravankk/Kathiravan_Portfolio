import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/counter_text_field.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/core/widgets/gender_selection_chip.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class RecruiterRegistrationScreen extends StatefulWidget {
  const RecruiterRegistrationScreen({super.key});

  @override
  State<RecruiterRegistrationScreen> createState() =>
      _RecruiterRegistrationScreenState();
}

class _RecruiterRegistrationScreenState
    extends State<RecruiterRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController alternateMobileController =
      TextEditingController();
  final TextEditingController designationController = TextEditingController();

  String selectedGender = "Male";
  int employeeCount = 0;

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
          elevation: 0,
          backgroundColor: AppColors.transparentColor,
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(CupertinoIcons.back, color: AppColors.whiteColor),
          ),
          title: Text(
            "Recruiter Registration",
            style: AppStyles.customTextStyle(
              size: 16,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  "Join Internsharks",
                  style: AppStyles.customTextStyle(
                    size: 30,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Fill in your professional details to start hiring\n"
                  "top talent across the globe.",
                  style: AppStyles.customTextStyle(
                    size: 16,
                    color: AppColors.greyTextColor,
                    weight: FontWeight.w400,
                    lineSpace: 1.4,
                  ),
                ),
                const SizedBox(height: 5),

                /// FULL NAME
                CustomTextField(
                  controller: nameController,
                  labelText: "Full Name",
                  hintText: "e.g. Alexander Pierce",
                  isNumberKeyboard: false,
                  prefixWidget: const Icon(
                    CupertinoIcons.person,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),

                /// EMAIL
                CustomTextField(
                  controller: emailController,
                  labelText: "Work Email",
                  hintText: "alex@company.com",
                  isNumberKeyboard: false,
                  prefixWidget: const Icon(
                    CupertinoIcons.mail,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),

                /// GENDER
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gender",
                      style: AppStyles.customTextStyle(
                        color: AppColors.whiteColor,
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),

                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: GenderSelectionChip(
                            title: "Male",
                            isSelected: selectedGender == "Male",
                            onTap: () {
                              setState(() {
                                selectedGender = "Male";
                              });
                            },
                          ),
                        ),

                        Expanded(
                          child: GenderSelectionChip(
                            title: "Female",
                            isSelected: selectedGender == "Female",
                            onTap: () {
                              setState(() {
                                selectedGender = "Female";
                              });
                            },
                          ),
                        ),

                        Expanded(
                          child: GenderSelectionChip(
                            title: "Other",
                            isSelected: selectedGender == "Other",
                            onTap: () {
                              setState(() {
                                selectedGender = "Other";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// MOBILE
                CustomTextField(
                  controller: mobileController,
                  labelText: "Mobile Number",
                  hintText: "+91 6380172278",
                  prefixWidget: const Icon(
                    CupertinoIcons.phone,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),

                /// ALTERNATE
                CustomTextField(
                  controller: alternateMobileController,
                  labelText: "Alternate Number",
                  hintText: "Optional",
                  prefixWidget: const Icon(
                    CupertinoIcons.device_phone_portrait,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),

                /// DESIGNATION
                CustomTextField(
                  controller: designationController,
                  labelText: "Recruiter Designation",
                  hintText: "HR Manager",
                  isNumberKeyboard: false,
                  prefixWidget: const Icon(
                    CupertinoIcons.briefcase,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    Text(
                      "Number of Employees",
                      style: AppStyles.customTextStyle(
                        color: AppColors.whiteColor,
                        size: 15,
                        weight: FontWeight.w700,
                      ),
                    ),
                    CounterTextField(
                      value: employeeCount,
                      onChanged: (value) {
                        setState(() {
                          employeeCount = value;
                        });
                      },
                      min: 1,
                      max: 100000,
                      hintText: "Enter company size",
                    ),
                  ],
                ),
                _buildReferralExpansionTile(),
                const SizedBox(height: 5),

                /// BUTTON
                CustomButtonWidget(
                  buttonText: "Continue",
                  buttonFunction: () async{
                   await validateAndContinue();
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController referralCodeController = TextEditingController();

  bool isReferralExpanded = false;
  bool isReferralSubmitted = false;

  Widget _buildReferralExpansionTile() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.fieldBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.fieldBorderColor),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          initiallyExpanded: isReferralExpanded,
          onExpansionChanged: (value) {
            setState(() {
              isReferralExpanded = value;
            });
          },
          collapsedIconColor: AppColors.primaryColor,
          iconColor: AppColors.primaryColor,
          title: Text(
            "Have a Referral Code?",
            style: AppStyles.customTextStyle(
              size: 15,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            "Tap here if someone referred you",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.lightText,
              weight: FontWeight.w300,
            ),
          ),
          children: [
            const SizedBox(height: 10),

            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     "Have a friend's link or code?\nPaste it here to get started.",
            //     style: AppStyles.customTextStyle(
            //       size: 13,
            //       color: AppColors.lightText,
            //       weight: FontWeight.w300,
            //       lineSpace: 1.4,
            //     ),
            //   ),
            // ),
            //
            // const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: referralCodeController,
                    labelText: "Referral Code",
                    isEnabled: !isReferralSubmitted,
                    isNumberKeyboard: false,
                    hintText: "Enter Referral Code",
                    prefixWidget: const Icon(
                      Icons.card_giftcard_rounded,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isReferralSubmitted) {
                        isReferralSubmitted = false;
                      } else {
                        if (referralCodeController.text.trim().isEmpty) {
                          AppAlertUtils.showToast(
                            message: "Please enter Referral Code",
                            isError: true,
                          );
                          return;
                        }

                        isReferralSubmitted = true;
                      }
                    });
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isReferralSubmitted
                          ? CupertinoIcons.square_pencil_fill
                          : Icons.check_sharp,
                      color: AppColors.whiteColor,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> validateAndContinue() async {
    final nameError = AppFunctions.validateName(nameController.text);

    if (nameError != null) {
      AppAlertUtils.showToast(message: nameError, isError: true);
      return;
    }

    final emailError = AppFunctions.validateEmail(
      newEmail: emailController.text,
      currentEmail: null,
    );

    if (emailError != null) {
      AppAlertUtils.showToast(message: emailError, isError: true);
      return;
    }

    final mobileError = AppFunctions.validateIndianMobile(
      mobileController.text,
    );

    if (mobileError != null) {
      AppAlertUtils.showToast(message: mobileError, isError: true);
      return;
    }

    /// Alternate Mobile (Optional)
    if (alternateMobileController.text.trim().isNotEmpty) {
      final altMobileError = AppFunctions.validateIndianMobile(
        alternateMobileController.text,
      );

      if (altMobileError != null) {
        AppAlertUtils.showToast(
          message: "Alternate $altMobileError",
          isError: true,
        );
        return;
      }
    }

    if (designationController.text.trim().isEmpty) {
      AppAlertUtils.showToast(
        message: "Recruiter designation is required",
        isError: true,
      );
      return;
    }

    if (employeeCount <= 0) {
      AppAlertUtils.showToast(
        message: "Please enter company size",
        isError: true,
      );
      return;
    }

    /// Navigate to OTP Verification Screen
    ///
    debugPrint("************************");

    AppFunctions.navigateScreen(
      context,
      AppRoutes.recruiterVerificationScreen,
      arguments: {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "mobile": mobileController.text.trim(),
        "alternateMobile": alternateMobileController.text.trim(),
        "designation": designationController.text.trim(),
        "gender": selectedGender,
        "employeeCount": employeeCount,
        "refcode": referralCodeController.text,
      },
    );
  }
}
