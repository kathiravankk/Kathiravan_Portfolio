import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/internship_card.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class AllInternshipScreen extends StatefulWidget {
  const AllInternshipScreen({super.key});

  @override
  State<AllInternshipScreen> createState() => _AllInternshipScreenState();
}

class _AllInternshipScreenState extends State<AllInternshipScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final TextEditingController searchController = TextEditingController();

  String companyState = "";
  String companyCity = "";
  String qualification = "";
  String duration = "";
  String stipend = "";
  String internshipMode = "";

  @override
  void initState() {
    getInternshipData();
    super.initState();
  }

  Future<void> getInternshipData() async {
    await dashboardController.getAllInternship(
      companyState: companyState,
      companyCity: companyCity,
      qualification: qualification,
      duration: duration,
      stipend: stipend,
      internshipMode: internshipMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor_2,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Search Internships',
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 15,
            children: [
              _buildSearchBar(),
              Expanded(
                child: dashboardController.allInternshipLoading
                    ? Center(
                        child: CupertinoActivityIndicator(
                          color: AppColors.secondaryColor,
                        ),
                      )
                    : dashboardController.internshipModel.internship!.isEmpty
                    ? CustomEmptyWidget()
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: dashboardController
                            .internshipModel
                            .internship!
                            .length,
                        itemBuilder: (context, index) => InternshipCard(
                          viewFunc: () {
                            AppFunctions.navigateScreen(
                              context,
                              AppRoutes.internshipDetailScreen,
                              arguments: {
                                "internshipId": dashboardController
                                    .internshipModel
                                    .internship![index]
                                    .id,
                              },
                            );
                          },
                          isSaved:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .isSaved ??
                              false,
                          //saveFunc: () => dashboardController.toggleSave(index),
                          saveFunc: () {},
                          postedDate: dashboardController
                              .internshipModel
                              .internship![index]
                              .createdAt!,
                          role:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .title ??
                              "",
                          companyName:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .companyName ??
                              "",
                          internshipMode:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .internshipMode ??
                              "NA",
                          imageUrl:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .companyLogo ??
                              "",
                          description:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .internshipDescription ??
                              "",
                          duration:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .internshipDuration ??
                              "NA",
                          stipendRupees:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .internshipStipend ??
                              "NA",
                          qualification:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .studentQualification ??
                              "All",
                          eligibility:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .eligibilityCriteria ??
                              "All",
                          skillList:
                              dashboardController
                                  .internshipModel
                                  .internship![index]
                                  .requiredSkills ??
                              [],
                          isApplied: false,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.lightWhiteCont,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        spacing: 15,
        children: [
          SizedBox(),
          Icon(CupertinoIcons.search, color: AppColors.lightHintText, size: 25),
          Expanded(
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {},
              onChanged: (value) {
                searchController.text = value;
              },
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.blackColor,
                weight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Search here..',
                hintStyle: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.lightHintText,
                  weight: FontWeight.w400,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.tune,
              color: AppColors.lightHintText,
              size: 25,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
