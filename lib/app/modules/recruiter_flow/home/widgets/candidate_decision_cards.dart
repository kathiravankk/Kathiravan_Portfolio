import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_test_result_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/widgets/intern_test_result_cards.dart';

// ─────────────────────────────────────────────────────────────────────────────
// INTERVIEW DECISION DETAILS CARD
// ─────────────────────────────────────────────────────────────────────────────

class InterviewDecisionDetailsCard extends StatelessWidget {
  final InterviewDecisionDetails? details;
  final String? fallbackCompanyName;
  final void Function(String url) onOpenUrl;

  const InterviewDecisionDetailsCard({
    super.key,
    required this.details,
    this.fallbackCompanyName,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.calendar,
                  color: AppColors.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Interview Scheduled",
                      style: AppStyles.customTextStyle(
                        size: 17,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details?.companyName ??
                          fallbackCompanyName ??
                          "Double Tap Innovations",
                      style: AppStyles.customTextStyle(
                        size: 13,
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
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  (details?.interviewStatus ?? "SCHEDULED").toUpperCase(),
                  style: AppStyles.customTextStyle(
                    size: 11,
                    color: const Color(0xFF10B981),
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 24),
          _buildInfoRow(
            icon: CupertinoIcons.calendar_today,
            label: "Interview Date & Time",
            value:
                "${DailyProgressCard.formatDate(details?.interviewDate)} at ${details?.interviewTime ?? '—'}",
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: CupertinoIcons.device_laptop,
            label: "Interview Mode",
            value: details?.interviewMode ?? "Online",
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: CupertinoIcons.layers,
            label: "Interview Round",
            value: details?.interviewRound ?? "Technical Round",
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: CupertinoIcons.person_crop_circle,
            label: "Interviewer Name",
            value: details?.interviewerName ?? "—",
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: CupertinoIcons.phone,
            label: "Contact Email / Phone",
            value: details?.contactEmail ?? "—",
          ),
          if ((details?.meetingLinkOrLocation ?? "").isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildMeetingLinkTile(details!.meetingLinkOrLocation!),
          ],
          if ((details?.interviewInstructions ?? "").isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: CupertinoIcons.info_circle,
              label: "Interview Instructions",
              value: details!.interviewInstructions!,
            ),
          ],
          if (details?.recruiter?.name != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: CupertinoIcons.briefcase,
              label: "Scheduled By",
              value:
                  "${details!.recruiter!.name} (${details!.recruiter!.email ?? ''})",
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF10B981),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Interview details recorded and notification sent to student.",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: const Color(0xFF10B981),
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingLinkTile(String linkOrLocation) {
    final isUrl = linkOrLocation.startsWith("http://") ||
        linkOrLocation.startsWith("https://");

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            CupertinoIcons.link,
            color: AppColors.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Meeting Link / Location",
                  style: AppStyles.customTextStyle(
                    size: 11,
                    color: AppColors.greyTextColor,
                    weight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: isUrl ? () => onOpenUrl(linkOrLocation) : null,
                  child: Text(
                    linkOrLocation,
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: isUrl
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.greyTextColor),
        const SizedBox(width: 10),
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.greyTextColor,
              weight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppStyles.customTextStyle(
              size: 13,
              color: valueColor ?? AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEMENT DECISION DETAILS CARD
// ─────────────────────────────────────────────────────────────────────────────

class PlacementDecisionDetailsCard extends StatelessWidget {
  final PlacementDecisionDetails? details;
  final String? fallbackCompanyName;
  final void Function(String url) onOpenUrl;

  const PlacementDecisionDetailsCard({
    super.key,
    required this.details,
    this.fallbackCompanyName,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.briefcase_fill,
                  color: Color(0xFF10B981),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details?.jobTitle ?? "Candidate Placed",
                      style: AppStyles.customTextStyle(
                        size: 17,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details?.companyName ??
                          fallbackCompanyName ??
                          "Double Tap Innovations",
                      style: AppStyles.customTextStyle(
                        size: 13,
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
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  "JOB PLACED",
                  style: AppStyles.customTextStyle(
                    size: 11,
                    color: const Color(0xFF10B981),
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 24),
          _buildInfoRow(
            icon: Icons.currency_rupee_rounded,
            label: "Annual Salary / CTC",
            value: details?.annualSalary ?? "—",
            valueColor: AppColors.primaryColor,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: CupertinoIcons.calendar,
            label: "Joining Date",
            value: DailyProgressCard.formatDate(details?.joiningDate),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: CupertinoIcons.briefcase,
            label: "Employment Type",
            value: details?.employmentType ?? "Full-time",
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: CupertinoIcons.building_2_fill,
            label: "Work Mode",
            value: details?.workMode ?? "On-site",
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: CupertinoIcons.location_solid,
            label: "Job Location",
            value: details?.jobLocation ?? "—",
          ),
          if ((details?.placementNotes ?? "").isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: CupertinoIcons.chat_bubble_text,
              label: "Placement Notes",
              value: details!.placementNotes!,
            ),
          ],
          if ((details?.offerLetter ?? "").isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.doc_text_fill,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Offer Letter Document",
                          style: AppStyles.customTextStyle(
                            size: 13,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Official offer letter issued to the student",
                          style: AppStyles.customTextStyle(
                            size: 11,
                            color: AppColors.greyTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => onOpenUrl(details!.offerLetter!),
                    icon: const Icon(
                      CupertinoIcons.eye_fill,
                      size: 14,
                      color: Colors.black,
                    ),
                    label: Text(
                      "View",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: Colors.black,
                        weight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF10B981),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Placement decision recorded and email sent to student successfully.",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: const Color(0xFF10B981),
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.greyTextColor),
        const SizedBox(width: 10),
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.greyTextColor,
              weight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppStyles.customTextStyle(
              size: 13,
              color: valueColor ?? AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

