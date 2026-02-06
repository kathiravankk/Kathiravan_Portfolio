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
            ? ListView.separated(
                padding: EdgeInsets.all(15),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: internshipList!.length,
                itemBuilder: (context, index) => InternshipCard(
                  viewFunc: () {
                    AppFunctions.navigateScreen(
                      context,
                      AppRoutes.internshipDetailScreen,
                      arguments: {"internshipId": internshipList![index].sId},
                    );
                  },
                  applyFunc: () {},
                  postedDate: internshipList![index].createdAt!,
                  role: internshipList![index].title ?? "",
                  companyName: internshipList![index].companyName ?? "",
                  internshipMode: internshipList![index].internshipMode ?? "NA",
                  imageUrl: internshipList![index].companyLogo ?? "",
                  description:
                      internshipList![index].internshipDescription ?? "",
                  duration: internshipList![index].internshipDuration ?? "NA",
                  stipendRupees:
                      internshipList![index].internshipStipend ?? "NA",
                  qualification:
                      internshipList![index].studentQualification ?? "All",
                  eligibility:
                      internshipList![index].eligibilityCriteria ?? "All",
                  skillList: internshipList![index].requiredSkills ?? [],
                  isApplied: internshipList![index].applied ?? false,
                ),
              )
            : CustomEmptyWidget()
      ),
    );
  }
}
