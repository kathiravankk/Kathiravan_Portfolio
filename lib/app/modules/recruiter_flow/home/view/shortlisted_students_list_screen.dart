import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/student_detail_card.dart';
import 'package:internsharks/app/data/models/recruiter_flow/shortlisted_students_data_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';

class ShortlistedStudentsListScreen extends StatefulWidget {
  const ShortlistedStudentsListScreen({super.key});

  @override
  State<ShortlistedStudentsListScreen> createState() =>
      _ShortlistedStudentsListScreenState();
}

class _ShortlistedStudentsListScreenState
    extends State<ShortlistedStudentsListScreen> {
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();

  @override
  void initState() {
    getStudentsListData();
    super.initState();
  }

  List<ShortlistedData>? studentsList = [];

  Future<void> getStudentsListData() async {
    try {
      await homeController.getShortlistStudentsList();
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        setState(() {
          studentsList = homeController.shortlistModel.shortlistedData ?? [];
          debugPrint(studentsList.toString());
        });
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
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
          backgroundColor: AppColors.transparentColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
          automaticallyImplyActions: false,
          title: Text(
            "Shortlisted Students",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => homeController.shortlistStudentLoading
              ? AppAlertUtils.customLoader()
              : RefreshIndicator(
                  color: AppColors.primaryColor,
                  backgroundColor: AppColors.appBgColor_2,
                  onRefresh: () async {
                    await getStudentsListData();
                  },

                  child: GridView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: studentsList!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.65,
                        ),
                    itemBuilder: (context, index) {
                      return StudentDetailCard(
                        // isLoading:
                        //     homeController.addShortlistLoading ||
                        //     homeController.removeShortlistLoading,
                        shortlistFunc: () async {
                          setState(() {});
                          await homeController.shortlistStudentToggleFunc(
                            index,
                            studentsList![index],
                          );
                          setState(() {});
                        },
                        requestFunc: () {},
                        studentName:
                            studentsList![index].student!.studName ?? "",
                        studentProfile:
                            studentsList![index].student!.studProfile ?? "",
                        studentDegree:
                            studentsList![index].student!.studentdegree ?? "",
                        studentCollegeName:
                            studentsList![index].student!.studentcollegename ??
                            "",
                        studentDepartment:
                            studentsList![index].student!.studentfieldofstudy ??
                            "",
                        isVerified:
                            studentsList![index].student!.isVerified ?? false,
                        isShortList:
                            studentsList![index].status == "Shortlisted"
                            ? true
                            : false,
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
