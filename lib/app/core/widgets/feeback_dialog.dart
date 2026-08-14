import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

class FeedbackDialog extends StatefulWidget {
  final Future<bool> Function({
    required int rating,
    required String review,
    required String feedbackType,
    String? referenceLink,
  })
  onSubmit;

  final bool isReadOnly;
  final int? initialRating;
  final String? initialReview;
  final String? initialFeedbackType;
  final String? initialReferenceLink;

  const FeedbackDialog({
    super.key,
    required this.onSubmit,
    this.isReadOnly = false,
    this.initialRating,
    this.initialReview,
    this.initialFeedbackType,
    this.initialReferenceLink,
  });

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final _formKey = GlobalKey<FormState>();

  int _selectedRating = 0;
  String? _selectedFeedbackType = "Other";
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  bool _isLoading = false;
  int _charCount = 0;

  final List<String> _feedbackOptions = [
    "Complaint",
    "Suggestion",
    "Feedback",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialRating != null) {
      _selectedRating = widget.initialRating!;
    }
    if (widget.initialFeedbackType != null &&
        _feedbackOptions.contains(widget.initialFeedbackType)) {
      _selectedFeedbackType = widget.initialFeedbackType;
    }
    if (widget.initialReview != null) {
      _reviewController.text = widget.initialReview!;
      _charCount = _reviewController.text.length;
    }
    if (widget.initialReferenceLink != null) {
      _linkController.text = widget.initialReferenceLink!;
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _selectedRating = 0;
      _selectedFeedbackType = "Other";
      _reviewController.clear();
      _linkController.clear();
      _charCount = 0;
    });
  }

  Future<void> _handleSubmit() async {
    if (_selectedRating == 0) {
      AppAlertUtils.showToast(
        message:
            "Rating Required! \n Please select a star rating before submitting.",
        isError: true,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final isSuccess = await widget.onSubmit(
        rating: _selectedRating,
        review: _reviewController.text.trim(),
        feedbackType: _selectedFeedbackType ?? "Other",
        referenceLink: _linkController.text.trim().isNotEmpty
            ? _linkController.text.trim()
            : null,
      );

      setState(() => _isLoading = false);

      if (isSuccess) {
        _resetForm();
        Get.back(); // Dismiss dialog
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.recContainerColor2,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Overall Rating
                _buildLabel("Overall Rating", isRequired: true),
                const SizedBox(height: 10),
                _buildStarRating(),
                const SizedBox(height: 20),

                // 2. Feedback Type Dropdown
                _buildLabel("Feedback Type", isRequired: true),
                const SizedBox(height: 10),
                _buildFeedbackTypeDropdown(),
                const SizedBox(height: 20),

                // 3. Comments / Details
                _buildLabel("Comments / Details", isRequired: true),
                const SizedBox(height: 10),
                _buildCommentsField(),
                const SizedBox(height: 20),

                // 4. Reference Link
                Row(
                  children: [
                     Text(
                      "Reference Link ",
                      style: AppStyles.customTextStyle(
                        color: AppColors.whiteColor,
                        size: 15,
                        weight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "(Optional)",
                      style: AppStyles.customTextStyle(
                        color: AppColors.primaryColor,
                        size: 12,
                        weight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildReferenceLinkField(),
                const SizedBox(height: 10),
                Text(
                  "Example: https://drive.google.com/...",
                  style: AppStyles.customTextStyle(
                    color: AppColors.lightHintText,
                    size: 12,
                    weight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 25),

                // 5. Submit / Close Button
                CustomButtonWidget(
                  buttonFunction: widget.isReadOnly ? () => Get.back() : _handleSubmit,
                  isLoading: _isLoading,
                  buttonWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Icon(
                        widget.isReadOnly
                            ? CupertinoIcons.check_mark_circled
                            : CupertinoIcons.location,
                        color: AppColors.blackColor,
                        size: 16,
                      ),
                      Text(
                        widget.isReadOnly ? "Close" : "Submit Feedback",
                        style: AppStyles.customTextStyle(
                          color: Colors.black,
                          size: 14,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: AppStyles.customTextStyle(color: AppColors.whiteColor,weight: FontWeight.w700, size: 15),
        children: isRequired
            ?  [
                TextSpan(
                  text: ' *',
                  style: AppStyles.customTextStyle(color: AppColors.primaryColor, size: 14),
                ),
              ]
            : [],
      ),
    );
  }

  // Animated Interactive Star Rating Component
  Widget _buildStarRating() {
    return Row(
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: widget.isReadOnly
              ? null
              : () {
                  setState(() {
                    _selectedRating = starIndex;
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            padding: const EdgeInsets.only(right: 12),
            transform: Matrix4.identity()
              ..scale(_selectedRating >= starIndex ? 1.15 : 1.0),
            child: Icon(
              _selectedRating >= starIndex
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: _selectedRating >= starIndex
                  ? AppColors.secondaryColor
                  : AppColors.secondaryColor.withValues(alpha: 0.6),
              size: 32,
            ),
          ),
        );
      }),
    );
  }

  // Dropdown Field
  Widget _buildFeedbackTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedFeedbackType,
      dropdownColor: const Color(0xFF1B1E2E),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      decoration: _inputDecoration(hintText: "Select feedback type"),
      items: _feedbackOptions.map((String type) {
        return DropdownMenuItem<String>(value: type, child: Text(type));
      }).toList(),
      onChanged: widget.isReadOnly
          ? null
          : (String? newValue) {
              setState(() {
                _selectedFeedbackType = newValue;
              });
            },
    );
  }

  // Comments / Details Multi-line Field
  Widget _buildCommentsField() {
    return Stack(
      children: [
        TextFormField(
          readOnly: widget.isReadOnly,
          controller: _reviewController,
          maxLines: 5,
          maxLength: 500,
          style: AppStyles.customTextStyle(color: AppColors.whiteColor,weight: FontWeight.w500, size: 14),
          onChanged: (text) => setState(() => _charCount = text.length),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter your review or feedback";
            }
            return null;
          },
          decoration:
              _inputDecoration(
                hintText: "Please provide your feedback...",
              ).copyWith(
                counterText: "",
                // Hide default counter text to place it inside custom stack
                contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
              ),
        ),
        Positioned(
          bottom: 10,
          right: 14,
          child: Text(
            "$_charCount / 500",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // Reference Link Text Field
  Widget _buildReferenceLinkField() {
    return TextFormField(
      readOnly: widget.isReadOnly,
      controller: _linkController,
      style: AppStyles.customTextStyle(color: AppColors.whiteColor,weight: FontWeight.w500, size: 14),
      decoration: _inputDecoration(
        hintText: "Enter reference link (URL)",
        prefixIcon:  Icon(CupertinoIcons.link, color: AppColors.primaryColor, size: 20),
      ),
    );
  }

  // Submit Button with Gradient & Loading State
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF67FDF3), Color(0xFF00E5FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            alignment: Alignment.center,
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_outlined, color: Colors.black, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Submit Feedback",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: const Color(0xFF141724),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }
}
