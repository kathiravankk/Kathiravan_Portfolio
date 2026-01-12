// import 'package:flutter/material.dart';
// import 'package:internsharks/const_file/app_colors.dart';
// import 'package:internsharks/const_file/app_text_style.dart';
// import 'package:internsharks/pages/upload_resdp/resumeScreen.dart';
// import 'package:internsharks/screens/home_Screen.dart';
// import '../../routes/app_pages.dart';
//
// class ResumeReportPage extends StatefulWidget {
//   final String? resumePath;
//   final Map<String, dynamic> analysisData;
//
//   ResumeReportPage({
//     this.resumePath,
//     required this.analysisData,
//   });
//
//   @override
//   _ResumeReportPageState createState() => _ResumeReportPageState();
// }
//
// class _ResumeReportPageState extends State<ResumeReportPage> {
//   late Map<String, dynamic> resumeData;
//   late Map<String, dynamic> analysisData;
//
//   // Checkbox states for suggestions
//   Map<String, Map<String, bool>> sectionSuggestions = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }
//
//   void _initializeData() {
//     // Extract data from analysisData
//     resumeData = widget.analysisData['extracted_content'] ?? {};
//     analysisData = widget.analysisData['analysis'] ?? {};
//
//     // Initialize checkbox states for each section
//     if (analysisData['sections'] != null) {
//       analysisData['sections'].forEach((sectionKey, sectionValue) {
//         sectionSuggestions[sectionKey] = {};
//         // Initialize suggestions as false
//         List<String> suggestions = _getSuggestionsForSection(sectionKey);
//         for (int i = 0; i < suggestions.length; i++) {
//           sectionSuggestions[sectionKey]!['suggestion_$i'] = false;
//         }
//       });
//     }
//   }
//
//   List<String> _getSuggestionsForSection(String sectionKey) {
//     if (analysisData['sections'] == null ||
//         analysisData['sections'][sectionKey] == null) {
//       return [];
//     }
//
//     var section = analysisData['sections'][sectionKey];
//     List<String> allSuggestions = [];
//
//     // Collect all suggestions (suggestions 1, 2, 3)
//     if (section['suggestions 1'] != null) {
//       allSuggestions.addAll(List<String>.from(section['suggestions 1']));
//     }
//     if (section['suggestions 2'] != null) {
//       allSuggestions.addAll(List<String>.from(section['suggestions 2']));
//     }
//     if (section['suggestions 3'] != null) {
//       allSuggestions.addAll(List<String>.from(section['suggestions 3']));
//     }
//
//     // Remove duplicates
//     return allSuggestions.toSet().toList();
//   }
//
//   bool get hasAnySelection {
//     return sectionSuggestions.values.any((section) =>
//         section.values.any((v) => v)
//     );
//   }
//
//   List<String> _getSelectedSuggestions() {
//     List<String> selected = [];
//     sectionSuggestions.forEach((sectionKey, suggestions) {
//       suggestions.forEach((key, value) {
//         if (value) {
//           List<String> sectionSuggestions = _getSuggestionsForSection(sectionKey);
//           int index = int.parse(key.split('_')[1]);
//           if (index < sectionSuggestions.length) {
//             selected.add('$sectionKey: ${sectionSuggestions[index]}');
//           }
//         }
//       });
//     });
//     return selected;
//   }
//
//   String _getSectionTitle(String key) {
//     final titles = {
//       'personalInfo': 'Personal Information',
//       'summary': 'Summary',
//       'experience': 'Experience',
//       'education': 'Education',
//       'skills': 'Skills',
//       'projects': 'Projects',
//       'certifications': 'Certifications',
//     };
//     return titles[key] ?? key;
//   }
//
//   String _getSectionSubtitle(double rating) {
//     if (rating >= 9) return 'Excellent';
//     if (rating >= 8) return 'Very Good';
//     if (rating >= 7) return 'Good but can be improved';
//     if (rating >= 6) return 'Needs improvement';
//     return 'Requires attention';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Get overall score
//     int overallScore = analysisData['overallScore'] ?? 0;
//     String grade = analysisData['grade'] ?? 'N/A';
//
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.appColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, size: 25, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text('Resume Report', style: AppTextStyles.white24Bold),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Credit Display
//               Padding(
//                 padding: const EdgeInsets.only(right: 30.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: const [
//                     Icon(Icons.stars, color: Colors.amber, size: 16),
//                     SizedBox(width: 4),
//                     Text('Credit: 100', style: AppTextStyles.white16),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               // Resume Preview Card
//               _buildResumePreview(),
//
//               // Total Score
//               SizedBox(height: 20),
//               Container(
//                 width: 250,
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Color(0xff1e2525),
//                   border: Border.all(color: Colors.white24, width: 1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Total Score  ',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: AppColors.appYellow,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: "$overallScore",
//                             style: TextStyle(
//                               fontSize: 36,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           TextSpan(
//                             text: "/100",
//                             style: TextStyle(
//                               fontSize: 25,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: AppColors.appBlue,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         grade,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 24),
//
//               // Dynamic Sections from API
//               if (analysisData['sections'] != null)
//                 ...analysisData['sections'].keys.map((sectionKey) {
//                   var section = analysisData['sections'][sectionKey];
//                   return _buildDynamicSection(
//                     sectionKey: sectionKey,
//                     title: _getSectionTitle(sectionKey),
//                     score: (section['rating'] ?? 0).toDouble(),
//                     subtitle: _getSectionSubtitle((section['rating'] ?? 0).toDouble()),
//                     suggestions: _getSuggestionsForSection(sectionKey),
//                   );
//                 }).toList(),
//
//               SizedBox(height: 20),
//
//               // Bottom Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           AppPageRoute(page: ResumeScreen()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xff283443),
//                         foregroundColor: Colors.green,
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           side: BorderSide(width: 1, color: AppColors.appBlue),
//                         ),
//                       ),
//                       child: Text(
//                         'Update',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => HomeScreen(activeStep: 2),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xff283443),
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       child: Text(
//                         'Skip',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildResumePreview() {
//     // Extract data from API response
//     String name = 'Name';
//     String designation = 'Designation';
//     String email = 'email@example.com';
//     String phone = '+91 0000000000';
//     String location = 'Location';
//
//     if (resumeData['personalInfo'] != null) {
//       List<String> personalInfo = resumeData['personalInfo'].toString().split(', ');
//       if (personalInfo.length >= 1) name = personalInfo[0];
//       if (personalInfo.length >= 2) location = personalInfo.length >= 4 ? personalInfo[3] : personalInfo[1];
//       if (personalInfo.length >= 3) email = personalInfo[1];
//       if (personalInfo.length >= 4) phone = personalInfo[2];
//     }
//
//     return Column(
//       children: [
//         // Resume File Preview Card
//         if (widget.resumePath != null)
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 10),
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xff1a1a1a),
//                   Color(0xff252525),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: AppColors.appBlue.withOpacity(0.3), width: 2),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.appBlue.withOpacity(0.2),
//                   blurRadius: 15,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // PDF Icon and filename
//                 Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.red.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
//                       ),
//                       child: Icon(
//                         Icons.picture_as_pdf,
//                         color: Colors.red,
//                         size: 40,
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.resumePath!.split('/').last,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'Resume Uploaded',
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Icon(Icons.check_circle, color: Colors.green, size: 24),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//         SizedBox(height: 16),
//
//         // Resume Content Preview
//         Container(
//           height: 250,
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF5F1E8),
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.cyan.withOpacity(0.3),
//                 blurRadius: 20,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Tech Icons Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: const [
//                     Text('🌀', style: TextStyle(fontSize: 20)),
//                     Text('☕', style: TextStyle(fontSize: 20)),
//                     Text('📦', style: TextStyle(fontSize: 20)),
//                     Text('📄', style: TextStyle(fontSize: 20)),
//                     Text('🔷', style: TextStyle(fontSize: 20)),
//                     Text('📱', style: TextStyle(fontSize: 20)),
//                     Text('🎨', style: TextStyle(fontSize: 20)),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Name and Title
//                 Center(
//                   child: Column(
//                     children: [
//                       Text(
//                         name,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         designation,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         '$location | $email | $phone',
//                         style: TextStyle(
//                           fontSize: 9,
//                           color: Colors.black54,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Summary
//                 if (resumeData['summary'] != null) ...[
//                   const Text(
//                     'SUMMARY',
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const Divider(color: Colors.black38, thickness: 1),
//                   Text(
//                     resumeData['summary'],
//                     style: TextStyle(
//                       fontSize: 9,
//                       color: Colors.black87,
//                       height: 1.4,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                 ],
//
//                 // Skills
//                 if (resumeData['skills'] != null) ...[
//                   const Text(
//                     'SKILLS',
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const Divider(color: Colors.black38, thickness: 1),
//                   Text(
//                     (resumeData['skills'] as List).join(', '),
//                     style: TextStyle(
//                       fontSize: 9,
//                       color: Colors.black87,
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDynamicSection({
//     required String sectionKey,
//     required String title,
//     required double score,
//     required String subtitle,
//     required List<String> suggestions,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 20),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Color(0xFF262626),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: AppColors.appBlue, width: 3),
//                 ),
//                 child: Center(
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: score.toStringAsFixed(0),
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "/10",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       subtitle,
//                       style: TextStyle(fontSize: 14, color: Colors.white60),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 6),
//           Divider(color: Colors.white12, thickness: 1),
//           SizedBox(height: 16),
//           Row(
//             children: [
//               Text('Suggestions', style: AppTextStyles.white16bold),
//               Spacer(),
//               Container(
//                 padding: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: AppColors.appBlue,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.refresh, size: 20, color: Colors.white),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           if (suggestions.isEmpty)
//             Text(
//               'No suggestions available',
//               style: TextStyle(fontSize: 14, color: Colors.white60),
//             )
//           else
//             ...List.generate(suggestions.length, (index) {
//               String checkboxKey = 'suggestion_$index';
//               return CheckboxListTile(
//                 contentPadding: EdgeInsets.zero,
//                 dense: true,
//                 controlAffinity: ListTileControlAffinity.leading,
//                 activeColor: AppColors.appBlue,
//                 checkColor: Colors.black,
//                 title: Text(
//                   suggestions[index],
//                   style: TextStyle(fontSize: 14, color: Colors.white70),
//                 ),
//                 value: sectionSuggestions[sectionKey]?[checkboxKey] ?? false,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     sectionSuggestions[sectionKey]![checkboxKey] = value ?? false;
//                   });
//                 },
//               );
//             }),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';

import '../../../models/resume_response.dart';
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
                          Routes.resumeScreen,

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
