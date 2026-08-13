import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/data/models/internship/student_test_result_model.dart';
import 'package:internsharks/app/modules/internship/controller/internship_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

class StudentTestResultScreen extends StatefulWidget {
  const StudentTestResultScreen({super.key});

  @override
  State<StudentTestResultScreen> createState() => _StudentTestResultScreenState();
}

class _StudentTestResultScreenState extends State<StudentTestResultScreen> {
  final InternshipController internController =
  Get.find<InternshipController>();
  final ProfileController profileController = Get.find<ProfileController>();

  StudentTestData? _internData;

  @override
  void initState() {
    studentId = Get.arguments["studentId"] ?? "";
    jobId = Get.arguments["jobId"] ?? "";
    super.initState();
    getTestResult();
    getStudentProfileData();
  }

  String studentId = "";
  String jobId = "";
  String jobType = "";

  Future<void> getTestResult() async {
    try {
      await internController.getStudentTestResult(studentId: studentId, jobId: jobId);
      if (internController.getResponseCode() == 200 ||
          internController.getResponseCode() == 201) {
        setState(() {
          _internData = internController.resultReviewModel.studentTestResult;
        });
      } else {
        AppFunctions.apiErrorHandling(
          internController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        internController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  Future<void> getStudentProfileData() async {
    try {
      await profileController.getProfileData(studentId: studentId);
      if (profileController.getResponseCode() == 200 ||
          profileController.getResponseCode() == 201) {
      } else {
        AppFunctions.apiErrorHandling(
          profileController.getResponseCode(),
          "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        "Something went wrong!, Try again later",
      );
    }
  }

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
            () =>
        internController.studentResultLoading ||
            profileController.profileDataLoading
            ? AppAlertUtils.customLoader()
            : Scaffold(
          backgroundColor: AppColors.transparentColor,
          appBar: _buildAppBar(),
          body: _internData == null
              ? Center(
            child: Text(
              "No test result available.",
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.lightTextColor,
                weight: FontWeight.w400,
              ),
            ),
          )
              : SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileHeader(),
                  _scoreAndRatingRow(),
                  _dailyProgressCard(),
                  if ((_internData?.testWeeklyReport?.internProjectLink ?? [])
                      .isNotEmpty)
                    _projectLinkCard(),
                  Text(
                    "Answer Review",
                    style: AppStyles.customTextStyle(
                      size: 18,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  ..._answerReviewCards(),

                ],
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
        "Test Result",
        style: AppStyles.customTextStyle(
          size: 18,
          color: AppColors.secondaryColor,
          weight: FontWeight.w700,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // PROFILE HEADER
  // ─────────────────────────────────────────

  Widget _profileHeader() {
    final status = _internData?.testWeeklyReport?.status ?? "";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        CircleAvatar(
          maxRadius: 30,
          backgroundImage: NetworkImage(
            profileController.profileDataModel.studProfile ?? "",
          ),
        ),
        Expanded(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileController.profileDataModel.studentName ??
                    "Student",
                style: AppStyles.customTextStyle(
                  size: 17,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              Text(
                profileController.profileDataModel
                    .education!.college!.first.degree ??
                    "College",
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.lightTextColor,
                  weight: FontWeight.w400,
                ),
              ),
              if (status.isNotEmpty) ...[_statusChip(status)],
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusChip(String status) {
    final isCompleted = status.toLowerCase() == "completed";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.correctBg : AppColors.disableContColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.check_circle_outline : Icons.timelapse,
            size: 12,
            color: isCompleted
                ? AppColors.correctText
                : AppColors.lightTextColor,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: AppStyles.customTextStyle(
              size: 11,
              color: isCompleted
                  ? AppColors.correctText
                  : AppColors.lightTextColor,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // SCORE + RATING
  // ─────────────────────────────────────────

  Widget _scoreAndRatingRow() {
    final score = _internData?.testData?.testViewData?.score;
    final stars = _internData?.testData?.testViewData?.stars ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "SCORE",
                    style: AppStyles.customTextStyle(
                      size: 11,
                      color: AppColors.pathLightTextColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${score ?? 0}",
                    style: AppStyles.customTextStyle(
                      size: 30,
                      color: AppColors.secondaryColor,
                      weight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              color: AppColors.contBorderColor2,
              thickness: 1,
              width: 1,
              indent: 6,
              endIndent: 6,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "RATING",
                    style: AppStyles.customTextStyle(
                      size: 11,
                      color: AppColors.pathLightTextColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _starRow(stars),
                  const SizedBox(height: 4),
                  Text(
                    "${stars.toStringAsFixed(1)} / 5.0",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _starRow(double rating) {
    final filled = rating.round().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: AppColors.secondaryColor,
          size: 18,
        );
      }),
    );
  }

  // ─────────────────────────────────────────
  // DAILY PROGRESS
  // ─────────────────────────────────────────

  Widget _dailyProgressCard() {
    final progress = _internData?.testWeeklyReport?.dailyProgress ?? [];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 16,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                "Daily Progress",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (progress.isEmpty)
            Text(
              "No daily progress recorded yet.",
              style: AppStyles.customTextStyle(
                size: 12,
                color: AppColors.lightTextColor,
                weight: FontWeight.w300,
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "DAY",
                    style: AppStyles.customTextStyle(
                      size: 10,
                      color: AppColors.lightTextColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "STATUS",
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 10,
                      color: AppColors.lightTextColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "DATE",
                    textAlign: TextAlign.right,
                    style: AppStyles.customTextStyle(
                      size: 10,
                      color: AppColors.lightTextColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...progress.map((p) => _dailyProgressRow(p)),
          ],
        ],
      ),
    );
  }

  Widget _dailyProgressRow(TestDailyProgress progress) {
    final isCompleted = (progress.status ?? "").toLowerCase() == "completed";

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Day ${progress.dayNumber ?? "-"}",
              style: AppStyles.customTextStyle(
                size: 12,
                color: AppColors.whiteColor,
                weight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.correctBg
                          : AppColors.disableContColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (progress.status ?? "Pending").toUpperCase(),
                      style: AppStyles.customTextStyle(
                        size: 9,
                        color: isCompleted
                            ? AppColors.correctText
                            : AppColors.lightTextColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final uri = Uri.tryParse(progress.driveLink!);
                      if (uri != null && await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        AppAlertUtils.showToast(
                          message: "Couldn't open this link",
                          isError: true,
                        );
                      }
                    },
                    child: Icon(
                      CupertinoIcons.link,
                      color: AppColors.primaryColor,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatDateFromString(progress.completedAt),
              textAlign: TextAlign.right,
              style: AppStyles.customTextStyle(
                size: 11,
                color: AppColors.lightTextColor,
                weight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateFromString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";

    // Convert string to DateTime safely
    DateTime? date = DateTime.tryParse(dateStr);
    if (date == null) return "-";

    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(date.day)}-${two(date.month)}-${date.year.toString().substring(2)}";
  }

  // ─────────────────────────────────────────
  // INTERN PROJECT LINK
  // ─────────────────────────────────────────

  Widget _projectLinkCard() {
    final links = _internData?.testWeeklyReport?.internProjectLink ?? [];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.contBorderColor2, width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.link, size: 16, color: AppColors.whiteColor),
              const SizedBox(width: 8),
              Text(
                "Intern Project Link",
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...links.map(
                (url) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: GestureDetector(
                onTap: () async {
                  final uri = Uri.tryParse(url);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    AppAlertUtils.showToast(
                      message: "Couldn't open this link",
                      isError: true,
                    );
                  }
                },
                child: Text(
                  url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.selectedContColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // ANSWER REVIEW
  // ─────────────────────────────────────────

  List<Widget> _answerReviewCards() {
    final answers = _internData?.testData?.testViewData?.correctAnswer ?? [];

    if (answers.isEmpty) {
      return [
        Text(
          "No answers recorded.",
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.lightTextColor,
            weight: FontWeight.w300,
          ),
        ),
      ];
    }

    return List.generate(answers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _questionCard(answers[index], index),
      );
    });
  }

  Widget _questionCard(CorrectAnswerList data, int index) {
    final isSkipped = data.selectAnswer == null || data.selectAnswer == "";
    final isCorrect = !isSkipped && data.answer == data.selectAnswer;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCorrect ? AppColors.correctBorder : AppColors.inCorrectBorder,
      ),
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.contColor2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.contBorderColor2),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "QUESTION ${(index + 1).toString().padLeft(2, "0")}",
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: AppColors.contLightText,
                    weight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSkipped
                        ? AppColors.disableContColor
                        : (isCorrect
                        ? AppColors.correctBg
                        : AppColors.inCorrectBg),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isSkipped
                        ? "SKIPPED"
                        : (isCorrect ? "CORRECT" : "INCORRECT"),
                    style: AppStyles.customTextStyle(
                      size: 10,
                      color: isSkipped
                          ? AppColors.lightTextColor
                          : (isCorrect
                          ? AppColors.correctText
                          : AppColors.inCorrectText),
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              data.question ?? "",
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                lineSpace: 1.3,
                weight: FontWeight.w500,
              ),
            ),
            if (!isSkipped)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.correctBg
                      : AppColors.inCorrectBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCorrect
                        ? AppColors.correctBorder
                        : AppColors.inCorrectBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text(
                      "YOUR ANSWER",
                      style: AppStyles.customTextStyle(
                        size: 10,
                        color: isCorrect
                            ? AppColors.correctText
                            : AppColors.inCorrectText,
                        weight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      _resolveAnswerText(data, data.selectAnswer) ?? "",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            if (!isCorrect)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.correctBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.correctBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text(
                      "CORRECT ANSWER",
                      style: AppStyles.customTextStyle(
                        size: 10,
                        color: AppColors.correctText,
                        weight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      _resolveAnswerText(data, data.answer) ??
                          data.correctAnswer ??
                          "",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String? _resolveAnswerText(CorrectAnswerList data, String? key) {
    if (key == null || key.isEmpty) return null;
    final options = data.options;
    if (options == null) return key;

    switch (key) {
      case "A":
        return options.a ?? key;
      case "B":
        return options.b ?? key;
      case "C":
        return options.c ?? key;
      case "D":
        return options.d ?? key;
      default:
        return key; // already full text
    }
  }
}
