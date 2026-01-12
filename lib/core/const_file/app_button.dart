// import 'package:flutter/material.dart';
//
// class AppButton {
//   static MaterialButton AppMaterialButton({
//     required Function()? onPressed,
//     required String text,
//     required TextStyle? style,
//     required Color? color,
//     double? height,
//     double? elevation,
//     double paddingVertical = 0.0,
//     double paddingHorizontal = 0.0,
//   }) {
//     return MaterialButton(
//       padding: EdgeInsets.symmetric(
//         vertical: paddingVertical,
//         horizontal: paddingHorizontal,
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//       elevation: elevation,
//       onPressed: onPressed,
//       color: color,
//       child: Text(text, style: style),
//     );
//   }
//
//   static MaterialButton AppSubmitButton({
//     required Function()? onPressed,
//     required String text,
//     // required TextStyle? style,
//     required Color? color,
//     // double? height,n b  b b b
//     double? elevation,
//     double paddingVertical = 0.0,
//     double paddingHorizontal = 0.0,
//   }) {
//     return MaterialButton(
//       padding: EdgeInsets.symmetric(
//         vertical: paddingVertical,
//         horizontal: paddingHorizontal,
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//       elevation: elevation,
//       onPressed: onPressed,
//       color: color,
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   /// AppCustomButtonAppButton.AppCustomButton(
//
//   static Widget AppCustomButton({
//     required Function()? onTap,
//     required String text,
//     required TextStyle? style,
//     required Color? color,
//     double? width,
//     double? height,
//     double paddingVertical = 0.0,
//     double paddingHorizontal = 0.0,
//   }) {
//     return InkWell(
//       overlayColor: WidgetStatePropertyAll<Color>(Colors.transparent),
//       onTap: onTap,
//       child: Container(
//         alignment: Alignment.center,
//         width: width,
//         height: height,
//         padding: EdgeInsets.symmetric(
//           vertical: paddingVertical,
//           horizontal: paddingHorizontal,
//         ),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.all(Radius.circular(30)),
//         ),
//         child: Text(text, style: style),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AppButton {
  static Widget AppContainerButton({
    required VoidCallback? onTap,
    required String text,
    Color bgColor = Colors.transparent,
    double Width=double.infinity,
    Color textColor = Colors.white,
    double borderRadius = 45,
    double verticalPadding = 15,
    double horizontalPadding = 0,
    Color borderColor = Colors.transparent,
    double borderWidth = 0,
    TextStyle? textStyle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: Width,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Center(
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  static Future<File?> pickFromCameraGallery(BuildContext context) async {
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Select Option", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text("Camera", style: TextStyle(color: Colors.white)),
                onTap: () async {
                  final picked =
                  await ImagePicker().pickImage(source: ImageSource.camera);
                  Navigator.pop(context, picked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text("Gallery", style: TextStyle(color: Colors.white)),
                onTap: () async {
                  final picked =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, picked);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile == null) return null;

    /// CROPPING
    final cropped = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (cropped == null) return null;

    return File(cropped.path);
  }

}