import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

class EducationCard extends StatelessWidget {
  final String level, title, subtitle, meta, extra;
  final VoidCallback onEdit;

  const EducationCard({super.key,
    required this.level,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.extra,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                level,
                style: AppStyles.customTextStyle(
                  fontFamily: 'Roboto',
                  color: AppColors.whiteColor,
                  size: 16,
                  weight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: Image.asset(
                  AssetImages.editIconImg,
                  height: 18,
                  width: 18,
                  color: AppColors.secondaryColor,
                ),
                onPressed: onEdit,
              ),
            ],
          ),
          if (title.isNotEmpty)
            Text(
              title,
              style: AppStyles.customTextStyle(
                color: AppColors.whiteColor,
                size: 12,
                weight: FontWeight.w500,
              ),
            ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: AppStyles.customTextStyle(
                color: AppColors.lightText,
                size: 12,
                weight: FontWeight.w400,
              ),
            ),
          Text(
            '$meta | $extra',
            style: AppStyles.customTextStyle(
              color: AppColors.lightText,
              size: 10,
              weight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}