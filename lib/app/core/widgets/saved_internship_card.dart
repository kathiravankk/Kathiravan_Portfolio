import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

class SavedInternshipCard extends StatelessWidget {
  final String? jobTitle;
  final String? companyName;
  final String? companyLogo;
  final String? postedDate;

  const SavedInternshipCard({
    super.key,
    this.jobTitle = "",
    this.companyName = "",
    this.companyLogo = "",
    this.postedDate = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: AppColors.whiteColor,
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobTitle ?? "",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    companyName ?? "",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.selectedContColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.navBarColor, width: 0.5),
                ),
                child: Image.network(
                  companyLogo ?? "",
                  height: 50,
                  width: 50,
                  //color: AppColors.whiteColor,
                  errorBuilder: (context, error, stackTrace) => CircleAvatar(
                    backgroundColor: AppColors.whiteColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_outlined,
                          color: AppColors.lightHintText,
                          size: 30,
                        ),
                        Text(
                          "Error!",
                          style: AppStyles.customTextStyle(
                            size: 5,
                            weight: FontWeight.w400,
                            color: AppColors.failTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            AppFunctions.convertPostedDate(postedDate ?? ""),
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.lightBlackText2,
              weight: FontWeight.w300,
            ),
          ),
          Row(
            children: [
              CustomButtonWidget(
                buttonFunction: () {},
                buttonText: "Apply Now",
                bgColor: AppColors.secondaryColor,
                width: 220,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark, color: AppColors.secondaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
