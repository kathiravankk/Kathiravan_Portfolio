import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';
import 'package:internsharks/app/data/models/internship/syllabus_data_model.dart';
import 'package:internsharks/app/modules/home/controller/internship_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class InternSyllabusScreen extends StatefulWidget {
  const InternSyllabusScreen({super.key});

  @override
  State<InternSyllabusScreen> createState() => _InternSyllabusScreenState();
}

class _InternSyllabusScreenState extends State<InternSyllabusScreen> {
  final InternshipController internController =
      Get.find<InternshipController>();

  final TextEditingController projectController = TextEditingController();

  String jobId = "";
  String studentId = "";
  int currentWeek = 1;
  SyllabusData? syllabus;
  List<WeeklyData>? weekList = [];
  List<WeeklyProgressData>? progressList = [];

  Map<int, WeeklyProgressData> progressMap = {};
  int lastCompletedWeek = 0;

  bool isProjectSubmitted = false;

  @override
  void initState() {
    jobId = Get.arguments["jobId"] ?? "";
    studentId = Get.arguments["studentId"] ?? "";
    getStatusData();
    getInitialData();
    super.initState();
  }

  Future<void> getStatusData() async {
    await internController.getInternStatus(jobId: jobId, studentId: studentId);
    if (internController.getResponseCode() == 200) {
      final links =
          internController.internStatusModel.application?.internProjectLink ??
          [];

      isProjectSubmitted = links.isNotEmpty;

      if (links.isNotEmpty) {
        projectController.text = links.first ?? "";
      }
      projectController.text =
          internController
              .internStatusModel
              .application!
              .internProjectLink!
              .isNotEmpty
          ? internController
                    .internStatusModel
                    .application!
                    .internProjectLink!
                    .first ??
                ""
          : "";
    }
  }

  Future<void> getInitialData() async {
    //await internController.getInternStatus(jobId: jobId, studentId: studentId);
    await internController.getSyllabusData(jobId: jobId);

    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      syllabus = internController.syllabusModel.syllabusData;
      weekList = syllabus?.data ?? [];

      progressList = internController.syllabusModel.weeklyProgressList ?? [];

      /// Convert list → map
      progressMap = {for (var p in progressList!) p.weekNumber ?? 0: p};

      /// Calculate last completed week
      lastCompletedWeek = progressList!
          .where((p) => p.status == "Completed")
          .map((p) => p.weekNumber ?? 0)
          .fold(0, (max, value) => value > max ? value : max);
      setState(() {});
    }
  }

  bool get areAllWeeksCompleted {
    if (weekList == null || weekList!.isEmpty) return false;

    return weekList!.every(
      (week) => progressMap[week.week]?.status == "Completed",
    );
  }

  bool get canSubmitProject {
    return areAllWeeksCompleted && !isProjectSubmitted;
  }

  bool get canAttendMockTest {
    return isProjectSubmitted &&
        !(internController.internStatusModel.isTestTaken ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          internController.syllabusDataLoading ||
              internController.internStatusLoading
          ? Center(
              child: CupertinoActivityIndicator(
                color: AppColors.secondaryColor,
              ),
            )
          : Scaffold(
              backgroundColor: AppColors.appBgColor_2,
              appBar: AppBar(
                backgroundColor: AppColors.appBgColor_2,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: AppColors.whiteColor,
                  ),
                  onPressed: () => Get.back(),
                ),
                elevation: 0,
                title: Text(
                  "Syllabus",
                  style: AppStyles.customTextStyle(
                    size: 18,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w600,
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.selectedContColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${syllabus?.totalWeeks ?? 0} weeks Total",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.all(12),
                children: _buildMonthSections(weekList!),
              ),
              bottomNavigationBar: _bottomActionSection(),
            ),
    );
  }

  List<Widget> _buildMonthSections(List<WeeklyData> weeks) {
    List<Widget> widgets = [];

    int month = 1;
    int count = 0;

    for (int i = 0; i < weeks.length; i++) {
      if (count == 0) {
        widgets.add(_monthTitle("Month $month"));
      }

      widgets.add(
        _weekTile(
          weekData: weeks[i],
          weekNumber: weeks[i].week ?? 0,
          title:
              weeks[i].days?.first.topics?.first.title ??
              "Week ${weeks[i].week}",
          status: getWeekStatus(weeks[i].week ?? 0),
        ),
      );

      count++;

      if (count == 4) {
        month++;
        count = 0;
      }
    }

    return widgets;
  }

  Widget _monthTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Text(
        title,
        style: AppStyles.customTextStyle(
          size: 14,
          color: AppColors.secondaryColor,
          weight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _weekTile({
    required WeeklyData weekData,
    required int weekNumber,
    required String title,
    required String status,
  }) {
    bool isCompleted = status == "Completed";

    bool canOpen = weekNumber <= lastCompletedWeek + 1;

    bool isFuture = !canOpen;

    return GestureDetector(
      onTap: !isFuture
          ? () async {
              var result = await AppFunctions.navigateFutureScreen(
                context,
                AppRoutes.syllabusViewScreen,
                arguments: {
                  "weekData": weekData,
                  "weeklyStatus": status,
                  "weekNumber": weekNumber,
                },
              );
              if (result ?? false) {
                await getInitialData();
              }
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.contColor2,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.contBorderColor2),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isFuture
                    ? AppColors.contBorderColor2
                    : AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text(
                      "$weekNumber",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w700,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Week $weekNumber: $title",
                style: AppStyles.customTextStyle(
                  lineSpace: 1.3,
                  size: 12,
                  color: isFuture
                      ? AppColors.lightTextColor
                      : AppColors.whiteColor,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomActionSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          _projectSubmissionCard(),
          CustomButtonWidget(
            isLoading: internController.getMcqQuestionLoading,
            buttonFunction: () async {
              //await generateMcqQuestions();
              AppFunctions.showAppAlert(
                context: context,
                title: "Mock Test Instructions",
                content:
                    "This mock test contains 15 questions.\n\n"
                    "Each question has 30 seconds.\n"
                    "Total test duration is 7 minutes 30 seconds.\n\n"
                    "Please feel free to attend the test.\n"
                    "Once the time is up, your answers will be automatically submitted.",
                cancelText: "Do it later",
                confirmText: "Attend Now",
                onConfirm: () async {
                  await generateMcqQuestions();
                },
              );
            },
            buttonText: "Attend Mock Test",
            disable: !canAttendMockTest,
            height: 45,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _projectSubmissionCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Project Submission",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w300,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.disableContBorder),
                  color: AppColors.disableContColor,
                ),
                padding: EdgeInsets.all(5),
                child: isProjectSubmitted
                    ? Text(
                        "Submitted!",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          color: AppColors.primaryColor,
                          weight: FontWeight.w300,
                        ),
                      )
                    : Text(
                        "Not Submitted!",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          color: AppColors.lightTextColor,
                          weight: FontWeight.w300,
                        ),
                      ),
              ),
            ],
          ),
          CustomTextField(
            prefixWidget: Icon(
              Icons.assignment_outlined,
              color: AppColors.primaryColor,
            ),
            controller: projectController,
            isEnabled: canSubmitProject,
            hintText: "Paste your project url here..",
            onChanged: (value) {
              projectController.text = value;
            },
          ),
          const SizedBox(height: 10),
          CustomButtonWidget(
            height: 35,
            isLoading: internController.weeklyUpdateLoading,
            buttonFunction: () async {
              await submitProject();
            },
            buttonText: "Submit URL",
            disable: !canSubmitProject,
          ),
        ],
      ),
    );
  }

  Future<void> generateMcqQuestions() async {
    await internController.getMcqQuestions(
      weekData: internController.syllabusModel.syllabusData!.data ?? [],
    );
    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message: "Successfully generate your MCQ test questions!",
      );
      AppFunctions.navigateScreen(
        context,
        AppRoutes.mcqTestScreen,
        arguments: {"mockTestModel": internController.mcqQuesModel},
      );
    }
  }

  Future<void> submitProject() async {
    Map<String, dynamic> projectData = {
      "studentId": internController.syllabusModel.syllabusData!.student ?? "",
      "jobId": internController.syllabusModel.syllabusData!.job ?? "",
      "internProjectlink": projectController.text,
    };
    await internController.updateInternWeeklyStatus(weeklyData: projectData);
    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      await getInitialData();
      AppFunctions.showToast(
        message:
            internController.weeklyUpdateModel.message ??
            "Your Project Submitted Successfully!",
      );
    }
  }

  String getWeekStatus(int weekNumber) {
    return progressMap[weekNumber]?.status ?? "";
  }
}
