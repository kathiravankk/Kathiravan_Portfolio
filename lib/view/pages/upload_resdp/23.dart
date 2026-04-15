// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:internsharks/const_file/app_colors.dart';
// import 'package:internsharks/const_file/app_text_style.dart';
// import 'package:internsharks/const_file/asset_image.dart';
// import 'package:internsharks/screens/final_screen.dart';
// import 'package:internsharks/screens/home_Screen.dart';
// import 'package:share_plus/share_plus.dart';
//
// class ResDpScreen extends StatefulWidget {
//   const ResDpScreen({super.key});
//
//   @override
//   State<ResDpScreen> createState() => _ResDpScreenState();
// }
//
// class _ResDpScreenState extends State<ResDpScreen> {
//   bool isLoading = true;
//   double progress = 0.0;
//   bool isLiked = false;
//   bool showAiAssistant = false;
//   bool showOnlyTwo = false;
//   final TextEditingController _aiController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     simulateProgress();
//   }
//
//   void _handleLike() {
//     setState(() {
//       isLiked = !isLiked;
//     });
//   }
//
//   void _handleShare() {
//     Share.share('Check out my resume - Anantha Krishnan\nFull Stack Developer');
//   }
//
//   void _handleAiSubmit() {
//     if (_aiController.text.trim().isNotEmpty) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           backgroundColor: Colors.grey[900],
//           title: const Text('AI Resume Assistant'),
//           content: Text(
//             'Processing: "${_aiController.text}"\nImproving your resume...',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _aiController.clear();
//               },
//               child: const Text('OK', style: TextStyle(color: Colors.cyan)),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   void simulateProgress() {
//     Timer.periodic(const Duration(milliseconds: 40), (timer) {
//       setState(() {
//         progress += 0.02;
//         if (progress >= 1.0) {
//           progress = 1.0;
//           isLoading = false;
//           timer.cancel();
//         }
//       });
//     });
//   }
//
//   Widget buildLoadingView() {
//     return Container(
//       height: double.infinity,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(AppAssetImages.backgroundimage),
//         ),
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Optimizing ResDP",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   Text(
//                     "${(progress * 100).toInt()}%",
//                     style: const TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//
//               /// Loading Bar
//               LinearProgressIndicator(
//                 value: progress,
//                 color: Colors.yellow,
//                 backgroundColor: Colors.white24,
//                 minHeight: 6,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildResultView() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               const Text("ResDP", style: AppTextStyles.white24Bold),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 30.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: const [
//                 Icon(Icons.stars, color: Colors.amber, size: 16),
//                 SizedBox(width: 4),
//                 Text(
//                   'Credit: 100',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//
//           /// Resume Display Picture (DP)
//           ClipRRect(
//             borderRadius: BorderRadius.circular(30),
//             child: Image.assets(
//               "lib/assets/images/Rectangle 144.png", // <-- put your image here
//               height: 180,
//               width: 300,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           /// Buttons Row (Like - Share - Download - Reset)
//           Container(
//             width: 270,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(45),
//               color: AppColors.thirdColor,
//               border: Border.all(color: Colors.white24, width: 1),
//             ),
//             padding: const EdgeInsets.symmetric(vertical: 12),
//
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildActionButton(
//                   icon: isLiked ? Icons.favorite : Icons.favorite_border,
//                   color: isLiked ? Colors.red : Colors.white,
//                   onTap: _handleLike,
//                 ),
//                 _buildActionButton(
//                   icon: Icons.share_outlined,
//                   color: Colors.white,
//                   onTap: _handleShare,
//                 ),
//
//                 _buildActionButton(
//                   icon: Icons.download_outlined,
//                   color: Colors.white,
//                   onTap: () {},
//                 ),
//                 Container(
//                   // color: AppColors.appColor,
//                   padding: EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     color: AppColors.appBlue,
//                     shape: BoxShape.circle,
//                   ),
//                   child: _buildActionButton(
//                     icon: Icons.refresh,
//                     color: Colors.white,
//                     onTap: () {
//                       setState(() {
//                         showAiAssistant = true;
//                         showOnlyTwo = false;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 25),
//           // ✅ STATE 3 - After ⭐ tap
//           if (showOnlyTwo)
//             Column(
//               children: [
//                 const Text(
//                   "Now Perfect! Your ResDP to\nStandsup!",
//                   style: TextStyle(
//                     color: AppColors.appYellow,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Your suggestion resume shines! It's perfectly crafted to catch employers' eyes, highlighting your unique strengths and achievements. You're ready to make a powerful impression!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//               ],
//             )
//           else if (showAiAssistant)
//             Column(
//               children: [
//                 const Text(
//                   "Great! Your ResDP looks outstanding and professional!",
//                   style: TextStyle(
//                     color: AppColors.appYellow,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Your ResDP looks outstanding! It highlights your key skills and "
//                   "achievements in a way that grabs employers attention, "
//                   "You're all set to leave a great impression!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'AI Resume Assistant',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: AppColors.thirdColor,
//                     border: Border.all(color: Colors.white24, width: 1),
//                   ),
//                   // padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: TextFormField(
//                     controller: _aiController,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     // 🔥 unlimited lines
//                     minLines: 1,
//                     // start with 1 line
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: 'Ask AI to improve your resume',
//                       hintStyle: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 14,
//                       ),
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 14,
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: const BoxDecoration(
//                             color: Colors.cyan,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.star_border,
//                             size: 20,
//                             color: Colors.black,
//                           ),
//                         ),
//                         onPressed: _handleAiSubmit,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // AI textbox
//               ],
//             )
//
//           else
//             Column(
//               children: [
//                 const Text(
//                   "Amazing! Your ResDP to\nStandsup!",
//                   style: TextStyle(
//                     color: AppColors.appYellow,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Your suggestion resume shines! It's perfectly crafted to catch employers' eyes, highlighting your unique strengths and achievements. You're ready to make a powerful impression!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//                 const SizedBox(height: 20),
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Improvement Suggestion",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       showOnlyTwo = true; // ✅ FIXED
//                     });
//                   },
//                   child: suggestionTile(
//                     "⭐",
//                     "Quantity Achievements with number",
//                     AppColors.appBlue,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 suggestionTile(
//                   "🖼️",
//                   "Using some good quality Picture",
//                   Colors.white24,
//                 ),
//               ],
//             ),
//           const SizedBox(height: 40),
//
//           GestureDetector(
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const FinalScreen()),
//               );
//             },
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(40),
//                 border: Border.all(color: Colors.cyan, width: 2),
//               ),
//               child: const Text(
//                 "Continue",
//                 textAlign: TextAlign.center,
//                 style: AppTextStyles.white24Bold,
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
//
//   Widget suggestionTile(String icon, String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(color: color, width: 1.5),
//       ),
//       child: Row(
//         children: [
//           Text(icon, style: const TextStyle(fontSize: 30)),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Icon(icon, color: color, size: 20),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: isLoading ? buildLoadingView() : buildResultView(),
//     );
//   }
// }
