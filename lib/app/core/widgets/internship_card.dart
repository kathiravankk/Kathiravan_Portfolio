import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

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
  final bool isCategoryFlow;
  final List<String> skillList;

  const InternshipCard({
    super.key,
    this.viewFunc,
    this.duration = "0",
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
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    role.capitalize!,
                    style: AppStyles.customTextStyle(
                      color: AppColors.disableButtonColor2,
                      size: 16,
                      weight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: saveFunc,
                    icon: Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightWhiteCont,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(5),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName.capitalize!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 14,
                          weight: FontWeight.w500,
                          color: AppColors.selectedContColor,
                        ),
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.work_history_outlined,
                                size: 15,
                                color: AppColors.greyIcon,
                              ),
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
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: AppColors.greyIcon,
                              ),
                              Text(
                                location,
                                style: AppStyles.customTextStyle(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: !isCategoryFlow,
                    child: Container(
                      padding: EdgeInsets.all(3),
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
                          //color: AppColors.whiteColor,
                          errorBuilder: (context, error, stackTrace) =>
                              CircleAvatar(
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
                            qualification,
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
                            skillList.join(", "),
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

              // Text(
              //   description,
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              //   style: AppStyles.customTextStyle(
              //     size: 8,
              //     lineSpace: 1.3,
              //     weight: FontWeight.w400,
              //     color: AppColors.blackColor,
              //   ),
              // ),
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
                      "Posted ${AppFunctions.convertPostedDate(postedDate)}",
                      style: AppStyles.customTextStyle(
                        size: 10,
                        weight: FontWeight.w500,
                        color: AppColors.blackLight,
                      ),
                    ),
                  ),
                  Container(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
