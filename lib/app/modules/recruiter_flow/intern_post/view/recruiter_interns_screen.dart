import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/app_background_widget.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/applicants_list_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class RecruiterInternsScreen extends StatefulWidget {
  const RecruiterInternsScreen({super.key});

  @override
  State<RecruiterInternsScreen> createState() => _RecruiterInternsScreenState();
}

class _RecruiterInternsScreenState extends State<RecruiterInternsScreen> {
  final InternshipPostController postController =
      Get.find<InternshipPostController>();
  final InternshipPostController applicationController =
      Get.find<InternshipPostController>();

  List<PostData>? internshipList = [];
  List<ApplicantsData>? applicantsList = [];

  String jobId = "";
  String companyName = "";

  // Index of the currently selected internship-post card in the
  // horizontal list.
  final RxInt selectedIndex = 0.obs;
  String? recruiterId = "";
  int internCount = 0;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getInternshipData();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        status: "Selected",
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

  // Called when the user taps a different internship-post card.
  Future<void> onJobSelected(int index, String selectedJobId) async {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
    jobId = selectedJobId;
    await getApplicantsData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBarWidget: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparentColor,
        automaticallyImplyLeading: false,
        title: Text(
          "My Interns",
          style: AppStyles.customTextStyle(
            size: 20,
            color: AppColors.secondaryColor,
            weight: FontWeight.w700,
          ),
        ),
      ),
      bodyWidget: Obx(
        () => postController.internPostLoading
            ? AppAlertUtils.customLoader()
            : RefreshIndicator(
                backgroundColor: AppColors.appBgColor_2,
                color: AppColors.primaryColor,
                onRefresh: () async {
                  getInternshipData();
                },
                child: Column(
                  spacing: 15,
                  children: [
                    _buildShowingBanner(),
                    _buildInternshipCardsList(),
                    _buildSearchAndFilterRow(),
                    Expanded(child: _buildApplicantsList()),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildShowingBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.recContColor,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Icon(Icons.group_outlined, color: AppColors.whiteColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.contLightText2,
                  weight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text:
                        "Showing ${internshipList?.length ?? 0} Intern(s) for ",
                  ),
                  TextSpan(
                    text: companyName,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternshipCardsList() {
    if (internshipList == null || internshipList!.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: internshipList!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final job = internshipList![index];
          final bool isSelected = selectedIndex.value == index;
          return GestureDetector(
            onTap: () => onJobSelected(index, job.id ?? ""),
            child: Container(
              width: 150,
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
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      job.companyLogo ?? "",
                      height: 50,
                      width: 50,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.photo_camera_back_outlined),
                    ),
                  ),
                  Text(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.selContColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${(job.selectedApplicants ?? 0).toString()} Selected",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.recContColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.search,
                  color: AppColors.greyIcon.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: "Search by name, email, skills...",
                      hintStyle: AppStyles.customTextStyle(
                        size: 13,
                        color: AppColors.disableButtonColor,
                        weight: FontWeight.w400,
                      ),
                    ),
                    onChanged: (value) {
                      // TODO: hook into your search/filter logic.
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.recContColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // TODO: open filter bottom sheet.
            },
            child: Row(
              children: [
                Icon(Icons.filter_list, color: AppColors.whiteColor, size: 20),
                const SizedBox(width: 6),
                Text(
                  "Filter",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final applicant = applicantsList![index];
        return _buildApplicantCard(applicant);
      },
    );
  }

  Widget _buildApplicantCard(ApplicantsData applicant) {
    return GestureDetector(
      onTap: () {
        AppFunctions.navigateScreen(
          context,
          AppRoutes.applicationActionScreen,
          arguments: {
            'jobId': applicant.job,
            'studentId': applicant.studentDetails!.id,
            'applicationId': applicant.id,
          },
        );
      },
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
                      (applicant.studentDetails!.studProfile ?? "").isNotEmpty
                      ? NetworkImage(
                          applicant.studentDetails!.studProfile ?? "",
                        )
                      : null,
                  child: (applicant.studentDetails!.studProfile ?? "").isEmpty
                      ? Icon(Icons.person, color: AppColors.whiteColor)
                      : null,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildSelectedPill(),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: AppColors.whiteColor.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            color: AppColors.primaryColor,
                            onSelected: (value) {
                              // TODO: handle menu actions (view profile, reject, etc.)
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: "view",
                                child: Text(
                                  "View Profile",
                                  style: AppStyles.customTextStyle(
                                    size: 14,
                                    color: AppColors.whiteColor,
                                    weight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: "reject",
                                child: Text(
                                  "Reject",
                                  style: AppStyles.customTextStyle(
                                    size: 14,
                                    color: AppColors.whiteColor,
                                    weight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        applicant.studentDetails!.studName ?? "",
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
              applicant.studentDetails!.studEmail ?? "",
            ),
            _buildInfoRow(
              Icons.school_outlined,
              applicant.studentDetails!.studentfieldofstudy ?? "",
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List<Widget>.from(
                (applicant.studentDetails!.studprogramminglang as List? ?? [])
                    .map((skill) => _buildSkillChip(skill.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.sucBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.sucTextColor,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            "Selected",
            style: AppStyles.customTextStyle(
              size: 10,
              color: AppColors.sucTextColor,
              weight: FontWeight.w600,
            ),
          ),
        ],
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
