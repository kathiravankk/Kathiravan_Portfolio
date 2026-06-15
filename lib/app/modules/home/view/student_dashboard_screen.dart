import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_nav_bar.dart';
import 'package:internsharks/app/core/widgets/home_drawer.dart';
import 'package:internsharks/app/modules/home/view/interns_home_screen.dart';
import 'package:internsharks/app/modules/home/view/my_applies_screen.dart';
import 'package:internsharks/app/modules/internship/view/my_internship_screen.dart';
import 'package:internsharks/app/modules/profile/view/home_profile_screen.dart';
import '../../../core/utils/app_functions.dart' show AppFunctions;

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await AppAlertUtils.showAppExitAlert(
          context: context,
          title: "Exit ?",
          content: "Are you sure you want to Exit the app?",
          confirmText: "Confirm",
          cancelText: "Cancel",
        );
        if (shouldExit) SystemNavigator.pop();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.appBackgroundImg),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          key: _scaffoldKey,           // drawer lives HERE
          drawer: HomeDrawer(),
          backgroundColor: AppColors.transparentColor,
          bottomNavigationBar: null,
          body: CustomNavBar(
            screens: [
              InternsHomeScreen(scaffoldKey: _scaffoldKey),  // pass key
              const MyAppliesScreen(),
              MyInternshipScreen(),
              const HomeProfileScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
