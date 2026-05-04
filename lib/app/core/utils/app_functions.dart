import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFunctions {
  //Routing functions
  static void navigateScreen(
    BuildContext context,
    String screenName, {
    dynamic arguments,
  }) {
    FocusScope.of(context).unfocus();
    Get.toNamed(screenName, arguments: arguments);
  }

  static Future<dynamic> navigateFutureScreen(
    BuildContext context,
    String screenName, {
    dynamic arguments,
  }) async {
    FocusScope.of(context).unfocus();
    return await Get.toNamed(screenName, arguments: arguments);
  }

  static void navigateInitialScreen(
    BuildContext context,
    String screenName, {
    dynamic arguments,
  }) async {
    FocusScope.of(context).unfocus();
    await Get.offAllNamed(screenName, arguments: arguments);
  }

  static void logOutFunc(BuildContext context) {
    LocalStorageService.clearUser();
    AppFunctions.navigateInitialScreen(context, AppRoutes.loginScreen);
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

  static void apiErrorHandling(int responseCode, String message) {
    if (responseCode == 400) {
      showToast(message: message, isError: true);
    } else if (responseCode == 400) {
      showToast(message: message, isError: true);
    } else if (responseCode == 401) {
      showToast(message: "Session expired, Please login again!", isError: true);
      LocalStorageService.clearUser();
      Get.offAllNamed(AppRoutes.loginScreen);
    } else if (responseCode == 403) {
      showToast(
        message: "Insufficient Balance!, Please Buy Credits!",
        isError: true,
      );
      //AppFunctions.showAppAlert(context: context, content: content)
    } else if (responseCode == 404) {
       showToast(message: message, isError: true);
      //showToast(message: "Session expired, Please login again!", isError: true);
      //Get.offAllNamed(AppRoutes.loginScreen);
    } else if (responseCode == 500) {
      showToast(message: message, isError: true);
    } else if (responseCode == 502) {
      showToast(message: message, isError: true);
    }
  }

  static String getSubtitle({required String key, required double score}) {
    switch (key) {
      case "Profile Summary":
        return _scoreText(
          score,
          excellent: 'Excellent summary with clear career direction',
          good: 'Good summary, add more impact and clarity',
          average: 'Basic summary, needs stronger storytelling',
          poor: 'Summary needs major improvement',
        );

      case 'Skills':
        return _scoreText(
          score,
          excellent: 'Strong, well-aligned technical skill set',
          good: 'Relevant skills, add depth or specialization',
          average: 'Skills listed but need better structuring',
          poor: 'Skills section is weak or incomplete',
        );

      case 'Experience':
        return _scoreText(
          score,
          excellent: 'Experience is impactful and result-driven',
          good: 'Good experience, add measurable outcomes',
          average: 'Experience lacks clarity and achievements',
          poor: 'Experience section needs major rework',
        );

      case 'Projects':
        return _scoreText(
          score,
          excellent: 'Projects are strong and industry-ready',
          good: 'Good projects, optimize descriptions',
          average: 'Projects need better explanation and impact',
          poor: 'Projects section is weak or unclear',
        );

      case 'Internships':
        return _scoreText(
          score,
          excellent: 'Internship experience is highly relevant',
          good: 'Good exposure, add responsibilities',
          average: 'Internship details need clarity',
          poor: 'Internship section needs improvement',
        );

      default:
        return '';
    }
  }

  static String _scoreText(
    double score, {
    required String excellent,
    required String good,
    required String average,
    required String poor,
  }) {
    if (score >= 8.5) {
      return excellent;
    } else if (score >= 6.5) {
      return good;
    } else if (score >= 4.5) {
      return average;
    } else {
      return poor;
    }
  }

  static String extractFilePathFromUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // Removes leading "/"
      return uri.path.startsWith('/') ? uri.path.substring(1) : uri.path;
    } catch (e) {
      return "";
    }
  }

  static Future<void> showAppAlert({
    required BuildContext context,
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
          title: Image.asset(AssetImages.appLogoImage, height: 30, width: 30),
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
                      bgColor: AppColors.fieldBgColor,
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

  static getCategoryImage({required String service}) {
    switch (service) {
      case "Information Technology":
        return AssetImages.softwareImg;
      case "Logistics":
        return AssetImages.logisticImg;
      case "Finance":
        return AssetImages.financeImg;
      case "Healthcare":
        return AssetImages.healthCareImg;
      case "Hospitality & Tourism":
        return AssetImages.tourismServiceImg;
      case "Mining":
        return AssetImages.miningImg;
      case "IT/Software":
        return AssetImages.softwareImg;
      case "Customer Service":
        return AssetImages.customerServiceImg;
      case "Marketing":
        return AssetImages.marketingImg;
      case "Designing":
        return AssetImages.designImg;
      case "AI Engineering":
        return AssetImages.aiEngineeringImg;
      case "BPO":
        return AssetImages.bpoImg;
      case "Salesforce":
        return AssetImages.salesForceImg;
      default:
        AssetImages.softwareImg;
    }
  }

  static String convertPostedDate(String dateTimeString) {
    if (dateTimeString.isEmpty) {
      return "NA";
    }
    try {
      final DateTime parsedDate = DateTime.parse(dateTimeString).toLocal();
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(parsedDate);

      if (difference.inDays == 0) {
        return "Today";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} days ago";
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return "$weeks week${weeks > 1 ? 's' : ''} ago";
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return "$months month${months > 1 ? 's' : ''} ago";
      } else {
        final years = (difference.inDays / 365).floor();
        return "$years year${years > 1 ? 's' : ''} ago";
      }
    } catch (e) {
      return "NA";
    }
  }

  static String? validateIndianMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Mobile number is required";
    }

    final mobile = value.trim();

    /// must be exactly 10 digits
    if (mobile.length != 10) {
      return "Mobile number must be 10 digits";
    }

    /// must contain only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      return "Only numbers are allowed";
    }

    /// should not start with 0–5
    if (RegExp(r'^[0-5]').hasMatch(mobile)) {
      return "Mobile number must start from 6-9";
    }

    return null; // ✅ valid
  }

  static String formatIsoDate(String isoString) {
    try {
      DateTime dateTime = DateTime.parse(isoString);

      // 2. Format to "03 March 2025"
      // 'dd' -> padded day, 'MMMM' -> full month name, 'yyyy' -> year
      return DateFormat("dd MMMM yyyy").format(dateTime);
    } catch (e) {
      return "Invalid date";
    }
  }

  static Future<void> launchWebURL({required String webUrl}) async {
    final Uri url = Uri.parse(webUrl);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void> openGoogleMap(String mapUrl) async {
    final Uri uri = Uri.parse(mapUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch map';
    }
  }

  static String? validateEmail({
    required String? newEmail,
    required String? currentEmail,
  }) {
    final email = newEmail?.trim() ?? "";
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    if (email.isEmpty) {
      return 'Please enter an Email!';
    }
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address!';
    }
    if (currentEmail != null && email == currentEmail.trim()) {
      return 'New Email must be different from current!';
    }

    return null; // Return null if validation passes
  }

  static String getFileName(String? path) {
    if (path == null || path.isEmpty) return "No file";

    // Get '1770360640535-Kathiravan_K_Resumes.pdf'
    String fullName = path.split('/').last;

    // If there is a '-' after the timestamp, remove everything before it
    if (fullName.contains('-')) {
      return fullName.split('-').last; // Returns 'Kathiravan_K_Resumes.pdf'
    }

    return fullName;
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
                    bgColor: AppColors.fieldBgColor,
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
                    const Divider(color: AppColors.dividerContColor, thickness: 0.5,),
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

  static Widget _paymentRow(
    String title,
    String value, {
    Color valueColor = AppColors.whiteColor,
    bool isAmount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.customTextStyle(
            size: 10,
            color: AppColors.whiteColor,
            weight: FontWeight.w300,
          ),
        ),
        Text(
          value,
          style: AppStyles.customTextStyle(
            size: 12,
            color: valueColor,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// <key>LSApplicationQueriesSchemes</key>
// <array>
// <string>https</string>
// <string>http</string>
// </array>
