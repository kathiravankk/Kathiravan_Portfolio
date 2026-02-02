import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/widgets/custom_nav_bar.dart';
import 'package:internsharks/app/modules/home/view/interns_home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showExitAlert(context);
        return exit;
      },
      child: const Scaffold(
        backgroundColor: AppColors.transparentColor,
        body: CustomNavBar(
          screens: [
            InternsHomeScreen(),
            InternsHomeScreen(),
            InternsHomeScreen(),
            InternsHomeScreen(),
          ],
        ),
      ),
    );
  }

   Future<bool> showExitAlert(BuildContext context) async {
    bool result = false;
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Exit"),
          content: const Text("Are you sure you want to go back?"),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                "Confirm",
                style: TextStyle(color: AppColors.primaryColor),
              ),
              onPressed: () {
                result = true;
                Get.back();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Cancel"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
    return result;
  }
}


