import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/utils/common_utils.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_profile_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class RecruiterProfileScreen extends StatefulWidget {
  const RecruiterProfileScreen({super.key});

  @override
  State<RecruiterProfileScreen> createState() => _RecruiterProfileScreenState();
}

class _RecruiterProfileScreenState extends State<RecruiterProfileScreen> {
  final RecruiterHomeController profileController =
      Get.find<RecruiterHomeController>();

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  Future<void> getProfileData() async {
    final recruiterId = await LocalStorageService.getRecruiterId();
    try {
      await profileController.getRecruiterProfileData(
        recruiterId: recruiterId ?? "",
      );
      if (profileController.getResponseCode() != 200 &&
          profileController.getResponseCode() != 201) {
        AppFunctions.apiErrorHandling(
          profileController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (_) {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    if (url.trim().isEmpty) return;
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openInMaps(String address) async {
    final encoded = Uri.encodeComponent(address);
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encoded',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ── HELPERS ───────────────────────────────────────────────────

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.recContainerColor,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.recBorderColor),
  );

  Widget _divider() =>
      Divider(color: AppColors.whiteColor.withValues(alpha: 0.07), height: 1);

  String _extractCity(String? address) {
    if (address == null || address.trim().isEmpty) return "—";
    final parts = address
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    return parts.isNotEmpty ? parts.last : "—";
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
        body: Obx(
          () => profileController.profileLoading
              ? AppAlertUtils.customLoader()
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildProfileHeader(profileController.profileModel),
                      _buildStatRow(profileController.profileModel),
                      _buildOfficeInfoCard(profileController.profileModel),
                      _buildPersonalInfoCard(profileController.profileModel),
                      _buildContactDetailsCard(profileController.profileModel),
                      _buildAddressCard(profileController.profileModel),
                      _buildCompanyDetailsCard(profileController.profileModel),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ── APP BAR ───────────────────────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.transparentColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
          color: AppColors.whiteColor,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "My Profile",
        style: AppStyles.customTextStyle(
          size: 18,
          color: AppColors.secondaryColor,
          weight: FontWeight.w600,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            AppFunctions.navigateScreen(
              context,
              AppRoutes.recruiterProfileEditScreen,
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primaryColor),
              color: AppColors.primaryColor.withValues(alpha: 0.15),
            ),
            child: Row(
              spacing: 5,
              children: [
                const Icon(
                  CupertinoIcons.pencil_outline,
                  color: AppColors.primaryColor,
                  size: 14,
                ),
                Text(
                  "Edit Profile",
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
    );
  }

  // ── PROFILE HEADER ────────────────────────────────────────────

  Widget _buildProfileHeader(RecruiterProfileModel profile) {
    final logoUrl = (profile.recCompanyLogo ?? "").trim();
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
                    profile.recCompanyLogo ??
                        "",
                    profile.recCompanyName ??
                        "",
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
                  child:  Icon(
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
          profile.recName ?? "",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w700,
          ),
        ),
        Text(
          profile.recCompanyName ?? "",
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

  Widget _logoPlaceholder() => Container(
    color: AppColors.primaryColor.withValues(alpha: 0.1),
    child: const Icon(
      Icons.business_rounded,
      color: AppColors.primaryColor,
      size: 40,
    ),
  );

  Widget _buildStatRow(RecruiterProfileModel profile) {
    return Row(
      spacing: 8,
      children: [
        _statChip(
          icon: Icons.groups_outlined,
          iconColor: AppColors.primaryColor,
          value: profile.recCompanySize ?? "—",
          label: "Employees",
        ),
        _statChip(
          icon: Icons.business_center_rounded,
          iconColor: AppColors.orangeColor2,
          value: profile.recCompanyIndustryType?.name ?? "—",
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
          value: _extractCity(profile.recCompanyAddress),
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
              height: 25,
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
            Text(
              label,
              style: AppStyles.customTextStyle(
                size: 10,
                color: AppColors.greyTextColor,
                weight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── OFFICE INFO ───────────────────────────────────────────────

  Widget _buildOfficeInfoCard(RecruiterProfileModel profile) {
    return _sectionCard(
      icon: Icons.business_center_rounded,
      title: "Office Info",
      children: [
        _infoRow(
          icon: CupertinoIcons.building_2_fill,
          label: "Company\nName",
          value: profile.recCompanyName ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: Icons.factory_outlined,
          label: "Industry",
          value: profile.recCompanyIndustryType?.name ?? "—",
        ),
        _divider(),
        _infoRowWidget(
          icon: CupertinoIcons.globe,
          label: "Website",
          child: GestureDetector(
            onTap: () => _launchUrl(profile.recCompanyWebsite ?? ""),
            child: Row(
              spacing: 4,
              children: [
                Flexible(
                  child: Text(
                    profile.recCompanyWebsite ?? "—",
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
                if ((profile.recCompanyWebsite ?? "").isNotEmpty)
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
          value: profile.recCompanySize ?? "—",
        ),
      ],
    );
  }

  // ── PERSONAL INFO ─────────────────────────────────────────────

  Widget _buildPersonalInfoCard(RecruiterProfileModel profile) {
    return _sectionCard(
      icon: Icons.person_rounded,
      title: "Personal Info",
      children: [
        _infoRow(
          icon: CupertinoIcons.mail,
          label: "Email",
          value: profile.recEmail ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: CupertinoIcons.phone,
          label: "Phone",
          value: profile.recMobileNo ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: CupertinoIcons.person,
          label: "Gender",
          value: profile.recGender ?? "—",
        ),
      ],
    );
  }

  // ── CONTACT DETAILS ───────────────────────────────────────────

  Widget _buildContactDetailsCard(RecruiterProfileModel profile) {
    final alternate = (profile.recSecondaryMobileNo ?? "").trim();
    return _sectionCard(
      icon: Icons.phone_in_talk_rounded,
      title: "Contact Details",
      children: [
        _infoRow(
          icon: CupertinoIcons.phone,
          label: "Phone",
          value: profile.recMobileNo ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: CupertinoIcons.mail,
          label: "Email",
          value: profile.recEmail ?? "—",
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

  Widget _buildAddressCard(RecruiterProfileModel profile) {
    final address = (profile.recCompanyAddress ?? "").trim();
    final pincode = (profile.recCompanyPinCode ?? "").trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          // header
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

          // address text
          Text(
            address.isNotEmpty ? address : "—",
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.whiteColor,
              weight: FontWeight.w400,
              lineSpace: 1.5,
            ),
          ),

          // pincode
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

          // mini map card
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
                    onTap: () => _openInMaps(address),
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
                          Icon(
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

  Widget _buildCompanyDetailsCard(RecruiterProfileModel profile) {
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
                label: "${profile.recCompanySize ?? "—"} Employees",
              ),
              _companyChip(
                icon: Icons.monitor_rounded,
                label: profile.recCompanyIndustryType?.name ?? "—",
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

  // ── SECTION CARD / ROW HELPERS ────────────────────────────────

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
