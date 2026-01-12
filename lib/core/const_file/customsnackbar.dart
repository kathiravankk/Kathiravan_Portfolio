import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {

  static void showSnackBarMessage({
    required String message,
    bool isError = false,
  }) {
    Get.snackbar(
      isError ? "Error" : "Success",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }
}
