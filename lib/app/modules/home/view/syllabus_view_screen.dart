import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/code_example_widget.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';
import 'package:internsharks/app/modules/home/controller/internship_controller.dart';

class SyllabusViewScreen extends StatefulWidget {
  const SyllabusViewScreen({super.key});

  @override
  State<SyllabusViewScreen> createState() => _SyllabusViewScreenState();
}

class _SyllabusViewScreenState extends State<SyllabusViewScreen> {
  WeeklyData? weekData;
  String? weeklyStatus;
  int? weekNumber;

  // String? jobId;
  // String? studentId;

  int currentDayIndex = 0;

  final InternshipController internController =
      Get.find<InternshipController>();

  @override
  void initState() {
    super.initState();
    weekData = Get.arguments["weekData"];
    weeklyStatus = Get.arguments["weeklyStatus"] ?? "";
    weekNumber = Get.arguments["weekNumber"] ?? 0;
    // jobId = Get.arguments["jobId"] ?? "";
    // studentId = Get.arguments["studentId"] ?? "";
  }

  void nextDay() {
    if (currentDayIndex < weekData!.days!.length - 1) {
      setState(() {
        currentDayIndex++;
      });
    } else if (weeklyStatus == "Completed") {
      AppFunctions.showToast(
        message: "You have already completed this week!",
        isError: true,
      );
    } else {
      markWeekComplete();
    }
  }

  void previousDay() {
    if (currentDayIndex > 0) {
      setState(() {
        currentDayIndex--;
      });
    }
  }

  Future<void> markWeekComplete() async {
    debugPrint("Week Completed");
    await internController.updateInternWeeklyStatus(
      weeklyData: {
        "studentId": internController.syllabusModel.syllabusData!.student ?? "",
        "jobId": internController.syllabusModel.syllabusData!.job ?? "",
        "weekNumber": weekNumber,
      },
    );
    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message:
            internController.weeklyUpdateModel.message ??
            "This Week Completed Successfully!",
      );
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayData = weekData!.days![currentDayIndex];
    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor_2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: AppColors.whiteColor,
          ),
          onPressed: () =>
              dayData.day! == 1 ||
                  dayData.day! == 8 ||
                  dayData.day! == 15 ||
                  dayData.day! == 22
              ? Get.back()
              : previousDay(),
        ),
        elevation: 0,
        //centerTitle: true,
        title: Text(
          "Day - ${dayData.day}",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.secondaryColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            spacing: 15,
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ...dayData.topics!.map((topic) {
                      return Column(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            topic.title ?? "",
                            style: AppStyles.customTextStyle(
                              size: 16,
                              lineSpace: 1.3,
                              color: AppColors.whiteColor,
                              weight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            topic.explanation ?? "",
                            style: AppStyles.customTextStyle(
                              size: 12,
                              lineSpace: 1.3,
                              color: AppColors.lightText,
                              weight: FontWeight.w300,
                            ),
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.edit_document,
                                color: AppColors.primaryColor,
                                size: 15,
                              ),
                              Text(
                                "Teacher's Notes",
                                style: AppStyles.customTextStyle(
                                  size: 14,
                                  color: AppColors.whiteColor,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          ...topic.codeExamples!.map(
                            (code) => CodeExampleWidget(code: code),
                          ),

                          if (topic.homework != null)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.contColor3,
                                border: Border.all(
                                  color: AppColors.contBorderColor3,
                                ),
                              ),
                              padding: EdgeInsets.all(15),
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Home Work",
                                    style: AppStyles.customTextStyle(
                                      size: 14,
                                      color: AppColors.whiteColor,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                  ...topic.homework!.map(
                                    (hw) => Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Row(
                                        spacing: 5,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            color: AppColors.primaryColor,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              hw,
                                              style: AppStyles.customTextStyle(
                                                size: 12,
                                                lineSpace: 1.3,
                                                color: AppColors.lightText,
                                                weight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }),
                    SizedBox(height: 15),

                    if (dayData.projectSchedule!.isNotEmpty)
                      ...dayData.projectSchedule!.map(
                        (project) => projectTaskCard(project),
                      ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              Obx(
                () => CustomButtonWidget(
                  isLoading: internController.weeklyUpdateLoading,
                  height: 40,
                  buttonFunction: nextDay,
                  buttonText: currentDayIndex == weekData!.days!.length - 1
                      ? weeklyStatus == "Completed"
                            ? "Completed"
                            : "Mark as Complete"
                      : "Next",
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget projectTaskCard(ProjectScheduleData project) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.disableFieldColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.disableBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 6,
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: AppColors.primaryColor,
                size: 18,
              ),
              Text(
                "Project Task – Day ${project.day}",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              children: [
                TextSpan(
                  text: "Project: ",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: project.project ?? "",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.lightText,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            project.task ?? "",
            style: AppStyles.customTextStyle(
              size: 12,
              lineSpace: 1.3,
              color: AppColors.chatTextColor,
              weight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
