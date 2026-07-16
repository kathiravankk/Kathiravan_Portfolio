import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/code_example_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/models/recruiter_flow/syllabus_view_data_model.dart'
    show ScheduleGroup, Topic, ProjectSchedule;

/// Recruiter's full read-only view of a single day: topics, code examples,
/// homework and project tasks. Same visual language as [SyllabusDetailViewScreen]
/// (topic sections, homework card, project task card) but with no
/// "Mark as Complete" / submission UI, since the recruiter is only reviewing.
class RecruiterSyllabusDetailViewScreen extends StatefulWidget {
  const RecruiterSyllabusDetailViewScreen({super.key});

  @override
  State<RecruiterSyllabusDetailViewScreen> createState() =>
      _RecruiterSyllabusDetailViewScreenState();
}

class _RecruiterSyllabusDetailViewScreenState
    extends State<RecruiterSyllabusDetailViewScreen> {
  ScheduleGroup? dayData;
  int? dayNumber;
  int? weekNumber;
  bool isMonthBased = false;

  @override
  void initState() {
    super.initState();
    dayData = Get.arguments?["dayData"];
    dayNumber = Get.arguments?["dayNumber"];
    weekNumber = Get.arguments?["weekNumber"];
    isMonthBased = Get.arguments?["isMonthBased"] ?? false;
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final scheduleList = dayData?.data ?? [];
    final topics = scheduleList.expand((s) => s.topics).toList();
    final projectSchedule =
    scheduleList.expand((s) => s.projectSchedule).toList();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: _buildAppBar(),
        body: (topics.isEmpty && projectSchedule.isEmpty)
            ? const Center(
          child: Text(
            "No content available.",
            style: TextStyle(color: Colors.white),
          ),
        )
            : SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ...topics.map((t) => _topicSection(t)),
              const SizedBox(height: 15),
              ...projectSchedule.map((p) => _projectTaskCard(p)),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final title = isMonthBased && weekNumber != null
        ? "Week $weekNumber · Day ${dayNumber ?? ""}"
        : "Day - ${dayNumber ?? ""}";

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
        title,
        style: AppStyles.customTextStyle(
          size: 18,
          color: AppColors.secondaryColor,
          weight: FontWeight.w600,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // TOPIC SECTION — same layout as SyllabusDetailViewScreen
  // ─────────────────────────────────────────

  Widget _topicSection(Topic topic) {
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
        if ((topic.youtubeUrl ?? "").isNotEmpty) ...[
          const SizedBox(height: 12),
          _youtubeButton(topic.youtubeUrl!),
        ],
        if ((topic.visualExplanation ?? "").isNotEmpty) ...[
          const SizedBox(height: 14),
          _visualExplanationBox(topic.visualExplanation!),
        ],
        const SizedBox(height: 14),
        if (topic.codeExamples.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.edit_document,
                  color: AppColors.primaryColor, size: 15),
              const SizedBox(width: 8),
              Text(
                "Code Examples",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...topic.codeExamples.map((code) => CodeExampleWidget(code: code)),
          const SizedBox(height: 10),
        ],
        if (topic.homework.isNotEmpty) _homeworkCard(topic.homework),
        const SizedBox(height: 10),
      ],
    );
  }

  // ─────────────────────────────────────────
  // VISUAL EXPLANATION — matches RecruiterSyllabusViewScreen's card
  // ─────────────────────────────────────────

  Widget _visualExplanationBox(String rawText) {
    final items = _parseNumberedList(rawText);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.image_outlined,
                  size: 15, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                "VISUAL EXPLANATION",
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.primaryColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (items.length > 1)
            ...items.map(
                  (line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  line,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    lineSpace: 1.4,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            )
          else
            Text(
              rawText,
              style: AppStyles.customTextStyle(
                size: 12,
                lineSpace: 1.4,
                color: AppColors.primaryColor,
                weight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }

  List<String> _parseNumberedList(String text) {
    final matches = RegExp(r'(?=\d+\.\s)').allMatches(text).toList();
    if (matches.length < 2) return [text.trim()];

    final parts = <String>[];
    for (int i = 0; i < matches.length; i++) {
      final start = matches[i].start;
      final end = i + 1 < matches.length ? matches[i + 1].start : text.length;
      final chunk = text.substring(start, end).trim();
      if (chunk.isNotEmpty) parts.add(chunk);
    }
    return parts;
  }

  // ─────────────────────────────────────────
  // HOMEWORK CARD — same styling as SyllabusDetailViewScreen
  // ─────────────────────────────────────────

  Widget _homeworkCard(List<String> items) {
    return Container(
      width: double.infinity,
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

  // ─────────────────────────────────────────
  // PROJECT TASK CARD — same styling as both reference screens
  // ─────────────────────────────────────────

  Widget _projectTaskCard(ProjectSchedule project) {
    final label = isMonthBased
        ? "Project Task – Month ${project.month ?? ""}"
        : "Project Task – Day ${project.day ?? dayNumber ?? ""}";

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
              Expanded(
                child: Text(
                  label,
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if ((project.project ?? "").isNotEmpty)
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

  // ─────────────────────────────────────────
  // YOUTUBE LINK
  // ─────────────────────────────────────────

  Widget _youtubeButton(String url) {
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
                color: AppColors.primaryColor,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}