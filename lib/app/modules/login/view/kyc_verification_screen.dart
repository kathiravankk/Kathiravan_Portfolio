import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:http/http.dart' hide MultipartFile;
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/core/const_file/asset_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  final RegisterController registerController = Get.find<RegisterController>();

  File? collegeIdImg;
  File? aadhaarImg;

  Future<File?> pickFromCameraGallery() async {
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.gradientColor1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Select Option to upload",
            textAlign: TextAlign.center,
            style: AppStyles.customTextStyle(
              size: 16,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.whiteColor,
                  size: 25,
                ),
                title: Text(
                  "From Camera",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  Get.back(result: picked);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.whiteColor,
                  size: 25,
                ),
                title: Text(
                  "From Gallery",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  Get.back(result: picked);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile == null) return null;
    final cropped = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: false,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (cropped == null) return null;

    return File(cropped.path);
  }

  // FULL IMAGE VIEW
  void openFullImage(File file) {
    Get.to(
      () => Scaffold(
        backgroundColor: AppColors.appBgColor,
        appBar: AppBar(
          backgroundColor: AppColors.appBgColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(child: Image.file(file)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssetImages.backgroundimage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
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
            "KYC Verification",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Secure Your Account",
                    style: AppStyles.customTextStyle(
                      size: 16,
                      color: AppColors.secondaryColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Please upload the required documents \n to complete your KYC Verification!",
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w300,
                      lineSpace: 1.3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Upload Your\nCollege ID Card & Aadhaar Card",
                        style: AppStyles.customTextStyle(
                          size: 18,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                          lineSpace: 1.5,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "Kindly upload clear images of the front side of your College ID & Aadhaar card.",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w300,
                      lineSpace: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  uploadBox(
                    title: "Front side of College ID",
                    file: collegeIdImg,
                    onSelect: () async {
                      File? f = await pickFromCameraGallery();
                      if (f != null) setState(() => collegeIdImg = f);
                    },
                  ),

                  uploadBox(
                    title: "Front side of Aadhaar",
                    file: aadhaarImg,
                    onSelect: () async {
                      File? f = await pickFromCameraGallery();
                      if (f != null) setState(() => aadhaarImg = f);
                    },
                  ),
                  const SizedBox(height: 40),
                  CustomButtonWidget(
                    width: 270,
                    height: 45,
                    isLoading: registerController.kycVerificationLoading,
                    buttonFunction: () async {
                      await updateKYC();
                    },
                    buttonText: "Submit",
                    disable: !(collegeIdImg != null && aadhaarImg != null),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateKYC() async {
    final prefs = await SharedPreferences.getInstance();
    final studentName = prefs.getString('student_name');
    final studentId = prefs.getString('student_id');
    if (!collegeIdImg!.existsSync() || !aadhaarImg!.existsSync()) {
      AppFunctions.showToast(message: "Both images are required!");
      return;
    }

    final collegeIdFile = await MultipartFile.fromFile(
      collegeIdImg!.path,
      filename: "college_id_${DateTime.now().millisecondsSinceEpoch}.jpg",
      contentType: MediaType("image", "jpeg"),
    );

    final aadhaarFile = await MultipartFile.fromFile(
      aadhaarImg!.path,
      filename: "aadhaar_${DateTime.now().millisecondsSinceEpoch}.jpg",
      contentType: MediaType("image", "jpeg"),
    );

    Map<String, dynamic> kycData = {
      "college_id": collegeIdFile,
      "aadhaar": aadhaarFile,
      "name": "THENMOZHI. D",
      //"name": studentName,
    };
    await registerController.verifyKycData(kycData: kycData);

    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      Map<String, dynamic> updateProfileData = {
        "studentAdhar": collegeIdImg!.path,
        "studentId": aadhaarImg!.path,
        "stuid": "6979f45490869a0803c30be7",
        //"stuid": studentId,
        "studname": "THENMOZHI. D",
        //"studname": studentName,
        "isVerified":
            (registerController.kycUpdateModel.name != "invalid" &&
                registerController.kycUpdateModel.aadhaar != "invalid")
            ? true
            : false,
      };
      await registerController.updateStudentProfileData(
        updateData: updateProfileData,
      );
      if (registerController.kycUpdateModel.name != "invalid" &&
          registerController.kycUpdateModel.aadhaar != "invalid") {
        AppFunctions.showToast(
          message: "KYC details verified successfully!",
          isError: false,
        );
        AppFunctions.navigateScreen(
          context,
          AppRoutes.stepUpdateScreen,
          arguments: {"activeStep": 4},
        );
      } else {
        AppFunctions.showToast(
          message:
              registerController.kycUpdateModel.candidateDetails ??
              "KYC Verification Pending..",
          isError: true,
        );
        showAlertDialog();
      }
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Failed to verify your KYC details!",
      );
    }
  }

  Widget uploadBox({
    required String title,
    required File? file,
    required Function() onSelect,
  }) {
    if (file == null) {
      return GestureDetector(
        onTap: onSelect,
        child: DottedBorder(
          color: AppColors.contBorderColor,
          strokeWidth: 1.4,
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          dashPattern: const [8, 5],
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [AppColors.contGradient1, AppColors.contGradient2],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  color: Colors.white,
                  size: 50,
                ),
                Text(
                  title,
                  style: AppStyles.customTextStyle(
                    size: 16,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  "PNG, JPG, JPEG up to 10MB",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () => openFullImage(file),
      child: DottedBorder(
        color: AppColors.contBorderColor,
        strokeWidth: 1.4,
        borderType: BorderType.RRect,
        dashPattern: const [8, 5],
        radius: const Radius.circular(20),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [AppColors.contGradient1, AppColors.contGradient2],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            spacing: 15,
            children: [
              Container(
                width: 100,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.transparentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(file, fit: BoxFit.cover),
                ),
              ),
              // RIGHT SIDE TEXT + BUTTON
              Expanded(
                child: Column(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.primaryColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    // FILE NAME
                    Text(
                      file.path.split("/").last,
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // FILE SIZE
                    Text(
                      "${(file.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w300,
                      ),
                    ),

                    const SizedBox(height: 15),

                    CustomButtonWidget(
                      width: 150,
                      height: 40,
                      buttonFunction: onSelect,
                      buttonText: "Replace",
                      bgColor: AppColors.secButtonColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.fieldBgColor,
        title: Image.asset(AssetImages.alertImage, height: 30, width: 30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Verification Pending..!",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
            Text(
              "Your identity verification is pending. Our recruiter will call you shortly to assist with your verification!",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w300,
                lineSpace: 1.3,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          CustomButtonWidget(
            buttonFunction: () {
              Get.back();
              AppFunctions.navigateScreen(
                context,
                AppRoutes.stepUpdateScreen,
                arguments: {"activeStep": 4},
              );
            },
            buttonText: "OKAY",
            width: 150,
            height: 40,
          ),
        ],
      ),
    );
  }
}
