import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/widgets/education_card.dart';
import 'package:internsharks/app/core/widgets/experience_card.dart';
import 'package:internsharks/app/core/widgets/item_card_widget.dart';
import 'package:internsharks/app/core/widgets/profile_avatar.dart';
import 'package:internsharks/app/core/widgets/profile_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
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

  final _dashCtrl = Get.find<DashboardController>();

  // Personal controllers
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

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
    _bioCtrl.text = '';
    _profileImageUrl = p.studProfile;

    _certifications = (p.studentCertificate ?? [])
        .map<Map<String, dynamic>>(
          (e) => {
            'name': e['name'] ?? '',
            'issuer': e['issuer'] ?? '',
            'date': e['date'] ?? '',
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
                (proj.description is List && proj.description.isNotEmpty)
                ? proj.description.first.toString()
                : proj.description?.toString() ?? '',
          },
        )
        .toList();

    _programmingSkills = p.studProgrammingLang?.isNotEmpty == true
        ? ProfileWidgets.parseSkills(p.studProgrammingLang!.first)
        : [];
    _toolsSkills = (p.toolsAndTechnologies ?? [])
        .map<String>((e) => e.toString())
        .toList();

    if (p.collegeData?.isNotEmpty == true) {
      final c = p.collegeData!.first;
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

    if (mounted) setState(() {});
  }

  Future<void> _pickImage(ImageSource source) async {
    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    final status = await permission.request();

    if (status.isGranted) {
      try {
        final picked = await ImagePicker().pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 800,
        );
        if (picked == null) return;
        final file = File(picked.path);
        if (await file.length() > 1_000_000) {
          AppFunctions.showToast(
            message: 'File too large (max 1 MB)',
            isError: true,
          );
        } else {
          setState(() => _pickedImage = file);
        }
      } catch (e) {
        AppFunctions.showToast(
          message: 'Could not open camera/gallery: $e',
          isError: true,
        );
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(
        source == ImageSource.camera ? 'Camera' : 'Photo Library',
      );
    } else {
      AppFunctions.showToast(message: 'Permission denied', isError: true);
    }




  }

  void _showPermissionDialog(String resource) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.fieldBgColor,
        title: Text(
          '$resource Permission Required',
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 16,
            weight: FontWeight.w600,
          ),
        ),
        content: Text(
          '$resource access is needed. Please enable it in your device Settings.',
          style: AppStyles.customTextStyle(
            color: AppColors.lightText,
            size: 13,
            weight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppStyles.customTextStyle(
                color: AppColors.lightText,
                size: 13,
                weight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text(
              'Open Settings',
              style: AppStyles.customTextStyle(
                color: AppColors.primaryColor,
                size: 13,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  // ── Save ─────────────────────────────────────────────────────────────────

  Future<void> _saveAll() async {
    setState(() => _isSaving = true);
    try {
      await registerController.updateStudentProfileData(
        updateData: _buildPayload(),
      );
      final code = registerController.getResponseCode();
      if (code == 200 || code == 201) {
        AppFunctions.showToast(message: 'Profile updated successfully!');
        await _loadProfile();
      } else {
        AppFunctions.showToast(
          message: 'Failed to update. Please try again.',
          isError: true,
        );
      }
    } catch (e) {
      AppFunctions.showToast(message: 'Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Map<String, dynamic> _buildPayload() => {
    'studname': _nameCtrl.text.trim(),
    'studemail': _emailCtrl.text.trim(),
    'studmobileno': _mobileCtrl.text.trim(),
    'linkedIn': _linkedinCtrl.text.trim(),
    'github': _websiteCtrl.text.trim(),
    'profile_summary': _bioCtrl.text.trim(),
    'studentcertificate': jsonEncode(_certifications),
    'experience': jsonEncode(
      _experiences
          .map(
            (e) => {
              'role': e['role'],
              'company': e['company'],
              'duration': e['duration'],
              'description': e['description'],
            },
          )
          .toList(),
    ),
    'projects': jsonEncode(
      _projects
          .map(
            (e) => {
              'title': e['title'],
              'description': [e['description']],
            },
          )
          .toList(),
    ),
    'studprogramminglang': jsonEncode(_programmingSkills),
    'tools_and_technologies': jsonEncode(_toolsSkills),
    'studentdegree': _collegeData?['degree'] ?? '',
    'studentfieldofstudy': _collegeData?['department'] ?? '',
    'studentcollegename': _collegeData?['institution'] ?? '',
    'studcollegestartyear': _collegeData?['start_year'] ?? '',
    'studhighschollname': _higherSecData?['institution'] ?? '',
    'studhighschoolpercentage': _higherSecData?['percentage'] ?? '',
    'studentsecondaryschoolname': _secondaryData?['institution'] ?? '',
    'studentsecondaryschoolpercentage': _secondaryData?['percentage'] ?? '',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.loginBgImage),
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
            onPressed: () => Get.back(),
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
            return const Center(
              child: CupertinoActivityIndicator(
                color: AppColors.secondaryColor,
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar ────────────────────────────────────────────────
                ProfileAvatar(
                  imageUrl: _profileImageUrl ?? '',
                  pickedFile: _pickedImage,
                  name: _nameCtrl.text,
                  collegeName:
                      profileController.profileDataModel.collegeName ?? '',
                  onTap: _showImageSourceSheet,
                ),
                const SizedBox(height: 20),

                // ── Personal Info ─────────────────────────────────────────
                ProfileWidgets.sectionHeader('📋', 'Personal Information'),
                _pfield(Icons.person_outline_sharp, _nameCtrl, 'Full Name'),
                const SizedBox(height: 12),
                _pfield(Icons.email_outlined, _emailCtrl, 'Email Address'),
                const SizedBox(height: 12),
                _pfield(
                  Icons.phone_outlined,
                  _mobileCtrl,
                  'Mobile Number',
                  isNum: true,
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
                  hintText: 'Passionate about building impactful products...',
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
                const SizedBox(height: 20),

                // ── Work Experience ───────────────────────────────────────
                ProfileWidgets.sectionHeader(
                  '💼',
                  'Work Experience',
                  onAdd: () => _expSheet(),
                ),
                if (_experiences.isNotEmpty)
                  ProfileWidgets.infoCard(
                    Column(
                      children: _experiences.asMap().entries.map((e) {
                        final exp = e.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ExperienceCard(
                              role: exp['role'] ?? '',
                              company: exp['company'] ?? '',
                              meta:
                                  '${exp['type'] ?? ''} | ${exp['duration'] ?? ''}',
                              onEdit: () => _expSheet(editIndex: e.key),
                              onDelete: () =>
                                  setState(() => _experiences.removeAt(e.key)),
                            ),
                            if (e.key < _experiences.length - 1)
                              const Divider(color: Colors.white12),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
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
                          onEdit: () => _eduSheet(type: 'College'),
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
                          onEdit: () => _eduSheet(type: 'Class XII'),
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
                          onEdit: () => _eduSheet(type: 'Class X'),
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
                            () => setState(() => _toolsSkills.removeAt(e.key)),
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
                const SizedBox(height: 28),

                // ── Save ──────────────────────────────────────────────────
                CustomButtonWidget(
                  buttonFunction: () {
                    _isSaving ? null : _saveAll();
                  },
                  buttonText: _isSaving ? 'Saving...' : 'Save Changes',
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  // helper for personal-info fields
  Widget _pfield(
    IconData icon,
    TextEditingController ctrl,
    String label, {
    bool isNum = false,
  }) => CustomTextField(
    isNumberKeyboard: isNum,
    isProfileFlow: true,
    prefixWidget: Icon(icon, color: AppColors.primaryColor, size: 23),
    controller: ctrl,
    labelText: label,
    onChanged: (_) {},
  );

  // ─── Bottom sheet openers ────────────────────────────────────────────────

  void _certSheet({int? editIndex}) {
    final nameCtrl = TextEditingController(
      text: editIndex != null ? _certifications[editIndex]['name'] : '',
    );
    final issuerCtrl = TextEditingController(
      text: editIndex != null ? _certifications[editIndex]['issuer'] : '',
    );

    ProfileWidgets.showBottomSheet(
      context: context,
      title: editIndex != null ? 'Edit Certification' : 'Add Certification',
      content: Column(
        spacing: 12,
        children: [
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: nameCtrl,
            labelText: 'Certificate Name',
            onChanged: (_) {},
          ),
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: issuerCtrl,
            labelText: 'Issuing Organization',
            onChanged: (_) {},
          ),
        ],
      ),
      onSave: () {
        if (nameCtrl.text.isEmpty) return;
        final data = {
          'name': nameCtrl.text.trim(),
          'issuer': issuerCtrl.text.trim(),
          'date': editIndex != null ? _certifications[editIndex]['date'] : '',
        };
        setState(
          () => editIndex != null
              ? _certifications[editIndex] = data
              : _certifications.add(data),
        );
        Get.back();
      },
    );
  }

  void _expSheet({int? editIndex}) {
    final roleCtrl = TextEditingController(
      text: editIndex != null ? _experiences[editIndex]['role'] : '',
    );
    final companyCtrl = TextEditingController(
      text: editIndex != null ? _experiences[editIndex]['company'] : '',
    );
    final durationCtrl = TextEditingController(
      text: editIndex != null ? _experiences[editIndex]['duration'] : '',
    );
    final descCtrl = TextEditingController(
      text: editIndex != null ? _experiences[editIndex]['description'] : '',
    );
    String empType = editIndex != null
        ? (_experiences[editIndex]['type'] ?? 'Full Time')
        : 'Full Time';

    ProfileWidgets.showBottomSheet(
      context: context,
      title: editIndex != null ? 'Edit Work Experience' : 'Add Work Experience',
      content: StatefulBuilder(
        builder: (ctx, setS) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            CustomTextField(
              isNumberKeyboard: false,
              isProfileFlow: true,
              controller: roleCtrl,
              labelText: 'Role / Position',
              onChanged: (_) {},
            ),
            CustomTextField(
              isNumberKeyboard: false,
              isProfileFlow: true,
              controller: companyCtrl,
              labelText: 'Company',
              onChanged: (_) {},
            ),
            CustomTextField(
              isNumberKeyboard: false,
              isProfileFlow: true,
              controller: durationCtrl,
              labelText: 'Duration (e.g. June 2024 - Present)',
              onChanged: (_) {},
            ),
            Text(
              'Employment Type',
              style: AppStyles.customTextStyle(
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            Row(
              children: ['Full Time', 'Part Time']
                  .map(
                    (t) => Row(
                      children: [
                        Radio<String>(
                          value: t,
                          groupValue: empType,
                          activeColor: AppColors.primaryColor,
                          onChanged: (v) => setS(() => empType = v!),
                        ),
                        Text(
                          t,
                          style: AppStyles.customTextStyle(
                            fontFamily: 'Roboto',
                            color: AppColors.whiteColor,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  )
                  .toList(),
            ),
            CustomTextField(
              isNumberKeyboard: false,
              isProfileFlow: true,
              controller: descCtrl,
              labelText: 'Description',
              maxLines: 3,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
      onSave: () {
        if (roleCtrl.text.isEmpty) return;
        final data = {
          'role': roleCtrl.text.trim(),
          'company': companyCtrl.text.trim(),
          'duration': durationCtrl.text.trim(),
          'type': empType,
          'description': descCtrl.text.trim(),
        };
        setState(
          () => editIndex != null
              ? _experiences[editIndex] = data
              : _experiences.add(data),
        );
        Get.back();
      },
    );
  }

  void _eduSheet({String type = 'College'}) {
    Map<String, dynamic>? existing;
    if (type == 'College') existing = _collegeData;
    if (type == 'Class XII') existing = _higherSecData;
    if (type == 'Class X') existing = _secondaryData;

    String selectedType = type;
    String courseType = 'Full time';
    String? startYear = existing?['start_year'];
    String? endYear = existing?['end_year'];

    final uniCtrl = TextEditingController(text: existing?['institution'] ?? '');
    final courseCtrl = TextEditingController(text: existing?['degree'] ?? '');
    final specCtrl = TextEditingController(text: existing?['department'] ?? '');
    final gradeCtrl = TextEditingController(
      text: existing?['percentage'] ?? '',
    );
    final years = List.generate(30, (i) => (2000 + i).toString());

    ProfileWidgets.showBottomSheet(
      context: context,
      title: existing != null ? 'Edit Education' : 'Add Education',
      content: StatefulBuilder(
        builder: (ctx, setS) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(
              'Education *',
              style: AppStyles.customTextStyle(
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            ProfileWidgets.bsDropdown(
              value: selectedType,
              items: ['College', 'Class XII', 'Class X'],
              onChanged: (v) => setS(() => selectedType = v!),
            ),
            CustomTextField(
              isNumberKeyboard: false,
              isProfileFlow: true,
              controller: uniCtrl,
              labelText: 'University / School *',
              onChanged: (_) {},
            ),
            CustomTextField(
              isNumberKeyboard: false,
              isProfileFlow: true,
              controller: courseCtrl,
              labelText: 'Course *',
              onChanged: (_) {},
            ),
            CustomTextField(
              isNumberKeyboard: false,
              isProfileFlow: true,
              controller: specCtrl,
              labelText: 'Specialization',
              onChanged: (_) {},
            ),
            Text(
              'Course type',
              style: AppStyles.customTextStyle(
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            Row(
              children: ['Full time', 'Part time']
                  .map(
                    (t) => Row(
                      children: [
                        Radio<String>(
                          value: t,
                          groupValue: courseType,
                          activeColor: AppColors.primaryColor,
                          onChanged: (v) => setS(() => courseType = v!),
                        ),
                        Text(
                          t,
                          style: AppStyles.customTextStyle(
                            fontFamily: 'Roboto',
                            color: AppColors.whiteColor,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  )
                  .toList(),
            ),
            Text(
              'Course duration *',
              style: AppStyles.customTextStyle(
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: ProfileWidgets.bsDropdown(
                    value: startYear,
                    hint: 'Starting year',
                    items: years,
                    onChanged: (v) => setS(() => startYear = v),
                  ),
                ),
                Text(
                  'To',
                  style: AppStyles.customTextStyle(
                    color: AppColors.whiteColor,
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: ProfileWidgets.bsDropdown(
                    value: endYear,
                    hint: 'Ending year',
                    items: years,
                    onChanged: (v) => setS(() => endYear = v),
                  ),
                ),
              ],
            ),
            CustomTextField(
              isNumberKeyboard: false,
              isProfileFlow: true,
              controller: gradeCtrl,
              labelText: 'Grade / Percentage',
              onChanged: (_) {},
            ),
          ],
        ),
      ),
      onSave: () {
        final data = {
          'institution': uniCtrl.text.trim(),
          'degree': courseCtrl.text.trim(),
          'department': specCtrl.text.trim(),
          'percentage': gradeCtrl.text.trim(),
          'start_year': startYear ?? '',
          'end_year': endYear ?? '',
          'year': endYear ?? '',
          'board': specCtrl.text.trim(),
        };
        setState(() {
          if (selectedType == 'College') _collegeData = data;
          if (selectedType == 'Class XII') _higherSecData = data;
          if (selectedType == 'Class X') _secondaryData = data;
        });
        Get.back();
      },
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
    final titleCtrl = TextEditingController(
      text: editIndex != null ? _projects[editIndex]['title'] : '',
    );
    final descCtrl = TextEditingController(
      text: editIndex != null ? _projects[editIndex]['description'] : '',
    );

    ProfileWidgets.showBottomSheet(
      context: context,
      title: editIndex != null ? 'Edit Project' : 'Add Project',
      content: Column(
        spacing: 12,
        children: [
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: titleCtrl,
            labelText: 'Project Title',
            onChanged: (_) {},
          ),
          CustomTextField(
            isNumberKeyboard: false,
            isProfileFlow: true,
            controller: descCtrl,
            labelText: 'Description',
            maxLines: 4,
            onChanged: (_) {},
          ),
        ],
      ),
      onSave: () {
        if (titleCtrl.text.isEmpty) return;
        final data = {
          'title': titleCtrl.text.trim(),
          'description': descCtrl.text.trim(),
        };
        setState(
          () => editIndex != null
              ? _projects[editIndex] = data
              : _projects.add(data),
        );
        Get.back();
      },
    );
  }
}
