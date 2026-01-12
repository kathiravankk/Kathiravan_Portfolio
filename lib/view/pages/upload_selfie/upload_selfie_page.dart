// // import 'package:flutter/material.dart';
// // import 'dart:ui';
// //
// // import 'package:internsharks/const_file/app_colors.dart';
// // import 'package:internsharks/const_file/app_text_style.dart';
// //
// // import 'review_upload_selfie.dart';
// //
// // class UploadSelfiePage extends StatefulWidget {
// //   const UploadSelfiePage({super.key});
// //
// //   @override
// //   State<UploadSelfiePage> createState() => _UploadSelfiePageState();
// // }
// //
// // class _UploadSelfiePageState extends State<UploadSelfiePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
// //         width: double.infinity,
// //         height: double.infinity,
// //         color: AppColors.appColor,
// //         child: Column(
// //           children: [
// //             Row(
// //               children: [
// //                 IconButton(
// //                   icon: const Icon(Icons.arrow_back, color: Colors.white,size: 25,),
// //                   onPressed: () {},
// //                 ),
// //                 Text(
// //                   "Upload Selfie",
// //                   style: AppTextStyles.white24Bold
// //                 ),
// //               ],
// //             ),
// //
// //             // Description Text
// //             const Padding(
// //               padding: EdgeInsets.symmetric(horizontal: 20.0),
// //               child: Text(
// //                 "Ready for your close-up? A great photo helps you stand out.",
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   color: Colors.white70,
// //                   fontSize: 18,
// //                   height: 1.4,
// //                 ),
// //               ),
// //             ),
// //
// //             const SizedBox(height: 40),
// //
// //             // Camera Frame Area
// //             Expanded(
// //               child: Center(
// //                 child: SizedBox(
// //                   width: 300,
// //                   height: 450, // Adjust height to match aspect ratio
// //                   child: Stack(
// //                     children: [
// //                       // 1. The Dashed Border Layer
// //                       Positioned.fill(
// //                         child: CustomPaint(
// //                           painter: DashedRectPainter(
// //                             color: Colors.grey.withOpacity(0.5),
// //                             strokeWidth: 2.0,
// //                             gap: 10.0,
// //                             dash: 8.0,
// //                             radius: 30.0,
// //                           ),
// //                         ),
// //                       ),
// //
// //                       // 2. The Solid Corner Accents
// //                       // Top Left
// //                       const Positioned(
// //                         top: 0,
// //                         left: 0,
// //                         child: CornerBracket(isTop: true, isLeft: true),
// //                       ),
// //                       // Top Right
// //                       const Positioned(
// //                         top: 0,
// //                         right: 0,
// //                         child: CornerBracket(isTop: true, isLeft: false),
// //                       ),
// //                       // Bottom Left
// //                       const Positioned(
// //                         bottom: 0,
// //                         left: 0,
// //                         child: CornerBracket(isTop: false, isLeft: true),
// //                       ),
// //                       // Bottom Right
// //                       const Positioned(
// //                         bottom: 0,
// //                         right: 0,
// //                         child: CornerBracket(isTop: false, isLeft: false),
// //                       ),
// //
// //                       // 3. Center Content (Face Icon & Text)
// //                       Center(
// //                         child: Column(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Icon(Icons.face, size: 60, color: Colors.grey.withOpacity(0.5)),
// //                             const SizedBox(height: 16),
// //                             const Text(
// //                               "Align your face here",
// //                               style: TextStyle(
// //                                 color: Colors.white70,
// //                                 fontSize: 16,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //
// //                       // 4. Sparkle Filter Indicator
// //                       Positioned(
// //                         bottom: 30,
// //                         left: 0,
// //                         right: 0,
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: const [
// //                             Icon(
// //                               Icons.auto_awesome,
// //                               size: 20,
// //                               color: Colors.white70,
// //                             ),
// //                             SizedBox(width: 8),
// //                             Text(
// //                               "Sparkle Filter",
// //                               style: TextStyle(
// //                                 color: Colors.white70,
// //                                 fontSize: 16,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //
// //             const SizedBox(height: 30),
// //
// //             // Bottom Action Buttons
// //             Padding(
// //               padding: const EdgeInsets.only(bottom: 40.0, left: 20, right: 20),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // Left Button (Upload)
// //                   _buildActionButton(
// //                     icon: Icons.image_outlined,
// //                     label: "Upload Selfie",
// //                     color: const Color(0xFF1F232F),
// //                     iconColor: Colors.white60,
// //                   ),
// //
// //                   // Center Button (Take Photo)
// //                   InkWell(onTap: () {
// //                     Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewUploadSelfie(),))
// // ;                  },
// //                     child: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Container(
// //                           width: 70,
// //                           height: 70,
// //                           decoration: const BoxDecoration(
// //                             color: Color(0xFF00BCD4), // Cyan color
// //                             shape: BoxShape.circle,
// //                           ),
// //                           child: const Icon(
// //                             Icons.camera_alt_outlined,
// //                             color: Colors.white70,
// //                             size: 36,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 12),
// //                         const Text(
// //                           "Take Selfie",
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //
// //                   // Right Button (Generate)
// //                   _buildActionButton(
// //                     icon: Icons.auto_fix_high,
// //                     label: "Generate",
// //                     color: const Color(0xFF1F232F),
// //                     iconColor: Colors.white60,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //     ;
// //   }
// // }
// //
// // Widget _buildActionButton({
// //   required IconData icon,
// //   required String label,
// //   required Color color,
// //   required Color iconColor,
// // }) {
// //   return Column(
// //     mainAxisSize: MainAxisSize.min,
// //     children: [
// //       Container(
// //         width: 70,
// //         height: 70,
// //         decoration: BoxDecoration(color: color, shape: BoxShape.circle),
// //         child: Icon(icon, color: iconColor, size: 28),
// //       ),
// //       const SizedBox(height: 12),
// //       Text(
// //         label,
// //         style: const TextStyle(
// //           color: Colors.white,
// //           fontSize: 14,
// //           fontWeight: FontWeight.w500,
// //         ),
// //       ),
// //     ],
// //   );
// // }
// //
// // // Draws the solid grey corners
// // class CornerBracket extends StatelessWidget {
// //   final bool isTop;
// //   final bool isLeft;
// //
// //   const CornerBracket({super.key, required this.isTop, required this.isLeft});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     const double size = 40;
// //     const double thickness = 4;
// //     const double radius = 25;
// //
// //     return Container(
// //       width: size,
// //       height: size,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.only(
// //           topLeft: Radius.circular(isTop && isLeft ? radius : 0),
// //           topRight: Radius.circular(isTop && !isLeft ? radius : 0),
// //           bottomLeft: Radius.circular(!isTop && isLeft ? radius : 0),
// //           bottomRight: Radius.circular(!isTop && !isLeft ? radius : 0),
// //         ),
// //         border: Border(
// //           top: isTop
// //               ? BorderSide(color: Colors.grey.shade600, width: thickness)
// //               : BorderSide.none,
// //           bottom: !isTop
// //               ? BorderSide(color: Colors.grey.shade600, width: thickness)
// //               : BorderSide.none,
// //           left: isLeft
// //               ? BorderSide(color: Colors.grey.shade600, width: thickness)
// //               : BorderSide.none,
// //           right: !isLeft
// //               ? BorderSide(color: Colors.grey.shade600, width: thickness)
// //               : BorderSide.none,
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // Custom Painter to draw a rounded rectangle with dashed lines
// // class DashedRectPainter extends CustomPainter {
// //   final Color color;
// //   final double strokeWidth;
// //   final double gap;
// //   final double dash;
// //   final double radius;
// //
// //   DashedRectPainter({
// //     this.color = Colors.grey,
// //     this.strokeWidth = 2.0,
// //     this.gap = 5.0,
// //     this.dash = 5.0,
// //     this.radius = 0.0,
// //   });
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     Paint paint = Paint()
// //       ..color = color
// //       ..strokeWidth = strokeWidth
// //       ..style = PaintingStyle.stroke;
// //
// //     // Create a rounded rectangle path
// //     RRect rRect = RRect.fromRectAndRadius(
// //       Rect.fromLTWH(0, 0, size.width, size.height),
// //       Radius.circular(radius),
// //     );
// //
// //     Path path = Path()..addRRect(rRect);
// //
// //     // Convert the path to a dashed path
// //     Path dashedPath = Path();
// //     double distance = 0.0;
// //
// //     for (PathMetric pathMetric in path.computeMetrics()) {
// //       while (distance < pathMetric.length) {
// //         dashedPath.addPath(
// //           pathMetric.extractPath(distance, distance + dash),
// //           Offset.zero,
// //         );
// //         distance += dash + gap;
// //       }
// //     }
// //
// //     canvas.drawPath(dashedPath, paint);
// //   }
// //
// //   @override
// //   bool shouldRepaint(CustomPainter oldDelegate) => false;
// // }
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'package:internsharks/const_file/app_colors.dart';
// import 'package:internsharks/const_file/app_text_style.dart';
// import 'review_upload_selfie.dart';
//
// class UploadSelfiePage extends StatefulWidget {
//   const UploadSelfiePage({super.key});
//
//   @override
//   State<UploadSelfiePage> createState() => _UploadSelfiePageState();
// }
//
// class _UploadSelfiePageState extends State<UploadSelfiePage> {
//   CameraController? controller;
//   List<CameraDescription>? cameras;
//   int cameraIndex = 1;
//
//   @override
//   void initState() {
//     super.initState();
//     initCamera();
//   }
//
//   initCamera() async {
//     cameras = await availableCameras();
//     controller = CameraController(
//       cameras![cameraIndex],
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//     await controller!.initialize();
//     if (mounted) setState(() {});
//   }
//
//   switchCamera() async {
//     cameraIndex = cameraIndex == 0 ? 1 : 0;
//     initCamera();
//   }
//
//   takePhoto() async {
//     final image = await controller!.takePicture();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ReviewUploadSelfie(imagePath: image.path),
//       ),
//     );
//   }
//
//   pickGallery() async {
//     final picker = ImagePicker();
//     final file = await picker.pickImage(source: ImageSource.gallery);
//     if (file == null) return;
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ReviewUploadSelfie(imagePath: file.path),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.appColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, size: 25, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text('Upload Selfie', style: AppTextStyles.white24Bold),
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
//         width: double.infinity,
//         height: double.infinity,
//         color: AppColors.appColor,
//         child: Column(
//           children: [
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.0),
//               child: Text(
//                 "Ready for your close-up? A great photo helps you stand out.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 18,
//                   height: 1.4,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 40),
//
//             Expanded(
//               child: Center(
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.80,
//                   height: MediaQuery.of(context).size.height * 0.50,
//                   child: Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(30),
//                         child: controller == null || !controller!.value.isInitialized
//                             ? const Center(
//                           child: CircularProgressIndicator(color: Colors.white),
//                         )
//                             : FittedBox(
//                           fit: BoxFit.cover,
//                           child: SizedBox(
//                             width: controller!.value.previewSize!.height,
//                             height: controller!.value.previewSize!.width,
//                             child: CameraPreview(controller!),
//                           ),
//                         ),
//                       ),
//
//                       // Dotted Rectangle Frame
//                       Positioned.fill(
//                         child: CustomPaint(
//                           painter: DashedRectPainter(
//                             color: Colors.grey.withOpacity(0.5),
//                             strokeWidth: 2.0,
//                             gap: 10.0,
//                             dash: 8.0,
//                             radius: 30.0,
//                           ),
//                         ),
//                       ),
//
//                       // 4 Corner brackets
//                       const Positioned(top: 0, left: 0, child: CornerBracket(isTop: true, isLeft: true)),
//                       const Positioned(top: 0, right: 0, child: CornerBracket(isTop: true, isLeft: false)),
//                       const Positioned(bottom: 0, left: 0, child: CornerBracket(isTop: false, isLeft: true)),
//                       const Positioned(bottom: 0, right: 0, child: CornerBracket(isTop: false, isLeft: false)),
//
//                       // Face Align Text
//                       Center(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.face, size: 60, color: Colors.white.withOpacity(0.3)),
//                             const SizedBox(height: 16),
//                             const Text(
//                               "Align your face here",
//                               style: TextStyle(color: Colors.white70, fontSize: 16),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             Padding(
//               padding: const EdgeInsets.only(bottom: 40.0, left: 20, right: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   InkWell(
//                     onTap: pickGallery,
//                     child: _buildActionButton(
//                       icon: Icons.image_outlined,
//                       label: "Upload Selfie",
//                       color: const Color(0xFF1F232F),
//                       iconColor: Colors.white60,
//                     ),
//                   ),
//
//                   InkWell(
//                     onTap: takePhoto,
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: const BoxDecoration(
//                             color: Color(0xFF00BCD4),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.camera_alt_outlined,
//                             color: Colors.white70,
//                             size: 36,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         const Text(
//                           "Take Selfie",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   InkWell(
//                     onTap: switchCamera,
//                     child: _buildActionButton(
//                       icon: Icons.cameraswitch,
//                       label: "Switch",
//                       color: const Color(0xFF1F232F),
//                       iconColor: Colors.white60,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Widget _buildActionButton({
//   required IconData icon,
//   required String label,
//   required Color color,
//   required Color iconColor,
// }) {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Container(
//         width: 70,
//         height: 70,
//         decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         child: Icon(icon, color: iconColor, size: 28),
//       ),
//       const SizedBox(height: 12),
//       Text(
//         label,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     ],
//   );
// }
//
// class CornerBracket extends StatelessWidget {
//   final bool isTop;
//   final bool isLeft;
//
//   const CornerBracket({super.key, required this.isTop, required this.isLeft});
//
//   @override
//   Widget build(BuildContext context) {
//     const double size = 40;
//     const double thickness = 4;
//     const double radius = 25;
//
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(isTop && isLeft ? radius : 0),
//           topRight: Radius.circular(isTop && !isLeft ? radius : 0),
//           bottomLeft: Radius.circular(!isTop && isLeft ? radius : 0),
//           bottomRight: Radius.circular(!isTop && !isLeft ? radius : 0),
//         ),
//         border: Border(
//           top: isTop
//               ? BorderSide(color: Colors.grey.shade600, width: thickness)
//               : BorderSide.none,
//           bottom: !isTop
//               ? BorderSide(color: Colors.grey.shade600, width: thickness)
//               : BorderSide.none,
//           left: isLeft
//               ? BorderSide(color: Colors.grey.shade600, width: thickness)
//               : BorderSide.none,
//           right: !isLeft
//               ? BorderSide(color: Colors.grey.shade600, width: thickness)
//               : BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
//
// class DashedRectPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final double gap;
//   final double dash;
//   final double radius;
//
//   DashedRectPainter({
//     this.color = Colors.grey,
//     this.strokeWidth = 2.0,
//     this.gap = 5.0,
//     this.dash = 5.0,
//     this.radius = 0.0,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;
//
//     RRect rRect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       Radius.circular(radius),
//     );
//
//     Path path = Path()..addRRect(rRect);
//
//     Path dashedPath = Path();
//     double distance = 0.0;
//
//     for (PathMetric pathMetric in path.computeMetrics()) {
//       while (distance < pathMetric.length) {
//         dashedPath.addPath(
//           pathMetric.extractPath(distance, distance + dash),
//           Offset.zero,
//         );
//         distance += dash + gap;
//       }
//     }
//
//     canvas.drawPath(dashedPath, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';
import 'review_upload_selfie.dart';

class UploadSelfiePage extends StatefulWidget {
  const UploadSelfiePage({super.key});

  @override
  State<UploadSelfiePage> createState() => _UploadSelfiePageState();
}

class _UploadSelfiePageState extends State<UploadSelfiePage> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  int cameraIndex = 1;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isEmpty) return;

      controller = CameraController(
        cameras![cameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      print('Camera init error: $e');
    }
  }

  switchCamera() async {
    if (cameras == null || cameras!.length < 2) return;
    cameraIndex = cameraIndex == 0 ? 1 : 0;
    await controller?.dispose();
    initCamera();
  }

  toggleFlash() async {
    if (controller == null || !controller!.value.isInitialized) return;
    try {
      isFlashOn = !isFlashOn;
      await controller!.setFlashMode(
        isFlashOn ? FlashMode.torch : FlashMode.off,
      );
      if (mounted) setState(() {});
    } catch (e) {
      print('Flash toggle error: $e');
    }
  }

  takePhoto() async {
    if (controller == null || !controller!.value.isInitialized) return;

    try {
      final image = await controller!.takePicture();
      if (mounted) {
        Get.toNamed(
          Routes.reviewUploadSelfie,
          arguments: image.path,
        );

      }
    } catch (e) {
      print('Take photo error: $e');
    }
  }

  pickGallery() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (file != null && mounted) {
        Get.toNamed(
          Routes.reviewUploadSelfie,
          arguments: file.path,
        );
      }

    } catch (e) {
      print('Pick gallery error: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Upload Selfie', style: AppTextStyles.white24Bold),
        centerTitle: true,
        actions: [
          if (controller != null && controller!.value.isInitialized)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: toggleFlash,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white70, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Position your face in the frame for best results",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Camera Preview with Enhanced Frame
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.appBlue.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(
                          children: [
                            // Camera Preview
                            if (controller == null ||
                                !controller!.value.isInitialized)
                              Container(
                                color: Colors.black26,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.appBlue,
                                  ),
                                ),
                              )
                            else
                              SizedBox.expand(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width:
                                        controller!.value.previewSize!.height,
                                    height:
                                        controller!.value.previewSize!.width,
                                    child: CameraPreview(controller!),
                                  ),
                                ),
                              ),

                            // Overlay with Face Guide
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.3),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Face Oval Guide
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.width * 0.75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.appBlue.withOpacity(0.8),
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),

                            // Corner Brackets (Enhanced)
                            Positioned(
                              top: 20,
                              left: 20,
                              child: _buildCornerBracket(true, true),
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: _buildCornerBracket(true, false),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: _buildCornerBracket(false, true),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: _buildCornerBracket(false, false),
                            ),

                            // Center Guide Icon
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.face_retouching_natural,
                                      size: 50,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Align Face",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      onTap: pickGallery,
                      icon: Icons.photo_library_outlined,
                      label: "Gallery",
                    ),
                    _buildCaptureButton(onTap: takePhoto),
                    _buildActionButton(
                      onTap: switchCamera,
                      icon: Icons.flip_camera_ios_outlined,
                      label: "Flip",
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

  Widget _buildCornerBracket(bool isTop, bool isLeft) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? BorderSide(color: AppColors.appBlue, width: 4)
              : BorderSide.none,
          bottom: !isTop
              ? BorderSide(color: AppColors.appBlue, width: 4)
              : BorderSide.none,
          left: isLeft
              ? BorderSide(color: AppColors.appBlue, width: 4)
              : BorderSide.none,
          right: !isLeft
              ? BorderSide(color: AppColors.appBlue, width: 4)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTop && isLeft ? 12 : 0),
          topRight: Radius.circular(isTop && !isLeft ? 12 : 0),
          bottomLeft: Radius.circular(!isTop && isLeft ? 12 : 0),
          bottomRight: Radius.circular(!isTop && !isLeft ? 12 : 0),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.appBlue.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Capture",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
