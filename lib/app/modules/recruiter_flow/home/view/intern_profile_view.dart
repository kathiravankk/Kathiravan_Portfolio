import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/utils/resume_file_utils.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/full_screen_image_preview.dart';
import 'package:internsharks/app/core/widgets/recruiter_internship_widget.dart';
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_student_profile_model.dart';
import 'package:internsharks/app/modules/home/view/resume_template_preview_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InternProfileViewScreen extends StatefulWidget {
  const InternProfileViewScreen({super.key});

  @override
  State<InternProfileViewScreen> createState() =>
      _InternProfileViewScreenState();
}

class _InternProfileViewScreenState extends State<InternProfileViewScreen> {
  final RecruiterHomeController applicationController =
      Get.find<RecruiterHomeController>();
  String studentId = "";
  String jobId = "";
  InternStudentProfileModel? studentData;
  WebViewController? webViewController;
  bool isResumeLoading = false;
  ExtractedResumeDataModel? resumeData;
  bool _canWebGoBack = false;

  @override
  void initState() {
    studentId = Get.arguments["studentId"] ?? "";
    super.initState();
    getStudentProfileData();
  }

  Future<void> getStudentProfileData() async {
    try {
      await applicationController.getInternProfileData(studentId: studentId);
      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        setState(() {
          studentData = applicationController.internProfileModel;
          initResumePreview();
        });
      } else {
        AppFunctions.apiErrorHandling(
          applicationController.getResponseCode(),
          "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        applicationController.getResponseCode(),
        "Something went wrong!, Try again later",
      );
    }
  }

  Future<void> initResumePreview() async {
    resumeData = ExtractedResumeDataModel(
      personalInfo: PersonalInfoModel(
        name: studentData?.studName ?? "",
        email: studentData?.studEmail ?? "",
        phone: studentData?.studMobileNo ?? "",
        github: studentData?.github ?? "",
        linkedIn: studentData?.linkedIn ?? "",
        location: studentData?.location ?? "",
        gender: "",
      ),
      profileSummary: studentData?.profileSummary ?? "",
      skills: studentData?.studProgrammingLang,
      certifications: studentData?.studentCertificate,
      educationData: studentData?.education,
      colleges: studentData?.college,
      internships: studentData?.internships,
      experience: studentData?.experience,
      projects: studentData?.projects,
      hobbies: studentData?.hobbies,
      achievements: studentData?.achievements,
      publications: studentData?.publications,
      volunteerExperience: studentData?.volunteerExperience,
      workShops: studentData?.workshops,
      paperPresentations: studentData?.paperPresentations,
      industrialVisits: studentData?.industrialVisits,
      languages: studentData?.languagesKnown,
      areasOfInterest: studentData?.areasOfInterest,
      leaderships: studentData?.leadership,
      studentId: studentData?.id,
      higherSecondary: studentData?.education?.school?.higherSecondary,
      secondary: studentData?.education?.school?.secondary,
    );

    _initWebview();
  }

  void _initWebview() {
    if (resumeData == null) return;

    final template = templates.firstWhere(
      (e) =>
          e.id ==
          int.parse(
            studentData?.templateNumber?.isNotEmpty == true
                ? studentData!.templateNumber!
                : "1",
          ),
      orElse: () => templates.first,
    );

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            final canBack = webViewController != null
                ? await webViewController!.canGoBack()
                : false;
            if (mounted) setState(() => _canWebGoBack = canBack);
          },
          onPageFinished: (_) async {
            final canBack = webViewController != null
                ? await webViewController!.canGoBack()
                : false;
            if (mounted) setState(() => _canWebGoBack = canBack);

            if (!canBack && resumeData != null) {
              await Future.delayed(const Duration(milliseconds: 300));

              await webViewController!.runJavaScript("""
            var meta = document.querySelector('meta[name="viewport"]');
            if (!meta) {
              meta = document.createElement('meta');
              meta.name = 'viewport';
              document.head.appendChild(meta);
            }
            meta.content =
            'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            """);

              final jsonData = jsonEncode(resumeData!.toJson());
              final safeJson = jsonEncode(jsonData);

              await webViewController!.runJavaScript(
                "renderResume(JSON.parse($safeJson));",
              );
            }
          },
        ),
      );

    _loadHtml(template.htmlPath);
  }

  Future<void> _handleWebBack() async {
    if (webViewController != null && await webViewController!.canGoBack()) {
      await webViewController!.goBack();
      final canBack = webViewController != null
          ? await webViewController!.canGoBack()
          : false;
      if (!canBack) {
        _initWebview();
      }
      if (mounted) setState(() => _canWebGoBack = canBack);
    } else {
      Get.back();
    }
  }

  Future<void> _loadHtml(String path) async {
    String html = await DefaultAssetBundle.of(context).loadString(path);

    html = html.replaceFirst(
      '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
      '<meta name="viewport" content="width=900, initial-scale=1.0, shrink-to-fit=no">',
    );

    await webViewController!.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_canWebGoBack,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleWebBack();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.appBackgroundImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: AppColors.transparentColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.transparentColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
              onPressed: () async {
                if (_canWebGoBack) {
                  await _handleWebBack();
                } else {
                  Get.back();
                }
              },
            ),
            title: Text(
              "Profile",
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.secondaryColor,
                weight: FontWeight.w600,
              ),
            ),
          ),
          body: Obx(
            () => applicationController.internProfileLoading
                ? AppAlertUtils.customLoader()
                : studentData != null
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 12,
                              children: [
                                // Profile banner + avatar
                                studentData!.studentBanner!.isNotEmpty ||
                                        studentData!.studentBanner != null
                                    ? GestureDetector(
                                        onTap: () {
                                          final imageUrl =
                                              studentData!.studentBanner ?? "";

                                          if (imageUrl.isNotEmpty) {
                                            Get.to(
                                              () => FullScreenImagePreview(
                                                imageUrl: imageUrl,
                                              ),
                                            );
                                          }
                                        },
                                        child: Hero(
                                          tag: studentData!.studentBanner ?? "",
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            child: Image.network(
                                              studentData!.studentBanner ?? "",
                                              //height: 180,
                                              width: double.infinity,
                                              fit: BoxFit.fill,

                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }

                                                return Container(
                                                  height: 130,
                                                  color: AppColors.thirdColor,
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      color: AppColors
                                                          .primaryColor,
                                                      value:
                                                          loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  ),
                                                );
                                              },

                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(Icons.photo),
                                            ),
                                          ),
                                        ),
                                      )
                                    : ProfileBanner(student: studentData!),

                                // Identity card
                                IdentityCard(student: studentData!),

                                // 2-column section grid
                                TwoColRow(
                                  left: SectionCard(
                                    icon: Icons.notes_rounded,
                                    iconColor: const Color(0xFF7B68EE),
                                    title: "SUMMARY",
                                    child: BodyText(
                                      studentData!.profileSummary ?? "—",
                                    ),
                                  ),
                                  right: SectionCard(
                                    icon: Icons.code_rounded,
                                    iconColor: const Color(0xFF00D4CC),
                                    title: "SKILLS",
                                    child: BodyText(
                                      (studentData!.studProgrammingLang ?? [])
                                          .join(', '),
                                    ),
                                  ),
                                ),

                                TwoColRow(
                                  left: WorkExperienceCard(
                                    student: studentData!,
                                  ),
                                  right: CertificationsCard(
                                    student: studentData!,
                                  ),
                                ),

                                TwoColRow(
                                  left: SectionCard(
                                    icon: Icons.language_rounded,
                                    iconColor: const Color(0xFF00D4CC),
                                    title: "LANGUAGES",
                                    child: BodyText(
                                      (studentData!.languagesKnown ?? []).join(
                                        ', ',
                                      ),
                                    ),
                                  ),
                                  right: SectionCard(
                                    icon: Icons.star_rounded,
                                    iconColor: const Color(0xFFFFD700),
                                    title: "AREAS OF INTEREST",
                                    child: BodyText(
                                      (studentData!.areasOfInterest ?? []).join(
                                        ', ',
                                      ),
                                    ),
                                  ),
                                ),

                                if ((studentData!.hobbies ?? []).isNotEmpty)
                                  SectionCard(
                                    icon: Icons.games_rounded,
                                    iconColor: const Color(0xFFFF8C42),
                                    title: "HOBBIES",
                                    fullWidth: true,
                                    child: BodyText(
                                      (studentData!.hobbies ?? []).join(', '),
                                    ),
                                  ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        BottomBar(
                          student: studentData!,
                          viewFunc: () {
                            AppFunctions.navigateScreen(
                              context,
                              AppRoutes.recruiterResumePreviewScreen,
                              arguments: {
                                "templateId": int.parse(
                                  studentData!.templateNumber?.isNotEmpty ==
                                          true
                                      ? studentData!.templateNumber!
                                      : "1",
                                ),
                                "studentId": studentData!.id!.isNotEmpty == true
                                    ? studentData!.id!
                                    : "",
                                // "resumeData": ExtractedResumeDataModel(
                                //   personalInfo: PersonalInfoModel(
                                //     name: studentData!.studName ?? "",
                                //     email: studentData!.studEmail ?? "",
                                //     phone: studentData!.studMobileNo ?? "",
                                //     github: studentData!.github ?? "",
                                //     linkedIn: studentData!.linkedIn ?? "",
                                //     location: studentData!.location ?? "",
                                //     gender: "",
                                //   ),
                                //   profileSummary:
                                //       studentData!.profileSummary ?? "",
                                //   skills: studentData!.studProgrammingLang,
                                //   certifications: studentData!.studentCertificate,
                                //   educationData: studentData!.education,
                                //   colleges: studentData!.college,
                                //   internships: studentData!.internships,
                                //   experience: studentData!.experience,
                                //   projects: studentData!.projects,
                                //   hobbies: studentData!.hobbies,
                                //   achievements: studentData!.achievements,
                                //   publications: studentData!.publications,
                                //   volunteerExperience:
                                //       studentData!.volunteerExperience,
                                //   workShops: studentData!.workshops,
                                //   paperPresentations:
                                //       studentData!.paperPresentations,
                                //   industrialVisits: studentData!.industrialVisits,
                                //   languages: studentData!.languagesKnown,
                                //   areasOfInterest: studentData!.areasOfInterest,
                                //   leaderships: studentData!.leadership,
                                //   studentId: studentData!.id,
                                //   higherSecondary: studentData!
                                //       .education
                                //       ?.school
                                //       ?.higherSecondary,
                                //   secondary:
                                //       studentData!.education?.school?.secondary,
                                // ),
                              },
                            );
                          },
                          downloadFunc: () async {
                            await _handleDownload();
                          },
                        ),
                      ],
                    ),
                  )
                : CustomEmptyWidget(),
          ),
        ),
      ),
    );
  }

  Future<void> _handleDownload() async {
    if (webViewController == null) return;

    setState(() {
      isResumeLoading = true;
    });

    try {
      final firstName = (resumeData?.personalInfo?.name ?? "resume")
          .split(" ")
          .first;

      await ResumeFileUtils.handleDownload(
        webViewController: webViewController!,
        fileName: "${firstName}_resume",
      );
    } finally {
      if (mounted) {
        setState(() {
          isResumeLoading = false;
        });
      }
    }
  }
}
