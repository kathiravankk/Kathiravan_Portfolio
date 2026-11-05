import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_profile_model.dart';

class RecruiterProfileAboutTab extends StatelessWidget {
  final RecruiterProfileModel profile;
  final void Function(String url) onLaunchUrl;
  final void Function(String address) onOpenMaps;

  const RecruiterProfileAboutTab({
    super.key,
    required this.profile,
    required this.onLaunchUrl,
    required this.onOpenMaps,
  });

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
      children: [
        _buildOfficeInfoCard(),
        _buildPersonalInfoCard(),
        _buildContactDetailsCard(),
        _buildAddressCard(),
        _buildCompanyDetailsCard(),
      ],
    );
  }

  // ── OFFICE INFO ───────────────────────────────────────────────

  Widget _buildOfficeInfoCard() {
    final rec = profile.recruiterData;
    return _sectionCard(
      icon: Icons.business_center_rounded,
      title: "Office Info",
      children: [
        _infoRow(
          icon: CupertinoIcons.building_2_fill,
          label: "Company\nName",
          value: rec?.recCompanyName ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: Icons.factory_outlined,
          label: "Industry",
          value: rec?.recCompanyIndustryType?.name ?? "—",
        ),
        _divider(),
        _infoRowWidget(
          icon: CupertinoIcons.globe,
          label: "Website",
          child: GestureDetector(
            onTap: () => onLaunchUrl(rec?.recCompanyWebsite ?? ""),
            child: Row(
              spacing: 4,
              children: [
                Flexible(
                  child: Text(
                    rec?.recCompanyWebsite ?? "—",
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
                if ((rec?.recCompanyWebsite ?? "").isNotEmpty)
                  const Icon(
                    Icons.open_in_new_rounded,
                    color: AppColors.primaryColor,
                    size: 14,
                  ),
              ],
            ),
          ),
        ),
        _divider(),
        _infoRow(
          icon: Icons.people_alt_outlined,
          label: "Company\nSize",
          value: rec?.recCompanySize ?? "—",
        ),
      ],
    );
  }

  // ── PERSONAL INFO ─────────────────────────────────────────────

  Widget _buildPersonalInfoCard() {
    final rec = profile.recruiterData;
    return _sectionCard(
      icon: Icons.person_rounded,
      title: "Personal Info",
      children: [
        _infoRow(
          icon: CupertinoIcons.mail,
          label: "Email",
          value: rec?.recEmail ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: CupertinoIcons.phone,
          label: "Phone",
          value: rec?.recMobileNo ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: CupertinoIcons.person,
          label: "Gender",
          value: rec?.recGender ?? "—",
        ),
      ],
    );
  }

  // ── CONTACT DETAILS ───────────────────────────────────────────

  Widget _buildContactDetailsCard() {
    final rec = profile.recruiterData;
    final alternate = (rec?.recSecondaryMobileNo ?? "").trim();
    return _sectionCard(
      icon: Icons.phone_in_talk_rounded,
      title: "Contact Details",
      children: [
        _infoRow(
          icon: CupertinoIcons.phone,
          label: "Phone",
          value: rec?.recMobileNo ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: CupertinoIcons.mail,
          label: "Email",
          value: rec?.recEmail ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: CupertinoIcons.chat_bubble,
          label: "Alternate\nContact",
          value: alternate.isEmpty ? "Not provided" : alternate,
          valueColor: alternate.isEmpty ? AppColors.greyTextColor : null,
        ),
      ],
    );
  }

  // ── ADDRESS ───────────────────────────────────────────────────

  Widget _buildAddressCard() {
    final rec = profile.recruiterData;
    final address = (rec?.recCompanyAddress ?? "").trim();
    final pincode = (rec?.recCompanyPinCode ?? "").trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            spacing: 8,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppColors.secondaryColor,
                size: 20,
              ),
              Text(
                "Address",
                style: AppStyles.customTextStyle(
                  size: 15,
                  color: AppColors.secondaryColor,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            address.isNotEmpty ? address : "—",
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.whiteColor,
              weight: FontWeight.w400,
              lineSpace: 1.5,
            ),
          ),
          if (pincode.isNotEmpty)
            RichText(
              text: TextSpan(
                text: "Pincode: ",
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: pincode,
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.15),
                    AppColors.primaryColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  const Icon(
                    CupertinoIcons.location_solid,
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                  GestureDetector(
                    onTap: () => onOpenMaps(address),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1,
                        ),
                        color: AppColors.primaryColor.withValues(alpha: 0.15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [
                          const Icon(
                            CupertinoIcons.location_fill,
                            color: AppColors.primaryColor,
                            size: 14,
                          ),
                          Text(
                            "Open in Maps",
                            style: AppStyles.customTextStyle(
                              size: 12,
                              color: AppColors.primaryColor,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

  // ── COMPANY DETAILS CHIPS ─────────────────────────────────────

  Widget _buildCompanyDetailsCard() {
    final rec = profile.recruiterData;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            spacing: 8,
            children: [
              const Icon(
                Icons.work_rounded,
                color: AppColors.secondaryColor,
                size: 20,
              ),
              Text(
                "Company Details",
                style: AppStyles.customTextStyle(
                  size: 15,
                  color: AppColors.secondaryColor,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              _companyChip(
                icon: Icons.people_alt_rounded,
                label: "${rec?.recCompanySize ?? "—"} Employees",
              ),
              _companyChip(
                icon: Icons.monitor_rounded,
                label: rec?.recCompanyIndustryType?.name ?? "—",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _companyChip({required IconData icon, required String label}) {
    return Expanded(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardColor2,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder2),
        ),
        child: Row(
          spacing: 10,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 18),
            Flexible(
              child: Text(
                label,
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                  lineSpace: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(icon, color: AppColors.secondaryColor, size: 20),
              Text(
                title,
                style: AppStyles.customTextStyle(
                  size: 16,
                  color: AppColors.secondaryColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return _infoRowWidget(
      icon: icon,
      label: label,
      child: Text(
        value,
        style: AppStyles.customTextStyle(
          size: 14,
          color: valueColor ?? AppColors.whiteColor,
          weight: FontWeight.w400,
          lineSpace: 1.4,
        ),
      ),
    );
  }

  Widget _infoRowWidget({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.greyTextColor, size: 16),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.greyTextColor,
                weight: FontWeight.w400,
                lineSpace: 1.4,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

