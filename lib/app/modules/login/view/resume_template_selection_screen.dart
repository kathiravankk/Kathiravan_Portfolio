import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/resume_thumbnail_card.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/resume_template_model.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class ResumeTemplateSelectionScreen extends StatefulWidget {
  const ResumeTemplateSelectionScreen({super.key});

  @override
  State<ResumeTemplateSelectionScreen> createState() =>
      _ResumeTemplateSelectionScreenState();
}

class _ResumeTemplateSelectionScreenState
    extends State<ResumeTemplateSelectionScreen> {
  ExtractedResumeDataModel? resumeData;

  @override
  void initState() {
    super.initState();
    resumeData = Get.arguments["resumeData"] ?? {};
  }

  final List<ResumeTemplateModel> templates = List.generate(
    10,
    (index) => ResumeTemplateModel(
      id: 1 + index,
      htmlPath:
          'assets/images/html_templates/resume_template_${index + 1}.html',
      thumbnailPath:
          'assets/images/templates_thumbnail/resume_thumbnail_${index + 1}.png',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor_2,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Choose One Resume Template',
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: templates.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final template = templates[index];
          return ResumeThumbnailCard(
            template: template,
            onTap: () {
              AppFunctions.navigateScreen(
                context,
                AppRoutes.resumeTemplateViewScreen,
                arguments: {"templateData": template, "resumeData": resumeData},
              );
            },
          );
        },
      ),
    );
  }
}
