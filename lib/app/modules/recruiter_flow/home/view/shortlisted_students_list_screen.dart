import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/student_detail_card.dart';
import 'package:internsharks/app/data/models/recruiter_flow/shortlisted_students_data_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

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
              Icons.arrow_back,
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
              color: AppColors.secondaryColor,
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
                  child: studentsList!.isNotEmpty
                      ? ListView.separated(
                          padding: EdgeInsets.fromLTRB(20,20,20,20),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 15),
                          itemCount: studentsList!.length,
                          itemBuilder: (context, index) {
                            return buildApplicantCard(
                              viewFunc: (){
                                AppFunctions.navigateScreen(
                                  context,
                                  AppRoutes.internProfileViewScreen,
                                  arguments: {"studentId": studentsList![index].student!.id},
                                );
                              },
                              applicant: studentsList![index],
                              isShortList:
                                  studentsList![index].status == "Shortlisted"
                                  ? true
                                  : false,
                              shortlistFunc: () async {
                                setState(() {});
                                await homeController.shortlistStudentToggleFunc(
                                  index,
                                  studentsList![index],
                                );
                                setState(() {});
                              },
                            );
                            //   StudentDetailCard(
                            //   // isLoading:
                            //   //     homeController.addShortlistLoading ||
                            //   //     homeController.removeShortlistLoading,
                            //   shortlistFunc: () async {
                            //     setState(() {});
                            //     await homeController.shortlistStudentToggleFunc(
                            //       index,
                            //       studentsList![index],
                            //     );
                            //     setState(() {});
                            //   },
                            //   requestFunc: () {},
                            //   studentName:
                            //       studentsList![index].student!.studName ?? "",
                            //   studentProfile:
                            //       studentsList![index].student!.studProfile ??
                            //       "",
                            //   studentDegree:
                            //       studentsList![index].student!.studentdegree ??
                            //       "",
                            //   studentCollegeName:
                            //       studentsList![index]
                            //           .student!
                            //           .studentcollegename ??
                            //       "",
                            //   studentDepartment:
                            //       studentsList![index]
                            //           .student!
                            //           .studentfieldofstudy ??
                            //       "",
                            //   isVerified:
                            //       studentsList![index].student!.isVerified ??
                            //       false,
                            //   isShortList:
                            //       studentsList![index].status == "Shortlisted"
                            //       ? true
                            //       : false,
                            // );
                          },
                        )
                      : CustomEmptyWidget(),
                ),
        ),
      ),
    );
  }

  Widget buildApplicantCard({
    required ShortlistedData applicant,
    required bool isShortList,
    required VoidCallback? shortlistFunc,
    required VoidCallback? viewFunc,
  }) {
    return GestureDetector(
      onTap: viewFunc,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.recContColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              spacing: 15,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.whiteColor.withOpacity(0.1),
                  backgroundImage:
                      (applicant.student!.studProfile ?? "").isNotEmpty
                      ? NetworkImage(applicant.student!.studProfile ?? "")
                      : null,
                  child: (applicant.student!.studProfile ?? "").isEmpty
                      ? Icon(Icons.person, color: AppColors.whiteColor)
                      : null,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.lightBorderColor,
                              ),
                              color: AppColors.lightContColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            child: Text(
                              "Shortlisted",
                              style: AppStyles.customTextStyle(
                                size: 10,
                                color: AppColors.whiteColor,
                                weight: FontWeight.w400,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: shortlistFunc!,
                            icon: isShortList
                                ? Icon(
                                    Icons.bookmark,
                                    color: AppColors.secondaryColor,
                                  )
                                : Icon(
                                    Icons.bookmark_border_sharp,
                                    color: AppColors.secondaryColor,
                                  ),
                          ),
                        ],
                      ),
                      Text(
                        applicant.student!.studName ?? "",
                        style: AppStyles.customTextStyle(
                          size: 16,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildInfoRow(
              Icons.email_outlined,
              applicant.student!.studEmail ?? "",
            ),
            _buildInfoRow(
              Icons.school_outlined,
              applicant.student!.studentfieldofstudy ?? "",
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List<Widget>.from(
                (applicant.student!.studprogramminglang as List? ?? []).map(
                  (skill) => _buildSkillChip(skill.toString()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeContainer({required String type}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorderColor),
        color: type == "STIPEND"
            ? AppColors.lightContColor2
            : type == "FEES"
            ? AppColors.lightContColor
            : AppColors.transparentColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        spacing: 5,
        mainAxisAlignment: .center,
        children: [
          Icon(
            type == "STIPEND"
                ? Icons.work_history_outlined
                : type == "FEES"
                ? Icons.school_outlined
                : Icons.currency_rupee_rounded,
            color: type == "STIPEND"
                ? AppColors.blueTextColor
                : type == "FEES"
                ? AppColors.primaryColor
                : AppColors.whiteColor,
            size: 16,
          ),
          Text(
            type,
            style: AppStyles.customTextStyle(
              size: 12,
              color: type == "STIPEND"
                  ? AppColors.blueTextColor
                  : type == "FEES"
                  ? AppColors.primaryColor
                  : AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPill() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.sucBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.check_circle,
        color: AppColors.sucTextColor,
        size: 15,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.whiteColor.withOpacity(0.6)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.whiteColor.withOpacity(0.75),
              weight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        skill,
        style: AppStyles.customTextStyle(
          size: 12,
          color: AppColors.primaryColor,
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}
