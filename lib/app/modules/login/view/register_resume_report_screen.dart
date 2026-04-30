import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/ai_loading_widget.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/data/repositories/resume_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class RegisterResumeReportScreen extends StatefulWidget {
  const RegisterResumeReportScreen({super.key});

  @override
  State<RegisterResumeReportScreen> createState() =>
      _RegisterResumeReportScreenState();
}

class _RegisterResumeReportScreenState
    extends State<RegisterResumeReportScreen> {
  final RegisterController registerController = Get.find<RegisterController>();

  // Holds checkbox state per section
  final Map<String, Map<String, bool>> _suggestionSelection = {};

  // Stores initial suggestions for reset
  final Map<String, List<String>> _initialSuggestions = {};

  String? networkResumePath;

  @override
  void initState() {
    getResumeScore();
    super.initState();
  }

  // Future<void> getResumeScore() async {
  //   try {
  //     AiLoadingWidget.show(context, type: LoadingDialogType.atsJson);
  //
  //     /// ✅ allow one frame to render loader
  //     await Future.delayed(const Duration(milliseconds: 100));
  //     networkResumePath = await ResumeStorageService.getNetworkResume();
  //     debugPrint(networkResumePath!);
  //     debugPrint("******************");
  //     await registerController.checkResumeScore(resumeUrl: networkResumePath!);
  //     if (mounted) {
  //       AiLoadingWidget.hide(context);
  //     }
  //     if (registerController.getResponseCode() == 200 ||
  //         registerController.getResponseCode() == 201) {
  //       await getProfileData();
  //     } else {
  //       AppFunctions.apiErrorHandling(
  //         registerController.getResponseCode(),
  //         "Something went wrong!, Try again later",
  //       );
  //     }
  //   } catch (error) {
  //     if (mounted) {
  //       AiLoadingWidget.hide(context);
  //     }
  //     AppFunctions.apiErrorHandling(
  //       registerController.getResponseCode(),
  //       "Something went wrong!, Try again later",
  //     );
  //   } finally {
  //     if (mounted) {
  //       AiLoadingWidget.hide(context);
  //     }
  //   }
  // }

  Future<void> getResumeScore() async {
    networkResumePath = await ResumeStorageService.getNetworkResume();
    // await registerController.checkResumeScore(
    //   resumeUrl:
    //       "https://fulupo.selfietoons.com/uploads/1769402419963-Narmatha M.pdf",
    // );
    print(networkResumePath!);
    print("******************");
    await registerController.checkResumeScore(resumeUrl: networkResumePath!);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      await getProfileData();
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Something went wrong!, Try again later",
      );
    }
  }

  Future<void> getProfileData() async {
    final studentId = await LocalStorageService.getStudentId();
    await registerController.getStudentProfile(studentId: studentId!);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Something went wrong!, Try again later",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        AppFunctions.showAppAlert(
          context: context,
          title: "Are you sure? ⚠️",
          content:
              "This action might not be available again.\n\nIf you go back, you'll be redirected to the Dashboard. Continue?",

          confirmText: "OK, Go Back",
          onConfirm: () {
            Get.offAllNamed(AppRoutes.dashBoardScreen);
          },
        );
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await getResumeScore();
        },
        child: Scaffold(
          backgroundColor: AppColors.appBgColor_2,
          appBar: AppBar(
            backgroundColor: AppColors.transparentColor,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              'Resume Report',
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.whiteColor,
                weight: FontWeight.w600,
              ),
            ),
          ),
          body: Obx(
            () => registerController.resumeScoreLoading || registerController.studentDetailsLoading
                ? Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.secondaryColor,
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      spacing: 15,
                      children: [
                        resumePreview(),
                        buildScoreCard(),
                        buildAllSections(),
                        buildStrengthCard(
                          isStrength: true,
                          list: registerController
                              .resumeAnalyzeModel
                              .analysis!
                              .strengths,
                          title: "Strengths",
                        ),
                        buildStrengthCard(
                          isStrength: false,
                          list: registerController
                              .resumeAnalyzeModel
                              .analysis!
                              .improvements,
                          title: "Improvements",
                        ),
                        buildBottomButtons(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget resumePreview() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: Colors.white,
      ),
      clipBehavior: Clip.hardEdge,
      child: networkResumePath == null || networkResumePath!.isEmpty
          ? Center(
              child: CupertinoActivityIndicator(
                color: AppColors.secondaryColor,
              ),
            )
          : SfPdfViewer.network(
              networkResumePath ?? "",
              canShowScrollHead: false,
              canShowScrollStatus: false,
              enableDoubleTapZooming: false,
              pageLayoutMode: PdfPageLayoutMode.single,
            ),
    );
  }

  Widget buildAllSections() {
    final analysis = registerController.resumeAnalyzeModel.analysis;
    final extracted = registerController.resumeAnalyzeModel.extractedData;

    if (analysis == null || extracted == null) {
      return const SizedBox();
    }

    final sections = analysis.sections.toMap();

    if (sections.isEmpty) {
      return const SizedBox();
    }

    sections.forEach((sectionTitle, sectionDetail) {
      _suggestionSelection.putIfAbsent(sectionTitle, () {
        _initialSuggestions[sectionTitle] = List<String>.from(
          sectionDetail.suggestions,
        );

        return {for (var s in sectionDetail.suggestions) s: true};
      });
    });

    return Column(
      children: sections.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: buildSectionCard(
            title: entry.key,
            sectionData: entry.value,
            extractedData: extracted,
          ),
        );
      }).toList(),
    );
  }

  Widget buildSectionCard({
    required String title,
    required SectionDetail sectionData,
    required ExtractedResumeDataModel extractedData,
  }) {
    final extractedWidget = buildExtractedContent(title, extractedData);

    if (extractedWidget is SizedBox && sectionData.suggestions.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [AppColors.blackGradient1, AppColors.blackGradient2],
        ),
        border: Border.all(color: AppColors.contBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerRow(title, sectionData.rating),
          Divider(color: AppColors.contBorderColor),
          extractedWidget,
          Divider(color: AppColors.contBorderColor),
          buildSuggestions(title, sectionData.suggestions),
        ],
      ),
    );
  }

  Widget buildStrengthCard({
    required List<String> list,
    required String title,
    bool? isStrength,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isStrength! ? AppColors.correctBg : AppColors.inCorrectBg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isStrength
              ? AppColors.correctBorder
              : AppColors.inCorrectBorder,
        ),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppStyles.customTextStyle(
                  size: 16,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
              Icon(
                isStrength
                    ? CupertinoIcons.arrow_up_right_square
                    : CupertinoIcons.arrow_down_left_square,
                color: isStrength
                    ? AppColors.correctText
                    : AppColors.inCorrectText,
                size: 20,
              ),
            ],
          ),
          Column(
            spacing: 10,
            children: list
                .map(
                  (e) => Row(
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.star_outline,
                        color: isStrength
                            ? AppColors.correctText
                            : AppColors.inCorrectText,
                        size: 15,
                      ),
                      Expanded(
                        child: Text(
                          e,
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget headerRow(String title, double rating) {
    return Row(
      spacing: 10,
      children: [
        scoreBoard(score: rating, size: 45),
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyles.customTextStyle(
                size: 16,
                color: AppColors.whiteColor,
                weight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 230,
              child: Text(
                AppFunctions.getSubtitle(key: title, score: rating),
                maxLines: 2,
                softWrap: true,
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildExtractedContent(String title, ExtractedResumeDataModel data) {
    final normalized = title.toLowerCase().replaceAll(" ", "_");

    switch (normalized) {
      case "profile_summary":
        if ((data.profileSummary ?? "").isEmpty) {
          return const SizedBox();
        }
        return Text(
          data.profileSummary!,
          style: AppStyles.customTextStyle(
            size: 12,
            color: Colors.white,
            weight: FontWeight.w600,
          ),
        );

      case "projects":
        if (data.projects == null || data.projects!.isEmpty) {
          return const SizedBox();
        }
        return Column(
          children: data.projects!.map((p) {
            return buildBulletBlock(
              title: p.title ?? '',
              points: p.description.toString(),
            );
          }).toList(),
        );

      case "internships":
        if (data.internships == null || data.internships!.isEmpty) {
          return const SizedBox();
        }
        return Column(
          children: data.internships!.map((i) {
            return buildBulletBlock(
              title: "${i.role ?? ''} • ${i.company ?? ''}",
              subtitle: i.duration,
              points: i.description.toString(),
            );
          }).toList(),
        );

      default:
        return const SizedBox();
    }
  }

  Widget buildBulletBlock({
    required String title,
    String? subtitle,
    required String points,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: AppStyles.customTextStyle(
                size: 12,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "• ",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: Text(
                  points,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    lineSpace: 1.3,
                    color: AppColors.lightColorText,
                    weight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSuggestions(String sectionTitle, List<String> suggestions) {
    final sectionMap = _suggestionSelection[sectionTitle]!;

    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Suggestions",
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     setState(() {
            //       for (var s in _initialSuggestions[sectionTitle]!) {
            //         sectionMap[s] = true;
            //       }
            //     });
            //   },
            //   child: Container(
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: AppColors.primaryColor,
            //     ),
            //     padding: const EdgeInsets.all(2),
            //     child: Icon(
            //       Icons.refresh_sharp,
            //       color: AppColors.whiteColor,
            //       size: 25,
            //     ),
            //   ),
            // ),
          ],
        ),
        ...suggestions.map(
          (s) => Row(
            children: [
              Checkbox(
                activeColor: AppColors.primaryColor,
                value: sectionMap[s] ?? true,
                onChanged: (value) {
                  setState(() {
                    sectionMap[s] = value ?? false;
                  });
                },
              ),
              Expanded(
                child: Text(
                  s,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, List<String>> buildSuggestionPayload() {
    final Map<String, List<String>> payload = {};

    _suggestionSelection.forEach((section, values) {
      final selected = values.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      if (selected.isNotEmpty) {
        payload[_mapSectionKey(section)] = selected;
      }
    });

    return payload;
  }

  String _mapSectionKey(String title) {
    switch (title) {
      case "Experience":
        return "updatedExperience";
      case "Profile Summary":
        return "updatedProfileSummary";
      case "Resume Profile":
        return "updatedProfileSummary";
      case "Projects":
        return "updatedProjects";
      case "Internships":
        return "updateInternships";
      case "Skills":
        return "updatedSkills";
      default:
        return title;
    }
  }

  Widget buildBottomButtons() {
    return Row(
      spacing: 25,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButtonWidget(
          width: 150,
          height: 40,
          buttonFunction: () async {
            // final payload = buildSuggestionPayload();
            // debugPrint(payload.toString());
            registerController
                .resumeAnalyzeModel
                .extractedData!
                .updatedExperience = _suggestionSelection["Experience"]?.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .toList();
            registerController
                .resumeAnalyzeModel
                .extractedData!
                .updatedInternships = _suggestionSelection["Internships"]
                ?.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .toList();
            registerController
                .resumeAnalyzeModel
                .extractedData!
                .updatedProjects = _suggestionSelection["Projects"]?.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .toList();
            registerController
                .resumeAnalyzeModel
                .extractedData!
                .updatedProfileSummary = _suggestionSelection["Profile Summary"]
                ?.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .toList();

            debugPrint(
              registerController.resumeAnalyzeModel.extractedData!.toString(),
            );
            debugPrint(
              registerController
                  .resumeAnalyzeModel
                  .extractedData!
                  .updatedProfileSummary
                  .toString(),
            );
            AppFunctions.showAppAlert(
              context: context,
              title: "Update Resume",
              content:
                  "Updating your resume will consume 50 credits. Are you sure you want to continue?",
              onConfirm: () async {
                await updateResumeFunc();
              },
              confirmText: "Confirm",
              cancelText: "Cancel",
            );
          },
          isLoading: registerController.updateResumeLoading,
          buttonText: "Update",
        ),
        CustomButtonWidget(
          bgColor: AppColors.transparentColor,
          width: 150,
          height: 40,
          isLoading: registerController.updateResumeTemplateLoading,
          buttonFunction: () async {
            await updateSkipProfileFunc();
          },
          buttonText: "Skip",
        ),
      ],
    );
  }

  Future<void> updateSkipProfileFunc() async {
    final studentId = await LocalStorageService.getStudentId();
    registerController.extractedResumeModel.templateNumber != 1.toString();
    registerController.extractedResumeModel.studentId != studentId!;
    await registerController.updateResumeProfileData(
      updateData: registerController.extractedResumeModel,
    );
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message: "Resume updated successfully!",
        isError: false,
      );
      if(mounted) {
        AppFunctions.navigateScreen(
          context,
          AppRoutes.stepUpdateScreen,
          arguments: {"activeStep": 2},
        );
      }
    } else {
      AppFunctions.showToast(
        message:
            registerController.updateProfileModel.message ??
            "Something went wrong!,Please try again later!",
        isError: true,
      );
    }
  }

  Future<void> updateResumeFunc() async {
    try {
      /// ✅ show loader first
      AiLoadingWidget.show(context, type: LoadingDialogType.enhanceResume);

      /// ✅ allow one frame to render loader
      await Future.delayed(const Duration(milliseconds: 100));

      await registerController.updateResumeData(
        updateData: registerController.resumeAnalyzeModel.extractedData!,
      );

      if (registerController.getResponseCode() == 200 ||
          registerController.getResponseCode() == 201) {
        AppFunctions.showToast(
          message: "Resume Updated Successfully!",
          isError: false,
        );

        AppFunctions.navigateScreen(
          context,
          AppRoutes.chatResumeTemplateScreen,
          arguments: {"resumeData": registerController.extractedResumeModel},
        );
      } else {
        AppFunctions.apiErrorHandling(
          registerController.getResponseCode(),
          "Failed to update your resume!",
        );
      }
    } catch (e) {
      debugPrint("Resume update error: $e");

      AppFunctions.showToast(
        message: "Something went wrong while updating resume",
        isError: true,
      );
    } finally {
      /// ✅ always hide loader
      AiLoadingWidget.hide(context);
    }
  }

  Widget buildScoreCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.contBorderColor),
        gradient: LinearGradient(
          colors: [AppColors.blackGradient1, AppColors.blackGradient2],
        ),
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Total Score",
            style: AppStyles.customTextStyle(
              size: 20,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
          Text(
            registerController.resumeAnalyzeModel.analysis != null
                ? "${registerController.resumeAnalyzeModel.analysis!.overallScore ?? "0.0"} / 10"
                : "0.0 / 10",
            style: AppStyles.customTextStyle(
              size: 30,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget scoreBoard({required double score, required double size}) {
    final progress = score / 10;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation(
                  AppColors.primaryColor,
                ),
              ),
            ),

            /// Center Text
            Row(
              spacing: 3,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  score.toStringAsFixed(1),
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  "/10",
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
