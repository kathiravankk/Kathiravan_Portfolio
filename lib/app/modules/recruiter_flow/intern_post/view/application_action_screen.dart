import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/app_background_widget.dart';
import 'package:internsharks/app/core/widgets/full_screen_image_preview.dart';
import 'package:internsharks/app/core/widgets/recruiter_internship_widget.dart';
import 'package:internsharks/app/data/models/account/certification_model.dart';
import 'package:internsharks/app/data/models/account/education_model.dart';
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/student_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_student_profile_model.dart' hide ProjectModelData;
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class ApplicantActionsScreen extends StatefulWidget {
  const ApplicantActionsScreen({super.key});

  @override
  State<ApplicantActionsScreen> createState() => _ApplicantActionsScreenState();
}

class _ApplicantActionsScreenState extends State<ApplicantActionsScreen> {
  final InternshipPostController applicationController =
      Get.find<InternshipPostController>();

  String studentId = "";
  String jobId = "";

  @override
  void initState() {
    studentId = Get.arguments["studentId"] ?? "";
    jobId = Get.arguments["jobId"] ?? "";
    super.initState();
    getStudentProfileData();
  }

  Future<void> getStudentProfileData() async {
    try {
      await applicationController.getInternStudentProfile(
        jobId: jobId,
        studentId: studentId,
      );
      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        setState(() {
          studentData = applicationController.internStudentProfileModel;
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

  InternStudentProfileModel? studentData;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBarWidget: _buildAppBar(
        studentData != null ? studentData!.applicationStatus ?? "" : "",
      ),
      bodyWidget: Obx(
        () => applicationController.studentProfileLoading
            ? AppAlertUtils.customLoader()
            : Column(
                children: [
                  // ── Accept / Reject action strip ────────────────────
                  Visibility(
                    visible:
                        studentData!.applicationStatus == "applied" ||
                        studentData!.applicationStatus == "Applied",
                    child: ActionStrip(applicant: studentData!),
                  ),

                  // ── Scrollable resume card ───────────────────────────
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
                                      borderRadius: BorderRadius.circular(15),
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
                                                color: AppColors.primaryColor,
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
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.photo),
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
                                (studentData!.studProgrammingLang ?? []).join(
                                  ', ',
                                ),
                              ),
                            ),
                          ),

                          TwoColRow(
                            left: WorkExperienceCard(student: studentData!),
                            right: CertificationsCard(student: studentData!),
                          ),

                          TwoColRow(
                            left: SectionCard(
                              icon: Icons.language_rounded,
                              iconColor: const Color(0xFF00D4CC),
                              title: "LANGUAGES",
                              child: BodyText(
                                (studentData!.languagesKnown ?? []).join(', '),
                              ),
                            ),
                            right: SectionCard(
                              icon: Icons.star_rounded,
                              iconColor: const Color(0xFFFFD700),
                              title: "AREAS OF INTEREST",
                              child: BodyText(
                                (studentData!.areasOfInterest ?? []).join(', '),
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
                        ],
                      ),
                    ),
                  ),

                  BottomBar(
                    student: studentData!,
                    viewFunc: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.resumeTemplatePreviewScreen,
                        arguments: {
                          "templateId": int.parse(
                            studentData!.templateNumber?.isNotEmpty == true
                                ? studentData!.templateNumber!
                                : "1",
                          ),
                          "resumeData": ExtractedResumeDataModel(
                            personalInfo: PersonalInfoModel(
                              name: studentData!.studName ?? "",
                              email: studentData!.studEmail ?? "",
                              phone: studentData!.studMobileNo ?? "",
                              github: studentData!.github,
                              linkedIn: studentData!.linkedIn,
                              location: studentData!.location!,
                              gender: "",
                            ),
                            profileSummary: studentData!.profileSummary ?? "",
                            skills: studentData!.studProgrammingLang,
                            certifications:
                                studentData!.studentCertificate,
                            educationData: studentData!.education,
                            colleges: studentData!.college,
                            internships: studentData!.internships,
                            experience: studentData!.experience,
                            projects: studentData!.projects,
                            hobbies: studentData!.hobbies,
                            achievements: studentData!.achievements,
                            publications: studentData!.publications,
                            volunteerExperience: studentData!.volunteerExperience,
                            workShops: studentData!.workshops,
                            paperPresentations: studentData!.paperPresentations,
                            industrialVisits: studentData!.industrialVisits,
                            languages: studentData!.languagesKnown,
                            areasOfInterest: studentData!.areasOfInterest,
                            leaderships: studentData!.leadership,
                            studentId: studentData!.id,
                            higherSecondary:
                            studentData!.education?.school?.higherSecondary,
                            secondary: studentData!.education?.school?.secondary,
                          ),
                        },
                      );
                    },
                    downloadFunc: () {},
                  ),
                ],
              ),
      ),
    );
  }

  // ── App Bar ───────────────────────────────────────────────────────────────
  AppBar _buildAppBar(String status) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.transparentColor,
      leading: InkWell(
        onTap: () => Get.back(),
        child: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            "Applicant Actions",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Text(
                "Current Status:",
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
              StatusChip(status: status),
            ],
          ),
        ],
      ),
    );
  }
}
