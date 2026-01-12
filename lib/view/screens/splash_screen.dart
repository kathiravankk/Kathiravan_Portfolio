// //
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:internsharks/core/const_file/app_colors.dart';
// // import 'package:internsharks/core/const_file/asset_image.dart';
// //
// // import '../pages/login/register_page.dart';
// // import '../pages/login/login_page.dart';
// //
// // class SplashScreen extends StatefulWidget {
// //   @override
// //   _SplashScreenState createState() => _SplashScreenState();
// // }
// //
// // class _SplashScreenState extends State<SplashScreen>
// //     with TickerProviderStateMixin {
// //   late AnimationController _featherController;
// //   late AnimationController _boxController;
// //   late AnimationController _gifController;
// //   late AnimationController _fadeOutController;
// //
// //   late Animation<double> _featherAnimation;
// //   late Animation<double> _boxAnimation;
// //   late Animation<double> _gifAnimation;
// //   late Animation<double> _fadeOutAnimation;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     // Feather fade in animation
// //     _featherController = AnimationController(
// //       duration: Duration(milliseconds: 1000),
// //       vsync: this,
// //     );
// //     _featherAnimation = CurvedAnimation(
// //       parent: _featherController,
// //       curve: Curves.easeIn,
// //     );
// //
// //     // White box animation from sides
// //     _boxController = AnimationController(
// //       duration: Duration(milliseconds: 800),
// //       vsync: this,
// //     );
// //     _boxAnimation = CurvedAnimation(
// //       parent: _boxController,
// //       curve: Curves.easeInOut,
// //     );
// //
// //     // GIF/Logo inside box animation
// //     _gifController = AnimationController(
// //       duration: Duration(milliseconds: 600),
// //       vsync: this,
// //     );
// //     _gifAnimation = CurvedAnimation(
// //       parent: _gifController,
// //       curve: Curves.easeOut,
// //     );
// //
// //     // Fade out animation for entire splash
// //     _fadeOutController = AnimationController(
// //       duration: Duration(milliseconds: 500),
// //       vsync: this,
// //     );
// //     _fadeOutAnimation = CurvedAnimation(
// //       parent: _fadeOutController,
// //       curve: Curves.easeOut,
// //     );
// //
// //     // Start animations in sequence
// //     _startAnimationSequence();
// //   }
// //   void _startAnimationSequence() async {
// //     await _featherController.forward();
// //     await Future.delayed(Duration(milliseconds: 500));
// //     await _featherController.reverse();
// //     await _boxController.forward();
// //     await _gifController.forward();
// //     await Future.delayed(Duration(milliseconds: 1500));
// //
// //
// //
// //     if (mounted) {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (context) => LoginPage()),
// //       );
// //     }
// //   }
// //   @override
// //   void dispose() {
// //     _featherController.dispose();
// //     _boxController.dispose();
// //     _gifController.dispose();
// //     _fadeOutController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(backgroundColor: AppColors.appColor,
// //       body: FadeTransition(
// //         opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_fadeOutAnimation),
// //         child: Container(
// //           padding: const EdgeInsets.all(20),
// //           width: double.infinity,
// //           decoration: BoxDecoration(
// //             image: DecorationImage(
// //                image: AssetImage(AppAssetImages.backgroundimage),
// //               fit: BoxFit.cover,
// //             ),
// //           ),
// //           child: Stack(
// //             children: [
// //               // Feather animation (appears first, then disappears)
// //               Center(
// //                 child: FadeTransition(
// //                   opacity: _featherAnimation,
// //                   child: Container(
// //                     width: 200,
// //                     height: 200,
// //                     decoration: BoxDecoration(
// //
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: Image(
// //                       image: AssetImage("asset/images/app_fether.png"),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //
// //               // White box animation from sides (appears after feather fades)
// //               Center(
// //                 child: AnimatedBuilder(
// //                   animation: _boxAnimation,
// //                   builder: (context, child) {
// //                     return Container(
// //                       width: MediaQuery.of(context).size.width *
// //                           0.85 *
// //                           _boxAnimation.value,
// //                       height: 100,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: _boxAnimation.value > 0.95
// //                           ? FadeTransition(
// //                         opacity: _gifAnimation,
// //                         child: ScaleTransition(
// //                           scale: _gifAnimation,
// //                           child: Center(
// //                             child: Container(
// //                               width: 250,
// //                               height: 250,
// //                               child: Image(
// //                                 image: AssetImage(
// //                                     "asset/images/splash_gif.gif"),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       )
// //                           : SizedBox.shrink(),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // Login Page - Replace with your actual login page
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../core/const_file/app_colors.dart';
// import '../core/const_file/asset_image.dart';
// import '../core/routes/app_pages.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//
//   late AnimationController _featherController;
//   late AnimationController _boxController;
//   late AnimationController _gifController;
//
//   late Animation<double> _featherAnimation;
//   late Animation<double> _boxAnimation;
//   late Animation<double> _gifAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _secureSetup();
//     _initAnimations();
//     _startAnimationSequence();
//   }
//
//   /// 🔒 Screenshot + 🔄 Rotation disable
//   Future<void> _secureSetup() async {
//
//
//     await SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//   }
//
//   void _initAnimations() {
//     _featherController =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
//     _boxController =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
//     _gifController =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
//
//     _featherAnimation =
//         CurvedAnimation(parent: _featherController, curve: Curves.easeIn);
//     _boxAnimation =
//         CurvedAnimation(parent: _boxController, curve: Curves.easeInOut);
//     _gifAnimation =
//         CurvedAnimation(parent: _gifController, curve: Curves.easeOut);
//   }
//
//   /// ▶ Animation + Logic flow
//   Future<void> _startAnimationSequence() async {
//     await _featherController.forward();
//     await Future.delayed(const Duration(milliseconds: 500));
//     await _featherController.reverse();
//
//     await _boxController.forward();
//     await _gifController.forward();
//
//     await Future.delayed(const Duration(milliseconds: 1500));
//
//     if (!mounted) return;
//
//     // 🆕 Update check
//     bool updateRequired = await _checkForUpdate();
//     if (updateRequired) {
//       _showUpdateDialog();
//       return;
//     }
//
//     // 🔐 Login check
//     await _checkLoginStatus();
//   }
//
//   /// 🔐 Login check
//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//
//     if (isLoggedIn) {
//       Get.offAllNamed(Routes.homeScreen);
//     } else {
//       Get.offAllNamed(Routes.loginPage);
//     }
//   }
//
//   /// 🆕 Play Store update logic (sample)
//   Future<bool> _checkForUpdate() async {
//     const currentVersion = "1.0.0";
//     const latestVersion = "1.0.1"; // backend / remote config
//
//     return currentVersion != latestVersion;
//   }
//
//   void _showUpdateDialog() {
//     Get.dialog(
//       AlertDialog(
//         title: const Text("Update Available"),
//         content: const Text(
//           "A new version is available. Please update the app to continue.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // TODO: Open Play Store link
//             },
//             child: const Text("Update"),
//           ),
//         ],
//       ),
//       barrierDismissible: true,
//     );
//   }
//
//   @override
//   void dispose() {
//     _featherController.dispose();
//     _boxController.dispose();
//     _gifController.dispose();
//
//     // 🔓 Rotation back
//     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         width: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppAssetImages.backgroundimage),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Stack(
//           children: [
//             /// Feather animation
//             Center(
//               child: FadeTransition(
//                 opacity: _featherAnimation,
//                 child: Image.asset(
//                   "asset/images/app_fether.png",
//                   width: 200,
//                 ),
//               ),
//             ),
//
//             /// White box + GIF
//             Center(
//               child: AnimatedBuilder(
//                 animation: _boxAnimation,
//                 builder: (context, child) {
//                   return Container(
//                     width: MediaQuery.of(context).size.width *
//                         0.85 *
//                         _boxAnimation.value,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: _boxAnimation.value > 0.95
//                         ? FadeTransition(
//                       opacity: _gifAnimation,
//                       child: ScaleTransition(
//                         scale: _gifAnimation,
//                         child: Center(
//                           child: Image.asset(
//                             "asset/images/splash_gif.gif",
//                             width: 220,
//                           ),
//                         ),
//                       ),
//                     )
//                         : const SizedBox.shrink(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import '../../core/const_file/app_colors.dart';
import '../../core/const_file/asset_image.dart';
import '../../core/routes/app_pages.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _featherController;
  late AnimationController _boxController;
  late AnimationController _gifController;

  late Animation<double> _featherAnimation;
  late Animation<double> _boxAnimation;
  late Animation<double> _gifAnimation;

  final Upgrader _upgrader = Upgrader(
    debugLogging: true,
    durationUntilAlertAgain: Duration.zero,
  );

  @override
  void initState() {
    super.initState();
    _secureSetup();
    _initAnimations();
    _startAnimationSequence();
  }

  Future<void> _secureSetup() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _initAnimations() {
    _featherController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _boxController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _gifController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _featherAnimation =
        CurvedAnimation(parent: _featherController, curve: Curves.easeIn);
    _boxAnimation =
        CurvedAnimation(parent: _boxController, curve: Curves.easeInOut);
    _gifAnimation =
        CurvedAnimation(parent: _gifController, curve: Curves.easeOut);
  }

  Future<void> _startAnimationSequence() async {
    await _featherController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    await _featherController.reverse();

    await _boxController.forward();
    await _gifController.forward();

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    await _upgrader.initialize();

    if (!_upgrader.shouldDisplayUpgrade()) {
      await _checkLoginStatus();
    }
    // ❗ Update இருந்தா → UpgradeAlert auto show ஆகும்
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offAllNamed(Routes.homeScreen);
    } else {
      Get.offAllNamed(Routes.loginPage);
    }
  }

  @override
  void dispose() {
    _featherController.dispose();
    _boxController.dispose();
    _gifController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: _upgrader,
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssetImages.backgroundimage),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [

              /// Feather
              Center(
                child: FadeTransition(
                  opacity: _featherAnimation,
                  child: Image.asset(
                    "asset/images/app_fether.png",
                    width: 200,
                  ),
                ),
              ),

              /// Box + GIF
              Center(
                child: AnimatedBuilder(
                  animation: _boxAnimation,
                  builder: (context, child) {
                    return Container(
                      width: MediaQuery.of(context).size.width *
                          0.85 *
                          _boxAnimation.value,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _boxAnimation.value > 0.95
                          ? FadeTransition(
                        opacity: _gifAnimation,
                        child: ScaleTransition(
                          scale: _gifAnimation,
                          child: Center(
                            child: Image.asset(
                              "asset/images/splash_gif.gif",
                              width: 220,
                            ),
                          ),
                        ),
                      )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
