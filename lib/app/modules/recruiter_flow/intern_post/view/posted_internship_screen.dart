import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class PostedInternshipScreen extends StatefulWidget {
  const PostedInternshipScreen({super.key});

  @override
  State<PostedInternshipScreen> createState() => PostedInternshipScreenState();
}

class PostedInternshipScreenState extends State<PostedInternshipScreen> {
  final InternshipPostController postController =
      Get.find<InternshipPostController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshData();
    });
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      if (!postController.isLoadMoreLoading.value &&
          postController.currentPage.value < postController.totalPages.value) {
        postController.loadMorePostedInternships();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    await postController.getPostedInternshipsFiltered(
      status: postController.selectedStatusTab.value,
      page: 1,
      isLoadMore: false,
    );
  }

  Future<void> getInternshipData() async {
    await refreshData();
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
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Obx(() {
            final count = postController.totalJobsCount.value;
            final jobs = postController.postedJobsList;
            final isLoading = postController.internPostLoading;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header area ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My Posting",
                        style: AppStyles.customTextStyle(
                          size: 18,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                      _activeChip(count),
                    ],
                  ),
                ),

                // ── Status Filter Tabs (All / Active / Inactive) ───────
                _buildStatusTabs(),

                // ── Main Content Area ─────────────────────────────────
                Expanded(
                  child: isLoading
                      ? AppAlertUtils.customLoader()
                      : (jobs.isEmpty
                          ? RefreshIndicator(
                              backgroundColor: AppColors.appBgColor_2,
                              color: AppColors.primaryColor,
                              onRefresh: refreshData,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: _buildEmptyState(),
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              backgroundColor: AppColors.appBgColor_2,
                              color: AppColors.primaryColor,
                              onRefresh: refreshData,
                              child: ListView.separated(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 120),
                                itemCount: jobs.length +
                                    (postController.currentPage.value <
                                                postController
                                                    .totalPages.value ||
                                            postController
                                                .isLoadMoreLoading.value
                                        ? 1
                                        : 0),
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  if (index == jobs.length) {
                                    return _buildLoadMoreWidget();
                                  }
                                  return _JobCard(job: jobs[index]);
                                },
                              ),
                            )),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ── App Bar ───────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.transparentColor,
      automaticallyImplyLeading: false,
      // leading: InkWell(
      //   onTap: () => Get.back(),
      //   child: const Icon(CupertinoIcons.back, color: AppColors.whiteColor),
      // ),
      title: Text(
        "Posted Internship",
        style: AppStyles.customTextStyle(
          size: 20,
          color: AppColors.secondaryColor,
          weight: FontWeight.w700,
        ),
      ),
      // actions: [
      //   // Credits badge (coin icon + count)
      //   Obx(
      //     () => Container(
      //       margin: const EdgeInsets.only(right: 16),
      //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      //       decoration: BoxDecoration(
      //         color: Colors.black.withValues(alpha: 0.5),
      //         borderRadius: BorderRadius.circular(20),
      //         border: Border.all(
      //           color: AppColors.secondaryColor.withValues(alpha: 0.4),
      //         ),
      //       ),
      //       child: Row(
      //         mainAxisSize: MainAxisSize.min,
      //         spacing: 6,
      //         children: [
      //           const Text("🪙", style: TextStyle(fontSize: 16)),
      //           Text(
      //             "${postController.internPostModel..value}",
      //             style: AppStyles.customTextStyle(
      //               size: 14,
      //               color: AppColors.secondaryColor,
      //               weight: FontWeight.w700,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ],
    );
  }

  // ── Status Filter Tabs ─────────────────────────────────────────────────────
  Widget _buildStatusTabs() {
    final tabs = [
      {'label': 'All', 'status': 'all'},
      {'label': 'Active', 'status': 'active'},
      {'label': 'Inactive', 'status': 'inactive'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected =
              postController.selectedStatusTab.value == tab['status'];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isSelected) {
                  postController.filterByStatus(tab['status']!);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tab['label']!,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: isSelected ? Colors.black : AppColors.greyTextColor,
                    weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Active chip ────────────────────────────────────────────────────────────
  Widget _activeChip(int count) {
    final status = postController.selectedStatusTab.value;
    final label = status == 'active'
        ? 'ACTIVE'
        : (status == 'inactive' ? 'INACTIVE' : 'POSTINGS');
    final color = status == 'inactive'
        ? const Color(0xFFEF4444)
        : AppColors.secondaryColor;
    final textColor = status == 'inactive' ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "${count.toString().padLeft(2, '0')} $label",
        style: AppStyles.customTextStyle(
          size: 12,
          color: textColor,
          weight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Load more indicator ────────────────────────────────────────────────────
  Widget _buildLoadMoreWidget() {
    if (postController.isLoadMoreLoading.value) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      );
    }

    if (postController.currentPage.value < postController.totalPages.value) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextButton.icon(
            onPressed: () => postController.loadMorePostedInternships(),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
            label: Text(
              "Load More Internships (${postController.postedJobsList.length} of ${postController.totalJobsCount.value})",
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.primaryColor,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    final status = postController.selectedStatusTab.value;
    final message = status == 'active'
        ? "No active internships found"
        : (status == 'inactive'
            ? "No inactive internships found"
            : "No internships posted yet");

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Icon(
            CupertinoIcons.briefcase,
            size: 60,
            color: AppColors.secondaryColor,
          ),
          Text(
            message,
            style: AppStyles.customTextStyle(
              size: 16,
              color: AppColors.whiteColor,
              weight: FontWeight.w500,
            ),
          ),
          Text(
            status == 'all'
                ? "Tap the '+' button below to post your first internship"
                : "Switch tabs to view other internships",
            textAlign: TextAlign.center,
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.secondaryColor.withValues(alpha: 0.6),
              weight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Job Card widget
// ─────────────────────────────────────────────────────────────────────────────
class _JobCard extends StatelessWidget {
  const _JobCard({required this.job});

  final PostData job;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company logo
                CompanyLogo(logoUrl: job.companyLogo),
                const SizedBox(width: 12),

                // Company name + role + status badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              job.companyName ?? "—",
                              style: AppStyles.customTextStyle(
                                size: 15,
                                color: AppColors.whiteColor,
                                weight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(job.isJobActive),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            CupertinoIcons.briefcase_fill,
                            size: 12,
                            color: AppColors.greyTextColor,
                          ),
                          Flexible(
                            child: Text(
                              job.roleType ?? "—",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.customTextStyle(
                                size: 13,
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

                // More options
                InkWell(
                  onTap: () => _showOptionsSheet(context),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.greyTextColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Info grid ──────────────────────────────────────────
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            decoration: BoxDecoration(
              color: AppColors.selectedContColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                // Row 1: Location | Duration
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: CupertinoIcons.location_solid,
                        iconColor: const Color(0xFF9B59B6),
                        label: "Location",
                        value: _formatLocation(),
                      ),
                    ),
                    Expanded(
                      child: _InfoTile(
                        icon: CupertinoIcons.clock_fill,
                        iconColor: const Color(0xFF1ABC9C),
                        label: "Duration",
                        value: _formatDuration(),
                      ),
                    ),
                  ],
                ),

                // Row 2: Compensation | Posted
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.currency_rupee_rounded,
                        iconColor: const Color(0xFF1ABC9C),
                        label: "Compensation",
                        value: _formatCompensation(),
                      ),
                    ),
                    Expanded(
                      child: _InfoTile(
                        icon: CupertinoIcons.calendar,
                        iconColor: AppColors.secondaryColor,
                        label: "Posted",
                        value: _formatDate(job.createdAt),
                      ),
                    ),
                  ],
                ),

                // Eligibility chips
                if ((job.studentQualification ?? []).isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [
                          const Icon(
                            Icons.school_rounded,
                            color: AppColors.greyTextColor,
                            size: 14,
                          ),
                          Text(
                            "Eligibility:",
                            style: AppStyles.customTextStyle(
                              size: 13,
                              color: AppColors.greyTextColor,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      ...(job.studentQualification ?? []).map(
                        (q) => _QualChip(label: q),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // ── Action buttons ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
            child: Row(
              spacing: 8,
              children: [
                // View
                Expanded(
                  child: _ActionButton(
                    label: "View",
                    icon: CupertinoIcons.eye_fill,
                    background: AppColors.primaryColor,
                    textColor: Colors.black,
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.postedInternshipViewScreen,
                        arguments: {"internshipData": job},
                      );
                    },
                  ),
                ),

                // Edit
                Expanded(
                  child: _ActionButton(
                    label: "Edit",
                    icon: CupertinoIcons.pencil,
                    background: Colors.white.withValues(alpha: 0.12),
                    textColor: AppColors.whiteColor,
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.postNewInternshipScreen,
                        arguments: {
                          "internPostData": job,
                          "isEditScreen": true,
                        },
                      );
                    },
                  ),
                ),

                // Applicants
                Expanded(
                  flex: 2,
                  child: _ApplicantsButton(
                    count: job.totalApplicants ?? 0,
                    onTap: job.totalApplicants != 0
                        ? () {
                            AppFunctions.navigateScreen(
                              context,
                              AppRoutes.applicantsListScreen,
                              arguments: {
                                "jobId": job.id,
                                "companyLogoUrl": job.companyLogo,
                                "companyName": job.companyName,
                                "roleType": job.roleType,
                                "projectList": job.projectDescription,
                                "internshipData": job,
                              },
                            );
                          }
                        : () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Formatting helpers ─────────────────────────────────────────────────────

  String _formatLocation() {
    final city = job.companyCity ?? "";
    final state = job.companyState ?? "";
    if (city.isNotEmpty && state.isNotEmpty) return "$city, $state";
    return city.isNotEmpty ? city : (state.isNotEmpty ? state : "—");
  }

  String _formatDuration() {
    final duration = job.internshipDuration ?? "";
    final days = job.days ?? "";

    if (duration.isNotEmpty && duration != "0") {
      final months = int.tryParse(duration);
      return months != null
          ? "$months Month${months > 1 ? 's' : ''}"
          : duration;
    }
    if (days.isNotEmpty && days != "0") {
      final d = int.tryParse(days);
      return d != null ? "$d Day${d > 1 ? 's' : ''}" : "$days Days";
    }
    return "—";
  }

  String _formatCompensation() {
    final stipend = job.internshipStipend ?? "";
    final fee = job.fee ?? "0";

    if (stipend == "N/A" || stipend.isEmpty) {
      return fee != "0" ? "Fee: ₹$fee" : "Free Internship";
    }
    return "₹$stipend/month";
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return "—";
    try {
      final dt = DateTime.parse(iso);
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year}";
    } catch (_) {
      return "—";
    }
  }

  // ── Options bottom sheet ───────────────────────────────────────────────────
  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                CupertinoIcons.eye,
                color: AppColors.primaryColor,
              ),
              title: Text(
                "View Internship",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                AppFunctions.navigateScreen(
                  context,
                  AppRoutes.postedInternshipViewScreen,
                  arguments: {"internshipData": job},
                );
              },
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.pencil,
                color: AppColors.primaryColor,
              ),
              title: Text(
                "Edit Internship",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                AppFunctions.navigateScreen(
                  context,
                  AppRoutes.postNewInternshipScreen,
                  arguments: {"internPostData": job, "isEditScreen": true},
                );
              },
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.person_2,
                color: AppColors.primaryColor,
              ),
              title: Text(
                "View Applicants",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: job.totalApplicants != 0
                  ? () {
                      Get.back();
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.applicantsListScreen,
                        arguments: {
                          "jobId": job.id,
                          "companyLogoUrl": job.companyLogo,
                          "companyName": job.companyName,
                          "roleType": job.roleType,
                          "projectList": job.projectDescription,
                          "internshipData": job,
                        },
                      );
                    }
                  : () {},
            ),
            ListTile(
              leading: Icon(
                job.isJobActive
                    ? Icons.pause_circle_outline_rounded
                    : Icons.play_circle_outline_rounded,
                color: job.isJobActive
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF10B981),
              ),
              title: Text(
                job.isJobActive ? "In-Active" : "Active",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: job.isJobActive
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF10B981),
                  weight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                job.isJobActive
                    ? "Hide this posting from students"
                    : "Make this posting active for applicants",
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.greyTextColor,
                ),
              ),
              onTap: () {
                Get.back();
                _showStatusToggleDialog(context, job.isJobActive);
              },
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.trash,
                color: Color(0xFFEF4444),
              ),
              title: Text(
                "Delete",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: const Color(0xFFEF4444),
                  weight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "Permanently remove this posting",
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.greyTextColor,
                ),
              ),
              onTap: () {
                Get.back();
                _showDeleteDialog(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ── Status toggle confirmation dialog ──────────────────────────────────────
  void _showStatusToggleDialog(BuildContext context, bool currentActive) {
    final willBeActive = !currentActive;
    final actionName = willBeActive ? "Active" : "In-Active";

    AppAlertUtils.showAppAlert(
      context: context,
      title: "Mark as $actionName",
      content: willBeActive
          ? "Are you sure you want to activate this internship? Students will be able to see and apply for it."
          : "Are you sure you want to mark this internship as In-Active? Students will no longer see or apply for it.",
      confirmText: actionName,
      cancelText: "Cancel",
      isDestructive: !willBeActive,
      onConfirm: () {
        final postController = Get.find<InternshipPostController>();
        postController.toggleJobStatus(
          jobId: job.id ?? "",
          makeActive: willBeActive,
        );
      },
    );
  }

  // ── Delete confirmation dialog ─────────────────────────────────────────────
  void _showDeleteDialog(BuildContext context) {
    final roleName = (job.roleType != null && job.roleType!.trim().isNotEmpty)
        ? job.roleType!.trim()
        : (job.companyName ?? "this post");

    AppAlertUtils.showAppAlert(
      context: context,
      title: "Delete Internship",
      content:
          'Are you sure you want to delete "$roleName"? This action cannot be undone and will permanently remove this post.',
      confirmText: "Delete",
      cancelText: "Cancel",
      isDestructive: true,
      onConfirm: () {
        final postController = Get.find<InternshipPostController>();
        postController.deletePostedInternship(
          jobId: job.id ?? "",
        );
      },
    );
  }

  // ── Status Badge ───────────────────────────────────────────────────────────
  Widget _buildStatusBadge(bool isActive) {
    final Color badgeColor =
        isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: badgeColor.withValues(alpha: 0.7),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isActive ? "ACTIVE" : "IN-ACTIVE",
            style: AppStyles.customTextStyle(
              size: 10,
              color: badgeColor,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class CompanyLogo extends StatelessWidget {
  const CompanyLogo({required this.logoUrl, super.key});

  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: logoUrl != null && logoUrl!.isNotEmpty
          ? Image.network(
              logoUrl!,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.business_rounded,
        color: AppColors.primaryColor,
        size: 26,
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 3,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(icon, size: 13, color: iconColor),
            Text(
              label,
              style: AppStyles.customTextStyle(
                size: 12,
                color: iconColor,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.customTextStyle(
            size: 13,
            color: AppColors.whiteColor,
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _QualChip extends StatelessWidget {
  const _QualChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppStyles.customTextStyle(
          size: 11,
          color: AppColors.whiteColor,
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            Icon(icon, size: 15, color: textColor),
            Text(
              label,
              style: AppStyles.customTextStyle(
                size: 13,
                color: textColor,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicantsButton extends StatelessWidget {
  const _ApplicantsButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A3FAA),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            const Icon(Icons.people_alt_rounded, size: 15, color: Colors.white),
            Text(
              count == 0 ? 'No Applicants' : 'Applicants',
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.whiteColor,
                weight: FontWeight.w600,
              ),
            ),
            count == 0
                ? SizedBox.shrink()
                : Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      count.toString().padLeft(2, '0'),
                      style: AppStyles.customTextStyle(
                        size: 11,
                        color: Colors.black,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
