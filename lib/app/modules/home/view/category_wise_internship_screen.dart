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
                  ? ListView.separated(
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
                        applyFunc: () {},
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
                            internshipList![index].studentQualification ??
                            "All",
                        eligibility:
                            internshipList![index].eligibilityCriteria ?? "All",
                        skillList: internshipList![index].requiredSkills ?? [],
                        isApplied: internshipList![index].applied ?? false,
                      ),
                    )
                  : CustomEmptyWidget(),
            ),
    );
  }
}
