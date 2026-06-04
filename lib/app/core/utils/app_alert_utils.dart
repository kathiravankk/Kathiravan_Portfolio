import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:lottie/lottie.dart';

class AppAlertUtils {
  static Future<bool> showAppExitAlert({
    required BuildContext context,
    Widget? customContent,
    String? title,
    required String content,
    String cancelText = 'Cancel',
    VoidCallback? onCancel,
    String? confirmText,
    VoidCallback? onConfirm,
    bool isDestructive = false,
    bool barrierDismissible = false,
  }) async {
    bool result = false;

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.fieldBgColor,
          title: Image.asset(AssetImages.appAlertImage, height: 30, width: 30),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null)
                Text(
                  title,
                  style: AppStyles.customTextStyle(
                    size: 18,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              customContent ??
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w300,
                      lineSpace: 1.3,
                    ),
                  ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            if (confirmText != null)
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButtonWidget(
                      buttonFunction: () {
                        result = true; // ✅ Confirm → allow exit
                        Get.back();
                        onConfirm?.call();
                      },
                      buttonText: confirmText,
                      height: 35,
                    ),
                  ),
                  Expanded(
                    child: CustomButtonWidget(
                      buttonFunction: () {
                        result = false; // ❌ Cancel → prevent exit
                        Get.back();
                        onCancel?.call();
                      },
                      buttonText: cancelText,
                      bgColor: AppColors.disableButtonColor3,
                      height: 35,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );

    return result;
  }

  static Future<void> showAppUpdateAlert({
    required BuildContext context,
    Widget? customContent,
    String? title,
    required String content,
    String cancelText = 'Cancel',
    VoidCallback? onCancel,
    String? confirmText,
    VoidCallback? onConfirm,
    bool isDestructive = false,
    bool barrierDismissible = false,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.fieldBgColor,
          title: Image.asset(AssetImages.appAlertImage, height: 30, width: 30),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null) ...[
                Text(
                  title,
                  style: AppStyles.customTextStyle(
                    size: 18,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              customContent ??
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w300,
                      lineSpace: 1.3,
                    ),
                  ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            if (confirmText != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomButtonWidget(
                      buttonFunction: () {
                        Get.back();
                        onConfirm?.call();
                      },
                      buttonText: confirmText,
                      //width: 130,
                      height: 35,
                    ),
                  ),
                  Expanded(
                    child: CustomButtonWidget(
                      buttonFunction: () {
                        Get.back();
                        onCancel?.call();
                      },
                      buttonText: cancelText,
                      bgColor: AppColors.disableButtonColor3,
                      //width: 130,
                      height: 35,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  static Future<void> showAppAlert({
    required BuildContext context,
    Widget? customContent,
    String? title,
    required String content,
    String cancelText = 'Cancel',
    VoidCallback? onCancel,
    String? confirmText,
    VoidCallback? onConfirm,
    bool isDestructive = false,
    bool barrierDismissible = false,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.fieldBgColor,
          title: Image.asset(AssetImages.appAlertImage, height: 30, width: 30),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null) ...[
                Text(
                  title,
                  style: AppStyles.customTextStyle(
                    size: 18,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              customContent ??
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w300,
                      lineSpace: 1.3,
                    ),
                  ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            if (confirmText != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomButtonWidget(
                      buttonFunction: () {
                        Get.back();
                        onConfirm?.call();
                      },
                      buttonText: confirmText,
                      //width: 130,
                      height: 35,
                    ),
                  ),
                  Expanded(
                    child: CustomButtonWidget(
                      buttonFunction: () {
                        Get.back();
                        onCancel?.call();
                      },
                      buttonText: cancelText,
                      bgColor: AppColors.disableButtonColor3,
                      //width: 130,
                      height: 35,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  static void showToast({required String message, bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      textColor: isError ? AppColors.failTextColor : AppColors.sucTextColor,
      fontSize: 14,
      backgroundColor: isError ? AppColors.failBgColor : AppColors.sucBgColor,
    );
  }

  static Future<void> showPaymentRequiredDialog({
    required BuildContext context,
    required String courseName,
    required String amount,
    String cancelText = "CANCEL",
    String confirmText = "PAY ₹",
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    bool barrierDismissible = false,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.fieldBgColor,
          title: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.paymentContColor,
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.primaryColor,
              size: 30,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: CustomButtonWidget(
                    buttonFunction: () {
                      Get.back();
                      onConfirm?.call();
                    },
                    buttonText: confirmText,
                    height: 35,
                    bgColor: AppColors.primaryColor,
                  ),
                ),
                Expanded(
                  child: CustomButtonWidget(
                    buttonFunction: () {
                      Get.back();
                      onCancel?.call();
                    },
                    buttonText: cancelText,
                    height: 35,
                    bgColor: AppColors.disableButtonColor3,
                  ),
                ),
              ],
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            children: [
              Text(
                "PAYMENT REQUIRED",
                style: AppStyles.customTextStyle(
                  size: 18,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              Text(
                "To start this internship, you need to pay\nthe course fee.",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w300,
                  lineSpace: 1.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.paymentContColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  spacing: 5,
                  children: [
                    _paymentRow("COURSE", courseName),
                    const Divider(
                      color: AppColors.dividerContColor,
                      thickness: 0.5,
                    ),
                    _paymentRow(
                      "AMOUNT",
                      "₹ $amount",
                      valueColor: AppColors.primaryColor,
                      isAmount: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget customLoader() {
    return Center(
      child: Lottie.asset(
        AssetImages.loadingIndicator,
        height: 200,
        width: 200
      ),
    );
  }

  static Widget _paymentRow(
    String title,
    String value, {
    Color valueColor = AppColors.whiteColor,
    bool isAmount = false,
  }) {
    return Row(
      children: [
        /// LEFT TEXT
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: AppStyles.customTextStyle(
              size: 10,
              color: AppColors.whiteColor,
              weight: FontWeight.w300,
            ),
          ),
        ),

        const SizedBox(width: 10),

        /// RIGHT TEXT (IMPORTANT)
        Expanded(
          flex: 6,
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppStyles.customTextStyle(
              size: 12,
              color: valueColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
