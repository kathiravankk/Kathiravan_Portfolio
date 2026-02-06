import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class AppliesInternshipCard extends StatelessWidget {
  final String? role;
  final VoidCallback? viewFunc;
  final String? companyName;
  final String? companyLocation;
  final String? companyDescription;
  final String? appliedOn;
  final String? companyLogo;

  const AppliesInternshipCard({
    super.key,
     this.role = "",
     this.companyName ="",
     this.companyLocation ="",
     this.companyDescription="",
     this.appliedOn ="",
     this.companyLogo="", this.viewFunc,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: viewFunc,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.navBarColor, width: 0.5),
                  ),
                  child: Image.network(
                    companyLogo!,
                    height: 40,
                    width: 40,
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
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role!,
                      style: AppStyles.customTextStyle(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Text(
                          companyName!,
                          style: AppStyles.customTextStyle(
                            size: 12,
                            weight: FontWeight.w400,
                            color: AppColors.selectedContColor,
                          ),
                        ),
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: AppColors.greyIcon,
                        ),
                        Text(
                          companyLocation!,
                          style: AppStyles.customTextStyle(
                            size: 10,
                            weight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Text(
              companyDescription!,
              style: AppStyles.customTextStyle(
                size: 10,
                weight: FontWeight.w400,
                lineSpace: 1.3,
                color: AppColors.blackColor,
              ),
            ),
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.selectedContColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: const Icon(
                      Icons.check_sharp,
                      color: AppColors.whiteColor,
                      size: 10,
                    ),
                  ),
                  Text(
                    "Applied ${AppFunctions.convertPostedDate(appliedOn!)}",
                    style: AppStyles.customTextStyle(
                      size: 10,
                      weight: FontWeight.w400,
                      color: AppColors.selectedContColor,
                    )    ,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
