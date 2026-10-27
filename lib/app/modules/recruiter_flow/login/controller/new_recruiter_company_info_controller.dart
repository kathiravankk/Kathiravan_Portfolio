import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/data/models/recruiter_flow/company_document_extracted_model.dart';
import 'package:internsharks/app/data/providers/dashboard_provider.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_register_provider.dart';

class NewRecruiterCompanyInfoController extends GetxController {
  final RecruiterRegisterProvider recruiterRegisterProvider;

  NewRecruiterCompanyInfoController({required this.recruiterRegisterProvider});

  /// Direct provider to fetch the industry/category list without requiring
  /// DashboardController (which depends on ProfileController being registered).
  late final DashboardProvider _dashboardProvider;

  // ─── STEP 1 ARGUMENTS ───────────────────────────────────────────
  Map<String, dynamic> step1Data = {};

  // ─── TAB SELECTION (0 = Upload File, 1 = Paste Link) ────────────
  final selectedTab = 0.obs;

  // ─── TEXT CONTROLLERS ───────────────────────────────────────────
  final pasteLinkController = TextEditingController();

  final companyNameController = TextEditingController();
  final companyEmailController = TextEditingController();
  final contactNumberController = TextEditingController();
  final companyAddressController = TextEditingController();
  final pinCodeController = TextEditingController();
  final companyWebsiteController = TextEditingController();
  final employeeRangeController = TextEditingController();
  final companyDescriptionController = TextEditingController();
  final companyTypeController = TextEditingController();
  final foundedYearController = TextEditingController();
  final gstCinController = TextEditingController();
  final companyMissionController = TextEditingController();
  final companyVisionController = TextEditingController();
  final coreServicesController = TextEditingController();
  final whyInternWithUsController = TextEditingController();

  // Social Media Controllers
  final linkedInController = TextEditingController();
  final xController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final youtubeController = TextEditingController();

  // ─── CHARACTER COUNTERS ─────────────────────────────────────────
  final descriptionLength = 0.obs;
  final missionLength = 0.obs;
  final visionLength = 0.obs;
  final whyInternLength = 0.obs;

  // ─── DROPDOWNS & SELECTORS ──────────────────────────────────────
  final selectedIndustry = RxnString();
  final industryList = <String>[].obs;

  final selectedEmployeeCount = RxnString();
  final List<String> employeeCountOptions = [
    '1-10',
    '11-50',
    '51-200',
    '201-500',
    '501-1000',
    '1000+',
  ];

  final selectedWorkingModel = RxnString();
  final List<String> workingModelOptions = [
    'Remote',
    'On-site',
    'Hybrid',
  ];

  // ─── FILES & UPLOADS ────────────────────────────────────────────
  static const int maxLogoSizeBytes = 2 * 1024 * 1024; // 2 MB
  static const int maxDocumentSizeBytes = 5 * 1024 * 1024; // 5 MB

  final companyLogo = Rxn<File>();
  MultipartFile? companyLogoMultipartFile;

  final registrationDocFile = Rxn<File>();
  final registrationDocName = RxnString();
  MultipartFile? registrationDocMultipartFile;

  final supportingDocFile = Rxn<File>();
  final supportingDocName = RxnString();
  MultipartFile? supportingDocMultipartFile;

  // ─── EXTRACTION STATE ───────────────────────────────────────────
  final isExtracting = false.obs;
  final extractedFileName = RxnString();
  final extractedModel = Rxn<CompanyDocumentExtractedModel>();

  @override
  void onInit() {
    super.onInit();
    _dashboardProvider = DashboardProvider(client: Dio());
    _initArguments();
    _initListeners();
    getIndustryListData();
  }

  void _initArguments() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      step1Data = Get.arguments as Map<String, dynamic>;
    }
  }

  void _initListeners() {
    companyDescriptionController.addListener(() {
      descriptionLength.value = companyDescriptionController.text.length;
    });
    companyMissionController.addListener(() {
      missionLength.value = companyMissionController.text.length;
    });
    companyVisionController.addListener(() {
      visionLength.value = companyVisionController.text.length;
    });
    whyInternWithUsController.addListener(() {
      whyInternLength.value = whyInternWithUsController.text.length;
    });
  }

  // ─── GET INDUSTRY LIST DATA ─────────────────────────────────────
  Future<void> getIndustryListData() async {
    try {
      final categoryListModel = await _dashboardProvider.fetchCategoryList();
      final code = _dashboardProvider.responseStatus;
      if (code == 200 || code == 201) {
        industryList.value = (categoryListModel.categoryList ?? [])
            .map((category) => category.categoryName!)
            .toList();
      } else {
        AppFunctions.apiErrorHandling(code, "Could not load industry list");
      }
    } catch (error) {
      // Silently fail — industry list is optional during registration
      debugPrint("[IndustryList] Failed to fetch: $error");
    }
  }

  // ─── EXTRACT DATA: UPLOAD FILE ──────────────────────────────────
  Future<void> pickAndExtractFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result == null || result.files.isEmpty) return;
      final pickedFile = result.files.single;

      if (pickedFile.path == null) {
        AppAlertUtils.showToast(
          message: 'Could not read the selected file',
          isError: true,
        );
        return;
      }

      extractedFileName.value = pickedFile.name;
      await extractFromDocument(filePath: pickedFile.path!);
    } catch (e) {
      AppAlertUtils.showToast(
        message: 'Could not select file: $e',
        isError: true,
      );
    }
  }

  // ─── EXTRACT DATA: PASTE LINK ───────────────────────────────────
  Future<void> extractFromLink() async {
    final link = pasteLinkController.text.trim();
    if (link.isEmpty) {
      AppAlertUtils.showToast(
        message: 'Please enter a valid website or profile URL',
        isError: true,
      );
      return;
    }

    if (!link.startsWith('http://') && !link.startsWith('https://')) {
      AppAlertUtils.showToast(
        message: 'URL must start with http:// or https://',
        isError: true,
      );
      return;
    }

    await extractFromDocument(linkUrl: link);
  }

  // ─── CALL EXTRACTION API ────────────────────────────────────────
  Future<void> extractFromDocument({
    String? filePath,
    String? linkUrl,
  }) async {
    try {
      isExtracting.value = true;
      final response =
          await recruiterRegisterProvider.extractCompanyDocumentData(
        filePath: filePath,
        linkUrl: linkUrl,
      );

      isExtracting.value = false;

      if (response is CompanyDocumentExtractedModel &&
          (response.success == true || response.data?.success == true)) {
        extractedModel.value = response;
        populateExtractedData(response);
        AppAlertUtils.showToast(
          message: response.message ?? 'Document data extracted successfully',
          isError: false,
        );
      } else {
        AppAlertUtils.showToast(
          message: response?.message ?? 'Failed to extract data from document',
          isError: true,
        );
      }
    } catch (e) {
      isExtracting.value = false;
      AppAlertUtils.showToast(
        message: 'Error extracting document: $e',
        isError: true,
      );
    }
  }

  // ─── POPULATE EXTRACTED DATA INTO FIELDS ────────────────────────
  void populateExtractedData(CompanyDocumentExtractedModel model) {
    final info = model.data?.extractedData?.companyInformation;
    final social = model.data?.extractedData?.socialMediaLinks;

    if (info != null) {
      if (info.companyName != null && info.companyName!.isNotEmpty) {
        companyNameController.text = info.companyName!;
      }
      if (info.companyAddress != null && info.companyAddress!.isNotEmpty) {
        companyAddressController.text = info.companyAddress!;
      }
      if (info.companyPincode != null && info.companyPincode!.isNotEmpty) {
        pinCodeController.text = info.companyPincode!;
      }
      if (info.companyWebsite != null && info.companyWebsite!.isNotEmpty) {
        companyWebsiteController.text = info.companyWebsite!;
      }
      if (info.companyEmail != null && info.companyEmail!.isNotEmpty) {
        companyEmailController.text = info.companyEmail!;
      }
      if (info.companyDescription != null &&
          info.companyDescription!.isNotEmpty) {
        companyDescriptionController.text = info.companyDescription!;
        descriptionLength.value = companyDescriptionController.text.length;
      }
      if (info.companyContactNumber != null &&
          info.companyContactNumber!.isNotEmpty) {
        // Strip out country code if present (e.g. +91 44 22271400 -> clean number)
        String contact = info.companyContactNumber!.trim();
        if (contact.startsWith('+91')) {
          contact = contact.replaceFirst('+91', '').trim();
        }
        contactNumberController.text = contact;
      }

      // Match Industry Type
      if (info.industryType != null && info.industryType!.isNotEmpty) {
        final extractedInd = info.industryType!.toLowerCase();
        final matched = industryList.firstWhereOrNull(
          (ind) =>
              ind.toLowerCase() == extractedInd ||
              extractedInd.contains(ind.toLowerCase()) ||
              ind.toLowerCase().contains(extractedInd),
        );
        if (matched != null) {
          selectedIndustry.value = matched;
        } else {
          // Add or set if industry not in list
          selectedIndustry.value = info.industryType;
          if (!industryList.contains(info.industryType!)) {
            industryList.add(info.industryType!);
          }
        }
      }
    }

    if (social != null) {
      if (social.linkedin != null && social.linkedin!.isNotEmpty) {
        linkedInController.text = social.linkedin!;
      }
      if (social.twitterX != null && social.twitterX!.isNotEmpty) {
        xController.text = social.twitterX!;
      }
      if (social.facebook != null && social.facebook!.isNotEmpty) {
        facebookController.text = social.facebook!;
      }
      if (social.instagram != null && social.instagram!.isNotEmpty) {
        instagramController.text = social.instagram!;
      }
      if (social.youtube != null && social.youtube!.isNotEmpty) {
        youtubeController.text = social.youtube!;
      }
    }
  }

  // ─── LOGO PICKER ────────────────────────────────────────────────
  Future<void> pickCompanyLogo(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (picked == null) return;

      final file = File(picked.path);
      final sizeInBytes = await file.length();

      if (sizeInBytes > maxLogoSizeBytes) {
        AppAlertUtils.showToast(
          message: 'Logo too large (max 2 MB)',
          isError: true,
        );
        return;
      }

      companyLogoMultipartFile = await MultipartFile.fromFile(
        file.path,
        filename: 'company_logo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      companyLogo.value = file;
    } catch (e) {
      AppAlertUtils.showToast(
        message: 'Could not open camera/gallery: $e',
        isError: true,
      );
    }
  }

  // ─── COMPANY REGISTRATION DOCUMENT PICKER ───────────────────────
  Future<void> pickRegistrationDoc() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.single;
      final sizeInBytes = pickedFile.size;

      if (sizeInBytes > maxDocumentSizeBytes) {
        AppAlertUtils.showToast(
          message: 'Document too large (max 5 MB)',
          isError: true,
        );
        return;
      }

      if (pickedFile.path == null) {
        AppAlertUtils.showToast(
          message: 'Could not read file',
          isError: true,
        );
        return;
      }

      registrationDocMultipartFile = await MultipartFile.fromFile(
        pickedFile.path!,
        filename: pickedFile.name,
      );

      registrationDocFile.value = File(pickedFile.path!);
      registrationDocName.value = pickedFile.name;
    } catch (e) {
      AppAlertUtils.showToast(
        message: 'Could not pick document: $e',
        isError: true,
      );
    }
  }

  // ─── OTHER SUPPORTING DOCUMENT PICKER ───────────────────────────
  Future<void> pickSupportingDoc() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.single;
      final sizeInBytes = pickedFile.size;

      if (sizeInBytes > maxDocumentSizeBytes) {
        AppAlertUtils.showToast(
          message: 'Document too large (max 5 MB)',
          isError: true,
        );
        return;
      }

      if (pickedFile.path == null) {
        AppAlertUtils.showToast(
          message: 'Could not read file',
          isError: true,
        );
        return;
      }

      supportingDocMultipartFile = await MultipartFile.fromFile(
        pickedFile.path!,
        filename: pickedFile.name,
      );

      supportingDocFile.value = File(pickedFile.path!);
      supportingDocName.value = pickedFile.name;
    } catch (e) {
      AppAlertUtils.showToast(
        message: 'Could not pick document: $e',
        isError: true,
      );
    }
  }

  // ─── VALIDATION ─────────────────────────────────────────────────
  /// Required fields:
  /// company name, company email, company contact number, address, website,
  /// industry type, number of employees, company description, company logo
  String? validateStep2() {
    if (companyNameController.text.trim().isEmpty) {
      return "Company name is required";
    }

    final emailError = AppFunctions.validateEmail(
      newEmail: companyEmailController.text.trim(),
      currentEmail: null,
    );
    if (emailError != null) return emailError;

    if (contactNumberController.text.trim().isEmpty) {
      return "Company contact number is required";
    }

    if (companyAddressController.text.trim().isEmpty) {
      return "Company address is required";
    }

    if (companyWebsiteController.text.trim().isEmpty) {
      return "Company website is required";
    }

    if (selectedIndustry.value == null ||
        selectedIndustry.value!.trim().isEmpty) {
      return "Please select an industry type";
    }

    if (selectedEmployeeCount.value == null ||
        selectedEmployeeCount.value!.trim().isEmpty) {
      return "Please select number of employees";
    }

    if (companyDescriptionController.text.trim().isEmpty) {
      return "Company description is required";
    }

    if (companyLogo.value == null && companyLogoMultipartFile == null) {
      return "Company logo is required";
    }

    return null;
  }

  // ─── COLLECT STEP 2 DATA ────────────────────────────────────────
  Map<String, dynamic> getCombinedRegisterData() {
    return {
      ...step1Data,
      "companyName": companyNameController.text.trim(),
      "companyEmail": companyEmailController.text.trim(),
      "companyContactNumber": contactNumberController.text.trim(),
      "companyAddress": companyAddressController.text.trim(),
      "companyPincode": pinCodeController.text.trim(),
      "companyWebsite": companyWebsiteController.text.trim(),
      "industryType": selectedIndustry.value,
      "numberOfEmployees": selectedEmployeeCount.value,
      "employeeRange": employeeRangeController.text.trim(),
      "companyDescription": companyDescriptionController.text.trim(),
      "companyType": companyTypeController.text.trim(),
      "foundedYear": foundedYearController.text.trim(),
      "gstCin": gstCinController.text.trim(),
      "workingModel": selectedWorkingModel.value,
      "companyMission": companyMissionController.text.trim(),
      "companyVision": companyVisionController.text.trim(),
      "coreServices": coreServicesController.text.trim(),
      "whyInternWithUs": whyInternWithUsController.text.trim(),
      "socialMedia": {
        "linkedin": linkedInController.text.trim(),
        "x": xController.text.trim(),
        "facebook": facebookController.text.trim(),
        "instagram": instagramController.text.trim(),
        "youtube": youtubeController.text.trim(),
      },
      "companyLogo": companyLogoMultipartFile,
      "registrationDocument": registrationDocMultipartFile,
      "supportingDocument": supportingDocMultipartFile,
    };
  }

  @override
  void onClose() {
    pasteLinkController.dispose();
    companyNameController.dispose();
    companyEmailController.dispose();
    contactNumberController.dispose();
    companyAddressController.dispose();
    pinCodeController.dispose();
    companyWebsiteController.dispose();
    employeeRangeController.dispose();
    companyDescriptionController.dispose();
    companyTypeController.dispose();
    foundedYearController.dispose();
    gstCinController.dispose();
    companyMissionController.dispose();
    companyVisionController.dispose();
    coreServicesController.dispose();
    whyInternWithUsController.dispose();
    linkedInController.dispose();
    xController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    youtubeController.dispose();
    super.onClose();
  }
}
