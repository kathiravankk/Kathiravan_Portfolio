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
  final Color bgColor;
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
    this.bgColor = AppColors.primaryColor,
    this.buttonTextStyle,
    this.buttonWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child:
      Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          gradient: disable
              ? null
              : const LinearGradient(
                  colors: [AppColors.buttonGrad1, AppColors.buttonGrad2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: disable ? AppColors.disableButColor : null,
        ),
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
                      : Colors
                            .transparent,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(25)),
              ),
            ),
          ),
          child: isLoading
              ? SizedBox(
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
                        buttonIcon ?? Container(),
                        SizedBox(width: buttonIcon != null ? 5 : 0),
                        Text(
                          buttonText,
                          style:
                              buttonTextStyle ??
                              AppStyles.customTextStyle(
                                size: 16,
                                color: disable ? AppColors.whiteColor : AppColors.blackColor,
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
