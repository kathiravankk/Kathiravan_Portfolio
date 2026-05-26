import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/saved_internship_card.dart';
import 'package:internsharks/app/data/models/home/saved_internship_model.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class SavedInternshipScreen extends StatefulWidget {
  const SavedInternshipScreen({super.key});

  @override
  State<SavedInternshipScreen> createState() => _SavedInternshipScreenState();
}

class _SavedInternshipScreenState extends State<SavedInternshipScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  List<SavedJobData>? savedJobs = [];

  @override
  void initState() {
    super.initState();
    getSavedJobsData();
  }

  Future<void> getSavedJobsData() async {
    await profileController.getSavedJobsData();

    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      savedJobs = profileController.savedJobModel.jobData ?? [];
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.savedJobModel.message ?? "Something went wrong!",
      );
    }
  }

  bool isAlreadySaved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.loginBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Saved Internships",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => profileController.savedJobsLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.secondaryColor,
                  ),
                )
              : savedJobs!.isNotEmpty
              ? Stack(
                  children: [
                    ListView.separated(
                      padding: EdgeInsets.all(20),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: savedJobs!.length,
                      itemBuilder: (context, index) => SavedInternshipCard(
                        jobTitle: savedJobs![index].job!.roleType ?? "",
                        companyLogo: savedJobs![index].job!.companyLogo ?? "",
                        postedDate: savedJobs![index].updatedAt ?? "",
                        companyName: savedJobs![index].job!.companyName ?? "",
                        qualification: savedJobs![index]
                            .job!
                            .studentQualification!
                            .join(",")
                            .toString(),
                        duration:
                            savedJobs![index]
                                    .job!
                                    .internshipDuration!
                                    .isNotEmpty &&
                                savedJobs![index].job!.internshipDuration !=
                                    null
                            ? "${savedJobs![index].job!.internshipDuration!} Months"
                            : "${savedJobs![index].job!.days} Days",
                        stipendRupees:
                            savedJobs![index].job!.internshipStipend ?? "NA",

                        skillList: savedJobs![index].job!.requiredSkills ?? [],
                        internFees:
                            savedJobs![index].job!.fees != null &&
                                savedJobs![index].job!.fees!.isNotEmpty
                            ? savedJobs![index].job!.fees!
                            : 'NA',
                        isApplyFunc: () {
                          AppFunctions.navigateScreen(
                            context,
                            AppRoutes.internshipDetailScreen,
                            arguments: {
                              "internshipId": savedJobs![index].job!.id,
                            },
                          );
                        },
                        isViewFunc: () {
                          AppFunctions.navigateScreen(
                            context,
                            AppRoutes.internshipDetailScreen,
                            arguments: {
                              "internshipId": savedJobs![index].job!.id,
                            },
                          );
                        },
                        isSaveFunc: () {
                          removeToSaved(jobId: savedJobs![index].job!.id ?? "");
                        },
                      ),
                    ),
                    Visibility(
                      visible: profileController.removeSavedJobsLoading,
                      child: Positioned(
                        child: Center(
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.blackGradient2,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                CupertinoActivityIndicator(
                                  color: AppColors.secondaryColor,
                                ),
                                Text(
                                  "Removing from saved posts..!",
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
      ),
    );
  }

  // Future<void> addToSaved({required String jobId}) async {
  //   await profileController.addSavedJobsData(jobId: jobId);
  //   if (profileController.getResponseCode() == 200 ||
  //       profileController.getResponseCode() == 201) {
  //     AppFunctions.showToast(
  //       message:
  //           profileController.savedJobModel.message ??
  //           "Internship added to your saved posts!",
  //     );
  //     await getSavedJobsData();
  //   } else {
  //     AppFunctions.apiErrorHandling(
  //       profileController.getResponseCode(),
  //       profileController.savedJobModel.message ??
  //           "Something went wrong!, Please try again later",
  //     );
  //   }
  // }

  Future<void> removeToSaved({required String jobId}) async {
    await profileController.removeSavedJobsData(jobId: jobId);
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
            profileController.savedJobModel.message ??
            "Internship removed from your saved posts!",
      );
      await getSavedJobsData();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.savedJobModel.message ??
            "Something went wrong!, Please try again later",
      );
    }
  }
}
