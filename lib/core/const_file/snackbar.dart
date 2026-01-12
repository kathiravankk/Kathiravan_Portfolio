import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {

  // ✅ SUCCESS SNACKBAR
  static void showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),

      // 🎨 LEFT GREEN BAR + ICON
      borderColor: Colors.green.shade600,
      borderWidth: 3,

      icon: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check_circle,
          color: Colors.green.shade600,
          size: 28,
        ),
      ),

      shouldIconPulse: false,

      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Icon(
          Icons.close,
          color: Colors.grey.shade600,
          size: 20,
        ),
      ),

      boxShadows: [
        BoxShadow(
          color: Colors.green.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // ❌ ERROR SNACKBAR
  static void showError({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),

      // 🎨 LEFT RED BAR + ICON
      borderColor: Colors.red.shade600,
      borderWidth: 3,

      icon: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.error,
          color: Colors.red.shade600,
          size: 28,
        ),
      ),

      shouldIconPulse: false,

      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Icon(
          Icons.close,
          color: Colors.grey.shade600,
          size: 20,
        ),
      ),

      boxShadows: [
        BoxShadow(
          color: Colors.red.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // ℹ️ INFO SNACKBAR
  static void showInfo({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),

      // 🎨 LEFT BLUE BAR + ICON
      borderColor: Colors.blue.shade600,
      borderWidth: 3,

      icon: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.info,
          color: Colors.blue.shade600,
          size: 28,
        ),
      ),

      shouldIconPulse: false,

      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Icon(
          Icons.close,
          color: Colors.grey.shade600,
          size: 20,
        ),
      ),

      boxShadows: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // ⚠️ WARNING SNACKBAR
  static void showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),

      // 🎨 LEFT ORANGE BAR + ICON
      borderColor: Colors.orange.shade600,
      borderWidth: 3,

      icon: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.warning,
          color: Colors.orange.shade600,
          size: 28,
        ),
      ),

      shouldIconPulse: false,

      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Icon(
          Icons.close,
          color: Colors.grey.shade600,
          size: 20,
        ),
      ),

      boxShadows: [
        BoxShadow(
          color: Colors.orange.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}