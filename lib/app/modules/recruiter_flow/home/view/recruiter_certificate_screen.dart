import 'package:flutter/cupertino.dart';
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
  final TextEditingController searchController = TextEditingController();

  String? recruiterId = "";
  List<PostData>? internshipList = [];

  // Backing master list and UI list
  List<ApplicantsData>? _allApplicants = [];
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
    _allApplicants!.clear();
    try {
      await applicationController.getApplicants(
        jobId: jobId,
        status: "Completed",
      );
      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        // Store in master list copy
        _allApplicants = List.from(
          applicationController.applicantsModel.applicantsList ?? [],
        );
        applicantsList = List.from(_allApplicants!);

        debugPrint("+++++++++++++++++++++++++++");
        debugPrint(applicantsList!.length.toString());

        // Re-apply filter if user already typed something before changing tabs
        if (searchController.text.isNotEmpty) {
          filterSearch(searchController.text);
        } else {
          setState(() {
            internCount = applicantsList!.length;
          });
        }
      } else {
        setState(() {
          internCount = applicantsList?.length ?? 0;
        });
        AppFunctions.apiErrorHandling(
          applicationController.getResponseCode(),
          applicationController.applicantsModel.message ??
              "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      setState(() {
        internCount = applicantsList?.length ?? 0;
      });
      AppFunctions.apiErrorHandling(
        applicationController.getResponseCode(),
        applicationController.applicantsModel.message ??
            "Something went wrong!, Try again later",
      );
      rethrow;
    }
  }

  // Filter Logic Implementation
  void filterSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        applicantsList = List.from(_allApplicants!);
        internCount = applicantsList!.length;
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    setState(() {
      applicantsList = _allApplicants!.where((applicant) {
        final name = applicant.studentDetails?.studName?.toLowerCase() ?? "";
        final email = applicant.studentDetails?.studEmail?.toLowerCase() ?? "";
        return name.contains(lowercaseQuery) || email.contains(lowercaseQuery);
      }).toList();
      internCount = applicantsList!.length;
    });
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

    // Clear search bar UI when switching tabs
    searchController.clear();
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
              Icons.arrow_back,
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
              color: AppColors.secondaryColor,
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
                        searchWidget(),
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

  Widget searchWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.recContColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: searchController,
        textAlign: TextAlign.start,
        style: AppStyles.customTextStyle(
          size: 14,
          color: AppColors.whiteColor,
          weight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search by name,email...",
          hintStyle: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.disableButtonColor,
            weight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: AppColors.primaryColor,
            size: 20,
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.redColor),
                  onPressed: () {
                    searchController.clear();
                    filterSearch("");
                  },
                )
              : const SizedBox.shrink(),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onChanged: (value) => filterSearch(value),
      ),
    );
  }

  Widget _buildInternshipCardsList() {
    if (internshipList == null || internshipList!.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 40,
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
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.selContColor
                    : AppColors.transparentColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.fieldBorderColor,
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
                  size: 12,
                  lineSpace: 1.4,
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.fieldBorderColor,
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

    if (applicantsList == null || applicantsList!.isEmpty) {
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
    debugPrint(applicant.isCertificateGenerated!.toString());
    debugPrint("_____________________");
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
            backgroundColor: AppColors.whiteColor.withValues(alpha: 0.1),
            backgroundImage:
                (applicant.studentDetails != null
                        ? applicant.studentDetails!.studProfile ?? ""
                        : "")
                    .isNotEmpty
                ? NetworkImage(
                    applicant.studentDetails != null
                        ? applicant.studentDetails!.studProfile ?? ""
                        : "",
                  )
                : null,
            child:
                (applicant.studentDetails != null
                        ? applicant.studentDetails!.studProfile ?? ""
                        : "")
                    .isEmpty
                ? Icon(Icons.person, color: AppColors.whiteColor)
                : null,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  applicant.studentDetails != null
                      ? applicant.studentDetails!.studName ??
                            "Anonymous Student"
                      : "Anonymous Student",
                  style: AppStyles.customTextStyle(
                    size: 15,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text(
                          applicant.studentDetails != null
                              ? applicant.studentDetails!.studEmail ?? ""
                              : "NA",
                          style: AppStyles.customTextStyle(
                            size: 13,
                            color: AppColors.contLightText2,
                            weight: FontWeight.w500,
                          ),
                        ),
                        applicant.isCertificateGenerated!
                            ? Row(
                                spacing: 3,
                                children: [
                                  Icon(
                                    Icons.verified_outlined,
                                    color: AppColors.primaryColor,
                                    size: 15,
                                  ),
                                  Text(
                                    "ISSUED: ${AppFunctions.formatIsoDate(applicant.studentDetails != null ? applicant.studentDetails!.updatedAt ?? "" : "NA")}",
                                    style: AppStyles.customTextStyle(
                                      size: 11,
                                      color: AppColors.primaryColor,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Not Issued",
                                style: AppStyles.customTextStyle(
                                  size: 11,
                                  color: AppColors.secondaryColor,
                                  weight: FontWeight.w600,
                                ),
                              ),
                      ],
                    ),
                    const Spacer(),
                    Visibility(
                      visible: applicant.isCertificateGenerated!,
                      child: IconButton(
                        onPressed: () {
                          AppFunctions.navigateScreen(
                            context,
                            AppRoutes.certificateViewScreen,
                            arguments: {
                              "jobId": jobId,
                              "studentId": applicant.studentDetails != null
                                  ? applicant.studentDetails!.id
                                  : "",
                            },
                          );
                        },
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: AppColors.secondaryColor,
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
    );
  }
}
