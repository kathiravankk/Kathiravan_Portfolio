import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/counter_text_field.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';

class RecruiterEditProfileScreen extends StatefulWidget {
  const RecruiterEditProfileScreen({super.key});

  @override
  State<RecruiterEditProfileScreen> createState() =>
      _RecruiterEditProfileScreenState();
}

class _RecruiterEditProfileScreenState
    extends State<RecruiterEditProfileScreen> {
  final RecruiterHomeController profileController =
  Get.find<RecruiterHomeController>();

  // ── Controllers ───────────────────────────────────────────────
  final TextEditingController recruiterNameController =
  TextEditingController();
  final TextEditingController primaryNumberController =
  TextEditingController();
  final TextEditingController secondaryNumberController =
  TextEditingController();
  final TextEditingController recruiterEmailController =
  TextEditingController();
  final TextEditingController designationController =
  TextEditingController();
  final TextEditingController companyNameController =
  TextEditingController();
  final TextEditingController companyAddressController =
  TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  // ── State ─────────────────────────────────────────────────────
  int employeeCount = 0;

  // Logo
  File? _newLogoFile;
  MultipartFile? _logoMultipartFile;
  String _existingLogoUrl = "";
  static const int _maxLogoBytes = 2 * 1024 * 1024; // 2 MB

  // Certificate
  File? _newCertificateFile;
  String? _certificateFileName;
  double? _certificateSizeMB;
  String _existingCertificateUrl = "";
  static const int _maxCertBytes = 10 * 1024 * 1024; // 10 MB

  String? _recruiterId;

  @override
  void initState() {
    super.initState();
    _prefillFromProfile();
  }

  @override
  void dispose() {
    recruiterNameController.dispose();
    primaryNumberController.dispose();
    secondaryNumberController.dispose();
    recruiterEmailController.dispose();
    designationController.dispose();
    companyNameController.dispose();
    companyAddressController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  // ── Pre-fill ──────────────────────────────────────────────────
  void _prefillFromProfile() {
    final profile = profileController.recruiterProfile.value;
    if (profile == null) return;

    recruiterNameController.text = profile.recName ?? "";
    primaryNumberController.text = profile.recMobileNo ?? "";
    secondaryNumberController.text = profile.recSecondaryMobileNo ?? "";
    recruiterEmailController.text = profile.recEmail ?? "";
    designationController.text = profile.recDesignation ?? "";
    companyNameController.text = profile.recCompanyName ?? "";
    companyAddressController.text = profile.recCompanyAddress ?? "";
    pincodeController.text = profile.recCompanyPinCode ?? "";
    employeeCount = int.tryParse(profile.recCompanySize ?? "0") ?? 0;
    _existingLogoUrl = profile.recCompanyLogo ?? "";
    _existingCertificateUrl =
        profile.recCompanyDocument?.toString() ?? "";
  }

  // ── Logo Picker ───────────────────────────────────────────────
  void _showLogoSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: AppColors.greyIcon, size: 20),
              title: Text(
                'Choose from Gallery',
                style: AppStyles.customTextStyle(
                  fontFamily: 'Roboto',
                  color: AppColors.blackColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                _pickLogo(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera,
                  color: AppColors.greyIcon, size: 20),
              title: Text(
                'Take a Photo',
                style: AppStyles.customTextStyle(
                  fontFamily: 'Roboto',
                  color: AppColors.blackColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                _pickLogo(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLogo(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
      );
      if (picked == null) return;

      final file = File(picked.path);
      if (await file.length() > _maxLogoBytes) {
        AppAlertUtils.showToast(
          message: 'Logo too large (max 2 MB)',
          isError: true,
        );
        return;
      }

      _logoMultipartFile = await MultipartFile.fromFile(
        file.path,
        filename:
        'company_logo_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType('image', 'jpeg'),
      );

      setState(() => _newLogoFile = file);
    } catch (e) {
      AppAlertUtils.showToast(
        message: 'Could not open camera/gallery: $e',
        isError: true,
      );
    }
  }

  // ── Certificate Picker ────────────────────────────────────────
  Future<void> _pickCertificateFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.single;
      if (pickedFile.size > _maxCertBytes) {
        AppAlertUtils.showToast(
          message: 'File too large (max 10 MB)',
          isError: true,
        );
        return;
      }
      if (pickedFile.path == null) {
        AppAlertUtils.showToast(
          message: 'Could not read the selected file',
          isError: true,
        );
        return;
      }

      setState(() {
        _newCertificateFile = File(pickedFile.path!);
        _certificateFileName = pickedFile.name;
        _certificateSizeMB = pickedFile.size / (1024 * 1024);
      });
    } catch (e) {
      AppAlertUtils.showToast(
        message: 'Could not pick file: $e',
        isError: true,
      );
    }
  }

  void _removeCertificateFile() => setState(() {
    _newCertificateFile = null;
    _certificateFileName = null;
    _certificateSizeMB = null;
  });

  // ── Build ─────────────────────────────────────────────────────
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Section header
                Text(
                  "Edit Profile",
                  style: AppStyles.customTextStyle(
                    size: 28,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Update your professional details below.",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.greyTextColor,
                    weight: FontWeight.w400,
                    lineSpace: 1.4,
                  ),
                ),

                // ── Row 1: Company Name | Recruiter Name
                _buildRowPair(
                  left: _fieldBlock(
                    label: "Company Name",
                    icon: CupertinoIcons.building_2_fill,
                    child: CustomTextField(
                      controller: companyNameController,
                      labelText: "Company Name",
                      hintText: "e.g. Internsharks Pvt Ltd",
                      isNumberKeyboard: false,
                      prefixWidget: const Icon(
                        CupertinoIcons.building_2_fill,
                        color: AppColors.primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                  right: _fieldBlock(
                    label: "Recruiter Name",
                    icon: CupertinoIcons.person,
                    child: CustomTextField(
                      controller: recruiterNameController,
                      labelText: "Recruiter Name",
                      hintText: "e.g. Sumesh",
                      isNumberKeyboard: false,
                      prefixWidget: const Icon(
                        CupertinoIcons.person,
                        color: AppColors.primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),

                // ── Row 2: Primary Number | Secondary Number
                _buildRowPair(
                  left: CustomTextField(
                    controller: primaryNumberController,
                    labelText: "Primary Number",
                    hintText: "+91 9876543210",
                    isNumberKeyboard: true,
                    prefixWidget: const Icon(
                      CupertinoIcons.phone,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                  ),
                  right: CustomTextField(
                    controller: secondaryNumberController,
                    labelText: "Secondary Number",
                    hintText: "Optional",
                    isNumberKeyboard: true,
                    prefixWidget: const Icon(
                      CupertinoIcons.phone,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                  ),
                ),

                // ── Row 3: Email | Designation
                _buildRowPair(
                  left: CustomTextField(
                    controller: recruiterEmailController,
                    labelText: "Recruiter Email",
                    hintText: "hr@company.com",
                    isNumberKeyboard: false,
                    prefixWidget: const Icon(
                      CupertinoIcons.mail,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                  ),
                  right: CustomTextField(
                    controller: designationController,
                    labelText: "Designation",
                    hintText: "HR Manager",
                    isNumberKeyboard: false,
                    prefixWidget: const Icon(
                      CupertinoIcons.briefcase,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                  ),
                ),

                // ── Row 4: Company Address | Pincode
                _buildRowPair(
                  left: CustomTextField(
                    controller: companyAddressController,
                    labelText: "Company Address",
                    hintText: "Enter your address",
                    isNumberKeyboard: false,
                    prefixWidget: const Icon(
                      CupertinoIcons.location,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                  ),
                  right: CustomTextField(
                    controller: pincodeController,
                    labelText: "Pincode",
                    hintText: "600001",
                    isNumberKeyboard: true,
                    prefixWidget: const Icon(
                      CupertinoIcons.location_solid,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                  ),
                ),

                // ── Employees Count (full width)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    _sectionLabel(
                      icon: Icons.people_alt_rounded,
                      label: "Employees Count",
                    ),
                    CounterTextField(
                      value: employeeCount,
                      onChanged: (v) => setState(() => employeeCount = v),
                      min: 1,
                      max: 100000,
                      hintText: "Enter company size",
                    ),
                  ],
                ),

                // ── Company Logo
                _buildLogoSection(),

                // ── Incorporation Certificate / CIN
                _buildCertificateSection(),

                const SizedBox(height: 5),

                // ── Buttons
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColors.greyTextColor, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding:
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          "Cancel",
                          style: AppStyles.customTextStyle(
                            size: 15,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Obx(
                            () => CustomButtonWidget(
                          buttonText: "Save Changes",
                          isLoading:
                          profileController.updateProfileLoading,
                          buttonFunction: () async {
                            await _validateAndSave();
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── App Bar ───────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.transparentColor,
      leading: InkWell(
        onTap: () => Get.back(),
        child:
        const Icon(CupertinoIcons.back, color: AppColors.whiteColor),
      ),
      title: Text(
        "Edit Profile",
        style: AppStyles.customTextStyle(
          size: 16,
          color: AppColors.whiteColor,
          weight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── Logo Section ──────────────────────────────────────────────
  Widget _buildLogoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        _sectionLabel(icon: Icons.business_rounded, label: "Company Logo"),

        GestureDetector(
          onTap: _showLogoSourceSheet,
          child: Row(
            spacing: 16,
            children: [
              // Preview
              _logoPreview(),

              // Info + change button
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      "PNG or JPG up to 2MB.\nRecommended 400×400px",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.greyTextColor,
                        weight: FontWeight.w400,
                        lineSpace: 1.5,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _showLogoSourceSheet,
                      icon: const Icon(Icons.upload_rounded,
                          size: 16, color: AppColors.primaryColor),
                      label: Text(
                        "Change Logo",
                        style: AppStyles.customTextStyle(
                          size: 13,
                          color: AppColors.primaryColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColors.primaryColor, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _logoPreview() {
    Widget child;

    if (_newLogoFile != null) {
      // Newly picked local file
      child = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _newLogoFile!,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        ),
      );
    } else if (_existingLogoUrl.isNotEmpty) {
      // Existing network image
      child = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          _existingLogoUrl,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _logoPlaceholder(),
        ),
      );
    } else {
      child = _logoPlaceholder();
    }

    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, size: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _logoPlaceholder() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3)),
      ),
      child: const Icon(Icons.business_rounded,
          color: AppColors.primaryColor, size: 36),
    );
  }

  // ── Certificate Section ───────────────────────────────────────
  Widget _buildCertificateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        // Header
        Row(
          spacing: 6,
          children: [
            _sectionLabel(
              icon: CupertinoIcons.doc_text_fill,
              label: "Incorporation Certificate / CIN Number",
            ),
            const Icon(Icons.verified,
                color: AppColors.primaryColor, size: 16),
          ],
        ),

        // Upload box
        InkWell(
          onTap: _newCertificateFile == null
              ? _pickCertificateFile
              : null,
          borderRadius: BorderRadius.circular(16),
          child: CustomPaint(
            painter: DashPainter(
              color: AppColors.contBorderColor,
              radius: 16,
              dash: 8,
              gap: 5,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 24, horizontal: 16),
              child: _newCertificateFile == null
                  ? Column(
                spacing: 8,
                children: [
                  const Icon(CupertinoIcons.doc_text,
                      color: AppColors.greyTextColor, size: 32),
                  Text(
                    "Click to upload",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "PDF, DOC up to 10MB",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.greyTextColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              )
                  : Row(
                spacing: 10,
                children: [
                  const Icon(CupertinoIcons.doc_fill,
                      color: AppColors.primaryColor, size: 26),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          _certificateFileName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.customTextStyle(
                            size: 13,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${_certificateSizeMB?.toStringAsFixed(2)} MB",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: AppColors.greyTextColor,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: _removeCertificateFile,
                    child: const Icon(
                      CupertinoIcons.clear_circled_solid,
                      color: AppColors.greyTextColor,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Show existing document name if no new file chosen
        if (_newCertificateFile == null &&
            _existingCertificateUrl.isNotEmpty)
          Row(
            spacing: 6,
            children: [
              const Icon(CupertinoIcons.doc_fill,
                  color: AppColors.primaryColor, size: 14),
              Expanded(
                child: Text(
                  "Current: ${_extractFileName(_existingCertificateUrl)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.greyTextColor,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────

  /// Two-column row that stacks on narrow viewports
  Widget _buildRowPair({required Widget left, required Widget right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Expanded(child: left),
        Expanded(child: right),
      ],
    );
  }

  Widget _fieldBlock({
    required String label,
    required IconData icon,
    required Widget child,
  }) =>
      child; // CustomTextField already includes its own label; pass-through

  Widget _sectionLabel({required IconData icon, required String label}) {
    return Row(
      spacing: 6,
      children: [
        Icon(icon, color: AppColors.secondaryColor, size: 16),
        Flexible(
          child: Text(
            label,
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _extractFileName(String url) {
    try {
      final parts = url.split('?').first.split('/');
      return parts.last;
    } catch (_) {
      return url;
    }
  }

  // ── Validation + Save ─────────────────────────────────────────
  Future<void> _validateAndSave() async {
    // Recruiter name
    final nameError =
    AppFunctions.validateName(recruiterNameController.text);
    if (nameError != null) {
      AppAlertUtils.showToast(message: nameError, isError: true);
      return;
    }

    // Company name
    if (companyNameController.text.trim().isEmpty) {
      AppAlertUtils.showToast(
          message: "Company name is required", isError: true);
      return;
    }

    // Primary mobile
    final mobileError = AppFunctions.validateIndianMobile(
        primaryNumberController.text);
    if (mobileError != null) {
      AppAlertUtils.showToast(message: mobileError, isError: true);
      return;
    }

    // Secondary mobile (optional)
    if (secondaryNumberController.text.trim().isNotEmpty) {
      final altError = AppFunctions.validateIndianMobile(
          secondaryNumberController.text);
      if (altError != null) {
        AppAlertUtils.showToast(
            message: "Secondary: $altError", isError: true);
        return;
      }
    }

    // Email
    final emailError = AppFunctions.validateEmail(
      newEmail: recruiterEmailController.text,
      currentEmail: null,
    );
    if (emailError != null) {
      AppAlertUtils.showToast(message: emailError, isError: true);
      return;
    }

    // Designation
    if (designationController.text.trim().isEmpty) {
      AppAlertUtils.showToast(
          message: "Designation is required", isError: true);
      return;
    }

    // Address
    if (companyAddressController.text.trim().isEmpty) {
      AppAlertUtils.showToast(
          message: "Company address is required", isError: true);
      return;
    }

    // Pincode
    final pincode = pincodeController.text.trim();
    if (pincode.isEmpty ||
        pincode.length != 6 ||
        int.tryParse(pincode) == null) {
      AppAlertUtils.showToast(
          message: "Enter a valid 6-digit pincode", isError: true);
      return;
    }

    // Employee count
    if (employeeCount <= 0) {
      AppAlertUtils.showToast(
          message: "Please enter employee count", isError: true);
      return;
    }

    await _updateProfile();
  }

  Future<void> _updateProfile() async {
    _recruiterId = await LocalStorageService.getRecruiterId();

    // Build multipart payload — only include logo/cert if newly selected
    final Map<String, dynamic> payload = {
      "recname": recruiterNameController.text.trim(),
      "recmobileno": primaryNumberController.text.trim(),
      "recsecondarymobileno": secondaryNumberController.text.trim(),
      "recemail": recruiterEmailController.text.trim(),
      "recdesignation": designationController.text.trim(),
      "reccompanyname": companyNameController.text.trim(),
      "reccompanyaddress": companyAddressController.text.trim(),
      "reccompanypincode": pincode,
      "reccompanysize": employeeCount.toString(),
      if (_logoMultipartFile != null)
        "reccompanylogo": _logoMultipartFile,
      if (_newCertificateFile != null)
        "reccompanydocumenttype": await MultipartFile.fromFile(
          _newCertificateFile!.path,
          filename: _certificateFileName ??
              'cert_${DateTime.now().millisecondsSinceEpoch}.pdf',
        ),
    };

    try {
      await profileController.updateRecruiterProfile(
        recruiterId: _recruiterId ?? "",
        payload: payload,
      );
      if (profileController.getResponseCode() == 200 ||
          profileController.getResponseCode() == 201) {
        AppAlertUtils.showToast(
          message: "Profile updated successfully!",
          isError: false,
        );
        Get.back();
      } else {
        AppFunctions.apiErrorHandling(
          profileController.getResponseCode(),
          "Update failed. Please try again.",
        );
      }
    } catch (e) {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        "Something went wrong. Please try again.",
      );
    }
  }

  // Quick getter to avoid repeating the field read
  String get pincode => pincodeController.text.trim();
}