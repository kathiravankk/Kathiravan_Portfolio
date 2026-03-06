import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/internship_controller.dart';

class MyInternshipScreen extends StatefulWidget {
  const MyInternshipScreen({super.key});

  @override
  State<MyInternshipScreen> createState() => _MyInternshipScreenState();
}

class _MyInternshipScreenState extends State<MyInternshipScreen> {
  final InternshipController internController =
      Get.find<InternshipController>();

  String studentId = "";

  @override
  void initState() {
    getInternshipData();
    super.initState();
  }

  Future<void> getInternshipData() async {
    studentId = await LocalStorageService.getStudentId() ?? "";
    await internController.getInternshipSyllabus(studentId: studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        automaticallyImplyActions: false,
        centerTitle: true,
        title: Text(
          "My Internships",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(),
    );
  }
}
