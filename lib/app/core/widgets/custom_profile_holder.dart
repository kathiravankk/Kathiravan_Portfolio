import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

typedef FileCallBack = Function(File file);

class CustomProfileHolder extends StatefulWidget {
  final bool? isEditable;
  final String imageUrl;
  final FileCallBack? fileCallBack;
  final VoidCallback? onTap;

  const CustomProfileHolder({
    super.key,
    this.isEditable = false,
    required this.imageUrl,
    this.fileCallBack,
    this.onTap,
  });

  @override
  State<CustomProfileHolder> createState() => _CustomProfileHolderState();
}

class _CustomProfileHolderState extends State<CustomProfileHolder> {
  final picker = ImagePicker();

  ValueNotifier<File?> selectedFile = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.isEditable! ? showUploadOption() : widget.onTap!(),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: widget.isEditable! ? 100 : 86,
            width: widget.isEditable! ? 100 : 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00D9F5),
                  Color(0xFF00F5A0),
                  Color(0xFF0093B4),
                  Color(0xFF00F5A0),
                  Color(0xFF00D9F5),
                  Color(0xFF00F5A0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0), // border thickness
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white, // inner background
                  shape: BoxShape.circle,
                ),
                child: ValueListenableBuilder(
                  valueListenable: selectedFile,
                  builder: (context, values, _) {
                    return CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: selectedFile.value != null
                          ? FileImage(selectedFile.value!)
                          : (widget.imageUrl.isNotEmpty
                                    ? NetworkImage(widget.imageUrl)
                                    : AssetImage(AssetImages.emptyImage,))
                                as ImageProvider,
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
            ),
            child: widget.isEditable!
                ? Icon(
                    CupertinoIcons.camera,
                    color: AppColors.primaryColor,
                    size: 20,
                  )
                : Icon(
                    Icons.edit_outlined,
                    color: AppColors.greyIcon,
                    size: 20,
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> showUploadOption() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: AppColors.greyIcon,
                    size: 20,
                  ),
                  title: Text(
                    "Choose from Gallery",
                    style: AppStyles.customTextStyle(
                      fontFamily: "Roboto",
                      color: AppColors.blackColor,
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    chooseImage(ImageSource.gallery);
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera,
                    color: AppColors.greyIcon,
                    size: 20,
                  ),
                  title: Text(
                    "Take a Photo",
                    style: AppStyles.customTextStyle(
                      fontFamily: "Roboto",
                      color: AppColors.blackColor,
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    chooseImage(ImageSource.camera);
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  chooseImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (await pickedFile.length() > 1000000) {
        AppAlertUtils.showToast(message: "File size exists..!");
      } else {
        selectedFile.value = File(pickedFile.path);
        if (widget.fileCallBack != null) {
          widget.fileCallBack!(selectedFile.value!);
        }
      }
    }
  }

  @override
  void dispose() {
    selectedFile.value = null;
    super.dispose();
  }
}
