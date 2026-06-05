import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

enum LoadingDialogType {
  resumeExtraction,
  atsJson,
  enhanceResume,
  kyc,
  syllabus,
  resDp,
  mcqTest,
  mcqValidation,
}

class AiLoadingWidget {
  static final Map<LoadingDialogType, List<String>> _messages = {
    LoadingDialogType.resumeExtraction: [
      '📤 Your resume is being securely uploaded to the system.',
      '🔐 Ensuring file integrity and safe transmission.',
      '📄 Reading and parsing the document content.',
      '🧠 Understanding layout, sections, and formatting.'
      '🔍 Identifying key information such as name, skills, and experience.',
      '📑 Extracting structured data from unstructured text.',
      '🗂️ Categorizing details into predefined fields.',
      '⚙️ Normalizing data for consistency and accuracy.',
      '📊 Preparing the extracted profile for further processing.',
      '✅ Resume extraction completed successfully.',
    ],
    LoadingDialogType.atsJson: [
      '📄 Analyzing your resume for ATS compatibility.',
      '🔍 Detecting relevant keywords and missing skills.',
      '🧠 Mapping your resume against job description patterns.',
      '📊 Evaluating keyword density and semantic relevance.',
      '⚖️ Checking formatting issues that affect ATS parsing.',
      '🧾 Converting resume data into structured JSON format.',
      '🧩 Ensuring schema consistency for ATS systems.',
      '📉 Identifying gaps impacting your ATS score.',
      '📈 Calculating and generating ATS match score.',
      '✅ ATS analysis and JSON generation completed.',
    ],
    LoadingDialogType.enhanceResume: [
      '✨ Applying intelligent improvements to your resume.',
      '🔍 Enhancing keyword relevance for better visibility.',
      '🧠 Rewriting experience with impact-focused statements.',
      '📊 Optimizing achievements using measurable metrics.',
      '🧩 Aligning content with ATS-friendly structures.',
      '📄 Improving formatting and readability.',
      '⚙️ Standardizing sections for consistency.',
      '🛠️ Eliminating redundant or weak content.',
      '🚀 Boosting overall resume effectiveness.',
      '✅ Resume enhancement completed successfully.',
    ],
    LoadingDialogType.kyc: [
      '🆔 Initiating identity verification process.',
      '📄 Validating submitted documents and details.',
      '🔍 Checking authenticity using verification rules.',
      '🧠 Matching identity data across sources.',
      '⚖️ Ensuring compliance with regulatory standards.',
      '🛡️ Running fraud detection and security checks.',
      '📊 Evaluating risk and verification confidence.',
      '🔗 Cross-verifying data consistency.',
      '📌 Finalizing identity validation status.',
      '✅ KYC verification completed successfully.',
    ],
    LoadingDialogType.syllabus: [
      '🧠 Analyzing candidate skills and knowledge gaps.',
      '📊 Identifying relevant topics based on goals.',
      '📚 Selecting structured learning modules.',
      '🔍 Prioritizing concepts based on importance.',
      '🧩 Mapping dependencies between topics.',
      '🗂️ Organizing content into a logical sequence.',
      '📅 Structuring syllabus with timeline.',
      '⚙️ Customizing difficulty based on user level.',
      '📈 Ensuring progressive learning flow.',
      '✅ Personalized syllabus generated successfully.',
    ],
    LoadingDialogType.resDp: [
      '🎯 Analyzing student profile and preferences.',
      '🧠 Understanding skills and learning objectives.',
      '🎨 Designing a personalized RESDP banner layout.',
      '🧩 Integrating relevant skill highlights.',
      '📊 Aligning visual elements with user profile.',
      '🖼️ Rendering design with optimized styling.',
      '⚙️ Adjusting layout for clarity and impact.',
      '📐 Ensuring responsive and clean presentation.',
      '✨ Enhancing visual appeal and readability.',
      '✅ RESDP banner generated successfully.',
    ],
    LoadingDialogType.mcqTest: [
      '🧠 Generating questions based on syllabus coverage.',
      '📚 Selecting topics for balanced assessment.',
      '🎯 Adjusting difficulty level dynamically.',
      '🧩 Ensuring variety in question types.',
      '📊 Maintaining coverage across all concepts.',
      '📝 Structuring test format and flow.',
      '⚙️ Configuring timing and rules.',
      '🔍 Validating question quality and accuracy.',
      '🚀 Preparing test environment.',
      '✅ Your MCQ test is ready.',
    ],
    LoadingDialogType.mcqValidation: [
      '📝 Collecting and reviewing submitted answers.',
      '🔍 Matching responses with correct answers.',
      '📊 Calculating score and accuracy metrics.',
      '🧠 Analyzing strengths and weak areas.',
      '📉 Identifying incorrect answer patterns.',
      '📈 Generating performance insights.',
      '🧩 Mapping results to syllabus topics.',
      '⚙️ Preparing detailed evaluation report.',
      '📄 Structuring feedback for improvement.',
      '✅ Test validation completed successfully.',
    ],
  };

  static Future<void> show(
    BuildContext context, {
    required LoadingDialogType type,
  }) async {
    final messages = _messages[type] ?? [];

    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Loading',
      barrierColor: AppColors.blackColor
          .withValues(alpha: 0.5),
      pageBuilder: (_, __, ___) => PopScope(
        canPop: false,
        child: _LoadingDialogContent(messages: messages),
      ),
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class _LoadingDialogContent extends StatefulWidget {
  final List<String> messages;

  const _LoadingDialogContent({required this.messages});

  @override
  State<_LoadingDialogContent> createState() => _LoadingDialogContentState();
}

class _LoadingDialogContentState extends State<_LoadingDialogContent> {
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted || widget.messages.isEmpty) return;
      setState(() {
        currentIndex = (currentIndex + 1) % widget.messages.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.35,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.blackColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(blurRadius: 20, color: AppColors.iconBgColor),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AssetImages.internsharksAiLoading,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.4),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Text(
                widget.messages.isEmpty
                    ? 'AI Loading...'
                    : widget.messages[currentIndex],
                key: ValueKey(currentIndex),
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 14,
                  weight: FontWeight.w500,
                  lineSpace: 1.3,
                  color: AppColors.secondaryColor,
                  fontFamily: "Roboto"
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
