import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import '../../../../core/const_file/asset_image.dart';
import '../../../data/repositories/local_storage_service.dart';

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
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void _initAnimations() {
    _featherController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _boxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _gifController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _featherAnimation = CurvedAnimation(
      parent: _featherController,
      curve: Curves.easeIn,
    );
    _boxAnimation = CurvedAnimation(
      parent: _boxController,
      curve: Curves.easeInOut,
    );
    _gifAnimation = CurvedAnimation(
      parent: _gifController,
      curve: Curves.easeOut,
    );
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
      await Future.delayed(const Duration(seconds: 3));
      await _checkLoginStatus();
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('stud_token');
    final token = await LocalStorageService.getToken();

    final isVerified = prefs.getBool('student_verified') ?? false;

    if (token != null && token.isNotEmpty) {
      if (isVerified) {
        Get.offAllNamed(AppRoutes.dashBoardScreen);
      } else {
        Get.offAllNamed(AppRoutes.dashBoardScreen);
      }
    } else {
      Get.offAllNamed(AppRoutes.loginScreen);
      //Get.offAllNamed(AppRoutes.dashBoardScreen);
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
              Center(
                child: FadeTransition(
                  opacity: _featherAnimation,
                  child: Image.asset(AssetImages.appIconImage, width: 200),
                ),
              ),

              Center(
                child: AnimatedBuilder(
                  animation: _boxAnimation,
                  builder: (context, child) {
                    return Container(
                      width:
                          MediaQuery.of(context).size.width *
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
                                    AssetImages.splashGif,
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
