import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/code_example_widget.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/internship/intern_syllabus_response_model.dart';
import 'package:internsharks/app/modules/home/controller/internship_controller.dart';

class SyllabusDetailViewScreen extends StatefulWidget {
  const SyllabusDetailViewScreen({super.key});

  @override
  State<SyllabusDetailViewScreen> createState() =>
      _SyllabusDetailViewScreenState();
}

class _SyllabusDetailViewScreenState extends State<SyllabusDetailViewScreen> {
  final InternshipController internController =
      Get.find<InternshipController>();

  // ── Arguments ────────────────────────────
  DayData? dayData;
  WeekData? weekData;
  int? weekNumber;
  int? dayNumber;

  /// true  → opened from a completed day (view-only, no Mark as Complete)
  /// false → day not yet completed, show Mark as Complete
  bool isDayCompleted = false;

  // ── Derived ──────────────────────────────
  DayDetail? _dayDetail;

  @override
  void initState() {
    super.initState();
    dayData = Get.arguments["dayData"];
    weekData = Get.arguments["weekData"];
    weekNumber = Get.arguments["weekNumber"] ?? 0;
    dayNumber = Get.arguments["dayNumber"] ?? 0;
    isDayCompleted = Get.arguments["isDayCompleted"] ?? false;

    // DayData.dayList is the correct property per the model
    _dayDetail = dayData?.dayList?.first;
  }

  // ─────────────────────────────────────────
  // MARK DAY COMPLETE
  // ─────────────────────────────────────────

  Future<void> _markDayComplete() async {
    await internController.updateInternDailyStatus(
      weeklyData: {
        "studentId":
            internController.syllabusModel.syllabusViewData?.student ?? "",
        "jobId": internController.syllabusModel.syllabusViewData?.job ?? "",
        "dayNumber": dayNumber,
      },
    );

    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message:
            internController.weeklyUpdateModel.message ??
            "Day $dayNumber Completed Successfully!",
      );
      // Pass true so the list screen knows to refresh
      Get.back(result: true);
    }
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_dayDetail == null) {
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
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(
          child: Text(
            "No content available.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final topics = _dayDetail!.topics ?? [];
    final projectSchedule = _dayDetail!.projectSchedule ?? [];

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
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        title: Text(
          "Day - ${_dayDetail!.day}",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.secondaryColor,
            weight: FontWeight.w600,
          ),
        ),
        // Show "Completed" badge in the AppBar when already done
        actions: [
          if (isDayCompleted)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.completedColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.whiteColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Completed",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // ── Scrollable content ──────────────
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ...topics.map((topic) => _topicSection(topic)),
                    const SizedBox(height: 15),
                    if (projectSchedule.isNotEmpty)
                      ...projectSchedule.map((p) => _projectTaskCard(p)),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // ── Mark Complete button  ───────────
              // Hidden entirely when day is already completed
              if (!isDayCompleted) ...[
                const SizedBox(height: 10),
                Obx(
                  () => CustomButtonWidget(
                    isLoading: internController.weeklyUpdateLoading,
                    height: 44,
                    buttonFunction: _markDayComplete,
                    buttonText: "Mark as Complete",
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // TOPIC SECTION
  // ─────────────────────────────────────────

  Widget _topicSection(TopicData topic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          topic.title ?? "",
          style: AppStyles.customTextStyle(
            size: 16,
            lineSpace: 1.3,
            color: AppColors.whiteColor,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          topic.explanation ?? "",
          style: AppStyles.customTextStyle(
            size: 12,
            lineSpace: 1.3,
            color: AppColors.lightText,
            weight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Icon(
              Icons.edit_document,
              color: AppColors.primaryColor,
              size: 15,
            ),
            const SizedBox(width: 8),
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
        const SizedBox(height: 10),
        if (topic.codeExamples != null)
          ...topic.codeExamples!.map((code) => CodeExampleWidget(code: code)),
        const SizedBox(height: 10),
        if (topic.homework != null && topic.homework!.isNotEmpty)
          _homeworkCard(topic.homework!),
        const SizedBox(height: 10),
      ],
    );
  }

  // ─────────────────────────────────────────
  // HOMEWORK CARD
  // ─────────────────────────────────────────

  Widget _homeworkCard(List<String> items) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.contColor3,
        border: Border.all(color: AppColors.contBorderColor3),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
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
          const SizedBox(height: 8),
          ...items.map(
            (hw) => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
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
    );
  }

  // ─────────────────────────────────────────
  // PROJECT TASK CARD
  // ─────────────────────────────────────────

  Widget _projectTaskCard(ProjectSchedule project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.disableFieldColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.disableBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: AppColors.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 6),
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
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
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
          const SizedBox(height: 6),
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
