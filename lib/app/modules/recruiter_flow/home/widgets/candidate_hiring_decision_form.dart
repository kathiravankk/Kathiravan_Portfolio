import 'dart:io';
import 'package:dio/dio.dart' show FormData, MultipartFile;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';

class CandidateHiringDecisionForm extends StatefulWidget {
  final String studentId;
  final String jobId;
  final String? defaultJobTitle;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const CandidateHiringDecisionForm({
    super.key,
    required this.studentId,
    required this.jobId,
    this.defaultJobTitle,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  State<CandidateHiringDecisionForm> createState() =>
      _CandidateHiringDecisionFormState();
}

class _CandidateHiringDecisionFormState
    extends State<CandidateHiringDecisionForm> {
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();

  int _selectedDecisionType = 0; // 0: Select for Interview, 1: Mark as Job Placed

  // Interview Form Controllers
  final TextEditingController _interviewDateController =
      TextEditingController();
  final TextEditingController _interviewTimeController =
      TextEditingController();
  String _selectedInterviewMode = "Online";
  String _selectedInterviewRound = "Technical Round";
  final TextEditingController _interviewRoundCustomController =
      TextEditingController();
  final TextEditingController _meetingLinkController =
      TextEditingController();
  final TextEditingController _interviewerNameController =
      TextEditingController();
  final TextEditingController _contactEmailController =
      TextEditingController();
  final TextEditingController _interviewInstructionsController =
      TextEditingController();
  DateTime? _rawInterviewDate;

  // Placement Form Controllers
  final TextEditingController _placementJobTitleController =
      TextEditingController();
  String _selectedEmploymentType = "Full-time";
  String _selectedWorkMode = "On-site";
  final TextEditingController _joiningDateController =
      TextEditingController();
  final TextEditingController _jobLocationController =
      TextEditingController();
  final TextEditingController _annualSalaryController =
      TextEditingController();
  final TextEditingController _placementNotesController =
      TextEditingController();
  DateTime? _rawJoiningDate;
  File? _selectedOfferLetterFile;
  String? _selectedOfferLetterName;

  @override
  void initState() {
    super.initState();
    if (widget.defaultJobTitle != null && widget.defaultJobTitle!.isNotEmpty) {
      _placementJobTitleController.text = widget.defaultJobTitle!;
    }
  }

  @override
  void dispose() {
    _interviewDateController.dispose();
    _interviewTimeController.dispose();
    _interviewRoundCustomController.dispose();
    _meetingLinkController.dispose();
    _interviewerNameController.dispose();
    _contactEmailController.dispose();
    _interviewInstructionsController.dispose();
    _placementJobTitleController.dispose();
    _joiningDateController.dispose();
    _jobLocationController.dispose();
    _annualSalaryController.dispose();
    _placementNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card Info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Candidate Hiring Decision",
                      style: AppStyles.customTextStyle(
                        size: 16,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Recognize high-performing interns and update their next career step.",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.greyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Radio Selector Cards
          _buildDecisionTypeSelector(),
          const SizedBox(height: 16),

          // Form fields depending on selected type
          if (_selectedDecisionType == 0)
            _buildInterviewForm()
          else
            _buildPlacementForm(),
        ],
      ),
    );
  }

  Widget _buildDecisionTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildDecisionTypeCard(
            index: 0,
            title: "Select for Interview",
            icon: CupertinoIcons.calendar,
            isSelected: _selectedDecisionType == 0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDecisionTypeCard(
            index: 1,
            title: "Mark as Job Placed",
            icon: CupertinoIcons.briefcase,
            isSelected: _selectedDecisionType == 1,
          ),
        ),
      ],
    );
  }

  Widget _buildDecisionTypeCard({
    required int index,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (_selectedDecisionType != index) {
          setState(() {
            _selectedDecisionType = index;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryColor : AppColors.greyTextColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: isSelected ? AppColors.whiteColor : AppColors.greyTextColor,
                  weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.circle,
              color: isSelected ? AppColors.primaryColor : AppColors.greyTextColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // INTERVIEW FORM
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildInterviewForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Interview Date & Interview Time
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Interview Date", isRequired: true),
                  const SizedBox(height: 6),
                  _buildInputField(
                    controller: _interviewDateController,
                    hint: "dd/mm/yyyy",
                    prefixIcon: CupertinoIcons.calendar,
                    readOnly: true,
                    onTap: _pickInterviewDate,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Interview Time", isRequired: true),
                  const SizedBox(height: 6),
                  _buildInputField(
                    controller: _interviewTimeController,
                    hint: "14:00",
                    prefixIcon: CupertinoIcons.time,
                    readOnly: true,
                    onTap: _pickInterviewTime,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Row 2: Interview Mode & Interview Round
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Interview Mode", isRequired: true),
                  const SizedBox(height: 6),
                  _buildDropdownField(
                    value: _selectedInterviewMode,
                    items: const ["Online", "In-Person", "Phone"],
                    prefixIcon: CupertinoIcons.device_laptop,
                    onChanged: (val) {
                      setState(() => _selectedInterviewMode = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Interview Round", isRequired: true),
                  const SizedBox(height: 6),
                  _buildDropdownField(
                    value: _selectedInterviewRound,
                    items: const [
                      "Technical Round",
                      "HR Round",
                      "Managerial Round",
                      "Final Round",
                      "Other",
                    ],
                    prefixIcon: CupertinoIcons.layers,
                    onChanged: (val) {
                      setState(() => _selectedInterviewRound = val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        if (_selectedInterviewRound == "Other") ...[
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormLabel("Specify Round Name", isRequired: true),
              const SizedBox(height: 6),
              _buildInputField(
                controller: _interviewRoundCustomController,
                hint: "e.g. System Design Round",
                prefixIcon: CupertinoIcons.pencil,
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),

        // Meeting Link / Location
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormLabel("Meeting Link / Location", isRequired: true),
            const SizedBox(height: 6),
            _buildInputField(
              controller: _meetingLinkController,
              hint: "https://meet.google.com/... or Office Address",
              prefixIcon: CupertinoIcons.link,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Interviewer Name & Contact Number / Email
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Interviewer Name", isRequired: true),
                  const SizedBox(height: 6),
                  _buildInputField(
                    controller: _interviewerNameController,
                    hint: "e.g. Ravi Kumar",
                    prefixIcon: CupertinoIcons.person,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Contact / Email", isRequired: true),
                  const SizedBox(height: 6),
                  _buildInputField(
                    controller: _contactEmailController,
                    hint: "email or phone",
                    prefixIcon: CupertinoIcons.phone,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Interview Instructions
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormLabel("Interview Instructions"),
            const SizedBox(height: 6),
            _buildInputField(
              controller: _interviewInstructionsController,
              hint: "e.g. Please join 10 minutes early and keep your resume ready.",
              prefixIcon: CupertinoIcons.info_circle,
              maxLines: 3,
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Info Banner
        _buildInfoBanner(),
        const SizedBox(height: 16),

        // Action Buttons
        _buildActionButtons(
          submitLabel: "Submit Interview Details",
          onSubmit: _submitInterviewDecision,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PLACEMENT FORM
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildPlacementForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Job Title
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormLabel("Job Title", isRequired: true),
            const SizedBox(height: 6),
            _buildInputField(
              controller: _placementJobTitleController,
              hint: "e.g. Junior Software Developer",
              prefixIcon: CupertinoIcons.briefcase,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Employment Type & Work Mode
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Employment Type", isRequired: true),
                  const SizedBox(height: 6),
                  _buildDropdownField(
                    value: _selectedEmploymentType,
                    items: const [
                      "Full-time",
                      "Part-time",
                      "Contract",
                      "Internship to Full-time",
                    ],
                    prefixIcon: CupertinoIcons.square_grid_2x2,
                    onChanged: (val) {
                      setState(() => _selectedEmploymentType = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Work Mode", isRequired: true),
                  const SizedBox(height: 6),
                  _buildDropdownField(
                    value: _selectedWorkMode,
                    items: const ["On-site", "Hybrid", "Remote"],
                    prefixIcon: CupertinoIcons.building_2_fill,
                    onChanged: (val) {
                      setState(() => _selectedWorkMode = val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Joining Date & Job Location
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Joining Date", isRequired: true),
                  const SizedBox(height: 6),
                  _buildInputField(
                    controller: _joiningDateController,
                    hint: "dd/mm/yyyy",
                    prefixIcon: CupertinoIcons.calendar,
                    readOnly: true,
                    onTap: _pickJoiningDate,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Job Location", isRequired: true),
                  const SizedBox(height: 6),
                  _buildInputField(
                    controller: _jobLocationController,
                    hint: "e.g. Chennai, Tamil Nadu",
                    prefixIcon: CupertinoIcons.location_solid,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Annual Salary / CTC & Offer Letter
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Annual Salary / CTC", isRequired: true),
                  const SizedBox(height: 6),
                  _buildInputField(
                    controller: _annualSalaryController,
                    hint: "e.g. ₹3,60,000 / 3 LPA",
                    prefixIcon: Icons.currency_rupee_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Offer Letter (PDF)"),
                  const SizedBox(height: 6),
                  _buildOfferLetterPicker(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Placement Notes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormLabel("Placement Notes"),
            const SizedBox(height: 6),
            _buildInputField(
              controller: _placementNotesController,
              hint: "e.g. Congratulations!, Welcome to team!",
              prefixIcon: CupertinoIcons.doc_text,
              maxLines: 3,
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Info Banner
        _buildInfoBanner(),
        const SizedBox(height: 16),

        // Action Buttons
        _buildActionButtons(
          submitLabel: "Submit Placement Details",
          onSubmit: _submitPlacementDecision,
        ),
      ],
    );
  }

  Widget _buildOfferLetterPicker() {
    if (_selectedOfferLetterFile != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.doc_fill,
              color: AppColors.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _selectedOfferLetterName ?? "offer_letter.pdf",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedOfferLetterFile = null;
                  _selectedOfferLetterName = null;
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  color: Color(0xFFEF4444),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _pickOfferLetterPdf,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.fieldBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.cloud_upload,
              color: AppColors.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Upload PDF",
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.cardBorder2,
                  weight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Browse",
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // FORM HELPERS
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildFormLabel(String label, {bool isRequired = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          Text(
            "*",
            style: AppStyles.customTextStyle(
              size: 13,
              color: const Color(0xFFEF4444),
              weight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: AppStyles.customTextStyle(
          size: 13,
          color: AppColors.whiteColor,
          weight: FontWeight.w500,
        ),
        cursorColor: AppColors.primaryColor,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.cardBorder2,
            weight: FontWeight.w400,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.primaryColor, size: 16)
              : null,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
    IconData? prefixIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          dropdownColor: const Color(0xFF1A1A2E),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.greyTextColor,
            size: 18,
          ),
          style: AppStyles.customTextStyle(
            size: 13,
            color: AppColors.whiteColor,
            weight: FontWeight.w500,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    Icon(prefixIcon, color: AppColors.primaryColor, size: 16),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    item,
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primaryColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "The student will be notified by email and in-app notification.",
              style: AppStyles.customTextStyle(
                size: 11,
                color: AppColors.primaryColor,
                weight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({
    required String submitLabel,
    required VoidCallback onSubmit,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: OutlinedButton(
            onPressed: widget.onCancel,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              "Cancel",
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.whiteColor,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Obx(
            () => CustomButtonWidget(
              buttonFunction: onSubmit,
              isLoading: homeController.hiringDecisionLoading,
              buttonText: submitLabel,
              height: 44,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PICKERS & SUBMISSION
  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> _pickInterviewDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _rawInterviewDate ?? now,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A2E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A1A2E),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _rawInterviewDate = picked;
        _interviewDateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _pickInterviewTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A2E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A1A2E),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      setState(() {
        _interviewTimeController.text = "$hour:$minute $period";
      });
    }
  }

  Future<void> _pickJoiningDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _rawJoiningDate ?? now,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A2E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A1A2E),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _rawJoiningDate = picked;
        _joiningDateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _pickOfferLetterPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedOfferLetterFile = File(result.files.single.path!);
          _selectedOfferLetterName = result.files.single.name;
        });
      }
    } catch (e) {
      AppAlertUtils.showToast(message: "Failed to pick file: $e", isError: true);
    }
  }

  Future<void> _submitInterviewDecision() async {
    if (_rawInterviewDate == null) {
      AppAlertUtils.showToast(message: "Please select interview date *", isError: true);
      return;
    }
    if (_interviewTimeController.text.trim().isEmpty) {
      AppAlertUtils.showToast(message: "Please select interview time *", isError: true);
      return;
    }
    final round = _selectedInterviewRound == "Other"
        ? _interviewRoundCustomController.text.trim()
        : _selectedInterviewRound;
    if (round.isEmpty) {
      AppAlertUtils.showToast(message: "Please specify interview round *", isError: true);
      return;
    }
    if (_meetingLinkController.text.trim().isEmpty) {
      AppAlertUtils.showToast(message: "Please enter meeting link or location *", isError: true);
      return;
    }
    if (_interviewerNameController.text.trim().isEmpty) {
      AppAlertUtils.showToast(message: "Please enter interviewer name *", isError: true);
      return;
    }
    if (_contactEmailController.text.trim().isEmpty) {
      AppAlertUtils.showToast(message: "Please enter contact number or email *", isError: true);
      return;
    }

    final String formattedDate =
        "${_rawInterviewDate!.year}-${_rawInterviewDate!.month.toString().padLeft(2, '0')}-${_rawInterviewDate!.day.toString().padLeft(2, '0')}";

    final payload = {
      "studentId": widget.studentId,
      "jobId": widget.jobId,
      "type": "Interview",
      "interviewDate": formattedDate,
      "interviewTime": _interviewTimeController.text.trim(),
      "interviewMode": _selectedInterviewMode,
      "interviewRound": round,
      "meetingLinkOrLocation": _meetingLinkController.text.trim(),
      "interviewerName": _interviewerNameController.text.trim(),
      "contactEmail": _contactEmailController.text.trim(),
      "interviewInstructions": _interviewInstructionsController.text.trim(),
    };

    try {
      final res = await homeController.submitInterviewDecision(data: payload);
      final statusCode = homeController.getResponseCode();
      if (statusCode == 200 || statusCode == 201 || res["success"] == true) {
        AppAlertUtils.showToast(
          message: res["message"]?.toString() ??
              "Interview decision recorded successfully.",
          isError: false,
        );
        widget.onSuccess();
      } else {
        AppAlertUtils.showToast(
          message: res["message"]?.toString() ??
              "Failed to submit interview decision",
          isError: true,
        );
      }
    } catch (e) {
      AppAlertUtils.showToast(
        message: "Something went wrong: $e",
        isError: true,
      );
    }
  }

  Future<void> _submitPlacementDecision() async {
    if (_placementJobTitleController.text.trim().isEmpty) {
      AppAlertUtils.showToast(message: "Please enter job title *", isError: true);
      return;
    }
    if (_rawJoiningDate == null) {
      AppAlertUtils.showToast(message: "Please select joining date *", isError: true);
      return;
    }
    if (_jobLocationController.text.trim().isEmpty) {
      AppAlertUtils.showToast(message: "Please enter job location *", isError: true);
      return;
    }
    if (_annualSalaryController.text.trim().isEmpty) {
      AppAlertUtils.showToast(message: "Please enter annual salary / CTC *", isError: true);
      return;
    }

    final String formattedDate =
        "${_rawJoiningDate!.year}-${_rawJoiningDate!.month.toString().padLeft(2, '0')}-${_rawJoiningDate!.day.toString().padLeft(2, '0')}";

    final Map<String, dynamic> formMap = {
      "studentId": widget.studentId,
      "jobId": widget.jobId,
      "type": "Placement",
      "jobTitle": _placementJobTitleController.text.trim(),
      "employmentType": _selectedEmploymentType,
      "workMode": _selectedWorkMode,
      "joiningDate": formattedDate,
      "jobLocation": _jobLocationController.text.trim(),
      "annualSalary": _annualSalaryController.text.trim(),
      "placementNotes": _placementNotesController.text.trim(),
    };

    if (_selectedOfferLetterFile != null &&
        await _selectedOfferLetterFile!.exists()) {
      formMap["offerLetter"] = await MultipartFile.fromFile(
        _selectedOfferLetterFile!.path,
        filename: _selectedOfferLetterName ?? "offer_letter.pdf",
      );
    }

    final formData = FormData.fromMap(formMap);

    try {
      final res =
          await homeController.submitPlacementDecision(payloadFormData: formData);
      final statusCode = homeController.getResponseCode();
      if (statusCode == 200 || statusCode == 201 || res["success"] == true) {
        AppAlertUtils.showToast(
          message: res["message"]?.toString() ??
              "Placement decision recorded successfully.",
          isError: false,
        );
        widget.onSuccess();
      } else {
        AppAlertUtils.showToast(
          message: res["message"]?.toString() ??
              "Failed to submit placement decision",
          isError: true,
        );
      }
    } catch (e) {
      AppAlertUtils.showToast(
        message: "Something went wrong: $e",
        isError: true,
      );
    }
  }
}

