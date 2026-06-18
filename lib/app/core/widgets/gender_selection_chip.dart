import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import '../utils/app_colors.dart';

class GenderSelectionChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderSelectionChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.disableFieldColor
              : AppColors.fieldBgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.fieldBorderColor,
            width: 1.2,
          ),
        ),
        child: Text(
          title,
          style: AppStyles.customTextStyle(
            size: 13,
            color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
            weight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
