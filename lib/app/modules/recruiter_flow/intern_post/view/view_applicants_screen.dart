import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/app_background_widget.dart';
import '../../../../data/models/recruiter_flow/applicants_model.dart';
import '../controller/internship_post_controller.dart';
import 'posted_internship_screen.dart' show CompanyLogo;

class ViewApplicantsScreen extends StatelessWidget {
  const ViewApplicantsScreen({
    super.key,
    required this.companyLogoUrl,
    required this.companyName,
    required this.roleType,
  });

  final String companyLogoUrl;
  final String companyName;
  final String roleType;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InternshipPostController>();
    return AppBackgroundWidget(
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  const SizedBox(width: 15),

                  CompanyLogo(logoUrl: companyLogoUrl),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 3,
                      children: [
                        Text(
                          companyName,
                          style: AppStyles.customTextStyle(
                            size: 16,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Icon(
                              CupertinoIcons.briefcase_fill,
                              size: 12,
                              color: AppColors.greyTextColor,
                            ),
                            Flexible(
                              child: Text(
                                roleType,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.customTextStyle(
                                  size: 13,
                                  color: AppColors.greyTextColor,
                                  weight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: .centerLeft,
                child: Text(
                  'Applicants (${controller.applicantsList.length})',
                  style: AppStyles.customTextStyle(
                    size: 16,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (controller.applicantsLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              else if (controller.applicantsList.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      "No applicants found",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.greyTextColor,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.applicantsList.length,
                    itemBuilder: (context, index) {
                      final applicant = controller.applicantsList[index];
                      return _ApplicantsCard(applicant: applicant);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplicantsCard extends StatelessWidget {
  const _ApplicantsCard({super.key, required this.applicant});

  final ApplicantsModel applicant;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.containerBgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Row(
              children: [
                Center(
                  child: CircleAvatar(
                    maxRadius: 35,
                    backgroundImage: NetworkImage(
                      applicant.studentDetails.studProfile ?? '',
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .start,
                  children: [
                    Text(
                      applicant.studentDetails.studName ?? '',
                      style: AppStyles.customTextStyle(
                        size: 15,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.emeraldBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          child: Text(
                            'Applied',
                            style: AppStyles.customTextStyle(
                              size: 13,
                              color: AppColors.emeraldColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '• Applied on',
                          style: AppStyles.customTextStyle(
                            size: 13,
                            color: AppColors.greyTextColor,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                const SizedBox(width: 70),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.darkGrayColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        CupertinoIcons.eye,
                        size: 16,
                        color: AppColors.whiteColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'View',
                        style: AppStyles.customTextStyle(
                          size: 13,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.darkGrayColor,
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        CupertinoIcons.bookmark,
                        size: 16,
                        color: AppColors.whiteColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Shortlist',
                        style: AppStyles.customTextStyle(
                          size: 13,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
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
