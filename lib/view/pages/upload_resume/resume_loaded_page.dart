// import 'package:flutter/material.dart';
// import 'package:internsharks/const_file/app_colors.dart';
// import 'package:internsharks/screens/home_Screen.dart';
//
// class ResumeLoadedPage extends StatefulWidget {
//   const ResumeLoadedPage({super.key});
//
//   @override
//   State<ResumeLoadedPage> createState() => _ResumeLoadedPageState();
// }
//
// class _ResumeLoadedPageState extends State<ResumeLoadedPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       body: Container(
//         padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
//         height: double.infinity,
//         width: double.infinity,
//
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                       size: 25,
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   const Text(
//                     "Upload Resume",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 30,
//                   horizontal: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [
//                       Color(0xff181713),
//                       Color(0xff181714),
//                       Color(0xff181618),
//                       Color(0xff15201c),
//                       Color(0xff15201c),
//                       Color(0xff15201c),
//                       Color(0xff15201c),
//                       Color(0xff161e16),
//                       Color(0xff181814),
//                       Color(0xff181814),
//                     ],
//                     begin: AlignmentGeometry.topRight,
//                     end: AlignmentGeometry.bottomLeft,
//                   ),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 width: double.infinity,
//
//                 child: Column(
//                   children: [
//                     // RESUME ILLUSTRATION
//                     Container(
//                       width: 180,
//                       height: 180,
//                       decoration: const BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage("lib/asset/images/Frame 10.png"),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 15),
//
//                     const Text(
//                       "Resume Uploaded",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 15),
//                       child: Text(
//                         "Your resume is now part of your profile. Good luck with your applications!",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white70, fontSize: 16),
//                       ),
//                     ),
//
//                     const SizedBox(height: 25),
//
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(45),
//                         color: AppColors.thirdColor,
//                         border: Border.all(color: Colors.white10, width: 1),
//
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       child: const Center(
//                         child: Text(
//                           "my_resume_final.pdf",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
// SizedBox(height: 20,),
//                     InkWell(
//                       onTap: () {
//                      Navigator.pop(context); // Start upload + show box
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 24,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                             color: AppColors.appBlue,
//                             width: 0.5,
//                           ),
//                         ),
//                         child: const Text(
//                           "Replace Resume",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),SizedBox(height: 20,),
//                     InkWell(
//                       onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder:  (context) => HomePages(),));
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 24,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.appBlue,
//                           borderRadius: BorderRadius.circular(30),
//
//                         ),
//                         child: const Text(
//                           "Continue",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:internsharks/core/const_file/app_button.dart';import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';import '../../../controllers/login_controller.dart';
import '../../../core/const_file/app_button.dart';
import '../../../core/const_file/app_colors.dart';
import '../../../core/const_file/app_text_style.dart';
import '../../../core/routes/app_pages.dart';
import 'package:internsharks/provider/resume_api_service.dart';

import '../../../models/resume_response.dart';


// Import fixed!

class ResumeLoadedPage extends StatefulWidget {
  final File file;

  const ResumeLoadedPage({super.key, required this.file});

  @override
  State<ResumeLoadedPage> createState() => _ResumeLoadedPageState();
}

class _ResumeLoadedPageState extends State<ResumeLoadedPage> {

  // --- API ANALYZE LOGIC ---
// --- API ANALYZE LOGIC ---
  Future<void> analyzeResume() async {
    try {
      // 1. Loading Spinner
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.appBlue),
        ),
      );

      // 2. API Call
      final responseModel = await ResumeApiService.analyzeResume(widget.file.path);

      // Dialog-a close panrom
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);

      if (responseModel != null) {
        // ✅ SUCCESS: Real Data kidaichaa mattum dhaan Report Page-ku pogum
        Get.toNamed(
          Routes.resumeReportPage,
          arguments: {
            'resumePath': widget.file.path,
            'analysisData': responseModel,
          },
        );

      } else {
        // ❌ SERVER ERROR: Data varala na error message mattum kaatum
        _showErrorMessage("Could not analyze resume. Please try again.");
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
      _showErrorMessage("Something went wrong. Check your internet.");
    }
  }

// Mock data-vukku bathila Error SnackBar mattum
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
  // --- MOCK DATA LOGIC (API fail aana use aagum) ---
  void _showMockData() {
    final mockJson = {
      "success": true,
      "filename": widget.file.path.split('/').last,
      "extracted_content": {
        "personalInfo": {
          "name": "User Name",
          "email": "user@example.com",
          "location": "Chennai"
        },
        "summary": "MERN Stack Developer with Flutter experience."
      },
      "analysis": {
        "overallScore": 80,
        "grade": "A",
        "sections": {
          "personalInfo": {
            "rating": 9,
            "suggestions 1": ["Add your LinkedIn profile link"]
          },
          "summary": {
            "rating": 7,
            "suggestions 1": ["Make it more achievement-oriented"]
          }
        }
      }
    };

    final ResumeResponse mockModel = ResumeResponse.fromJson(mockJson);

    if (mounted) {Get.toNamed(
      Routes.resumeReportPage,
      arguments: {
        'resumePath': widget.file.path,
        'analysisData': mockModel,
      },
    );

    // Navigator.push(
    //     context,
    //     AppPageRoute(
    //       page: ResumeReportPage(
    //         resumePath: widget.file.path,
    //         analysisData: mockModel,
    //       ),
    //     ),
    //   );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server busy. Showing Mock Report.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String fileName = widget.file.path.split('/').last;

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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff181713), Color(0xff15201c), Color(0xff181814)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    // PDF Thumbnail Preview
                    Container(
                      width: 180,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.picture_as_pdf, color: Colors.red, size: 60),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              fileName,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text("Resume Uploaded", style: AppTextStyles.white24Bold),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Your resume is now part of your profile. Good luck with your applications!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Tap to View File
                    InkWell(
                      onTap: () {
                        Get.toNamed(
                          Routes.resumeViewPage,
                          arguments: widget.file,
                        );

                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: AppColors.thirdColor,
                          border: Border.all(color: Colors.white10, width: 1),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        child: Center(
                          child: Text(
                            fileName,
                            style: AppTextStyles.white20bold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // REPLACE RESUME
                    AppButton.AppContainerButton(
                      onTap: () => Navigator.pop(context),
                      text: "Replace Resume",
                      horizontalPadding: 24,
                      verticalPadding: 10,
                      textStyle: AppTextStyles.white24Bold,
                      borderColor: AppColors.appBlue,
                      borderRadius: 30,
                      borderWidth: 0.5,
                    ),

                    const SizedBox(height: 20),

                    // CONTINUE / ANALYZE
                    AppButton.AppContainerButton(
                      onTap: () => analyzeResume(),
                      text: "Continue",
                      horizontalPadding: 24,
                      verticalPadding: 10,
                      bgColor: AppColors.appBlue,
                      textStyle: AppTextStyles.white24Bold,
                      borderRadius: 30,
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