import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String? prefixText;
  final int maxLength;
  final int maxLines;
  final double? width;
  final bool isEnabled;
  final bool isProfileFlow;
  final bool isNumberKeyboard;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    this.isEnabled = true,
    this.isNumberKeyboard = true,
    this.hintText = "",
    this.onChanged,
    this.maxLines= 1,
    this.width,
    this.prefixText,
    this.maxLength = 3000,
    this.labelText = "",
    this.suffixWidget,
    this.prefixWidget,
    this.isProfileFlow = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          labelText,
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 15,
            weight: FontWeight.w700,
          ),
        ),
        Container(
          constraints: BoxConstraints(minHeight: 55),
          width: width != null ? width! : double.maxFinite,
          child: TextFormField(
            validator: validator,
            maxLines: maxLines,
            controller: controller,
            onChanged: onChanged,
            maxLength: isNumberKeyboard ? 10 :maxLength,
            keyboardType: isNumberKeyboard
                ? TextInputType.number
                : TextInputType.visiblePassword,
            style: AppStyles.customTextStyle(
              fontFamily: "Roboto",
              color: AppColors.whiteColor,
              size: 15,
              weight: FontWeight.w500,
            ),
            inputFormatters: [
              isNumberKeyboard
                  ? FilteringTextInputFormatter.digitsOnly
                  : FilteringTextInputFormatter.allow(
                      RegExp(r'^[\u0020-\u007E]+$'),
                    ),
            ],
            cursorColor:
            AppColors.primaryColor,
            cursorErrorColor: AppColors.primaryColor,
            autofocus: false,
            decoration: InputDecoration(
              focusColor: AppColors.primaryColor,

              suffixIcon: suffixWidget,

              enabled: isEnabled,
              counterText: "",
              hintText: hintText,

              hintStyle: AppStyles.customTextStyle(
                fontFamily: "Roboto",
                color: AppColors.greyColor,
                size: 15,
                weight: FontWeight.w500,
              ),

              filled: true,
              isDense: true,

              fillColor: isEnabled
                  ? AppColors.fieldBgColor
                  : isProfileFlow
                  ? AppColors.fieldBgColor
                  : AppColors.disableFieldColor,

              /// FIXED PREFIX
              prefixIcon: prefixWidget ?? ((prefixText != null && prefixText!.isNotEmpty)
                  ? Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  prefixText!,
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    fontFamily: "Roboto",
                    color: AppColors.whiteColor,
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
              )
                  : null),

              /// IMPORTANT
              prefixIconConstraints:
              prefixWidget != null ||
                  (prefixText != null && prefixText!.isNotEmpty)
                  ? const BoxConstraints(
                minWidth: 45,
                minHeight: 45,
              )
                  : const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),

              prefixStyle: AppStyles.customTextStyle(
                fontFamily: "Roboto",
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),

              /// DYNAMIC PADDING
              contentPadding: EdgeInsets.symmetric(
                vertical: 22,
                horizontal:
                prefixWidget != null ||
                    (prefixText != null && prefixText!.isNotEmpty)
                    ? 10
                    : 18,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: AppColors.fieldBorderColor,
                ),
              ),

              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: isProfileFlow
                      ? AppColors.fieldBorderColor
                      : AppColors.disableBorderColor,
                ),
              ),

              border: OutlineInputBorder(
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
            ),
          ),
        ),
      ],
    );
  }
}
