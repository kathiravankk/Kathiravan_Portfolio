import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final VoidCallback buttonFunction;
  final Widget? buttonIcon;
  final String buttonText;
  final double width;
  final double height;
  final bool disable;
  final bool isLoading;
  final Color? bgColor;
  final TextStyle? buttonTextStyle;
  final Widget? buttonWidget;

  const CustomButtonWidget({
    super.key,
    required this.buttonFunction,
    this.buttonIcon,
    required this.buttonText,
    this.width = double.infinity,
    this.height = 50,
    this.disable = false,
    this.isLoading = false,
    this.bgColor,
    this.buttonTextStyle,
    this.buttonWidget,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Determine the background color or gradient based on priority
    final bool hasCustomBgColor = bgColor != null;

    final BoxDecoration containerDecoration = hasCustomBgColor
        ? BoxDecoration(
      color: bgColor,
      borderRadius: const BorderRadius.all(Radius.circular(25)),
    )
        : BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      gradient: disable
          ? null
          : const LinearGradient(
        colors: [AppColors.buttonGrad1, AppColors.buttonGrad2],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      color: disable ? AppColors.disableButColor : null,
    );

    return SizedBox(
      width: width,
      height: height,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: containerDecoration,
        child: ElevatedButton(
          onPressed: disable ? null : buttonFunction,
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10),
            ),
            maximumSize: const WidgetStatePropertyAll(
              Size(double.infinity, 40),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: disable
                      ? AppColors.transparentColor
                      : Colors.transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(25)),
              ),
            ),
          ),
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CupertinoActivityIndicator(
              color: AppColors.whiteColor,
            ),
          )
              : buttonWidget ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonIcon ?? const SizedBox.shrink(),
                  if (buttonIcon != null) const SizedBox(width: 5),
                  Text(
                    buttonText,
                    style: buttonTextStyle ??
                        AppStyles.customTextStyle(
                          size: 16,
                          color: disable || hasCustomBgColor
                              ? AppColors.contLightText2
                              : AppColors.blackColor,
                          weight: FontWeight.w700,
                          fontFamily: "Roboto",
                        ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
