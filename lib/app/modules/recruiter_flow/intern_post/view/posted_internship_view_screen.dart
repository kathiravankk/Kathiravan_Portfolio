import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/app_background_widget.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/view/recruiter_review_dialog.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class PostedInternshipViewScreen extends StatefulWidget {
  const PostedInternshipViewScreen({super.key});

  @override
  State<PostedInternshipViewScreen> createState() =>
      _PostedInternshipViewScreenState();
}

class _PostedInternshipViewScreenState
    extends State<PostedInternshipViewScreen> {
  final InternshipPostController postController =
  Get.find<InternshipPostController>();

  PostData? internshipData;


  @override
  void initState() {
    super.initState();
    internshipData = Get.arguments["internshipData"] ?? PostData();
  }


  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
        appBarWidget: AppBar(
          elevation: 0,
          backgroundColor: AppColors.transparentColor,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(
                    Icons.arrow_back_ios, color: AppColors.whiteColor),
                onPressed: () => Get.back(),
              ),
              Expanded(
                child: Text(
                  "Internship Details",
                  style: AppStyles.customTextStyle(
                    size: 19,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Get.dialog(
                  RecruiterReviewDialog(internshipId: internshipData!.id ?? ""),
                  barrierDismissible: true,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    Text(
                      "Internship Review",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.primaryColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15,)
          ],
        ),
        bodyWidget:
        internshipData == null
            ? CustomEmptyWidget()
            : ListView(
          children: [
            _buildCompanyCard(internshipData!),
            const SizedBox(height: 20),
            _buildSectionCard(
              icon: Icons.description_outlined,
              iconColor: AppColors.purpleColor,
              title: "About This Internship",
              child: Text(
                internshipData!.aboutInternship ??
                    "This internship is designed for students who are passionate about learning and working on real-time projects. You will get hands-on experience and improve your skills.",
                style: AppStyles.customTextStyle(
                  color: AppColors.greyTextColor,
                  size: 14,
                  weight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.local_activity_outlined,
              iconColor: AppColors.selectedContColor,
              title: "Project Description",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                (internshipData!.projectDescription ??
                    [
                      "Assist in development and testing of applications",
                      "Work on assigned modules and tasks",
                      "Collaborate with the team to deliver quality solutions",
                      "Learn and implement new technologies",
                    ])
                    .map<Widget>((r) => _bulletPoint(r))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.code,
              iconColor: AppColors.orangeColor,
              title: "Skills Required",
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                (internshipData!.requiredSkills ??
                    ["HTML", "CSS", "JavaScript", "React", "Git"])
                    .map<Widget>((s) => _chip(s))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.school_outlined,
              iconColor: AppColors.correctText,
              title: "Eligibility Criteria",
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: (internshipData!.studentQualification ?? ["BCA"])
                    .map<Widget>((e) => _chip(e))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            _buildPostedDeadlineRow(internshipData!),
            const SizedBox(height: 20),
            CustomButtonWidget(
              disable: internshipData!.totalApplicants == 0,
                buttonFunction: () {
              AppFunctions.navigateScreen(
                context,
                AppRoutes.applicantsListScreen,
                arguments: {
                  "jobId": internshipData!.id,
                  "companyLogoUrl": internshipData!.companyLogo,
                  "companyName": internshipData!.companyName,
                  "roleType": internshipData!.roleType,
                  "internshipData": internshipData,
                  "projectList": internshipData!.projectDescription,
                },
              );
            },
              buttonWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 6,
                children: [
                  const Icon(Icons.remove_red_eye_outlined, size: 20, color: AppColors.blackColor),
                  Text(
                    internshipData!.totalApplicants == 0 ? 'No Applicants' : 'View Applicants',
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.blackColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                  internshipData!.totalApplicants == 0
                      ? SizedBox.shrink()
                      : Text(
                        "(${internshipData!.totalApplicants.toString()})",
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: AppColors.blackColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                ],
              ),
            )
          ],
        )
    );
  }

  Widget _buildCompanyCard(PostData internship) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.recContColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child:
                internship.companyLogo != null &&
                    internship.companyLogo!.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    internship.companyLogo!,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(
                  Icons.touch_app,
                  color: Colors.black54,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,

                  children: [
                    Text(
                      internship.companyName ?? "Company",
                      style: AppStyles.customTextStyle(
                        size: 18,
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.work_outline,
                          size: 16,
                          color: AppColors.greyIcon,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            internship.roleType ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppStyles.customTextStyle(
                              color: AppColors.greyTextColor,
                              size: 16,
                              weight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${(internship.selectedApplicants ?? 2).toString()} ACTIVE",
                  style: AppStyles.customTextStyle(
                    color: Colors.black,
                    size: 12,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.selectedContColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    spacing: 15,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _infoTile(
                              icon: CupertinoIcons.location_solid,
                              iconColor: AppColors.inCorrectText,
                              label: "Location",
                              value: internship.companyCity ?? "-",
                            ),
                          ),
                          Expanded(
                            child: _infoTile(
                              icon: Icons.access_time,
                              iconColor: AppColors.appYellow,
                              label: "Duration",
                              value:
                              internship.internshipDuration != null &&
                                  internship.internshipDuration!.isNotEmpty
                                  ? "${internship.internshipDuration} Months"
                                  : "${internship.days} Days",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _infoTile(
                              icon: Icons.currency_rupee,
                              iconColor: AppColors.primaryColor,
                              label: "Compensation",
                              value: internship.internshipStipend != "N/A"
                                  ? "Stipend : ${internship.internshipStipend}"
                                  : internship.fee != "0"
                                  ? "Fees : ${internship.fee}"
                                  : "Free Internship",
                            ),
                          ),
                          Expanded(
                            child: _infoTile(
                              icon: Icons.calendar_today_outlined,
                              iconColor: AppColors.orangeColor2,
                              label: "Posted",
                              value: AppFunctions.formatIsoDate(
                                internship.createdAt ?? "",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                const Icon(
                                  Icons.school_outlined,
                                  size: 16,
                                  color: AppColors.primaryColor,
                                ),
                                Text(
                                  "Eligibility: ",
                                  style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 13.5,
                                  ),
                                ),
                                ...(internship.studentQualification ?? ["BE", "BSC", "BBA"])
                                    .map<Widget>((s) => _chip(s)),
                              ],
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(icon, size: 15, color: iconColor),
            Text(
              label,
              style: AppStyles.customTextStyle(
                size: 12,
                color: AppColors.lightColorText,
                weight: FontWeight.w300,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: AppStyles.customTextStyle(
            size: 14,
            color: AppColors.whiteColor,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.recContColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppStyles.customTextStyle(
                  size: 18,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppStyles.customTextStyle(
                color: AppColors.greyTextColor,
                size: 14,
                weight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppStyles.customTextStyle(
          size: 12,
          weight: FontWeight.w300,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }

  Widget _buildPostedDeadlineRow(PostData internship) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.recContColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        spacing: 15,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: AppColors.pinkColor,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      "Posted On",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.lightColorText,
                        weight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      AppFunctions.formatIsoDate(internship.createdAt ?? ""),
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.lightColorText,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(width: 1, height: 36, color: AppColors.dividerContColor),
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.countertops_outlined,
                  size: 20,
                  color: AppColors.orangeColor2,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      "Position",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.lightColorText,
                        weight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      internship.noOfPosition.toString(),
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.lightColorText,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
