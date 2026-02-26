import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

class SavedInternshipCard extends StatelessWidget {
  final String? jobTitle;
  final String? companyName;
  final String? companyLogo;
  final String? postedDate;
  final VoidCallback? isApplyFunc;
  final VoidCallback? isSaveFunc;
  final VoidCallback? isViewFunc;

  const SavedInternshipCard({
    super.key,
    this.jobTitle = "",
    this.companyName = "",
    this.companyLogo = "",
    this.postedDate = "",
    this.isApplyFunc,
    this.isSaveFunc,
    this.isViewFunc
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isViewFunc,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.whiteColor,
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle!.capitalize ?? "",
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
                const Spacer(),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButtonWidget(
                  buttonFunction: isApplyFunc!,
                  buttonText: "Apply Now",
                  bgColor: AppColors.secondaryColor,
                  buttonTextStyle: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.blackColor,
                    weight: FontWeight.w500,
                    fontFamily: "Roboto",
                  ),
                  width: 220,
                  height: 35,
                ),
                IconButton(
                  onPressed: isSaveFunc!,
                  icon: Icon(
                    Icons.bookmark,
                    color: AppColors.secondaryColor,
                    size: 35,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
