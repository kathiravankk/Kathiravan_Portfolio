import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/models/internship/intern_syllabus_response_model.dart';
import 'package:internsharks/app/modules/home/controller/internship_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class InternshipSyllabusScreen extends StatefulWidget {
  const InternshipSyllabusScreen({super.key});

  @override
  State<InternshipSyllabusScreen> createState() =>
      _InternshipSyllabusScreenState();
}

class _InternshipSyllabusScreenState extends State<InternshipSyllabusScreen> {
  final InternshipController internController =
      Get.find<InternshipController>();

  final TextEditingController projectController = TextEditingController();

  String jobId = "";
  String studentId = "";

  SyllabusViewData? syllabus;

  // ── Month-based ──────────────────────────
  List<MonthData> monthList = [];
  Map<int, WeeklyProgressListData> progressMap = {};

  // Track which week tiles are expanded (weekCounter → expanded)
  final Map<int, bool> _expandedWeeks = {};

  // ── Day-based ────────────────────────────
  List<DayData> dayList = [];

  // ── Shared ───────────────────────────────
  List<WeeklyProgressListData> progressList = [];

  /// dayNumber → "Completed" / ""  — built from dailyProgress in status API
  Map<int, String> dayProgressMap = {};

  bool isProjectSubmitted = false;

  // ─────────────────────────────────────────
  // INIT
  // ─────────────────────────────────────────

  @override
  void initState() {
    jobId = Get.arguments["jobId"] ?? "";
    studentId = Get.arguments["studentId"] ?? "";
    getStatusData();
    getInitialData();
    super.initState();
  }

  // ─────────────────────────────────────────
  // DATA FETCHING
  // ─────────────────────────────────────────

  Future<void> getStatusData() async {
    await internController.getInternStatus(jobId: jobId, studentId: studentId);

    if (internController.getResponseCode() == 200) {
      final statusData = internController.internStatusModel.application;

      // Project link
      final links = statusData?.internProjectLink ?? [];
      isProjectSubmitted = links.isNotEmpty;
      projectController.text = links.isNotEmpty ? (links.first ?? "") : "";

      // Build dayProgressMap from dailyProgress list
      dayProgressMap.clear();
      for (final progress in statusData?.dailyProgress ?? []) {
        if (progress.dayNumber != null) {
          dayProgressMap[progress.dayNumber!] = progress.status ?? "";
        }
      }

      setState(() {});
    }
  }

  Future<void> getInitialData() async {
    await internController.getSyllabusData(jobId: jobId);

    final code = internController.getResponseCode();
    if (code == 200 || code == 201) {
      syllabus = internController.syllabusModel.syllabusViewData;
      progressList = internController.syllabusModel.weeklyProgressList ?? [];

      if (syllabus?.isMonthBased == true) {
        monthList = syllabus!.monthData!;
        progressMap = {for (var p in progressList) p.weekNumber ?? 0: p};
      } else {
        dayList = syllabus?.daysData ?? [];
      }

      setState(() {});
    }
  }

  // ─────────────────────────────────────────
  // LOCK / UNLOCK HELPERS
  // ─────────────────────────────────────────

  /// Ordered list of day-numbers belonging to a WeekData
  List<int> _dayNumbersForWeek(WeekData week) {
    return (week.daysList ?? [])
        .map((d) => d.dayList?.first.day ?? 0)
        .where((d) => d > 0)
        .toList();
  }

  /// True only when every day in the week is Completed
  bool _isWeekFullyCompleted(List<int> weekDayNumbers) {
    if (weekDayNumbers.isEmpty) return false;
    return weekDayNumbers.every((d) => dayProgressMap[d] == "Completed");
  }

  /// Sequential (1-based) index of the last week that is fully completed.
  int get _lastCompletedWeekIndex {
    int last = 0;
    int weekCounter = 1;
    for (final month in monthList) {
      for (final week in month.data ?? []) {
        if (_isWeekFullyCompleted(_dayNumbersForWeek(week))) {
          last = weekCounter;
        }
        weekCounter++;
      }
    }
    return last;
  }

  /// Sequential (1-based) index of a WeekData object
  int _weekIndexOf(WeekData week) {
    int index = 1;
    for (final month in monthList) {
      for (final w in month.data ?? []) {
        if (w == week) return index;
        index++;
      }
    }
    return index;
  }

  // ─────────────────────────────────────────
  // STATUS HELPERS
  // ─────────────────────────────────────────

  String _getDayStatus(int dayNum) => dayProgressMap[dayNum] ?? "";

  String _getDayStatusInWeek(DayData dayData) {
    final dayNum = dayData.dayList?.first.day ?? 0;
    return dayProgressMap[dayNum] ?? "";
  }

  // ─────────────────────────────────────────
  // COMPUTED GETTERS
  // ─────────────────────────────────────────

  bool get areAllWeeksCompleted {
    if (monthList.isEmpty) return false;
    final allWeeks = monthList.expand((m) => m.data ?? []).toList();
    if (allWeeks.isEmpty) return false;
    return allWeeks.every((w) => _isWeekFullyCompleted(_dayNumbersForWeek(w)));
  }

  bool get areAllDaysCompleted {
    if (dayList.isEmpty) return false;
    return dayList.every((d) {
      final dayNum = d.dayList?.first.day ?? 0;
      return dayProgressMap[dayNum] == "Completed";
    });
  }

  bool get canSubmitProject {
    if (syllabus?.isMonthBased == true) {
      return areAllWeeksCompleted && !isProjectSubmitted;
    }
    return areAllDaysCompleted && !isProjectSubmitted;
  }

  bool get canAttendMockTest =>
      isProjectSubmitted &&
      !(internController.internStatusModel.isTestTaken ?? false);

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

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
              appBar: _buildAppBar(),
              body: ListView(
                padding: const EdgeInsets.all(12),
                children: syllabus?.isMonthBased == true
                    ? _buildMonthSections()
                    : _buildDaySections(),
              ),
              bottomNavigationBar: _bottomActionSection(),
            ),
    );
  }

  AppBar _buildAppBar() {
    final totalLabel = syllabus?.isMonthBased == true
        ? "${syllabus?.totalMonth ?? 0} months Total"
        : "${syllabus?.totalDays ?? 0} days Total";

    return AppBar(
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.selectedContColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            totalLabel,
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.whiteColor,
              weight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // MONTH-BASED UI  ── expandable week cards
  // ─────────────────────────────────────────

  List<Widget> _buildMonthSections() {
    final widgets = <Widget>[];
    int weekCounter = 1;
    final completedWeekIndex = _lastCompletedWeekIndex;

    for (final month in monthList) {
      widgets.add(_sectionTitle(month.title ?? ""));

      for (final week in month.data ?? []) {
        final dayNums = _dayNumbersForWeek(week);
        final isWeekCompleted = _isWeekFullyCompleted(dayNums);

        // Week 1 always unlocked.
        // Week N unlocked only after week N-1 is fully completed.
        final canOpen =
            weekCounter == 1 || weekCounter <= completedWeekIndex + 1;

        final firstTopic =
            week.daysList?.first.dayList?.first.topics?.first.title ??
            week.title ??
            "";

        widgets.add(
          _expandableWeekTile(
            weekData: week,
            weekNumber: weekCounter,
            title: firstTopic,
            isWeekCompleted: isWeekCompleted,
            canOpen: canOpen,
          ),
        );
        weekCounter++;
      }
    }
    return widgets;
  }

  Widget _expandableWeekTile({
    required WeekData weekData,
    required int weekNumber,
    required String title,
    required bool isWeekCompleted,
    required bool canOpen,
  }) {
    final isFuture = !canOpen;
    final isExpanded = _expandedWeeks[weekNumber] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      child: Column(
        children: [
          // ── Week header ───────────────────────
          GestureDetector(
            onTap: isFuture
                ? null
                : () =>
                      setState(() => _expandedWeeks[weekNumber] = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  _circleIndicator(
                    label: "$weekNumber",
                    isCompleted: isWeekCompleted,
                    isFuture: isFuture,
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
                  if (isFuture)
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.lightTextColor,
                      size: 16,
                    )
                  else
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.lightTextColor,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),

          // ── Expanded day cards ────────────────
          if (!isFuture && isExpanded) ...[
            Divider(color: AppColors.contBorderColor2, height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(children: _buildDayCardsForWeek(weekData)),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds individual day cards inside an expanded week tile.
  /// Day 1 of the week is always unlocked (week itself is already unlocked).
  /// Day N unlocks only after day N-1 is Completed.
  List<Widget> _buildDayCardsForWeek(WeekData weekData) {
    final days = weekData.daysList ?? [];
    final List<Widget> cards = [];

    for (int i = 0; i < days.length; i++) {
      final dayData = days[i];
      final dayDetail = dayData.dayList?.first;
      final dayNumber = dayDetail?.day ?? 0;
      final isDayCompleted = _getDayStatusInWeek(dayData) == "Completed";
      final dayTopicTitle =
          dayDetail?.topics?.first.title ?? dayData.title ?? "Day $dayNumber";

      // First day always unlocked when week is open.
      // Subsequent days unlock only when the previous day is completed.
      final bool isDayLocked;
      if (i == 0) {
        isDayLocked = false;
      } else {
        final prevDayNum = days[i - 1].dayList?.first.day ?? 0;
        isDayLocked = dayProgressMap[prevDayNum] != "Completed";
      }

      cards.add(
        _dayCardInWeek(
          dayData: dayData,
          weekData: weekData,
          weekNumber: _weekIndexOf(weekData),
          dayNumber: dayNumber,
          topicTitle: dayTopicTitle,
          isDayCompleted: isDayCompleted,
          isDayLocked: isDayLocked,
        ),
      );
    }
    return cards;
  }

  Widget _dayCardInWeek({
    required DayData dayData,
    required WeekData weekData,
    required int weekNumber,
    required int dayNumber,
    required String topicTitle,
    required bool isDayCompleted,
    required bool isDayLocked,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.appBgColor_2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      child: Row(
        children: [
          // Circle indicator
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDayCompleted
                  ? AppColors.primaryColor
                  : isDayLocked
                  ? AppColors.contBorderColor2.withOpacity(0.5)
                  : AppColors.contBorderColor2,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: isDayCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : isDayLocked
                ? const Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: AppColors.lightTextColor,
                  )
                : Text(
                    "$dayNumber",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.lightTextColor,
                      weight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: 10),

          // Day label + topic title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DAY $dayNumber",
                  style: AppStyles.customTextStyle(
                    size: 9,
                    color: AppColors.lightTextColor,
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  topicTitle,
                  style: AppStyles.customTextStyle(
                    lineSpace: 1.3,
                    size: 11,
                    color: isDayLocked
                        ? AppColors.lightTextColor
                        : AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Action — locked shows nothing tappable
          if (!isDayLocked)
            GestureDetector(
              onTap: () async {
                final result = await AppFunctions.navigateFutureScreen(
                  context,
                  AppRoutes.syllabusViewScreen,
                  arguments: {
                    "dayData": dayData,
                    "weekData": weekData,
                    "weekNumber": weekNumber,
                    "dayNumber": dayNumber,
                    "isDayCompleted": isDayCompleted,
                  },
                );
                if (result ?? false) {
                  // Refresh status so lock states update immediately
                  await getStatusData();
                  setState(() {});
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDayCompleted
                      ? AppColors.completedColor
                      : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isDayCompleted ? "Completed" : "Get Started",
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // DAY-BASED UI  (flat day list – new_22)
  // ─────────────────────────────────────────

  List<Widget> _buildDaySections() {
    final widgets = <Widget>[];

    for (int i = 0; i < dayList.length; i++) {
      final dayData = dayList[i];
      final dayDetail = dayData.dayList?.first;
      final dayNumber = dayDetail?.day ?? 0;
      final isDayCompleted = _getDayStatus(dayNumber) == "Completed";
      final firstTopicTitle =
          dayDetail?.topics?.first.title ?? dayData.title ?? "Day $dayNumber";

      // Day 1 always unlocked.
      // Day N unlocks only after day N-1 is Completed.
      final bool isDayLocked;
      if (i == 0) {
        isDayLocked = false;
      } else {
        final prevDayNum = dayList[i - 1].dayList?.first.day ?? 0;
        isDayLocked = dayProgressMap[prevDayNum] != "Completed";
      }

      widgets.add(
        _flatDayTile(
          dayData: dayData,
          dayNumber: dayNumber,
          title: firstTopicTitle,
          isDayCompleted: isDayCompleted,
          isDayLocked: isDayLocked,
        ),
      );
    }
    return widgets;
  }

  Widget _flatDayTile({
    required DayData dayData,
    required int dayNumber,
    required String title,
    required bool isDayCompleted,
    required bool isDayLocked,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DAY $dayNumber",
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: AppColors.lightTextColor,
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppStyles.customTextStyle(
                    lineSpace: 1.3,
                    size: 13,
                    color: isDayLocked
                        ? AppColors.lightTextColor
                        : AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          if (isDayLocked)
            const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.lightTextColor,
              size: 18,
            )
          else
            GestureDetector(
              onTap: () async {
                final result = await AppFunctions.navigateFutureScreen(
                  context,
                  AppRoutes.syllabusViewScreen,
                  arguments: {
                    "dayData": dayData,
                    "dayNumber": dayNumber,
                    "isDayCompleted": isDayCompleted,
                  },
                );
                if (result ?? false) {
                  await getStatusData();
                  setState(() {});
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDayCompleted
                      ? AppColors.completedColor
                      : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isDayCompleted ? "Completed" : "Get Started",
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // SHARED HELPERS
  // ─────────────────────────────────────────

  Widget _sectionTitle(String title) {
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

  Widget _circleIndicator({
    required String label,
    required bool isCompleted,
    required bool isFuture,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.primaryColor
            : isFuture
            ? AppColors.contBorderColor2
            : AppColors.primaryColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: isCompleted
          ? const Icon(Icons.check, size: 16, color: AppColors.whiteColor)
          : Text(
              label,
              style: AppStyles.customTextStyle(
                size: 14,
                color: isFuture
                    ? AppColors.lightTextColor
                    : AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
    );
  }

  // ─────────────────────────────────────────
  // BOTTOM SECTION
  // ─────────────────────────────────────────

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
              AppFunctions.showAppAlert(
                context: context,
                title: "Mock Test Instructions",
                content:
                    "This mock test contains 15 questions.\n\n"
                    "Total test duration is 7 minutes 30 seconds.\n\n"
                    "Please feel free to attend the test.\n"
                    "Once the time is up, your answers will be automatically submitted.",
                cancelText: "Do it later",
                confirmText: "Attend Now",
                onConfirm: () async {
                  await _generateMcqQuestions();
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
                padding: const EdgeInsets.all(5),
                child: Text(
                  isProjectSubmitted ? "Submitted!" : "Not Submitted!",
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: isProjectSubmitted
                        ? AppColors.primaryColor
                        : AppColors.lightTextColor,
                    weight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          CustomTextField(
            prefixWidget: const Icon(
              Icons.assignment_outlined,
              color: AppColors.primaryColor,
            ),
            controller: projectController,
            isEnabled: canSubmitProject,
            hintText: "Paste your project url here..",
            onChanged: (value) => projectController.text = value,
          ),
          const SizedBox(height: 10),
          CustomButtonWidget(
            height: 35,
            isLoading: internController.weeklyUpdateLoading,
            buttonFunction: () async => await _submitProject(),
            buttonText: "Submit URL",
            disable: !canSubmitProject,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // ACTIONS
  // ─────────────────────────────────────────

  Future<void> _generateMcqQuestions() async {
    // final allWeekData = syllabus?.isMonthBased == true
    //     ? monthList.expand((m) => m.data ?? []).toList()
    //     : <WeekData>[];
    // await internController.getMcqQuestions(
    //    weekData: internController.syllabusModel.syllabusViewData!.days ?? [],);
    await internController.getMcqQuestions(
      weekData: internController.syllabusModel.syllabusViewData!.isMonthBased
          ? internController.syllabusModel.syllabusViewData!.monthData
          : internController.syllabusModel.syllabusViewData!.daysData,
    );
    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message: "Successfully generate your MCQ test questions!",
      );
      AppFunctions.navigateScreen(
        context,
        AppRoutes.mcqTestScreen,
        arguments: {
          "mockTestModel": internController.mcqQuesModel,
          "jobId": syllabus?.job,
          "studentId": syllabus?.student,
        },
      );
    }
  }

  Future<void> _submitProject() async {
    final projectData = {
      "studentId": syllabus?.student ?? "",
      "jobId": syllabus?.job ?? "",
      "internProjectlink": projectController.text,
    };
    await internController.updateInternDailyStatus(weeklyData: projectData);
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
}
