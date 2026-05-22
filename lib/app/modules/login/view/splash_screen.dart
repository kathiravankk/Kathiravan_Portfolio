import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // 👈 Add this import
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import '../../../data/repositories/local_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final NewVersionPlus _newVersion = NewVersionPlus(
    androidId: 'com.doubletap.internsharks.ai',
  );
  String localVersion = "";

  @override
  void initState() {
    super.initState();
    _setupAndNavigate();
  }

  Future<void> _setupAndNavigate() async {
    // 1. Set orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // 2. Fetch and store FCM Token 👈 Added here
    await _getAndStoreFCMToken();

    // 3. Check version
    final shouldBlock = await _checkVersion();

    if (!shouldBlock) {
      await Future.delayed(const Duration(milliseconds: 500));
      await _checkLoginStatus();
    }
  }

  // New method to handle Firebase Cloud Messaging Token
  Future<void> _getAndStoreFCMToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request notification permissions (Required for Android 13+)
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted notification permission.');
      }

      // Get the device token
      String? fcmToken = await messaging.getToken();

      if (fcmToken != null) {
        debugPrint("FCM Token: $fcmToken");

        // Save it locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', fcmToken);

        // Alternatively, if your LocalStorageService has a method for it, use:
        // await LocalStorageService.saveFcmToken(fcmToken);
      }
    } catch (e) {
      debugPrint("Error fetching FCM token: $e");
    }
  }

  Future<bool> _checkVersion() async {
    try {
      final status = await _newVersion.getVersionStatus();
      if (status != null) {
        if (!mounted) return false;
        setState(() {
          localVersion = status.localVersion;
        });
        if (status.canUpdate) {
          _showForceUpdateDialog(status.appStoreLink);
          return true;
        }
      }
    } catch (e) {
      debugPrint("Version check failed: $e");
    }
    return false;
  }

  void _showForceUpdateDialog(String updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: AppColors.fieldBgColor,
          title: Text("Update Required", style: AppStyles.customTextStyle(size: 16, color: AppColors.whiteColor, weight: FontWeight.w600)),
          content: Text("A new version is available. Please update to continue.", style: AppStyles.customTextStyle(size: 13, color: AppColors.whiteColor)),
          actions: [
            CustomButtonWidget(
              buttonFunction: () => _newVersion.launchAppStore(updateUrl),
              buttonText: "Update Now",
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = await LocalStorageService.getToken();
    final isVerified = prefs.getBool('student_verified') ?? false;

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.dashBoardScreen);
    } else {
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.newAppBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Text(
                localVersion.isNotEmpty ? "v $localVersion" : "",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}