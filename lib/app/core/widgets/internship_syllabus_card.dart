import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

class InternSyllabusCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final int totalWeeks;
  final int totalTopics;
  final VoidCallback viewFunc;
  final bool isLoading;

  // Job info fields
  final String? companyName;
  final String? companyLogo;
  final String? roleType;
  final String? internshipMode;
  final String? jobType;

  const InternSyllabusCard({
    super.key,
    this.title = "",
    this.subTitle = "",
    this.totalWeeks = 0,
    required this.viewFunc,
    this.totalTopics = 0,
    this.isLoading = false,
    this.companyName,
    this.companyLogo,
    this.roleType,
    this.internshipMode,
    this.jobType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.contColor2,
        border: Border.all(color: AppColors.contBorderColor2, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: Logo + Role + Company ──────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Company logo
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.contButtonColor,
                  border: Border.all(color: AppColors.contBorderColor2),
                ),
                clipBehavior: Clip.hardEdge,
                child: _buildCompanyLogo(),
              ),
              const SizedBox(width: 12),

              // Role + Company name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roleType?.capitalize ?? roleType ?? "NA",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.customTextStyle(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      companyName ?? "NA",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.customTextStyle(
                        size: 13,
                        weight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Job type badge
              if (jobType != null && jobType!.isNotEmpty) _jobTypeBadge(jobType!),
            ],
          ),

          const SizedBox(height: 14),

          // ── Divider ───────────────────────────────────────────────────
          Container(height: 1, color: AppColors.contBorderColor2),

          const SizedBox(height: 14),

          // ── Course subject ────────────────────────────────────────────
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: 14,
              lineSpace: 1.35,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          // ── Beginner to Advanced ──────────────────────────────────────
          Text(
            "Beginner to Advanced",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.lightText,
              weight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 12),

          // ── Stats row: Mode · Days · Topics ──────────────────────────
          Row(
            children: [
              // Internship mode
              if (internshipMode != null && internshipMode!.isNotEmpty) ...[
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryColor,
                  size: 14,
                ),
                const SizedBox(width: 3),
                Text(
                  internshipMode!,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w600,
                  ),
                ),
                _dot(),
              ],

              // Days
              Icon(
                Icons.access_time_sharp,
                color: AppColors.secondaryColor,
                size: 14,
              ),
              const SizedBox(width: 3),
              Text(
                getWeek(totalWeeks),
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.lightText,
                  weight: FontWeight.w400,
                ),
              ),
              _dot(),

              // Total topics
              Icon(
                Icons.format_list_numbered_outlined,
                color: AppColors.secondaryColor,
                size: 14,
              ),
              const SizedBox(width: 3),
              Text(
                "$totalTopics Topics",
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.lightText,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Start Now Button ──────────────────────────────────────────
          CustomButtonWidget(
            isLoading: isLoading,
            height: 44,
            buttonFunction: viewFunc,
            buttonText: "Start Now",
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  Widget _buildCompanyLogo() {
    final logoPath = companyLogo ?? '';
    final fullUrl = logoPath.startsWith('http')
        ? logoPath
        : '${AppApiUrls.newBaseUrl.replaceAll('/api/', '/')}$logoPath';

    return Image.network(
      fullUrl,
      height: 52,
      width: 52,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.business_outlined,
        color: AppColors.greyIcon,
        size: 26,
      ),
    );
  }

  Widget _jobTypeBadge(String label) {
    final Color badgeColor;
    final Color bgColor;

    switch (label.toLowerCase()) {
      case 'stipend':
        badgeColor = AppColors.primaryColor;         // teal
        bgColor = AppColors.primaryColor.withValues(alpha: 0.12);
        break;
      case 'fee':
        badgeColor = AppColors.orangeColor2;         // orange-red
        bgColor = AppColors.orangeColor2.withValues(alpha: 0.12);
        break;
      case 'free':
        badgeColor = AppColors.correctText;          // green
        bgColor = AppColors.correctBg;
        break;
      default:
        badgeColor = AppColors.lightText;
        bgColor = AppColors.contButtonColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppStyles.customTextStyle(
          size: 11,
          color: badgeColor,
          weight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _dot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.greyIcon,
        ),
      ),
    );
  }

  static String getWeek(int week) {
    return week <= 1 ? "$week Day" : "$week Days";
  }
}
