import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/routes/app_pages.dart';

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

  static void navigateInitialScreen(
    BuildContext context,
    String screenName, {
    dynamic arguments,
  }) async {
    FocusScope.of(context).unfocus();
    await Get.offAllNamed(screenName, arguments: arguments);
  }

  static void logOutFunc(BuildContext context) {
    //LocalStorageService.clearUser();
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
    }
    else if (responseCode == 400) {
      showToast(message: message, isError: true);
    } else if (responseCode == 401) {
      showToast(message: "Session expired, Please login again!", isError: true);
      Get.offAllNamed(AppRoutes.loginScreen);
    } else if (responseCode == 403) {
      showToast(message: message, isError: true);
    } else if (responseCode == 404) {
      showToast(message: message, isError: true);
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


}
