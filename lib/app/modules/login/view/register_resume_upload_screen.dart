import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/ai_loading_widget.dart';
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

  // @override
  // void initState() {
  //   getInitialData();
  //   super.initState();
  // }

  // Future<void> getInitialData() async {
  //   await registerController.getStudentProfile(
  //     studentId: "6995828777e9a4ba74ac4035",
  //   );
  // }

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
    bool alreadyClosed = false;

    try {
      AiLoadingWidget.show(
        context,
        type: LoadingDialogType.resumeExtraction,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      await registerController.extractResumeData(filePath);

      if ((registerController.getResponseCode() == 200 ||
          registerController.getResponseCode() == 201) &&
          registerController.resumeExtractModel.success != false) {
        final localPath = await ResumeStorageService.copyResumeToAppDir(filePath);

        await ResumeStorageService.saveResume(
          filePath: localPath,
          fileName: fileName!,
        );

        /// ✅ close loader safely
        if (Get.isDialogOpen ?? false) {
          AiLoadingWidget.hide(context);
          alreadyClosed = true;
        }

        AppFunctions.showToast(
          message: "Resume uploaded & extracted successfully!",
          isError: false,
        );

        Get.offNamed(AppRoutes.studentRegisterScreen);
        return;
      } else {
        AppFunctions.showToast(
          message: "Failed to upload your resume",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Resume extract error: $e");
    } finally {
      /// ✅ prevent popping new route
      if (!alreadyClosed && (Get.isDialogOpen ?? false)) {
        AiLoadingWidget.hide(context);
      }
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
                        //AppFunctions.navigateScreen(context, AppRoutes.stepUpdateScreen, arguments: {"activeStep": 3});
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
                            AppFunctions.navigateScreen(
                              context,
                              AppRoutes.chatResumeCreation,
                            );
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

                //final progress = registerController.uploadProgress.value;
                final progress = registerController.uploadProgress.value;
                final isExtracting = registerController.isExtracting.value;

                String statusText;

                if (progress < 0.7) {
                  statusText = "Uploading resume...";
                } else if (progress < 1.0) {
                  statusText = "Extracting data from resume...";
                } else {
                  statusText = "Extraction complete!";
                }

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
                            progress == 1.0
                                ? "Completed"
                                : "${(progress * 100).toInt()}% • $statusText",
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
