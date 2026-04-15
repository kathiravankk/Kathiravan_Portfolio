// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:internsharks/const_file/app_colors.dart';
// import 'package:internsharks/const_file/app_text_style.dart';
// import 'package:internsharks/const_file/asset_image.dart';
// import 'package:internsharks/page/upload_resdp/resumeScreen.dart';
//
// class AnalyseResumePage extends StatefulWidget {
//   const AnalyseResumePage({super.key});
//
//   @override
//   State<AnalyseResumePage> createState() => _AnalyseResumePageState();
// }
//
// class _AnalyseResumePageState extends State<AnalyseResumePage> {
//   bool isLoading = true; // whether loading 0 – 100%
//   bool isSecondAnalysis = false; // after Change button
//   double progress = 0.0; // 0 to 1.0
//
//   // Issues only shown first time
//   List<String> issues = [];
//
//   // Message changes second time
//   String resultMessage = "";
//
//   @override
//   void initState() {
//     super.initState();
//     analyseResume();
//   }
//
//   /// Fake loading processor 0% to 100%
//   Future<void> analyseResume() async {
//     setState(() {
//       isLoading = true;
//       progress = 0;
//       issues.clear();
//       resultMessage = "";
//     });
//
//     for (int i = 0; i <= 100; i++) {
//       await Future.delayed(const Duration(milliseconds: 30));
//       setState(() {
//         progress = i / 100;
//       });
//     }
//
//     setState(() {
//       isLoading = false;
//
//       // FIRST TIME → show issues
//       if (!isSecondAnalysis) {
//         resultMessage =
//             "Tailer your resume for each job application by highlighting relavant skills and experiance";
//       } else {
//         // SECOND TIME → perfect
//         issues.clear();
//         resultMessage =
//             "Now perfect — craft a target resume for each job by emphasizing relevant strengths and work experience";
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppAssetImages.backgroundimage),
//             fit: BoxFit.cover,
//           ),
//         ),
//         width: double.infinity,
//         height: double.infinity,
//         child: isLoading ? buildLoadingView() : buildResultView(),
//       ),
//     );
//   }
//
//
//   Widget buildLoadingView() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             /// Top Title + Percent
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Optimizing Resume",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 Text(
//                   "${(progress * 100).toInt()}%",
//                   style: const TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 10),
//
//
//             LinearProgressIndicator(
//               value: progress,
//               color: Colors.yellow,
//               backgroundColor: Colors.white24,
//               minHeight: 6,
//             ),
//
//             const SizedBox(height: 25),
//
//             const Text(
//               "Analysing your resume..",
//               style: TextStyle(
//                 color: Colors.yellow,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget buildResultView() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           /// Top Title + 100%
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text("Optimizing Resume", style: AppTextStyles.white18bold),
//               Text("100%", style: TextStyle(color: Colors.white)),
//             ],
//           ),
//
//           const SizedBox(height: 10),
//
//           /// Full Progress Bar
//           LinearProgressIndicator(
//             value: 1,
//             backgroundColor: Colors.white24,
//             color: Colors.yellow,
//             minHeight: 6,
//           ),
//
//           const SizedBox(height: 30),
//
//           const Text(
//             "Analysing your resume..",
//             style: TextStyle(
//               color: Colors.yellow,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           const SizedBox(height: 15),
//
//           /// MAIN MESSAGE
//           Text(
//             resultMessage,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           /// FIRST TIME ONLY → show missing issues
//           if (!isSecondAnalysis) ...[
//             const SizedBox(height: 20),
//             ...issues.map(
//               (txt) => Padding(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 child: Text(
//                   "• $txt",
//                   style: const TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//
//           const SizedBox(height: 40),
//
//
//
//
//           if (isSecondAnalysis)
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const ResumeScreen(),
//                   ),
//                 );
//               },
//               child: SizedBox(width: 200,
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(45),
//                     color: AppColors.thirdColor,
//                     border: Border.all(color: AppColors.appBlue, width: 1),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: const Center(
//                     child: Text("Next", style: AppTextStyles.white22bold),
//                   ),
//                 ),
//               ),
//             ),
//
//           if (!isSecondAnalysis)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         isSecondAnalysis = true;
//                       });
//                       analyseResume();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(45),
//                         color: AppColors.thirdColor,
//                         border: Border.all(color: AppColors.appBlue, width: 1),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: const Center(
//                         child: Text("Change", style: AppTextStyles.white22bold),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const ResumeScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(45),
//                         color: AppColors.thirdColor,
//                         border: Border.all(color: Colors.white24, width: 1),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: const Center(
//                         child: Text("Skip", style: AppTextStyles.white22bold),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }
