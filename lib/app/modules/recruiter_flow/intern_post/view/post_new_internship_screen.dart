import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
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

class PostNewInternshipScreen extends StatefulWidget {
  const PostNewInternshipScreen({super.key});

  @override
  State<PostNewInternshipScreen> createState() =>
      _PostNewInternshipScreenState();
}

enum StipendType { free, paid, fees }

class _PostNewInternshipScreenState extends State<PostNewInternshipScreen> {
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();

  // ============================================================
  // STEP CONTROL
  // ============================================================
  int currentStep = 0;
  final int totalSteps = 5;
  final List<String> stepTitles = const [
    "Company Information",
    "Internship Details",
    "Location & Duration",
    "Requirements",
    "Stipend / Fees",
  ];

  final ScrollController _scrollController = ScrollController();

  // ============================================================
  // SECTION 1 — COMPANY INFORMATION
  // ============================================================
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyWebsiteController =
      TextEditingController();
  final TextEditingController aboutCompanyController = TextEditingController();
  String _existingLogoUrl = "";

  // ============================================================
  // SECTION 2 — INTERNSHIP DETAILS
  // ============================================================
  final TextEditingController titleController = TextEditingController();
  final TextEditingController roleTypeController = TextEditingController();
  final TextEditingController qualificationController =
      TextEditingController(); // e.g. "3+ years of experience"
  final TextEditingController descriptionController = TextEditingController();

  // Dynamic "Add Project" list
  final List<TextEditingController> projectControllers = [
    TextEditingController(),
  ];

  // ============================================================
  // SECTION 3 — LOCATION & DURATION
  // ============================================================
  String? selectedState;
  String? selectedDistrict;
  String? selectedInternshipMode;
  final TextEditingController locationLinkController = TextEditingController();

  String durationType = "Months"; // "Months" | "Days"
  String? selectedDuration; // dropdown value (months/days count)
  int numberOfPositions = 1;

  final List<String> stateList = const [
    "Tamil Nadu",
    "Andhra Pradesh",
    "Karnataka",
    "Kerala",
    "Telangana",
    "Maharashtra",
  ];

  final Map<String, List<String>> districtMap = const {
    "Tamil Nadu": ["Chennai", "Coimbatore", "Madurai", "Trichy"],
    "Andhra Pradesh": ["Prakasam", "Guntur", "Vijayawada"],
    "Karnataka": ["Bengaluru", "Mysuru"],
    "Kerala": ["Kochi", "Trivandrum"],
    "Telangana": ["Hyderabad", "Warangal"],
    "Maharashtra": ["Mumbai", "Pune"],
  };

  final List<String> internshipModeList = const [
    "Work From Home",
    "Work From Office",
    "Hybrid",
  ];

  List<String> get durationOptions => durationType == "Months"
      ? List.generate(12, (i) => "${i + 1}")
      : List.generate(30, (i) => "${i + 1}");

  // ============================================================
  // SECTION 4 — REQUIREMENTS
  // ============================================================
  final List<String> qualificationOptions = const [
    "BE",
    "BTech",
    "BSc",
    "BCom",
    "BCA",
    "MCA",
    "MBA",
    "MTech",
    "Diploma",
  ];
  final List<String> selectedQualifications = [];

  final TextEditingController fieldOfStudyController = TextEditingController();
  final TextEditingController eligibilityCriteriaController =
      TextEditingController();

  final TextEditingController skillInputController = TextEditingController();
  final List<String> requiredSkills = [];

  // ============================================================
  // SECTION 5 — STIPEND / FEES
  // ============================================================
  StipendType stipendType = StipendType.free;
  final TextEditingController stipendAmountController = TextEditingController();

  bool postLoading = false;

  @override
  void dispose() {
    companyNameController.dispose();
    companyWebsiteController.dispose();
    aboutCompanyController.dispose();
    titleController.dispose();
    roleTypeController.dispose();
    qualificationController.dispose();
    descriptionController.dispose();
    for (final c in projectControllers) {
      c.dispose();
    }
    locationLinkController.dispose();
    fieldOfStudyController.dispose();
    eligibilityCriteriaController.dispose();
    skillInputController.dispose();
    stipendAmountController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
    _prefillCompanyInfo();
  }

  String? recruiterId = "";

  Future<void> getProfileData() async {
    recruiterId = await LocalStorageService.getRecruiterId();
    try {
      await homeController.getRecruiterProfileData(recruiterId: recruiterId!);
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        _prefillCompanyInfo();
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
      rethrow;
    }
  }

  void _prefillCompanyInfo() {
    companyNameController.text =
        homeController.profileModel.recCompanyName ?? "";
    companyWebsiteController.text =
        homeController.profileModel.recCompanyWebsite ?? "";
    aboutCompanyController.text =
        homeController.profileModel.recCompanyDescription ?? "";
    _existingLogoUrl = homeController.profileModel.recCompanyLogo ?? "";
  }

  // ============================================================
  // BUILD
  // ============================================================
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.transparentColor,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          //   onPressed: () {
          //     if (currentStep == 0) {
          //       Get.back();
          //     } else {
          //       _goToStep(currentStep - 1);
          //     }
          //   },
          // ),
          title: Text(
            "Post an Internship",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => homeController.profileLoading
              ? AppAlertUtils.customLoader()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      children: [
                        Text(
                          "Create Hiring Post",
                          style: AppStyles.customTextStyle(
                            size: 24,
                            color: AppColors.secondaryColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Create your hiring post to start finding and hiring the right talent",
                          style: AppStyles.customTextStyle(
                            size: 16,
                            color: AppColors.lightText,
                            weight: FontWeight.w400,
                          ),
                        ),
                        _buildStepIndicator(),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 20,
                              children: [
                                _sectionHeading(),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: _buildCurrentStepContent(),
                                ),
                                const SizedBox(height: 5),
                                CustomButtonWidget(
                                  isLoading: postLoading,
                                  buttonText: currentStep == totalSteps - 1
                                      ? "Post Internship"
                                      : "Next",
                                  buttonFunction: () async {
                                    await _handleNext();
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // ============================================================
  // STEP INDICATOR (linear, same language as the OTP progress bar)
  // ============================================================
  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(totalSteps, (index) {
        final bool isActive = index <= currentStep;
        return Expanded(
          child: GestureDetector(
            onTap: index < currentStep ? () => _goToStep(index) : null,
            child: Container(
              margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 6),
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.whiteColor
                    : AppColors.whiteColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _sectionHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          "Step ${currentStep + 1} of $totalSteps",
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.primaryColor,
            weight: FontWeight.w600,
          ),
        ),
        Text(
          stepTitles[currentStep],
          style: AppStyles.customTextStyle(
            size: 24,
            color: AppColors.secondaryColor,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStepContent() {
    switch (currentStep) {
      case 0:
        return _buildCompanyInfoStep();
      case 1:
        return _buildInternshipDetailsStep();
      case 2:
        return _buildLocationDurationStep();
      case 3:
        return _buildRequirementsStep();
      case 4:
      default:
        return _buildStipendStep();
    }
  }

  // ============================================================
  // STEP NAVIGATION + VALIDATION
  // ============================================================
  void _goToStep(int step) {
    setState(() => currentStep = step);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _handleNext() async {
    if (!_validateCurrentStep()) return;

    if (currentStep < totalSteps - 1) {
      _goToStep(currentStep + 1);
    } else {
      await _postInternship();
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep) {
      case 0:
        if (companyNameController.text.trim().isEmpty) {
          AppAlertUtils.showToast(
            message: "Company name is required",
            isError: true,
          );
          return false;
        }
        if (companyWebsiteController.text.trim().isEmpty) {
          AppAlertUtils.showToast(
            message: "Company website is required",
            isError: true,
          );
          return false;
        }
        if (aboutCompanyController.text.trim().isEmpty) {
          AppAlertUtils.showToast(
            message: "Please add a short company description",
            isError: true,
          );
          return false;
        }
        return true;

      case 1:
        if (roleTypeController.text.trim().isEmpty) {
          AppAlertUtils.showToast(
            message: "Internship role is required",
            isError: true,
          );
          return false;
        }
        if (titleController.text.trim().isEmpty) {
          AppAlertUtils.showToast(
            message: "Internship title is required",
            isError: true,
          );
          return false;
        }
        if (descriptionController.text.trim().isEmpty) {
          AppAlertUtils.showToast(
            message: "Internship responsibilities are required",
            isError: true,
          );
          return false;
        }
        return true;

      case 2:
        if (selectedState == null) {
          AppAlertUtils.showToast(
            message: "Please select a state",
            isError: true,
          );
          return false;
        }
        if (selectedDistrict == null) {
          AppAlertUtils.showToast(
            message: "Please select a district",
            isError: true,
          );
          return false;
        }
        if (selectedInternshipMode == null) {
          AppAlertUtils.showToast(
            message: "Please select an internship mode",
            isError: true,
          );
          return false;
        }
        if (selectedDuration == null) {
          AppAlertUtils.showToast(
            message: "Please select internship duration",
            isError: true,
          );
          return false;
        }
        if (numberOfPositions <= 0) {
          AppAlertUtils.showToast(
            message: "Please enter number of positions",
            isError: true,
          );
          return false;
        }
        return true;

      case 3:
        if (selectedQualifications.isEmpty) {
          AppAlertUtils.showToast(
            message: "Please select at least one qualification",
            isError: true,
          );
          return false;
        }
        return true;

      case 4:
        if (stipendType == StipendType.paid &&
            stipendAmountController.text.trim().isEmpty) {
          AppAlertUtils.showToast(
            message: "Please enter the stipend amount",
            isError: true,
          );
          return false;
        }
        if (stipendType == StipendType.fees &&
            stipendAmountController.text.trim().isEmpty) {
          AppAlertUtils.showToast(
            message: "Please enter the internship fee",
            isError: true,
          );
          return false;
        }
        return true;
    }
    return true;
  }

  // ============================================================
  // STEP 1 — COMPANY INFORMATION
  // ============================================================
  Widget _buildCompanyInfoStep() {
    return Column(
      key: const ValueKey("step0"),
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: [
        CustomTextField(
          controller: companyNameController,
          labelText: "Company Name",
          hintText: "e.g. Internsharks Pvt Ltd",
          isNumberKeyboard: false,
          prefixWidget: const Icon(
            CupertinoIcons.building_2_fill,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        CustomTextField(
          controller: companyWebsiteController,
          labelText: "Company Website",
          hintText: "https://www.internsharks.com",
          isNumberKeyboard: false,
          prefixWidget: const Icon(
            CupertinoIcons.globe,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        CustomTextField(
          controller: aboutCompanyController,
          labelText: "About Company",
          hintText: "Briefly describe your company...",
          isNumberKeyboard: false,
          maxLines: 5,
        ),
        _buildLogoLoadedNotice(),
      ],
    );
  }

  Widget _buildLogoLoadedNotice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Company Logo",
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.fieldBgColor,
            border: Border.all(
              color: AppColors.contBorderColor,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            spacing: 12,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _existingLogoUrl.isNotEmpty
                    ? Image.network(
                        _existingLogoUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _logoFallback(),
                      )
                    : _logoFallback(),
              ),
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
                size: 20,
              ),
              Expanded(
                child: Text(
                  "Logo loaded from your profile",
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: AppColors.greyTextColor,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _logoFallback() {
    return Container(
      width: 50,
      height: 50,
      color: AppColors.primaryColor.withValues(alpha: 0.1),
      child: const Icon(
        Icons.business_rounded,
        color: AppColors.primaryColor,
        size: 24,
      ),
    );
  }

  // ============================================================
  // STEP 2 — INTERNSHIP DETAILS
  // ============================================================
  Widget _buildInternshipDetailsStep() {
    return Column(
      key: const ValueKey("step1"),
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: [
        CustomTextField(
          controller: roleTypeController,
          labelText: "Internship Role",
          hintText: "Developer, Tech/DevOps",
          isNumberKeyboard: false,
          prefixWidget: const Icon(
            CupertinoIcons.briefcase,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        CustomTextField(
          controller: titleController,
          labelText: "Internship Title",
          hintText: "e.g. Flutter Developer Intern",
          isNumberKeyboard: false,
          prefixWidget: const Icon(
            CupertinoIcons.tag,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        CustomTextField(
          controller: qualificationController,
          labelText: "Experience / Qualification Required",
          hintText: "e.g. 3+ years of experience",
          isNumberKeyboard: false,
          prefixWidget: const Icon(
            CupertinoIcons.star,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        CustomTextField(
          controller: descriptionController,
          labelText: "Internship Responsibilities",
          hintText: "Enter internship responsibilities (one per line)",
          isNumberKeyboard: false,
          maxLines: 5,
        ),
        _buildProjectsSection(),
      ],
    );
  }

  Widget _buildProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          "Add Project",
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        ...List.generate(projectControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: projectControllers[index],
                    labelText: "Project ${index + 1}",
                    hintText:
                        "Describe project ${index + 1} (used for syllabus generation)",
                    isNumberKeyboard: false,
                  ),
                ),
                if (projectControllers.length > 1)
                  InkWell(
                    onTap: () {
                      setState(() {
                        projectControllers[index].dispose();
                        projectControllers.removeAt(index);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        CupertinoIcons.trash,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
        InkWell(
          onTap: () =>
              setState(() => projectControllers.add(TextEditingController())),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              const Icon(
                Icons.add_circle_outline,
                color: AppColors.primaryColor,
                size: 18,
              ),
              Text(
                "Add More Project",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.primaryColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STEP 3 — LOCATION & DURATION
  // ============================================================
  Widget _buildLocationDurationStep() {
    return Column(
      key: const ValueKey("step2"),
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: [
        _buildDropdownPicker(
          label: "Select State",
          icon: CupertinoIcons.map,
          value: selectedState,
          placeholder: "Select State",
          onTap: () => _showOptionPicker(
            title: "Select State",
            options: stateList,
            selected: selectedState,
            onSelected: (val) {
              setState(() {
                selectedState = val;
                selectedDistrict = null;
              });
            },
          ),
        ),
        _buildDropdownPicker(
          label: "District",
          icon: CupertinoIcons.location,
          value: selectedDistrict,
          placeholder: selectedState == null
              ? "Select state first"
              : "Select District",
          enabled: selectedState != null,
          onTap: selectedState == null
              ? null
              : () => _showOptionPicker(
                  title: "Select District",
                  options: districtMap[selectedState] ?? [],
                  selected: selectedDistrict,
                  onSelected: (val) => setState(() => selectedDistrict = val),
                ),
        ),
        _buildDropdownPicker(
          label: "Internship Mode",
          icon: CupertinoIcons.briefcase,
          value: selectedInternshipMode,
          placeholder: "Select Mode",
          onTap: () => _showOptionPicker(
            title: "Internship Mode",
            options: internshipModeList,
            selected: selectedInternshipMode,
            onSelected: (val) => setState(() => selectedInternshipMode = val),
          ),
        ),
        CustomTextField(
          controller: locationLinkController,
          labelText: "Google Maps Link",
          hintText: "https://goo.gl/maps/example123",
          isNumberKeyboard: false,
          prefixWidget: const Icon(
            CupertinoIcons.location_solid,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        _buildDurationTypeSelector(),
        _buildDropdownPicker(
          label:
              "Internship Duration (${durationType == "Months" ? "Months" : "Days"})",
          icon: CupertinoIcons.calendar,
          value: selectedDuration,
          placeholder: "Select Duration",
          onTap: () => _showOptionPicker(
            title: "Select Duration",
            options: durationOptions,
            selected: selectedDuration,
            onSelected: (val) => setState(() => selectedDuration = val),
          ),
        ),
        _buildPositionsCounter(),
      ],
    );
  }

  Widget _buildDurationTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Internship Duration Type",
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        Row(
          spacing: 20,
          children: [
            _buildRadioOption(
              label: "Months",
              selected: durationType == "Months",
              onTap: () => setState(() {
                durationType = "Months";
                selectedDuration = null;
              }),
            ),
            _buildRadioOption(
              label: "Days",
              selected: durationType == "Days",
              onTap: () => setState(() {
                durationType = "Days";
                selectedDuration = null;
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? AppColors.primaryColor : AppColors.greyIcon,
            size: 20,
          ),
          Text(
            label,
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.whiteColor,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionsCounter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Number of Positions",
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        CounterTextField(
          value: numberOfPositions,
          onChanged: (v) => setState(() => numberOfPositions = v),
          min: 1,
          max: 1000,
          hintText: "e.g. 5, 10",
        ),
      ],
    );
  }

  // ============================================================
  // STEP 4 — REQUIREMENTS
  // ============================================================
  Widget _buildRequirementsStep() {
    return Column(
      key: const ValueKey("step3"),
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: [
        _buildMultiSelectQualifications(),
        CustomTextField(
          controller: fieldOfStudyController,
          labelText: "Field of Study",
          hintText: "e.g. Computer Science",
          isNumberKeyboard: false,
        ),
        _buildSkillsInput(),
        CustomTextField(
          controller: eligibilityCriteriaController,
          labelText: "Eligibility Criteria",
          hintText: "Any additional eligibility notes",
          isNumberKeyboard: false,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildMultiSelectQualifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Student Qualification",
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        InkWell(
          onTap: _showQualificationPicker,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.fieldBgColor,
              border: Border.all(color: AppColors.fieldBorderColor),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.book,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: selectedQualifications.isEmpty
                      ? Text(
                          "Select qualifications",
                          style: AppStyles.customTextStyle(
                            size: 14,
                            color: AppColors.greyTextColor,
                            weight: FontWeight.w400,
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedQualifications
                              .map(
                                (q) => _buildChip(
                                  label: q,
                                  onRemove: () => setState(
                                    () => selectedQualifications.remove(q),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ),
                const Icon(
                  CupertinoIcons.chevron_down,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        if (selectedQualifications.isEmpty)
          Text(
            "Please select at least one qualification",
            style: AppStyles.customTextStyle(
              size: 12,
              color: Colors.redAccent,
              weight: FontWeight.w400,
            ),
          ),
      ],
    );
  }

  void _showQualificationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Wrap(
            children: List.generate(qualificationOptions.length, (index) {
              final option = qualificationOptions[index];
              final isSelected = selectedQualifications.contains(option);
              return ListTile(
                title: Text(
                  option,
                  style: AppStyles.customTextStyle(
                    fontFamily: 'Roboto',
                    color: AppColors.blackColor,
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setSheetState(() {
                    setState(() {
                      if (isSelected) {
                        selectedQualifications.remove(option);
                      } else {
                        selectedQualifications.add(option);
                      }
                    });
                  });
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Required Skills",
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        CustomTextField(
          controller: skillInputController,
          labelText: "Required skills",
          hintText: "e.g. JavaScript, Python, React",
          isNumberKeyboard: false,

          //onFieldSubmitted: (_) => _addSkill(),
          suffixWidget: InkWell(
            onTap: _addSkill,
            child: const Icon(
              Icons.add_circle,
              color: AppColors.primaryColor,
              size: 22,
            ),
          ),
        ),
        if (requiredSkills.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: requiredSkills
                .map(
                  (s) => _buildChip(
                    label: s,
                    onRemove: () => setState(() => requiredSkills.remove(s)),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  void _addSkill() {
    final raw = skillInputController.text.trim();
    if (raw.isEmpty) return;
    // allow comma separated entry too
    final parts = raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    setState(() {
      for (final p in parts) {
        if (!requiredSkills.contains(p)) requiredSkills.add(p);
      }
      skillInputController.clear();
    });
  }

  Widget _buildChip({required String label, required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Text(
            label,
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.primaryColor,
              weight: FontWeight.w600,
            ),
          ),
          InkWell(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP 5 — STIPEND / FEES
  // ============================================================
  Widget _buildStipendStep() {
    return Column(
      key: const ValueKey("step4"),
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: [
        Text(
          "Internship Stipend",
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        Wrap(
          spacing: 18,
          runSpacing: 10,
          children: [
            _buildRadioOption(
              label: "Free Internship",
              selected: stipendType == StipendType.free,
              onTap: () => setState(() {
                stipendType = StipendType.free;
                stipendAmountController.clear();
              }),
            ),
            _buildRadioOption(
              label: "Paid Internship",
              selected: stipendType == StipendType.paid,
              onTap: () => setState(() => stipendType = StipendType.paid),
            ),
            _buildRadioOption(
              label: "Fees Internship",
              selected: stipendType == StipendType.fees,
              onTap: () => setState(() => stipendType = StipendType.fees),
            ),
          ],
        ),
        if (stipendType != StipendType.free)
          CounterTextField(
            value: int.tryParse(stipendAmountController.text) ?? 0,
            onChanged: (v) =>
                setState(() => stipendAmountController.text = v.toString()),
            min: 0,
            max: 1000000,
            hintText: stipendType == StipendType.paid
                ? "Monthly stipend amount"
                : "Student pays internship fee",
          ),
      ],
    );
  }

  // ============================================================
  // SHARED DROPDOWN PICKER UI
  // ============================================================
  Widget _buildDropdownPicker({
    required String label,
    required IconData icon,
    required String? value,
    required String placeholder,
    required VoidCallback? onTap,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          label,
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: enabled
                  ? AppColors.fieldBgColor
                  : AppColors.fieldBgColor.withValues(alpha: 0.5),
              border: Border.all(color: AppColors.fieldBorderColor),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value ?? placeholder,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: value == null
                          ? AppColors.greyTextColor
                          : AppColors.whiteColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.chevron_down,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showOptionPicker({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: List.generate(options.length, (index) {
            final option = options[index];
            return ListTile(
              title: Text(
                option,
                style: AppStyles.customTextStyle(
                  fontFamily: 'Roboto',
                  color: AppColors.blackColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              trailing: selected == option
                  ? const Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
              onTap: () {
                onSelected(option);
                Get.back();
              },
            );
          }),
        ),
      ),
    );
  }

  // ============================================================
  // SUBMIT
  // ============================================================
  Future<void> _postInternship() async {
    setState(() => postLoading = true);

    final String stipendValue = stipendType == StipendType.free
        ? "Free"
        : stipendAmountController.text.trim();

    final Map<String, dynamic> payload = {
      "companyname": companyNameController.text.trim(),
      "aboutcompany": aboutCompanyController.text.trim(),
      "companywebsite": companyWebsiteController.text.trim(),
      "roletype": roleTypeController.text.trim(),
      "title": titleController.text.trim(),
      "qualification": qualificationController.text.trim(),
      "intershipdescription": descriptionController.text.trim(),
      // dio FormData supports repeated keys for array fields when you pass
      // a List<MapEntry<String, dynamic>> — adjust to match your FormData
      // helper / API client conventions.
      "studentqualification[]": selectedQualifications,
      "fieldofstudy": fieldOfStudyController.text.trim(),
      "requiredskills[]": requiredSkills,
      "eligibilitycriteria": eligibilityCriteriaController.text.trim(),
      "companystate": selectedState ?? "",
      "companycity": selectedDistrict ?? "",
      "locationlink": locationLinkController.text.trim(),
      "internshipmode": selectedInternshipMode ?? "",
      "durationtype": durationType,
      "internshipduration": selectedDuration ?? "",
      "days": durationType == "Days" ? (selectedDuration ?? "") : "",
      "numberofpositions": numberOfPositions.toString(),
      "internshipstipend": stipendValue,
      "projects": projectControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
    };

    try {
      // TODO: replace with your real controller call once it's wired up, e.g.
      // await postInternshipController.postInternship(postData: payload);
      // if (postInternshipController.getResponseCode() == 200 ||
      //     postInternshipController.getResponseCode() == 201) {
      //   AppAlertUtils.showToast(
      //     message: "Internship posted successfully!",
      //     isError: false,
      //   );
      //   Get.back();
      // } else {
      //   AppFunctions.apiErrorHandling(
      //     postInternshipController.getResponseCode(),
      //     "Failed to post internship.",
      //   );
      // }
      debugPrint("Internship payload: $payload");
      AppAlertUtils.showToast(
        message: "Internship posted successfully!",
        isError: false,
      );
      Get.back();
    } catch (e) {
      AppAlertUtils.showToast(
        message: "Something went wrong. Please try again.",
        isError: true,
      );
    } finally {
      if (mounted) setState(() => postLoading = false);
    }
  }
}
