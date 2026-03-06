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
  final bool isApplied;
  final double width;
  final bool isSaved;
  List<String> skillList;

  InternshipCard({
    super.key,
    this.viewFunc,
    this.duration = "0",
    this.role = "",
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
    this.isApplied = false,
    this.width = double.infinity,
    this.isSaved = false,
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
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightWhiteCont,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  AppFunctions.convertPostedDate(postedDate),
                  style: AppStyles.customTextStyle(
                    size: 10,
                    weight: FontWeight.w400,
                    color: AppColors.blackLight,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.capitalize!,
                        style: AppStyles.customTextStyle(
                          color: AppColors.primaryColor,
                          size: 14,
                          weight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          SizedBox(
                            width: 210,
                            child: Text(
                              companyName.capitalize!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.customTextStyle(
                                size: 10,
                                weight: FontWeight.w400,
                                color: AppColors.selectedContColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: AppColors.greyIcon,
                          ),
                          Text(
                            internshipMode,
                            style: AppStyles.customTextStyle(
                              size: 8,
                              weight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
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
                        height: 40,
                        width: 40,
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
                ],
              ),

              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.customTextStyle(
                  size: 8,
                  lineSpace: 1.3,
                  weight: FontWeight.w400,
                  color: AppColors.blackColor,
                ),
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
                          size: 10,
                          color: AppColors.greyIcon,
                        ),
                        Text(
                          "Duration : $duration",
                          style: AppStyles.customTextStyle(
                            size: 8,
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
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.currency_rupee,
                          size: 10,
                          color: AppColors.greyIcon,
                        ),
                        Text(
                          "Stipend : $stipendRupees",
                          style: AppStyles.customTextStyle(
                            size: 8,
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
                  Expanded(
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "Education: ",
                                    style: AppStyles.customTextStyle(
                                      size: 8,
                                      weight: FontWeight.w400,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      qualification,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.customTextStyle(
                                        size: 8,
                                        weight: FontWeight.w400,
                                        color: AppColors.navBarColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "Available: ",
                                    style: AppStyles.customTextStyle(
                                      size: 8,
                                      weight: FontWeight.w400,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      eligibility,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.customTextStyle(
                                        size: 8,
                                        weight: FontWeight.w400,
                                        color: AppColors.navBarColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "*Skills: ",
                              style: AppStyles.customTextStyle(
                                size: 8,
                                weight: FontWeight.w400,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                skillList.join(', '),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.customTextStyle(
                                  size: 8,
                                  lineSpace: 1.3,
                                  weight: FontWeight.w400,
                                  color: AppColors.navBarColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Bookmark button
                  IconButton(
                    onPressed: saveFunc!,
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: AppColors.secondaryColor,
                      size: 30,
                    ),
                  ),
                ],
              )            ],
          ),
        ),
      ),
    );
  }
}
