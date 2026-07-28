import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/ai_loading_widget.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/internship/mcq_question_model.dart';
import 'package:internsharks/app/modules/internship/controller/internship_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

import '../../../core/utils/app_functions.dart' show AppFunctions;

class McqTestScreen extends StatefulWidget {
  const McqTestScreen({super.key});

  @override
  State<McqTestScreen> createState() => _McqTestScreenState();
}

class _McqTestScreenState extends State<McqTestScreen> {
  final InternshipController internController =
      Get.find<InternshipController>();
  List<QuestionDataModel> allQuestions = [];

  int currentQuestionIndex = 0;
  String selectedOption = "";

  Timer? timer;
  //int totalSeconds = 450;
  int totalSeconds = 0;

  List<String> answers = [];

  String jobId = "";
  String studentId = "";

  @override
  void initState() {
    super.initState();

    McqQuestionModel model = Get.arguments["mockTestModel"];
    jobId = Get.arguments["jobId"] ?? "";
    studentId = Get.arguments["studentId"];

    // API returns minutes (e.g. 15) → convert to seconds for the countdown
    final minutes = model.timeDuration ?? 0;
    totalSeconds = minutes * 60;

    prepareQuestions(model);
    startTimer();
  }

  void prepareQuestions(McqQuestionModel model) {
    allQuestions = [
      ...(model.page1 ?? []),
      ...(model.page2 ?? []),
      ...(model.page3 ?? []),
    ];

    answers = List.filled(allQuestions.length, "");
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (totalSeconds <= 0) {
        t.cancel();
        submitTest();
      } else {
        setState(() {
          totalSeconds--;
        });
      }
    });
  }

  String get formattedTime {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void stopTimer() {
    timer?.cancel();
  }

  double get progressValue {
    if (allQuestions.isEmpty) return 0;
    return (currentQuestionIndex + 1) / allQuestions.length;
  }

  void nextQuestion() {
    if (currentQuestionIndex < allQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = answers[currentQuestionIndex];
      });
    } else {
      submitTest();
    }
  }
  bool _isSubmitting = false;

  Future<void> submitTest() async {
    if (_isSubmitting) return;
    _isSubmitting = true;
    stopTimer();
    bool isLoaderVisible = false;

    try {
      AiLoadingWidget.show(context, type: LoadingDialogType.mcqValidation);
      isLoaderVisible = true;

      await Future.delayed(const Duration(milliseconds: 100));

      Map<String, dynamic> answerData = {
        "answers": answers,
        "questions": allQuestions,
      };

      await internController.validateMcqAnswer(answerData: answerData);

      if (internController.getResponseCode() == 200 ||
          internController.getResponseCode() == 201 ||
          internController.testResultModel.success == true) {
        Map<String, dynamic> testData = {
          "jobId": jobId,
          "testresult": {
            "correct_answer":
                internController.testResultModel.testResult?.correctAnswer,
            "score": internController.testResultModel.testResult?.score,
            "stars": internController.testResultModel.testResult?.stars,
          },
        };

        /// ✅ HIDE loader BEFORE next async/navigation
        if (isLoaderVisible) {
          AiLoadingWidget.hide(context);
          isLoaderVisible = false;
        }

        /// ⚠️ IMPORTANT: if this method navigates → loader must already be hidden
        await saveTestResult(testData: testData);
      } else {
        throw Exception("Validation failed");
      }
    } catch (error) {
      if (isLoaderVisible) {
        AiLoadingWidget.hide(context);
        isLoaderVisible = false;
      }

      AppFunctions.apiErrorHandling(
        internController.getResponseCode(),
        "Something went wrong!, Try again later!",
      );
    } finally {
      /// safety fallback (won’t double hide)
      if (isLoaderVisible) {
        AiLoadingWidget.hide(context);
      }
    }
  }

  Future<void> saveTestResult({required Map<String, dynamic> testData}) async {
    await internController.saveTestResult(testData: testData);

    if (!mounted) return; // bail if screen already gone

    final code = internController.getResponseCode();
    debugPrint("saveTestResult response code: $code, success: ${internController.saveTestModel.success}");

    if (internController.saveTestModel.success == true) {
      AppAlertUtils.showToast(
        message: internController.saveTestModel.message ?? "Test Submitted Successfully!",
      );
      AppFunctions.navigateScreen(
        context,
        AppRoutes.mcqResultReviewScreen,
        arguments: {
          "testDuration": formattedTime,
          "jobId": jobId,
          "studentId": studentId,
        },
      );
    } else {
      AppFunctions.apiErrorHandling(
        code,
        internController.saveTestModel.message ?? "Something went wrong, Try again later!",
      );
    }
  }

  Widget optionTile(String key, String? value) {
    bool isSelected = selectedOption == key;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = key;
          answers[currentQuestionIndex] = key;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.contColor2,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.contBorderColor2,
          ),
        ),
        child: Row(
          spacing: 10,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected
                  ? AppColors.whiteColor
                  : AppColors.contBorderColor2,
            ),
            Expanded(
              child: Text(
               value ?? "",
                style: AppStyles.customTextStyle(
                  size: 12,
                  lineSpace: 1.3,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (allQuestions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.secondaryColor),
        ),
      );
    }

    QuestionDataModel question = allQuestions[currentQuestionIndex];

    return WillPopScope(
      onWillPop: () async {
        if (currentQuestionIndex > 0) {
          setState(() {
            currentQuestionIndex--;
            selectedOption = answers[currentQuestionIndex];
          });
          return false;
        } else {
          AppAlertUtils.showAppAlert(
            context: context,
            title: "Exit Test",
            content:
                "If you go back now, your test will be cancelled and answers will not be submitted.\n\nDo you want to exit the test?",
            cancelText: "Stay Here",
            confirmText: "Exit Test",
            onConfirm: () {
              stopTimer();
              Get.back();
            },
          );
          return false;
        }
      },
      child: Container(
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
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 25,
                color: AppColors.whiteColor,
              ),
              onPressed: () {
                if (currentQuestionIndex > 0) {
                  setState(() {
                    currentQuestionIndex--;
                    selectedOption = answers[currentQuestionIndex];
                  });
                } else {
                  AppAlertUtils.showAppAlert(
                    context: context,
                    title: "Exit Test",
                    content:
                        "If you go back now, your test will be cancelled and answers will not be submitted.\n\nDo you want to exit the test?",
                    cancelText: "Stay Here",
                    confirmText: "Exit Test",
                    onConfirm: () {
                      stopTimer();
                      Get.back();
                    },
                  );
                }
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Text(
                  "Progress",
                  style: AppStyles.customTextStyle(
                    size: 16,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Question ${currentQuestionIndex + 1} of ${allQuestions.length}",
                          style: AppStyles.customTextStyle(
                            size: 14,
                            color: AppColors.secondaryColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          formattedTime,
                          style: AppStyles.customTextStyle(
                            size: 14,
                            color: AppColors.primaryColor,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(5),
                      value: progressValue,
                      backgroundColor: AppColors.dividerContColor,
                      color: AppColors.whiteColor,
                      minHeight: 6,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 15,
                      children: [
                        Text(
                          question.question ?? "",
                          style: AppStyles.customTextStyle(
                            lineSpace: 1.3,
                            size: 16,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),

                        optionTile("A", question.options?.a),
                        optionTile("B", question.options?.b),
                        optionTile("C", question.options?.c),
                        optionTile("D", question.options?.d),
                      ],
                    ),
                  ),
                ),

                //const Spacer(),
                Obx(
                  () => CustomButtonWidget(
                    isLoading:
                        internController.validateMcqAnswerLoading ||
                        internController.saveTestLoading,
                    disable: selectedOption.isEmpty,
                    height: 45,
                    buttonFunction: () async {
                      if (currentQuestionIndex == allQuestions.length - 1) {
                        AppAlertUtils.showAppAlert(
                          context: context,
                          title: "Complete Test",
                          content:
                              "Are you sure you want to complete this test?\n\n"
                              "Remaining Time: $formattedTime\n\n"
                              "You can go back and review your answers before submitting.",
                          cancelText: "Review",
                          confirmText: "Submit",
                          onConfirm: () async {
                            await submitTest();
                          },
                        );
                      } else {
                        nextQuestion();
                      }
                    },
                    buttonText: currentQuestionIndex == allQuestions.length - 1
                        ? "Complete the Test"
                        : "Next",
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
