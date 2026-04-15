import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class RegisterProfileUploadScreen extends StatefulWidget {
  const RegisterProfileUploadScreen({super.key});

  @override
  State<RegisterProfileUploadScreen> createState() =>
      _RegisterProfileUploadScreenState();
}

class _RegisterProfileUploadScreenState
    extends State<RegisterProfileUploadScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  int cameraIndex = 1;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
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

  Future<void> switchCamera() async {
    if (cameras == null || cameras!.length < 2) return;
    cameraIndex = cameraIndex == 0 ? 1 : 0;
    await controller?.dispose();
    initCamera();
  }

  Future<void> toggleFlash() async {
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

  Future<void> takePhoto() async {
    if (controller == null || !controller!.value.isInitialized) return;

    try {
      final image = await controller!.takePicture();
      if (mounted) {
        Get.toNamed(
          AppRoutes.registerSelfiePreviewScreen,
          arguments: {"uploadedImage": image.path},
        );
      }
    } catch (e) {
      print('Take photo error: $e');
    }
  }

  Future<void> pickGallery() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (file != null && mounted) {
        Get.toNamed(AppRoutes.reviewUploadSelfie, arguments: file.path);
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
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: AppColors.whiteColor,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Upload Selfie",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (controller != null && controller!.value.isInitialized)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  size: 25,
                  color: AppColors.whiteColor,
                ),
              ),
              onPressed: toggleFlash,
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            spacing: 15,
            children: [
              Text(
                "Ready for your close-up? A great photo \n helps you stand out!",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  color: AppColors.whiteColor,
                  size: 16,
                  lineSpace: 1.4,
                  weight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 10),
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
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.3,
                            ),
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
                                color: AppColors.blackGradient1,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
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
                                      AppColors.blackColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      AppColors.transparentColor,
                                      AppColors.transparentColor,
                                      AppColors.blackColor.withValues(
                                        alpha: 0.3,
                                      ),
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
                                    color: AppColors.primaryColor.withValues(
                                      alpha: 0.8,
                                    ),
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
                                  color: AppColors.blackColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.face_retouching_natural,
                                      size: 50,
                                      color: AppColors.whiteColor.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Align your face here",
                                      style: AppStyles.customTextStyle(
                                        color: AppColors.whiteColor.withValues(
                                          alpha: 0.7,
                                        ),
                                        size: 14,
                                        weight: FontWeight.w500,
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
