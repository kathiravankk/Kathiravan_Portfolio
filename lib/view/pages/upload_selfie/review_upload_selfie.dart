import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';

import '../../screens/home_Screen.dart';
class ReviewUploadSelfie extends StatefulWidget {
  String imagePath;   // <- make editable (IMPORTANT)

  ReviewUploadSelfie({super.key, required this.imagePath});

  @override
  State<ReviewUploadSelfie> createState() => _ReviewUploadSelfieState();
}

class _ReviewUploadSelfieState extends State<ReviewUploadSelfie> {

  // ---------- CROP FUNCTION ----------
  Future<String?> cropImage(String path) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: false,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    return cropped?.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        width: double.infinity,
        height: double.infinity,
        color: AppColors.appColor,

        child: Column(
          children: [
            // ---------------- TOP BAR ----------------
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
                  onPressed: () => Navigator.pop(context),
                ),

                SizedBox(width: 10),

                Text(
                  "Review your upload",
                  style: AppTextStyles.white24Bold,
                ),

                Spacer(),

                // ---------- CROP BUTTON ----------
                IconButton(
                  icon: Icon(Icons.crop, color: Colors.white, size: 25),
                  onPressed: () async {
                    final newPath = await cropImage(widget.imagePath);
                    if (newPath != null) {
                      setState(() {
                        widget.imagePath = newPath;
                      });
                    }
                  },
                ),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    Text(
                      "It's a cool look! Let's add final touches.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 30),

                    // ---------- PHOTO PREVIEW ----------
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(widget.imagePath)),
                        ),
                      ),
                    ),

                    SizedBox(height:250),

                    // ---------- UPLOAD BUTTON ----------
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(activeStep: 3),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.appBlue,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            'Upload',
                            style: AppTextStyles.white24Bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
