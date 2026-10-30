import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/new_recruiter_review_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class NewRecruiterReviewScreen extends StatelessWidget {
  const NewRecruiterReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewRecruiterReviewController>();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        backgroundColor: AppColors.transparentColor,
        body: SafeArea(
          child: Column(
            children: [
              /// SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// STEP INDICATOR
                      _buildStepIndicator(),

                      const SizedBox(height: 24),

                      /// HEADER
                      _buildHeader(),

                      const SizedBox(height: 24),

                      /// PERSONAL DETAILS CARD
                      _buildPersonalDetailsCard(controller),

                      const SizedBox(height: 16),

                      /// COMPANY INFORMATION CARD
                      _buildCompanyInfoCard(controller),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              /// BOTTOM CONTINUE BUTTON
              _buildBottomButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  // ─── STEP INDICATOR ─────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step 1 — Completed
        Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emeraldColor,
                  border: Border.all(color: AppColors.emeraldColor, width: 2),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.checkmark,
                  color: AppColors.whiteColor,
                  size: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Personal Info',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.emeraldColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Completed',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 9,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        // Connector 1→2
        Container(
          width: 28,
          height: 1.5,
          color: AppColors.emeraldColor.withValues(alpha: 0.5),
          margin: const EdgeInsets.only(bottom: 24),
        ),

        // Step 2 — Completed
        Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emeraldColor,
                  border: Border.all(color: AppColors.emeraldColor, width: 2),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.checkmark,
                  color: AppColors.whiteColor,
                  size: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Company Info',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.emeraldColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Completed',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 9,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        // Connector 2→3
        Container(
          width: 28,
          height: 1.5,
          color: AppColors.primaryColor.withValues(alpha: 0.6),
          margin: const EdgeInsets.only(bottom: 24),
        ),

        // Step 3 — Active
        Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  '3',
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.blackColor,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Review',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.secondaryColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Verify details',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 9,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        // Connector 3→4
        Container(
          width: 28,
          height: 1.5,
          color: AppColors.greyTextColor.withValues(alpha: 0.3),
          margin: const EdgeInsets.only(bottom: 24),
        ),

        // Step 4 — Upcoming
        Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.fieldBgColor,
                  border: Border.all(
                    color: AppColors.greyTextColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '4',
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.greyTextColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose Plan',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Select your plan',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 9,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── HEADER ─────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review & Submit',
          style: AppStyles.customTextStyle(
            size: 24,
            color: AppColors.whiteColor,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Please review your information before creating your recruiter account.',
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

  // ─── PERSONAL DETAILS CARD ──────────────────────────────────────
  Widget _buildPersonalDetailsCard(NewRecruiterReviewController controller) {
    return _buildSectionCard(
      stepNumber: 1,
      title: 'Personal Details',
      onEdit: () {
        // Navigate back to Step 1, passing combined data so Step 1 keeps context
        Get.offNamed(
          AppRoutes.newRecruiterRegisterScreen,
          arguments: controller.combinedData,
        );
      },
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                icon: CupertinoIcons.person,
                label: 'Full Name',
                value: controller.fullName,
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                icon: CupertinoIcons.mail,
                label: 'Work Email',
                value: controller.email,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                icon: CupertinoIcons.phone,
                label: 'Mobile Number',
                value: '+91 ${controller.mobile}',
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                icon: CupertinoIcons.briefcase,
                label: 'Recruiter Designation',
                value: controller.designation,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── COMPANY INFORMATION CARD ───────────────────────────────────
  Widget _buildCompanyInfoCard(NewRecruiterReviewController controller) {
    final social = controller.socialMedia;

    return _buildSectionCard(
      stepNumber: 2,
      title: 'Company Information',
      onEdit: () {
        // Navigate back to Step 2, passing combined data so fields are pre-filled
        Get.offNamed(
          AppRoutes.newRecruiterCompanyInfoScreen,
          arguments: controller.combinedData,
        );
      },
      children: [
        // Row 1
        _buildTwoColRow(
          left: _buildDetailItem(
            icon: CupertinoIcons.bookmark,
            label: 'Company Name',
            value: controller.companyName,
          ),
          right: _buildDetailItem(
            icon: CupertinoIcons.location,
            label: 'Company Address',
            value: controller.companyAddress,
          ),
        ),
        const SizedBox(height: 14),
        // Row 2
        _buildTwoColRow(
          left: _buildDetailItem(
            icon: CupertinoIcons.mail,
            label: 'Company Email',
            value: controller.companyEmail,
          ),
          right: _buildDetailItem(
            icon: CupertinoIcons.globe,
            label: 'Company Website',
            value: controller.companyWebsite,
          ),
        ),
        const SizedBox(height: 14),
        // Row 3
        _buildTwoColRow(
          left: _buildDetailItem(
            icon: CupertinoIcons.phone,
            label: 'Contact Number',
            value: controller.companyContactNumber,
          ),
          right: _buildDetailItem(
            icon: CupertinoIcons.tag,
            label: 'Pincode',
            value: controller.companyPincode,
          ),
        ),
        if (controller.gstCin.isNotEmpty) ...[
          const SizedBox(height: 14),
          _buildTwoColRow(
            left: _buildDetailItem(
              icon: CupertinoIcons.doc_plaintext,
              label: 'GST or CIN Number',
              value: controller.gstCin,
            ),
            right: _buildDetailItem(
              icon: CupertinoIcons.building_2_fill,
              label: 'Industry Type',
              value: controller.industryType,
            ),
          ),
        ],
        if (controller.gstCin.isEmpty && controller.industryType.isNotEmpty) ...[
          const SizedBox(height: 14),
          _buildDetailItem(
            icon: CupertinoIcons.building_2_fill,
            label: 'Industry Type',
            value: controller.industryType,
          ),
        ],
        if (controller.companyType.isNotEmpty ||
            controller.foundedYear.isNotEmpty) ...[
          const SizedBox(height: 14),
          _buildTwoColRow(
            left: controller.companyType.isNotEmpty
                ? _buildDetailItem(
                    icon: CupertinoIcons.briefcase,
                    label: 'Company Type',
                    value: controller.companyType,
                  )
                : const SizedBox(),
            right: controller.foundedYear.isNotEmpty
                ? _buildDetailItem(
                    icon: CupertinoIcons.calendar,
                    label: 'Founded Year',
                    value: controller.foundedYear,
                  )
                : const SizedBox(),
          ),
        ],
        if (controller.workingModel.isNotEmpty ||
            controller.numberOfEmployees.isNotEmpty) ...[
          const SizedBox(height: 14),
          _buildTwoColRow(
            left: controller.workingModel.isNotEmpty
                ? _buildDetailItem(
                    icon: CupertinoIcons.desktopcomputer,
                    label: 'Working Model',
                    value: controller.workingModel,
                  )
                : const SizedBox(),
            right: controller.numberOfEmployees.isNotEmpty
                ? _buildDetailItem(
                    icon: CupertinoIcons.person_3,
                    label: 'Employee Range',
                    value: controller.numberOfEmployees,
                  )
                : const SizedBox(),
          ),
        ],
        if (controller.companyDescription.isNotEmpty) ...[
          const SizedBox(height: 14),
          _buildDetailItem(
            icon: CupertinoIcons.doc_text,
            label: 'Company Description',
            value: controller.companyDescription,
            isFullWidth: true,
          ),
        ],
        if (controller.companyMission.isNotEmpty) ...[
          const SizedBox(height: 14),
          _buildDetailItem(
            icon: CupertinoIcons.clock,
            label: 'Company Mission',
            value: controller.companyMission,
            isFullWidth: true,
          ),
        ],
        if (controller.companyVision.isNotEmpty) ...[
          const SizedBox(height: 14),
          _buildDetailItem(
            icon: CupertinoIcons.eye,
            label: 'Company Vision',
            value: controller.companyVision,
            isFullWidth: true,
          ),
        ],
        if (controller.coreServices.isNotEmpty) ...[
          const SizedBox(height: 14),
          _buildDetailItem(
            icon: CupertinoIcons.layers,
            label: 'Core Services',
            value: controller.coreServices,
            isFullWidth: true,
          ),
        ],
        if (controller.whyInternWithUs.isNotEmpty) ...[
          const SizedBox(height: 14),
          _buildDetailItem(
            icon: CupertinoIcons.person_badge_plus,
            label: 'Why Intern With Us?',
            value: controller.whyInternWithUs,
            isFullWidth: true,
          ),
        ],
        // Social media (only show non-empty)
        if (_hasSocialMedia(social)) ...[
          const SizedBox(height: 16),
          _buildDivider(),
          const SizedBox(height: 14),
          _buildSocialMediaSection(social),
        ],
      ],
    );
  }

  bool _hasSocialMedia(Map<String, dynamic> social) {
    return (social['linkedin'] ?? '').isNotEmpty ||
        (social['x'] ?? '').isNotEmpty ||
        (social['facebook'] ?? '').isNotEmpty ||
        (social['instagram'] ?? '').isNotEmpty ||
        (social['youtube'] ?? '').isNotEmpty;
  }

  Widget _buildSocialMediaSection(Map<String, dynamic> social) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Social Media Links',
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.greyTextColor,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            if ((social['linkedin'] ?? '').isNotEmpty)
              _buildSocialChip(
                icon: CupertinoIcons.link,
                label: 'LinkedIn',
                value: social['linkedin'],
              ),
            if ((social['x'] ?? '').isNotEmpty)
              _buildSocialChip(
                icon: CupertinoIcons.at,
                label: 'X (Twitter)',
                value: social['x'],
              ),
            if ((social['facebook'] ?? '').isNotEmpty)
              _buildSocialChip(
                icon: CupertinoIcons.person_2,
                label: 'Facebook',
                value: social['facebook'],
              ),
            if ((social['instagram'] ?? '').isNotEmpty)
              _buildSocialChip(
                icon: CupertinoIcons.camera,
                label: 'Instagram',
                value: social['instagram'],
              ),
            if ((social['youtube'] ?? '').isNotEmpty)
              _buildSocialChip(
                icon: CupertinoIcons.play_circle,
                label: 'YouTube',
                value: social['youtube'],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialChip({
    required IconData icon,
    required String label,
    required String? value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 12),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppStyles.customTextStyle(
              size: 11,
              color: AppColors.primaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── SECTION CARD ───────────────────────────────────────────────
  Widget _buildSectionCard({
    required int stepNumber,
    required String title,
    required VoidCallback onEdit,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1726),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header with step badge + title + edit button
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$stepNumber',
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: AppColors.blackColor,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.customTextStyle(
                    size: 15,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        CupertinoIcons.pencil,
                        color: AppColors.primaryColor,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Edit',
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

          const SizedBox(height: 14),
          _buildDivider(),
          const SizedBox(height: 14),

          ...children,
        ],
      ),
    );
  }

  // ─── DETAIL ITEM ────────────────────────────────────────────────
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isFullWidth = false,
  }) {
    if (value.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.greyTextColor,
              size: 12,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 17),
          child: Text(
            value,
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.whiteColor,
              weight: FontWeight.w500,
              lineSpace: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTwoColRow({required Widget left, required Widget right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFF1E293B),
    );
  }

  // ─── BOTTOM BUTTON ──────────────────────────────────────────────
  Widget _buildBottomButton(NewRecruiterReviewController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF070B14).withValues(alpha: 0.9),
        border: const Border(
          top: BorderSide(
            color: Color(0xFF1E293B),
            width: 0.5,
          ),
        ),
      ),
      child: Obx(
        () => CustomButtonWidget(
          buttonText: controller.isLoading.value
              ? 'Registering...'
              : 'Continue to Choose Plan',
          buttonFunction: controller.isLoading.value
              ? () {} // no-op while loading
              : () => controller.registerRecruiter(),
        ),
      ),
    );
  }
}
