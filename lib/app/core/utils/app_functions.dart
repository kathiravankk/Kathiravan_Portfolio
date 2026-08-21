import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
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

  // static void logOutFunc(BuildContext context) {
  //   LocalStorageService.clearUser();
  //   AppFunctions.navigateInitialScreen(context, AppRoutes.choosePathScreen);
  // }

  static void logOutFunc(BuildContext context, {bool isRecruiter = false}) async {
    if (isRecruiter) {
      await LocalStorageService.clearRecruiter();
    } else {
      await LocalStorageService.clearStudent();
    }

    // Optional: Clear GetX controllers if you're using Get.delete<Controller>() here

    if (context.mounted) {
      AppFunctions.navigateInitialScreen(context, AppRoutes.choosePathScreen);
    }
  }

  static void apiErrorHandling(int responseCode, String message) {
    if (responseCode == 400) {
      AppAlertUtils.showToast(message: message, isError: true);
    } else if (responseCode == 400) {
      AppAlertUtils.showToast(message: message, isError: true);
    } else if (responseCode == 401) {
      AppAlertUtils.showToast(
        message: "Session expired, Please login again!",
        isError: true,
      );
      LocalStorageService.clearUser();
      Get.offAllNamed(AppRoutes.choosePathScreen);
    } else if (responseCode == 403) {
      AppAlertUtils.showToast(
        message: "Insufficient Balance!, Please Buy Credits!",
        isError: true,
      );
      //AppFunctions.showAppAlert(context: context, content: content)
    } else if (responseCode == 404) {
      AppAlertUtils.showToast(message: message, isError: true);
      //showToast(message: "Session expired, Please login again!", isError: true);
      //Get.offAllNamed(AppRoutes.loginScreen);
    } else if (responseCode == 500) {
      AppAlertUtils.showToast(message: message, isError: true);

    }
    else if (responseCode == 410) {
      AppAlertUtils.showToast(message: message, isError: true);
    } else if (responseCode == 502) {
      AppAlertUtils.showToast(message: message, isError: true);
    }
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }

    if (RegExp(r'[0-9]').hasMatch(value)) {
      return "Name should not contain numbers";
    }

    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
      return "Enter valid name";
    }

    return null;
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

  // static String getCategoryImage({required String service}) {
  //   switch (service) {
  //     case "Information Technology" || "EdTech":
  //       return AssetImages.softwareImg;
  //     case "Logistics" || "Aluminium Extrusion (Manufacturing)":
  //       return AssetImages.logisticImg;
  //     case "Finance":
  //       return AssetImages.financeImg;
  //     case "Healthcare" || "Orthopaedic & Spine Clinic":
  //       return AssetImages.healthCareImg;
  //     case "Hospitality & Tourism":
  //       return AssetImages.tourismServiceImg;
  //     case "Mining":
  //       return AssetImages.miningImg;
  //     case "IT/Software" || "HR Cosultancy ":
  //       return AssetImages.softwareImg;
  //     case "Customer Service":
  //       return AssetImages.customerServiceImg;
  //     case "Marketing" :
  //       return AssetImages.marketingImg;
  //     case "Designing":
  //       return AssetImages.designImg;
  //     case "AI Engineering":
  //       return AssetImages.aiEngineeringImg;
  //     case "BPO":
  //       return AssetImages.bpoImg;
  //     case "Salesforce" ||  "Hypercommerce":
  //       return AssetImages.salesForceImg;
  //     case "":
  //       return AssetImages.softwareImg;
  //     default:
  //       return AssetImages.softwareImg;
  //   }
  // }

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

  /// Parsers and sanitizes programming skills into a clean List<String>.
  /// Handles stringified JSON arrays, nested lists, comma-separated strings, etc.
  static List<String> parseSkillsList(dynamic value) {
    if (value == null) return [];

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return [];
      if (trimmed.startsWith('[')) {
        try {
          final decoded = jsonDecode(trimmed);
          return parseSkillsList(decoded);
        } catch (_) {}
      }
      return trimmed
          .split(',')
          .map((e) => e.replaceAll(RegExp(r'[\[\]\\"]'), '').trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (value is List) {
      final List<String> result = [];
      for (var item in value) {
        if (item == null) continue;
        if (item is List) {
          result.addAll(parseSkillsList(item));
        } else if (item is String) {
          final trimmed = item.trim();
          if (trimmed.startsWith('[')) {
            try {
              final decoded = jsonDecode(trimmed);
              result.addAll(parseSkillsList(decoded));
            } catch (_) {
              final cleaned = trimmed
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .replaceAll('"', '')
                  .replaceAll('\\', '')
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty);
              result.addAll(cleaned);
            }
          } else if (trimmed.isNotEmpty) {
            result.add(trimmed);
          }
        } else {
          final str = item.toString().trim();
          if (str.isNotEmpty) result.add(str);
        }
      }
      // Deduplicate preserving order
      final seen = <String>{};
      return result.where((e) => seen.add(e)).toList();
    }

    return [];
  }
}

// <key>LSApplicationQueriesSchemes</key>
// <array>
// <string>https</string>
// <string>http</string>
// </array>
