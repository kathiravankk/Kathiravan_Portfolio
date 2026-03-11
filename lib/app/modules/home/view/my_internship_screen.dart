import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/internship_syllabus_card.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/internship_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class MyInternshipScreen extends StatefulWidget {
  const MyInternshipScreen({super.key});

  @override
  State<MyInternshipScreen> createState() => _MyInternshipScreenState();
}

class _MyInternshipScreenState extends State<MyInternshipScreen> {
  final InternshipController internController =
      Get.find<InternshipController>();

  String studentId = "";
  List<SyllabusData>? syllabusList = [];

  @override
  void initState() {
    getInternshipData();
    super.initState();
  }

  Future<void> getInternshipData() async {
    studentId = await LocalStorageService.getStudentId() ?? "";
    await internController.getInternshipSyllabus(studentId: studentId);
    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      syllabusList = internController.internSyllabusModel.syllabus ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.appBgColor_2,
      color: AppColors.primaryColor,
      onRefresh: () => getInternshipData(),
      child: Scaffold(
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
        body: Obx(
          () => internController.internSyllabusLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.secondaryColor,
                  ),
                )
              : syllabusList!.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: syllabusList!.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(15),
                  itemBuilder: (context, index) {
                    final item = syllabusList![index];
                    return InternSyllabusCard(
                      title: item.subject ?? "NA",
                      subTitle: "Introduction to Software Developer",
                      totalWeeks: item.totalWeeks ?? 0,
                      totalTopics: item.meta!.totalTopics ?? 0,
                      viewFunc: () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.internshipSyllabusScreen,
                          arguments: {"jobId": item.job, "studentId": item.student},
                        );
                      },
                    );
                  },
                )
              : CustomEmptyWidget(),
        ),
      ),
    );
  }
}
