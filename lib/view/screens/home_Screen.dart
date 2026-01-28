import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/core/const_file/app_button.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/const_file/asset_image.dart';
import 'bottom_screen.dart';


class HomeScreen extends StatefulWidget {
  final int activeStep; // 1,2
  final VoidCallback? onGoToInternPage;
  const HomeScreen({super.key, this.activeStep = 1,this.onGoToInternPage});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Determine header text based on completion
    String headerText = "Let the Journey begin!";
    if (widget.activeStep == 2) {
      headerText = "First step Updated!";
    } else if (widget.activeStep == 3) {
      headerText = "Second step Updated!";
    } else if (widget.activeStep > 3) {
      headerText = "Congratulations! You've completed the final step";
    }
    String subHeaderText =
        "Complete your profile to unlock new opportunities. Your first quest awaits.";
    if (widget.activeStep == 2) {
      subHeaderText =
          "Your resume is uploaded. On to the next challenge to build your profile.";
    } else if (widget.activeStep == 3) {
      subHeaderText =
          "Great job you're one step closer to completing your profile";
    } else if (widget.activeStep > 3) {
      subHeaderText = "Your profile is officially finished nad good to go ";
    }
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back navigation
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.appColor,
            image: DecorationImage(
              image: AssetImage(AppAssetImages.backgroundimage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                headerText,
                textAlign: TextAlign.center,
                style: AppTextStyles.yellow26Bold,
              ),
              const SizedBox(height: 10),
              Text(
                subHeaderText,
                textAlign: TextAlign.center,
                style: AppTextStyles.grey20Bold,
              ),
              const SizedBox(height: 20),
              // Step 1
              _StepCard(
                step: "Step 1",
                title: widget.activeStep > 1
                    ? "Resume Uploaded Successfully"
                    : "Upload Your Resume",
                isActive: widget.activeStep == 1,
                isCompleted: widget.activeStep > 1,
                icon: _getStepIcon(1, widget.activeStep),
                onTap: () {
                  if (widget.activeStep == 1) {Get.toNamed(AppRoutes.resumeReportPage);

                  }
                },
              ),
              const SizedBox(height: 10),
              // Step 2
              _StepCard(
                step: "Step 2",
                title: widget.activeStep > 2
                    ? "Selfie Uploaded Successfully"
                    : "Upload Your Selfie",
                isActive: widget.activeStep == 2,
                isCompleted: widget.activeStep > 2,
                icon: _getStepIcon(2, widget.activeStep),
                onTap: () {
                  if (widget.activeStep == 2) {Get.toNamed(AppRoutes.uploadSelfiePage);


                  }
                },
              ),
              const SizedBox(height: 10),
              // Step 3
              _StepCard(
                step: "Step 3",
                title: widget.activeStep > 3
                    ? "KYC Verified Successfully"
                    : "KYC Verification",
                isActive: widget.activeStep == 3,
                isCompleted: widget.activeStep > 3,
                icon: _getStepIcon(3, widget.activeStep),
                onTap: () {
                  if (widget.activeStep == 3) {    Get.offNamed(AppRoutes.kycCollegeIdPage);

                  }
                },
              ),
              const SizedBox(height: 30),

              AppButton.AppContainerButton(
                onTap: () {
                  if (widget.activeStep > 3) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const BottomScreen()),
                          (route) => false,   // <-- Removes ALL previous screens
                    );
                  }
                },bgColor: widget.activeStep > 3
                  ? AppColors.appBlue
                  : AppColors.thirdColor,
                borderRadius: 45,borderColor:Colors.white24,borderWidth: 1 ,
                text: "Go to Interns Page",verticalPadding: 15,
                textStyle: AppTextStyles.white24Bold,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _getStepIcon(int stepNumber, int currentActiveStep) {
    if (stepNumber == 1) {
      if (currentActiveStep > 1) {
        // Completed - show tick
        return const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.appYellow,
        );
      } else if (currentActiveStep == 1) {
        // Active - Upload icon
        return Image.asset(
          "assets/images/icons/upload icon.png",
          height: 28,
          width: 28,
          color: Colors.white,
        );
      }
    } else if (stepNumber == 2) {
      if (currentActiveStep > 2) {
        // Completed - show tick
        return const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.appYellow,
        );
      } else if (currentActiveStep == 2) {
        // Active - show image icon
        return Image.asset(
          "assets/images/icons/upload icon.png",
          height: 28,
          width: 28,
          color: Colors.white,
        );
      } else {
        // Locked
        return const Icon(Icons.lock_outline, color: Colors.grey, size: 28);
      }
    } else if (stepNumber == 3) {
      if (currentActiveStep > 3) {
        // Completed - show tick
        return const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.appYellow,
        );
      } else if (currentActiveStep == 3) {
        return Image.asset(
          "lib/assets/images/icons/step3 .png",
          height: 28,
          width: 28,
          color: Colors.white,
        );
      } else {
        // Locked
        return const Icon(Icons.lock_outline, color: Colors.grey, size: 28);
      }
    }

    return const Icon(Icons.lock_outline, color: Colors.grey, size: 28);
  }
}

class _StepCard extends StatefulWidget {
  final String step;
  final String title;
  final bool isActive;
  final bool isCompleted;
  final Widget icon;
  final VoidCallback? onTap;

  const _StepCard({
    required this.step,
    required this.title,
    required this.isActive,
    required this.isCompleted,
    required this.icon,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  @override
  Widget build(BuildContext context) {
    // Active step gets cyan highlight, completed gets yellow circle
    bool shouldHighlight = widget.isActive;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: widget.isActive ? widget.onTap : null,
        child: Container(
          margin: const EdgeInsets.all(2),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: shouldHighlight
                ? Colors.black
                : AppColors.appColor.withOpacity(0.5),
            border: Border.all(
              color: shouldHighlight ? AppColors.appBlue : Colors.white10,
              width: 1.8,
            ),
            boxShadow: shouldHighlight
                ? [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.5),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isCompleted
                      ? Color(0xff494d22) // Yellow for completed
                      : (shouldHighlight
                            ? AppColors
                                  .appBlue // Cyan for active
                            : Colors.white10), // White10 for locked
                ),
                child: widget.icon,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.step,
                    style: TextStyle(
                      color: (shouldHighlight || widget.isCompleted)
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: (shouldHighlight || widget.isCompleted)
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (shouldHighlight)
                const Icon(Icons.arrow_forward_ios, color: AppColors.appBlue),
            ],
          ),
        ),
      ),
    );
  }
}
