import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/internship_card.dart';
import 'package:internsharks/app/data/models/home/category_list_model.dart';
import 'package:internsharks/app/data/models/home/category_wise_internship_model.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/home/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class CategoryWiseInternshipScreen extends StatefulWidget {
  const CategoryWiseInternshipScreen({super.key});

  @override
  State<CategoryWiseInternshipScreen> createState() =>
      _CategoryWiseInternshipScreenState();
}

class _CategoryWiseInternshipScreenState
    extends State<CategoryWiseInternshipScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final ProfileController profileController = Get.find<ProfileController>();

  CategoryListData? categoryData;
  List<InternshipData>? internshipList = [];

  @override
  void initState() {
    super.initState();
    categoryData = Get.arguments["categoryData"];
    getInternshipData();
  }

  Future<void> getInternshipData() async {
    await dashboardController.getCategoryInternshipData(
      categoryId: categoryData!.categoryId ?? "",
    );
    if (dashboardController.getResponseCode() == 200 ||
        dashboardController.getResponseCode() == 201) {
      internshipList = dashboardController.categoryInternshipModel.jobs ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => dashboardController.categoryInternshipLoading
          ? Center(
              child: CupertinoActivityIndicator(
                color: AppColors.secondaryColor,
              ),
            )
          : Scaffold(
              backgroundColor: AppColors.blackColor,
              appBar: AppBar(
                backgroundColor: AppColors.blackColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.back(),
                ),
                title: Text(
                  categoryData!.categoryName ?? "",
                  style: AppStyles.customTextStyle(
                    size: 18,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              body: internshipList!.isNotEmpty
                  ? Stack(
                      children: [
                        ListView.separated(
                          padding: EdgeInsets.all(15),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10),
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
                            saveFunc: () {
                              internshipList![index].isSaved!
                                  ? removeToSaved(
                                      jobId: internshipList![index].sId!,
                                    )
                                  : addToSaved(
                                      jobId: internshipList![index].sId!,
                                    );
                            },
                            isSaved: internshipList![index].isSaved ?? false,
                            postedDate: internshipList![index].createdAt!,
                            role: internshipList![index].title ?? "",
                            companyName:
                                internshipList![index].companyName ?? "",
                            internshipMode:
                                internshipList![index].internshipMode ?? "NA",
                            imageUrl: internshipList![index].companyLogo ?? "",
                            description:
                                internshipList![index].internshipDescription ??
                                "",
                            duration:
                                internshipList![index].internshipDuration ??
                                "NA",
                            stipendRupees:
                                internshipList![index].internshipStipend ??
                                "NA",
                            qualification:
                                internshipList![index].studentQualification ??
                                "All",
                            eligibility:
                                internshipList![index].eligibilityCriteria ??
                                "All",
                            skillList:
                                internshipList![index].requiredSkills ?? [],
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
