import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class FilterChipWidget extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;
  final String label;

  const FilterChipWidget({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected == option;
            return GestureDetector(
              onTap: () {
                // Toggle: tap same chip to deselect
                onSelected(isSelected ? null : option);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.fieldBgColor
                      : AppColors.fieldBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.contBorderColor,
                    width: 1.5,
                  ),
                ),
                //alignment: Alignment.center,
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: isSelected
                  ?  AppStyles.customTextStyle(
                    fontFamily: "Roboto",
                    color: AppColors.whiteColor,
                    size: 14,
                    weight: FontWeight.w500,
                  )
                      : AppStyles.customTextStyle(
                    fontFamily: "Roboto",
                    color: AppColors.greyColor,
                    size: 14,
                    weight: FontWeight.w200,
                  )
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}