import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/core/const_file/api_constants.dart';
import 'package:internsharks/core/const_file/app_button.dart' show AppButton;
import 'package:internsharks/core/const_file/asset_image.dart';
import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';
import 'package:internsharks/view/pages/kyc/successful_page.dart';

class KycAadhaarIdPage extends StatefulWidget {
  final File? collegeFront;
  final File? collegeBack;
  final File? resumeFile;

  const KycAadhaarIdPage({super.key, this.collegeFront, this.collegeBack,this.resumeFile,});

  @override
  State<KycAadhaarIdPage> createState() => _KycAadhaarIdPageState();
}

class _KycAadhaarIdPageState extends State<KycAadhaarIdPage> {
  File? frontFile;
  File? backFile;
  Future<void> completeKYC() async {
    // ... (loading dialog code)

    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse("${ApiConstants.baseUrl}/kyc/verify-kyc")
      );


      if (widget.resumeFile != null) {
        request.files.add(await http.MultipartFile.fromPath('resume', widget.resumeFile!.path));
      }


      if (widget.collegeFront != null) {
        request.files.add(await http.MultipartFile.fromPath('college_front', widget.collegeFront!.path));
      }


      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // ✅ System matched: true nu kudutha mattum SuccessfulPage-ku pogum
        if (data['status'] == "SUCCESS" && data['audit']['matched'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SuccessfulPage()),
          );
        } else {
          // ❌ Match aagalana intha message varum
          _showErrorDialog("Verification Failed", "Resume matrum ID details match aagavillai.");
        }
      } else if (response.statusCode == 402) {
        _showErrorDialog("Quota Exceeded", "API limit mudindhuvittathu (Error 402).");
      }
    } catch (e) {
      _showErrorDialog("Error", "Server connect aagala.");
    }
  }
  // --- API CALL FUNCTION ---
  // Future<void> completeKYC() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => const Center(child: CircularProgressIndicator()),
  //   );
  //
  //   try {
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse("${ApiConstants.baseUrl}/kyc/verify-kyc"),
  //     );
  //
  //     // College ID Files from previous page
  //     if (widget.collegeFront != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'college_front',
  //           widget.collegeFront!.path,
  //         ),
  //       );
  //     }
  //     if (widget.collegeBack != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'college_back',
  //           widget.collegeBack!.path,
  //         ),
  //       );
  //     }
  //
  //     // Aadhaar Files from current page
  //     request.files.add(
  //       await http.MultipartFile.fromPath('aadhaar_front', frontFile!.path),
  //     );
  //     request.files.add(
  //       await http.MultipartFile.fromPath('aadhaar_back', backFile!.path),
  //     );
  //
  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);
  //
  //     Navigator.pop(context); // Close loading
  //
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       if (data['audit']['matched'] == true) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const SuccessfulPage()),
  //         );
  //       } else {
  //         _showErrorDialog(
  //           "Data Mismatch",
  //           "Unga documents match aagala. Please try again.",
  //         );
  //       }
  //     } else {
  //       _showErrorDialog("Server Error", "Status Code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     Navigator.pop(context);
  //     _showErrorDialog("Error", "Check your internet connection.");
  //   }
  // }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(title, style: const TextStyle(color: Colors.red)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // --- PICKER & CROPPER ---
  Future<File?> pickFromCameraGallery() async {
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
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

    final cropped = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    return cropped != null ? File(cropped.path) : null;
  }

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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Upload Your\nAadhaar Card",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Please upload your Aadhaar front & back for identity verification",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    uploadBox(
                      title: "Front Side",
                      file: frontFile,
                      onSelect: () async {
                        File? f = await pickFromCameraGallery();
                        if (f != null) setState(() => frontFile = f);
                      },
                    ),
                    const SizedBox(height: 25),
                    uploadBox(
                      title: "Back Side",
                      file: backFile,
                      onSelect: () async {
                        File? f = await pickFromCameraGallery();
                        if (f != null) setState(() => backFile = f);
                      },
                    ),
                    const SizedBox(height: 40),
                    AppButton.AppContainerButton(
                      onTap: () {
                        if (isBothUploaded) {
                          completeKYC(); // 👈 Call API function here
                        }
                      },
                      text: "Submit",
                      bgColor: isBothUploaded
                          ? AppColors.appBlue
                          : const Color(0xff3b3b3b),
                      borderRadius: 40,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
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
    if (file == null) {
      return GestureDetector(
        onTap: onSelect,
        child: DottedBorder(
          color: Colors.white54,
          strokeWidth: 1.4,
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          dashPattern: const [8, 5],
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xff121615), Color(0xff111f1f)],
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
                const Text(
                  "PNG, JPG up to 10MB",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
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
        color: Colors.white54,
        strokeWidth: 1.4,
        borderType: BorderType.RRect,
        dashPattern: const [8, 5],
        radius: const Radius.circular(20),
        child: Container(
          height: 180,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xff121615), Color(0xff111f1f)],
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  file,
                  width: 130,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
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
                    Text(
                      file.path.split("/").last,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: onSelect,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.appColor,
                          border: Border.all(color: AppColors.appBlue),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text(
                          "Replace",
                          style: TextStyle(color: Colors.white, fontSize: 14),
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
