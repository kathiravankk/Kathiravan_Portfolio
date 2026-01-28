import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_button.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/const_file/asset_image.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  File? frontFile;
  File? backFile;

  // CAMERA / GALLERY PICKER
  // CAMERA / GALLERY PICKER + CROP
  Future<File?> pickFromCameraGallery() async {
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Select Option",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  Navigator.pop(context, picked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  Navigator.pop(context, picked);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile == null) return null;

    // ======================
    // 🚀 IMAGE CROP (v5)
    // ======================
    final cropped = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3), // ID card ratio
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
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(child: Image.file(file)),
      ),
    );

    // Navigator.push(
    //   context,
    //   AppPageRoute(
    //     page: Scaffold(
    //       backgroundColor: Colors.black,
    //       appBar: AppBar(
    //         backgroundColor: Colors.black,
    //         iconTheme: const IconThemeData(color: Colors.white),
    //       ),
    //       body: Center(child: Image.file(file)),
    //     ),
    //   ),
    // );
  }

  bool get isBothUploaded => frontFile != null && backFile != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssetImages.backgroundimage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                Text("KYC Verification", style: AppTextStyles.white24Bold),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    // const Text(
                    //   "Secure Your Account",
                    //   style: TextStyle(
                    //     color: AppColors.appYellow,
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    // const Text(
                    //   "Please upload the required documents\nto complete your KYC Verification",
                    //   style: TextStyle(
                    //     color: Colors.white70,
                    //     fontSize: 18,
                    //     // height: 1.4,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Upload Your\nCollege ID Card",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Please upload your clear image of front and back image of your id card",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),

                    const SizedBox(height: 15),
                    uploadBox(
                      title: "Front side",
                      file: frontFile,
                      onSelect: () async {
                        File? f = await pickFromCameraGallery();
                        if (f != null) setState(() => frontFile = f);
                      },
                    ),

                    const SizedBox(height: 25),

                    uploadBox(
                      title: "Back side",
                      file: backFile,
                      onSelect: () async {
                        File? f = await pickFromCameraGallery();
                        if (f != null) setState(() => backFile = f);
                      },
                    ),

                    const SizedBox(height: 40),

                    AppButton.AppContainerButton(
                      onTap: () {
                        // if (isBothUploaded) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => KycAadhaarIdPage(
                        //         collegeFront: frontFile, // 👈 Intha page-oda files
                        //         collegeBack: backFile,   // 👈 Intha page-oda files
                        //       ),
                        //     ),
                        //   );
                        // }
                      },   text: "Submit",
                      // ... rest of button code


                      bgColor: isBothUploaded
                          ? AppColors.appBlue
                          : const Color(0xff3b3b3b),
                      borderRadius: 40,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // SUBMIT BUTTON
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadBox({
    required String title,
    required File? file,
    required Function() onSelect,
  }) {
    // =======================
    // NO FILE SELECTED
    // =======================
    if (file == null) {
      return GestureDetector(
        onTap: onSelect,
        child: DottedBorder(
          color: Colors.white54,
          strokeWidth: 1.4,
          borderType: BorderType.RRect,
          radius: const Radius.circular(15),
          dashPattern: const [8, 5],
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xff121615),
                  Color(0xff111919),

                  Color(0xff111f1f),
                  Color(0xff111f1f),
                  Color(0xff111919),

                  Color(0xff121615),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  color: Colors.white,
                  size: 55,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff22e3e5),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "PNG, JPG, PDF up to 10MB",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // =======================
    // FILE SELECTED VIEW
    // =======================
    return GestureDetector(
      onTap: () => openFullImage(file),
      child: DottedBorder(
        color: Colors.white54,
        strokeWidth: 1.4,
        borderType: BorderType.RRect,
        dashPattern: const [8, 5],
        radius: const Radius.circular(20),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color(0xff121615),
                Color(0xff111919),

                Color(0xff111f1f),
                Color(0xff111f1f),
                Color(0xff111919),

                Color(0xff121615),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              // IMAGE / PDF ICON
              Container(
                width: 80,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: file.path.endsWith(".pdf")
                    ? const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                  size: 40,
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(file, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(width: 15),

              // RIGHT SIDE TEXT + BUTTON
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.appBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // FILE NAME
                    Text(
                      file.path.split("/").last,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // FILE SIZE
                    Text(
                      "${(file.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // REPLACE BUTTON
                    GestureDetector(
                      onTap: onSelect,
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.appColor,
                          border: Border.all(
                            color: AppColors.appBlue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            "Replace",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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
}
