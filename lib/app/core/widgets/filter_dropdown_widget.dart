import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class FilterDropdownWidget extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onChanged;
  final String label;
  final String hint;

  const FilterDropdownWidget({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.label,
    this.hint = 'Select...',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.fieldBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected != null
                  ? AppColors.primaryColor
                  : AppColors.fieldBorderColor,
              width: 1.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(

              value: selected,
              hint: Text(
                hint,
                style: AppStyles.customTextStyle(
                  fontFamily: "Roboto",
                  color: AppColors.greyColor,
                  size: 13,
                  weight: FontWeight.w400,
                ),
              ),
              isExpanded: true,
              dropdownColor: AppColors.fieldBgColor,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primaryColor,
                size: 25,
              ),
              style: AppStyles.customTextStyle(
                fontFamily: "Roboto",
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
              items: [
                // Allow clearing by selecting null
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    'Select any',
                    style: AppStyles.customTextStyle(
                      fontFamily: "Roboto",
                      color: AppColors.greyColor,
                      size: 13,
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
                ...options.map(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: AppStyles.customTextStyle(
                        fontFamily: "Roboto",
                        color: AppColors.whiteColor,
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
