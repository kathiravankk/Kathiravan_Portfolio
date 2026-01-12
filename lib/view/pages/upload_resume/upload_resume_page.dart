// // // // import 'dart:async';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:internsharks/const_file/app_colors.dart';
// // // // import 'package:internsharks/const_file/app_text_style.dart';
// // // // import 'package:internsharks/pages/upload_resume/ResumeChat.dart';
// // // // import 'package:internsharks/pages/upload_resume/resume_loaded_page.dart';
// // // //
// // // // class UploadResumePage extends StatefulWidget {
// // // //   const UploadResumePage({super.key});
// // // //
// // // //   @override
// // // //   State<UploadResumePage> createState() => _UploadResumePageState();
// // // // }
// // // //
// // // // class _UploadResumePageState extends State<UploadResumePage> {
// // // //   bool showUploading = false;
// // // //   double uploadProgress = 0.0;
// // // //
// // // //   // Upload Simulation
// // // //   void startUpload() {
// // // //     setState(() {
// // // //       showUploading = true;
// // // //       uploadProgress = 0;
// // // //     });
// // // //
// // // //     Timer.periodic(const Duration(milliseconds: 300), (timer) {
// // // //       setState(() {
// // // //         uploadProgress += 0.10;
// // // //       });
// // // //
// // // //       if (uploadProgress >= 1) {
// // // //         timer.cancel();
// // // //
// // // //         Future.delayed(const Duration(milliseconds: 600), () {
// // // //           if (mounted) {
// // // //             Navigator.push(
// // // //               context,
// // // //               MaterialPageRoute(
// // // //                 builder: (_) => const ResumeLoadedPage(),
// // // //               ),
// // // //             );
// // // //           }
// // // //         });
// // // //       }
// // // //     });
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: AppColors.appColor,
// // // //       body: Container(
// // // //         padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
// // // //         height: double.infinity,
// // // //         width: double.infinity,
// // // //         child: SingleChildScrollView(
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //
// // // //               // HEADER
// // // //               Row(
// // // //                 children: [
// // // //                   IconButton(
// // // //                     onPressed: () => Navigator.pop(context),
// // // //                     icon: const Icon(
// // // //                       Icons.arrow_back,
// // // //                       color: Colors.white,
// // // //                       size: 25,
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(width: 20),
// // // //                   const Text(
// // // //                     "Upload Resume",
// // // //                     style: AppTextStyles.white24Bold
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //
// // // //               const SizedBox(height: 20),
// // // //
// // // //               // UPLOAD BODY BOX
// // // //               Container(
// // // //                 padding: const EdgeInsets.symmetric(
// // // //                   vertical: 30,
// // // //                   horizontal: 16,
// // // //                 ),
// // // //                 decoration: BoxDecoration(
// // // //                   gradient: const LinearGradient(
// // // //                     colors: [
// // // //                       Color(0xff181713),
// // // //                       Color(0xff181714),
// // // //                       Color(0xff181618),
// // // //                       Color(0xff15201c),
// // // //                       Color(0xff15201c),
// // // //                       Color(0xff15201c),
// // // //                       Color(0xff15201c),
// // // //                       Color(0xff161e16),
// // // //                       Color(0xff181814),
// // // //                       Color(0xff181814),
// // // //                     ],
// // // //                     begin: Alignment.topRight,
// // // //                     end: Alignment.bottomLeft,
// // // //                   ),
// // // //                   borderRadius: BorderRadius.circular(30),
// // // //                 ),
// // // //                 width: double.infinity,
// // // //
// // // //                 child: Column(
// // // //                   children: [
// // // //                     // Resume Image
// // // //                     Container(
// // // //                       width: 180,
// // // //                       height: 180,
// // // //                       decoration: const BoxDecoration(
// // // //                         image: DecorationImage(
// // // //                           image: AssetImage("lib/asset/images/Frame 10.png"),
// // // //                           fit: BoxFit.cover,
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //
// // // //                     const SizedBox(height: 15),
// // // //
// // // //                     const Text(
// // // //                       "Upload Your Resume",
// // // //                       style: AppTextStyles.white24Bold
// // // //                     ),
// // // //
// // // //                     const SizedBox(height: 10),
// // // //
// // // //                     const Padding(
// // // //                       padding: EdgeInsets.symmetric(horizontal: 25),
// // // //                       child: Text(
// // // //                         "Ready to land your dream Internship? Start by uploading your resume.",
// // // //                         textAlign: TextAlign.center,
// // // //                         style: TextStyle(color: Colors.white70, fontSize: 16),
// // // //                       ),
// // // //                     ),
// // // //
// // // //                     const SizedBox(height: 25),
// // // //
// // // //                     // SELECT FILE BUTTON
// // // //                     InkWell(
// // // //                       onTap: () {
// // // //                         startUpload();
// // // //                       },
// // // //                       child: Container(
// // // //                         width: double.infinity,
// // // //                         padding: const EdgeInsets.symmetric(
// // // //                           vertical: 10,
// // // //                           horizontal: 24,
// // // //                         ),
// // // //                         decoration: BoxDecoration(
// // // //                           borderRadius: BorderRadius.circular(30),
// // // //                           border: Border.all(
// // // //                             color: AppColors.appBlue,
// // // //                             width: 1.5,
// // // //                           ),
// // // //                         ),
// // // //                         child: const Text(
// // // //                           "Select File to Upload",
// // // //                           textAlign: TextAlign.center,
// // // //                           style:AppTextStyles.white24Bold
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //
// // // //               const SizedBox(height: 20),
// // // //
// // // //               // PROGRESS BOX
// // // //               if (showUploading)
// // // //                 Container(
// // // //                   width: double.infinity,
// // // //                   padding: const EdgeInsets.all(14),
// // // //                   decoration: BoxDecoration(
// // // //                     color: const Color(0xFF192226),
// // // //                     borderRadius: BorderRadius.circular(20),
// // // //                   ),
// // // //
// // // //                   child: Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       Row(
// // // //                         children: [
// // // //                           const CircleAvatar(
// // // //                             radius: 20,
// // // //                             backgroundColor: Color(0xFF123B34),
// // // //                             child: Icon(
// // // //                               Icons.video_file_outlined,
// // // //                               color: Color(0xFF18E0CC),
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(width: 10),
// // // //
// // // //                           Expanded(
// // // //                             child: Column(
// // // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // // //                               children: [
// // // //                                 const Text(
// // // //                                   "my_resume_final.pdf",
// // // //                                   style: AppTextStyles.white16bold
// // // //                                 ),
// // // //
// // // //                                 const SizedBox(height: 2),
// // // //
// // // //                                 Text(
// // // //                                   uploadProgress >= 1
// // // //                                       ? "Upload Complete"
// // // //                                       : "Uploading...",
// // // //                                   style: const TextStyle(
// // // //                                     color: Colors.white60,
// // // //                                     fontSize: 12,
// // // //                                   ),
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                           ),
// // // //
// // // //                           // HIDE CLOSE WHEN COMPLETE
// // // //                        IconButton(
// // // //                             onPressed: () {
// // // //                               setState(() {
// // // //                                 showUploading = false;
// // // //                               });
// // // //                             },
// // // //                             icon: const Icon(
// // // //                               Icons.close,
// // // //                               color: Colors.white70,
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //
// // // //                       const SizedBox(height: 12),
// // // //
// // // //                       // PROGRESS BAR
// // // //                       ClipRRect(
// // // //                         borderRadius: BorderRadius.circular(8),
// // // //                         child: LinearProgressIndicator(
// // // //                           value: uploadProgress,
// // // //                           minHeight: 6,
// // // //                           backgroundColor: Colors.white24,
// // // //                           valueColor: const AlwaysStoppedAnimation(
// // // //                             Color(0xFFEAC930),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //
// // // //                       const SizedBox(height: 6),
// // // //
// // // //                       Text(
// // // //                         "${(uploadProgress * 100).toInt()}% complete",
// // // //                         style: const TextStyle(
// // // //                           color: Colors.white60,
// // // //                           fontSize: 12,
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //     if (!showUploading) ...[
// // // //               const SizedBox(height: 15),
// // // //
// // // //               const Center(
// // // //                 child: Text(
// // // //                   "Or",
// // // //                   style: TextStyle(color: Colors.white, fontSize: 24),
// // // //                 ),
// // // //               ),
// // // //
// // // //               const SizedBox(height: 10),
// // // //
// // // //               Center(
// // // //                 child: InkWell(onTap: () {
// // // //                   Navigator.push(
// // // //                       context,
// // // //                       MaterialPageRoute(
// // // //                         builder: (_) =>   ResumeChat(),
// // // //                       ));
// // // //                 },
// // // //                   child: Container(
// // // //                     padding: const EdgeInsets.only(bottom: 4),
// // // //                     decoration: const BoxDecoration(
// // // //                       border: Border(
// // // //                         bottom: BorderSide(color: Colors.white, width: 1),
// // // //                       ),
// // // //                     ),
// // // //                     child: const Text(
// // // //                       "Create Your Resume",
// // // //                       style: TextStyle(
// // // //                         color: Colors.white,
// // // //                         fontSize: 22,
// // // //                         fontWeight: FontWeight.w600,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),]
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }}
// // // //
// // //
// // // import 'dart:async';
// // // import 'dart:io';
// // // import 'package:file_picker/file_picker.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get_core/src/get_main.dart';
// // // import 'package:get/get_instance/src/extension_instance.dart';
// // // import 'package:get/get_navigation/src/extension_navigation.dart';
// // // import 'package:internsharks/core/const_file/app_colors.dart';
// // // import 'package:internsharks/core/const_file/app_text_style.dart';
// // // import 'package:internsharks/core/routes/app_pages.dart';
// // // import 'package:internsharks/pages/upload_resume/resume_loaded_page.dart';
// // // import 'package:internsharks/pages/upload_resume/ResumeChat.dart';
// // // import 'package:internsharks/core/const_file/app_colors.dart';
// // // import 'package:internsharks/core/const_file/app_text_style.dart';
// // // import 'package:internsharks/core/routes/app_pages.dart';
// // //
// // // import '../../controllers/resigter_controller.dart';
// // //
// // // class UploadResumePage extends StatefulWidget {
// // //   const UploadResumePage({super.key});
// // //
// // //   @override
// // //   State<UploadResumePage> createState() => _UploadResumePageState();
// // // }
// // //
// // // class _UploadResumePageState extends State<UploadResumePage> {
// // //   bool showUploading = false;
// // //   double uploadProgress = 0.0;
// // //
// // //   final registerCtrl = Get.put(RegisterFlowController());
// // //   File? selectedFile;
// // //   String? fileName;
// // //
// // //   void startUpload() {
// // //     setState(() {
// // //       showUploading = true;
// // //       uploadProgress = 0;
// // //     });
// // //
// // //     Timer.periodic(const Duration(milliseconds: 300), (timer) {
// // //       setState(() {
// // //         uploadProgress += 0.10;
// // //       });
// // //
// // //       if (uploadProgress >= 1) {
// // //         timer.cancel();
// // //
// // //         Future.delayed(const Duration(milliseconds: 600), () {
// // //           if (mounted) {
// // //             Get.toNamed(
// // //               Routes.resumeLoadedPage,
// // //               arguments: selectedFile,
// // //             );
// // //
// // //           }
// // //         });
// // //       }
// // //     });
// // //   }
// // //
// // //   Future<void> pickFile() async {
// // //     FilePickerResult? result = await FilePicker.platform.pickFiles(
// // //       type: FileType.custom,
// // //       allowedExtensions: ['pdf', 'doc', 'docx'],
// // //     );
// // //
// // //     if (result != null) {
// // //       selectedFile = File(result.files.single.path!);
// // //       fileName = result.files.single.name;
// // //
// // //       startUpload();
// // //     } else {
// // //       ScaffoldMessenger.of(
// // //         context,
// // //       ).showSnackBar(const SnackBar(content: Text("No file selected")));
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: AppColors.appColor,
// // //       appBar: AppBar(
// // //         surfaceTintColor: AppColors.appColor,
// // //         backgroundColor: AppColors.appColor,
// // //         elevation: 0,
// // //         leading: IconButton(
// // //           icon: Icon(Icons.arrow_back, size: 25, color: Colors.white),
// // //           onPressed: () => Navigator.pop(context),
// // //         ),
// // //         title: Text('Upload Resume', style: AppTextStyles.white24Bold),
// // //       ),
// // //       body: Container(
// // //         padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
// // //         width: double.infinity,
// // //         height: double.infinity,
// // //         child: SingleChildScrollView(
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               const SizedBox(height: 20),
// // //
// // //               Container(
// // //                 padding: const EdgeInsets.symmetric(
// // //                   vertical: 30,
// // //                   horizontal: 16,
// // //                 ),
// // //                 decoration: BoxDecoration(
// // //                   gradient: const LinearGradient(
// // //                     colors: [
// // //                       Color(0xff181713),
// // //                       Color(0xff161e16),
// // //                       Color(0xff181814),
// // //                     ],
// // //                     begin: Alignment.topRight,
// // //                     end: Alignment.bottomLeft,
// // //                   ),
// // //                   borderRadius: BorderRadius.circular(30),
// // //                 ),
// // //                 child: SingleChildScrollView(
// // //                   child: Column(
// // //                     children: [
// // //                       Container(
// // //                         width: 180,
// // //                         height: 180,
// // //                         decoration: const BoxDecoration(
// // //                           image: DecorationImage(
// // //                             image: AssetImage("asset/images/Frame 10.png"),
// // //                             fit: BoxFit.cover,
// // //                           ),
// // //                         ),
// // //                       ),
// // //
// // //                       const SizedBox(height: 15),
// // //
// // //                       const Text(
// // //                         "Upload Your Resume",
// // //                         style: AppTextStyles.white24Bold,
// // //                       ),
// // //
// // //                       const SizedBox(height: 10),
// // //
// // //                       const Padding(
// // //                         padding: EdgeInsets.symmetric(horizontal: 25),
// // //                         child: Text(
// // //                           "Ready to land your dream Internship? Start by uploading your resume.",
// // //                           textAlign: TextAlign.center,
// // //                           style: TextStyle(color: Colors.white70, fontSize: 16),
// // //                         ),
// // //                       ),
// // //
// // //                       const SizedBox(height: 25),
// // //
// // //                       InkWell(
// // //                         onTap: pickFile,
// // //                         child: Container(
// // //                           width: double.infinity,
// // //                           padding: const EdgeInsets.symmetric(vertical: 10),
// // //                           decoration: BoxDecoration(
// // //                             borderRadius: BorderRadius.circular(30),
// // //                             border: Border.all(
// // //                               color: AppColors.appBlue,
// // //                               width: 1.5,
// // //                             ),
// // //                           ),
// // //                           child: const Text(
// // //                             "Select File to Upload",
// // //                             textAlign: TextAlign.center,
// // //                             style: AppTextStyles.white24Bold,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //
// // //               const SizedBox(height: 20),
// // //
// // //               if (showUploading)
// // //                 Container(
// // //                   padding: const EdgeInsets.all(14),
// // //                   decoration: BoxDecoration(
// // //                     color: const Color(0xFF192226),
// // //                     borderRadius: BorderRadius.circular(20),
// // //                   ),
// // //                   child: Column(
// // //                     children: [
// // //                       Row(
// // //                         children: [
// // //                           const CircleAvatar(
// // //                             radius: 20,
// // //                             backgroundColor: Color(0xFF123B34),
// // //                             child: Icon(
// // //                               Icons.picture_as_pdf,
// // //                               color: Color(0xFF18E0CC),
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 10),
// // //
// // //                           Expanded(
// // //                             child: Text(
// // //                               fileName ?? "Selected File",
// // //                               style: AppTextStyles.white16bold,
// // //                               maxLines: 1,
// // //                               overflow: TextOverflow.ellipsis,
// // //                             ),
// // //                           ),
// // //
// // //                           IconButton(
// // //                             onPressed: () {
// // //                               setState(() {
// // //                                 showUploading = false;
// // //                                 uploadProgress = 0;
// // //                               });
// // //                             },
// // //                             icon: const Icon(
// // //                               Icons.close,
// // //                               color: Colors.white70,
// // //                               size: 20,
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //
// // //                       const SizedBox(height: 12),
// // //
// // //                       ClipRRect(
// // //                         borderRadius: BorderRadius.circular(8),
// // //                         child: LinearProgressIndicator(
// // //                           value: uploadProgress,
// // //                           minHeight: 6,
// // //                           backgroundColor: Colors.white24,
// // //                           valueColor: const AlwaysStoppedAnimation(
// // //                             Color(0xFFEAC930),
// // //                           ),
// // //                         ),
// // //                       ),
// // //
// // //                       const SizedBox(height: 6),
// // //
// // //                       Row(
// // //                         mainAxisAlignment: MainAxisAlignment.end,
// // //                         children: [
// // //                           Text(
// // //                             "${(uploadProgress * 100).toInt()}% complete",
// // //                             style: const TextStyle(
// // //                               color: Colors.white60,
// // //                               fontSize: 12,
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //
// // //               if (!showUploading) ...[
// // //                 const SizedBox(height: 15),
// // //                 const Center(
// // //                   child: Text(
// // //                     "Or",
// // //                     style: TextStyle(color: Colors.white, fontSize: 24),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 10),
// // //
// // //                 Center(
// // //                   child: InkWell(
// // //                     onTap: () {
// // //                       Navigator.push(
// // //                         context,
// // //                         MaterialPageRoute(builder: (_) => ResumeChat()),
// // //                       );
// // //                     },
// // //                     child: Container(
// // //                       padding: const EdgeInsets.only(bottom: 4),
// // //                       decoration: const BoxDecoration(
// // //                         border: Border(
// // //                           bottom: BorderSide(color: Colors.white, width: 1),
// // //                         ),
// // //                       ),
// // //                       child: const Text(
// // //                         "Create Your Resume",
// // //                         style: TextStyle(
// // //                           color: Colors.white,
// // //                           fontSize: 22,
// // //                           fontWeight: FontWeight.w600,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// //
// // import 'dart:async';
// // import 'dart:io';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import 'package:get/get_instance/src/extension_instance.dart';
// // import 'package:get/get_navigation/src/extension_navigation.dart';
// // import 'package:internsharks/core/const_file/app_colors.dart';
// // import 'package:internsharks/core/const_file/app_text_style.dart';
// // import 'package:internsharks/core/routes/app_pages.dart';
// // import 'package:internsharks/pages/upload_resume/resume_loaded_page.dart';
// // import 'package:internsharks/pages/upload_resume/ResumeChat.dart';
// // import 'package:internsharks/core/const_file/app_colors.dart';
// // import 'package:internsharks/core/const_file/app_text_style.dart';
// // import 'package:internsharks/core/routes/app_pages.dart';
// //
// // import '../../controllers/resigter_controller.dart';
// //
// // class UploadResumePage extends StatefulWidget {
// //   const UploadResumePage({super.key});
// //
// //   @override
// //   State<UploadResumePage> createState() => _UploadResumePageState();
// // }
// //
// // class _UploadResumePageState extends State<UploadResumePage> {
// //   bool showUploading = false;
// //   double uploadProgress = 0.0;
// //
// //   final registerCtrl = Get.put(RegisterFlowController());
// //   File? selectedFile;
// //   String? fileName;
// //
// //   void startUpload() {
// //     setState(() {
// //       showUploading = true;
// //       uploadProgress = 0;
// //     });
// //
// //     Timer.periodic(const Duration(milliseconds: 300), (timer) {
// //       setState(() {
// //         uploadProgress += 0.10;
// //       });
// //       if (uploadProgress >= 1) {
// //         timer.cancel();
// //
// //         Future.delayed(const Duration(milliseconds: 600), () {
// //           if (mounted) {
// //             // 👈 INGHA dhaan use pananum
// //           }
// //         });
// //       }
// //       String extractEmail(String text) {
// //         final reg = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
// //         return reg.firstMatch(text)?.group(0) ?? '';
// //       }
// //
// //       String extractMobile(String text) {
// //         final reg = RegExp(r'\b[6-9]\d{9}\b');
// //         return reg.firstMatch(text)?.group(0) ?? '';
// //       }
// //
// //       String extractName(String text) {
// //         final lines = text.split('\n');
// //         return lines.isNotEmpty ? lines.first.trim() : '';
// //       }
// //
// //       if (uploadProgress >= 1) {
// //         timer.cancel();
// //         if (uploadProgress >= 1) {
// //           timer.cancel();
// //           Future.delayed(const Duration(milliseconds: 600), () async {
// //             if (mounted && selectedFile != null) {
// //
// //               // 🔹 Resume text read
// //               final resumeText = await extractResumeText(selectedFile!);
// //
// //               // 🔹 Filter data
// //               final name   = extractName(resumeText);
// //               final email  = extractEmail(resumeText);
// //               final mobile = extractMobile(resumeText);
// //
// //               // 🔹 Full resume data store
// //               registerCtrl.resumeData.value = {
// //                 "name": name,
// //                 "email": email,
// //                 "mobile": mobile,
// //                 "resumeFile": selectedFile!.path,
// //               };
// //
// //               // 🔹 Required fields
// //               registerCtrl.name.value   = name;
// //               registerCtrl.email.value  = email;
// //               registerCtrl.mobile.value = mobile;
// //
// //               // 🔹 Next page
// //               Get.toNamed(Routes.registerPage);
// //             }
// //           });
// //
// //
// //           // Future.delayed(const Duration(milliseconds: 600), () {
// //           //   if (mounted) {
// //           //
// //           //     registerCtrl.resumeData.value = {
// //           //       "name": "Rokesh",
// //           //       "email": "rokesh@gmail.com",
// //           //       "mobile": "9876543210",
// //           //       "dob": "04-02-2002",
// //           //       "resumeFile": selectedFile?.path,
// //           //     };
// //           //
// //           //     registerCtrl.name.value = "Rokesh";
// //           //     registerCtrl.email.value = "rokesh@gmail.com";
// //           //     registerCtrl.mobile.value = "9876543210";
// //           //     registerCtrl.dob.value = "04-02-2002";
// //           //
// //           //     Get.toNamed(Routes.registerPage);
// //           //   }
// //           // });
// //         }
// //
// //
// //       }
// //     });
// //   }
// //
// //   Future<void> pickFile() async {
// //     FilePickerResult? result = await FilePicker.platform.pickFiles(
// //       type: FileType.custom,
// //       allowedExtensions: ['pdf', 'doc', 'docx'],
// //     );
// //
// //     if (result != null) {
// //       selectedFile = File(result.files.single.path!);
// //       fileName = result.files.single.name;
// //
// //       startUpload();
// //     } else {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(const SnackBar(content: Text("No file selected")));
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.appColor,
// //       appBar: AppBar(
// //         surfaceTintColor: AppColors.appColor,
// //         backgroundColor: AppColors.appColor,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back, size: 25, color: Colors.white),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         title: Text('Upload Resume', style: AppTextStyles.white24Bold),
// //       ),
// //       body: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
// //         width: double.infinity,
// //         height: double.infinity,
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const SizedBox(height: 20),
// //
// //               Container(
// //                 padding: const EdgeInsets.symmetric(
// //                   vertical: 30,
// //                   horizontal: 16,
// //                 ),
// //                 decoration: BoxDecoration(
// //                   gradient: const LinearGradient(
// //                     colors: [
// //                       Color(0xff181713),
// //                       Color(0xff161e16),
// //                       Color(0xff181814),
// //                     ],
// //                     begin: Alignment.topRight,
// //                     end: Alignment.bottomLeft,
// //                   ),
// //                   borderRadius: BorderRadius.circular(30),
// //                 ),
// //                 child: SingleChildScrollView(
// //                   child: Column(
// //                     children: [
// //                       Container(
// //                         width: 180,
// //                         height: 180,
// //                         decoration: const BoxDecoration(
// //                           image: DecorationImage(
// //                             image: AssetImage("asset/images/Frame 10.png"),
// //                             fit: BoxFit.cover,
// //                           ),
// //                         ),
// //                       ),
// //
// //                       const SizedBox(height: 15),
// //
// //                       const Text(
// //                         "Upload Your Resume",
// //                         style: AppTextStyles.white24Bold,
// //                       ),
// //
// //                       const SizedBox(height: 10),
// //
// //                       const Padding(
// //                         padding: EdgeInsets.symmetric(horizontal: 25),
// //                         child: Text(
// //                           "Ready to land your dream Internship? Start by uploading your resume.",
// //                           textAlign: TextAlign.center,
// //                           style: TextStyle(color: Colors.white70, fontSize: 16),
// //                         ),
// //                       ),
// //
// //                       const SizedBox(height: 25),
// //
// //                       InkWell(
// //                         onTap: pickFile,
// //                         child: Container(
// //                           width: double.infinity,
// //                           padding: const EdgeInsets.symmetric(vertical: 10),
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(30),
// //                             border: Border.all(
// //                               color: AppColors.appBlue,
// //                               width: 1.5,
// //                             ),
// //                           ),
// //                           child: const Text(
// //                             "Select File to Upload",
// //                             textAlign: TextAlign.center,
// //                             style: AppTextStyles.white24Bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 20),
// //
// //               if (showUploading)
// //                 Container(
// //                   padding: const EdgeInsets.all(14),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFF192226),
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       Row(
// //                         children: [
// //                           const CircleAvatar(
// //                             radius: 20,
// //                             backgroundColor: Color(0xFF123B34),
// //                             child: Icon(
// //                               Icons.picture_as_pdf,
// //                               color: Color(0xFF18E0CC),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 10),
// //
// //                           Expanded(
// //                             child: Text(
// //                               fileName ?? "Selected File",
// //                               style: AppTextStyles.white16bold,
// //                               maxLines: 1,
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //
// //                           IconButton(
// //                             onPressed: () {
// //                               setState(() {
// //                                 showUploading = false;
// //                                 uploadProgress = 0;
// //                               });
// //                             },
// //                             icon: const Icon(
// //                               Icons.close,
// //                               color: Colors.white70,
// //                               size: 20,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //
// //                       const SizedBox(height: 12),
// //
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(8),
// //                         child: LinearProgressIndicator(
// //                           value: uploadProgress,
// //                           minHeight: 6,
// //                           backgroundColor: Colors.white24,
// //                           valueColor: const AlwaysStoppedAnimation(
// //                             Color(0xFFEAC930),
// //                           ),
// //                         ),
// //                       ),
// //
// //                       const SizedBox(height: 6),
// //
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.end,
// //                         children: [
// //                           Text(
// //                             "${(uploadProgress * 100).toInt()}% complete",
// //                             style: const TextStyle(
// //                               color: Colors.white60,
// //                               fontSize: 12,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //               if (!showUploading) ...[
// //                 const SizedBox(height: 15),
// //                 const Center(
// //                   child: Text(
// //                     "Or",
// //                     style: TextStyle(color: Colors.white, fontSize: 24),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),
// //
// //                 Center(
// //                   child: InkWell(
// //                     onTap: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(builder: (_) => ResumeChat()),
// //                       );
// //                     },
// //                     child: Container(
// //                       padding: const EdgeInsets.only(bottom: 4),
// //                       decoration: const BoxDecoration(
// //                         border: Border(
// //                           bottom: BorderSide(color: Colors.white, width: 1),
// //                         ),
// //                       ),
// //                       child: const Text(
// //                         "Create Your Resume",
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 22,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/response/response.dart' as http;
// import 'package:http/http.dart';
// import 'package:http/http.dart' as http hide Response;
//
// import 'package:internsharks/controllers/resigter_controller.dart';
// import 'package:internsharks/core/const_file/app_colors.dart';
// import 'package:internsharks/core/const_file/app_text_style.dart';
// import 'package:internsharks/core/routes/app_pages.dart';
// import 'package:internsharks/pages/upload_resume/ResumeChat.dart';
//
// class UploadResumePage extends StatefulWidget {
//   const UploadResumePage({super.key});
//
//   @override
//   State<UploadResumePage> createState() => _UploadResumePageState();
// }
//
// class _UploadResumePageState extends State<UploadResumePage> {
//   bool showUploading = false;
//   double uploadProgress = 0.0;
//
//   File? selectedFile;
//   String? fileName;
//
//   final RegisterFlowController registerCtrl =
//   Get.put(RegisterFlowController());
//
//   // 🔹 AI TEAM RESUME EXTRACT API (LOGIC ONLY)
//
//   Future<Map<String, dynamic>> callAnalyzeResumeApi(File file) async {
//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse(ApiUrls.analyzeResume),
//     );
//
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'resume', // 🔴 backend expects this key
//         file.path,
//       ),
//     );
//
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//
//       // 🔹 Example backend response assumption
//       return {
//         "name": decoded['data']['name'],
//         "email": decoded['data']['email'],
//         "mobile": decoded['data']['mobile'],
//         "dob": decoded['data']['dob'],
//         "skills": decoded['data']['skills'],
//         "education": decoded['data']['education'],
//         "full_text": decoded['data']['full_text'],
//       };
//     } else {
//       throw Exception("Resume analyze failed");
//     }
//   }
//   // 🔹 START UPLOAD + PROGRESS + API
//   void startUpload() {
//     setState(() {
//       showUploading = true;
//       uploadProgress = 0;
//     });
//
//     Timer.periodic(const Duration(milliseconds: 300), (timer) async {
//       setState(() {
//         uploadProgress += 0.1;
//       });
//
//       if (uploadProgress >= 1) {
//         timer.cancel();
//
//         if (selectedFile == null) return;
//
//         // 🔹 CALL AI API
//         final aiResponse = await callAiResumeApi(selectedFile!);
//
//         // 🔹 STORE ALL DATA LOCALLY
//         registerCtrl.resumeData.value = aiResponse;
//
//         registerCtrl.name.value = aiResponse['name'] ?? '';
//         registerCtrl.email.value = aiResponse['email'] ?? '';
//         registerCtrl.mobile.value = aiResponse['mobile'] ?? '';
//         registerCtrl.dob.value = aiResponse['dob'] ?? '';
//
//         // 🔹 NEXT PAGE (REGISTER / OTP PAGE)
//         Get.toNamed(Routes.registerPage);
//       }
//     });
//   }
//
//   // 🔹 PICK FILE
//   Future<void> pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//     );
//
//     if (result != null) {
//       selectedFile = File(result.files.single.path!);
//       fileName = result.files.single.name;
//       startUpload();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No file selected")),
//       );
//     }
//   }
//
//   // ================= UI (UNCHANGED) =================
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       appBar: AppBar(
//         surfaceTintColor: AppColors.appColor,
//         backgroundColor: AppColors.appColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back,
//               size: 25, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title:
//         const Text('Upload Resume', style: AppTextStyles.white24Bold),
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
//         width: double.infinity,
//         height: double.infinity,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//
//               /// ---------------- CARD ----------------
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 30,
//                   horizontal: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [
//                       Color(0xff181713),
//                       Color(0xff161e16),
//                       Color(0xff181814),
//                     ],
//                     begin: Alignment.topRight,
//                     end: Alignment.bottomLeft,
//                   ),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 180,
//                       height: 180,
//                       decoration: const BoxDecoration(
//                         image: DecorationImage(
//                           image:
//                           AssetImage("asset/images/Frame 10.png"),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     const Text(
//                       "Upload Your Resume",
//                       style: AppTextStyles.white24Bold,
//                     ),
//                     const SizedBox(height: 10),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 25),
//                       child: Text(
//                         "Ready to land your dream Internship? Start by uploading your resume.",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.white70, fontSize: 16),
//                       ),
//                     ),
//                     const SizedBox(height: 25),
//
//                     /// SELECT FILE
//                     InkWell(
//                       onTap: pickFile,
//                       child: Container(
//                         width: double.infinity,
//                         padding:
//                         const EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                             color: AppColors.appBlue,
//                             width: 1.5,
//                           ),
//                         ),
//                         child: const Text(
//                           "Select File to Upload",
//                           textAlign: TextAlign.center,
//                           style: AppTextStyles.white24Bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               /// ---------------- UPLOAD PROGRESS ----------------
//               if (showUploading)
//                 Container(
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF192226),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           const CircleAvatar(
//                             radius: 20,
//                             backgroundColor: Color(0xFF123B34),
//                             child: Icon(Icons.picture_as_pdf,
//                                 color: Color(0xFF18E0CC)),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               fileName ?? "Selected File",
//                               style: AppTextStyles.white16bold,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 showUploading = false;
//                                 uploadProgress = 0;
//                               });
//                             },
//                             icon: const Icon(Icons.close,
//                                 color: Colors.white70, size: 20),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: LinearProgressIndicator(
//                           value: uploadProgress,
//                           minHeight: 6,
//                           backgroundColor: Colors.white24,
//                           valueColor:
//                           const AlwaysStoppedAnimation(
//                               Color(0xFFEAC930)),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             "${(uploadProgress * 100).toInt()}% complete",
//                             style: const TextStyle(
//                                 color: Colors.white60, fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//               /// ---------------- CREATE RESUME ----------------
//               if (!showUploading) ...[
//                 const SizedBox(height: 15),
//                 const Center(
//                   child: Text(
//                     "Or",
//                     style:
//                     TextStyle(color: Colors.white, fontSize: 24),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Center(
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => ResumeChat()),
//                       );
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.only(bottom: 4),
//                       decoration: const BoxDecoration(
//                         border: Border(
//                           bottom:
//                           BorderSide(color: Colors.white, width: 1),
//                         ),
//                       ),
//                       child: const Text(
//                         "Create Your Resume",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:internsharks/controllers/resigter_controller.dart';
import 'package:internsharks/controllers/resume_controller.dart';
import 'package:internsharks/core/const_file/api_constants.dart';
import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';

import 'ResumeChat.dart';

class UploadResumePage extends StatefulWidget {
  const UploadResumePage({super.key});

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

  // 🔹 ANALYZE RESUME API CALL
  Future<Map<String, dynamic>> callAnalyzeResumeApi(File file) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.analyzeResume),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'resume', // backend expects this key
          file.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // Extract data from API response
        return {
          "name": decoded['data']['name'] ?? '',
          "email": decoded['data']['email'] ?? '',
          "mobile": decoded['data']['mobile'] ?? '',
          "dob": decoded['data']['dob'] ?? '',
          "skills": decoded['data']['skills'] ?? [],
          "education": decoded['data']['education'] ?? [],
          "full_text": decoded['data']['full_text'] ?? '',
        };
      } else {
        throw Exception(
          "Resume analyze failed with status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Error calling analyze API: $e");
      throw Exception("Failed to analyze resume: $e");
    }
  }

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
          // 🔹 CALL ANALYZE RESUME API
          final aiResponse = await callAnalyzeResumeApi(selectedFile!);

          // 🔹 STORE ALL DATA IN CONTROLLER
          registerController.resumeData.value = aiResponse;
          registerController.name.value = aiResponse['name'] ?? '';
          registerController.email.value = aiResponse['email'] ?? '';
          registerController.mobile.value = aiResponse['mobile'] ?? '';
          registerController.dob.value = aiResponse['dob'] ?? '';

          setState(() {
            uploadProgress = 1.0;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Resume analyzed successfully!"),
              backgroundColor: Colors.green,
            ),
          );

          // Wait a moment to show 100% completion
          await Future.delayed(const Duration(milliseconds: 500));

          // 🔹 NAVIGATE TO REGISTER PAGE
          Get.toNamed(Routes.registerPage);
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

    await resumeController.uploadResume(filePath);

    final model = resumeController.resumeAnalyzeModel;

    if (model.success == true && model.resumeData != null) {
      final info = model.resumeData!.personalInfo;

      registerController.name.value = info.name!;
      registerController.email.value = info.email!;

      print(info.name);
      print("********************");

      Get.snackbar("Success", "Resume analyzed successfully");
      Get.toNamed(Routes.registerPage);
    } else {
      Get.snackbar("Failed", "Resume analysis failed");
    }
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
                          image: AssetImage("asset/images/Frame 10.png"),
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
