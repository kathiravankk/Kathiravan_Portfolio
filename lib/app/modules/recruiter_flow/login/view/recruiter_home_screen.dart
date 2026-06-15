import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';

class RecruiterHomeScreen extends StatefulWidget {
  const RecruiterHomeScreen({super.key});

  @override
  State<RecruiterHomeScreen> createState() => _RecruiterHomeScreenState();
}

class _RecruiterHomeScreenState extends State<RecruiterHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparentColor,
      appBar: AppBar(backgroundColor: AppColors.transparentColor),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                AppAlertUtils.showAppAlert(
                  context: context,
                  content: "Are you sure you want to logout?",
                  confirmText: "Confirm",
                  title: "Logout",
                  onConfirm: () {
                    AppFunctions.logOutFunc(context);
                  },
                );
              },
              icon: Icon(Icons.logout, color: AppColors.whiteColor, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
