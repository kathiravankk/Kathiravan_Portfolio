import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/modules/login/view/kyc_verification_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/new_recruiter_company_info_controller.dart';

class CompanyExtractionCard extends StatelessWidget {
  final NewRecruiterCompanyInfoController controller;

  const CompanyExtractionCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
          Text(
            "Company Information",
            style: AppStyles.customTextStyle(
              size: 16,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Upload your company profile and let AI extract the details or fill manually.",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.greyTextColor,
              weight: FontWeight.w400,
              lineSpace: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          /// TABS: Upload File / Paste Link
          Obx(
            () => Container(
              height: 42,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0F1D),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFF1E293B),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectedTab.value = 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.selectedTab.value == 0
                              ? const Color(0xFFFFD56B)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Upload File",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: controller.selectedTab.value == 0
                                ? AppColors.blackColor
                                : AppColors.greyTextColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectedTab.value = 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.selectedTab.value == 1
                              ? const Color(0xFFFFD56B)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Paste Link",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: controller.selectedTab.value == 1
                                ? AppColors.blackColor
                                : AppColors.greyTextColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// TAB CONTENT
          Obx(
            () => controller.selectedTab.value == 0
                ? _buildUploadFileTabContent()
                : _buildPasteLinkTabContent(),
          ),
        ],
      ),
    );
  }

  /// TAB 1: UPLOAD FILE
  Widget _buildUploadFileTabContent() {
    return CustomPaint(
      painter: DashPainter(
        color: AppColors.primaryColor.withValues(alpha: 0.6),
        radius: 14,
        strokeWidth: 1.2,
        gap: 5,
        dash: 7,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF0A0F1D).withValues(alpha: 0.5),
        ),
        child: Column(
          children: [
            /// ICON WITH BADGE
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF132338),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.doc_text,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: AppColors.blackColor,
                      size: 11,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// TITLE
            Text(
              "Upload Company Profile",
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),

            /// RECOMMENDED
            Text(
              "(Recommended)",
              style: AppStyles.customTextStyle(
                size: 11,
                color: AppColors.primaryColor,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            /// DESCRIPTION
            Text(
              "Drag & drop your company profile (PDF, DOC, DOCX, JPG, PNG)",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 10,
                color: AppColors.greyTextColor,
                weight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 16),

            /// CHOSEN FILE BADGE (IF EXTRACTED)
            Obx(() {
              if (controller.extractedFileName.value != null &&
                  controller.extractedFileName.value!.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.correctBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.correctBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.correctText,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            controller.extractedFileName.value!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.customTextStyle(
                              size: 11,
                              color: AppColors.correctText,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            /// UPLOAD BUTTON OR LOADER
            Obx(
              () => controller.isExtracting.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "AI is extracting details...",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: AppColors.primaryColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: controller.pickAndExtractFile,
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.buttonGrad1,
                              AppColors.buttonGrad2,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.arrow_up_to_line,
                              color: AppColors.blackColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Upload File",
                              style: AppStyles.customTextStyle(
                                size: 14,
                                color: AppColors.blackColor,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// TAB 2: PASTE LINK
  Widget _buildPasteLinkTabContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1D).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Paste Company Website or Profile Link",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1527),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF1E293B),
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller.pasteLinkController,
              keyboardType: TextInputType.url,
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.whiteColor,
                weight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "https://www.company.com",
                hintStyle: AppStyles.customTextStyle(
                  size: 12,
                  color: const Color(0xFF64748B),
                  weight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  CupertinoIcons.link,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => controller.isExtracting.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "AI is extracting details...",
                        style: AppStyles.customTextStyle(
                          size: 12,
                          color: AppColors.primaryColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: controller.extractFromLink,
                    child: Container(
                      width: double.infinity,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.buttonGrad1,
                            AppColors.buttonGrad2,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.sparkles,
                            color: AppColors.blackColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Extract Details",
                            style: AppStyles.customTextStyle(
                              size: 13,
                              color: AppColors.blackColor,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

