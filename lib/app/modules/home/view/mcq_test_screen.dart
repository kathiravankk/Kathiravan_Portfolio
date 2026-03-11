import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/internship/mcq_question_model.dart';

class McqTestScreen extends StatefulWidget {
  const McqTestScreen({super.key});

  @override
  State<McqTestScreen> createState() => _McqTestScreenState();
}

class _McqTestScreenState extends State<McqTestScreen> {
  List<QuestionDataModel> allQuestions = [];

  int currentQuestionIndex = 0;
  String selectedOption = "";

  Timer? timer;
  int totalSeconds = 0;

  @override
  void initState() {
    super.initState();

    McqQuestionModel model = Get.arguments["mockTestModel"];

    prepareQuestions(model);
    startTimer();
  }

  void prepareQuestions(McqQuestionModel model) {
    allQuestions = [
      ...(model.page1 ?? []),
      ...(model.page2 ?? []),
      ...(model.page3 ?? []),
    ];
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        totalSeconds++;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  String get formattedTime {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  double get progressValue {
    if (allQuestions.isEmpty) return 0;
    return (currentQuestionIndex + 1) / allQuestions.length;
  }

  void nextQuestion() {
    if (currentQuestionIndex < allQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = "";
      });
    } else {
      stopTimer();

      Get.snackbar(
        "Test Completed",
        "You finished the mock test",
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    }
  }

  Widget optionTile(String key, String? value) {
    bool isSelected = selectedOption == key;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = key;
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

    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor_2,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: AppColors.whiteColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
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

            const Spacer(),
            CustomButtonWidget(
              disable: selectedOption.isEmpty,
              height: 45,
              buttonFunction: () {
                selectedOption.isEmpty ? null : nextQuestion();
              },
              buttonText: "Next",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
