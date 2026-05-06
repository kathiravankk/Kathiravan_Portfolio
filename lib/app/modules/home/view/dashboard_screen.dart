import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/widgets/custom_nav_bar.dart';
import 'package:internsharks/app/modules/home/view/interns_home_screen.dart';
import 'package:internsharks/app/modules/home/view/my_applies_screen.dart';
import 'package:internsharks/app/modules/internship/view/my_internship_screen.dart';
import 'package:internsharks/app/modules/profile/view/home_profile_screen.dart';
import '../../../core/utils/app_functions.dart' show AppFunctions;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldExit = await AppFunctions.showAppExitAlert(
          context: context,
          title: "Exit ?",
          content: "Are you sure you want to Exit the app?",
          confirmText: "Confirm",
          cancelText: "Cancel",
        );

        if (shouldExit) {
          Get.back(); // ✅ Actually exit app/screen
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        body: CustomNavBar(
          screens: [
            const InternsHomeScreen(),
            const MyAppliesScreen(),
            MyInternshipScreen(),
            const HomeProfileScreen(),
          ],
        ),
      ),
    );
  }
}
