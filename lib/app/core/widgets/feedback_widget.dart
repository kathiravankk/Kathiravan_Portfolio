import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class FeedbackWidget extends StatefulWidget {
  final Function(int rating, String feedback) onSubmit;
  final bool isLoading;

  const FeedbackWidget({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget>
    with SingleTickerProviderStateMixin {
  int rating = 0;

  final TextEditingController feedbackController = TextEditingController();

  /// ✅ NEW
  bool isSubmitted = false;

  void submitFeedback() async {
    /// ✅ Prevent multiple submit
    if (rating == 0 || isSubmitted || widget.isLoading) return;

    await widget.onSubmit(
      rating,
      feedbackController.text.trim(),
    );

    /// ✅ Disable widget after success
    if (mounted) {
      setState(() {
        isSubmitted = true;
      });
    }
  }

  Widget buildStar(int index) {
    bool isSelected = index < rating;

    return GestureDetector(
      /// ✅ Disable star selection
      onTap: isSubmitted
          ? null
          : () {
        setState(() {
          rating = index + 1;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: isSelected ? 1.1 : 1,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isSelected
                ? CupertinoIcons.star_fill
                : CupertinoIcons.star,
            key: ValueKey(isSelected),
            color: isSelected
                ? AppColors.secondaryColor
                : AppColors.greyIcon,
            size: 25,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          /// ✅ Disable all interactions
          ignoring: isSubmitted,
          child: Opacity(
            /// ✅ Slight faded UI after submit
            opacity: isSubmitted ? 0.6 : 1,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.contColor2,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.contBorderColor2,
                ),
              ),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    isSubmitted
                        ? "THANK YOU FOR YOUR FEEDBACK ❤️"
                        : "HOW WAS YOUR EXPERIENCE WITH THIS \n MOCK TEST?",
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w500,
                      lineSpace: 1.3,
                      color: AppColors.whiteColor,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: List.generate(5, buildStar),
                  ),

                  TextField(
                    enabled: !isSubmitted,
                    cursorColor: AppColors.primaryColor,
                    controller: feedbackController,
                    style: AppStyles.customTextStyle(
                      fontFamily: "Roboto",
                      color: AppColors.whiteColor,
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Your feedback about Internship",
                      hintStyle: AppStyles.customTextStyle(
                        fontFamily: "Roboto",
                        color: AppColors.greyColor,
                        size: 12,
                        weight: FontWeight.w200,
                      ),
                      fillColor: AppColors.contBorderColor2,
                      filled: true,
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: AppColors.fieldBorderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),

                      /// ✅ Hide send button after submit
                      suffixIcon: isSubmitted
                          ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                          : GestureDetector(
                        onTap: submitFeedback,
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Text(
                    isSubmitted
                        ? "Feedback submitted successfully!"
                        : "Your feedback helps us improve!",
                    style: AppStyles.customTextStyle(
                      size: 10,
                      color: AppColors.contLightText,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (widget.isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
