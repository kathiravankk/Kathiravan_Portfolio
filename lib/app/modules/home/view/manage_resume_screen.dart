import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/card_widgets.dart';
import 'package:internsharks/app/modules/home/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';

class ManageResumeScreen extends StatefulWidget {
  const ManageResumeScreen({super.key});

  @override
  State<ManageResumeScreen> createState() => _ManageResumeScreenState();
}

class _ManageResumeScreenState extends State<ManageResumeScreen> {
  final ProfileController profileController = Get.find<ProfileController>();

  String resumeName = "";
  String updatedAt = "";

  @override
  void initState() {
    super.initState();
    resumeName = profileController.profileDataModel.studentResume ?? "";
    updatedAt = profileController.profileDataModel.updatedAt ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.loginBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Manage Your Resume",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Resume',
                style: AppStyles.customTextStyle(
                  color: AppColors.whiteColor,
                  size: 16,
                  weight: FontWeight.w700,
                ),
              ),
              CardWidgets.settingsCard(
                children: [
                  CardWidgets.settingsTile(
                    isResumeFlow: true,
                    icon: CupertinoIcons.doc_richtext,
                    title: "",
                    onTap: () {},
                    titleWidget: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppFunctions.getFileName(resumeName),
                          style: AppStyles.customTextStyle(
                            color: AppColors.whiteColor,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Updated ${AppFunctions.formatIsoDate(updatedAt)}",
                          style: AppStyles.customTextStyle(
                            color: AppColors.whiteColor,
                            size: 10,
                            weight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                'Actions',
                style: AppStyles.customTextStyle(
                  color: AppColors.whiteColor,
                  size: 16,
                  weight: FontWeight.w700,
                ),
              ),
              CardWidgets.settingsCard(
                children: [
                  CardWidgets.settingsTile(
                    icon: CupertinoIcons.tray_arrow_down,
                    title: "View / Download Resume",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.resumeFileViewScreen,
                        arguments: {
                          "resumeUrl": "${AppApiUrls.devServer}$resumeName",
                        },
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  Divider(color: AppColors.contBorderColor),
                  SizedBox(height: 5),
                  CardWidgets.settingsTile(
                    icon: CupertinoIcons.pencil_outline,
                    title: "Update your resume with AI",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.chatResumeUpdateScreen,
                      );
                    },
                  ),
                  // Divider(color: AppColors.contBorderColor),
                  // SizedBox(height: 5),
                  // CardWidgets.settingsTile(
                  //   icon: CupertinoIcons.pencil_outline,
                  //   title: "Create / Edit with Ai",
                  //   onTap: () {},
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
