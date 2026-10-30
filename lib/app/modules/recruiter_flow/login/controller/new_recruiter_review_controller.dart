import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_register_model.dart';
import 'package:internsharks/app/data/providers/dashboard_provider.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_register_provider.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class NewRecruiterReviewController extends GetxController {
  final RecruiterRegisterProvider recruiterRegisterProvider;

  NewRecruiterReviewController({required this.recruiterRegisterProvider});

  int getResponseCode() => recruiterRegisterProvider.responseStatus;

  // ─── FULL COMBINED DATA FROM STEPS 1 + 2 ───────────────────────
  /// Populated in onInit() from Get.arguments
  Map<String, dynamic> combinedData = {};

  // ─── LOADING STATE ──────────────────────────────────────────────
  final isLoading = false.obs;

  // ─── REGISTER MODEL ─────────────────────────────────────────────
  final _registerModel = RecruiterRegisterModel().obs;

  RecruiterRegisterModel get registerModel => _registerModel.value;

  set registerModel(RecruiterRegisterModel value) =>
      _registerModel.value = value;

  @override
  void onInit() {
    super.onInit();
    _initArguments();
  }

  void _initArguments() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      combinedData = Map<String, dynamic>.from(
        Get.arguments as Map<String, dynamic>,
      );
    }
  }

  // ─── CONVENIENCE GETTERS (Step 1) ───────────────────────────────

  String get fullName => combinedData['name']?.toString() ?? '';

  String get email => combinedData['email']?.toString() ?? '';

  String get mobile => combinedData['mobile']?.toString() ?? '';

  String get designation => combinedData['designation']?.toString() ?? '';

  // ─── CONVENIENCE GETTERS (Step 2) ───────────────────────────────

  String get companyName => combinedData['companyName']?.toString() ?? '';

  String get companyEmail => combinedData['companyEmail']?.toString() ?? '';

  String get companyContactNumber =>
      combinedData['companyContactNumber']?.toString() ?? '';

  String get companyAddress => combinedData['companyAddress']?.toString() ?? '';

  String get companyPincode => combinedData['companyPincode']?.toString() ?? '';

  String get companyWebsite => combinedData['companyWebsite']?.toString() ?? '';

  String get industryType => combinedData['industryType']?.toString() ?? '';

  String get numberOfEmployees =>
      combinedData['numberOfEmployees']?.toString() ?? '';

  String get employeeRange => combinedData['employeeRange']?.toString() ?? '';

  String get companyDescription =>
      combinedData['companyDescription']?.toString() ?? '';

  String get companyType => combinedData['companyType']?.toString() ?? '';

  String get foundedYear => combinedData['foundedYear']?.toString() ?? '';

  String get gstCin => combinedData['gstCin']?.toString() ?? '';

  String get workingModel => combinedData['workingModel']?.toString() ?? '';

  String get companyMission => combinedData['companyMission']?.toString() ?? '';

  String get companyVision => combinedData['companyVision']?.toString() ?? '';

  String get coreServices => combinedData['coreServices']?.toString() ?? '';

  String get whyInternWithUs =>
      combinedData['whyInternWithUs']?.toString() ?? '';

  Map<String, dynamic> get socialMedia {
    final sm = combinedData['socialMedia'];
    if (sm is Map<String, dynamic>) return sm;
    return {};
  }

  // ─── RESOLVE INDUSTRY TYPE ID (ObjectId) ────────────────────────
  Future<String> _resolveIndustryTypeId() async {
    // 1. If industryTypeId is passed in combinedData and is a valid 24-char hex ObjectId
    final idCandidate = combinedData['industryTypeId']?.toString().trim() ?? '';
    if (idCandidate.isNotEmpty &&
        RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(idCandidate)) {
      return idCandidate;
    }

    // 2. If industryType itself is already a 24-char hex ObjectId
    final nameOrId = industryType.trim();
    if (nameOrId.isNotEmpty &&
        RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(nameOrId)) {
      return nameOrId;
    }

    // 3. Information Technology exact ObjectId lookup
    final lowerName = nameOrId.toLowerCase();
    if (lowerName.contains('information') ||
        lowerName.contains('technology') ||
        lowerName == 'it') {
      return '68fb2b06d513c9bec54195ff';
    }

    // 4. Match from backend Category list
    try {
      final dashboardProvider = DashboardProvider(client: Dio());
      final res = await dashboardProvider.fetchCategoryList();
      final list = res.categoryList ?? [];
      final matched = list.firstWhereOrNull(
        (c) {
          final cName = (c.categoryName ?? '').toLowerCase().trim();
          return cName == lowerName ||
              lowerName.contains(cName) ||
              cName.contains(lowerName);
        },
      );
      if (matched != null &&
          matched.categoryId != null &&
          RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(matched.categoryId!)) {
        return matched.categoryId!;
      }
    } catch (e) {
      debugPrint('[ReviewController] Error resolving category ID: $e');
    }

    // 5. Safe fallback to Information Technology ObjectId
    return '68fb2b06d513c9bec54195ff';
  }

  // ─── BUILD REGISTER PAYLOAD ─────────────────────────────────────
  Future<Map<String, dynamic>> _buildRegisterPayload() async {
    final fcmToken = await LocalStorageService.getFcmToken() ?? '';
    final resolvedIndustryId = await _resolveIndustryTypeId();

    return {
      'fcmToken': fcmToken,
      'recname': fullName,
      'recemail': email,
      'recmobileno': mobile,
      'recmobilenocode': combinedData['countryCode'] ?? '+91',
      'recdesignation': designation,
      if (combinedData['referralCode'] != null &&
          combinedData['referralCode'].toString().isNotEmpty)
        'refcode': combinedData['referralCode'],
      'reccompanyname': companyName,
      'reccompanyemail': companyEmail,
      'reccompanycontactno': companyContactNumber,
      'reccompanyaddress': companyAddress,
      'reccompanypincode': companyPincode,
      'reccompanywebsite': companyWebsite,
      'reccompanyindustrytype': resolvedIndustryId,
      'reccompanysize': numberOfEmployees,
      'employee_range': employeeRange,
      'reccompanydescription': companyDescription,
      'company_type': companyType,
      'founded_year': foundedYear,
      'reccompanycinnumber': gstCin,
      'working_model': workingModel,
      'company_mission': companyMission,
      'reccompanywhyintern': whyInternWithUs,
      'why_intern': whyInternWithUs,
      'company_vision': companyVision,
      'reccompanycoreservices': coreServices,
      'core_services': coreServices,
      'instagram_link': socialMedia['instagram'] ?? '',
      'twitter_link': socialMedia['x'] ?? '',
      'linkedin_link': socialMedia['linkedin'] ?? '',
      'facebook_link': socialMedia['facebook'] ?? '',
      'youtube_link': socialMedia['youtube'] ?? '',
      // Binary files (MultipartFile) — passed through unchanged
      if (combinedData['companyLogo'] is MultipartFile)
        'reccompanylogo': combinedData['companyLogo'],
      if (combinedData['registrationDocument'] is MultipartFile)
        'reccompanydocument': combinedData['registrationDocument'],
    };
  }

  // ─── REGISTER API CALL ──────────────────────────────────────────
  Future<void> registerRecruiter() async {
    try {
      isLoading.value = true;
      final payload = await _buildRegisterPayload();

      final result = await recruiterRegisterProvider.newRecruiterRegister(
        registerData: payload,
      );

      isLoading.value = false;

      if (result is RecruiterRegisterModel) {
        registerModel = result;
      }

      if (getResponseCode() == 200 || getResponseCode() == 201) {
        debugPrint('★★★ Registration success ★★★');

        await LocalStorageService.saveRecruiterToken(
          recruiterToken: registerModel.recToken ?? '',
        );
        await LocalStorageService.saveRecruiterId(
          recruiterId: registerModel.recruiter?.id ?? '',
        );
        await LocalStorageService.saveRecruiterCreditId(
          creditId: registerModel.recruiter?.recruiterCreditId ?? '',
        );

        AppAlertUtils.showToast(
          message: registerModel.message ?? 'Registration Successful!',
          isError: false,
        );

        // Step 4: Choose Plan screen — navigate to it
        Get.offNamed(AppRoutes.newRecruiterChoosePlanScreen);
      } else {
        AppFunctions.apiErrorHandling(
          getResponseCode(),
          registerModel.message ?? 'Registration failed!',
        );
      }
    } catch (error) {
      isLoading.value = false;
      debugPrint('[Register] Error: $error');
      AppFunctions.apiErrorHandling(
        getResponseCode(),
        registerModel.message ?? 'Something went wrong!',
      );
    }
  }
}
