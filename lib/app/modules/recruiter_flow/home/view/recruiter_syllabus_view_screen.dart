import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import '../../../../data/models/recruiter_flow/syllabus_view_data_model.dart'
    show ScheduleGroup, SyllabusViewData;

class RecruiterSyllabusViewScreen extends StatefulWidget {
  const RecruiterSyllabusViewScreen({super.key});

  @override
  State<RecruiterSyllabusViewScreen> createState() =>
      _RecruiterSyllabusViewScreenState();
}

class _RecruiterSyllabusViewScreenState
    extends State<RecruiterSyllabusViewScreen> {
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();

  SyllabusViewData? _syllabus;
  bool _isMonthBased = false;

  // Top level groups: Month groups (month-based) or Day groups (day-based)
  List<ScheduleGroup> _groups = [];

  // Track which week tiles are expanded ("monthIndex-weekIndex" -> expanded)
  final Set<String> _expandedWeeks = {};

  String studentId = "";
  String jobId = "";

  // ─────────────────────────────────────────
  // INIT
  // ─────────────────────────────────────────

  @override
  void initState() {
    studentId = Get.arguments?["studentId"] ?? "";
    jobId = Get.arguments?["jobId"] ?? "";
    super.initState();
    getSyllabusData();
  }

  Future<void> getSyllabusData() async {
    try {
      await homeController.getSyllabus(studentId: studentId, jobId: jobId);

      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        setState(() {
          _syllabus = homeController.syllabusModel.syllabus;

          if (_syllabus != null) {
            _isMonthBased =
                _syllabus!.month.isNotEmpty && _syllabus!.days.isEmpty;
            _groups = _isMonthBased ? _syllabus!.month : _syllabus!.days;
          }

          // Open the first week by default so the list isn't empty on load.
          if (_isMonthBased && _groups.isNotEmpty) {
            _expandedWeeks.add("0-0");
          }
        });
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error, stackTrace) {
      // Keep this — silent parse failures are exactly what caused the
      // "200 OK but empty screen" symptom last time.
      debugPrint("Syllabus parse/fetch error: $error");
      debugPrintStack(stackTrace: stackTrace);
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Obx(
        () => homeController.syllabusLoading
            ? AppAlertUtils.customLoader()
            : Scaffold(
                backgroundColor: AppColors.transparentColor,
                appBar: _buildAppBar(),
                body: _syllabus == null || _groups.isEmpty
                    ? const CustomEmptyWidget()
                    : ListView(
                        padding: const EdgeInsets.all(20),
                        children: _isMonthBased
                            ? _buildMonthSections()
                            : _buildDaySections(),
                      ),
              ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // APP BAR — same shell as InternshipSyllabusScreen, plus "Edit with AI"
  // ─────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    final totalLabel = _isMonthBased
        ? "${_syllabus?.totalMonth ?? _groups.length} months Total"
        : "${_syllabus?.totalDays ?? _groups.length} days Total";

    return AppBar(
      backgroundColor: AppColors.transparentColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
          color: AppColors.whiteColor,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        _syllabus?.subject ?? "Syllabus",
        maxLines: 2,
        style: AppStyles.customTextStyle(
          size: 18,
          lineSpace: 1.5,
          color: AppColors.secondaryColor,
          weight: FontWeight.w600,
        ),
      ),
      actions: [
        if (_syllabus != null && _syllabus!.status != "completed")
          GestureDetector(
            onTap: () {
              AppFunctions.navigateScreen(
                context,
                AppRoutes.chatSyllabusUpdateScreen,
                arguments: {
                  "syllabusData": _syllabus,
                  "studentId": studentId,
                  "jobId": jobId,
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  const Icon(
                    CupertinoIcons.sparkles,
                    color: AppColors.primaryColor,
                    size: 15,
                  ),
                  Text(
                    "Edit with AI",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Container(
        //   margin: const EdgeInsets.only(right: 12),
        //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        //   decoration: BoxDecoration(
        //     color: AppColors.selectedContColor,
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: Text(
        //     totalLabel,
        //     style: AppStyles.customTextStyle(
        //       size: 14,
        //       color: AppColors.whiteColor,
        //       weight: FontWeight.w400,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // MONTH-BASED UI — Month header + expandable week tiles + day cards
  // ─────────────────────────────────────────

  List<Widget> _buildMonthSections() {
    final widgets = <Widget>[];

    for (int mIndex = 0; mIndex < _groups.length; mIndex++) {
      final month = _groups[mIndex];
      widgets.add(_sectionTitle(month.title ?? "Month ${mIndex + 1}"));

      final weeks = month.children;
      for (int wIndex = 0; wIndex < weeks.length; wIndex++) {
        final week = weeks[wIndex];
        final weekPath = "$mIndex-$wIndex";
        final weekTitle = week.title ?? "Week ${wIndex + 1}";

        widgets.add(
          _expandableWeekTile(
            week: week,
            weekNumber: wIndex + 1,
            weekTitle: weekTitle,
            path: weekPath,
          ),
        );
      }
    }
    return widgets;
  }

  Widget _expandableWeekTile({
    required ScheduleGroup week,
    required int weekNumber,
    required String weekTitle,
    required String path,
  }) {
    final isExpanded = _expandedWeeks.contains(path);
    final days = week.children;

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
            onTap: () => setState(() {
              isExpanded
                  ? _expandedWeeks.remove(path)
                  : _expandedWeeks.add(path);
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  _circleIndicator(label: "$weekNumber"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Week $weekNumber: $weekTitle",
                      style: AppStyles.customTextStyle(
                        lineSpace: 1.3,
                        size: 12,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
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
          if (isExpanded) ...[
            Divider(color: AppColors.contBorderColor2, height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                children: List.generate(
                  days.length,
                  (dIndex) => _dayCardInWeek(
                    day: days[dIndex],
                    weekNumber: weekNumber,
                    dayNumber: dIndex + 1,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dayCardInWeek({
    required ScheduleGroup day,
    required int weekNumber,
    required int dayNumber,
  }) {
    final topicTitle = _leafTitle(day) ?? "Day $dayNumber";

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
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.contBorderColor2,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$dayNumber",
              style: AppStyles.customTextStyle(
                size: 12,
                color: AppColors.lightTextColor,
                weight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
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
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _viewButton(
            onTap: () => _openDetail(
              day: day,
              dayNumber: dayNumber,
              weekNumber: weekNumber,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // DAY-BASED UI — flat day list, same card style as
  // InternshipSyllabusScreen's _flatDayTile
  // ─────────────────────────────────────────

  List<Widget> _buildDaySections() {
    return List.generate(_groups.length, (i) {
      final day = _groups[i];
      final title = _leafTitle(day) ?? "Day ${i + 1}";
      return _flatDayTile(day: day, dayNumber: i + 1, title: title);
    });
  }

  Widget _flatDayTile({
    required ScheduleGroup day,
    required int dayNumber,
    required String title,
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
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _viewButton(
            onTap: () => _openDetail(day: day, dayNumber: dayNumber),
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

  Widget _circleIndicator({required String label}) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppStyles.customTextStyle(
          size: 14,
          color: AppColors.whiteColor,
          weight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _viewButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "View",
          style: AppStyles.customTextStyle(
            size: 10,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Pulls the first topic title out of a leaf day group's data, so day
  /// cards show something meaningful instead of just "Day N".
  String? _leafTitle(ScheduleGroup day) {
    if (day.data.isEmpty) return day.title;
    final firstData = day.data.first;
    if (firstData.topics.isNotEmpty) {
      return firstData.topics.first.title ?? day.title;
    }
    return day.title;
  }

  void _openDetail({
    required ScheduleGroup day,
    required int dayNumber,
    int? weekNumber,
  }) {
    AppFunctions.navigateScreen(
      context,
      AppRoutes.recruiterSyllabusDetailScreen,
      arguments: {
        "dayData": day,
        "dayNumber": dayNumber,
        "weekNumber": weekNumber,
        "isMonthBased": _isMonthBased,
      },
    );
  }
}
