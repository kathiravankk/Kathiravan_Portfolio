import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/repositories/resume_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class RegisterResumeUploadScreen extends StatefulWidget {
  const RegisterResumeUploadScreen({super.key});

  @override
  State<RegisterResumeUploadScreen> createState() =>
      _RegisterResumeUploadScreenState();
}

class _RegisterResumeUploadScreenState
    extends State<RegisterResumeUploadScreen> {
  bool showUploading = false;
  double uploadProgress = 0.0;

  File? selectedFile;
  String? fileName;

  final RegisterController registerController = Get.find<RegisterController>();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null) {
      AppFunctions.showToast(message: "No file selected", isError: true);
      return;
    }
    final filePath = result.files.single.path!;
    fileName = result.files.single.name;
    await extractResumeFunc(filePath);
  }

  Future<void> extractResumeFunc(String filePath) async {
    await registerController.extractResumeData(filePath);
    if ((registerController.getResponseCode() == 200 ||
            registerController.getResponseCode() == 201) &&
        registerController.resumeExtractModel.success != false) {
      final localPath = await ResumeStorageService.copyResumeToAppDir(filePath);

      await ResumeStorageService.saveResume(
        filePath: localPath,
        fileName: fileName!,
      );
      AppFunctions.showToast(
        message: "Resume upload & Extracted data successfully!",
        isError: false,
      );
      AppFunctions.navigateScreen(context, AppRoutes.studentRegisterScreen);
    } else if (registerController.getResponseCode() == 200 &&
        registerController.resumeExtractModel.success == false) {
      AppFunctions.showToast(
        message:
            registerController.resumeExtractModel.message ??
            "Failed to upload your resume",
        isError: true,
      );
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Failed to upload your resume",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor_2,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Upload Resume',
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gradientColor1,
                      AppColors.gradientColor2,
                      AppColors.gradientColor1,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.09, 0.9, 0.0],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 15,
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AssetImages.resumeUploadImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Upload Your Resume",
                      style: AppStyles.customTextStyle(
                        size: 16,
                        weight: FontWeight.w600,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    Text(
                      "Ready to land your dream Internship? Start \n\n by uploading your resume.",
                      textAlign: TextAlign.center,
                      style: AppStyles.customTextStyle(
                        size: 14,
                        weight: FontWeight.w400,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    //Obx(() =>
                    InkWell(
                      onTap: () async {
                        await pickFile();
                      },
                      child: Container(
                        width: 322,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          // resumeController.resumeUploadLoading
                          //     ? "Resume Uploading...."
                          //     :
                          "Select File to Upload",
                          textAlign: TextAlign.center,
                          style: AppStyles.customTextStyle(
                            size: 16,
                            weight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),

                    //),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ---------------- UPLOAD PROGRESS ----------------
              Obx(() {
                if (!registerController.resumeExtractLoading) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        "Or",
                        textAlign: TextAlign.center,
                        style: AppStyles.customTextStyle(
                          size: 16,
                          weight: FontWeight.w600,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            //AppFunctions.navigateScreen(context, AppRoutes.loginScreen);
                          },
                          child: Text(
                            "Create Your Resume",
                            textAlign: TextAlign.center,
                            style: AppStyles.customTextStyle(
                              size: 16,
                              weight: FontWeight.w600,
                              color: AppColors.whiteColor,
                              isUnderlined: true,
                              underlineColor: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                final progress = registerController.uploadProgress.value;

                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.iconContColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.iconBgColor,
                              child: Icon(
                                Icons.picture_as_pdf,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                fileName ?? "Uploading file",
                                style: AppStyles.customTextStyle(
                                  size: 14,
                                  weight: FontWeight.w500,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: AppColors.lightTextColor,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${(progress * 100).toInt()}% complete",
                            style: AppStyles.customTextStyle(
                              size: 10,
                              weight: FontWeight.w600,
                              color: AppColors.lightTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
