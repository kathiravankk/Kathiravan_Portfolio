import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/internship_card.dart';
import 'package:internsharks/app/data/models/home/recommand_internship_model.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/home/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class RecommentedInternshipScreen extends StatefulWidget {
  const RecommentedInternshipScreen({super.key});

  @override
  State<RecommentedInternshipScreen> createState() =>
      _RecommentedInternshipScreenState();
}

class _RecommentedInternshipScreenState
    extends State<RecommentedInternshipScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final ProfileController profileController = Get.find<ProfileController>();

  List<RecommentedData>? internshipList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInternshipData();
    });
  }

  Future<void> getInternshipData() async {
    await dashboardController.getRecommentedInternship();
    if (dashboardController.getResponseCode() == 200 ||
        dashboardController.getResponseCode() == 201) {
      internshipList =
          dashboardController.recommentedModel.internshipList ?? [];
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
        title: Text(
          "Recommended Internship",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => dashboardController.recommentedInternshipLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.secondaryColor,
                ),
              )
            : internshipList!.isNotEmpty
            ? Stack(
                children: [
                  ListView.separated(
                    padding: EdgeInsets.all(15),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: internshipList!.length,
                    itemBuilder: (context, index) => InternshipCard(
                      viewFunc: () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.internshipDetailScreen,
                          arguments: {
                            "internshipId": internshipList![index].sId,
                          },
                        );
                      },
                      isSaved: internshipList![index].isSaved ?? false,
                      saveFunc: () {
                        internshipList![index].isSaved!
                            ? removeToSaved(jobId: internshipList![index].sId!)
                            : addToSaved(jobId: internshipList![index].sId!);
                      },
                      postedDate: internshipList![index].createdAt!,
                      role: internshipList![index].title ?? "",
                      companyName: internshipList![index].companyName ?? "",
                      internshipMode:
                          internshipList![index].internshipMode ?? "NA",
                      imageUrl: internshipList![index].companyLogo ?? "",
                      description:
                          internshipList![index].internshipDescription ?? "",
                      duration:
                          internshipList![index].internshipDuration ?? "NA",
                      stipendRupees:
                          internshipList![index].internshipStipend ?? "NA",
                      qualification:
                          internshipList![index].studentQualification ?? "All",
                      eligibility:
                          internshipList![index].eligibilityCriteria ?? "All",
                      skillList: internshipList![index].requiredSkills ?? [],
                      isApplied: internshipList![index].applied ?? false,
                    ),
                  ),
                  Visibility(
                    visible:
                        profileController.removeSavedJobsLoading ||
                        profileController.addSavedJobsLoading,
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
                                profileController.removeSavedJobsLoading
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
      await getInternshipData();
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
      await getInternshipData();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.savedJobModel.message ??
            "Something went wrong!, Please try again later",
      );
    }
  }
}
