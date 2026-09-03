import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/feedback_widget.dart';
import 'package:internsharks/app/data/models/internship/test_result_model.dart';
import 'package:internsharks/app/modules/internship/controller/internship_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class McqResultReviewScreen extends StatefulWidget {
  const McqResultReviewScreen({super.key});

  @override
  State<McqResultReviewScreen> createState() => _McqResultReviewScreenState();
}

class _McqResultReviewScreenState extends State<McqResultReviewScreen> {
  final InternshipController internController =
      Get.find<InternshipController>();
  int correct = 0;
  int incorrect = 0;
  int skipped = 0;
  List<AnswerData>? answers;

  String testDuration = "";
  String jobId = "";
  String studentId = "";

  @override
  void initState() {
    testDuration = Get.arguments["testDuration"] ?? "";
    jobId = Get.arguments["jobId"] ?? "";
    studentId = Get.arguments["studentId"] ?? "";
    answers = internController.testResultModel.testResult!.correctAnswer ?? [];

    correct = answers!.where((e) => e.answer == e.selectAnswer).length;

    incorrect = answers!
        .where((e) => e.selectAnswer != null && e.answer != e.selectAnswer)
        .length;

    skipped = answers!
        .where((e) => e.selectAnswer == null || e.selectAnswer == "")
        .length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.appBackgroundImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: AppColors.transparentColor,
          floatingActionButton: CustomButtonWidget(
            width: 300,
            height: 45,
            buttonFunction: () {
              AppAlertUtils.showAppAlert(
                context: context,
                title: "Test Completed",
                content:
                    "Thank you for attending this test.\n\nRecruiter will contact you soon.\n\nYou will now be redirected to your dashboard.",
                confirmText: "OKAY",
                cancelText: "CLOSE",
                onConfirm: () {
                  AppFunctions.navigateInitialScreen(
                    context,
                    AppRoutes.studentDashBoardScreen,
                  );
                },
              );
            },
            buttonText: "Next",
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Obx(
            () => SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 20,
                  children: [
                    scoreCircle(correct, answers!.length),
                    reviewContent(),
                    Text(
                      "Review your Test Result",
                      textAlign: TextAlign.center,
                      style: AppStyles.customTextStyle(
                        size: 18,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w700,
                      ),
                    ),

                    Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        statCard(
                          "Correct",
                          correct.toString(),
                          Icon(
                            Icons.check,
                            color: AppColors.sucTextColor,
                            size: 20,
                          ),
                        ),
                        statCard(
                          "Incorrect",
                          incorrect.toString(),
                          Icon(
                            Icons.close,
                            color: AppColors.failTextColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        statCard(
                          "Skipped",
                          skipped.toString(),
                          Icon(
                            Icons.skip_next,
                            color: AppColors.greyIcon,
                            size: 20,
                          ),
                        ),
                        statCard(
                          "Time Taken",
                          testDuration,
                          Icon(
                            Icons.access_time_sharp,
                            color: AppColors.selectedContColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    // FeedbackWidget(
                    //   isLoading: internController.feedBackLoading,
                    //   onSubmit: (rating, feedback) async {
                    //     return await addFeedbackReview(
                    //       rating: rating,
                    //       review: feedback,
                    //     );
                    //   },
                    // ),
                    ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: answers!.length,
                      itemBuilder: (context, index) {
                        return questionCard(answers![index], index);
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> addFeedbackReview({
    required int rating,
    required String review,
  }) async {
    Map<String, dynamic> feedBackData = {
      "jobId": jobId,
      "studentId": studentId,
      "review": review,
      "rating": rating,
      "feedbacktype": "Other",
    };

    await internController.giveFeedBackReview(feedBackData: feedBackData);

    final code = internController.getResponseCode();

    if (code == 200 || code == 201) {
      AppAlertUtils.showToast(
        message: internController.reviewModel.message ??
            "Feedback Submitted Successfully!",
      );
      return true;
    } else {
      AppFunctions.apiErrorHandling(
        code,
        internController.reviewModel.message ?? "Please try again later!",
      );
      return false;
    }
  }

  Widget reviewContent() {
    int score = int.parse(
      internController.testResultModel.testResult!.score ?? "0",
    );
    return Container(
      decoration: BoxDecoration(
        color: AppColors.contBorderColor2,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Text(
        getResultLabel(score),
        style: AppStyles.customTextStyle(
          size: 14,
          color: AppColors.whiteColor,
          weight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget scoreCircle(int score, int total) {
    double percentage = score / total;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: percentage),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return SizedBox(
          height: 120,
          width: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 6,

                  backgroundColor: AppColors.contBorderColor2,
                  valueColor: AlwaysStoppedAnimation(AppColors.secondaryColor),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$score / $total",
                    style: AppStyles.customTextStyle(
                      size: 20,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Final Score",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget statCard(String title, String value, Widget icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.contColor2,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.contBorderColor2),
        ),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(5),
                  child: icon,
                ),
                Text(
                  title,
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget feedbackSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff131A21),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "HOW WAS YOUR EXPERIENCE WITH THIS MOCK TEST?",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => const Icon(Icons.star, color: Colors.amber),
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            decoration: InputDecoration(
              hintText: "Your feedback about Internship",
              filled: true,
              fillColor: const Color(0xff0B0F14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget questionCard(AnswerData data, int index) {
    bool isCorrect = data.answer == data.selectAnswer;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCorrect ? AppColors.correctBorder : AppColors.inCorrectBorder,
      ),
      padding: EdgeInsets.only(left: 5),
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
                  "QUESTION ${index + 1}",
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
                    color: isCorrect
                        ? AppColors.correctBg
                        : AppColors.inCorrectBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isCorrect ? "CORRECT" : "INCORRECT",
                    style: AppStyles.customTextStyle(
                      size: 10,
                      color: isCorrect
                          ? AppColors.correctText
                          : AppColors.inCorrectText,
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
            if (data.selectAnswer != null)
              Container(
                padding: EdgeInsets.all(10),
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
                  spacing: 10,
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
                      getOptionText(data, data.selectAnswer) ?? "",
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
                  spacing: 10,
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
                      getOptionText(data, data.answer) ??
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

  String getResultLabel(int score) {
    if (score <= 10) {
      return "Fail";
    } else if (score <= 16) {
      return "Pass";
    } else if (score <= 22) {
      return "Good";
    } else if (score <= 26) {
      return "Very Good";
    } else {
      return "Excellent";
    }
  }

  String? getOptionText(AnswerData data, String? key) {
    if (key == null || data.options == null) return null;

    switch (key) {
      case "A":
        return data.options?.a;
      case "B":
        return data.options?.b;
      case "C":
        return data.options?.c;
      case "D":
        return data.options?.d;
      default:
        return key;
    }
  }
}
