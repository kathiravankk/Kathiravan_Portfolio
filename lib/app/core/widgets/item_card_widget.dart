import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onEdit;

  const ItemCard({super.key,
    required this.title,
    required this.subtitle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        border: Border.all(color: AppColors.fieldBorderColor),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 4, 4, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.customTextStyle(
                    fontFamily: 'Roboto',
                    color: AppColors.whiteColor,
                    size: 14,
                    weight: FontWeight.w600,
                  ),
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
              const SizedBox(width: 8),
            ],
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: AppStyles.customTextStyle(
                fontFamily: 'Roboto',
                color: AppColors.lightText,
                size: 12,
                lineSpace: 1.3,
                weight: FontWeight.w300,
              ),
            ),
        ],
      ),
    );
  }
}