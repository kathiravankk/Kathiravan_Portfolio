import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class StepUpdateScreen extends StatefulWidget {
  const StepUpdateScreen({super.key});

  @override
  State<StepUpdateScreen> createState() => _StepUpdateScreenState();
}

class _StepUpdateScreenState extends State<StepUpdateScreen> {
  int activeStep = 1;

  final RegisterController registerController = Get.find<RegisterController>();

  @override
  void initState() {
    super.initState();
    activeStep = Get.arguments["activeStep"] ?? 1;
    debugPrint(activeStep.toString());
  }

  @override
  Widget build(BuildContext context) {
    // Determine header text based on completion
    String headerText = "Let the Journey begin!";
    if (activeStep == 2) {
      headerText = "First Step Updated!";
    } else if (activeStep == 3) {
      headerText = "Second Step Updated!";
    } else if (activeStep > 3) {
      headerText = "Congratulations! You've completed the final step";
    }
    String subHeaderText =
        "Complete your profile to unlock new opportunities. Your first quest awaits.";
    if (activeStep == 2) {
      subHeaderText =
          "Your resume is uploaded. On to the next challenge to build your profile.";
    } else if (activeStep == 3) {
      subHeaderText =
          "Great job you're one step closer to completing your profile";
    } else if (activeStep > 3) {
      subHeaderText = "Your profile is officially finished nad good to go ";
    }
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back navigation
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.appBgColor,
            image: DecorationImage(
              image: AssetImage(AssetImages.appScreenBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 30,
              children: [
                Text(
                  headerText,
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 22,
                    weight: FontWeight.w600,
                    color: AppColors.secondaryColor,
                    lineSpace: 1.3,
                  ),
                ),

                Text(
                  subHeaderText,
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 16,
                    weight: FontWeight.w400,
                    color: AppColors.whiteColor,
                    lineSpace: 1.4,
                  ),
                ),

                // Step 1
                StepCardWidget(
                  step: "Step 1",
                  title: activeStep > 1
                      ? "Resume Uploaded Successfully"
                      : "Upload Your Resume",
                  isActive: activeStep == 1,
                  isCompleted: activeStep > 1,
                  icon: _getStepIcon(1, activeStep),
                  onTap: () {
                    if (activeStep == 1) {
                      //Get.toNamed(AppRoutes.resumeReportPage);
                    }
                  },
                ),
                // Step 2
                StepCardWidget(
                  step: "Step 2",
                  title: activeStep > 2
                      ? "Selfie Uploaded Successfully"
                      : "Upload Your Selfie",
                  isActive: activeStep == 2,
                  isCompleted: activeStep > 2,
                  icon: _getStepIcon(2, activeStep),
                  onTap: () {
                    if (activeStep == 2) {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.registerProfileUpdateScreen,
                      );
                    }
                  },
                ),
                // Step 3
                StepCardWidget(
                  step: "Step 3",
                  title: activeStep > 3
                      ? registerController.kycUpdateModel.name != "invalid" ||
                                registerController.kycUpdateModel.aadhaarDocument !=
                                    "invalid" ||
                                registerController.kycUpdateModel.collegeId !=
                                    "invalid"
                            ? "KYC Verification Pending"
                            : "KYC Verified Successfully"
                      : "KYC Verification",
                  isActive: activeStep == 3,
                  isCompleted: activeStep > 3,
                  icon: _getStepIcon(3, activeStep),
                  onTap: () {
                    if (activeStep == 3) {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.kycVerificationScreen,
                        arguments: {"isRegisterFlow": true},
                      );
                    }
                  },
                ),
                const SizedBox(height: 30),
                CustomButtonWidget(
                  height: 55,
                  disable: activeStep < 4,
                  buttonFunction: () {
                    AppFunctions.navigateInitialScreen(
                      context,
                      AppRoutes.dashBoardScreen,
                    );
                  },
                  buttonText: "Go to Intern's Page",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getStepIcon(int stepNumber, int currentActiveStep) {
    if (stepNumber == 1) {
      if (currentActiveStep > 1) {
        // Completed - show tick
        return Image.asset(
          AssetImages.verificationIcon,
          height: 40,
          width: 40,
          color: AppColors.secondaryColor,
        );
      } else if (currentActiveStep == 1) {
        // Active - Upload icon
        return Icon(
          Icons.file_copy_outlined,
          color: AppColors.primaryColor,
          size: 40,
        );
      }
    } else if (stepNumber == 2) {
      if (currentActiveStep > 2) {
        // Completed - show tick
        return Image.asset(
          AssetImages.verificationIcon,
          height: 40,
          width: 40,
          color: AppColors.secondaryColor,
        );
      } else if (currentActiveStep == 2) {
        // Active - show image icon
        return Icon(
          CupertinoIcons.photo_fill_on_rectangle_fill,
          color: AppColors.whiteColor,
          size: 40,
        );
      } else {
        // Locked
        return Icon(
          Icons.lock_outline_sharp,
          color: AppColors.greyColor,
          size: 40,
        );
      }
    } else if (stepNumber == 3) {
      if (currentActiveStep > 3) {
        // Completed - show tick
        return Image.asset(
          AssetImages.verificationIcon,
          height: 40,
          width: 35,
          color: AppColors.secondaryColor,
        );
      } else if (currentActiveStep == 3) {
        return Icon(
          Icons.document_scanner_outlined,
          color: AppColors.whiteColor,
          size: 40,
        );
      } else {
        // Locked
        return Icon(
          Icons.lock_outline_sharp,
          color: AppColors.greyColor,
          size: 40,
        );
      }
    }

    return const Icon(Icons.lock_outline, color: AppColors.greyColor, size: 40);
  }
}

class StepCardWidget extends StatefulWidget {
  final String step;
  final String title;
  final bool isActive;
  final bool isCompleted;
  final Widget icon;
  final VoidCallback? onTap;

  const StepCardWidget({
    required this.step,
    required this.title,
    required this.isActive,
    required this.isCompleted,
    required this.icon,
    this.onTap,
    super.key,
  });

  @override
  State<StepCardWidget> createState() => _StepCardWidgetState();
}

class _StepCardWidgetState extends State<StepCardWidget> {
  @override
  Widget build(BuildContext context) {
    bool shouldHighlight = widget.isActive;

    return InkWell(
      onTap: widget.isActive ? widget.onTap : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: shouldHighlight
                ? AppColors.fieldBgColor
                : AppColors.appBgColor.withValues(alpha: 0.5),
            border: Border.all(
              color: shouldHighlight
                  ? AppColors.primaryColor
                  : AppColors.contBorderColor,
              width: 1.5,
            ),
            boxShadow: shouldHighlight
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            spacing: 15,
            children: [
              Container(
                // height: 50,
                // width: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isCompleted
                      ? AppColors.secondaryColor.withValues(alpha: 0.25)
                      : (shouldHighlight
                            ? AppColors.primaryColor
                            : AppColors.contBorderColor),
                ),
                child: widget.icon,
              ),
              Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.step,
                    style: AppStyles.customTextStyle(
                      color: (shouldHighlight || widget.isCompleted)
                          ? AppColors.whiteColor
                          : AppColors.darkText,
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.customTextStyle(
                      color: (shouldHighlight || widget.isCompleted)
                          ? AppColors.whiteColor
                          : AppColors.darkText,
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (shouldHighlight)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
