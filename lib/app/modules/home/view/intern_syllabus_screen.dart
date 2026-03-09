import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
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

  String jobId = "";
  int currentWeek = 1;
  SyllabusData? syllabus;
  List<WeeklyData>? weekList = [];
  List<WeeklyProgressData>? progressList = [];

  @override
  void initState() {
    jobId = Get.arguments["jobId"] ?? "";
    getInitialData();
    super.initState();
  }

  Future<void> getInitialData() async {
    await internController.getSyllabusData(jobId: jobId);
    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      syllabus = internController.syllabusModel.syllabusData;
      weekList = syllabus?.data ?? [];
      currentWeek = internController.syllabusModel.currentWeek ?? 1;
      progressList = internController.syllabusModel.weeklyProgressList ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => internController.syllabusDataLoading
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
    int currentWeek = internController.syllabusModel.currentWeek ?? 1;

    bool isCompleted = status == "Completed";

    bool isFuture = weekNumber > currentWeek;

    return GestureDetector(
      onTap: !isFuture
          ? () {
              AppFunctions.navigateScreen(
                context,
                AppRoutes.syllabusViewScreen,
                arguments: {"weekData": weekData},
              );
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

  String getWeekStatus(int weekNumber) {
    try {
      final progress = progressList!.firstWhere(
        (p) => p.weekNumber == weekNumber,
      );

      return progress.status ?? "";
    } catch (e) {
      return "";
    }
  }
}
