import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/utils/common_utils.dart';
import 'package:internsharks/app/core/widgets/counter_text_field.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

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
  final InternshipPostController postController =
      Get.find<InternshipPostController>();

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
  //final TextEditingController titleController = TextEditingController();
  final TextEditingController roleTypeController = TextEditingController();
  final TextEditingController coordinatorNameController = TextEditingController();
  final TextEditingController coordinatorMobileController = TextEditingController();
  final TextEditingController coordinatorEmailController = TextEditingController();

  // final TextEditingController qualificationController =
  //     TextEditingController(); // e.g. "3+ years of experience"
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
  int internshipDuration = 1;

  late List<String> stateList = districtMap.keys.toList()..sort();

  Map<String, List<String>> districtMap = CommonUtils.indiaStatesAndDistricts;

  final List<String> internshipModeList = const ["Onsite", "Remote", "Hybrid"];

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

  // final TextEditingController fieldOfStudyController = TextEditingController();
  // final TextEditingController eligibilityCriteriaController =
  //     TextEditingController();

  final TextEditingController skillInputController = TextEditingController();
  final List<String> requiredSkills = [];

  // ============================================================
  // SECTION 5 — STIPEND / FEES
  // ============================================================
  StipendType stipendType = StipendType.free;
  final TextEditingController stipendAmountController = TextEditingController();

  PostData? internPostData;
  bool? isEditScreen = false;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>?;

    internPostData = args?["internPostData"] as PostData?;
    isEditScreen = args?["isEditScreen"] ?? false;

    getProfileData();

    if (isEditScreen == true && internPostData != null) {
      _prefillEditData();
    }
  }

  String? recruiterId = "";

  Future<void> getProfileData() async {
    recruiterId = await LocalStorageService.getRecruiterId();
    try {
      await homeController.getRecruiterProfileData(recruiterId: recruiterId!);
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        if (isEditScreen == true) {
          setState(() {
            _prefillEditData();
          });
        } else {
          setState(() {
            _prefillCompanyInfo();
          });
        }
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

  void _prefillEditData() {
    final data = internPostData;
    if (data == null) return;

    // =============================
    // Company Information
    // =============================
    companyNameController.text = data.companyName ?? "";
    companyWebsiteController.text = data.companyWebsite ?? "";
    aboutCompanyController.text = data.aboutCompany ?? "";
    _existingLogoUrl = data.companyLogo ?? "";
    _existingLogoUrl = data.companyLogo ?? "";

    // =============================
    // Internship Details
    // =============================
    roleTypeController.text = data.roleType ?? "";
    coordinatorNameController.text = data.internshipNameCoordinator ?? "";
    coordinatorMobileController.text = data.internshipMobileCoordinator ?? "";
    coordinatorEmailController.text = data.internshipEmailCoordinator ?? "";

    // If you have a separate title in API
    // titleController.text = "";
    //
    // qualificationController.text = "";

    descriptionController.text = data.aboutInternship ?? "";

    // =============================
    // Projects
    // =============================
    final String durationStr = (data.internshipDuration ?? "").trim();
    final String daysStr = (data.days ?? "").trim();

    if (durationStr.isEmpty && daysStr.isNotEmpty && daysStr != "0") {
      debugPrint("&&&&&&&&&&&&&");
      debugPrint(
        "$durationStr+$daysStr----------------------------------------------------------",
      );
      // 1. Day-wise Internship configuration
      durationType = "Days";
      selectedDuration = daysStr;
      internshipDuration = int.tryParse(daysStr) ?? 1;
    } else {
      // 2. Month-wise Internship configuration (Default Fallback)
      durationType = "Months";
      selectedDuration = durationStr.isNotEmpty ? durationStr : "1";
      internshipDuration = int.tryParse(durationStr) ?? 1;
    }

    projectControllers.clear();

    if (data.projectDescription != null &&
        data.projectDescription!.isNotEmpty) {
      for (final project in data.projectDescription!) {
        projectControllers.add(TextEditingController(text: project));
      }
    } else {
      projectControllers.add(TextEditingController());
    }

    // =============================
    // Location
    // =============================

    selectedState = data.companyState;
    selectedDistrict = data.companyCity;
    selectedInternshipMode = data.internshipMode;

    locationLinkController.text = data.locationLink ?? "";

    // =============================
    // Duration
    // =============================

    final duration = int.tryParse(data.internshipDuration ?? "1") ?? 1;
    internshipDuration = duration;

    durationType = (data.days != null && data.days!.isNotEmpty)
        ? "Days"
        : "Months";

    // =============================
    // Positions
    // =============================

    numberOfPositions = data.internPositions ?? 1;
    numberOfPositions = data.internPositions ?? 1;

    // =============================
    // Qualification
    // =============================

    selectedQualifications.clear();

    if (data.studentQualification != null) {
      selectedQualifications.addAll(data.studentQualification!);
    }

    // =============================
    // Skills
    // =============================

    requiredSkills.clear();

    if (data.requiredSkills != null) {
      requiredSkills.addAll(data.requiredSkills!);
    }

    // =============================
    // Stipend
    // =============================
    //
    // final stipend = data.internshipStipend ?? "";
    //
    // if (stipend == "N/A") {
    //   stipendType = StipendType.free;
    //   stipendAmountController.clear();
    // } else {
    //   stipendType = StipendType.paid;
    //   stipendAmountController.text = stipend;
    // }
    final stipend = data.internshipStipend ?? "N/A";
    final fee = data.fee ?? "0"; // Fallback to "0" if null

    if (fee != "0") {
      // 1. FEES Model
      stipendType = StipendType.fees;
      stipendAmountController.text = fee;
    } else if (stipend != "N/A") {
      // 2. STIPEND Model
      stipendType = StipendType.paid;
      stipendAmountController.text = stipend;
    } else {
      // 3. FREE Model (stipend == "N/A" && fee == "0")
      stipendType = StipendType.free;
      stipendAmountController.clear();
    }

    setState(() {});
  }

  @override
  void dispose() {
    companyNameController.dispose();
    companyWebsiteController.dispose();
    aboutCompanyController.dispose();
    //titleController.dispose();
    roleTypeController.dispose();
    coordinatorNameController.dispose();
    coordinatorEmailController.dispose();
    coordinatorMobileController.dispose();
    //qualificationController.dispose();
    descriptionController.dispose();
    for (final c in projectControllers) {
      c.dispose();
    }
    locationLinkController.dispose();
    // fieldOfStudyController.dispose();
    // eligibilityCriteriaController.dispose();
    skillInputController.dispose();
    stipendAmountController.dispose();
    _scrollController.dispose();
    super.dispose();
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            onPressed: () {
              if (currentStep == 0) {
                Get.back();
              } else {
                _goToStep(currentStep - 1);
              }
            },
          ),
          title: Text(
            isEditScreen! ? "Edit Posted Internship" : "Post an Internship",
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
                            lineSpace: 1.5,
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
                                (currentStep == 4 || currentStep == 3)
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.2,
                                      )
                                    : const SizedBox(height: 10),
                                CustomButtonWidget(
                                  isLoading:
                                      postController.createInternshipLoading ||
                                      postController.updateInternshipLoading,
                                  buttonText: currentStep == totalSteps - 1
                                      ? isEditScreen!
                                            ? "Update Internship"
                                            : "Post Internship"
                                      : "Next",
                                  buttonFunction: () async {
                                    await _handleNext();
                                  },
                                ),
                                const SizedBox(height: 150),
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
      spacing: 10,
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
        // if (titleController.text.trim().isEmpty) {
        //   AppAlertUtils.showToast(
        //     message: "Internship title is required",
        //     isError: true,
        //   );
        //   return false;
        // }
        if (descriptionController.text.trim().isEmpty) {
          AppAlertUtils.showToast(
            message: "Internship responsibilities are required",
            isError: true,
          );
          return false;
        }
        final projectDescriptions = projectControllers
            .map((e) => e.text.trim())
            .toList();

        for (int i = 0; i < projectDescriptions.length; i++) {
          if (projectDescriptions[i].isEmpty) {
            AppAlertUtils.showToast(
              message: "Please enter Project ${i + 1} description",
              isError: true,
            );
            return false;
          }
        }

        if (projectDescriptions.toSet().length != projectDescriptions.length) {
          AppAlertUtils.showToast(
            message: "Duplicate project descriptions are not allowed",
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
        if (selectedDuration == null ||
            internshipDuration == null ||
            internshipDuration <= 0) {
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
        // if (skillInputController.text.isEmpty) {
        //   AppAlertUtils.showToast(
        //     message: "Please enter at least one skill",
        //     isError: true,
        //   );
        //   return false;
        // }
        // if (requiredSkills.isEmpty) {
        //   AppAlertUtils.showToast(
        //     message: "Please add this skill by pressing Enter or tapping the add icon",
        //     isError: true,
        //   );
        //   return false;
        // }
        if (requiredSkills.isEmpty) {
          AppAlertUtils.showToast(
            message: "Please add at least one skill. Press Enter or tap the '+' icon to add it.",
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
        // CustomTextField(
        //   controller: titleController,
        //   labelText: "Internship Title",
        //   hintText: "e.g. Flutter Developer Intern",
        //   isNumberKeyboard: false,
        //   prefixWidget: const Icon(
        //     CupertinoIcons.tag,
        //     color: AppColors.primaryColor,
        //     size: 20,
        //   ),
        // ),
        // CustomTextField(
        //   controller: qualificationController,
        //   labelText: "Experience / Qualification Required",
        //   hintText: "e.g. 3+ years of experience",
        //   isNumberKeyboard: false,
        //   prefixWidget: const Icon(
        //     CupertinoIcons.star,
        //     color: AppColors.primaryColor,
        //     size: 20,
        //   ),
        // ),
        CustomTextField(
          controller: descriptionController,
          labelText: "Internship Responsibilities",
          hintText: "Enter internship responsibilities (one per line)",
          isNumberKeyboard: false,
          maxLines: 5,
        ),
        CustomTextField(
          controller: coordinatorNameController,
          labelText: "Coordinator's Name",
          hintText: "Ex: Kathir",
          isNumberKeyboard: false,
          prefixWidget: const Icon(
            CupertinoIcons.person_badge_plus,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        CustomTextField(
          controller: coordinatorMobileController,
          labelText: "Coordinator's Mobile Number",
          hintText: "Ex: 9090909090",
          isNumberKeyboard: true,
          prefixWidget: const Icon(
            CupertinoIcons.phone,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        CustomTextField(
          controller: coordinatorEmailController,
          labelText: "Coordinator's Contact Email",
          hintText: "Ex: kathir123@gmail.com",
          isNumberKeyboard: false,
          prefixWidget: const Icon(
            CupertinoIcons.mail,
            color: AppColors.primaryColor,
            size: 20,
          ),
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
            weight: FontWeight.w700,
          ),
        ),
        ...List.generate(projectControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
        InkWell(
          onTap: () {
            if (projectControllers.last.text.trim().isEmpty) {
              AppAlertUtils.showToast(
                message: "Please fill the current project description first",
                isError: true,
              );
              return;
            }
            setState(() {
              projectControllers.add(TextEditingController());
            });
          },
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
              : () {
                  final districts = List<String>.from(
                    districtMap[selectedState] ?? [],
                  )..sort();
                  _showOptionPicker(
                    title: "Select District",
                    options: districts,
                    selected: selectedDistrict,
                    onSelected: (val) => setState(() => selectedDistrict = val),
                  );
                },
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
        CounterTextField(
          labelText: "Internship Duration ($durationType)",
          value: selectedDuration != null
              ? int.parse(selectedDuration!)
              : internshipDuration,
          onChanged: (value) {
            setState(() {
              internshipDuration = value;
              selectedDuration = value.toString();
            });
          },
          min: 1,
          max: durationType == "Months" ? 24 : 365,
          hintText: durationType == "Months" ? "e.g. 6 Months" : "e.g. 30 Days",
        ),
        // _buildDropdownPicker(
        //   label:
        //       "Internship Duration (${durationType == "Months" ? "Months" : "Days"})",
        //   icon: CupertinoIcons.calendar,
        //   value: selectedDuration,
        //   placeholder: "Select Duration",
        //   onTap: () => _showOptionPicker(
        //     title: "Select Duration",
        //     options: durationOptions,
        //     selected: selectedDuration,
        //     onSelected: (val) => setState(() => selectedDuration = val),
        //   ),
        // ),
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
            weight: FontWeight.w700,
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
                //selectedDuration = null;
              }),
            ),
            _buildRadioOption(
              label: "Days",
              selected: durationType == "Days",
              onTap: () => setState(() {
                durationType = "Days";
                //selectedDuration = null;
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
            size: 15,
            weight: FontWeight.w700,
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
        // CustomTextField(
        //   controller: fieldOfStudyController,
        //   labelText: "Field of Study",
        //   hintText: "e.g. Computer Science",
        //   isNumberKeyboard: false,
        // ),
        _buildSkillsInput(),
        // CustomTextField(
        //   controller: eligibilityCriteriaController,
        //   labelText: "Eligibility Criteria",
        //   hintText: "Any additional eligibility notes",
        //   isNumberKeyboard: false,
        //   maxLines: 3,
        // ),
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
        // if (selectedQualifications.isEmpty)
        //   Text(
        //     "Please select at least one qualification",
        //     style: AppStyles.customTextStyle(
        //       size: 12,
        //       color: Colors.redAccent,
        //       weight: FontWeight.w400,
        //     ),
        //   ),
      ],
    );
  }

  void _showQualificationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.fieldBgColor,
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
                    color: AppColors.whiteColor,
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
        CustomTextField(
          controller: skillInputController,
          labelText: "Required skills",
          hintText: "e.g. JavaScript, Python, React",
          isNumberKeyboard: false,
          onFieldSubmitted: (_) => _addSkill(),
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
                  : AppColors.disableFieldColor,
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
      isScrollControlled: true,
      // Allows bottom sheet to expand up when keyboard opens
      backgroundColor: AppColors.fieldBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        String searchQuery = ""; // Keeps track of what the user is typing

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Filter the items dynamically based on search query
            final filteredOptions = options
                .where(
                  (option) =>
                      option.toLowerCase().contains(searchQuery.toLowerCase()),
                )
                .toList();

            return Container(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height *
                    0.7, // Cap height at 70% of screen
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(
                  context,
                ).viewInsets.bottom, // Pushes up above keyboard
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title and Search Bar Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppStyles.customTextStyle(
                              color: AppColors.whiteColor,
                              size: 16,
                              weight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Search Input Field
                          TextField(
                            style: AppStyles.customTextStyle(
                              color: AppColors.whiteColor,
                              size: 14,
                            ),
                            cursorColor: AppColors.primaryColor,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              hintStyle: AppStyles.customTextStyle(
                                color: AppColors.greyTextColor,
                                size: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.greyTextColor,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: AppColors.disableFieldColor,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              // Using setModalState forces only the bottom sheet layout to update
                              setModalState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.fieldBorderColor, height: 1),

                    // Screen Options List
                    Expanded(
                      child: filteredOptions.isEmpty
                          ? Center(
                              child: Text(
                                "No options found",
                                style: AppStyles.customTextStyle(
                                  color: AppColors.greyTextColor,
                                  size: 14,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredOptions.length,
                              itemBuilder: (context, index) {
                                final option = filteredOptions[index];
                                return ListTile(
                                  title: Text(
                                    option,
                                    style: AppStyles.customTextStyle(
                                      fontFamily: 'Roboto',
                                      color: AppColors.whiteColor,
                                      size: 14,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: selected == option
                                      ? const Icon(
                                          Icons.check,
                                          color: AppColors.primaryColor,
                                        )
                                      : null,
                                  onTap: () {
                                    onSelected(option);
                                    Get.back();
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _postInternship() async {
    final String stipendValue = stipendType == StipendType.paid
        ? stipendAmountController.text.trim()
        : "N/A";

    final String feeValue = stipendType == StipendType.fees
        ? stipendAmountController.text.trim()
        : "0";

    final Map<String, dynamic> payload = {
      "recruiterId": recruiterId,
      "companyname": companyNameController.text.trim(),
      "aboutcompany": aboutCompanyController.text.trim(),
      "companywebsite": companyWebsiteController.text.trim(),
      "roletype": roleTypeController.text.trim(),
      "internship_coordinator": coordinatorNameController.text.trim(),
      "coordinatorName": coordinatorNameController.text.trim(),
      "coordinatorEmail": coordinatorEmailController.text.trim(),
      "coordinatorMobile": coordinatorMobileController.text.trim(),
      // "title": titleController.text.trim(),
      // "qualification": qualificationController.text.trim(),
      "intershipdescription": descriptionController.text.trim(),
      "aboutinternship": descriptionController.text.trim(),
      "studentqualification": selectedQualifications,
      //"fieldofstudy": fieldOfStudyController.text.trim(),
      "requiredskills": requiredSkills,
      //"eligibilitycriteria": eligibilityCriteriaController.text.trim(),
      "companystate": selectedState ?? "",
      "companycity": selectedDistrict ?? "",
      "locationlink": locationLinkController.text.trim(),
      "internshipmode": selectedInternshipMode ?? "",
      "durationtype": durationType,
      "internshipduration": durationType != "Days"
          ? (selectedDuration ?? "")
          : "",
      "days": durationType == "Days" ? (selectedDuration ?? "") : "",
      "noofposition": numberOfPositions.toString(),
      "internpositions": numberOfPositions.toString(),
      "internshipstipend": stipendValue,
      "fee": feeValue,
      "project_description": projectControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
    };

    try {
      debugPrint("Internship payload: $payload");

      if (isEditScreen == true) {
        await postController.updateNewInternship(
          internshipData: payload,
          jobId: internPostData?.id ?? "",
        );
      } else {
        await postController.createNewInternship(internshipData: payload);
      }

      final int responseCode = postController.getResponseCode();

      if (responseCode == 200 || responseCode == 201) {
        // Safely deduce the server message without forcing direct dot-notation properties blindly
        debugPrint(
          postController.createInternshipModel.toJson().toString(),
          wrapWidth: 1024,
        );
        String? serverMessage;
        try {
          serverMessage = isEditScreen == true
              ? postController.createInternshipModel?.message
              : postController.createInternshipModel?.message;
        } catch (_) {
          // Fallback catch if the models themselves are structurally distinct or null
        }

        final String fallbackText =
            "Internship ${isEditScreen == true ? "updated" : "posted"} successfully!";

        AppAlertUtils.showToast(
          message: serverMessage ?? fallbackText,
          isError: false,
        );

        // Using Get.offAll() prevents failures if AppRoutes configuration names contain mismatches
        Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
        // Note: If Get.offAllNamed still fails, replace temporary with: Get.offAll(() => RecruiterDashboardScreen());
      } else {
        AppFunctions.apiErrorHandling(
          responseCode,
          "Failed to process internship request.",
        );
      }
    } catch (e, stacktrace) {
      // Crucial step: prints exactly what broke line-by-line to your terminal console logs
      debugPrint("Error during submission flow execution: $e");
      debugPrint("Stacktrace layout: $stacktrace");

      AppAlertUtils.showToast(
        message: "Something went wrong. Please try again.",
        isError: true,
      );
    }
  }
}
