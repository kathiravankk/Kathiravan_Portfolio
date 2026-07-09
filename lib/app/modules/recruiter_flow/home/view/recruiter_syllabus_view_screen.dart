import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/code_example_widget.dart';
import '../../../../data/models/recruiter_flow/syllabus_data_model.dart'
    show ProjectSchedule, Topic, ScheduleGroup, Syllabus;

class RecruiterSyllabusViewScreen extends StatefulWidget {
  const RecruiterSyllabusViewScreen({super.key});

  @override
  State<RecruiterSyllabusViewScreen> createState() =>
      _RecruiterSyllabusViewScreenState();
}

class _RecruiterSyllabusViewScreenState
    extends State<RecruiterSyllabusViewScreen> {
  Syllabus? _syllabus;
  bool _isMonthBased = false;
  List<ScheduleGroup> _groups = [];

  // Path strings ("0", "0-1", "0-1-2" ...) uniquely identify a node
  // anywhere in the tree, however deep it goes.
  final Set<String> _expandedGroups = {};
  final Set<String> _expandedTopics = {};

  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();

  String studentId = "";
  String jobId = "";
  final bool? forcedMode = null;

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
                forcedMode ??
                (_syllabus!.month.isNotEmpty && _syllabus!.days.isEmpty);
            _groups = _isMonthBased ? _syllabus!.month : _syllabus!.days;
          }

          _autoExpandFirstBranch();
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

  /// Auto-expands straight down the first branch (Month 1 -> Week 1 -> Day 1,
  /// or just Day 1 for day-based plans) so the screen isn't empty on load.
  void _autoExpandFirstBranch() {
    if (_groups.isEmpty) return;
    String path = "0";
    ScheduleGroup current = _groups.first;
    _expandedGroups.add(path);
    while (current.hasChildren) {
      path = "$path-0";
      current = current.children.first;
      _expandedGroups.add(path);
    }
  }

  String _topicKey(Topic topic, String groupPath, int topicIndex) =>
      topic.id ?? "$groupPath-topic-$topicIndex";

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
                    ? CustomEmptyWidget()
                    : SafeArea(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _groups.length,
                          itemBuilder: (context, index) => _groupTile(
                            _groups[index],
                            depth: 0,
                            path: "$index",
                          ),
                        ),
                      ),
              ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    final totalLabel = _isMonthBased
        ? "${_syllabus?.totalMonth ?? _groups.length} Months Total"
        : "${_syllabus?.totalDays ?? _groups.length} Days Total";

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
        style: AppStyles.customTextStyle(
          size: 18,
          color: AppColors.secondaryColor,
          weight: FontWeight.w600,
        ),
      ),
      actions: [
        Visibility(
          visible: _syllabus!.status != "completed",
          child: GestureDetector(
            onTap: (){

            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child:
                  // Text(
                  //   totalLabel,
                  //   style: AppStyles.customTextStyle(
                  //     size: 12,
                  //     color: AppColors.whiteColor,
                  //     weight: FontWeight.w400,
                  //   ),
                  // ),
                  Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.sparkles, color: AppColors.primaryColor, size: 15,),
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
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // GROUP TILE — recursive: handles Month -> Week -> Day nesting for
  // month-based plans, and a single Day level for day-based plans.
  // ─────────────────────────────────────────

  Widget _groupTile(
    ScheduleGroup group, {
    required int depth,
    required String path,
  }) {
    final isExpanded = _expandedGroups.contains(path);
    final label = group.title ?? _defaultLabelFor(depth, path);
    final icon = _iconFor(depth);
    final titleSize = (15 - depth).clamp(11, 15).toDouble();

    return Container(
      margin: EdgeInsets.only(bottom: 12, left: depth * 10.0),
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          GestureDetector(
            onTap: () => setState(() {
              isExpanded
                  ? _expandedGroups.remove(path)
                  : _expandedGroups.add(path);
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: AppColors.primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: AppStyles.customTextStyle(
                        size: titleSize,
                        color: AppColors.secondaryColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.lightTextColor,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // Body — either nested sub-groups, or (at the deepest level) topics
          if (isExpanded) ...[
            Divider(color: AppColors.contBorderColor2, height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: group.hasChildren
                    ? List.generate(
                        group.children.length,
                        (i) => _groupTile(
                          group.children[i],
                          depth: depth + 1,
                          path: "$path-$i",
                        ),
                      )
                    : _buildLeafBody(group, path),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _defaultLabelFor(int depth, String path) {
    final index = int.tryParse(path.split("-").last) ?? 0;
    switch (depth) {
      case 0:
        return _isMonthBased ? "Month ${index + 1}" : "Day ${index + 1}";
      case 1:
        return "Week ${index + 1}";
      default:
        return "Day ${index + 1}";
    }
  }

  IconData _iconFor(int depth) {
    switch (depth) {
      case 0:
        return _isMonthBased
            ? Icons.calendar_month_outlined
            : Icons.calendar_today_outlined;
      case 1:
        return Icons.view_week_outlined;
      default:
        return Icons.calendar_today_outlined;
    }
  }

  /// Renders the deepest level of a branch: topic cards + project task
  /// cards, pulled from every [ScheduleData] entry under this group.
  List<Widget> _buildLeafBody(ScheduleGroup group, String path) {
    final widgets = <Widget>[];

    for (final scheduleData in group.data) {
      final topics = scheduleData.topics;
      for (int i = 0; i < topics.length; i++) {
        widgets.add(_topicCard(topics[i], path, i));
        widgets.add(const SizedBox(height: 10));
      }

      for (final project in scheduleData.projectSchedule) {
        widgets.add(_projectScheduleCard(project));
        widgets.add(const SizedBox(height: 10));
      }
    }

    if (widgets.isEmpty) {
      widgets.add(
        Text(
          "No topics added yet.",
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.lightTextColor,
            weight: FontWeight.w300,
          ),
        ),
      );
    }

    return widgets;
  }

  // ─────────────────────────────────────────
  // TOPIC CARD
  // ─────────────────────────────────────────

  Widget _topicCard(Topic topic, String groupPath, int topicIndex) {
    final key = _topicKey(topic, groupPath, topicIndex);
    final isExpanded = _expandedTopics.contains(key);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.appBgColor_2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              isExpanded
                  ? _expandedTopics.remove(key)
                  : _expandedTopics.add(key);
            }),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Topic ${topicIndex + 1}: ${topic.title ?? ""}",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      lineSpace: 1.3,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
          if (isExpanded) ...[
            const SizedBox(height: 10),
            if ((topic.explanation ?? "").isNotEmpty)
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
            if (topic.codeExamples.isNotEmpty) ...[
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
                    "Code Examples",
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...topic.codeExamples.map(
                (code) => CodeExampleWidget(code: code),
              ),
            ],
            if (topic.homework.isNotEmpty) ...[
              const SizedBox(height: 12),
              _homeworkBox(topic.homework),
            ],
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // VISUAL EXPLANATION
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
              const Icon(
                Icons.image_outlined,
                size: 15,
                color: AppColors.primaryColor,
              ),
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
  // HOMEWORK
  // ─────────────────────────────────────────

  Widget _homeworkBox(List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.contColor3,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.contBorderColor3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_turned_in_outlined,
                size: 15,
                color: AppColors.whiteColor,
              ),
              const SizedBox(width: 8),
              Text(
                "HOMEWORK",
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map(
            (hw) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.circle,
                      size: 6,
                      color: AppColors.lightTextColor,
                    ),
                  ),
                  const SizedBox(width: 10),
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
  // PROJECT SCHEDULE
  // ─────────────────────────────────────────

  Widget _projectScheduleCard(ProjectSchedule project) {
    final dayOrMonthLabel = _isMonthBased
        ? "Month ${project.month ?? ""}"
        : "Day ${project.day ?? ""}";

    return Container(
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
                "Project Task – $dayOrMonthLabel",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w500,
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
            const Icon(
              Icons.play_circle_outline,
              size: 16,
              color: AppColors.primaryColor,
            ),
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
