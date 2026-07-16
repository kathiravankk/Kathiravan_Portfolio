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
              onTap: (){
                AppFunctions.navigateScreen(context, AppRoutes.postNewInternshipScreen);
              },
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blackColor,
                  border: Border.all(
                    color: AppColors.secondaryColor,
                    width: 2,
                  ),
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          backgroundColor: AppColors.transparentColor,
          drawer: const RecruiterDrawerScreen(),
          bottomNavigationBar: null,
          body: CustomNavBar(
            isStudentFlow: false,
            screens: [
              RecruiterHomeScreen(
                onProfileTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              PostedInternshipScreen(),
              RecruiterInternsScreen(),
              RecruiterReferralScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
