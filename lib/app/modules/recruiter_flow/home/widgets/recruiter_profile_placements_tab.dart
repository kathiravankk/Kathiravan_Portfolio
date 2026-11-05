import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_placement_result_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';

class RecruiterProfilePlacementsTab extends StatefulWidget {
  final RecruiterHomeController profileController;
  final void Function(String url) onLaunchUrl;
  final String Function(dynamic date) formatDate;

  const RecruiterProfilePlacementsTab({
    super.key,
    required this.profileController,
    required this.onLaunchUrl,
    required this.formatDate,
  });

  @override
  State<RecruiterProfilePlacementsTab> createState() =>
      _RecruiterProfilePlacementsTabState();
}

class _RecruiterProfilePlacementsTabState
    extends State<RecruiterProfilePlacementsTab> {
  int _selectedPlacementSubTab = 0; // 0: Interview Schedule, 1: Placements

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.recContainerColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.recBorderColor),
    );
  }

  Widget _divider() => Divider(
        color: AppColors.recBorderColor,
        height: 1,
        thickness: 0.8,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 14,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sub-tabs: Interview Schedule vs Placements
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.recContainerColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.recBorderColor),
          ),
          child: Row(
            children: [
              _buildSubTabItem(
                index: 0,
                title: "Interview Schedule",
                icon: Icons.calendar_month_outlined,
              ),
              _buildSubTabItem(
                index: 1,
                title: "Placements",
                icon: Icons.workspace_premium_outlined,
              ),
            ],
          ),
        ),

        // Sub-tab view
        if (_selectedPlacementSubTab == 0)
          _buildInterviewScheduleSection()
        else
          _buildPlacementsSection(),
      ],
    );
  }

  Widget _buildSubTabItem({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedPlacementSubTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPlacementSubTab = index;
          });
          if (index == 0) {
            if (widget.profileController.interviewList.isEmpty &&
                !widget.profileController.interviewLoading.value) {
              widget.profileController.fetchInterviews();
            }
          } else {
            if (widget.profileController.placementList.isEmpty &&
                !widget.profileController.placementLoading.value) {
              widget.profileController.fetchPlacements();
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.secondaryColor.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: AppColors.secondaryColor.withValues(alpha: 0.45),
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected
                    ? AppColors.secondaryColor
                    : AppColors.greyTextColor,
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: isSelected
                      ? AppColors.secondaryColor
                      : AppColors.greyTextColor,
                  weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── INTERVIEW SCHEDULE SECTION ────────────────────────────────

  Widget _buildInterviewScheduleSection() {
    final statuses = [
      {"label": "All", "value": ""},
      {"label": "Scheduled", "value": "scheduled"},
      {"label": "Hold", "value": "hold"},
      {"label": "Placed", "value": "placed"},
      {"label": "Reject", "value": "reject"},
    ];

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8,
            children: statuses.map((item) {
              return Obx(() {
                final isSelected =
                    widget.profileController.selectedInterviewStatus.value ==
                        item["value"];
                return GestureDetector(
                  onTap: () {
                    widget.profileController.filterInterviewsByStatus(item["value"]!);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.recContainerColor,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.recBorderColor,
                      ),
                    ),
                    child: Text(
                      item["label"]!,
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: isSelected
                            ? AppColors.blackColor
                            : AppColors.greyTextColor,
                        weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        ),

        // Content
        Obx(() {
          if (widget.profileController.interviewLoading.value) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(child: AppAlertUtils.customLoader()),
            );
          }

          if (widget.profileController.interviewList.isEmpty) {
            final currentStatus =
                widget.profileController.selectedInterviewStatus.value;
            return _buildEmptyState(
              icon: Icons.event_busy_rounded,
              title: "No Interviews Found",
              subtitle: currentStatus.isEmpty
                  ? "There are no interview schedules available."
                  : "No interviews with status '$currentStatus' found.",
            );
          }

          return Column(
            spacing: 12,
            children: [
              ...widget.profileController.interviewList.map(
                (item) => _buildInterviewCard(item),
              ),

              // Pagination Load More
              if (widget.profileController.interviewPage.value <
                  widget.profileController.interviewTotalPages.value)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: widget.profileController.interviewLoadingMore.value
                        ? const CupertinoActivityIndicator(
                            color: AppColors.primaryColor,
                          )
                        : GestureDetector(
                            onTap: () => widget.profileController.fetchInterviews(
                              isLoadMore: true,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.primaryColor),
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 6,
                                children: [
                                  const Icon(
                                    Icons.refresh_rounded,
                                    size: 15,
                                    color: AppColors.primaryColor,
                                  ),
                                  Text(
                                    "Load More",
                                    style: AppStyles.customTextStyle(
                                      size: 13,
                                      color: AppColors.primaryColor,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildInterviewCard(RecruiterResultItem item) {
    final avatar = (item.student?.studprofile ?? "").trim();
    final name = (item.student?.studname ?? "Candidate").trim();
    final email = (item.student?.studemail ?? "").trim();
    final role = (item.job?.roletype ?? "Candidate").trim();
    final company = (item.companyName ?? item.job?.companyname ?? "").trim();
    final logo = (item.job?.companylogo ?? "").trim();
    final date = widget.formatDate(item.interviewDate);
    final time = (item.interviewTime ?? "").trim();
    final mode = (item.interviewMode ?? "").trim();
    final round = (item.interviewRound ?? "").trim();
    final location = (item.meetingLinkOrLocation ?? "").trim();
    final interviewer = (item.interviewerName ?? "").trim();
    final contactEmail = (item.contactEmail ?? "").trim();
    final instructions = (item.interviewInstructions ?? "").trim();

    final status = item.displayStatus.toLowerCase();
    Color statusBg;
    Color statusColor;
    switch (status) {
      case 'placed':
        statusBg = const Color(0xFF10B981).withValues(alpha: 0.15);
        statusColor = const Color(0xFF10B981);
        break;
      case 'scheduled':
        statusBg = AppColors.primaryColor.withValues(alpha: 0.15);
        statusColor = AppColors.primaryColor;
        break;
      case 'hold':
        statusBg = const Color(0xFFF59E0B).withValues(alpha: 0.15);
        statusColor = const Color(0xFFF59E0B);
        break;
      case 'reject':
        statusBg = const Color(0xFFEF4444).withValues(alpha: 0.15);
        statusColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = AppColors.primaryColor.withValues(alpha: 0.15);
        statusColor = AppColors.primaryColor;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: ClipOval(
                  child: avatar.isNotEmpty
                      ? Image.network(
                          avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                    if (email.isNotEmpty)
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 11.5,
                          color: AppColors.greyTextColor,
                          weight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: statusBg,
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  item.displayStatus.toUpperCase(),
                  style: AppStyles.customTextStyle(
                    size: 10.5,
                    color: statusColor,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          _divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (logo.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    logo,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: role.isNotEmpty ? "$role " : "",
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.secondaryColor,
                      weight: FontWeight.w600,
                    ),
                    children: [
                      if (company.isNotEmpty)
                        TextSpan(
                          text: "at $company",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: AppColors.greyTextColor,
                            weight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (round.isNotEmpty)
                _infoChip(Icons.stars_rounded, round, AppColors.orangeColor2),
              if (mode.isNotEmpty)
                _infoChip(
                  mode.toLowerCase() == 'online'
                      ? Icons.videocam_rounded
                      : Icons.business_rounded,
                  mode,
                  AppColors.purpleColor,
                ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardColor2,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder2),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  date,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
                if (time.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    time,
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (location.isNotEmpty) ...[
            if (location.startsWith("http"))
              GestureDetector(
                onTap: () => widget.onLaunchUrl(location),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.link_rounded,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Join Meeting / View Link",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: AppColors.primaryColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.open_in_new_rounded,
                        size: 14,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 15,
                    color: AppColors.greyTextColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      location,
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.greyTextColor,
                        weight: FontWeight.w400,
                        lineSpace: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
          ],
          if (interviewer.isNotEmpty || contactEmail.isNotEmpty)
            Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 14,
                  color: AppColors.greyTextColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Interviewer: $interviewer${contactEmail.isNotEmpty ? ' ($contactEmail)' : ''}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.customTextStyle(
                      size: 11.5,
                      color: AppColors.greyTextColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          if (instructions.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cardColor2.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Instructions: $instructions",
                style: AppStyles.customTextStyle(
                  size: 11.5,
                  color: const Color(0xFFCBD5E1),
                  weight: FontWeight.w400,
                  lineSpace: 1.3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── PLACEMENTS SECTION ────────────────────────────────────────

  Widget _buildPlacementsSection() {
    final statuses = [
      {"label": "All", "value": ""},
      {"label": "Active", "value": "active"},
      {"label": "Completed", "value": "completed"},
      {"label": "Terminated", "value": "terminated"},
    ];

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8,
            children: statuses.map((item) {
              return Obx(() {
                final isSelected =
                    widget.profileController.selectedPlacementStatus.value ==
                        item["value"];
                return GestureDetector(
                  onTap: () {
                    widget.profileController.filterPlacementsByStatus(item["value"]!);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.recContainerColor,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.recBorderColor,
                      ),
                    ),
                    child: Text(
                      item["label"]!,
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: isSelected
                            ? AppColors.blackColor
                            : AppColors.greyTextColor,
                        weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        ),

        // Content
        Obx(() {
          if (widget.profileController.placementLoading.value) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(child: AppAlertUtils.customLoader()),
            );
          }

          if (widget.profileController.placementList.isEmpty) {
            final currentStatus =
                widget.profileController.selectedPlacementStatus.value;
            return _buildEmptyState(
              icon: Icons.work_off_outlined,
              title: "No Placements Found",
              subtitle: currentStatus.isEmpty
                  ? "There are no student placements recorded."
                  : "No placements with status '$currentStatus' found.",
            );
          }

          return Column(
            spacing: 12,
            children: [
              ...widget.profileController.placementList.map(
                (item) => _buildPlacementCard(item),
              ),

              // Pagination Load More
              if (widget.profileController.placementPage.value <
                  widget.profileController.placementTotalPages.value)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: widget.profileController.placementLoadingMore.value
                        ? const CupertinoActivityIndicator(
                            color: AppColors.primaryColor,
                          )
                        : GestureDetector(
                            onTap: () => widget.profileController.fetchPlacements(
                              isLoadMore: true,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.primaryColor),
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 6,
                                children: [
                                  const Icon(
                                    Icons.refresh_rounded,
                                    size: 15,
                                    color: AppColors.primaryColor,
                                  ),
                                  Text(
                                    "Load More",
                                    style: AppStyles.customTextStyle(
                                      size: 13,
                                      color: AppColors.primaryColor,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildPlacementCard(RecruiterResultItem item) {
    final avatar = (item.student?.studprofile ?? "").trim();
    final name = (item.student?.studname ?? "Candidate").trim();
    final email = (item.student?.studemail ?? "").trim();
    final role = (item.job?.roletype ?? "Intern").trim();
    final company = (item.companyName ?? item.job?.companyname ?? "").trim();
    final logo = (item.job?.companylogo ?? "").trim();
    final date = widget.formatDate(item.interviewDate ?? item.createdAt);
    final offer = (item.offerLetter ?? "").trim();

    final status = item.displayStatus.toLowerCase();
    Color statusBg;
    Color statusColor;
    switch (status) {
      case 'active':
        statusBg = const Color(0xFF10B981).withValues(alpha: 0.15);
        statusColor = const Color(0xFF10B981);
        break;
      case 'completed':
        statusBg = AppColors.primaryColor.withValues(alpha: 0.15);
        statusColor = AppColors.primaryColor;
        break;
      case 'terminated':
        statusBg = const Color(0xFFEF4444).withValues(alpha: 0.15);
        statusColor = const Color(0xFFEF4444);
        break;
      default:
        statusBg = const Color(0xFF10B981).withValues(alpha: 0.15);
        statusColor = const Color(0xFF10B981);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: ClipOval(
                  child: avatar.isNotEmpty
                      ? Image.network(
                          avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                    if (email.isNotEmpty)
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 11.5,
                          color: AppColors.greyTextColor,
                          weight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: statusBg,
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  item.displayStatus.toUpperCase(),
                  style: AppStyles.customTextStyle(
                    size: 10.5,
                    color: statusColor,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          _divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (logo.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    logo,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: role.isNotEmpty ? "$role " : "",
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.secondaryColor,
                      weight: FontWeight.w600,
                    ),
                    children: [
                      if (company.isNotEmpty)
                        TextSpan(
                          text: "at $company",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: AppColors.greyTextColor,
                            weight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.cardColor2,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.cardBorder2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 13,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      date,
                      style: AppStyles.customTextStyle(
                        size: 11.5,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.interviewMode != null && item.interviewMode!.isNotEmpty) ...[
                const SizedBox(width: 8),
                _infoChip(
                  Icons.business_rounded,
                  item.interviewMode!,
                  AppColors.purpleColor,
                ),
              ],
            ],
          ),
          if (offer.isNotEmpty) ...[
            _divider(),
            GestureDetector(
              onTap: () => widget.onLaunchUrl(offer),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6,
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    Text(
                      "View Offer Letter",
                      style: AppStyles.customTextStyle(
                        size: 12.5,
                        color: AppColors.primaryColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.open_in_new_rounded,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, size: 12, color: color),
          Text(
            label,
            style: AppStyles.customTextStyle(
              size: 11,
              color: color,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: _cardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withValues(alpha: 0.1),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 36),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: AppStyles.customTextStyle(
              size: 16,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppStyles.customTextStyle(
              size: 12.5,
              color: AppColors.greyTextColor,
              weight: FontWeight.w400,
              lineSpace: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

