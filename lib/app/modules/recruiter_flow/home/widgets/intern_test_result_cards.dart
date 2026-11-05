import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_test_result_model.dart';
import 'package:url_launcher/url_launcher.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SCORE & RATING ROW
// ─────────────────────────────────────────────────────────────────────────────

class ScoreAndRatingRow extends StatelessWidget {
  final int? score;
  final double stars;

  const ScoreAndRatingRow({
    super.key,
    required this.score,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
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
}

// ─────────────────────────────────────────────────────────────────────────────
// DAILY PROGRESS CARD
// ─────────────────────────────────────────────────────────────────────────────

class DailyProgressCard extends StatelessWidget {
  final List<DailyProgress> progress;

  const DailyProgressCard({super.key, required this.progress});

  static String formatDate(dynamic date) {
    if (date == null) return "-";
    DateTime? dt;
    if (date is DateTime) {
      dt = date;
    } else if (date is String) {
      if (date.isEmpty) return "-";
      dt = DateTime.tryParse(date);
      if (dt == null) return date;
    }
    if (dt == null) return "-";
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(dt.day)}-${two(dt.month)}-${dt.year.toString().length >= 4 ? dt.year.toString().substring(2) : dt.year.toString()}";
  }

  @override
  Widget build(BuildContext context) {
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

  Widget _dailyProgressRow(DailyProgress progress) {
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
                      if (progress.driveLink == null || progress.driveLink!.isEmpty) return;
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
                    child: const Icon(
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
              formatDate(progress.completedAt),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// INTERN PROJECT LINK CARD
// ─────────────────────────────────────────────────────────────────────────────

class ProjectLinkCard extends StatelessWidget {
  final List<String> links;

  const ProjectLinkCard({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
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
              const Icon(CupertinoIcons.link, size: 16, color: AppColors.whiteColor),
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
                    color: AppColors.blueTextColor,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// QUESTION REVIEW CARD & LIST
// ─────────────────────────────────────────────────────────────────────────────

class QuestionReviewCard extends StatelessWidget {
  final CorrectAnswer data;
  final int index;

  const QuestionReviewCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
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

  String? _resolveAnswerText(CorrectAnswer data, String? key) {
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
        return key;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT STATUS CARD
// ─────────────────────────────────────────────────────────────────────────────

class PaymentStatusCard extends StatelessWidget {
  final String? fee;
  final dynamic updatedAt;

  const PaymentStatusCard({
    super.key,
    required this.fee,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.correctBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.credit_card_rounded,
                size: 16,
                color: AppColors.correctText,
              ),
              const SizedBox(width: 8),
              Text(
                "Payment Status",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _paymentField(
                  "Amount",
                  "₹${fee ?? '0'}",
                ),
              ),
              Expanded(
                child: _paymentField(
                  "Status",
                  null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.correctBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Paid",
                      style: AppStyles.customTextStyle(
                        size: 10,
                        color: AppColors.correctText,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _paymentField(
                  "Paid On",
                  updatedAt != null
                      ? AppFunctions.formatIsoDate(updatedAt.toString())
                      : "-",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentField(String label, String? value, {Widget? child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.customTextStyle(
            size: 10,
            color: AppColors.lightTextColor,
            weight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        child ??
            Text(
              value ?? "-",
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.whiteColor,
                weight: FontWeight.w600,
              ),
            ),
      ],
    );
  }
}

