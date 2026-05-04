import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class SavedInternshipCard extends StatelessWidget {
  final String? jobTitle;
  final String? companyName;
  final String? companyLogo;
  final String? postedDate;
  final String? qualification;
  final VoidCallback? isApplyFunc;
  final VoidCallback? isSaveFunc;
  final VoidCallback? isViewFunc;
  final List<String>? skillList;
  final String stipendRupees;
  final String internFees;
  final String duration;

  const SavedInternshipCard({
    super.key,
    this.jobTitle = "",
    this.companyName = "",
    this.companyLogo = "",
    this.postedDate = "",
    this.isApplyFunc,
    this.isSaveFunc,
    this.isViewFunc,
    this.qualification,
    this.skillList,
    this.stipendRupees = "NA",
    this.internFees = "NA",
    this.duration = "0",
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
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle!.capitalize ?? "",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.disableButtonColor2,
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
                GestureDetector(
                  onTap: isSaveFunc!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightWhiteCont,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.bookmark,
                      color: AppColors.secondaryColor,
                      size: 23,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 5,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Text(
                        "Education: ",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          weight: FontWeight.w400,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          qualification!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.customTextStyle(
                            size: 10,
                            weight: FontWeight.w400,
                            color: AppColors.blackLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Text(
                        "Available: ",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          weight: FontWeight.w400,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          skillList!.join(", "),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.customTextStyle(
                            size: 10,
                            weight: FontWeight.w400,
                            color: AppColors.blackLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    spacing: 6,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.greyIcon,
                      ),
                      Text(
                        "Duration : $duration",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          weight: FontWeight.w400,
                          color: AppColors.blackLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightWhiteCont,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Row(
                    spacing: 3,
                    children: [
                      const Icon(
                        Icons.currency_rupee,
                        size: 12,
                        color: AppColors.greyIcon,
                      ),
                      Text(
                        stipendRupees != "N/A"
                            ? "Stipend : $stipendRupees"
                            : internFees != "0"
                            ? "Fees : $internFees"
                            : "Free Internship",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          weight: FontWeight.w400,
                          color: AppColors.blackLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightWhiteCont,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Text(
                    "Saved ${AppFunctions.convertPostedDate(postedDate ?? "")}",
                    style: AppStyles.customTextStyle(
                      size: 10,
                      weight: FontWeight.w500,
                      color: AppColors.blackLight,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: isApplyFunc!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.selectedContColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.transparentColor),
                    ),
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
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
