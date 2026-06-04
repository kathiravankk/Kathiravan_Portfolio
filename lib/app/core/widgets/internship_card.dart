import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class InternshipCard extends StatelessWidget {
  final VoidCallback? viewFunc;
  final VoidCallback? saveFunc;
  final String duration;
  final String role;
  final String postedDate;
  final String companyName;
  final String internshipMode;
  final String imageUrl;
  final String description;
  final String stipendRupees;
  final String qualification;
  final String eligibility;
  final String internFees;
  final String location;
  final double width;
  final bool isSaved;
  final int position;
  final bool isCategoryFlow;
  final List<String> skillList;

  const InternshipCard({
    super.key,
    this.viewFunc,
    this.duration = "0",
    this.position = 0,
    this.role = "",
    this.location = "NA",
    this.internFees = "NA",
    this.companyName = "",
    this.internshipMode = "NA",
    this.imageUrl = "",
    this.description = "",
    this.saveFunc,
    this.stipendRupees = "NA",
    this.qualification = "NA",
    this.eligibility = "All",
    this.skillList = const [],
    this.postedDate = "",
    this.width = double.infinity,
    this.isSaved = false,
    this.isCategoryFlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: viewFunc,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.whiteColor,
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 ROLE + SAVE
            Row(
              children: [
                Expanded(
                  child: Text(
                    role.capitalize ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.customTextStyle(
                      color: AppColors.disableButtonColor2,
                      size: 16,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: saveFunc,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightWhiteCont,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved
                          ? AppColors.secondaryColor
                          : AppColors.greyIcon,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔹 COMPANY + LOGO
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName.capitalize ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 14,
                          weight: FontWeight.w500,
                          color: AppColors.selectedContColor,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// 🔹 MODE + LOCATION
                      Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.work_history_outlined,
                                  size: 15, color: AppColors.greyIcon),
                              const SizedBox(width: 5),
                              Text(
                                internshipMode,
                                style: AppStyles.customTextStyle(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 15, color: AppColors.greyIcon),
                              const SizedBox(width: 5),
                              ConstrainedBox(
                                constraints:
                                const BoxConstraints(maxWidth: 120),
                                child: Text(
                                  location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.customTextStyle(
                                    size: 12,
                                    weight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// 🔹 LOGO
                if (!isCategoryFlow)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.navBarColor,
                          width: 0.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          imageUrl,
                          height: 30,
                          width: 30,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.photo_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔹 EDUCATION + SKILLS
            Wrap(
              spacing: 10,
              runSpacing: 5,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Text(
                    "Education: $qualification",
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
                    "Skills: ${skillList.join(", ")}",
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

            const SizedBox(height: 10),

            /// 🔹 DURATION + STIPEND
            Wrap(
              spacing: 10,
              runSpacing: 5,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time,
                          size: 12, color: AppColors.greyIcon),
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
                  padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.currency_rupee,
                          size: 12, color: AppColors.greyIcon),
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

            const SizedBox(height: 10),

            /// 🔹 FOOTER
            Row(
              children: [
                Expanded(
                  child: Row(
                    spacing: 15,
                    children: [
                      Text(
                        "Posted ${AppFunctions.convertPostedDate(postedDate)}",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          color: AppColors.selectedContColor,
                        ),
                      ),
                      Text(
                        "Available: $position",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          color: AppColors.redColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.selectedContColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColors.whiteColor,
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