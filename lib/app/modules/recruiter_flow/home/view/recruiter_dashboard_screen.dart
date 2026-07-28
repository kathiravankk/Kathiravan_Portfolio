import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_nav_bar.dart';
import 'package:internsharks/app/modules/home/view/privacy_policy_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/view/recruiter_drawer_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/view/recruiter_home_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/view/recruiter_referral_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/view/shortlisted_students_list_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/view/post_new_internship_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/view/posted_internship_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/view/recruiter_interns_screen.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class RecruiterDashboardScreen extends StatefulWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  State<RecruiterDashboardScreen> createState() =>
      _RecruiterDashboardScreenState();
}

class _RecruiterDashboardScreenState extends State<RecruiterDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final homeKey = GlobalKey<RecruiterHomeScreenState>();
  final postKey = GlobalKey<PostedInternshipScreenState>();
  final internKey = GlobalKey<RecruiterInternsScreenState>();
  final referralKey = GlobalKey<RecruiterReferralScreenState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTab(0);
    });
  }

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
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () {
                AppFunctions.navigateScreen(
                  context,
                  AppRoutes.postNewInternshipScreen,
                );
              },
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blackColor,
                  border: Border.all(color: AppColors.secondaryColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryColor.withValues(alpha: 0.45),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          backgroundColor: AppColors.transparentColor,
          drawer: const RecruiterDrawerScreen(),
          bottomNavigationBar: null,
          body: CustomNavBar(
            isStudentFlow: false,
            onTabChanged: _refreshTab,
            screens: [
              RecruiterHomeScreen(
                onProfileTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                key: homeKey,
              ),
              PostedInternshipScreen(key: postKey),
              RecruiterInternsScreen(key: internKey),
              RecruiterReferralScreen(key: referralKey),
            ],
          ),
        ),
      ),
    );
  }

  void _refreshTab(int index) {
    switch (index) {
      case 0:
        homeKey.currentState?.refreshData();
        break;

      case 1:
        postKey.currentState?.refreshData();
        break;

      case 2:
        internKey.currentState?.refreshData();
        break;

      case 3:
        referralKey.currentState?.refreshData();
        break;
    }
  }
}
