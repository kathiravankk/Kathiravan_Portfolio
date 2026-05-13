import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:http/http.dart' hide MultipartFile;
import 'package:image_cropper/image_cropper.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:dio/dio.dart';

class RegisterSelfiePreviewScreen extends StatefulWidget {
  const RegisterSelfiePreviewScreen({super.key});

  @override
  State<RegisterSelfiePreviewScreen> createState() =>
      _RegisterSelfiePreviewScreenState();
}

class _RegisterSelfiePreviewScreenState
    extends State<RegisterSelfiePreviewScreen> {
  final RegisterController registerController = Get.find<RegisterController>();

  String imagePath = "";

  @override
  void initState() {
    super.initState();
    imagePath = Get.arguments["uploadedImage"] ?? "";
  }

  // ---------- CROP FUNCTION ----------
  Future<String?> cropImage(String path) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: false,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );
    return cropped?.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          "Upload Selfie",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.crop_sharp, color: AppColors.whiteColor, size: 30),
            onPressed: () async {
              final newPath = await cropImage(imagePath);
              if (newPath != null) {
                setState(() {
                  imagePath = newPath;
                });
              }
            },
          ),
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 30,
              children: [
                Text(
                  "its an cool look! your creativity brings this \n moment to life. Let’s add the final \ntouches to unique one",
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    color: AppColors.whiteColor,
                    size: 16,
                    lineSpace: 1.4,
                    weight: FontWeight.w400,
                  ),
                ),
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(imagePath)),
                    ),
                  ),
                ),
                Spacer(),
                CustomButtonWidget(
                  width: 300,
                  height: 45,
                  isLoading: registerController.updateProfileLoading,
                  buttonFunction: () async {
                    await uploadProfile();
                  },
                  buttonText: "Upload",
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //String? studentId = "";

  Future<void> uploadProfile() async {
    // final prefs = await SharedPreferences.getInstance();
    // studentId = prefs.getString('student_id');
    final studentId = await LocalStorageService.getStudentId();

    final file = File(imagePath);

    if (!file.existsSync()) {
      AppAlertUtils.showToast(message: "Image file not found");
      return;
    }

    final multipartFile = await MultipartFile.fromFile(
      file.path,
      filename: "profile_${DateTime.now().millisecondsSinceEpoch}.jpg",
      contentType: MediaType("image", "jpeg"),
    );

    Map<String, dynamic> updateData = {
      "studprofile": multipartFile,
      //"stuid": "6979f45490869a0803c30be7",
      "stuid": studentId,
    };

    await registerController.updateStudentProfileData(updateData: updateData);

    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
            registerController.updateProfileModel.message ??
            "Your profile updated successfully!",
      );
      AppFunctions.navigateScreen(
        context,
        AppRoutes.stepUpdateScreen,
        arguments: {"activeStep": 3},
      );
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.updateProfileModel.message ??
            "Failed to update your profile!",
      );
    }
  }
}
