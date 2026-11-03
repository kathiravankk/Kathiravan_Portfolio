import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/utils/common_utils.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_placement_result_model.dart';
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

  int _selectedMainTab = 0; // 0: ABOUT, 1: REVIEWS, 2: PLACEMENT LIST
  int _selectedPlacementSubTab = 0; // 0: Interview Schedule, 1: Placements

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

  String _formatDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return "—";
    try {
      final dt = DateTime.parse(raw);
      return DateFormat("dd MMM yyyy").format(dt);
    } catch (_) {
      return raw;
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
                      _buildMainTabBar(),
                      if (_selectedMainTab == 0) ...[
                        _buildOfficeInfoCard(profileController.profileModel),
                        _buildPersonalInfoCard(profileController.profileModel),
                        _buildContactDetailsCard(profileController.profileModel),
                        _buildAddressCard(profileController.profileModel),
                        _buildCompanyDetailsCard(profileController.profileModel),
                      ] else if (_selectedMainTab == 1) ...[
                        _buildReviewsTabContent(),
                      ] else ...[
                        _buildPlacementListTabContent(),
                      ],
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
        // Edit Profile button only shows when the first tab "ABOUT" is selected
        if (_selectedMainTab == 0)
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
    final logoUrl = (profile.recruiterData!.recCompanyLogo ?? "").trim();
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
                    profile.recruiterData!.recCompanyLogo ??
                        "",
                    profile.recruiterData!.recCompanyName ??
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
          profile.recruiterData!.recName ?? "",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w700,
          ),
        ),
        Text(
          profile.recruiterData!.recCompanyName ?? "",
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
          value: profile.recruiterData!.recCompanySize ?? "—",
          label: "Employees",
        ),
        _statChip(
          icon: Icons.business_center_rounded,
          iconColor: AppColors.orangeColor2,
          value: profile.recruiterData!.recCompanyIndustryType?.name ?? "—",
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
          value: _extractCity(profile.recruiterData!.recCompanyAddress),
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

  // ── OFFICE INFO ───────────────────────────────────────────────

  Widget _buildOfficeInfoCard(RecruiterProfileModel profile) {
    return _sectionCard(
      icon: Icons.business_center_rounded,
      title: "Office Info",
      children: [
        _infoRow(
          icon: CupertinoIcons.building_2_fill,
          label: "Company\nName",
          value: profile.recruiterData!.recCompanyName ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: Icons.factory_outlined,
          label: "Industry",
          value: profile.recruiterData!.recCompanyIndustryType?.name ?? "—",
        ),
        _divider(),
        _infoRowWidget(
          icon: CupertinoIcons.globe,
          label: "Website",
          child: GestureDetector(
            onTap: () => _launchUrl(profile.recruiterData!.recCompanyWebsite ?? ""),
            child: Row(
              spacing: 4,
              children: [
                Flexible(
                  child: Text(
                    profile.recruiterData!.recCompanyWebsite ?? "—",
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
                if ((profile.recruiterData!.recCompanyWebsite ?? "").isNotEmpty)
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
          value: profile.recruiterData!.recCompanySize ?? "—",
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
          value: profile.recruiterData!.recEmail ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: CupertinoIcons.phone,
          label: "Phone",
          value: profile.recruiterData!.recMobileNo ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: CupertinoIcons.person,
          label: "Gender",
          value: profile.recruiterData!.recGender ?? "—",
        ),
      ],
    );
  }

  // ── CONTACT DETAILS ───────────────────────────────────────────

  Widget _buildContactDetailsCard(RecruiterProfileModel profile) {
    final alternate = (profile.recruiterData!.recSecondaryMobileNo ?? "").trim();
    return _sectionCard(
      icon: Icons.phone_in_talk_rounded,
      title: "Contact Details",
      children: [
        _infoRow(
          icon: CupertinoIcons.phone,
          label: "Phone",
          value: profile.recruiterData!.recMobileNo ?? "—",
        ),
        _divider(),
        _infoRow(
          icon: CupertinoIcons.mail,
          label: "Email",
          value: profile.recruiterData!.recEmail ?? "—",
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
    final address = (profile.recruiterData!.recCompanyAddress ?? "").trim();
    final pincode = (profile.recruiterData!.recCompanyPinCode ?? "").trim();

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
                label: "${profile.recruiterData!.recCompanySize ?? "—"} Employees",
              ),
              _companyChip(
                icon: Icons.monitor_rounded,
                label: profile.recruiterData!.recCompanyIndustryType?.name ?? "—",
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

  // ── MAIN TAB BAR ───────────────────────────────────────────────

  Widget _buildMainTabBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.recContainerColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.recBorderColor),
      ),
      child: Row(
        children: [
          _buildMainTabItem(index: 0, title: "ABOUT"),
          _buildMainTabItem(index: 1, title: "REVIEWS"),
          _buildMainTabItem(index: 2, title: "PLACEMENT LIST"),
        ],
      ),
    );
  }

  Widget _buildMainTabItem({required int index, required String title}) {
    final isSelected = _selectedMainTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMainTab = index;
          });
          if (index == 2) {
            if (_selectedPlacementSubTab == 0 &&
                profileController.interviewList.isEmpty &&
                !profileController.interviewLoading.value) {
              profileController.fetchInterviews();
            } else if (_selectedPlacementSubTab == 1 &&
                profileController.placementList.isEmpty &&
                !profileController.placementLoading.value) {
              profileController.fetchPlacements();
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: 11.5,
              color: isSelected ? AppColors.blackColor : AppColors.greyTextColor,
              weight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ── REVIEWS TAB ────────────────────────────────────────────────

  Widget _buildReviewsTabContent() {
    final reviews = profileController.profileModel.reviews ??
        profileController.profileModel.recruiterData?.reviews ??
        [];

    if (reviews.isEmpty) {
      return _buildEmptyState(
        icon: Icons.rate_review_outlined,
        title: "No Reviews Yet",
        subtitle:
            "Feedback and reviews submitted by candidates will appear here.",
      );
    }

    double totalRating = 0.0;
    int ratedCount = 0;
    for (var r in reviews) {
      final num? ratingNum = r.rating is num
          ? (r.rating as num)
          : num.tryParse(r.rating?.toString() ?? "");
      if (ratingNum != null && ratingNum > 0) {
        totalRating += ratingNum;
        ratedCount++;
      }
    }
    final double avgRating = ratedCount > 0 ? (totalRating / ratedCount) : 0.0;

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary header card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: _cardDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 8,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFC107),
                    size: 26,
                  ),
                  Text(
                    avgRating > 0 ? avgRating.toStringAsFixed(1) : "0.0",
                    style: AppStyles.customTextStyle(
                      size: 18,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "out of 5.0",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.greyTextColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  "${reviews.length} ${reviews.length == 1 ? 'Review' : 'Reviews'}",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // List of reviews
        ...reviews.map((review) => _buildReviewCard(review)),
      ],
    );
  }

  Widget _buildReviewCard(RecruiterReviewItem review) {
    final avatar = (review.studentProfile ?? "").trim();
    final name = (review.studentName ?? "Candidate").trim();
    final email = (review.studentEmail ?? "").trim();
    final comment = (review.review ?? "").trim();
    final date = _formatDate(review.createdAt);

    final num? ratingNum = review.rating is num
        ? (review.rating as num)
        : num.tryParse(review.rating?.toString() ?? "");
    final int ratingInt = (ratingNum ?? 0).round().clamp(0, 5);

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
                      name.isNotEmpty ? name : "Candidate",
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < ratingInt
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: const Color(0xFFFFC107),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            _divider(),
            Text(
              comment,
              style: AppStyles.customTextStyle(
                size: 13,
                color: const Color(0xFFE2E8F0),
                weight: FontWeight.w400,
                lineSpace: 1.45,
              ),
            ),
          ],
          _divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (review.jobRole != null && review.jobRole!.trim().isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.cardColor2,
                    border: Border.all(color: AppColors.cardBorder2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      const Icon(
                        Icons.work_outline,
                        color: AppColors.primaryColor,
                        size: 12,
                      ),
                      Text(
                        review.jobRole!.trim(),
                        style: AppStyles.customTextStyle(
                          size: 11,
                          color: AppColors.primaryColor,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink(),
              Text(
                date,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── PLACEMENT LIST TAB ─────────────────────────────────────────

  Widget _buildPlacementListTabContent() {
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
            if (profileController.interviewList.isEmpty &&
                !profileController.interviewLoading.value) {
              profileController.fetchInterviews();
            }
          } else {
            if (profileController.placementList.isEmpty &&
                !profileController.placementLoading.value) {
              profileController.fetchPlacements();
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
                    profileController.selectedInterviewStatus.value ==
                        item["value"];
                return GestureDetector(
                  onTap: () {
                    profileController.filterInterviewsByStatus(item["value"]!);
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
          if (profileController.interviewLoading.value) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(child: AppAlertUtils.customLoader()),
            );
          }

          if (profileController.interviewList.isEmpty) {
            final currentStatus =
                profileController.selectedInterviewStatus.value;
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
              ...profileController.interviewList.map(
                (item) => _buildInterviewCard(item),
              ),

              // Pagination Load More
              if (profileController.interviewPage.value <
                  profileController.interviewTotalPages.value)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: profileController.interviewLoadingMore.value
                        ? const CupertinoActivityIndicator(
                            color: AppColors.primaryColor,
                          )
                        : GestureDetector(
                            onTap: () => profileController.fetchInterviews(
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
    final date = _formatDate(item.interviewDate);
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
          // Candidate row + Status Badge
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

          // Job & Company
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

          // Round & Mode chips
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

          // Date & Time
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

          // Meeting Link / Location
          if (location.isNotEmpty) ...[
            if (location.startsWith("http"))
              GestureDetector(
                onTap: () => _launchUrl(location),
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

          // Interviewer info
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

          // Instructions
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
                    profileController.selectedPlacementStatus.value ==
                        item["value"];
                return GestureDetector(
                  onTap: () {
                    profileController.filterPlacementsByStatus(item["value"]!);
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
          if (profileController.placementLoading.value) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(child: AppAlertUtils.customLoader()),
            );
          }

          if (profileController.placementList.isEmpty) {
            final currentStatus =
                profileController.selectedPlacementStatus.value;
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
              ...profileController.placementList.map(
                (item) => _buildPlacementCard(item),
              ),

              // Pagination Load More
              if (profileController.placementPage.value <
                  profileController.placementTotalPages.value)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: profileController.placementLoadingMore.value
                        ? const CupertinoActivityIndicator(
                            color: AppColors.primaryColor,
                          )
                        : GestureDetector(
                            onTap: () => profileController.fetchPlacements(
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
    final date = _formatDate(item.interviewDate ?? item.createdAt);
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
          // Candidate row + Status Badge
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

          // Job Role & Company
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

          // Date & Mode
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

          // Offer Letter button
          if (offer.isNotEmpty) ...[
            _divider(),
            GestureDetector(
              onTap: () => _launchUrl(offer),
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
