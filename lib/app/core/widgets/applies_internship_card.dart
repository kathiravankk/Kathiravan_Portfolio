import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class AppliesInternshipCard extends StatelessWidget {
  final String? role;
  final String? companyName;
  final String? companyLocation;
  final String? internshipType;   // e.g. "Internship" / "Full Time"
  final String? duration;         // e.g. "3 Month"
  final String? companyLogo;
  final VoidCallback? viewFunc;

  const AppliesInternshipCard({
    super.key,
    this.role           = '',
    this.companyName    = '',
    this.companyLocation= '',
    this.internshipType = 'Internship',
    this.duration       = '',
    this.companyLogo    = '',
    this.viewFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color        : AppColors.whiteColor,
        borderRadius : BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Row 1: Logo + Title + Company ────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Company logo
              Container(
                decoration: BoxDecoration(
                  shape : BoxShape.circle,
                  border: Border.all(color: AppColors.navBarColor, width: 0.5),
                ),
                child: ClipOval(
                  child: Image.network(
                    companyLogo ?? '',
                    height     : 50,
                    width      : 50,
                    fit        : BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height    : 50,
                      width     : 50,
                      color     : AppColors.whiteColor,
                      child     : const Icon(
                        Icons.business_outlined,
                        color: AppColors.lightHintText,
                        size : 28,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title + company name
              Expanded(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role!.capitalize ?? '',
                      style: AppStyles.customTextStyle(
                        size  : 14,
                        weight: FontWeight.w700,
                        color : AppColors.disableButtonColor2,
                      ),
                    ),
                    Text(
                      companyName ?? '',
                      style: AppStyles.customTextStyle(
                        size  : 12,
                        weight: FontWeight.w400,
                        color : AppColors.selectedContColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Row 2: Location chip + Type chip ─────────────────────────
          Row(
            children: [
              // Location — teal/primary color text with pin icon
              Icon(
                Icons.location_on_outlined,
                size : 15,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 3),
              Text(
                companyLocation ?? '',
                style: AppStyles.customTextStyle(
                  size  : 10,
                  weight: FontWeight.w700,
                  color : AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 10),

              // Internship type pill
              Container(
                padding   : const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color       : AppColors.lightWhiteCont,
                  borderRadius: BorderRadius.circular(20),
                  border      : Border.all(
                      color: AppColors.fieldBorderColor, width: 0.5),
                ),
                child: Text(
                  internshipType ?? 'Internship',
                  style: AppStyles.customTextStyle(
                    size  : 10,
                    weight: FontWeight.w500,
                    color : AppColors.lightBlackText2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Row 3: Duration badge + View Details button ───────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Duration badge — yellow background
              Container(
                padding   : const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color       : AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children    : [
                    const Icon(
                      Icons.access_time_rounded,
                      size : 13,
                      color: AppColors.blackColor,
                    ),
                    Text(
                      'Duration : $duration',
                      style: AppStyles.customTextStyle(
                        size  : 10,
                        weight: FontWeight.w600,
                        color : AppColors.lightBlackText2,
                      ),
                    ),
                  ],
                ),
              ),

              // View Details button — dark navy blue
              GestureDetector(
                onTap: viewFunc,
                child: Container(
                  padding   : const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color       : AppColors.selectedContColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children    : [
                      Text(
                        'View Details',
                        style: AppStyles.customTextStyle(
                          size  : 12,
                          weight: FontWeight.w600,
                          color : AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size : 11,
                        color: AppColors.whiteColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}