import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

import '../utils/asset_images.dart';

class AppScaffoldWidget extends StatelessWidget {
  final Widget bodyWidget;
  final AppBar appBarWidget;
  const AppScaffoldWidget({super.key, required this.bodyWidget, required this.appBarWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.contain,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWidget,
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: bodyWidget,
            )
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.transparentColor,
      elevation: 0,
      automaticallyImplyLeading: false,
        title: Text(
          "Posted Internship",
          style: AppStyles.customTextStyle(
            size: 20,
            color: AppColors.secondaryColor,
            weight: FontWeight.w700,
          ),
        )
    );
  }
}

