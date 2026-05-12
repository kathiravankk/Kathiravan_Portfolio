import 'dart:convert';
import 'dart:io';
import 'dart:ui';
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
import 'package:internsharks/app/core/widgets/ai_loading_widget.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/kyc_response_dialog.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  final RegisterController registerController = Get.find<RegisterController>();
  final ProfileController profileController = Get.find<ProfileController>();

  bool isRegisterFlow = true;

  @override
  void initState() {
    isRegisterFlow = Get.arguments["isRegisterFlow"] ?? true;
    super.initState();
  }

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
          image: AssetImage(AssetImages.appBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: PopScope(
        canPop: true,
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
            () => Padding(
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
                    "Please upload the required document \n to complete your KYC Verification!",
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w300,
                      lineSpace: 1.3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        //"Upload Your\nCollege ID Card & Aadhaar Card",
                        "Upload Your College ID Card",
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
                    //"Kindly upload clear images of the front side of your College ID & Aadhaar card.",
                    "Kindly upload clear image of the front side of your College ID.",
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
                  //
                  // uploadBox(
                  //   title: "Front side of Aadhaar",
                  //   file: aadhaarImg,
                  //   onSelect: () async {
                  //     File? f = await pickFromCameraGallery();
                  //     if (f != null) setState(() => aadhaarImg = f);
                  //   },
                  // ),
                  //const SizedBox(height: 40),
                  const Spacer(),
                  CustomButtonWidget(
                    width: 270,
                    height: 45,
                    isLoading: registerController.kycVerificationLoading,
                    buttonFunction: () async {
                      await updateKYC();
                    },
                    buttonText: "Submit",
                    //disable: !(collegeIdImg != null && aadhaarImg != null),
                    disable: !(collegeIdImg != null),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateKYC() async {
    final studentName = await LocalStorageService.getStudentName();
    //final studentId = await LocalStorageService.getStudentId();

    if (!collegeIdImg!.existsSync()) {
      AppFunctions.showToast(message: "College ID image is required!");
      return;
    }

    try {
      if(mounted) {
        AiLoadingWidget.show(context, type: LoadingDialogType.kyc);
      }

      await Future.delayed(const Duration(milliseconds: 100));

      final collegeIdFile = await MultipartFile.fromFile(
        collegeIdImg!.path,
        filename: "college_id_${DateTime.now().millisecondsSinceEpoch}.jpg",
        contentType: MediaType("image", "jpeg"),
      );

      Map<String, dynamic> kycData = {
        "college_id": collegeIdFile,
        "name": studentName,
        "college": jsonEncode(
          profileController.profileDataModel.education != null
              ? profileController.profileDataModel.education!.college ?? []
              : [],
        ),
      };

      await registerController.verifyKycData(kycData: kycData);

      /// ✅ hide loader immediately after API
      if(mounted) {
        AiLoadingWidget.hide(context);
      }

      if (registerController.getResponseCode() == 200 ||
          registerController.getResponseCode() == 201) {
        Map<String, dynamic> updateProfileData = {
          "isVerified":
          (registerController.kycUpdateModel.name == "valid" &&
              registerController.kycUpdateModel.collegeId == "valid" &&
              registerController.kycUpdateModel.collegeName == "valid")
              ? true
              : false,
        };

        await registerController.updateStudentProfileData(
          updateData: updateProfileData,
        );

        final isValid =
            registerController.kycUpdateModel.name == "valid" &&
                registerController.kycUpdateModel.collegeId == "valid" &&
                registerController.kycUpdateModel.collegeName == "valid";

        if (isValid) {
          AppFunctions.showToast(
            message: "KYC details verified successfully!",
            isError: false,
          );

          if (isRegisterFlow == true) {
            if(mounted) {
              AppFunctions.navigateScreen(
                context,
                AppRoutes.stepUpdateScreen,
                arguments: {"activeStep": 4},
              );
            }
          } else {
            Get.back();
          }
        } else {
          /// ✅ now dialog opens without loader behind it
          if(mounted) {
            showKycResultDialog(
              context: context,
              model: registerController.kycUpdateModel,
              isRegisterFlow: isRegisterFlow,
            );
          }
        }
      } else {
        AppFunctions.apiErrorHandling(
          registerController.getResponseCode(),
          "Failed to verify your KYC details!",
        );
      }
    } catch (e) {
      if(mounted) {
        AiLoadingWidget.hide(context);

        debugPrint("KYC error: $e");
        AppFunctions.showToast(
          message: "Something went wrong. Try again.",
          isError: true,
        );
      }
    }
  }

  Widget uploadBox({
    required String title,
    required File? file,
    required Function() onSelect,
  }) {
    return GestureDetector(
      onTap: file == null ? onSelect : () => openFullImage(file),
      child: CustomPaint(
        painter: DashPainter(
          color: AppColors.contBorderColor,
          radius: 20,
          dash: 8,
          gap: 5,
        ),
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
          padding: const EdgeInsets.all(15),
          child: file == null
              ? _buildEmptyState(title)
              : _buildFileState(title, file, onSelect),
        ),
      ),
    );
  }

// Sub-widgets to keep the code clean
  Widget _buildEmptyState(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        const Icon(Icons.cloud_upload_outlined, color: Colors.white, size: 50),
        const SizedBox(height: 10),
        Text(title, style: AppStyles.customTextStyle(size: 16, color: AppColors.primaryColor, weight: FontWeight.w700)),
        Text("PNG, JPG, JPEG up to 10MB", style: AppStyles.customTextStyle(size: 14, color: AppColors.whiteColor, weight: FontWeight.w300)),
      ],
    );
  }

  Widget _buildFileState(String title, File file, Function() onSelect) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(file, width: 100, height: 130, fit: BoxFit.cover),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(title, style: AppStyles.customTextStyle(size: 14, color: AppColors.primaryColor, weight: FontWeight.w700)),
              Text(file.path.split("/").last, style: AppStyles.customTextStyle(size: 12, color: AppColors.whiteColor, weight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text("${(file.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB", style: AppStyles.customTextStyle(size: 12, color: AppColors.whiteColor, weight: FontWeight.w300)),
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
    );
  }




  // void showAlertDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: AppColors.fieldBgColor,
  //       title: Image.asset(AssetImages.alertImage, height: 30, width: 30),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         spacing: 15,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             "Verification Pending..!",
  //             textAlign: TextAlign.center,
  //             style: AppStyles.customTextStyle(
  //               size: 18,
  //               color: AppColors.whiteColor,
  //               weight: FontWeight.w700,
  //             ),
  //           ),
  //           Text(
  //             registerController.kycUpdateModel.reasoning != null
  //                 ? registerController.kycUpdateModel.reasoning!
  //                 : "Your identity verification is pending. Our recruiter will call you shortly to assist with your verification!",
  //             textAlign: TextAlign.center,
  //             style: AppStyles.customTextStyle(
  //               size: 14,
  //               color: AppColors.whiteColor,
  //               weight: FontWeight.w300,
  //               lineSpace: 1.3,
  //             ),
  //           ),
  //         ],
  //       ),
  //       actionsAlignment: MainAxisAlignment.center,
  //       actions: [
  //         CustomButtonWidget(
  //           buttonFunction: () {
  //             Get.back();
  //             isRegisterFlow
  //                 ? AppFunctions.navigateScreen(
  //                     context,
  //                     AppRoutes.stepUpdateScreen,
  //                     arguments: {"activeStep": 4},
  //                   )
  //                 : Get.close(2);
  //           },
  //           buttonText: "OKAY",
  //           width: 150,
  //           height: 40,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class DashPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;
  final double radius;

  DashPainter({
    this.color = Colors.grey,
    this.strokeWidth = 1.4,
    this.gap = 5.0,
    this.dash = 8.0,
    this.radius = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(radius)));

    final Path dashPath = Path();

    for (final PathMetric measure in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < measure.length) {
        dashPath.addPath(
          measure.extractPath(distance, distance + dash),
          Offset.zero,
        );
        distance += dash + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(DashPainter oldDelegate) => false;
}

