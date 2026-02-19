import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/internship_card.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/data/models/home/applied_internship_model.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/home/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

import '../../../data/models/home/recommand_internship_model.dart';

class ApplicationStatusScreen extends StatefulWidget {
  const ApplicationStatusScreen({super.key});

  @override
  State<ApplicationStatusScreen> createState() =>
      _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  ApplicationData? appliedData;
  List<RecommentedData> similarList = [];

  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    appliedData = Get.arguments["appliedData"];
    getSimilarData();
  }

  Future<void> getSimilarData() async {
    await dashboardController.getSimilarInternship(
      skillList: appliedData!.jobData!.requiredSkills ?? [],
    );
    if (dashboardController.getResponseCode() == 200 ||
        dashboardController.getResponseCode() == 201) {
      similarList =
          dashboardController.similarInternshipModel.similarList ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appliedData!.jobData!.title ?? "",
                style: AppStyles.customTextStyle(
                  size: 18,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),

              Text(
                appliedData!.jobData!.companyName ?? "",
                style: AppStyles.customTextStyle(
                  size: 16,
                  color: AppColors.secondaryColor,
                  weight: FontWeight.w400,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  appliedData!.jobData!.aboutCompany ?? "NA",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.lightBlackText2,
                    weight: FontWeight.w400,
                    //isUnderlined: true,
                    //underlineColor: AppColors.lightBlackText2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your Application Status',
                style: AppStyles.customTextStyle(
                  size: 16,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              Column(
                children: [
                  _buildStatusItem(
                    iconWidget: Icon(
                      Icons.check_circle_sharp,
                      color: AppColors.selectedContColor,
                      size: 20,
                    ),
                    title: 'Applied',
                    date: AppFunctions.formatIsoDate(
                      appliedData!.jobData!.createdAt ?? "",
                    ),
                    showLine: true,
                  ),
                  _buildStatusItem(
                    iconWidget: Icon(
                      Icons.check_circle_sharp,
                      color: AppColors.selectedContColor,
                      size: 20,
                    ),
                    title: 'Application Sent',
                    date: AppFunctions.formatIsoDate(
                      appliedData!.jobData!.createdAt ?? "",
                    ),
                    showLine: true,
                  ),
                  _buildStatusItem(
                    iconWidget: appliedData!.status != "Applied"
                        ? Icon(
                            Icons.check_circle_sharp,
                            color: AppColors.selectedContColor,
                            size: 20,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            color: AppColors.whiteColor,
                            size: 20,
                          ),
                    title: 'Application viewed by recruiter',
                    showLine: appliedData!.status != "Applied" ? true : false,
                  ),
                  Visibility(
                    visible: appliedData!.status != "Applied",
                    child: _buildStatusItem(
                      iconWidget:
                          appliedData!.status == "Selected" ||
                              appliedData!.status == "Shortlisted"
                          ? Icon(
                              Icons.check_circle_sharp,
                              color: AppColors.sucTextColor,
                              size: 20,
                            )
                          : Icon(
                              Icons.close,
                              color: AppColors.failTextColor,
                              size: 20,
                            ),
                      title: appliedData!.status!,
                      showLine: false,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Text(
                'Similar Internship',
                style: AppStyles.customTextStyle(
                  size: 16,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),

              dashboardController.similarInternshipLoading
                  ? Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.secondaryColor,
                      ),
                    )
                  : SizedBox(
                      height: 210,
                      child: similarList.isNotEmpty
                          ? Stack(
                              children: [
                                ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 10),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: similarList.length,
                                  itemBuilder: (context, index) {
                                    RecommentedData similar =
                                        similarList[index];
                                    return InternshipCard(
                                      width: 360,
                                      companyName: similar.companyName ?? "",
                                      isSaved: similar.isSaved ?? false,
                                      duration:
                                          similar.internshipDuration ?? "",
                                      saveFunc: () {
                                        similar.isSaved!
                                            ? removeToSaved(jobId: similar.sId!)
                                            : addToSaved(jobId: similar.sId!);
                                      },
                                      viewFunc: () {
                                        AppFunctions.navigateScreen(
                                          context,
                                          AppRoutes.internshipDetailScreen,
                                          arguments: {
                                            "internshipId": similar.sId,
                                          },
                                        );
                                      },
                                      eligibility:
                                          similar.eligibilityCriteria ?? "",
                                      qualification:
                                          similar.studentQualification ?? "",
                                      stipendRupees:
                                          similar.internshipStipend ?? "",
                                      description:
                                          similar.internshipDescription ?? "",
                                      imageUrl: similar.companyLogo ?? "",
                                      internshipMode:
                                          similar.internshipMode ?? "NA",
                                      role: similar.title ?? "",
                                      postedDate: similar.createdAt ?? "",
                                      skillList: similar.requiredSkills ?? [],
                                      isApplied: similar.applied ?? false,
                                    );
                                  },
                                ),
                                Visibility(
                                  visible:
                                      profileController
                                          .removeSavedJobsLoading ||
                                      profileController.addSavedJobsLoading,
                                  child: Positioned(
                                    child: Center(
                                      child: Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: AppColors.blackGradient2,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          spacing: 10,
                                          children: [
                                            CupertinoActivityIndicator(
                                              color: AppColors.secondaryColor,
                                            ),
                                            Text(
                                              profileController
                                                      .removeSavedJobsLoading
                                                  ? "Removing from saved posts..!"
                                                  : "Adding to saved posts..!",
                                              style: AppStyles.customTextStyle(
                                                size: 14,
                                                color: AppColors.secondaryColor,
                                                weight: FontWeight.w500,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : CustomEmptyWidget(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addToSaved({required String jobId}) async {
    await profileController.addSavedJobsData(jobId: jobId);
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message:
            profileController.savedJobModel.message ??
            "Internship added to your saved posts!",
      );
      await getSimilarData();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.savedJobModel.message ??
            "Something went wrong!, Please try again later",
      );
    }
  }

  Future<void> removeToSaved({required String jobId}) async {
    await profileController.removeSavedJobsData(jobId: jobId);
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message:
            profileController.savedJobModel.message ??
            "Internship removed from your saved posts!",
      );
      await getSimilarData();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.savedJobModel.message ??
            "Something went wrong!, Please try again later",
      );
    }
  }

  Widget _buildStatusItem({
    required Widget iconWidget,
    required String title,
    String date = "",
    required bool showLine,
  }) {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            iconWidget,
            if (showLine)
              Container(
                width: 2,
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white.withOpacity(0.3)],
                  ),
                ),
              ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyles.customTextStyle(
                size: 12,
                color: AppColors.whiteColor,
                weight: FontWeight.w400,
              ),
            ),
            if (date.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  date,
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: AppColors.darkText,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            SizedBox(height: showLine ? 20 : 0),
          ],
        ),
      ],
    );
  }
}
