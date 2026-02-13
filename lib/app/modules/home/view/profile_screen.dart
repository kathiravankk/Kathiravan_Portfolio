import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:http/http.dart' hide MultipartFile;
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_profile_holder.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/home/controller/profile_controller.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? initialName;
  String? initialProfileImage;
  File? updatedProfileImage;

  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final RegisterController registerController = Get.find<RegisterController>();

  final ProfileController profileController = Get.find<ProfileController>();

  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    setInitialData();
  }

  Future<void> setInitialData() async {
    initialName = profileController.profileDataModel.studentName;
    initialProfileImage = profileController.profileDataModel.studProfile;

    nameController.text = initialName ?? "";
    emailController.text = profileController.profileDataModel.studEmail ?? "";
    mobileController.text =
        profileController.profileDataModel.studMobileNo ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.loginBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Obx(
        () => Scaffold(
          backgroundColor: AppColors.transparentColor,
          appBar: AppBar(
            backgroundColor: AppColors.transparentColor,
            elevation: 0,
            title: Text(
              "Profile",
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.secondaryColor,
                weight: FontWeight.w600,
              ),
            ),
            actions: [
              registerController.updateProfileLoading
                  ? CupertinoActivityIndicator(color: AppColors.secondaryColor)
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          isEditMode = !isEditMode;
                          if (!isEditMode) {
                            debugPrint("Save profile");
                            updateProfileData();
                          }
                        });
                      },
                      icon: isEditMode
                          ? Icon(
                              Icons.check,
                              color: AppColors.whiteColor,
                              size: 25,
                            )
                          : Image.asset(
                              AssetImages.editIconImg,
                              color: AppColors.failTextColor,
                              height: 25,
                              width: 25,
                            ),
                    ),
              SizedBox(width: 10),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: [
                  CustomProfileHolder(
                    imageUrl:
                        "https://fulupo.selfietoons.com/${updatedProfileImage ?? initialProfileImage ?? ""}",
                    onTap: () {},
                    fileCallBack: (file) {
                      setState(() {
                        updatedProfileImage = file;
                      });
                    },
                    isEditable: isEditMode,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    isNumberKeyboard: false,
                    isProfileFlow: true,
                    prefixWidget: Icon(
                      Icons.person_outline_sharp,
                      color: AppColors.primaryColor,
                      size: 23,
                    ),
                    controller: nameController,
                    labelText: "Name",
                    isEnabled: isEditMode,
                    onChanged: (value) {},
                  ),
                  CustomTextField(
                    prefixWidget: Icon(
                      CupertinoIcons.phone,
                      color: AppColors.primaryColor,
                      size: 23,
                    ),
                    suffixWidget: Icon(
                      Icons.check_circle,
                      color: AppColors.sucTextColor,
                      size: 20,
                    ),
                    controller: mobileController,
                    labelText: "Mobile Number",
                    isEnabled: false,
                    onChanged: (value) {},
                  ),
                  CustomTextField(
                    isNumberKeyboard: false,
                    prefixWidget: Icon(
                      CupertinoIcons.mail,
                      color: AppColors.primaryColor,
                      size: 23,
                    ),
                    suffixWidget: Icon(
                      Icons.check_circle,
                      color: AppColors.sucTextColor,
                      size: 20,
                    ),
                    controller: emailController,
                    labelText: "Email Address",
                    isEnabled: false,

                    onChanged: (value) {},
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      AppFunctions.navigateScreen(context, AppRoutes.manageResumeScreen);
                    },
                    child: Container(
                      height: 50,
                      //constraints: BoxConstraints(minHeight: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.fieldBorderColor),
                        color: AppColors.fieldBgColor,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                CupertinoIcons.doc_richtext,
                                color: AppColors.primaryColor,
                                size: 25,
                              ),
                              Text(
                                "Manage Resume",
                                style: AppStyles.customTextStyle(
                                  fontFamily: "Roboto",
                                  color: AppColors.whiteColor,
                                  size: 14,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.whiteColor,
                            size: 20,
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
      ),
    );
  }

  Future<void> updateProfileData() async {
    final studentId = await LocalStorageService.getStudentId();

    final bool isNameChanged =
        nameController.text.trim() != (initialName ?? "");

    // if (!updatedProfileImage!.existsSync()) {
    //   AppFunctions.showToast(message: "Image file not found");
    //   return;
    // }
    dynamic multipartFile;

    if (updatedProfileImage != null) {
      multipartFile = await MultipartFile.fromFile(
        updatedProfileImage!.path,
        filename: "profile_${DateTime.now().millisecondsSinceEpoch}.jpg",
        contentType: MediaType("image", "jpeg"),
      );
    }
    Map<String, dynamic> updateData = {
      "studprofile": multipartFile ?? null,
      "stuid": studentId,
      "studname": isNameChanged ? nameController.text.trim() : null,
    };

    debugPrint("Calling update profile API .... $updateData");

    await registerController.updateStudentProfileData(updateData: updateData);

    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      await LocalStorageService.saveName(
        studentName:
            registerController
                .updateProfileModel
                .profileUpdateData!
                .studentName ??
            "",
      );
      AppFunctions.showToast(
        message:
            registerController.updateProfileModel.message ??
            "Your profile updated successfully!",
      );
      initialName = nameController.text.trim();
      initialProfileImage = updatedProfileImage != null
          ? updatedProfileImage!.path
          : initialProfileImage;
      updatedProfileImage = null;
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.updateProfileModel.message ??
            "Failed to update your profile!",
      );
    }
  }
}
