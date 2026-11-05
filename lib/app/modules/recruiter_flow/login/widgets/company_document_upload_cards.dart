import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/new_recruiter_company_info_controller.dart';

class CompanyDocumentUploadCards extends StatelessWidget {
  final NewRecruiterCompanyInfoController controller;

  const CompanyDocumentUploadCards({super.key, required this.controller});

  void _showLogoPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F1726),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primaryColor,
                size: 22,
              ),
              title: Text(
                'Choose from Gallery',
                style: AppStyles.customTextStyle(
                  color: AppColors.whiteColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                controller.pickCompanyLogo(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_camera,
                color: AppColors.primaryColor,
                size: 22,
              ),
              title: Text(
                'Take a Photo',
                style: AppStyles.customTextStyle(
                  color: AppColors.whiteColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                controller.pickCompanyLogo(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 1. COMPANY LOGO *
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadCardHeader(
                label: "Company Logo",
                isRequired: true,
                subtitle: "JPG, PNG (Max 2MB)",
              ),
              const SizedBox(height: 8),
              Obx(
                () => _buildUploadBox(
                  hasFile: controller.companyLogo.value != null,
                  fileName: controller.companyLogo.value != null
                      ? "Logo Selected"
                      : "No file chosen",
                  previewFile: controller.companyLogo.value,
                  onTap: () => _showLogoPickerSheet(context),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        /// 2. REGISTRATION DOCUMENT *
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadCardHeader(
                label: "Company Registration Document",
                isRequired: true,
                subtitle: "PDF, DOC, DOCX (Max 5MB)",
              ),
              const SizedBox(height: 8),
              Obx(
                () => _buildUploadBox(
                  hasFile: controller.registrationDocFile.value != null,
                  fileName: controller.registrationDocName.value ??
                      "No file chosen",
                  onTap: controller.pickRegistrationDoc,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        /// 3. OTHER SUPPORTING DOCUMENT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadCardHeader(
                label: "Other Supporting Document (Optional)",
                isRequired: false,
                subtitle: "PDF, DOC, DOCX (Max 5MB)",
              ),
              const SizedBox(height: 8),
              Obx(
                () => _buildUploadBox(
                  hasFile: controller.supportingDocFile.value != null,
                  fileName: controller.supportingDocName.value ??
                      "No file chosen",
                  onTap: controller.pickSupportingDoc,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCardHeader({
    required String label,
    required bool isRequired,
    required String subtitle,
  }) {
    return SizedBox(
      height: 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customTextStyle(
                    size: 11,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                    lineSpace: 1.1,
                  ),
                ),
              ),
              if (isRequired)
                Text(
                  " *",
                  style: AppStyles.customTextStyle(
                    size: 11,
                    color: AppColors.redColor,
                    weight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: 9,
              color: const Color(0xFF64748B),
              weight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox({
    required bool hasFile,
    required String fileName,
    required VoidCallback onTap,
    dynamic previewFile,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 72,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1527),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasFile
                    ? AppColors.primaryColor
                    : const Color(0xFF1E293B),
                width: 1,
              ),
            ),
            child: previewFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(
                      previewFile,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.cloud_upload,
                        color: AppColors.primaryColor,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Choose File",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppStyles.customTextStyle(
            size: 9,
            color: hasFile ? AppColors.correctText : const Color(0xFF64748B),
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

