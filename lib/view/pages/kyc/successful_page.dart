import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';
import 'package:internsharks/core/routes/app_pages.dart';

class SuccessfulPage extends StatefulWidget {
  const SuccessfulPage({super.key});

  @override
  State<SuccessfulPage> createState() => _SuccessfulPageState();
}

class _SuccessfulPageState extends State<SuccessfulPage> {
  @override
  void initState() {
    super.initState();

    // 🔥 AUTO NAVIGATE TO HOME AFTER 3 SECONDS
    Future.delayed(const Duration(seconds: 1), () {Get.toNamed(
      Routes.homeScreen,
      arguments: {'activeStep': 4},
    );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success GIF
            Container(
              width: 200,
              height: 150,
              child: ClipOval(
                child: Image.asset(
                  'lib/asset/images/icons/verified.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Submission',
              style: TextStyle(
                color: AppColors.appYellow,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              'Congratulations!',
              style: TextStyle(
                color: AppColors.appYellow,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'we’re reviewing your documents. this usually takes up to 24 hours. we notify you once it’s complete.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
