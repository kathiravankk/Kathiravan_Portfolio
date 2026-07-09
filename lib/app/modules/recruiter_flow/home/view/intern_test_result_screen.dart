import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_test_result_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

class PaymentInfo {
  const PaymentInfo({
    required this.amount,
    required this.status,
    required this.paidOn,
    required this.transactionId,
    required this.paymentMethod,
  });

  final String amount;
  final String status; // e.g. "PAID"
  final String paidOn; // pre-formatted, e.g. "09 Jun 2026"
  final String transactionId;
  final String paymentMethod; // e.g. "UPI"
}

class InternTestResultScreen extends StatefulWidget {
  const InternTestResultScreen({super.key});

  @override
  State<InternTestResultScreen> createState() => _InternTestResultScreenState();
}

class _InternTestResultScreenState extends State<InternTestResultScreen> {
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();
  final InternshipPostController applicationController =
      Get.find<InternshipPostController>();
  InternTestResultData? _data;
  PaymentInfo? _paymentInfo;

  //InternStudentProfileModel? studentData;

  /// Coin cost shown on the CTA. Pull this from arguments if it's
  /// dynamic per-job; hardcoded here to match the screenshot ("50").
  int _certificateCost = 100;

  @override
  void initState() {
    studentId = Get.arguments["studentId"] ?? "";
    jobId = Get.arguments["jobId"] ?? "";
    super.initState();
    getTestResult();
    getStudentProfileData();
    _paymentInfo = Get.arguments?["paymentInfo"] as PaymentInfo?;
    //_certificateCost = Get.arguments?["certificateCost"] as int? ?? 50;
  }

  String studentId = "";
  String jobId = "";

  Future<void> getTestResult() async {
    try {
      await homeController.getStudentResult(studentId: studentId, jobId: jobId);
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        setState(() {
          _data = homeController.testResultModel.testData;
        });
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  Future<void> getStudentProfileData() async {
    try {
      await applicationController.getInternStudentProfile(
        jobId: jobId,
        studentId: studentId,
      );
      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        // setState(() {
        //   studentData = applicationController.internStudentProfileModel;
        // });
      } else {
        AppFunctions.apiErrorHandling(
          applicationController.getResponseCode(),
          "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        applicationController.getResponseCode(),
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
            applicationController.studentProfileLoading ||
                homeController.studentResultLoading
            ? AppAlertUtils.customLoader()
            : Scaffold(
                backgroundColor: AppColors.transparentColor,
                appBar: _buildAppBar(),
                body: _data == null
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
                              if ((_data?.weeklyReport?.internProjectLink ?? [])
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
                              //if (_paymentInfo != null) _paymentStatusCard(),
                            ],
                          ),
                        ),
                      ),
                floatingActionButton: _data == null
                    ? null
                    : _certificateButton(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
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
    final status = _data?.weeklyReport?.status ?? "";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        CircleAvatar(
          maxRadius: 30,
          backgroundImage: NetworkImage(
            applicationController.internStudentProfileModel.studProfile ?? "",
          ),
        ),
        Expanded(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                applicationController.internStudentProfileModel.studName ??
                    "Student",
                style: AppStyles.customTextStyle(
                  size: 17,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              Text(
                applicationController
                        .internStudentProfileModel
                        .studentCollegeName ??
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
    final score = _data?.testResult?.testResultDetails?.score;
    final stars = _data?.testResult?.testResultDetails?.stars ?? 0;

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
    final progress = _data?.weeklyReport?.dailyProgress ?? [];

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
              child: Container(
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
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(progress.completedAt),
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

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(date.day)}-${two(date.month)}-${date.year.toString().substring(2)}";
  }

  // ─────────────────────────────────────────
  // INTERN PROJECT LINK
  // ─────────────────────────────────────────

  Widget _projectLinkCard() {
    final links = _data?.weeklyReport?.internProjectLink ?? [];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(12),
        // border: Border(
        //   left: BorderSide(color: AppColors.primaryColor, width: 3),
        //   top: BorderSide(color: AppColors.contBorderColor2),
        //   right: BorderSide(color: AppColors.contBorderColor2),
        //   bottom: BorderSide(color: AppColors.contBorderColor2),
        // ),
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
    final answers = _data?.testResult?.testResultDetails?.correctAnswer ?? [];

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

  Widget _questionCard(CorrectAnswer data, int index) {
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

  /// `answer` / `select_answer` may either already be the full option text
  /// (as seen in your screenshots — "201 Created", "404 Not Found") or a
  /// letter key ("A"/"B"/"C"/"D") that needs resolving against `options`.
  /// This handles both without assuming one format.
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
        return key; // already full text
    }
  }

  // ─────────────────────────────────────────
  // PAYMENT STATUS (optional — see PaymentInfo doc comment above)
  // ─────────────────────────────────────────

  Widget _paymentStatusCard() {
    final payment = _paymentInfo!;
    final isPaid = payment.status.toLowerCase() == "paid";

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPaid ? AppColors.correctBorder : AppColors.contBorderColor2,
        ),
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
              Expanded(child: _paymentField("Amount", "₹${payment.amount}")),
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
                      color: isPaid
                          ? AppColors.correctBg
                          : AppColors.disableContColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      payment.status.toUpperCase(),
                      style: AppStyles.customTextStyle(
                        size: 10,
                        color: isPaid
                            ? AppColors.correctText
                            : AppColors.lightTextColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: _paymentField("Paid On", payment.paidOn)),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.contBorderColor2, height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _paymentField("Transaction ID", payment.transactionId),
              ),
              Expanded(
                child: _paymentField("Payment Method", payment.paymentMethod),
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

  // ─────────────────────────────────────────
  // GENERATE CERTIFICATE CTA
  // ─────────────────────────────────────────

  Widget _certificateButton() {
    final alreadyIssued = _data?.isCertificate == true;

    return CustomButtonWidget(
      disable: !alreadyIssued && _data?.weeklyReport?.status != "Completed",
      width: 300,
      buttonFunction: alreadyIssued ? _viewCertificate : _generateCertificate,
      buttonWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            alreadyIssued ? "View Certificate" : "Generate Certificate",
            style: AppStyles.customTextStyle(
              size: 15,
              color: AppColors.blackColor,
              weight: FontWeight.w700,
            ),
          ),
          if (!alreadyIssued) ...[
            const SizedBox(width: 6),
            Text(
              "100",
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.blackColor,
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 5),
            Image.asset(AssetImages.creditsIconNew, height: 22, width: 22),
          ],
        ],
      ),
    );
  }

  void _generateCertificate() {
    // TODO: wire this up to your certificate-generation API call.
    AppAlertUtils.showAppAlert(
      context: context,
      title: "Generate Certificate",
      content:
          "This will use 100 coins to generate a certificate for this intern.",
      cancelText: "Cancel",
      confirmText: "Generate",
      onConfirm: () {
        // await controller.generateCertificate(...)
      },
    );
  }

  void _viewCertificate() {
    AppFunctions.navigateScreen(
      context,
      AppRoutes.certificateViewScreen,
      arguments: {"jobId": jobId, "studentId": studentId},
    );
  }
}
