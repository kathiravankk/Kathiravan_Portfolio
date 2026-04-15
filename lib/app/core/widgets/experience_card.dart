import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

class ExperienceCard extends StatelessWidget {
  final String role, company, meta;
  final VoidCallback onEdit, onDelete;

  const ExperienceCard({
    required this.role,
    required this.company,
    required this.meta,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  role,
                  style: AppStyles.customTextStyle(
                    fontFamily: 'Roboto',
                    color: AppColors.whiteColor,
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                ),
                if (company.isNotEmpty)
                  Text(
                    company,
                    style: AppStyles.customTextStyle(
                      color: AppColors.lightText,
                      size: 12,
                      weight: FontWeight.w400,
                    ),
                  ),
                if (meta.isNotEmpty)
                  Text(
                    meta,
                    style: AppStyles.customTextStyle(
                      color: AppColors.lightText,
                      size: 10,
                      weight: FontWeight.w300,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onEdit,
            icon: Image.asset(
              AssetImages.editIconImg,
              height: 18,
              width: 18,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.failTextColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}