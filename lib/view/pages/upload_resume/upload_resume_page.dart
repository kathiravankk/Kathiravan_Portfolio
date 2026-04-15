import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/controllers/resigter_controller.dart';
import 'package:internsharks/controllers/resume_controller.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import '../../../app/routes/app_pages.dart' show AppRoutes;
import 'ResumeChat.dart';

class UploadResumePage extends StatefulWidget {
  const


  UploadResumePage({super.key});

  @override
  State<UploadResumePage> createState() => _UploadResumePageState();
}

class _UploadResumePageState extends State<UploadResumePage> {
  bool showUploading = false;
  double uploadProgress = 0.0;

  File? selectedFile;
  String? fileName;

  //final RegisterFlowController registerCtrl = Get.put(RegisterFlowController());

  final ResumeController resumeController = Get.find<ResumeController>();

  final RegisterFlowController registerController =
      Get.find<RegisterFlowController>();

  // 🔹 START UPLOAD + PROGRESS + API
  void startUpload() async {
    setState(() {
      showUploading = true;
      uploadProgress = 0;
    });

    // Progress animation
    Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      if (uploadProgress < 0.9) {
        setState(() {
          uploadProgress += 0.1;
        });
      } else {
        timer.cancel();

        if (selectedFile == null) return;

        try {
          // 🔹 CALL ANALYZE RESUME API via Controller
          await resumeController.uploadResume(selectedFile!.path);
          final model = resumeController.resumeAnalyzeModel;

          if (model.success == true && model.resumeData != null) {
            final info = model.resumeData!.personalInfo;

            // 🔹 STORE ALL DATA IN CONTROLLER
            registerController.resumeData = model.resumeData;
            registerController.name.value = info!.name ?? '';
            registerController.email.value = info!.email ?? '';
            registerController.mobile.value = info!.phone ?? '';
             // Use location as fallback or empty string since DOB is not in PersonalInfo model
            registerController.dob.value = '';

            setState(() {
              uploadProgress = 1.0;
            });

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Resume analyzed successfully!",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ),
            );

            // Wait a moment to show 100% completion
            await Future.delayed(const Duration(milliseconds: 500));

            // 🔹 NAVIGATE TO REGISTER PAGE
            Get.toNamed(AppRoutes.registerPage);
          } else {
            throw Exception("Resume analysis failed");
          }
        } catch (e) {
          setState(() {
            showUploading = false;
            uploadProgress = 0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
          );
        }
      }
    });
  }

  // 🔹 PICK FILE
  Future<void> pickFile() async {
    print("%%%%%%%%%%%%%%%%%");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result == null) {
      Get.snackbar("File", "No file selected");
      return;
    }

    final filePath = result.files.single.path;
    if (filePath == null) {
      Get.snackbar("Error", "Invalid file path");
      return;
    }

    selectedFile = File(filePath);
    fileName = result.files.single.name;
    
    // Start the upload process which handles API call and navigation
    startUpload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        surfaceTintColor: AppColors.appColor,
        backgroundColor: AppColors.appColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Upload Resume', style: AppTextStyles.white24Bold),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// ---------------- CARD ----------------
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff181713),
                      Color(0xff161e16),
                      Color(0xff181814),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/resume_upload_img.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Upload Your Resume",
                      style: AppTextStyles.white24Bold,
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        "Ready to land your dream Internship? Start by uploading your resume.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 25),

                    /// SELECT FILE
                    Obx(
                      () => InkWell(
                        onTap: () async {
                          await pickFile();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppColors.appBlue,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            resumeController.resumeUploadLoading
                                ? "Resume Uploading...."
                                : "Select File to Upload",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.white24Bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ---------------- UPLOAD PROGRESS ----------------
              if (showUploading)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF192226),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFF123B34),
                            child: Icon(
                              Icons.picture_as_pdf,
                              color: Color(0xFF18E0CC),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              fileName ?? "Selected File",
                              style: AppTextStyles.white16bold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showUploading = false;
                                uploadProgress = 0;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: uploadProgress,
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFFEAC930),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${(uploadProgress * 100).toInt()}% complete",
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              /// ---------------- CREATE RESUME ----------------
              if (!showUploading) ...[
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    "Or",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ResumeChat()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                      child: const Text(
                        "Create Your Resume",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
