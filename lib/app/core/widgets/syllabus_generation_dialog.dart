import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

class SyllabusGenerationDialog extends StatefulWidget {
  final List<String> initialProjectDescription;
  final void Function(String projectDescription, String level) onGenerate;
  final int creditCost;
  final List<String> levels;
  final String defaultLevel;

  const SyllabusGenerationDialog({
    super.key,
    required this.initialProjectDescription,
    required this.onGenerate,
    this.creditCost = 20,
    this.levels = const ["Intermediate", "High"],
    this.defaultLevel = "Intermediate",
  });

  static Future<void> show(
    BuildContext context, {
    required List<String> initialProjectDescription,
    required void Function(String projectDescription, String level) onGenerate,
    int creditCost = 20,
    List<String> levels = const ["Intermediate", "High"],
    String defaultLevel = "Intermediate",
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => SyllabusGenerationDialog(
        initialProjectDescription: initialProjectDescription,
        onGenerate: onGenerate,
        creditCost: creditCost,
        levels: levels,
        defaultLevel: defaultLevel,
      ),
    );
  }

  @override
  State<SyllabusGenerationDialog> createState() =>
      _SyllabusGenerationDialogState();
}

class _SyllabusGenerationDialogState extends State<SyllabusGenerationDialog> {
  late final TextEditingController _descController;
  late String _selectedLevel;

  static const int _maxLength = 500;

  @override
  void initState() {
    super.initState();
    // _descController = TextEditingController(
    //   text: widget.initialProjectDescription,
    // );
    final initialText = widget.initialProjectDescription.isNotEmpty
        ? widget.initialProjectDescription.join('\n')
        : '';

    _descController = TextEditingController(text: initialText);
    _selectedLevel = widget.levels.contains(widget.defaultLevel)
        ? widget.defaultLevel
        : widget.levels.first;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparentColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.recContainerColor2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Icon ────────────────────────────────────────────────
              Image.asset(AssetImages.syllabusAlertIcon, height: 100, width: 100),
              const SizedBox(height: 14),
              Text(
                "Project Description",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 18,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "You can edit this project description before generating syllabus:",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                  lineSpace: 1.4
                ),
              ),
              const SizedBox(height: 20),

              // ── Project description field ────────────────────────────
              Text(
                "Project Description",
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.statusBorder),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _descController,
                      maxLength: _maxLength,
                      maxLines: 4,
                      style: AppStyles.customTextStyle(
                        size: 13,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        counterText:
                            "", // hide default counter, we render our own
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    Text(
                      "${_descController.text.length}/$_maxLength",
                      style: AppStyles.customTextStyle(
                        size: 11,
                        color: AppColors.greyTextColor,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ── Difficulty dropdown ──────────────────────────────────
              Text(
                "Syllabus Difficulty Level:",
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.statusBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLevel,
                    isExpanded: true,
                    dropdownColor: AppColors.recContainerColor,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primaryColor,
                    ),
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w700,
                    ),
                    items: widget.levels
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedLevel = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // ── Generate button ──────────────────────────────────────
              CustomButtonWidget(
                buttonFunction: () {
                  final description = _descController.text.trim();
                  Navigator.of(context).pop();
                  widget.onGenerate(description, _selectedLevel);
                },
                buttonWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6,
                  children: [
                    Text(
                      "Generate Syllabus",
                      style: AppStyles.customTextStyle(
                        size: 16,
                        color: AppColors.blackColor,
                        weight: FontWeight.w500,
                        fontFamily: "Roboto",
                      ),
                    ),
                    Text(
                      "${widget.creditCost}",
                      style: AppStyles.customTextStyle(
                        size: 16,
                        color: AppColors.blackColor,
                        weight: FontWeight.w500,
                        fontFamily: "Roboto",
                      ),
                    ),
                    Image.asset(
                      AssetImages.creditsIconNew,
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
