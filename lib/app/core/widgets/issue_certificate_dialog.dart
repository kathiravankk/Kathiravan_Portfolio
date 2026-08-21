import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart' show AppStyles;
import 'package:internsharks/app/core/utils/asset_images.dart';

import 'custom_button_widget.dart' show CustomButtonWidget;

class IssueCertificateDialog extends StatefulWidget {
  const IssueCertificateDialog({super.key, required this.onSubmit});

  final Function(int rating, String feedback) onSubmit;

  @override
  State<IssueCertificateDialog> createState() => _IssueCertificateDialogState();
}

class _IssueCertificateDialogState extends State<IssueCertificateDialog> {
  final TextEditingController _feedbackController = TextEditingController();

  int rating = 5;
  final int maxLength = 500;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.recContainerColor2,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Icon
              Image.asset(AssetImages.issueCertificateIcon, height: 90),

              const SizedBox(height: 16),

              Text(
                "Issue Certificate & Feedback",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 20,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Please provide a final assessment for the student before generating their internship certificate.",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.greyTextColor,
                  lineSpace: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              Divider(color: AppColors.statusBorder),

              const SizedBox(height: 18),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Student Performance Rating",
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.recContainerColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.statusBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: buildStar(index),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "($rating-Star Rating)",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Detailed Feedback / Achievement Description",
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.statusBorder),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _feedbackController,
                      maxLength: maxLength,
                      maxLines: 5,
                      style: AppStyles.customTextStyle(
                        size: 13,
                        color: AppColors.whiteColor,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: "Successfully completed all modules...",
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${_feedbackController.text.length}/$maxLength",
                        style: AppStyles.customTextStyle(
                          size: 11,
                          color: AppColors.greyTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              CustomButtonWidget(
                buttonFunction: () {
                  Navigator.pop(context);

                  widget.onSubmit(rating, _feedbackController.text.trim());
                },
                buttonText: "Issue Certificate",
                buttonWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Issue Certificate",
                      style: AppStyles.customTextStyle(
                        size: 15,
                        color: AppColors.blackColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "100",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.blackColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Image.asset(
                      AssetImages.creditsIconNew,
                      height: 22,
                      width: 22,
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

  Widget buildStar(int index) {
    bool isSelected = index < rating;

    return GestureDetector(
      onTap: () {
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
            isSelected ? CupertinoIcons.star_fill : CupertinoIcons.star,
            key: ValueKey(isSelected),
            color: isSelected ? AppColors.secondaryColor : AppColors.greyIcon,
            size: 30,
          ),
        ),
      ),
    );
  }
}
