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
  State<RecruiterInternsScreen> createState() => RecruiterInternsScreenState();
}

class RecruiterInternsScreenState extends State<RecruiterInternsScreen> {
  final InternshipPostController postController = Get.find<InternshipPostController>();
  final InternshipPostController applicationController = Get.find<InternshipPostController>();



  List<PostData>? internshipList = [];

  // --- Search & Filter Setup ---
  List<ApplicantsData> allApplicants = [];
  List<ApplicantsData> filteredApplicantsList = [];

  String jobId = "";
  String companyName = "";
  PostData? internshipData;

  final RxInt selectedIndex = 0.obs;
  String? recruiterId = "";
  int internCount = 0;

  final TextEditingController searchController = TextEditingController();

  // --- Dynamic Filter Option State ---
  String selectedStatusFilter = "All";
  final List<String> filterOptions = ["All", "Ongoing", "Completed", "Upcoming"];

  // @override
  // void initState() {
  //   super.initState();
  //   getInternshipData();
  // }

  Future<void> refreshData() async {
    await getInternshipData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Maps display labels to API-expected status values
  String _mapFilterToApiStatus(String label) {
    switch (label) {
      case "Ongoing":
        return "ongoing";
      case "Completed":
        return "Completed";
      case "Upcoming":
        return "Selected";
      case "All":
      default:
        return "";
    }
  }

  // --- Local Filtering Engine (Search within already shown API results) ---
  void filterSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        filteredApplicantsList = List.from(allApplicants);
        internCount = filteredApplicantsList.length;
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase().trim();

    setState(() {
      filteredApplicantsList = allApplicants.where((applicant) {
        final details = applicant.studentDetails;
        if (details == null) return false;

        final name = (details.studName ?? "").toLowerCase();
        final email = (details.studEmail ?? "").toLowerCase();
        final mobile = (details.studMobileNo ?? "").toLowerCase();

        return name.contains(lowercaseQuery) ||
            email.contains(lowercaseQuery) ||
            mobile.contains(lowercaseQuery);
      }).toList();

      internCount = filteredApplicantsList.length;
    });
  }

  Future<void> getInternshipData() async {
    recruiterId = await LocalStorageService.getRecruiterId();

    try {
      await postController.getPostedInternships(recruiterId: recruiterId!);
      if (postController.getResponseCode() == 200 ||
          postController.getResponseCode() == 201) {
        internshipList = postController.internPostModel.jobs ?? [];
        if (internshipList != null && internshipList!.isNotEmpty) {
          companyName = internshipList![0].companyName ?? "Company";
          jobId = internshipList![0].id ?? "";
          selectedIndex.value = 0;
          internshipData = internshipList![0];

          // Reset filters strictly on a full main data reload
          selectedStatusFilter = "All";
          searchController.clear();

          await getApplicantsData();
        } else {
          setState(() {});
        }
      } else {
        AppFunctions.apiErrorHandling(
          postController.getResponseCode(),
          postController.internPostModel.message ?? "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        postController.getResponseCode(),
        postController.internPostModel.message ?? "Something went wrong!, Try again later",
      );
    }
  }

  // --- Fixed Method: Removed the hardcoded reset lines from the root of execution ---
  Future<void> getApplicantsData() async {
    try {
      final String apiStatus = _mapFilterToApiStatus(selectedStatusFilter);
      await applicationController.getApplicants(jobId: jobId, status: apiStatus);

      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        final fetched = applicationController.applicantsModel.applicantsList ?? [];
        setState(() {
          allApplicants = List.from(fetched);
          filteredApplicantsList = List.from(fetched);
          internCount = filteredApplicantsList.length;
        });

        // Re-apply search locally if text was entered prior to status filter shifts
        if (searchController.text.isNotEmpty) {
          filterSearch(searchController.text);
        }
      } else {
        _clearApplicantsState();
        AppFunctions.apiErrorHandling(
          applicationController.getResponseCode(),
          applicationController.applicantsModel.message ?? "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      _clearApplicantsState();
      AppFunctions.apiErrorHandling(
        applicationController.getResponseCode(),
        applicationController.applicantsModel.message ?? "Something went wrong!, Try again later",
      );
    }
  }

  void _clearApplicantsState() {
    setState(() {
      allApplicants.clear();
      filteredApplicantsList.clear();
      internCount = 0;
    });
  }

  Future<void> onJobSelected(int index, String selectedJobId, PostData postData) async {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
    jobId = selectedJobId;
    internshipData = postData;

    // Reset inputs specifically when changing layout context to a different internship card
    setState(() {
      selectedStatusFilter = "All";
      searchController.clear();
    });

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
      bodyWidget: Obx(() {
        final bool isLoading = postController.internPostLoading || applicationController.applicantsLoading;

        return isLoading
            ? AppAlertUtils.customLoader()
            : RefreshIndicator(
          backgroundColor: AppColors.appBgColor_2,
          color: AppColors.primaryColor,
          onRefresh: () async {
            await getInternshipData();
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
        );
      }),
    );
  }

  Widget _buildShowingBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.recContColor,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          const Icon(Icons.group_outlined, color: AppColors.whiteColor, size: 22),
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
                  TextSpan(text: "Showing $internCount Intern(s) for "),
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
          return Obx(() {
            final bool isSelected = selectedIndex.value == index;
            return GestureDetector(
              onTap: () => onJobSelected(index, job.id ?? "", job),
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
                        const Icon(Icons.photo_camera_back_outlined, color: AppColors.whiteColor),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.selContColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${(job.totalApplicants ?? 0).toString()} Selected",
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
          });
        },
      ),
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.recContColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: searchController,
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search by name, email...",
                hintStyle: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.disableButtonColor,
                  weight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
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
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: filterSearch,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Theme(
          data: Theme.of(context).copyWith(cardColor: AppColors.recContColor),
          child: PopupMenuButton<String>(
            color: AppColors.recContColor,
            initialValue: selectedStatusFilter,
            onSelected: (String value) async {
              if (selectedStatusFilter == value) return;
              setState(() {
                selectedStatusFilter = value;
              });
              await getApplicantsData();
            },
            offset: const Offset(0, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.primaryColor),
            ),
            itemBuilder: (BuildContext context) {
              return filterOptions.map((String option) {
                final bool isCurrent = option == selectedStatusFilter;
                return PopupMenuItem<String>(
                  value: option,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option,
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: isCurrent ? AppColors.primaryColor : AppColors.whiteColor,
                          weight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                      if (isCurrent)
                        const Icon(Icons.check_circle_outline, color: AppColors.primaryColor, size: 18)
                    ],
                  ),
                );
              }).toList();
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.recContColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.filter_list, color: AppColors.whiteColor, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    selectedStatusFilter,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: AppColors.whiteColor.withOpacity(0.7), size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicantsList() {
    if (filteredApplicantsList.isEmpty) {
      return const CustomEmptyWidget();
    }

    return ListView.separated(
      itemCount: filteredApplicantsList.length,
      padding: const EdgeInsets.only(bottom: 100),
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final applicant = filteredApplicantsList[index];
        return _buildApplicantCard(applicant);
      },
    );
  }

  Widget _buildApplicantCard(ApplicantsData applicant) {
    final details = applicant.studentDetails;
    return GestureDetector(
      onTap: () {
        if (details == null || internshipData == null) return;
        AppFunctions.navigateScreen(
          context,
          AppRoutes.applicationActionScreen,
          arguments: {
            'jobId': applicant.job,
            'studentId': details.id,
            'applicationId': applicant.id,
            'projectList': internshipData!.projectDescription,
            "internshipData": internshipData,
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
                  backgroundColor: AppColors.whiteColor.withValues(alpha: 0.1),
                  backgroundImage: (details?.studProfile ?? "").isNotEmpty
                      ? NetworkImage(details!.studProfile!)
                      : null,
                  child: (details?.studProfile ?? "").isEmpty
                      ? const Icon(Icons.person, color: AppColors.whiteColor)
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
                          _buildTypeContainer(
                            type: internshipData?.internshipStipend != "N/A"
                                ? "STIPEND"
                                : internshipData?.fee != "0"
                                ? "FEES"
                                : "FREE",
                          ),
                          _buildSelectedPill(),
                        ],
                      ),
                      Text(
                        details?.studName ?? "Anonymous Student",
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
            _buildInfoRow(Icons.email_outlined, details?.studEmail ?? "NA"),
            if ((details?.studMobileNo ?? "").isNotEmpty)
              _buildInfoRow(Icons.call, details?.studMobileNo ?? "NA"),
            _buildInfoRow(Icons.school_outlined, details?.studentfieldofstudy ?? "NA"),
            if (details?.studprogramminglang != null)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List<Widget>.from(
                  (details!.studprogramminglang as List)
                      .map((skill) => _buildSkillChip(skill.toString())),
                ),
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
    if (text.isEmpty || text == "NA") return const SizedBox.shrink();
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