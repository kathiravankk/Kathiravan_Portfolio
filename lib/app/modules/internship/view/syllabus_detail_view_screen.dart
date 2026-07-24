import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/code_example_widget.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/models/internship/intern_syllabus_response_model.dart';
import 'package:internsharks/app/modules/internship/controller/internship_controller.dart';
import 'package:url_launcher/url_launcher.dart';

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

  /// true  → view-only (already completed)
  /// false → show Mark as Complete
  bool isDayCompleted = false;

  // ── Derived ──────────────────────────────
  DayDetail? _dayDetail;

  // ── Project submission ────────────────────
  final TextEditingController projectController = TextEditingController();

  bool get _hasProject => (_dayDetail?.projectSchedule ?? []).isNotEmpty;

  bool get _isUrlValid {
    final url = projectController.text.trim();
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
  }

  /// Mark as Complete only enabled when:
  ///  • no project  → always enabled
  ///  • has project → only when URL field contains a valid http/https URL
  bool get _canMarkComplete => !_hasProject || _isUrlValid;

  @override
  void initState() {
    super.initState();
    dayData = Get.arguments["dayData"];
    weekData = Get.arguments["weekData"];
    weekNumber = Get.arguments["weekNumber"] ?? 0;
    dayNumber = Get.arguments["dayNumber"] ?? 0;
    isDayCompleted = Get.arguments["isDayCompleted"] ?? false;
    _dayDetail = dayData?.dayList?.first;
  }

  @override
  void dispose() {
    projectController.dispose();
    super.dispose();
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
        "drivelink": projectController.text.trim(),
      },
    );

    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
        internController.weeklyUpdateModel.message ??
            "Day $dayNumber Completed Successfully!",
      );
      Get.back(result: true);
    }
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_dayDetail == null) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.appBackgroundImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: AppColors.transparentColor,
          appBar: AppBar(
            backgroundColor: AppColors.transparentColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 25,
                  color: AppColors.whiteColor),
              onPressed: () => Get.back(),
            ),
          ),
          body: const Center(
            child: Text("No content available.",
                style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    final topics = _dayDetail!.topics ?? [];
    final projectSchedule = _dayDetail!.projectSchedule ?? [];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25,
                color: AppColors.whiteColor),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Day - ${_dayDetail!.day}",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
          actions: [
            if (isDayCompleted)
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.completedColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.whiteColor, size: 14),
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ...topics.map((t) => _topicSection(t)),
                      const SizedBox(height: 15),
                      if (projectSchedule.isNotEmpty)
                        ...projectSchedule.map((p) => _projectTaskCard(p)),
                      // Submission card — only for incomplete days with a project
                      if (projectSchedule.isNotEmpty && !isDayCompleted) ...[
                        const SizedBox(height: 8),
                        _projectSubmissionCard(),
                      ],
                      const SizedBox(height: 30),
                    ],
                  ),
                ),

                // Mark as Complete button
                if (!isDayCompleted) ...[
                  const SizedBox(height: 10),
                  Obx(() => CustomButtonWidget(
                    isLoading: internController.weeklyUpdateLoading,
                    height: 44,
                    disable: !_canMarkComplete,
                    buttonFunction:
                    _canMarkComplete ? _markDayComplete : () {},
                    buttonText: "Mark as Complete",
                  )),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // PROJECT SUBMISSION CARD
  // ─────────────────────────────────────────

  Widget _projectSubmissionCard() {
    final bool hasText = projectController.text.trim().isNotEmpty;
    final bool urlError = hasText && !_isUrlValid;

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
          // ── Header ──────────────────────────
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
              // Copy button (visible only when URL is filled)
              if (hasText)
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(text: projectController.text.trim()),
                    );
                    AppAlertUtils.showToast(
                      message: "Project URL copied!",
                      isError: false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.disableContColor,
                      borderRadius: BorderRadius.circular(6),
                      border:
                      Border.all(color: AppColors.disableContBorder),
                    ),
                    child: const Icon(Icons.copy_rounded,
                        size: 16, color: AppColors.whiteColor),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 15),

          // ── URL field ────────────────────────
          CustomTextField(
            maxLines: 2,
            isNumberKeyboard: false,
            prefixWidget: const Icon(
              Icons.assignment_outlined,
              color: AppColors.primaryColor,
            ),
            controller: projectController,
            isEnabled: true,
            hintText: "Paste your GitHub / Drive / Live URL here..",
            onChanged: (_) => setState(() {}),
            suffixWidget: hasText
                ? GestureDetector(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: projectController.text.trim()),
                );
                AppAlertUtils.showToast(
                  message: "Copied successfully!",
                  isError: false,
                );
              },
              child: const Icon(Icons.copy,
                  size: 20, color: AppColors.primaryColor),
            )
                : null,
          ),

          // ── Validation error ─────────────────
          if (urlError) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      size: 13, color: AppColors.failTextColor),
                  const SizedBox(width: 5),
                  Text(
                    "Please enter a valid URL (https://...)",
                    style: AppStyles.customTextStyle(
                      size: 11,
                      color: AppColors.failTextColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
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
            const Icon(Icons.edit_document,
                color: AppColors.primaryColor, size: 15),
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
        if ((topic.youtubeUrl ?? "").isNotEmpty) ...[
          const SizedBox(height: 10),
          youtubeButton(topic.youtubeUrl!),
        ],
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
                  const Icon(Icons.check_circle_outline,
                      color: AppColors.primaryColor, size: 18),
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
  Widget youtubeButton(String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.tryParse(url);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.disableContColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.disableContBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_circle_outline,
                size: 16, color: AppColors.primaryColor),
            const SizedBox(width: 6),
            Text(
              "Watch Video",
              style: AppStyles.customTextStyle(
                size: 12,
                lineSpace: 1.5,
                color: AppColors.primaryColor,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
              const Icon(Icons.assignment_outlined,
                  color: AppColors.primaryColor, size: 18),
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