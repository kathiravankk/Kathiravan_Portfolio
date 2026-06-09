import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CustomDatePickerField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  const CustomDatePickerField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.onTap,
    this.hintText = "Select Date",
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 10),

        TextFormField(
          controller: controller,
          validator: validator,
          readOnly: true,
          onTap: onTap,
          style: AppStyles.customTextStyle(
            fontFamily: "Roboto",
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,

            hintStyle: AppStyles.customTextStyle(
              fontFamily: "Roboto",
              color: AppColors.greyColor,
              size: 12,
              weight: FontWeight.w200,
            ),

            suffixIcon: const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.primaryColor,
            ),

            filled: true,
            fillColor: AppColors.fieldBgColor,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 22,
              horizontal: 18,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppColors.fieldBorderColor,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
              ),
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}