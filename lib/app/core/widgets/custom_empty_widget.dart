import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          Icon(
            Icons.file_copy_outlined,
            size: 35,
            color: AppColors.secondaryColor,
          ),
          Text(
            "No Data Found..!",
            style: AppStyles.customTextStyle(
              size: 14,
              weight: FontWeight.w700,
              color: AppColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
