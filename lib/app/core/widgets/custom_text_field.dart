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
  final double? width;
  final bool isEnabled;
  final bool isProfileFlow;
  final bool isNumberKeyboard;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    this.isEnabled = true,
    this.isNumberKeyboard = true,
    this.hintText = "",
    this.onChanged,
    this.width,
    this.prefixText,
    this.maxLength = 300,
    this.labelText = "",
    this.suffixWidget,
    this.prefixWidget,
    this.isProfileFlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          labelText,
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        Container(
          constraints: BoxConstraints(minHeight: 40),
          width: width != null ? width! : double.maxFinite,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLength: isNumberKeyboard ? 10 :maxLength,
            keyboardType: isNumberKeyboard
                ? TextInputType.number
                : TextInputType.visiblePassword,
            style: AppStyles.customTextStyle(
              fontFamily: "Roboto",
              color: AppColors.whiteColor,
              size: 14,
              weight: FontWeight.w500,
            ),
            inputFormatters: [
              isNumberKeyboard
                  ? FilteringTextInputFormatter.digitsOnly
                  : FilteringTextInputFormatter.allow(
                      RegExp(r'^[\u0020-\u007E]+$'),
                    ),
            ],
            autofocus: false,
            decoration: InputDecoration(
              //suffix: suffixWidget ?? Text(""),
              //prefix: prefixWidget ?? Text(""),
              suffixIcon: suffixWidget ?? Text(""),
              enabled: isEnabled,
              counterText: "",
              hintText: hintText,
              hintStyle: AppStyles.customTextStyle(
                fontFamily: "Roboto",
                color: AppColors.greyColor,
                size: 12,
                weight: FontWeight.w200,
              ),
              filled: true,
              isDense: true,
              fillColor: isEnabled
                  ? AppColors.fieldBgColor
                  : isProfileFlow
                  ? AppColors.fieldBgColor
                  : AppColors.disableFieldColor,
              //prefixText: "$prefixText  ",
              prefixIcon:
                  prefixWidget ??
                  Padding(
                    padding: EdgeInsetsGeometry.only(top: 15),
                    child: Text(
                      prefixText ?? "",
                      textAlign: TextAlign.center,
                      style: AppStyles.customTextStyle(
                        fontFamily: "Roboto",
                        color: AppColors.whiteColor,
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
              prefixStyle: AppStyles.customTextStyle(
                fontFamily: "Roboto",
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
              // constraints: BoxConstraints(
              //   maxHeight: 50
              // ),
              contentPadding: EdgeInsetsGeometry.symmetric(
                vertical: 18,
                horizontal: 30,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: AppColors.fieldBorderColor),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: isProfileFlow
                      ? AppColors.fieldBorderColor
                      : AppColors.sucTextColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: AppColors.fieldBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
