import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
    // Set orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Check version
    final shouldBlock = await _checkVersion();

    if (!shouldBlock) {
      // Small delay so the user actually sees the splash screen for a moment
      await Future.delayed(const Duration(milliseconds: 500));
      await _checkLoginStatus();
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
            // Shows the version number at the bottom
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


// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _featherController;
//   late AnimationController _boxController;
//   late AnimationController _gifController;
//
//   late Animation<double> _featherAnimation;
//   late Animation<double> _boxAnimation;
//   late Animation<double> _gifAnimation;
//
//   final NewVersionPlus _newVersion = NewVersionPlus(
//     androidId: 'com.doubletap.internsharks.ai',
//   );
//   String localVersion = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _secureSetup();
//     _initAnimations();
//     _startAnimationSequence();
//   }
//
//   Future<void> _secureSetup() async {
//     await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   }
//
//   void _initAnimations() {
//     _featherController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _boxController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _gifController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//
//     _featherAnimation = CurvedAnimation(
//       parent: _featherController,
//       curve: Curves.easeIn,
//     );
//     _boxAnimation = CurvedAnimation(
//       parent: _boxController,
//       curve: Curves.easeInOut,
//     );
//     _gifAnimation = CurvedAnimation(
//       parent: _gifController,
//       curve: Curves.easeOut,
//     );
//   }
//
//   Future<void> _startAnimationSequence() async {
//     await _featherController.forward();
//     await Future.delayed(const Duration(milliseconds: 400));
//     await _featherController.reverse();
//
//     await _boxController.forward();
//     await _gifController.forward();
//
//     await Future.delayed(const Duration(milliseconds: 1200));
//
//     if (!mounted) return;
//
//     final shouldBlock = await _checkVersion();
//
//     if (!shouldBlock) {
//       await Future.delayed(const Duration(seconds: 1));
//       await _checkLoginStatus();
//     }
//   }
//
//   Future<bool> _checkVersion() async {
//     try {
//       final status = await _newVersion.getVersionStatus();
//
//       if (status != null) {
//         if (!mounted) return false;
//
//         setState(() {
//           localVersion = status.localVersion;
//         });
//
//         if (status.canUpdate) {
//           _showForceUpdateDialog(status.appStoreLink);
//           return true;
//         }
//       }
//     } catch (e) {
//       debugPrint("Version check failed: $e");
//     }
//     return false;
//   }
//
//   void _showForceUpdateDialog(String updateUrl) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: AlertDialog(
//             backgroundColor: AppColors.fieldBgColor,
//             title: Text(
//               "Update Required",
//               style: AppStyles.customTextStyle(
//                 size: 16,
//                 color: AppColors.whiteColor,
//                 weight: FontWeight.w600,
//               ),
//             ),
//             content: Text(
//               "A new version is available. Please update to continue.",
//               style: AppStyles.customTextStyle(
//                 size: 13,
//                 color: AppColors.whiteColor,
//               ),
//             ),
//             actions: [
//               CustomButtonWidget(
//                 buttonFunction: () {
//                   _newVersion.launchAppStore(updateUrl);
//                 },
//                 buttonText: "Update Now",
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     // final token = prefs.getString('stud_token');
//     final token = await LocalStorageService.getToken();
//
//     final isVerified = prefs.getBool('student_verified') ?? false;
//
//     if (token != null && token.isNotEmpty) {
//       if (isVerified) {
//         Get.offAllNamed(AppRoutes.dashBoardScreen);
//       } else {
//         Get.offAllNamed(AppRoutes.dashBoardScreen);
//       }
//     } else {
//       Get.offAllNamed(AppRoutes.loginScreen);
//       //Get.offAllNamed(AppRoutes.dashBoardScreen);
//     }
//   }
//
//   @override
//   void dispose() {
//     _featherController.dispose();
//     _boxController.dispose();
//     _gifController.dispose();
//     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       body: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AssetImages.newAppBg),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(),
//         // Stack(
//         //   children: [
//         //     Center(
//         //       child: FadeTransition(
//         //         opacity: _featherAnimation,
//         //         child: Image.asset(AssetImages.appIconImage, width: 200),
//         //       ),
//         //     ),
//         //
//         //     Center(
//         //       child: AnimatedBuilder(
//         //         animation: _boxAnimation,
//         //         builder: (context, child) {
//         //           return Container(
//         //             width:
//         //                 MediaQuery.of(context).size.width *
//         //                 0.85 *
//         //                 _boxAnimation.value,
//         //             height: 100,
//         //             decoration: BoxDecoration(
//         //               color: Colors.white,
//         //               borderRadius: BorderRadius.circular(20),
//         //             ),
//         //             child: _boxAnimation.value > 0.95
//         //                 ? FadeTransition(
//         //                     opacity: _gifAnimation,
//         //                     child: ScaleTransition(
//         //                       scale: _gifAnimation,
//         //                       child: Center(
//         //                         child: Image.asset(
//         //                           AssetImages.splashGif,
//         //                           width: 220,
//         //                         ),
//         //                       ),
//         //                     ),
//         //                   )
//         //                 : const SizedBox.shrink(),
//         //           );
//         //         },
//         //       ),
//         //     ),
//         //     Positioned(
//         //       bottom: 20,
//         //       left: 0,
//         //       right: 0,
//         //       child: Text(
//         //         "v $localVersion",
//         //         textAlign: TextAlign.center,
//         //         style: const TextStyle(color: Colors.white, fontSize: 12),
//         //       ),
//         //     ),
//         //   ],
//         // ),
//       ),
//     );
//   }
// }
