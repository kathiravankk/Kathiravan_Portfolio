import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class ChoosePathScreen extends StatelessWidget {
  const ChoosePathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.choosePathBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                /// Heading
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Choose your\n",
                        style: AppStyles.customTextStyle(
                          size: 34,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: "Profile",
                        style: AppStyles.customTextStyle(
                          size: 48,
                          lineSpace: 1.3,
                          color: AppColors.secondaryColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 100,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xff9BEA93),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Text(
                  "Unlock a world of opportunities\ntailored for your professional\njourney.",
                  style: AppStyles.customTextStyle(
                    size: 16,
                    color: Colors.white,
                    lineSpace: 1.5,
                    weight: FontWeight.w400,
                  ),
                ),
                /// Student Card
                modernPathCard(
                  image: AssetImages.studentPathIcon,
                  title: "Student",
                  titleColor: AppColors.primaryColor,
                  description:
                      "Explore internships, entry-level roles, and connect with top recruiters already.",
                  buttonText: "Start Internship",
                  buttonColor: AppColors.primaryColor,
                  onTap: () {
                  },
                ),

                const SizedBox(height: 10),

                /// Recruiter Card
                modernPathCard(
                  image: AssetImages.recruiterPathIcon,
                  title: "Recruiter",
                  titleColor: AppColors.secondaryColor,
                  description:
                      "Post jobs, manage applications, and discover the next generation of top talent.",
                  buttonText: "Hire Talent",
                  buttonColor: AppColors.secondaryColor,
                  onTap: () {
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> navigateStudent(BuildContext context) async {
    final token = await LocalStorageService.getToken();

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.studentDashBoardScreen);
    } else {
      Get.toNamed(AppRoutes.studentLoginScreen);
    }
  }

  Future<void> navigateRecruiter(BuildContext context) async {
    final token = await LocalStorageService.getToken();

    if (token != null && token.isNotEmpty) {
      //Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
    } else {
      Get.toNamed(AppRoutes.recruiterLoginScreen);
    }
  }

  Widget modernPathCard({
    required String image,
    required String title,
    required Color titleColor,
    required String description,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: buttonColor.withValues(alpha: .09),
        border: Border.all(color: AppColors.pathBorderColor),
      ),
      child: Column(
        spacing: 20,
        children: [
          /// Dots
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _dot(buttonColor.withValues(alpha: .4)),
              _dot(buttonColor),
              _dot(buttonColor.withValues(alpha: .4)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(image),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "I'm a ",
                            style: AppStyles.customTextStyle(
                              size: 25,
                              color: AppColors.whiteColor,
                              weight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: title,
                            style: AppStyles.customTextStyle(
                              size: 25,
                              color: titleColor,
                              weight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      description,
                      style: AppStyles.customTextStyle(
                        size: 15,
                        color: AppColors.pathLightTextColor,
                        lineSpace: 1.5,
                        weight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: buttonColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    buttonText,
                    style: AppStyles.customTextStyle(
                      size: 18,
                      weight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: AppColors.blackColor,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
