import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/app_background_widget.dart';
import '../../../../data/models/recruiter_flow/applicants_list_model.dart';
import '../controller/internship_post_controller.dart';
import 'posted_internship_screen.dart' show CompanyLogo;

class ApplicantsListScreen extends StatefulWidget {
  const ApplicantsListScreen({super.key});

  @override
  State<ApplicantsListScreen> createState() => _ApplicantsListScreenState();
}

class _ApplicantsListScreenState extends State<ApplicantsListScreen> {
  final InternshipPostController applicationController =
      Get.find<InternshipPostController>();

  String jobId = "";
  String companyLogoUrl = "";
  String companyName = "";
  String roleType = "";
  List<String> projectList = [];
  PostData? internshipData;

  @override
  void initState() {
    super.initState();
    jobId = Get.arguments["jobId"] ?? "";
    companyLogoUrl = Get.arguments["companyLogoUrl"] ?? "";
    companyName = Get.arguments["companyName"] ?? "";
    roleType = Get.arguments["roleType"] ?? "";
    roleType = Get.arguments["roleType"] ?? "";
    projectList = Get.arguments["projectList"] ?? [];
    internshipData = Get.arguments["internshipData"] ?? PostData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInitialData();
    });
  }

  Future<void> getInitialData() async {
    try {
      await applicationController.getApplicants(
        jobId: jobId,
        status: "",
      );
      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
      } else {
        AppAlertUtils.showToast(
          message: "Something went wrong!, Try again later",
          isError: true,
        );
      }
    } catch (error) {
      AppAlertUtils.showToast(
        message: "Something went wrong!, Try again later",
        isError: true,
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBarWidget: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparentColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
            size: 25,
          ),
        ),
        title: Text(
          "",
          style: AppStyles.customTextStyle(
            size: 20,
            color: AppColors.secondaryColor,
            weight: FontWeight.w700,
          ),
        ),
      ),
      bodyWidget: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Row(
              spacing: 15,
              children: [
                CompanyLogo(logoUrl: companyLogoUrl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        companyName,
                        style: AppStyles.customTextStyle(
                          size: 16,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            CupertinoIcons.briefcase_fill,
                            color: AppColors.greyTextColor,
                          ),
                          Flexible(
                            child: Text(
                              roleType,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.customTextStyle(
                                size: 12,
                                color: AppColors.greyTextColor,
                                weight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              'Applicants (${applicationController.applicantsModel.count ?? 0})',
              style: AppStyles.customTextStyle(
                size: 16,
                color: AppColors.whiteColor,
                weight: FontWeight.w600,
              ),
            ),
            if (applicationController.applicantsLoading)
              AppAlertUtils.customLoader()
            else if (applicationController
                .applicantsModel
                .applicantsList!
                .isEmpty)
              CustomEmptyWidget()
            else
              Expanded(
                child: ListView.builder(
                  itemCount: applicationController
                      .applicantsModel
                      .applicantsList!
                      .length,
                  itemBuilder: (context, index) {
                    final applicant = applicationController
                        .applicantsModel
                        .applicantsList![index];
                    return _ApplicantsCard(
                      applicant: applicant,
                      projectList: projectList,
                      internshipData: internshipData!,
                      shortlistFunc: (){

                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ApplicantsCard extends StatelessWidget {
  const _ApplicantsCard({
    required this.applicant,
    required this.projectList,
    required this.internshipData,
    required this.shortlistFunc,
  });

  final ApplicantsData applicant;
  final List<String> projectList;
  final PostData internshipData;
  final VoidCallback shortlistFunc;

  @override
  Widget build(BuildContext context) {
    // Check if favorite flag exists inside user details profile fallback safely
    final bool isShortlisted = applicant.studentDetails?.isFavorite ?? false;

    return Card(
      color: AppColors.containerBgColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  maxRadius: 35,
                  backgroundImage: NetworkImage(
                    applicant.studentDetails?.studProfile ?? '',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        applicant.studentDetails?.studName?.capitalize ??
                            'Anonymous Student',
                        style: AppStyles.customTextStyle(
                          size: 15,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.emeraldBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Applied',
                              style: AppStyles.customTextStyle(
                                size: 13,
                                color: AppColors.emeraldColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'on ${_formatDate(
                                  applicant.createdAt)}',
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.customTextStyle(
                                size: 12,
                                color: AppColors.greyTextColor,
                                weight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                CustomButtonWidget(
                  width: 95,
                  height: 30,
                  buttonFunction: () {
                    AppFunctions.navigateScreen(
                      context,
                      AppRoutes.applicationActionScreen,
                      arguments: {
                        'jobId': applicant.job,
                        'studentId': applicant.studentDetails?.id,
                        'applicationId': applicant.id,
                        'projectList': projectList,
                        "internshipData": internshipData,
                      },
                    );
                  },
                  buttonWidget: Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.remove_red_eye_outlined,
                        color: AppColors.blackColor,
                        size: 12,
                      ),
                      Text(
                        'View',
                        style: AppStyles.customTextStyle(
                          size: 10,
                          color: AppColors.blackColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Refactored Interactive Shortlist Button Integration
                // GestureDetector(
                //   onTap: shortlistFunc,
                //   child: Container(
                //     height: 35,
                //     padding: const EdgeInsets.symmetric(horizontal: 15),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       border: Border.all(
                //         color: isShortlisted
                //             ? AppColors.secondaryColor
                //             : AppColors.lightBorderColor,
                //       ),
                //       color: isShortlisted
                //           ? AppColors.secondaryColor.withOpacity(0.1)
                //           : AppColors.transparentColor,
                //     ),
                //     child: Row(
                //       spacing: 5,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           isShortlisted
                //               ? CupertinoIcons.bookmark_fill
                //               : CupertinoIcons.bookmark,
                //           color: isShortlisted
                //               ? AppColors.secondaryColor
                //               : AppColors.whiteColor,
                //           size: 16,
                //         ),
                //         Text(
                //           isShortlisted ? 'Shortlisted' : 'Shortlist',
                //           style: AppStyles.customTextStyle(
                //             size: 12,
                //             color: isShortlisted
                //                 ? AppColors.secondaryColor
                //                 : AppColors.whiteColor,
                //             weight: isShortlisted ? FontWeight.w600 : FontWeight
                //                 .w400,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                _buildTypeContainer(
                  type: internshipData.internshipStipend != "N/A"
                      ? "STIPEND"
                      : internshipData.fee != "0"
                      ? "FEES"
                      : "FREE",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeContainer({required String type}) {
    final bool isStipend = type == "STIPEND";
    final bool isFees = type == "FEES";

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorderColor),
        color: isStipend
            ? AppColors.lightContColor2
            : isFees
            ? AppColors.lightContColor
            : AppColors.transparentColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isStipend
                ? Icons.work_history_outlined
                : isFees
                ? Icons.school_outlined
                : Icons.currency_rupee_rounded,
            color: isStipend
                ? AppColors.blueTextColor
                : isFees
                ? AppColors.primaryColor
                : AppColors.whiteColor,
            size: 16,
          ),
          Text(
            type,
            style: AppStyles.customTextStyle(
              size: 12,
              color: isStipend
                  ? AppColors.blueTextColor
                  : isFees
                  ? AppColors.primaryColor
                  : AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return "—";
    try {
      final dt = DateTime.parse(iso);
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
      final day = dt.day.toString().padLeft(2, '0');
      final monthStr = months[dt.month - 1];
      final year = dt.year;
      return "$day $monthStr $year";
    } catch (_) {
      return "—";
    }
  }
}