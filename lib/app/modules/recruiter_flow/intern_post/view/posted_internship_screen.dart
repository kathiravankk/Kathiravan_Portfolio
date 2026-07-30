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

  // @override
  // void initState() {
  //   super.initState();
  //   getInternshipData();
  // }

  Future<void> refreshData() async {
    await getInternshipData();
  }

  String? recruiterId = "";

  Future<void> getInternshipData() async {
    recruiterId = await LocalStorageService.getRecruiterId();
    try {
      await postController.getPostedInternships(recruiterId: recruiterId!);
      if (postController.getResponseCode() == 200 ||
          postController.getResponseCode() == 201) {
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
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Obx(() {
            if (postController.internPostLoading) {
              return AppAlertUtils.customLoader();
            }

            final jobs = postController.internPostModel.jobs;

            if (jobs?.isEmpty ?? true) {
              return _buildEmptyState();
            }

            // Count active jobs (noOfPosition > 0)
            final activeCount = jobs!
                .where((j) => (j.noOfPosition ?? 0) > 0)
                .length;

            return RefreshIndicator(
              backgroundColor: AppColors.appBgColor_2,
              color: AppColors.primaryColor,
              onRefresh: () async {
                await getInternshipData();
              },
              child: Column(
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
                        _activeChip(activeCount),
                      ],
                    ),
                  ),

                  // ── Job list ─────────────────────────────────────────
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                      itemCount: jobs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) =>
                          _JobCard(job: jobs[index]),
                    ),
                  ),
                ],
              ),
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

  // ── Active chip ────────────────────────────────────────────────────────────
  Widget _activeChip(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "${count.toString().padLeft(2, '0')} ACTIVE",
        style: AppStyles.customTextStyle(
          size: 12,
          color: Colors.black,
          weight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
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
            "No internships posted yet",
            style: AppStyles.customTextStyle(
              size: 16,
              color: AppColors.whiteColor,
              weight: FontWeight.w500,
            ),
          ),
          Text(
            "Tap the '+' button below to post your first internship",
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

                // Company name + role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        job.companyName ?? "—",
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
            // ListTile(
            //   leading: const Icon(
            //     CupertinoIcons.trash,
            //     color: Colors.redAccent,
            //   ),
            //   title: Text(
            //     "Delete Internship",
            //     style: AppStyles.customTextStyle(
            //       size: 14,
            //       color: Colors.redAccent,
            //       weight: FontWeight.w500,
            //     ),
            //   ),
            //   onTap: () => Get.back(),
            // ),
            const SizedBox(height: 8),
          ],
        ),
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
