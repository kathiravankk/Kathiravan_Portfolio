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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle?.capitalize ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: AppColors.disableButtonColor2,
                          weight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        companyName ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 12,
                          color: AppColors.selectedContColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: isSaveFunc,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightWhiteCont,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.bookmark,
                      color: AppColors.secondaryColor,
                      size: 23,
                    ),
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 10,
              runSpacing: 5,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Text(
                    "Education: ${qualification ?? ""}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.customTextStyle(
                      size: 10,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Text(
                    "Available: ${skillList?.join(", ") ?? ""}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.customTextStyle(
                      size: 10,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 10,
              runSpacing: 5,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, size: 12, color: AppColors.greyIcon),
                      const SizedBox(width: 5),
                      Text(
                        "Duration : $duration",
                        style: AppStyles.customTextStyle(
                          size: 10,
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
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.currency_rupee, size: 12, color: AppColors.greyIcon),
                      const SizedBox(width: 5),
                      Text(
                        stipendRupees != "N/A"
                            ? "Stipend : $stipendRupees"
                            : internFees != "0"
                            ? "Fees : $internFees"
                            : "Free Internship",
                        style: AppStyles.customTextStyle(
                          size: 10,
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
