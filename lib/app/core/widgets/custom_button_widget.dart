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
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: disable ? null : buttonFunction,
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(
            disable ? AppColors.disableButtonColor2 : bgColor,
          ),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10)),
          maximumSize: WidgetStatePropertyAll(Size(double.infinity, 40)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide(width: 1, color: disable ? AppColors.transparentColor :AppColors.primaryColor),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CupertinoActivityIndicator(color: AppColors.whiteColor),
              )
            : Row(
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
                          color: AppColors.whiteColor,
                          weight: FontWeight.w500,
                          fontFamily: "Roboto",
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
