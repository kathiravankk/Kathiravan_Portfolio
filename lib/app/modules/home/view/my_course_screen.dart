import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class MyCourseScreen extends StatefulWidget {
  const MyCourseScreen({super.key});

  @override
  State<MyCourseScreen> createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        automaticallyImplyActions: false,
        centerTitle: true,
        title: Text(
          "My Courses",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Icon(
              CupertinoIcons.doc_text_search,
              color: AppColors.primaryColor,
              size: 50,
            ),
            Text(
              "Coming Soon..!",
              style: AppStyles.customTextStyle(
                size: 14,
                weight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
