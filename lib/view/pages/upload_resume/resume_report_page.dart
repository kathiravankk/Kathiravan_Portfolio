import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:internsharks/app/data/models/account/resume_response.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import '../../screens/home_Screen.dart';

class ResumeReportPage extends StatefulWidget {
  final String? resumePath;
  final ResumeResponse analysisData;

  const ResumeReportPage({
    super.key,
    this.resumePath,
    required this.analysisData,
  });

  @override
  _ResumeReportPageState createState() => _ResumeReportPageState();
}

class _ResumeReportPageState extends State<ResumeReportPage> {
  Map<String, Map<String, bool>> sectionSuggestions = {};
  Map<String, String> sectionFeedback = {};

  @override
  void initState() {
    super.initState();
    _initializeSuggestions();
  }

  void _initializeSuggestions() {
    final analysis = widget.analysisData.analysis;
    if (analysis?.sections != null) {
      analysis!.sections!.forEach((sectionKey, sectionValue) {
        sectionSuggestions[sectionKey] = {};
        List<String> suggestions = _getSuggestionsForSection(sectionKey);
        for (int i = 0; i < suggestions.length; i++) {
          sectionSuggestions[sectionKey]!['suggestion_$i'] = false;
        }
      });
    }
  }

  List<String> _getSuggestionsForSection(String sectionKey) {
    final sections = widget.analysisData.analysis?.sections;
    if (sections == null || sections[sectionKey] == null) return [];

    var section = sections[sectionKey]!;
    List<String> allSuggestions = [];

    if (section.suggestions1 != null) {
      allSuggestions.addAll(section.suggestions1!);
    }

    return allSuggestions.toSet().toList();
  }

  String _getSectionTitle(String key) {
    final titles = {
      'personalInfo': 'Personal Information',
      'summary': 'Profile Summary',
      'experience': 'Experience',
      'education': 'Education',
      'skills': 'Technical Skills',
      'projects': 'Projects & Portfolios',
      'certifications': 'Certifications',
    };
    return titles[key] ?? key;
  }

  String _getSectionSubtitle(double rating) {
    if (rating >= 9) return 'Excellent';
    if (rating >= 8) return 'Very Good';
    if (rating >= 7) return 'Good but can be improved';
    if (rating >= 6) return 'Needs improvement';
    return 'Requires attention';
  }

  @override
  Widget build(BuildContext context) {
    final analysis = widget.analysisData.analysis;
    final int overallScore = analysis?.overallScore ?? 0;
    final String grade = analysis?.grade ?? 'N/A';

    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Resume Report', style: AppTextStyles.white24Bold),
      ),
      body: SingleChildScrollView(
        // RenderBox error fix: SingleChildScrollView uses dynamic height
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text('Credit: 100', style: AppTextStyles.white16),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildResumePreview(),

              const SizedBox(height: 20),

              // Total Score Container
              Container(
                width: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff1e2525),
                  border: Border.all(color: Colors.white24, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Score  ',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.appYellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "$overallScore",
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const TextSpan(
                            text: "/100",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.appBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        grade,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Dynamic Sections (Summary & Projects will show here)
              if (analysis?.sections != null)
                ...analysis!.sections!.keys.map((sectionKey) {
                  final sectionData = analysis.sections![sectionKey]!;
                  return _buildDynamicSection(
                    sectionKey: sectionKey,
                    title: _getSectionTitle(sectionKey),
                    score: (sectionData.rating ?? 0).toDouble(),
                    subtitle: _getSectionSubtitle(
                      (sectionData.rating ?? 0).toDouble(),
                    ),
                    suggestions: _getSuggestionsForSection(sectionKey),
                  );
                }),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:() {
                        Get.toNamed(
                          AppRoutes.resumeScreen,

                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff283443),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: AppColors.appBlue),
                        ),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(activeStep: 2),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff283443),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumePreview() {
    final extracted = widget.analysisData.extractedContent;
    final personalInfo = extracted?.personalInfo;

    String name = personalInfo?.name ?? 'Name';
    String email = personalInfo?.email ?? 'email@example.com';
    String location = personalInfo?.location ?? 'Location';
    String summary = extracted?.summary ?? 'No summary available in resume.';

    return GestureDetector(
      onTap: () {
        if (widget.resumePath != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FullScreenResumeViewer(filePath: widget.resumePath!),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        // Height specified to avoid layout ambiguity
        constraints: const BoxConstraints(minHeight: 180),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F1E8),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('🌀', style: TextStyle(fontSize: 18)),
                Text('☕', style: TextStyle(fontSize: 18)),
                Text('📄', style: TextStyle(fontSize: 18)),
                Text('🔷', style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '$location | $email',
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
            const Divider(height: 20, color: Colors.black12),

            // Profile Summary Area
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PROFILE SUMMARY",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    summary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Spacer error fixed here by using SizedBox
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tap to view full resume ",
                  style: TextStyle(
                    color: AppColors.appBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.touch_app, color: AppColors.appBlue, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicSection({
    required String sectionKey,
    required String title,
    required double score,
    required String subtitle,
    required List<String> suggestions,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.appBlue, width: 2),
                ),
                child: Center(
                  child: Text(
                    score.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 20,
                  color: sectionFeedback[sectionKey] == 'like'
                      ? AppColors.appBlue
                      : Colors.white38,
                ),
                onPressed: () =>
                    setState(() => sectionFeedback[sectionKey] = 'like'),
              ),
              IconButton(
                icon: Icon(
                  Icons.thumb_down_alt_outlined,
                  size: 20,
                  color: sectionFeedback[sectionKey] == 'dislike'
                      ? Colors.redAccent
                      : Colors.white38,
                ),
                onPressed: () =>
                    setState(() => sectionFeedback[sectionKey] = 'dislike'),
              ),
            ],
          ),
          const Divider(color: Colors.white12, height: 25),
          if (suggestions.isNotEmpty) ...[
            const Text(
              'Optimization Suggestions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.appYellow,
              ),
            ),
            const SizedBox(height: 8),
            ...suggestions.asMap().entries.map((entry) {
              int idx = entry.key;
              String val = entry.value;
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                activeColor: AppColors.appBlue,
                title: Text(
                  val,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
                value:
                    sectionSuggestions[sectionKey]?['suggestion_$idx'] ?? false,
                onChanged: (bool? v) => setState(
                  () => sectionSuggestions[sectionKey]!['suggestion_$idx'] =
                      v ?? false,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class FullScreenResumeViewer extends StatelessWidget {
  final String filePath;

  const FullScreenResumeViewer({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Full Resume", style: TextStyle(color: Colors.white)),
      ),
      body: filePath.toLowerCase().endsWith('.pdf')
          ? SfPdfViewer.file(File(filePath))
          : InteractiveViewer(child: Image.file(File(filePath))),
    );
  }
}
