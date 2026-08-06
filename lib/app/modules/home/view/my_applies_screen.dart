import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart' show AppStyles;
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/applies_internship_card.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/data/models/home/applied_internship_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class MyAppliesScreen extends StatefulWidget {
  final bool showBack;

  const MyAppliesScreen({super.key, this.showBack = false});

  @override
  State<MyAppliesScreen> createState() => MyAppliesScreenState();
}

class MyAppliesScreenState extends State<MyAppliesScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  List<ApplicationData>? appliedList = [];
  String? studentId = "";
  
  Future<void> refreshData()async{
    await getInternshipData();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInternshipData();
    });
  }

  Future<void> getInternshipData() async {
    studentId = await LocalStorageService.getStudentId();
    debugPrint(studentId);
    await dashboardController.getAppliedInternship(studentId: studentId!);
    if (dashboardController.getResponseCode() == 200 ||
        dashboardController.getResponseCode() == 201) {
      appliedList = dashboardController.appliedModel.applicationList ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.whiteColor),
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          automaticallyImplyActions: false,
          centerTitle: true,
          title: Text(
            "My Application",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => dashboardController.appliedInternshipLoading
              ? AppAlertUtils.customLoader()
              : appliedList!.isNotEmpty
              ? RefreshIndicator(
                  backgroundColor: AppColors.appBgColor_2,
                  color: AppColors.primaryColor,
                  onRefresh: () => getInternshipData(),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: appliedList!.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 100,
                      top: 20,
                    ),
                    itemBuilder: (context, index) {
                      final item = appliedList![index];
                      return AppliesInternshipCard(
                        internshipType: item.jobData != null
                            ? item.jobType ?? "NA"
                            : "NA",
                        viewFunc: item.jobData != null
                            ? () {
                                AppFunctions.navigateScreen(
                                  context,
                                  AppRoutes.applicationStatusScreen,
                                  arguments: {"appliedData": item},
                                );
                              }
                            : () {
                                AppAlertUtils.showToast(
                                  message: "No Job Data Available! (or) Its Existed!",isError: true
                                );
                        },
                        role: item.jobData != null
                            ? item.jobData!.roleType
                            : "",
                        companyName: item.jobData != null
                            ? item.jobData!.companyName
                            : "",
                        companyLocation: item.jobData != null
                            ? item.jobData!.internshipMode
                            : "",
                        duration: item.jobData != null
                            ? item.jobData!.internshipDuration!.isNotEmpty &&
                                      item.jobData!.internshipDuration != null
                                  ? "${item.jobData!.internshipDuration} Months"
                                  : "${item.jobData!.days} Days"
                            : "N/A",
                        // companyDescription: item.jobData != null
                        //     ? item.jobData!.aboutCompany
                        //     : "",
                        // appliedOn: item.jobData != null ? item.createdAt : "",
                        companyLogo: item.jobData != null
                            ? item.jobData!.companyLogo
                            : "",
                      );
                    },
                  ),
                )
              : CustomEmptyWidget(),
        ),
      ),
    );
  }
}
