import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/common_utils.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_profile_model.dart';

class RecruiterProfileHeaderWidget extends StatelessWidget {
  final RecruiterProfileModel profile;

  const RecruiterProfileHeaderWidget({super.key, required this.profile});

  Widget _logoPlaceholder() => Container(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        child: const Icon(
          Icons.business_rounded,
          color: AppColors.primaryColor,
          size: 40,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final logoUrl = (profile.recruiterData?.recCompanyLogo ?? "").trim();
    return Column(
      spacing: 8,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                  width: 2.5,
                ),
                color: AppColors.primaryColor.withValues(alpha: 0.1),
              ),
              child: ClipOval(
                child: logoUrl.isNotEmpty
                    ? Image.network(
                        logoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _logoPlaceholder(),
                      )
                    : _logoPlaceholder(),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: () {
                  CommonUtils.showProfileImageViewer(
                    context,
                    profile.recruiterData?.recCompanyLogo ?? "",
                    profile.recruiterData?.recCompanyName ?? "",
                  );
                },
                child: Container(
                  height: 25,
                  width: 25,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.blackColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: AppColors.whiteColor,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          profile.recruiterData?.recName ?? "",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w700,
          ),
        ),
        Text(
          profile.recruiterData?.recCompanyName ?? "",
          textAlign: TextAlign.center,
          style: AppStyles.customTextStyle(
            size: 13,
            color: AppColors.greyTextColor,
            weight: FontWeight.w400,
            lineSpace: 1.4,
          ),
        ),
      ],
    );
  }
}

class RecruiterProfileStatRowWidget extends StatelessWidget {
  final RecruiterProfileModel profile;

  const RecruiterProfileStatRowWidget({super.key, required this.profile});

  static String extractCity(String? address) {
    if (address == null || address.trim().isEmpty) return "—";
    final parts = address
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    return parts.isNotEmpty ? parts.last : "—";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        _statChip(
          icon: Icons.groups_outlined,
          iconColor: AppColors.primaryColor,
          value: profile.recruiterData?.recCompanySize ?? "—",
          label: "Employees",
        ),
        _statChip(
          icon: Icons.business_center_rounded,
          iconColor: AppColors.orangeColor2,
          value: profile.recruiterData?.recCompanyIndustryType?.name ?? "—",
          label: "Industry",
        ),
        _statChip(
          icon: Icons.language_rounded,
          iconColor: AppColors.purpleColor,
          value: "Active",
          label: "Website",
        ),
        _statChip(
          icon: CupertinoIcons.location_solid,
          iconColor: AppColors.correctText,
          value: extractCity(profile.recruiterData?.recCompanyAddress),
          label: "Location",
        ),
      ],
    );
  }

  Widget _statChip({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.recContainerColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.recBorderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Icon(icon, color: iconColor, size: 23),
            SizedBox(
              height: 30,
              child: Text(
                value,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 15,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.customTextStyle(
                  size: 10,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

