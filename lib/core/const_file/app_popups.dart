// // ignore_for_file: deprecated_member_use
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
// import 'package:get/get.dart';
// import 'package:help_desk/core/constants/app_colors.dart' show AppColors;
// import 'package:help_desk/core/constants/app_text_styles.dart';
// import 'package:help_desk/core/constants/const.dart' show AppConstants;
// import 'package:help_desk/core/constants/svg_images.dart' show SvgImages;
// import 'package:simple_fontellico_progress_dialog/fontelico_icons.dart'
//     show Fontelico;
// import 'package:simple_fontellico_progress_dialog/rotate_icon.dart'
//     show RotateIcon;
//
// class AppPopups {
//   // /// conformation popup
//   // static conformationPopup({
//   //   required BuildContext context,
//   //   required String title,
//   //   required String middleText,
//   //   required VoidCallback? onConfirm,
//   //   bool barrierDismissible = true,
//   // }) {
//   //   return Get.defaultDialog(
//   //     buttonColor: AppColors.themeBlue,
//   //     title: title,
//   //
//   //     barrierDismissible: barrierDismissible,
//   //     middleText: middleText,
//   //     textConfirm: "Yes",
//   //     textCancel: "No",
//   //     confirmTextColor: Colors.white,
//   //     onConfirm: onConfirm,
//   //     onCancel: () {
//   //       // Navigator.pop(context);
//   //
//   //     },
//   //   );
//   // }
//
//   static Future<void> conformationPopup({
//     required BuildContext context,
//     required String title,
//     required String middleText,
//     required VoidCallback onConfirm,
//     bool barrierDismissible = true,
//   }) async {
//     return Get.dialog(
//       AlertDialog(
//         backgroundColor: Colors.white,
//
//         title: Text(
//           title,
//           style: TextStyle(
//             color: AppColors.themeBlue,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: Text(middleText, style: TextStyle(fontSize: 16)),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Get.back(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.themeBlue,
//             ),
//             child: const Text("No", style: TextStyle(color: Colors.white)),
//           ),
//
//           // TextButton(
//           //   onPressed: () {
//           //     Get.back(); // Just closes the popup
//           //   },
//           //   child: const Text("No", style: TextStyle(color: Colors.white)),
//           // ),
//           ElevatedButton(
//             onPressed: () => onConfirm(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.themeBlue,
//             ),
//             child: const Text("Yes", style: TextStyle(color: Colors.white)),
//           ),
//           // TextButton(
//           //   onPressed: () {
//           //     onConfirm(); // Run the confirmation logic
//           //   },
//           //   child: const Text("Yes", style: TextStyle(color: Colors.green)),
//           // ),
//         ],
//       ),
//       barrierDismissible: barrierDismissible,
//     );
//   }
//
//   /// widget circular progress indicator
//   static widgetCircularProgressIndicator(
//       BuildContext context, {
//         Color color = AppColors.themeBlue,
//       }) {
//     return SizedBox(
//       height: AppConstants.screenHeight(context),
//       width:
//       kIsWeb
//           ? AppConstants.screenWidth(context) * 0.4
//           : AppConstants.screenWidth(context),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           RotateIcon(
//             //
//             // key: key,
//             duration: const Duration(milliseconds: 900),
//             child: Icon(
//               Fontelico.multiHurricane,
//               color: AppColors.themeBlue,
//               size: 50.0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static circularProgressIndicator({Color color = AppColors.themeBlue}) {
//     return Get.dialog(
//       Center(child: CircularProgressIndicator(color: color)),
//       barrierDismissible: false,
//     );
//   }
//
//   /// info popup
//
//   static void infoPopup({
//     required String title,
//     required String middleText,
//     required BuildContext context,
//   }) {
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         backgroundColor: Colors.white,
//         title: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: AppColors.themeBlue,
//           ),
//         ),
//         content: Text(
//           middleText,
//           style: TextStyle(fontSize: 16, color: Colors.black87),
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Get.back(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.themeBlue,
//             ),
//             child: const Text("OK", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//   }
//
// // static infoPopup({
// //   required BuildContext context,
// //   required String title,
// //   required String middleText,
// //
// //   bool barrierDismissible = false,
// // }) {
// //   return Get.defaultDialog(
// //  //   buttonColor: AppColors.themeBlue,
// //     title: title,
// //     middleText: middleText,
// //     textConfirm: "Ok",
// //     // textCancel: "No",
// //     confirmTextColor: Colors.white,
// //     onConfirm: () {
// //       Get.back(); // Close dialog
// //     },
// //   );
// // }
// }