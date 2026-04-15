import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/home/filter_option_model.dart';
import 'filter_chip_widget.dart';
import 'filter_dropdown_widget.dart';

class FilterBottomSheet extends StatefulWidget {
  final FilterOptionModel filterOptionModel;

  final String initialState;
  final String initialCity;
  final String initialQualification;
  final String initialDuration;
  final String initialStipend;
  final String initialMode;
  final String initialRole;

  /// Called when user taps "Apply Filter"
  final void Function({
    required String companyState,
    required String companyCity,
    required String qualification,
    required String duration,
    required String stipend,
    required String internshipMode,
    // required String initialRole
  })
  onApply;

  const FilterBottomSheet({
    super.key,
    required this.filterOptionModel,
    required this.onApply,
    this.initialState = '',
    this.initialCity = '',
    this.initialQualification = '',
    this.initialDuration = '',
    this.initialStipend = '',
    this.initialMode = '',
    this.initialRole = "",
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // ── local state ──────────────────────────────────────────────────────────────
  String? _selectedState;
  String? _selectedCity;
  String? _selectedQualification;
  double _durationValue = 0;
  String? _selectedStipend;
  String? _selectedMode;
  String? _selectedRole;

  List<String> get _states =>
      (widget.filterOptionModel.filters?.companyState ?? [])
          .where((s) => s.isNotEmpty)
          .toList();

  List<String> get _cities =>
      (widget.filterOptionModel.filters?.companyCity ?? [])
          .where((s) => s.isNotEmpty)
          .toList();

  List<String> get _qualifications =>
      (widget.filterOptionModel.filters?.studentQualification ?? [])
          .where((s) => s.isNotEmpty)
          .toList();

  List<String> get _roleType =>
      (widget.filterOptionModel.filters?.roleType ?? [])
          .where((s) => s.isNotEmpty)
          .toList();

  static const _stipendOptions = ['Paid', 'Unpaid'];

  static const _modeOptions = ['Remote', 'On-Site', "Hybrid"];

  // ── helpers ──────────────────────────────────────────────────────────────────

  bool get _isAnyFilterActive =>
      _selectedState != null ||
      _selectedCity != null ||
      _selectedQualification != null ||
      _durationValue > 0 ||
      _selectedStipend != null ||
      _selectedMode != null ||
      _selectedRole != null;

  String _stipendApiValue(String? label) {
    return label != null
        ? label == 'Paid'
              ? '1'
              : '0'
        : "";
  }

  void _clearAll() {
    setState(() {
      _selectedState = null;
      _selectedCity = null;
      _selectedQualification = null;
      _durationValue = 0;
      _selectedStipend = null;
      _selectedMode = null;
      _selectedRole = null;
    });
  }

  void _apply() {
    widget.onApply(
      companyState: _selectedState ?? '',
      companyCity: _selectedCity ?? '',
      qualification: _selectedQualification ?? '',
      duration: _durationValue > 0 ? _durationValue.toInt().toString() : '',
      stipend: _stipendApiValue(_selectedStipend),
      internshipMode: _selectedMode ?? '',
    );
    Get.back();
  }

  // ── init ────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _selectedState = widget.initialState.isEmpty ? null : widget.initialState;
    _selectedCity = widget.initialCity.isEmpty ? null : widget.initialCity;
    _selectedQualification = widget.initialQualification.isEmpty
        ? null
        : widget.initialQualification;
    _durationValue = double.tryParse(widget.initialDuration) ?? 0;
    // Map API stipend back to label
    if (widget.initialStipend == '1') {
      _selectedStipend = 'Paid';
    } else if (widget.initialStipend == '0') {
      _selectedStipend = 'Unpaid';
    }
    _selectedMode = widget.initialMode.isEmpty ? null : widget.initialMode;
    _selectedRole = widget.initialRole.isEmpty ? null : widget.initialRole;
  }

  // ── build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appBgColor_2,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(),
          Divider(color: AppColors.contBorderColor, height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Company State
                  FilterDropdownWidget(
                    label: 'Company State',
                    hint: 'Select state',
                    options: _states,
                    selected: _selectedState,
                    onChanged: (v) => setState(() => _selectedState = v),
                  ),

                  // 2. Company City
                  FilterDropdownWidget(
                    label: 'Company City',
                    hint: 'Select city',
                    options: _cities,
                    selected: _selectedCity,
                    onChanged: (v) => setState(() => _selectedCity = v),
                  ),

                  // 3. Student Qualification
                  FilterChipWidget(
                    label: 'Student Qualification',
                    options: _qualifications,
                    selected: _selectedQualification,
                    onSelected: (v) =>
                        setState(() => _selectedQualification = v),
                  ),
                  // FilterDropdownWidget(
                  //   label: 'Role Type',
                  //   hint: 'Select role',
                  //   options: _roleType,
                  //   selected: _selectedRole,
                  //   onChanged: (v) => setState(() => _selectedRole = v),
                  // ),

                  // 4. Internship Duration  (0–12 months slider)
                  _buildDurationSlider(),

                  // 5. Stipend
                  FilterChipWidget(
                    label: 'Stipend',
                    options: _stipendOptions,
                    selected: _selectedStipend,
                    onSelected: (v) => setState(() => _selectedStipend = v),
                  ),

                  // 6. Internship Mode
                  FilterChipWidget(
                    label: 'Internship Mode',
                    options: _modeOptions,
                    selected: _selectedMode,
                    onSelected: (v) => setState(() => _selectedMode = v),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),

          // ── Action buttons ──────────────────────────────────────────────────
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.contBorderColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
      child: Row(
        children: [
          Text(
            'Filter Internships',
            style: AppStyles.customTextStyle(
              size: 16,
              color: AppColors.whiteColor,
              weight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          // Clear All button
          TextButton(
            onPressed: _isAnyFilterActive ? _clearAll : null,
            child: Text(
              'Clear All',
              style: AppStyles.customTextStyle(
                size: 12,
                color: _isAnyFilterActive
                    ? AppColors.primaryColor
                    : AppColors.fieldBorderColor,
                weight: FontWeight.w500,
              ),
            ),
          ),
          // Close button
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.failTextColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Internship Duration',
              style: AppStyles.customTextStyle(
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                // color: _durationValue > 0
                //     ? AppColors.secondaryColor.withOpacity(0.2)
                //     : AppColors.lightWhiteCont,
                color: AppColors.fieldBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  // color: _durationValue > 0
                  //     ? AppColors.primaryColor
                  //     :AppColors.lightWhiteCont,
                  color: AppColors.primaryColor,
                ),
              ),
              child: Text(
                _durationValue > 0
                    ? 'Up to ${_durationValue.toInt()} month${_durationValue > 1 ? "s" : ""}'
                    : 'Any',
                style: AppStyles.customTextStyle(
                  size: 10,
                  // color: _durationValue > 0
                  //     ? AppColors.secondaryColor
                  //     : AppColors.lightHintText,
                  color: AppColors.primaryColor,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primaryColor,
            inactiveTrackColor: AppColors.lightWhiteCont,
            thumbColor: AppColors.primaryColor,
            overlayColor: AppColors.primaryColor.withOpacity(0.15),
            trackHeight: 4,
            valueIndicatorColor: AppColors.primaryColor,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: _durationValue,
            min: 0,
            max: 12,
            divisions: 12,
            label: _durationValue > 0 ? '${_durationValue.toInt()} mo' : 'Any',
            onChanged: (v) => setState(() => _durationValue = v),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0',
              style: AppStyles.customTextStyle(
                size: 11,
                color: AppColors.whiteColor,
                weight: FontWeight.w400,
              ),
            ),
            Text(
              '12 months',
              style: AppStyles.customTextStyle(
                size: 11,
                color: AppColors.whiteColor,
                weight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomButtonWidget(
          height: 40,
          disable: !_isAnyFilterActive,
          buttonFunction: () => _isAnyFilterActive ? _apply() : null,
          buttonText: 'Apply Filter',
        ),
      ),
    );
  }
}
