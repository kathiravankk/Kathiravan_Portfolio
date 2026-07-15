import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/applicants_list_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class RecruiterCertificateScreen extends StatefulWidget {
  const RecruiterCertificateScreen({super.key});

  @override
  State<RecruiterCertificateScreen> createState() =>
      _RecruiterCertificateScreenState();
}

class _RecruiterCertificateScreenState
    extends State<RecruiterCertificateScreen> {
  final InternshipPostController postController =
      Get.find<InternshipPostController>();
  final InternshipPostController applicationController =
      Get.find<InternshipPostController>();

  String? recruiterId = "";
  List<PostData>? internshipList = [];
  List<ApplicantsData>? applicantsList = [];

  String jobId = "";
  String companyName = "";
  PostData? internshipData;
  final RxInt selectedIndex = 0.obs;
  int internCount = 0;

  @override
  void initState() {
    super.initState();
    getInternshipData();
  }

  Future<void> getInternshipData() async {
    recruiterId = await LocalStorageService.getRecruiterId();

    try {
      await postController.getPostedInternships(recruiterId: recruiterId!);
      if (postController.getResponseCode() == 200 ||
          postController.getResponseCode() == 201) {
        internshipList = postController.internPostModel.jobs ?? [];
        companyName = internshipList![0].companyName ?? "Company";
        if (internshipList != null && internshipList!.isNotEmpty) {
          jobId = internshipList![0].id ?? "";
          selectedIndex.value = 0;
          internshipData = internshipList![0];
          await getApplicantsData();
        }
        setState(() {});
      } else {
        AppFunctions.apiErrorHandling(
          postController.getResponseCode(),
          postController.internPostModel.message ??
              "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        postController.getResponseCode(),
        postController.internPostModel.message ??
            "Something went wrong!, Try again later",
      );
      rethrow;
    }
  }

  Future<void> getApplicantsData() async {
    applicantsList!.clear();
    try {
      await applicationController.getApplicants(
        jobId: jobId,
        status: "Completed",
      );
      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        applicantsList = applicationController.applicantsModel.applicantsList;
        debugPrint("+++++++++++++++++++++++++++");
        debugPrint(applicantsList!.length.toString());
        internCount = applicantsList!.length;
      } else {
        setState(() {
          internCount = applicantsList?.length ?? 0;
        });
        AppFunctions.apiErrorHandling(
          applicationController.getResponseCode(),
          "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      internCount = applicantsList?.length ?? 0;
      AppFunctions.apiErrorHandling(
        applicationController.getResponseCode(),
        "Something went wrong!, Try again later",
      );
      rethrow;
    }
  }

  Future<void> onJobSelected(
    int index,
    String selectedJobId,
    PostData postData,
  ) async {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
    jobId = selectedJobId;
    internshipData = postData;
    await getApplicantsData();
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
            "Certificates",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => postController.internPostLoading
              ? AppAlertUtils.customLoader()
              : RefreshIndicator(
                  backgroundColor: AppColors.appBgColor_2,
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    getInternshipData();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      spacing: 15,
                      children: [
                        _buildInternshipCardsList(),
                        Expanded(child: _buildApplicantsList()),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInternshipCardsList() {
    if (internshipList == null || internshipList!.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: internshipList!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final job = internshipList![index];
          final bool isSelected = selectedIndex.value == index;
          return GestureDetector(
            onTap: () =>
                onJobSelected(index, job.id ?? "", internshipList![index]),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.recContColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                job.roleType ?? "",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.customTextStyle(
                  size: 14,
                  lineSpace: 1.4,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildApplicantsList() {
    if (applicationController.applicantsLoading) {
      return AppAlertUtils.customLoader();
    }

    if (applicantsList!.isEmpty) {
      return CustomEmptyWidget();
    }

    return ListView.separated(
      itemCount: applicantsList!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final applicant = applicantsList![index];
        return _buildApplicantCard(applicant);
      },
    );
  }

  Widget _buildApplicantCard(ApplicantsData applicant) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.recContColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.whiteColor.withOpacity(0.1),
            backgroundImage:
                (applicant.studentDetails!.studProfile ?? "").isNotEmpty
                ? NetworkImage(applicant.studentDetails!.studProfile ?? "")
                : null,
            child: (applicant.studentDetails!.studProfile ?? "").isEmpty
                ? Icon(Icons.person, color: AppColors.whiteColor)
                : null,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  applicant.studentDetails!.studName ?? "",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          applicant.studentDetails!.role!.capitalize ?? "",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          applicant.studentDetails!.updatedAt ?? "",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: AppColors.primaryColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.certificateViewScreen,
                          arguments: {"jobId": jobId, "studentId": applicant.studentDetails!.id},
                        );
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
