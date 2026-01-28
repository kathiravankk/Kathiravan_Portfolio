import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'customsnackbar.dart';

class ApiErrorHandler {
  /// 🌐 COMMON API ERROR HANDLER
  static void handleApiError({
    required int responseCode,
    required String message,
  }) {
    switch (responseCode) {
      case 200:
        CustomSnackBar.showSnackBarMessage(message: message, isError: false);
        break;

      case 201:
        CustomSnackBar.showSnackBarMessage(message: message, isError: false);
        break;
      case 400:
        CustomSnackBar.showSnackBarMessage(message: message, isError: true);
        break;

      case 401:
        CustomSnackBar.showSnackBarMessage(
          message: "Session expired, please login again",
          isError: true,
        );
        Get.offAllNamed(AppRoutes.loginScreen);
        break;

      case 403:
        CustomSnackBar.showSnackBarMessage(
          message: "Package Expired",
          isError: true,
        );
        break;

      case 404:
        CustomSnackBar.showSnackBarMessage(message: message, isError: true);
        break;

      case 500:
        CustomSnackBar.showSnackBarMessage(
          message: "Server error. Please try again later",
          isError: true,
        );
        // Get.offAllNamed(Routes.networkErrorScreen);
        break;

      case 502:
        CustomSnackBar.showSnackBarMessage(
          message: "Bad gateway. Try again later",
          isError: true,
        );
        // Get.offAllNamed(Routes.dataErrorScreen);
        break;

      default:
        CustomSnackBar.showSnackBarMessage(
          message: "Something went wrong",
          isError: true,
        );
    }
  }

  static void showToast({required String message, bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      textColor: isError ? Colors.red : Colors.green,
      fontSize: 14,
      backgroundColor: isError ? Colors.white : Colors.white,
    );
  }
}
