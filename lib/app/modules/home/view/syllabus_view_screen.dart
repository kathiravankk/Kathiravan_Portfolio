import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/code_example_widget.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';

class SyllabusViewScreen extends StatefulWidget {
  const SyllabusViewScreen({super.key});

  @override
  State<SyllabusViewScreen> createState() => _SyllabusViewScreenState();
}

class _SyllabusViewScreenState extends State<SyllabusViewScreen> {
  WeeklyData? weekData;

  int currentDayIndex = 0;

  @override
  void initState() {
    super.initState();
    weekData = Get.arguments["weekData"];
  }

  void nextDay() {
    if (currentDayIndex < weekData!.days!.length - 1) {
      setState(() {
        currentDayIndex++;
      });
    } else {
      markWeekComplete();
    }
  }

  void previousDay() {
    if (currentDayIndex > 0) {
      setState(() {
        currentDayIndex--;
      });
    }
  }

  void markWeekComplete() {
    debugPrint("Week Completed");
  }

  @override
  Widget build(BuildContext context) {
    final dayData = weekData!.days![currentDayIndex];

    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor_2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: AppColors.whiteColor,
          ),
          onPressed: () => dayData.day! <= 1 ? Get.back() : previousDay(),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Day ${dayData.day}: Modern Foundation",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.secondaryColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ...dayData.topics!.map((topic) {
                      return Column(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.title ?? "",
                            style: AppStyles.customTextStyle(
                              size: 16,
                              color: AppColors.whiteColor,
                              weight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            topic.explanation ?? "",
                            style: AppStyles.customTextStyle(
                              size: 12,
                              lineSpace: 1.3,
                              color: AppColors.lightText,
                              weight: FontWeight.w300,
                            ),
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.document_scanner_outlined,
                                color: AppColors.primaryColor,
                                size: 15,
                              ),
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

                          ...topic.codeExamples!.map(
                            (code) => CodeExampleWidget(code: code),
                          ),

                          const SizedBox(height: 20),

                          /// HOMEWORK
                          if (topic.homework != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Key Takeaways",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                ...topic.homework!.map(
                                  (hw) => Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.cyan,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            hw,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 30),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              CustomButtonWidget(
                height: 40,
                buttonFunction: nextDay,
                buttonText: currentDayIndex == weekData!.days!.length - 1
                    ? "Mark as Complete"
                    : "Next",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
