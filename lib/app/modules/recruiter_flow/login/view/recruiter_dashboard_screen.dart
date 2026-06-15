import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_nav_bar.dart';
import 'package:internsharks/app/modules/home/view/privacy_policy_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/view/recruiter_home_screen.dart';

class RecruiterDashboardScreen extends StatefulWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  State<RecruiterDashboardScreen> createState() =>
      _RecruiterDashboardScreenState();
}

class _RecruiterDashboardScreenState extends State<RecruiterDashboardScreen> {
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
          key: _scaffoldKey,
          backgroundColor: AppColors.transparentColor,
          bottomNavigationBar: null,
          body: CustomNavBar(
            isStudentFlow: false,
            screens: [
              RecruiterHomeScreen(),
              RecruiterHomeScreen(),
              RecruiterHomeScreen(),
              RecruiterHomeScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
