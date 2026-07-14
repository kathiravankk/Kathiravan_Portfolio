import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/app_background_widget.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/full_screen_image_preview.dart';
import 'package:internsharks/app/core/widgets/recruiter_internship_widget.dart';
import 'package:internsharks/app/core/widgets/syllabus_generation_dialog.dart';
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_student_profile_model.dart'
    hide ProjectModelData;
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/view/syllabus_generation_loading_screen.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class ApplicantActionsScreen extends StatefulWidget {
  const ApplicantActionsScreen({super.key});

  @override
  State<ApplicantActionsScreen> createState() => _ApplicantActionsScreenState();
}

class _ApplicantActionsScreenState extends State<ApplicantActionsScreen> {
  final InternshipPostController applicationController =
      Get.find<InternshipPostController>();
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();

  String studentId = "";
  String jobId = "";
  String applicationId = "";
  String status = "";
  List<String> projectList = [];
  PostData? internshipData;

  @override
  void initState() {
    studentId = Get.arguments["studentId"] ?? "";
    jobId = Get.arguments["jobId"] ?? "";
    applicationId = Get.arguments["applicationId"] ?? "";
    projectList = Get.arguments["projectList"] ?? [];
    internshipData = Get.arguments["internshipData"] ?? PostData();
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
        if (applicationController.internStudentProfileModel.applicationStatus ==
                "Applied" ||
            applicationController.internStudentProfileModel.applicationStatus ==
                "applied") {
          await updateApplicationStatus(status: "View", syllabusId: "");
        }
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
                        studentData!.applicationStatus == "Applied" ||
                        studentData!.applicationStatus == "View",
                    child: applicationController.applicationStatusLoading
                        ? Center(
                            child: CupertinoActivityIndicator(
                              color: AppColors.secondaryColor,
                            ),
                          )
                        : ActionStrip(
                            applicant: studentData!,
                            onAccept: () async {
                              await updateApplicationStatus(
                                status: "Selected",
                                syllabusId: "",
                              );
                            },
                            onReject: () async {
                              await updateApplicationStatus(
                                status: "Rejected",
                                syllabusId: "",
                              );
                            },
                          ),
                  ),
                  Visibility(
                    visible: studentData!.syllabusStatus!,
                    child: Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: statusContainer(
                            borderColor: AppColors.statusBorder,
                            labelText: "View Syllabus",
                            icon: CupertinoIcons.book,
                            onTap: () {
                              AppFunctions.navigateScreen(
                                context,
                                AppRoutes.recruiterSyllabusViewScreen,
                                arguments: {
                                  "studentId": studentId,
                                  "jobId": jobId,
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: statusContainer(
                            borderColor: AppColors.statusBorder2,
                            labelText: "Student Results",
                            icon: CupertinoIcons.chart_bar,
                            onTap: () {
                              AppFunctions.navigateScreen(
                                context,
                                AppRoutes.internTestResultScreen,
                                arguments: {
                                  "studentId": studentId,
                                  "jobId": jobId,
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

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
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  studentData!.syllabusStatus! ||
                          studentData!.applicationStatus == "Applied" ||
                          studentData!.applicationStatus == "Rejected" ||
                          studentData!.applicationStatus == "View"
                      ? BottomBar(
                          student: studentData!,
                          viewFunc: () {
                            AppFunctions.navigateScreen(
                              context,
                              AppRoutes.resumeTemplatePreviewScreen,
                              arguments: {
                                "templateId": int.parse(
                                  studentData!.templateNumber?.isNotEmpty ==
                                          true
                                      ? studentData!.templateNumber!
                                      : "1",
                                ),
                                "resumeData": ExtractedResumeDataModel(
                                  personalInfo: PersonalInfoModel(
                                    name: studentData!.studName ?? "",
                                    email: studentData!.studEmail ?? "",
                                    phone: studentData!.studMobileNo ?? "",
                                    github: studentData!.github ?? "",
                                    linkedIn: studentData!.linkedIn ?? "",
                                    location: studentData!.location ?? "",
                                    gender: "",
                                  ),
                                  profileSummary:
                                      studentData!.profileSummary ?? "",
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
                                  volunteerExperience:
                                      studentData!.volunteerExperience,
                                  workShops: studentData!.workshops,
                                  paperPresentations:
                                      studentData!.paperPresentations,
                                  industrialVisits:
                                      studentData!.industrialVisits,
                                  languages: studentData!.languagesKnown,
                                  areasOfInterest: studentData!.areasOfInterest,
                                  leaderships: studentData!.leadership,
                                  studentId: studentData!.id,
                                  higherSecondary: studentData!
                                      .education
                                      ?.school
                                      ?.higherSecondary,
                                  secondary:
                                      studentData!.education?.school?.secondary,
                                ),
                              },
                            );
                          },
                          downloadFunc: () {},
                        )
                      : CustomButtonWidget(
                          buttonFunction: () {
                            SyllabusGenerationDialog.show(
                              context,
                              initialProjectDescription: projectList,
                              creditCost: 100,
                              onGenerate: (description, level) async {
                                final success = await Navigator.of(context)
                                    .push<bool>(
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (_) =>
                                            SyllabusGeneratingScreen(
                                              onProcess: () =>
                                                  _generateAndSaveSyllabus(
                                                    projectDescription:
                                                        description,
                                                    level: level,
                                                  ),
                                            ),
                                      ),
                                    );

                                if (success == true) {
                                  await getStudentProfileData();
                                }
                              },
                            );
                          },
                          buttonWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Generate Syllabus",
                                style: AppStyles.customTextStyle(
                                  size: 16,
                                  color: AppColors.blackColor,
                                  weight: FontWeight.w500,
                                  fontFamily: "Roboto",
                                ),
                              ),
                              Text(
                                "100",
                                style: AppStyles.customTextStyle(
                                  size: 16,
                                  color: AppColors.blackColor,
                                  weight: FontWeight.w500,
                                  fontFamily: "Roboto",
                                ),
                              ),
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
    );
  }

  Future<bool> _generateAndSaveSyllabus({
    required String projectDescription,
    required String level,
  }) async {
    try {
      /// Build payload
      final Map<String, dynamic> payload = {
        "student_resume": {
          "name": studentData?.studName ?? "",
          "email": studentData?.studEmail ?? "",
          "phone": studentData?.studMobileNo ?? "",
          "location": studentData?.location ?? "",
          "linkedIn": studentData?.linkedIn ?? "",
          "github": studentData?.github ?? "",
          "role": "student",
          "profile_summary": studentData?.profileSummary ?? "",
          "skills": studentData?.studProgrammingLang ?? [],
          "languages": studentData?.languagesKnown ?? [],
          "projects": studentData?.projects ?? [],
          "experience": studentData?.experience ?? [],
          "internships": studentData?.internships ?? [],
          "industrial_visits": studentData?.industrialVisits ?? [],
          "workshops": studentData?.workshops ?? [],
          "certifications": studentData?.studentCertificate ?? [],
          "paper_presentations": studentData?.paperPresentations ?? [],
          "publications": studentData?.publications ?? [],
          "achievements": studentData?.achievements ?? [],
          "leadership": studentData?.leadership ?? [],
          "volunteer_experience": studentData?.volunteerExperience ?? [],
          "areas_of_interest": studentData?.areasOfInterest ?? [],
          "hobbies": studentData?.hobbies ?? [],
          "education": studentData?.education,
        },

        "recruiter_skills": (internshipData?.requiredSkills ?? []).join(", "),

        "project_description": [projectDescription],

        "job": jobId,
        "student": studentId,
        "level": level,
      };

      /// Send ONLY one field: days OR month
      final String days = (internshipData?.days ?? "").toString().trim();

      final String months = (internshipData?.internshipDuration ?? "")
          .toString()
          .trim();

      if (days.isNotEmpty) {
        payload["days"] = days;
      } else if (months.isNotEmpty) {
        payload["months"] = months;
      }

      debugPrint("Generate Payload:", wrapWidth: 1024);
      debugPrint(payload.toString());

      /// STEP 1 : Generate syllabus
      await homeController.generateSyllabus(requireData: payload);

      debugPrint(
        "Generate API Response Code: ${homeController.getResponseCode()}",
      );
      // debugPrint("Generate Model: ${homeController.syllabusGenerateModel}");

      if (homeController.getResponseCode() != 200 &&
          homeController.getResponseCode() != 201) {
        debugPrint("Generate failed");
        return false;
      }

      debugPrint("Calling Save API...");
      final saveSuccess = await saveSyllabusData();
      debugPrint("Save API returned: $saveSuccess");

      return saveSuccess;
    } catch (e) {
      debugPrint("Generate syllabus error: $e");

      AppAlertUtils.showToast(
        message: "Failed to generate syllabus",
        isError: true,
      );

      return false;
    }
  }

  Future<bool> saveSyllabusData() async {
    try {
      homeController.syllabusGenerateModel.studentId = studentId;
      homeController.syllabusGenerateModel.jobId = jobId;
      await homeController.saveSyllabus(
        syllabusData: homeController.syllabusGenerateModel,
      );

      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        AppAlertUtils.showToast(message: "Syllabus generated successfully!");
        await updateApplicationStatus(
          status: "Selected",
          syllabusId: homeController.syllabusSaveModel.id ?? "",
        );
        await getStudentProfileData();
        return true;
      }

      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        homeController.syllabusSaveModel.message ?? "Failed to save syllabus",
      );

      return false;
    } catch (e) {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong",
      );

      return false;
    }
  }

  Future<void> updateApplicationStatus({
    required String status,
    required String syllabusId,
  }) async {
    try {
      await applicationController.updateApplicationStatus(
        applicationId: applicationId,
        status: status,
        syllabusId: syllabusId,
      );
      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        AppAlertUtils.showToast(
          message:
              applicationController.applicationStatusModel.message ??
              "Something went wrong!, Try again later",
        );
        await getStudentProfileData();
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

  Widget statusContainer({
    required Color borderColor,
    required String labelText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.transparentColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(icon, color: AppColors.whiteColor, size: 20),
            Text(
              labelText,
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
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
        child: const Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
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
