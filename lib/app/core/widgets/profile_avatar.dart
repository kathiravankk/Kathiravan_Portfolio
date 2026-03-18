

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

import '../utils/app_colors.dart' show AppColors;

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final File? pickedFile;
  final String name;
  final String collegeName;
  final VoidCallback onTap;

  const ProfileAvatar({super.key,
    required this.imageUrl,
    required this.pickedFile,
    required this.name,
    required this.collegeName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider img;
    if (pickedFile != null) {
      img = FileImage(pickedFile!);
    } else if (imageUrl.isNotEmpty) {
      img = NetworkImage(imageUrl);
    } else {
      img = AssetImage(AssetImages.emptyImage) as ImageProvider;
    }

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF00D9F5),
                        Color(0xFF00F5A0),
                        Color(0xFF0093B4),
                        Color(0xFF00F5A0),
                        Color(0xFF00D9F5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(backgroundImage: img),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.camera,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
          Text(
            collegeName.isEmpty ? 'NA' : collegeName,
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.primaryColor,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}