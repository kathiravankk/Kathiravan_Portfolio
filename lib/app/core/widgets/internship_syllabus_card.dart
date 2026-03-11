import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

class InternSyllabusCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final int totalWeeks;
  final int totalTopics;
  final VoidCallback viewFunc;

  const InternSyllabusCard({
    super.key,
    this.title = "",
    this.subTitle = "",
    this.totalWeeks = 0, required this.viewFunc,  this.totalTopics = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.contBorderColor2),
        borderRadius: BorderRadius.circular(30),
        color: AppColors.contColor2,
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.gradientColor3,
            ),
          ),
          Text(
            title,
            style: AppStyles.customTextStyle(
              size: 14,
              lineSpace: 1.3,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
          Text(
            //subTitle,
            "Beginner to Advanced",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.lightText,
              weight: FontWeight.w300,
            ),
          ),
          Row(
            spacing: 10,
            children: [
              Row(
                spacing: 5,
                children: [
                  Icon(
                    Icons.access_time_sharp,
                    color: AppColors.secondaryColor,
                    size: 15,
                  ),
                  Text(
                    getWeek(totalWeeks),
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  Icon(
                    Icons.format_list_numbered_outlined,
                    color: AppColors.secondaryColor,
                    size: 15,
                  ),
                  Text(
                    "Total Topics: $totalTopics",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
          CustomButtonWidget(
            height: 40,
            buttonFunction: viewFunc,
            buttonText: "Start Now",
          ),
        ],
      ),
    );
  }

  static String getWeek(int week) {
    return week <= 1 ? "$week Week" : "$week Weeks";
  }
}
