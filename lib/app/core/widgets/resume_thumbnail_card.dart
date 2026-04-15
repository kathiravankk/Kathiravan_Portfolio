import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/account/resume_template_model.dart';

class ResumeThumbnailCard extends StatelessWidget {
  final ResumeTemplateModel template;
  final VoidCallback onTap;

  const ResumeThumbnailCard({
    super.key,
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(template.thumbnailPath),
                fit: BoxFit.fill,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
              ],
            ),
          ),

          // Template number badge
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primaryColor,
              child: Text(
                template.id.toString(),
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                  fontFamily: "Roboto",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
