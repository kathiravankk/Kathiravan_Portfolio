// // import 'dart:ui';
// //
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io';
// //
// // import 'package:internsharks/const_file/app_colors.dart';
// // import 'package:internsharks/const_file/app_text_style.dart';
// // import 'package:internsharks/const_file/asset_image.dart';
// // import 'package:internsharks/screens/home_Screen.dart';
// //
// // class KYCVerificationPage extends StatefulWidget {
// //   @override
// //   _KYCVerificationPageState createState() => _KYCVerificationPageState();
// // }
// //
// // class _KYCVerificationPageState extends State<KYCVerificationPage> {
// //   File? _selectedImage;
// //   final ImagePicker _picker = ImagePicker();
// //
// //   bool showSubmit = false;
// //   bool showUploading = false;
// //   double uploadProgress = 0;
// //   String? fileName;
// //
// //   Future<void> _pickImage() async {
// //     try {
// //       final XFile? image = await _picker.pickImage(
// //         source: ImageSource.gallery,
// //         imageQuality: 85,
// //       );
// //
// //       if (image != null) {
// //         final file = File(image.path);
// //
// //         setState(() {
// //           _selectedImage = file;
// //           showSubmit = true;
// //           fileName = file.path.split('/').last;
// //         });
// //       }
// //     } catch (e) {}
// //   }
// //
// //   Future<void> _pickFromCamera() async {
// //     try {
// //       final XFile? image = await _picker.pickImage(
// //         source: ImageSource.camera,
// //         imageQuality: 85,
// //       );
// //
// //       if (image != null) {
// //         setState(() {
// //           _selectedImage = File(image.path);
// //           showSubmit = true;
// //           fileName = image.name;
// //         });
// //       }
// //     } catch (e) {}
// //   }
// //
// //   void _showUploadOptions() {
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Color(0xFF2D3748),
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       builder: (context) => Container(
// //         padding: EdgeInsets.all(20),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             ListTile(
// //               leading: Icon(Icons.photo_library, color: Colors.amber),
// //               title: Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
// //               onTap: () {
// //                 Navigator.pop(context);
// //                 _pickImage();
// //               },
// //             ),
// //             ListTile(
// //               leading: Icon(Icons.camera_alt, color: Colors.amber),
// //               title: Text('Take Photo', style: TextStyle(color: Colors.white)),
// //               onTap: () {
// //                 Navigator.pop(context);
// //                 _pickFromCamera();
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _startUpload() async {
// //     setState(() {
// //       showUploading = true;
// //       showSubmit = false;
// //     });
// //
// //     for (int i = 0; i <= 100; i++) {
// //       await Future.delayed(Duration(milliseconds: 30));
// //       setState(() {
// //         uploadProgress = i / 100;
// //       });
// //     }
// //
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => const HomePages(activeStep: 3),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         width: double.infinity,
// //         height: double.infinity,
// //         decoration: BoxDecoration(
// //           image: DecorationImage(
// //             image: AssetImage(AppAssetImages.backgroundimage),
// //             fit: BoxFit.cover,
// //           ),
// //         ),
// //         child: Column(
// //           children: [
// //             SizedBox(height: 40),
// //             Row(
// //               children: [
// //                 IconButton(
// //                   icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
// //                   onPressed: () => Navigator.pop(context),
// //                 ),
// //                 Text('KYC Verification', style: AppTextStyles.white24Bold),
// //               ],
// //             ),
// //
// //             Expanded(
// //               child: SingleChildScrollView(
// //                 child: Padding(
// //                   padding: EdgeInsets.all(24.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //
// //                       Text('Upload a Valid\nGovernment-Issued ID',
// //                           style: AppTextStyles.white26Bold),
// //
// //                       SizedBox(height: 25),
// //
// //                       GestureDetector(
// //                         onTap: _showUploadOptions,
// //                         child: Stack(
// //                           children: [
// //                             Container(
// //                               width: double.infinity,
// //                               height: 280,
// //                               decoration: BoxDecoration(
// //                                 gradient: LinearGradient(
// //                                   colors: [
// //                                     Color(0xff121515),
// //                                     Color(0xff101d1d),
// //                                     Color(0xff111f1f),
// //                                     Color(0xff111b1b),
// //                                   ],
// //                                 ),
// //                                 borderRadius: BorderRadius.circular(16),
// //                               ),
// //                             ),
// //
// //                             Positioned.fill(
// //                               child: CustomPaint(
// //                                 painter: DashedRectPainter(
// //                                   color: Colors.grey.withOpacity(0.5),
// //                                   strokeWidth: 2.0,
// //                                   gap: 10.0,
// //                                   dash: 8.0,
// //                                   radius: 16.0,
// //                                 ),
// //                               ),
// //                             ),
// //
// //                             _selectedImage == null
// //                                 ? Center(
// //                               child: Column(
// //                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                 children: [
// //                                   Icon(Icons.cloud_upload_outlined,
// //                                       size: 64, color: Colors.grey[500]),
// //                                   SizedBox(height: 15),
// //                                   Text('Tap to Upload Document',
// //                                       style: TextStyle(color: Colors.white, fontSize: 18)),
// //                                   SizedBox(height: 8),
// //                                   Text('PNG, JPG, PDF up to 10MB',
// //                                       style: TextStyle(color: Colors.grey[500], fontSize: 14)),
// //                                 ],
// //                               ),
// //                             )
// //                                 :
// //                             Stack(
// //                               children: [
// //                                 ClipRRect(
// //                                   borderRadius: BorderRadius.circular(16),
// //                                   child: Image.file(
// //                                     _selectedImage!,
// //                                     width: double.infinity,
// //                                     height: 280,
// //                                     fit: BoxFit.cover,
// //                                   ),
// //                                 ),
// //
// //                                 Positioned(
// //                                   bottom: 12,
// //                                   left: 12,
// //                                   right: 12,
// //                                   child: Container(
// //                                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.black.withOpacity(0.45),
// //                                       borderRadius: BorderRadius.circular(10),
// //                                     ),
// //                                     child: Row(
// //                                       children: [
// //                                         Icon(Icons.insert_drive_file, color: Colors.white, size: 18),
// //                                         SizedBox(width: 8),
// //
// //                                         Expanded(
// //                                           child: Text(
// //                                             _selectedImage!.path.split('/').last,
// //                                             maxLines: 1,
// //                                             overflow: TextOverflow.ellipsis,
// //                                             style: TextStyle(
// //                                               color: Colors.white,
// //                                               fontSize: 14,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             )
// //                           ],
// //                         ),
// //                       ),
// //
// //                       SizedBox(height: 20),
// //
// //                       if (showSubmit && !showUploading)
// //                         ElevatedButton(
// //                           onPressed: _startUpload,
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Color(0xFF00D9FF),
// //                             foregroundColor: Colors.black,
// //                             padding: EdgeInsets.symmetric(vertical: 16),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(30),
// //                             ),
// //                           ),
// //                           child: Text("Submit",
// //                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                         ),
// //
// //                       if (showUploading)
// //                         Container(
// //                           padding: const EdgeInsets.all(14),
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xFF192226),
// //                             borderRadius: BorderRadius.circular(20),
// //                           ),
// //                           child: Column(
// //                             children: [
// //                               Row(
// //                                 children: [
// //                                   CircleAvatar(
// //                                     radius: 20,
// //                                     backgroundColor: Color(0xFF123B34),
// //                                     child: Icon(Icons.picture_as_pdf, color: Color(0xFF18E0CC)),
// //                                   ),
// //                                   SizedBox(width: 10),
// //                                   Expanded(
// //                                     child: Text(
// //                                       fileName ?? "Selected File",
// //                                       style: AppTextStyles.white16bold,
// //                                       overflow: TextOverflow.ellipsis,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //
// //                               SizedBox(height: 12),
// //
// //                               ClipRRect(
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 child: LinearProgressIndicator(
// //                                   value: uploadProgress,
// //                                   minHeight: 6,
// //                                   backgroundColor: Colors.white24,
// //                                   valueColor: AlwaysStoppedAnimation(Color(0xFFEAC930)),
// //                                 ),
// //                               ),
// //
// //                               SizedBox(height: 6),
// //
// //                               Row(
// //                                 mainAxisAlignment: MainAxisAlignment.end,
// //                                 children: [
// //                                   Text(
// //                                     "${(uploadProgress * 100).toInt()}% complete",
// //                                     style: TextStyle(color: Colors.white60, fontSize: 12),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class DashedRectPainter extends CustomPainter {
// //   final Color color;
// //   final double strokeWidth;
// //   final double gap;
// //   final double dash;
// //   final double radius;
// //
// //   DashedRectPainter({required this.color, required this.strokeWidth,required this.gap,required this.dash,required this.radius});
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     Paint paint = Paint()
// //       ..color = color
// //       ..strokeWidth = strokeWidth
// //       ..style = PaintingStyle.stroke;
// //
// //     RRect rRect = RRect.fromRectAndRadius(
// //       Rect.fromLTWH(0, 0, size.width, size.height),
// //       Radius.circular(radius),
// //     );
// //
// //     Path path = Path()..addRRect(rRect);
// //
// //     Path dashedPath = Path();
// //     double distance = 0.0;
// //
// //     for (PathMetric pm in path.computeMetrics()) {
// //       while (distance < pm.length) {
// //         dashedPath.addPath(pm.extractPath(distance, distance + dash), Offset.zero);
// //         distance += dash + gap;
// //       }
// //     }
// //
// //     canvas.drawPath(dashedPath, paint);
// //   }
// //
// //   @override
// //   bool shouldRepaint(CustomPainter oldDelegate) => true;
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:internsharks/const_file/app_colors.dart';
// import 'package:internsharks/const_file/app_text_style.dart';
// import 'dart:io';
//
// import 'package:internsharks/const_file/asset_image.dart';
// import 'package:internsharks/page/upload_selfie/upload_selfie_page.dart';
// import 'package:internsharks/screens/home_Screen.dart';
//
// class KYCVerificationPage extends StatefulWidget {
//   @override
//   _KYCVerificationPageState createState() => _KYCVerificationPageState();
// }
//
// class _KYCVerificationPageState extends State<KYCVerificationPage> {
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();
//
//
//
//   bool showSubmit = false;
//   bool showUploading = false;
//   double uploadProgress = 0;
//   String? fileName;
//   void _startUpload() async {
//     setState(() {
//       showUploading = true;
//       showSubmit = false;
//     });
//
//     for (int i = 0; i <= 100; i++) {
//       await Future.delayed(Duration(milliseconds: 30));
//       setState(() {
//         uploadProgress = i / 100;
//       });
//     }
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const HomePages(activeStep: 3),
//       ),
//     );
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );
//
//       if (image != null) {
//         final file = File(image.path);
//         final fileSize = await file.length();
//
//         if (fileSize > 10 * 1024 * 1024) {
//           _showSnackBar('File size must be less than 10MB');
//           return;
//         }
//
//         setState(() {
//           _selectedImage = file;
//         });
//       }
//     } catch (e) {
//       _showSnackBar('Error picking image: $e');
//     }
//   }
//
//   Future<void> _pickFromCamera() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );
//
//       if (image != null) {
//         setState(() {
//           _selectedImage = File(image.path);
//         });
//       }
//     } catch (e) {
//       _showSnackBar('Error taking photo: $e');
//     }
//   }
//
//   void _showUploadOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Color(0xFF2D3748),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.photo_library, color: Colors.amber),
//               title: Text(
//                 'Choose from Gallery',
//                 style: TextStyle(color: Colors.white),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.camera_alt, color: Colors.amber),
//               title: Text('Take Photo', style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickFromCamera();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red[700],
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }
//
//   void _submitDocument() {
//     if (_selectedImage != null) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           backgroundColor: Color(0xFF2D3748),
//           title: Text('Success', style: TextStyle(color: Colors.amber)),
//           content: Text(
//             'Document uploaded successfully! Verification in progress...',
//             style: TextStyle(color: Colors.white),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK', style: TextStyle(color: Colors.amber)),
//             ),
//           ],
//         ),
//       );
//     } else {
//       _showSnackBar('Please upload a document first');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Color(0xFF1A202C),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppAssetImages.backgroundimage),
//           ),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: 40),
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 Text('KYC Verification', style: AppTextStyles.white24Bold),
//               ],
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.all(24.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header Section
//                       Center(
//                         child: Column(
//                           children: [
//                             Text(
//                               'Secure Your Account',
//                               style: TextStyle(
//                                 color: AppColors.appYellow,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 12),
//                             Text(
//                               'Please upload the required documents to complete your KYC Verification',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.grey[400],
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 40),
//
//                       // Upload Section Title
//                       Text(
//                         'Upload a Valid\nGovernment-Issued ID',
//                         style: AppTextStyles.white26Bold,
//                       ),
//                       SizedBox(height: 16),
//
//                       // Instructions
//                       Text(
//                         'Make sure the image is clear and all four corners are visible. Accepted documents: Passport, Driver\'s License, Aadhar Card.',
//                         style: TextStyle(color: Colors.grey[400], fontSize: 16),
//                       ),
//                       SizedBox(height: 25),
//                       GestureDetector(
//                         onTap: _showUploadOptions,
//                         child: Stack(
//                           children: [
//                             Container(
//                               width: double.infinity,
//                               height: 280,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Color(0xff121515),
//                                     Color(0xff101d1d),
//                                     Color(0xff111f1f),
//                                     Color(0xff111b1b),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                             ),
//
//                             Positioned.fill(
//                               child: CustomPaint(
//                                 // painter: DashedRectPainter(
//                                 //   color: Colors.grey.withOpacity(0.5),
//                                 //   strokeWidth: 2.0,
//                                 //   gap: 10.0,
//                                 //   dash: 8.0,
//                                 //   radius: 16.0,
//                                 // ),
//                               ),
//                             ),
//
//                             _selectedImage == null
//                                 ? Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [SizedBox(height: 40),
//                                   Icon(Icons.cloud_upload_outlined,
//                                       size: 64, color: Colors.grey[500]),
//                                   SizedBox(height: 15),
//                                   Text('Tap to Upload Document',
//                                       style: TextStyle(color: Colors.white, fontSize: 18)),
//                                   SizedBox(height: 8),
//                                   Text('PNG, JPG, PDF up to 10MB',
//                                       style: TextStyle(color: Colors.grey[500], fontSize: 14)),
//                                 ],
//                               ),
//                             )
//                                 :
//                             Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(16),
//                                   child: Image.file(
//                                     _selectedImage!,
//                                     width: double.infinity,
//                                     height: 280,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//
//                                 Positioned(
//                                   bottom: 12,
//                                   left: 12,
//                                   right: 12,
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                                     decoration: BoxDecoration(
//                                       color: Colors.black.withOpacity(0.45),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Icon(Icons.insert_drive_file, color: Colors.white, size: 18),
//                                         SizedBox(width: 8),
//
//                                         Expanded(
//                                           child: Text(
//                                             _selectedImage!.path.split('/').last,
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//
//                       // Upload Area
//                       if (showSubmit && !showUploading)
//                         ElevatedButton(
//                           onPressed: _startUpload,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFF00D9FF),
//                             foregroundColor: Colors.black,
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           child: Text("Submit",
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         ),
//
//                       if (showUploading)
//                         Container(
//                           padding: const EdgeInsets.all(14),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF192226),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 20,
//                                     backgroundColor: Color(0xFF123B34),
//                                     child: Icon(Icons.picture_as_pdf, color: Color(0xFF18E0CC)),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Expanded(
//                                     child: Text(
//                                       fileName ?? "Selected File",
//                                       style: AppTextStyles.white16bold,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               SizedBox(height: 12),
//
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: LinearProgressIndicator(
//                                   value: uploadProgress,
//                                   minHeight: 6,
//                                   backgroundColor: Colors.white24,
//                                   valueColor: AlwaysStoppedAnimation(Color(0xFFEAC930)),
//                                 ),
//                               ),
//
//                               SizedBox(height: 6),
//
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     "${(uploadProgress * 100).toInt()}% complete",
//                                     style: TextStyle(color: Colors.white60, fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       // Submit Button
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
