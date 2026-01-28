import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';




class JobApplySuccesfull extends StatefulWidget {
  const JobApplySuccesfull({super.key});

  @override
  State<JobApplySuccesfull> createState() => _JobApplySuccesfullState();
}

class _JobApplySuccesfullState extends State<JobApplySuccesfull> {

  @override
  void initState() {
    super.initState();

    // 🔥 AUTO NAVIGATE TO HOME AFTER 3 SECONDS
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context,true);


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


            SizedBox(
              width: 200,
              height: 150,
              child: ClipOval(
                child: Image.asset(
                  'lib/assets/images/icons/verified.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Application Submitted!',
              style: TextStyle(
                color: AppColors.appYellow,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),



            const SizedBox(height: 16),

            const Text(
              'your application for the App developerExecutive role has been sent Successfully.',
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
