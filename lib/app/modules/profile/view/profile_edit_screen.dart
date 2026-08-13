import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:http/http.dart' hide MultipartFile;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/widgets/custom_date_picker_widget.dart';
import 'package:internsharks/app/core/widgets/education_card.dart';
import 'package:internsharks/app/core/widgets/item_card_widget.dart';
import 'package:internsharks/app/core/widgets/profile_avatar.dart';
import 'package:internsharks/app/core/widgets/profile_widgets.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final profileController = Get.find<ProfileController>();
  final registerController = Get.find<RegisterController>();

  // Personal controllers
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String? selectedDobForApi; // yyyy-MM-dd

  // State
  String? _studentId;
  String? _profileImageUrl;
  File? _pickedImage;
  bool _isSaving = false;

  // Section data
  List<Map<String, dynamic>> _certifications = [];
  List<Map<String, dynamic>> _experiences = [];
  List<Map<String, dynamic>> _projects = [];
  List<String> _programmingSkills = [];
  List<String> _toolsSkills = [];

  Map<String, dynamic>? _collegeData;
  Map<String, dynamic>? _higherSecData;
  Map<String, dynamic>? _secondaryData;
  List<String> _languagesKnown = [];
  List<String> _hobbies = [];
  List<String> _areasOfInterest = [];
  List<String> _achievements = [];
  List<String> _volunteerExperience = [];
  List<String> _leadership = [];
  List<String> _publications = [];
  List<String> _workshops = [];
  List<Map<String, dynamic>> _industrialVisits = [];
  List<Map<String, dynamic>> _paperPresentations = [];
  List<Map<String, dynamic>> _internships = [];

  String _initialProfileSnapshot = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _mobileCtrl,
      _emailCtrl,
      _linkedinCtrl,
      _websiteCtrl,
      _bioCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Load ─────────────────────────────────────────────────────────────────

  Future<void> _loadProfile() async {
    _studentId = await LocalStorageService.getStudentId();
    await profileController.getProfileData(studentId: _studentId ?? '');
    final code = profileController.getResponseCode();
    if (code == 200 || code == 201) _populate();
  }

  void _populate() {
    final p = profileController.profileDataModel;
    _nameCtrl.text = p.studentName ?? '';
    _emailCtrl.text = p.studEmail ?? '';
    _mobileCtrl.text = p.studMobileNo ?? '';
    _linkedinCtrl.text = p.linkedIn ?? '';
    _websiteCtrl.text = p.github ?? '';
    _bioCtrl.text = p.profileSummary ?? "";
    _profileImageUrl = p.studProfile;

    // _certifications = (p.studentCertificate ?? [])
    //     .map<Map<String, dynamic>>(
    //       (e) => {
    //         'name': e['name'] ?? '',
    //         'issuer': e['issuer'] ?? '',
    //         'date': e['date'] ?? '',
    //       },
    //     )
    //     .toList();

    _certifications = (p.studentCertificate ?? [])
        .map<Map<String, dynamic>>(
          (e) => {
            'name': e.name ?? '',
            'issuer': e.issuer ?? '',
            'date': e.date ?? '',
          },
        )
        .toList();

    _experiences = (p.experience ?? [])
        .map<Map<String, dynamic>>(
          (e) => {
            'role': e.role ?? '',
            'company': e.company ?? '',
            'duration': e.duration ?? '',
            'type': 'Full Time',
            'description': e.description ?? '',
          },
        )
        .toList();

    _projects = (p.projects ?? [])
        .map<Map<String, dynamic>>(
          (proj) => {
            'title': proj.title ?? '',
            'description':
                (proj.description is List && proj.description!.isNotEmpty)
                ? proj.description!.first.toString()
                : proj.description?.toString() ?? '',
          },
        )
        .toList();

    _programmingSkills = p.studProgrammingLang?.isNotEmpty == true
        ? p.studProgrammingLang!
        : [];
    _toolsSkills = (p.toolsAndTechnologies ?? [])
        .map<String>((e) => e.toString())
        .toList();

    if (p.college?.isNotEmpty == true) {
      final c = p.college!.first;
      _collegeData = {
        'degree': c.degree ?? '',
        'department': c.department ?? '',
        'institution': c.institution ?? '',
        'start_year': c.startYear ?? '',
        'end_year': c.endYear ?? '',
      };
    }
    if (p.higherSecondary?.isNotEmpty == true) {
      final h = p.higherSecondary!.first;
      _higherSecData = {
        'institution': h.institution ?? '',
        'board': h.board ?? '',
        'percentage': h.percentage ?? '',
        'year': h.yearOfPassing ?? '',
      };
    }
    if (p.secondary?.isNotEmpty == true) {
      final s = p.secondary!.first;
      _secondaryData = {
        'institution': s.institution ?? '',
        'board': s.board ?? '',
        'percentage': s.percentage ?? '',
        'year': s.yearOfPassing ?? '',
      };
    }

    _languagesKnown = (p.languagesKnown ?? []).cast<String>();
    _hobbies = (p.hobbies ?? []).cast<String>();
    _areasOfInterest = (p.areasOfInterest ?? []).cast<String>();
    _achievements = (p.achievements ?? []).cast<String>();
    _volunteerExperience = (p.volunteerExperience ?? []).cast<String>();
    _leadership = (p.leadership ?? []).cast<String>();
    _publications = (p.publications ?? []).cast<String>();
    _workshops = (p.workshops ?? []).cast<String>();
    _internships = (p.internships ?? [])
        .map<Map<String, dynamic>>(
          (e) => {
            'company': e.company ?? '',
            'duration': e.duration ?? '',
            'description': e.description ?? '',
          },
        )
        .toList();

    _industrialVisits = (p.industrialVisits ?? [])
        .map<Map<String, dynamic>>(
          (e) => {
            'company': e.company ?? '',
            'location': e.location ?? '',
            'date': e.date ?? '',
          },
        )
        .toList();

    _paperPresentations = (p.paperPresentations ?? [])
        .map<Map<String, dynamic>>(
          (e) => {
            'title': e.title ?? '',
            'event': e.event ?? '',
            'year': e.year ?? '',
            'description': e.description ?? '',
          },
        )
        .toList();
    locationController.text = p.location ?? "";

    // if ((p.studentDob ?? "").isNotEmpty) {
    //   final date = DateTime.parse(p.studentDob!);
    //
    //   dobController.text = DateFormat('dd/MM/yyyy').format(date);
    //
    //   selectedDobForApi = DateFormat('yyyy-MM-dd').format(date);
    // } else {
    //   dobController.clear();
    //   selectedDobForApi = null;
    // }

    // ── DOB parsing (handles "2002-02-21T00:00:00.000Z" format) ──
    final rawDob = p.studentDob ?? "";
    if (rawDob.isNotEmpty) {
      try {
        final date = DateTime.parse(rawDob).toLocal();
        dobController.text = DateFormat('dd/MM/yyyy').format(date);
        selectedDobForApi = DateFormat('yyyy-MM-dd').format(date);
      } catch (_) {
        dobController.clear();
        selectedDobForApi = null;
      }
    } else {
      dobController.clear();
      selectedDobForApi = null;
    }

    if (mounted) setState(() {});
  }

  // ── Save ─────────────────────────────────────────────────────────────────

  Future<void> _saveAll() async {
    setState(() => _isSaving = true);
    try {
      final payload = await _buildPayload();
      debugPrint(payload.toString(), wrapWidth: 1024);
      await registerController.updateStudentProfileData(updateData: payload);
      final code = registerController.getResponseCode();
      if (code == 200 || code == 201) {
        AppAlertUtils.showToast(message: 'Profile updated successfully!');
        await _loadProfile();
      } else {
        AppAlertUtils.showToast(
          message: 'Failed to update. Please try again.',
          isError: true,
        );
      }
    } catch (e) {
      AppAlertUtils.showToast(message: 'Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _handleBackPress();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.appBackgroundImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: AppColors.transparentColor,
          appBar: AppBar(
            backgroundColor: AppColors.transparentColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 25,
                color: AppColors.whiteColor,
              ),
              onPressed: _handleBackPress,
            ),
            title: Text(
              'Edit Profile',
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.secondaryColor,
                weight: FontWeight.w600,
              ),
            ),
          ),
          body: Obx(() {
            if (profileController.profileDataLoading) {
              return AppAlertUtils.customLoader();
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Avatar ────────────────────────────────────────────────
                    ProfileAvatar(
                      imageUrl: _profileImageUrl ?? '',
                      pickedFile: _pickedImage,
                      name: _nameCtrl.text,
                      collegeName:
                          profileController.profileDataModel.collegeLocation ?? '',
                      onTap: _showImageSourceSheet,
                    ),
                    const SizedBox(height: 20),

                    // ── Personal Info ─────────────────────────────────────────
                    ProfileWidgets.sectionHeader('📋', 'Personal Information'),
                    _pfield(
                      Icons.person_outline_sharp,
                      _nameCtrl,
                      'Full Name',
                      validator: AppFunctions.validateName,
                    ),
                    const SizedBox(height: 12),
                    _pfield(
                      Icons.email_outlined,
                      _emailCtrl,
                      'Email Address',
                      isEnable: false,
                      isProfileFlow: false,
                    ),
                    const SizedBox(height: 12),
                    _pfield(
                      Icons.phone_outlined,
                      _mobileCtrl,
                      'Mobile Number',
                      isNum: true,
                      isEnable: false,
                      isProfileFlow: false,
                    ),
                    const SizedBox(height: 12),

                    CustomDatePickerField(
                      labelText: "Date of Birth",
                      controller: dobController,
                      onTap: selectDob,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: locationController,
                      labelText: "Location",
                      hintText: "Enter Location",
                      isNumberKeyboard: false,
                    ),
                    const SizedBox(height: 12),
                    _pfield(
                      Icons.dataset_linked_outlined,
                      _linkedinCtrl,
                      'LinkedIn Profile',
                    ),
                    const SizedBox(height: 12),
                    _pfield(
                      Icons.language_outlined,
                      _websiteCtrl,
                      'Portfolio/Personal Website',
                    ),
                    const SizedBox(height: 20),

                    // ── Bio ───────────────────────────────────────────────────
                    ProfileWidgets.sectionHeader('📝', 'Professional Summary'),
                    CustomTextField(
                      isNumberKeyboard: false,
                      isProfileFlow: true,
                      prefixWidget: Icon(
                        Icons.person_outline_sharp,
                        color: AppColors.primaryColor,
                        size: 23,
                      ),
                      hintText:
                          'Passionate about building impactful products...',
                      controller: _bioCtrl,
                      labelText: 'Bio',
                      maxLines: 4,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 20),

                    // ── Certifications ────────────────────────────────────────
                    ProfileWidgets.sectionHeader(
                      '🏅',
                      'Certification',
                      onAdd: () => _certSheet(),
                    ),
                    ..._certifications.asMap().entries.map(
                      (e) => ItemCard(
                        title: e.value['name'] ?? '',
                        subtitle: e.value['issuer'] ?? '',
                        onEdit: () => _certSheet(editIndex: e.key),
                      ),
                    ),
                    //const SizedBox(height: 5),
                    //
                    // // ── Work Experience ───────────────────────────────────────
                    // ProfileWidgets.sectionHeader(
                    //   '💼',
                    //   'Work Experience',
                    //   onAdd: () => _expSheet(),
                    // ),
                    // if (_experiences.isNotEmpty)
                    //   ProfileWidgets.infoCard(
                    //     Column(
                    //       children: _experiences.asMap().entries.map((e) {
                    //         final exp = e.value;
                    //         return Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             ExperienceCard(
                    //               role: exp['role'] ?? '',
                    //               company: exp['company'] ?? '',
                    //               meta:
                    //                   '${exp['type'] ?? ''} | ${exp['duration'] ?? ''}',
                    //               onEdit: () => _expSheet(editIndex: e.key),
                    //               onDelete: () =>
                    //                   setState(() => _experiences.removeAt(e.key)),
                    //             ),
                    //             if (e.key < _experiences.length - 1)
                    //               const Divider(color: Colors.white12),
                    //           ],
                    //         );
                    //       }).toList(),
                    //     ),
                    //   ),
                    const SizedBox(height: 20),

                    // ── Education ─────────────────────────────────────────────
                    ProfileWidgets.sectionHeader(
                      '🏫',
                      'Education',
                      onAdd: () => _eduSheet(),
                    ),
                    ProfileWidgets.infoCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_collegeData != null) ...[
                            EducationCard(
                              level: 'College',
                              title:
                                  '${_collegeData!['degree']} - ${_collegeData!['department']}',
                              subtitle: _collegeData!['institution'] ?? '',
                              meta:
                                  '${_collegeData!['start_year']} - ${_collegeData!['end_year']}',
                              extra: 'Full Time',
                              onEdit: () => _eduSheet(),
                            ),
                            const Divider(color: Colors.white12),
                          ],
                          if (_higherSecData != null) ...[
                            EducationCard(
                              level: 'Class XII',
                              title: _higherSecData!['institution'] ?? '',
                              subtitle: _higherSecData!['board'] ?? '',
                              meta: _higherSecData!['year'] ?? '',
                              extra: '${_higherSecData!['percentage']}%',
                              onEdit: () => _eduSheet(),
                            ),
                            const Divider(color: Colors.white12),
                          ],
                          if (_secondaryData != null)
                            EducationCard(
                              level: 'Class X',
                              title: _secondaryData!['institution'] ?? '',
                              subtitle: _secondaryData!['board'] ?? '',
                              meta: _secondaryData!['year'] ?? '',
                              extra: '${_secondaryData!['percentage']}%',
                              onEdit: () => _eduSheet(),
                            ),
                          if (_collegeData == null &&
                              _higherSecData == null &&
                              _secondaryData == null)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  'No education added yet',
                                  style: AppStyles.customTextStyle(
                                    color: AppColors.lightText,
                                    size: 13,
                                    weight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Skills ────────────────────────────────────────────────
                    ProfileWidgets.sectionHeader(
                      '💡',
                      'Skills',
                      onAdd: () => _skillSheet(),
                      addLabel: '+ Add Skills',
                    ),
                    if (_programmingSkills.isNotEmpty) ...[
                      Text(
                        'Programming Skills',
                        style: AppStyles.customTextStyle(
                          color: AppColors.whiteColor,
                          size: 14,
                          weight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        children: _programmingSkills
                            .asMap()
                            .entries
                            .map(
                              (e) => ProfileWidgets.chip(
                                e.value,
                                () => setState(
                                  () => _programmingSkills.removeAt(e.key),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (_toolsSkills.isNotEmpty) ...[
                      Text(
                        'Tools Technologies',
                        style: AppStyles.customTextStyle(
                          color: AppColors.whiteColor,
                          size: 14,
                          weight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        children: _toolsSkills
                            .asMap()
                            .entries
                            .map(
                              (e) => ProfileWidgets.chip(
                                e.value,
                                () => setState(
                                  () => _toolsSkills.removeAt(e.key),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // ── Projects ──────────────────────────────────────────────
                    ProfileWidgets.sectionHeader(
                      '🚀',
                      'Projects',
                      onAdd: () => _projectSheet(),
                      addLabel: '+ Add Projects',
                    ),
                    ..._projects.asMap().entries.map(
                      (e) => ItemCard(
                        title: e.value['title'] ?? '',
                        subtitle: e.value['description'] ?? '',
                        onEdit: () => _projectSheet(editIndex: e.key),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ProfileWidgets.sectionHeader(
                      '💼',
                      'Internships',
                      onAdd: () => _internshipSheet(),
                    ),

                    ..._internships.asMap().entries.map(
                      (e) => ItemCard(
                        title: e.value['company'] ?? '',
                        subtitle: e.value['duration'] ?? '',
                        onEdit: () => _internshipSheet(editIndex: e.key),
                      ),
                    ),

                    const SizedBox(height: 20),
                    ProfileWidgets.sectionHeader(
                      '🏭',
                      'Industrial Visits',
                      onAdd: () => _industrialVisitSheet(),
                    ),

                    ..._industrialVisits.asMap().entries.map(
                      (e) => ItemCard(
                        title: e.value['company'] ?? '',
                        subtitle: '${e.value['location']} • ${e.value['date']}',
                        onEdit: () => _industrialVisitSheet(editIndex: e.key),
                      ),
                    ),

                    const SizedBox(height: 20),
                    ProfileWidgets.sectionHeader(
                      '📄',
                      'Paper Presentations',
                      onAdd: () => _paperPresentationSheet(),
                    ),

                    ..._paperPresentations.asMap().entries.map(
                      (e) => ItemCard(
                        title: e.value['title'] ?? '',
                        subtitle: '${e.value['event']} • ${e.value['year']}',
                        onEdit: () => _paperPresentationSheet(editIndex: e.key),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ProfileWidgets.sectionHeader(
                      '📘',
                      'Additional Information',
                      onAdd: () => _additionalInfoSheet(),
                    ),

                    ProfileWidgets.infoCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoWrap('Languages Known', _languagesKnown),
                          _buildInfoWrap('Hobbies', _hobbies),
                          _buildInfoWrap('Areas of Interest', _areasOfInterest),
                          _buildInfoWrap('Achievements', _achievements),
                          _buildInfoWrap(
                            'Volunteer Experience',
                            _volunteerExperience,
                          ),
                          _buildInfoWrap('Leadership', _leadership),
                          _buildInfoWrap('Publications', _publications),
                          _buildInfoWrap('Workshops', _workshops),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Save ──────────────────────────────────────────────────
                    CustomButtonWidget(
                      isLoading: registerController.updateProfileLoading,
                      buttonFunction: () {
                        if (_formKey.currentState!.validate()) {
                          _isSaving ? null : _saveAll();
                        }
                      },
                      buttonText: _isSaving ? 'Saving...' : 'Save Changes',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> selectDob() async {
    // Parse existing DOB from controller to use as initialDate
    DateTime initialDate = DateTime(2000);
    if (selectedDobForApi != null && selectedDobForApi!.isNotEmpty) {
      try {
        initialDate = DateTime.parse(selectedDobForApi!);
      } catch (_) {}
    } else if ((profileController.profileDataModel.studentDob ?? "").isNotEmpty) {
      try {
        initialDate = DateTime.parse(
          profileController.profileDataModel.studentDob!,
        );
      } catch (_) {}
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: "SELECT DATE OF BIRTH",
      cancelText: "CANCEL",
      confirmText: "CONFIRM",
      // ← This is the key fix: forces calendar view, hides the text input field
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.primaryColor,
              selectionColor: AppColors.whiteColor,
              selectionHandleColor: AppColors.secondaryColor,
            ),
            textTheme: TextTheme(
              labelMedium: AppStyles.customTextStyle(
                size: 12,
                color: AppColors.primaryColor,
                weight: FontWeight.w500,
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.fieldBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: const BorderSide(color: AppColors.fieldBorderColor),
              ),
            ),
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.blackColor,
              surface: AppColors.fieldBgColor,
              onSurface: AppColors.whiteColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                textStyle: AppStyles.customTextStyle(
                  size: 14,
                  weight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.fieldBgColor,
              headerBackgroundColor: AppColors.fieldBgColor,
              headerForegroundColor: AppColors.secondaryColor,
              dividerColor: AppColors.fieldBorderColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              todayBorder: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
              todayForegroundColor: WidgetStateProperty.all(
                AppColors.primaryColor,
              ),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.blackColor;
                }
                return AppColors.whiteColor;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryColor;
                }
                return Colors.transparent;
              }),
              yearForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.blackColor;
                }
                return AppColors.whiteColor;
              }),
              yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryColor;
                }
                return Colors.transparent;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      selectedDobForApi = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {});
    }
  }

  String _generateProfileSnapshot() {
    return jsonEncode({
      'name': _nameCtrl.text.trim(),
      'mobile': _mobileCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'linkedin': _linkedinCtrl.text.trim(),
      'website': _websiteCtrl.text.trim(),
      'bio': _bioCtrl.text.trim(),
      'pickedImage': _pickedImage?.path ?? '',
      'certifications': _certifications,
      'experiences': _experiences,
      'projects': _projects,
      'programmingSkills': _programmingSkills,
      'toolsSkills': _toolsSkills,
      'collegeData': _collegeData,
      'higherSecData': _higherSecData,
      'secondaryData': _secondaryData,
      'languagesKnown': _languagesKnown,
      'hobbies': _hobbies,
      'areasOfInterest': _areasOfInterest,
      'achievements': _achievements,
      'volunteerExperience': _volunteerExperience,
      'leadership': _leadership,
      'publications': _publications,
      'workshops': _workshops,
      'industrialVisits': _industrialVisits,
      'paperPresentations': _paperPresentations,
      'internships': _internships,
    });
  }

  bool _hasUnsavedChanges() {
    return _initialProfileSnapshot != _generateProfileSnapshot();
  }

  Future<void> _handleBackPress() async {
    if (!_hasUnsavedChanges()) {
      Get.back();
      return;
    }

    await AppAlertUtils.showAppAlert(
      context: context,
      title: 'Discard Changes?',
      content:
          'You have unsaved changes in your profile. If you go back now, all modified data will be lost.',
      confirmText: 'Discard',
      cancelText: 'Stay',
      isDestructive: true,
      onConfirm: () {
        Get.back();
      },
    );
  }

  // Profile Image Widgets

  Future<void> _pickImage(ImageSource source) async {
    // final permission = source == ImageSource.camera
    //     ? Permission.camera
    //     : Permission.photos;
    // final status = await permission.request();

    //if (status.isGranted) {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (picked == null) return;
      final file = File(picked.path);
      if (await file.length() > 1_000_000) {
        AppAlertUtils.showToast(
          message: 'File too large (max 1 MB)',
          isError: true,
        );
      } else {
        setState(() => _pickedImage = file);
      }
    } catch (e) {
      AppAlertUtils.showToast(
        message: 'Could not open camera/gallery: $e',
        isError: true,
      );
    }
    // } else if (status.isPermanentlyDenied) {
    //   _showPermissionDialog(
    //     source == ImageSource.camera ? 'Camera' : 'Photo Library',
    //   );
    //}
    // else {
    //   AppAlertUtils.showToast(message: 'Permission denied', isError: true);
    // }
  }

  // void _showPermissionDialog(String resource) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       backgroundColor: AppColors.fieldBgColor,
  //       title: Text(
  //         '$resource Permission Required',
  //         style: AppStyles.customTextStyle(
  //           color: AppColors.whiteColor,
  //           size: 16,
  //           weight: FontWeight.w600,
  //         ),
  //       ),
  //       content: Text(
  //         '$resource access is needed. Please enable it in your device Settings.',
  //         style: AppStyles.customTextStyle(
  //           color: AppColors.lightText,
  //           size: 13,
  //           weight: FontWeight.w400,
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: Text(
  //             'Cancel',
  //             style: AppStyles.customTextStyle(
  //               color: AppColors.lightText,
  //               size: 13,
  //               weight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Get.back();
  //             openAppSettings();
  //           },
  //           child: Text(
  //             'Open Settings',
  //             style: AppStyles.customTextStyle(
  //               color: AppColors.primaryColor,
  //               size: 13,
  //               weight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showImageSourceSheet() {
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
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.greyIcon,
                size: 20,
              ),
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
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_camera,
                color: AppColors.greyIcon,
                size: 20,
              ),
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
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<List<String>> convertToNestedList(List<String> values) {
    return values.map((e) => [e]).toList();
  }

  Future<Map<String, dynamic>> _buildPayload() async {
    dynamic multipartFile;
    if (_pickedImage != null) {
      multipartFile = await MultipartFile.fromFile(
        _pickedImage!.path,
        filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
    }
    final collegeArray = _collegeData != null
        ? [
            {
              'degree': _collegeData!['degree'] ?? '',
              'department': _collegeData!['department'] ?? '',
              'institution': _collegeData!['institution'] ?? '',
              'start_year': _collegeData!['start_year'] ?? '',
              'end_year': _collegeData!['end_year'] ?? '',
            },
          ]
        : [];
    final higherSecArray = _higherSecData != null
        ? [
            {
              'institution': _higherSecData!['institution'] ?? '',
              'board': _higherSecData!['board'] ?? '',
              'percentage': _higherSecData!['percentage'] ?? '',
              'year_of_passing': _higherSecData!['year'] ?? '',
            },
          ]
        : [];
    final secondaryArray = _secondaryData != null
        ? [
            {
              'institution': _secondaryData!['institution'] ?? '',
              'board': _secondaryData!['board'] ?? '',
              'percentage': _secondaryData!['percentage'] ?? '',
              'year_of_passing': _secondaryData!['year'] ?? '',
            },
          ]
        : [];
    final educationObject = {
      'school': {
        'higher_secondary': _higherSecData != null
            ? {
                'institution': _higherSecData!['institution'] ?? '',
                'board': _higherSecData!['board'] ?? '',
                'percentage': _higherSecData!['percentage'] ?? '',
                'year_of_passing': _higherSecData!['year'] ?? '',
              }
            : {},
        'secondary': _secondaryData != null
            ? {
                'institution': _secondaryData!['institution'] ?? '',
                'board': _secondaryData!['board'] ?? '',
                'percentage': _secondaryData!['percentage'] ?? '',
                'year_of_passing': _secondaryData!['year'] ?? '',
              }
            : {},
      },
      'college': collegeArray,
    };
    return {
      if (multipartFile != null) 'studprofile': multipartFile,
      'studname': _nameCtrl.text.trim(),
      'studemail': _emailCtrl.text.trim(),
      'studmobileno': _mobileCtrl.text.trim(),
      'linkedIn': _linkedinCtrl.text.trim(),
      'github': _websiteCtrl.text.trim(),
      "studdob": selectedDobForApi ?? "",
      "location": locationController.text.trim(),
      //'isVerified': false,
      //"role": "Software Developer",
      //"templateNumber": "1",
      'portfolio_website': _websiteCtrl.text.trim(),
      'profile_summary': _bioCtrl.text.trim(),
      'studentdegree': _collegeData?['degree'] ?? '',
      'studentfieldofstudy': _collegeData?['department'] ?? '',
      'studentcollegename': _collegeData?['institution'] ?? '',
      'studcollegestartyear': _collegeData?['start_year'] ?? '',
      'studcollegeendyear': _collegeData?['end_year'] ?? '',
      'studcollegelocation': '',
      'studhighschollname': _higherSecData?['institution'] ?? '',
      'studhighschoolpercentage': _higherSecData?['percentage'] ?? '',
      'studhighschoollocation': '',
      'studentsecondaryschoolname': _secondaryData?['institution'] ?? '',
      'studentsecondaryschoolpercentage': _secondaryData?['percentage'] ?? '',
      'studsecondaryschoollocation': '',
      'college': jsonEncode(collegeArray),
      'higher_secondary': jsonEncode(higherSecArray),
      'secondary': jsonEncode(secondaryArray),
      'education': jsonEncode(educationObject),
      'studprogramminglang': convertToNestedList(_programmingSkills),
      'tools_and_technologies': jsonEncode(_toolsSkills),
      'projects': jsonEncode(
        _projects
            .map(
              (e) => {
                'title': e['title'] ?? '',
                'description': [e['description'] ?? ''],
              },
            )
            .toList(),
      ),
      'experience': jsonEncode(
        _experiences
            .map(
              (e) => {
                'role': e['role'] ?? '',
                'company': e['company'] ?? '',
                'duration': e['duration'] ?? '',
                'description': e['description'] ?? '',
              },
            )
            .toList(),
      ),
      'studentcertificate': jsonEncode(_certifications),
      'internships': jsonEncode(_internships),
      'industrial_visits': jsonEncode(_industrialVisits),
      'paper_presentations': jsonEncode(_paperPresentations),
      'languages_known': jsonEncode(_languagesKnown),
      'hobbies': jsonEncode(_hobbies),
      'areas_of_interest': jsonEncode(_areasOfInterest),
      'volunteer_experience': jsonEncode(_volunteerExperience),
      'leadership': jsonEncode(_leadership),
      'achievements': jsonEncode(_achievements),
      'publications': jsonEncode(_publications),
      'workshops': jsonEncode(_workshops),
    };
  }

  Widget _buildInfoWrap(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        items.isEmpty
            ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.file_copy_outlined,
                      color: AppColors.secondaryColor,
                      size: 15,
                    ),
                    Text(
                      "No data found!",
                      style: AppStyles.customTextStyle(
                        size: 8,
                        weight: FontWeight.w300,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items
                    .asMap()
                    .entries
                    .map(
                      (e) => ProfileWidgets.chip(
                        e.value,
                        () => setState(() => items.removeAt(e.key)),
                      ),
                    )
                    .toList(),
              ),
        const SizedBox(height: 12),
      ],
    );
  }

  // helper for personal-info fields
  Widget _pfield(
    IconData icon,
    TextEditingController ctrl,
    String label, {
    bool isNum = false,
    bool isEnable = true,
    bool isProfileFlow = true,
    String? Function(String?)? validator,
  }) => CustomTextField(
    isEnabled: isEnable,
    isNumberKeyboard: isNum,
    isProfileFlow: isProfileFlow,
    prefixWidget: Icon(icon, color: AppColors.primaryColor, size: 23),
    controller: ctrl,
    labelText: label,
    validator: validator,
  );

  // ─── Bottom sheet openers ────────────────────────────────────────────────

  void _certSheet({int? editIndex}) {
    _showDynamicFormSheet(
      title: 'Certification',
      editIndex: editIndex,
      targetList: _certifications,
      fields: const [
        DynamicFieldConfig(key: 'name', label: 'Certificate Name'),
        DynamicFieldConfig(key: 'issuer', label: 'Issuing Organization'),
      ],
    );
  }

  // void _expSheet({int? editIndex}) {
  //   final roleCtrl = TextEditingController(
  //     text: editIndex != null ? _experiences[editIndex]['role'] : '',
  //   );
  //   final companyCtrl = TextEditingController(
  //     text: editIndex != null ? _experiences[editIndex]['company'] : '',
  //   );
  //   final durationCtrl = TextEditingController(
  //     text: editIndex != null ? _experiences[editIndex]['duration'] : '',
  //   );
  //   final descCtrl = TextEditingController(
  //     text: editIndex != null ? _experiences[editIndex]['description'] : '',
  //   );
  //   String empType = editIndex != null
  //       ? (_experiences[editIndex]['type'] ?? 'Full Time')
  //       : 'Full Time';
  //
  //   ProfileWidgets.showBottomSheet(
  //     context: context,
  //     title: editIndex != null ? 'Edit Work Experience' : 'Add Work Experience',
  //     content: StatefulBuilder(
  //       builder: (ctx, setS) => Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         spacing: 12,
  //         children: [
  //           CustomTextField(
  //             isNumberKeyboard: false,
  //             isProfileFlow: true,
  //             controller: roleCtrl,
  //             labelText: 'Role / Position',
  //             onChanged: (_) {},
  //           ),
  //           CustomTextField(
  //             isNumberKeyboard: false,
  //             isProfileFlow: true,
  //             controller: companyCtrl,
  //             labelText: 'Company',
  //             onChanged: (_) {},
  //           ),
  //           CustomTextField(
  //             isNumberKeyboard: false,
  //             isProfileFlow: true,
  //             controller: durationCtrl,
  //             labelText: 'Duration (e.g. June 2024 - Present)',
  //             onChanged: (_) {},
  //           ),
  //           Text(
  //             'Employment Type',
  //             style: AppStyles.customTextStyle(
  //               color: AppColors.whiteColor,
  //               size: 14,
  //               weight: FontWeight.w500,
  //             ),
  //           ),
  //           Row(
  //             children: ['Full Time', 'Part Time']
  //                 .map(
  //                   (t) => Row(
  //                     children: [
  //                       Radio<String>(
  //                         value: t,
  //                         groupValue: empType,
  //                         activeColor: AppColors.primaryColor,
  //                         onChanged: (v) => setS(() => empType = v!),
  //                       ),
  //                       Text(
  //                         t,
  //                         style: AppStyles.customTextStyle(
  //                           fontFamily: 'Roboto',
  //                           color: AppColors.whiteColor,
  //                           size: 14,
  //                           weight: FontWeight.w500,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 16),
  //                     ],
  //                   ),
  //                 )
  //                 .toList(),
  //           ),
  //           CustomTextField(
  //             isNumberKeyboard: false,
  //             isProfileFlow: true,
  //             controller: descCtrl,
  //             labelText: 'Description',
  //             maxLines: 3,
  //             onChanged: (_) {},
  //           ),
  //         ],
  //       ),
  //     ),
  //     onSave: () {
  //       if (roleCtrl.text.isEmpty) return;
  //       final data = {
  //         'role': roleCtrl.text.trim(),
  //         'company': companyCtrl.text.trim(),
  //         'duration': durationCtrl.text.trim(),
  //         'type': empType,
  //         'description': descCtrl.text.trim(),
  //       };
  //       setState(
  //         () => editIndex != null
  //             ? _experiences[editIndex] = data
  //             : _experiences.add(data),
  //       );
  //       Get.back();
  //     },
  //   );
  // }

  void _eduSheet() {
    final collegeInstitutionCtrl = TextEditingController(
      text: _collegeData?['institution'] ?? '',
    );
    final degreeCtrl = TextEditingController(
      text: _collegeData?['degree'] ?? '',
    );
    final departmentCtrl = TextEditingController(
      text: _collegeData?['department'] ?? '',
    );

    final higherInstitutionCtrl = TextEditingController(
      text: _higherSecData?['institution'] ?? '',
    );
    final higherBoardCtrl = TextEditingController(
      text: _higherSecData?['board'] ?? '',
    );
    final higherPercentageCtrl = TextEditingController(
      text: _higherSecData?['percentage'] ?? '',
    );

    final secondaryInstitutionCtrl = TextEditingController(
      text: _secondaryData?['institution'] ?? '',
    );
    final secondaryBoardCtrl = TextEditingController(
      text: _secondaryData?['board'] ?? '',
    );
    final secondaryPercentageCtrl = TextEditingController(
      text: _secondaryData?['percentage'] ?? '',
    );

    final years = List.generate(40, (index) => (2000 + index).toString());

    String? collegeStartYear = _collegeData?['start_year']?.toString();

    String? collegeEndYear = _collegeData?['end_year']?.toString();

    String? higherYear = _higherSecData?['year']?.toString();

    String? secondaryYear = _secondaryData?['year']?.toString();

    ProfileWidgets.showBottomSheet(
      context: context,
      title: 'Edit Education',
      content: StatefulBuilder(
        builder: (context, setS) {
          return Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// COLLEGE
              _sectionTitle(icon: "🎓", title: "College Education"),
              const SizedBox(height: 5),
              CustomTextField(
                isProfileFlow: true,
                controller: collegeInstitutionCtrl,
                labelText: 'Institution',
                onChanged: (_) {},
              ),
              CustomTextField(
                isProfileFlow: true,
                controller: degreeCtrl,
                isNumberKeyboard: false,
                labelText: 'Degree',
                onChanged: (_) {},
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: ProfileWidgets.bsDropdown(
                      value: collegeStartYear,
                      hint: 'Start Year',
                      items: years,
                      onChanged: (v) {
                        setS(() {
                          collegeStartYear = v;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ProfileWidgets.bsDropdown(
                      value: collegeEndYear,
                      hint: 'End Year',
                      items: years,
                      onChanged: (v) {
                        setS(() {
                          collegeEndYear = v;
                        });
                      },
                    ),
                  ),
                ],
              ),
              CustomTextField(
                isProfileFlow: true,
                isNumberKeyboard: false,
                controller: departmentCtrl,
                labelText: 'Department',
                onChanged: (_) {},
              ),

              const SizedBox(height: 10),

              /// HSC
              _sectionTitle(icon: "📚", title: "Higher Secondary (12th)"),

              const SizedBox(height: 5),

              CustomTextField(
                isProfileFlow: true,
                controller: higherInstitutionCtrl,
                labelText: 'Institution',
                onChanged: (_) {},
                isNumberKeyboard: false,
              ),
              CustomTextField(
                isProfileFlow: true,
                controller: higherBoardCtrl,
                labelText: 'Board',
                isNumberKeyboard: false,

                onChanged: (_) {},
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomTextField(
                      isProfileFlow: true,
                      controller: higherPercentageCtrl,
                      labelText: 'Percentage / CGPA',
                      onChanged: (_) {},
                      isNumberKeyboard: false,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ProfileWidgets.bsDropdown(
                        value: higherYear,
                        hint: 'Year of Passing',
                        items: years,
                        onChanged: (v) {
                          setS(() {
                            higherYear = v;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// SSLC
              _sectionTitle(icon: "📗", title: "Secondary School (10th)"),

              const SizedBox(height: 5),

              CustomTextField(
                isProfileFlow: true,
                controller: secondaryInstitutionCtrl,
                labelText: 'Institution',
                onChanged: (_) {},
                isNumberKeyboard: false,
              ),
              CustomTextField(
                isProfileFlow: true,
                controller: secondaryBoardCtrl,
                labelText: 'Board',
                isNumberKeyboard: false,

                onChanged: (_) {},
              ),

              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomTextField(
                      isProfileFlow: true,
                      controller: secondaryPercentageCtrl,
                      labelText: 'Percentage / CGPA',
                      onChanged: (_) {},
                      isNumberKeyboard: false,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ProfileWidgets.bsDropdown(
                        value: secondaryYear,
                        hint: 'Year of Passing',
                        items: years,
                        onChanged: (v) {
                          setS(() {
                            secondaryYear = v;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),

      onSave: () {
        setState(() {
          _collegeData = {
            'institution': collegeInstitutionCtrl.text.trim(),
            'degree': degreeCtrl.text.trim(),
            'department': departmentCtrl.text.trim(),
            'start_year': collegeStartYear ?? '',
            'end_year': collegeEndYear ?? '',
          };

          _higherSecData = {
            'institution': higherInstitutionCtrl.text.trim(),
            'board': higherBoardCtrl.text.trim(),
            'percentage': higherPercentageCtrl.text.trim(),
            'year': higherYear ?? '',
          };

          _secondaryData = {
            'institution': secondaryInstitutionCtrl.text.trim(),
            'board': secondaryBoardCtrl.text.trim(),
            'percentage': secondaryPercentageCtrl.text.trim(),
            'year': secondaryYear ?? '',
          };
        });

        Get.back();
      },
    );
  }

  Widget _sectionTitle({required String icon, required String title}) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppStyles.customTextStyle(
            size: 15,
            color: AppColors.primaryColor,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _skillSheet() {
    final skillCtrl = TextEditingController();
    final toolCtrl = TextEditingController();

    ProfileWidgets.showBottomSheet(
      context: context,
      title: 'Add Skills',
      content: Column(
        spacing: 12,
        children: [
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: skillCtrl,
            labelText: 'Programming Skill (e.g. Flutter)',
            onChanged: (_) {},
          ),
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: toolCtrl,
            labelText: 'Tool / Technology (e.g. Docker)',
            onChanged: (_) {},
          ),
        ],
      ),
      onSave: () {
        setState(() {
          if (skillCtrl.text.isNotEmpty) {
            _programmingSkills.add(skillCtrl.text.trim());
          }
          if (toolCtrl.text.isNotEmpty) _toolsSkills.add(toolCtrl.text.trim());
        });
        Get.back();
      },
    );
  }

  void _projectSheet({int? editIndex}) {
    _showDynamicFormSheet(
      title: 'Project',
      editIndex: editIndex,
      targetList: _projects,
      fields: const [
        DynamicFieldConfig(key: 'title', label: 'Project Title'),
        DynamicFieldConfig(
          key: 'description',
          label: 'Description',
          maxLines: 4,
        ),
      ],
    );
  }

  void _internshipSheet({int? editIndex}) {
    _showDynamicFormSheet(
      title: 'Internship',
      editIndex: editIndex,
      targetList: _internships,
      fields: const [
        DynamicFieldConfig(key: 'company', label: 'Company'),
        DynamicFieldConfig(key: 'duration', label: 'Duration'),
        DynamicFieldConfig(
          key: 'description',
          label: 'Description',
          maxLines: 3,
        ),
      ],
    );
  }

  void _industrialVisitSheet({int? editIndex}) {
    _showDynamicFormSheet(
      title: 'Industrial Visit',
      editIndex: editIndex,
      targetList: _industrialVisits,
      fields: const [
        DynamicFieldConfig(key: 'company', label: 'Company'),
        DynamicFieldConfig(key: 'location', label: 'Location'),
        DynamicFieldConfig(key: 'date', label: 'Date'),
      ],
    );
  }

  void _paperPresentationSheet({int? editIndex}) {
    _showDynamicFormSheet(
      title: 'Paper Presentation',
      editIndex: editIndex,
      targetList: _paperPresentations,
      fields: const [
        DynamicFieldConfig(key: 'title', label: 'Title'),
        DynamicFieldConfig(key: 'event', label: 'Event'),
        DynamicFieldConfig(key: 'year', label: 'Year', isNumber: true),
        DynamicFieldConfig(
          key: 'description',
          label: 'Description',
          maxLines: 3,
        ),
      ],
    );
  }

  void _additionalInfoSheet() {
    final languageCtrl = TextEditingController();
    final hobbyCtrl = TextEditingController();
    final interestCtrl = TextEditingController();
    final achievementCtrl = TextEditingController();
    final volunteerCtrl = TextEditingController();
    final leadershipCtrl = TextEditingController();
    final publicationCtrl = TextEditingController();
    final workshopCtrl = TextEditingController();

    ProfileWidgets.showBottomSheet(
      context: context,
      title: 'Additional Information',
      content: Column(
        spacing: 12,
        children: [
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: languageCtrl,
            labelText: 'Languages Known',
            onChanged: (_) {},
          ),
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: hobbyCtrl,
            labelText: 'Hobbies',
            onChanged: (_) {},
          ),
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: interestCtrl,
            labelText: 'Areas of Interest',
            onChanged: (_) {},
          ),
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: achievementCtrl,
            labelText: 'Achievements',
            onChanged: (_) {},
          ),
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: volunteerCtrl,
            labelText: 'Volunteer Experience',
            onChanged: (_) {},
          ),
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: leadershipCtrl,
            labelText: 'Leadership',
            onChanged: (_) {},
          ),
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: publicationCtrl,
            labelText: 'Publications',
            onChanged: (_) {},
          ),
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: workshopCtrl,
            labelText: 'Workshops',
            onChanged: (_) {},
          ),
        ],
      ),
      onSave: () {
        setState(() {
          if (languageCtrl.text.isNotEmpty) {
            _languagesKnown.add(languageCtrl.text.trim());
          }
          if (hobbyCtrl.text.isNotEmpty) {
            _hobbies.add(hobbyCtrl.text.trim());
          }
          if (interestCtrl.text.isNotEmpty) {
            _areasOfInterest.add(interestCtrl.text.trim());
          }
          if (achievementCtrl.text.isNotEmpty) {
            _achievements.add(achievementCtrl.text.trim());
          }
          if (volunteerCtrl.text.isNotEmpty) {
            _volunteerExperience.add(volunteerCtrl.text.trim());
          }
          if (leadershipCtrl.text.isNotEmpty) {
            _leadership.add(leadershipCtrl.text.trim());
          }
          if (publicationCtrl.text.isNotEmpty) {
            _publications.add(publicationCtrl.text.trim());
          }
          if (workshopCtrl.text.isNotEmpty) {
            _workshops.add(workshopCtrl.text.trim());
          }
        });

        Get.back();
      },
    );
  }

  // NEW WIDGETS

  void _showDynamicFormSheet({
    required String title,
    required List<DynamicFieldConfig> fields,
    required List<Map<String, dynamic>> targetList,
    int? editIndex,
  }) {
    final controllers = <String, TextEditingController>{};

    for (final field in fields) {
      controllers[field.key] = TextEditingController(
        text: editIndex != null
            ? targetList[editIndex][field.key]?.toString() ?? ''
            : '',
      );
    }

    ProfileWidgets.showBottomSheet(
      context: context,
      title: editIndex != null ? 'Edit $title' : 'Add $title',
      content: Column(
        spacing: 12,
        children: fields.map((field) {
          return CustomTextField(
            isNumberKeyboard: field.isNumber,
            isProfileFlow: true,
            controller: controllers[field.key]!,
            labelText: field.label,
            maxLines: field.maxLines,
            onChanged: (_) {},
          );
        }).toList(),
      ),
      onSave: () {
        final data = <String, dynamic>{};

        for (final field in fields) {
          data[field.key] = controllers[field.key]!.text.trim();
        }

        setState(() {
          if (editIndex != null) {
            targetList[editIndex] = data;
          } else {
            targetList.add(data);
          }
        });

        Get.back();
      },
    );
  }
}

class DynamicFieldConfig {
  final String key;
  final String label;
  final bool isNumber;
  final int maxLines;

  const DynamicFieldConfig({
    required this.key,
    required this.label,
    this.isNumber = false,
    this.maxLines = 1,
  });
}
