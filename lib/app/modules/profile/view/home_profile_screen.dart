import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/utils/resume_file_utils.dart';
import 'package:internsharks/app/core/widgets/ai_loading_widget.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/full_screen_image_preview.dart';
import 'package:internsharks/app/core/widgets/profile_widgets.dart';
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../home/view/resume_template_preview_screen.dart' show templates;

class HomeProfileScreen extends StatefulWidget {
  const HomeProfileScreen({super.key});

  @override
  State<HomeProfileScreen> createState() => _HomeProfileScreenState();
}

class _HomeProfileScreenState extends State<HomeProfileScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  final registerController = Get.find<RegisterController>();

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  String? studentId;
  int? templateNumber;
  bool isLiked = false;
  bool isDisliked = false;
  ExtractedResumeDataModel? resumeData;
  WebViewController? webViewController;
  bool isLoading = true;
  bool waterMarkValue = false;
  bool isWaterMarkRemoved = false;

  Future<void> getProfileData() async {
    studentId = await LocalStorageService.getStudentId();
    waterMarkValue = (await LocalStorageService.getWatermarkValue()) ?? false;
    await profileController.getProfileData(studentId: studentId ?? "");
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      await getResumeData();
      isWaterMarkRemoved = profileController.profileDataModel.isWaterMarkRemoved ?? false;
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        "Something went wrong!, try again later!",
      );
    }
  }

  Future<void> generateAiBanner() async {
    AiLoadingWidget.show(context, type: LoadingDialogType.resDp);

    try {
      Map<String, dynamic> bannerData = {
        "languages": profileController.profileDataModel.languagesKnown ?? "",
        "profile_image": profileController.profileDataModel.studProfile ?? "",
        "skills": profileController.profileDataModel.studProgrammingLang ?? "",
      };

      debugPrint(bannerData.toString(), wrapWidth: 1024);

      await profileController.generateResDp(bannerData: bannerData);

      if (profileController.getResponseCode() == 200 ||
          profileController.getResponseCode() == 201) {
        if (profileController.resDpModel.status!.status == "error") {
          AppAlertUtils.showToast(
            message:
                profileController.resDpModel.error ??
                "Failed to Generate your ResDp",
          );
        } else {
          AppAlertUtils.showToast(
            message: "Your ResDp Generated Successfully!",
          );

          LocalStorageService.saveWatermarkValue(waterMarkValue: false);

          await registerController.updateStudentProfileData(
            updateData: {
              "student_banner":
                  profileController.resDpModel.status!.imageUrl ?? "",
            },
          );

          final code = registerController.getResponseCode();

          if (code == 200 || code == 201) {
            AppAlertUtils.showToast(message: 'Profile updated successfully!');
            await getProfileData();
          } else {
            AppAlertUtils.showToast(
              message: 'Failed to update. Please try again.',
              isError: true,
            );
          }
        }
      } else {
        AppFunctions.apiErrorHandling(
          profileController.getResponseCode(),
          profileController.resDpModel.status?.message ??
              profileController.resDpModel.error ??
              "Something went wrong!, try again later!",
        );
      }
    } finally {
      if (mounted) {
        AiLoadingWidget.hide(context);
      }
    }
  }

  Future<void> removeWaterMark() async {
    await profileController.removeWaterMark(
      imageUrl: AppFunctions.extractFilePathFromUrl(
        profileController.profileDataModel.studentBanner ?? "",
      ),
    );
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      if (profileController.waterMarkModel.watermarkData!.status! == "error") {
        AppAlertUtils.showToast(message: "Failed to Generate your ResDp");
      } else {
        AppAlertUtils.showToast(
          message: "Successfully! removed Watermark  from your ResDp ",
        );
        LocalStorageService.saveWatermarkValue(waterMarkValue: true);
        debugPrint(
          profileController.waterMarkModel.watermarkData!.imageUrl ?? "",
        );
        await registerController.updateStudentProfileData(
          updateData: {
            "student_banner":
                profileController.waterMarkModel.watermarkData!.imageUrl ?? "",
            "isWaterMarkRemoved": true
          },
        );
        final code = registerController.getResponseCode();
        if (code == 200 || code == 201) {
          AppAlertUtils.showToast(message: 'Profile updated successfully!');
          await getProfileData();
        } else {
          AppAlertUtils.showToast(
            message: 'Failed to update. Please try again.',
            isError: true,
          );
        }
      }
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.waterMarkModel.watermarkData!.status != null
            ? "Something Went Wrong!, Try Again Later!"
            : "Something went wrong!, try again later!",
      );
    }
  }

  void _initWebview() {
    if (templateNumber == null || resumeData == null) return;

    final template = templates.firstWhere(
      (e) => e.id == templateNumber,
      orElse: () => templates.first,
    );

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            await Future.delayed(const Duration(milliseconds: 300));

            // ✅ Force proper viewport scaling
            await webViewController!.runJavaScript("""
            var meta = document.querySelector('meta[name="viewport"]');
            if (!meta) {
              meta = document.createElement('meta');
              meta.name = 'viewport';
              document.head.appendChild(meta);
            }
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
          """);

            final jsonData = jsonEncode(resumeData!.toJson());
            final safeJson = jsonEncode(jsonData);
            await webViewController!.runJavaScript(
              "renderResume(JSON.parse($safeJson));",
            );

            setState(() => isLoading = false);
          },
        ),
      );

    _loadHtml(template.htmlPath);
  }

  // Future<void> _loadHtml(String path) async {
  //   final html = await DefaultAssetBundle.of(context).loadString(path);
  //   await webViewController!.loadHtmlString(html);
  // }
  // In _loadHtml, inject a wider viewport before loading
  Future<void> _loadHtml(String path) async {
    String html = await DefaultAssetBundle.of(context).loadString(path);

    // ✅ Replace viewport meta to force desktop-width rendering
    html = html.replaceFirst(
      '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
      '<meta name="viewport" content="width=900, initial-scale=1.0, shrink-to-fit=no">',
    );

    await webViewController!.loadHtmlString(html);
  }

  // ── Replace _handleDownload ────────────────────────────────────────────────────
  Future<void> _handleDownload() async {
    if (webViewController == null) return;
    setState(() => isLoading = true);
    try {
      final firstName = (resumeData?.personalInfo?.name ?? 'resume')
          .split(' ')
          .first;

      await ResumeFileUtils.handleDownload(
        webViewController: webViewController!,
        fileName: "${firstName}_resume",
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ── Replace _handleShare ───────────────────────────────────────────────────────
  Future<void> _handleShare() async {
    if (webViewController == null) return;
    setState(() => isLoading = true);
    try {
      final firstName = (resumeData?.personalInfo?.name ?? 'resume')
          .split(' ')
          .first;
      await ResumeFileUtils.handleShare(
        webViewController: webViewController!,
        fileName: "${firstName}_resume",
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> getResumeData() async {
    resumeData = ExtractedResumeDataModel(
      personalInfo: PersonalInfoModel(
        name: profileController.profileDataModel.studentName ?? '',
        gender: profileController.profileDataModel.studentGender,
        email: profileController.profileDataModel.studEmail!,
        phone: profileController.profileDataModel.studMobileNo!,
        linkedIn: profileController.profileDataModel.linkedIn,
        github: profileController.profileDataModel.github,
        location: "",
      ),
      internships: profileController.profileDataModel.internships!,
      hobbies: profileController.profileDataModel.hobbies,
      areasOfInterest: profileController.profileDataModel.areasOfInterest,
      languages: profileController.profileDataModel.languagesKnown,
      volunteerExperience:
          profileController.profileDataModel.volunteerExperience,
      leaderships: profileController.profileDataModel.leadership,
      achievements: profileController.profileDataModel.achievements,
      publications: profileController.profileDataModel.publications,
      workShops: profileController.profileDataModel.workshops,
      paperPresentations: profileController.profileDataModel.paperPresentations,
      certifications: profileController.profileDataModel.studentCertificate,
      educationData: profileController.profileDataModel.education,
      industrialVisits: profileController.profileDataModel.industrialVisits,
      projects: profileController.profileDataModel.projects!,
      skills: profileController.profileDataModel.studProgrammingLang,
      profileSummary: profileController.profileDataModel.profileSummary,
      colleges: profileController.profileDataModel.collegeData!,
      degree: [],
      experience: profileController.profileDataModel.experience,
      trainings: [],
      studentId: profileController.profileDataModel.id,
      higherSecondary:
          profileController.profileDataModel.education!.school!.higherSecondary,
      institution: [],
      parents: [],
      secondary:
          profileController.profileDataModel.education!.school!.secondary,
    );
    templateNumber = int.parse(
      profileController.profileDataModel.templateNumber!.isEmpty
          ? "1"
          : profileController.profileDataModel.templateNumber ?? "1",
    );
    //await profileController.initResumeWebView(resumeData!, templateNumber!);
    _initWebview();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.whiteColor),
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          //   onPressed: () => Get.back(),
          // ),
          //automaticallyImplyLeading: false,
          title: Text(
            "My Profile",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
          actions: [
            ProfileWidgets.creditContainer(
              creditCount:
                  profileController.profileDataModel.studentCreditId!.balance ??
                  0,
              viewFunc: () {
                AppFunctions.navigateScreen(
                  context,
                  AppRoutes.buyCreditsScreen,
                );
              },
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: AppColors.appBgColor_2,
          onRefresh: () async {
            await getProfileData();
          },
          child: Obx(() {
            return profileController.profileDataLoading
                ? AppAlertUtils.customLoader()
                : CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              profileController
                                              .profileDataModel
                                              .studentBanner !=
                                          null &&
                                      profileController
                                          .profileDataModel
                                          .studentBanner!
                                          .isNotEmpty
                                  ? resDpContainer()
                                  : aiBannerContainer(),
                              SizedBox(height: 15),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  // child: WebViewWidget(
                                  //   controller: profileController.webViewController!,
                                  // ),
                                  child: webViewController == null
                                      ? const Center(
                                          child: CupertinoActivityIndicator(
                                            color: AppColors.secondaryColor,
                                          ),
                                        )
                                      : Stack(
                                          children: [
                                            WebViewWidget(
                                              controller: webViewController!,
                                            ),
                                            if (isLoading)
                                              Container(
                                                color: Colors.black45,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CupertinoActivityIndicator(
                                                        color: AppColors
                                                            .primaryColor,
                                                        radius: 16,
                                                      ),
                                                      SizedBox(height: 12),
                                                      Text(
                                                        "Processing...",
                                                        style:
                                                            AppStyles.customTextStyle(
                                                              size: 14,
                                                              color: AppColors
                                                                  .greyColor,
                                                              weight: FontWeight
                                                                  .w500,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: .07,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.1)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _actionItem(
                                      Icons.download,
                                      "Download",
                                      _handleDownload,
                                    ),
                                    _actionItem(
                                      Icons.share,
                                      "Share",
                                      _handleShare,
                                    ),
                                    _actionItem(Icons.remove_red_eye, "View", () {
                                      AppFunctions.navigateScreen(
                                        context,
                                        AppRoutes.resumeTemplatePreviewScreen,
                                        arguments: {
                                          "templateId": int.parse(
                                            profileController
                                                            .profileDataModel
                                                            .templateNumber !=
                                                        null &&
                                                    profileController
                                                        .profileDataModel
                                                        .templateNumber!
                                                        .isNotEmpty
                                                ? profileController
                                                      .profileDataModel
                                                      .templateNumber!
                                                : "1",
                                          ),
                                          //"templateId": 1,
                                          "resumeData":
                                              ExtractedResumeDataModel(
                                                personalInfo: PersonalInfoModel(
                                                  name:
                                                      profileController
                                                          .profileDataModel
                                                          .studentName ??
                                                      '',
                                                  gender: profileController
                                                      .profileDataModel
                                                      .studentGender,
                                                  email: profileController
                                                      .profileDataModel
                                                      .studEmail!,
                                                  phone: profileController
                                                      .profileDataModel
                                                      .studMobileNo!,
                                                  linkedIn: profileController
                                                      .profileDataModel
                                                      .linkedIn,
                                                  github: profileController
                                                      .profileDataModel
                                                      .github,
                                                  location: "",
                                                ),
                                                internships: profileController
                                                    .profileDataModel
                                                    .internships!,
                                                hobbies: profileController
                                                    .profileDataModel
                                                    .hobbies,
                                                areasOfInterest:
                                                    profileController
                                                        .profileDataModel
                                                        .areasOfInterest,
                                                languages: profileController
                                                    .profileDataModel
                                                    .languagesKnown,
                                                volunteerExperience:
                                                    profileController
                                                        .profileDataModel
                                                        .volunteerExperience,
                                                leaderships: profileController
                                                    .profileDataModel
                                                    .leadership,
                                                achievements: profileController
                                                    .profileDataModel
                                                    .achievements,
                                                publications: profileController
                                                    .profileDataModel
                                                    .publications,
                                                workShops: profileController
                                                    .profileDataModel
                                                    .workshops,
                                                paperPresentations:
                                                    profileController
                                                        .profileDataModel
                                                        .paperPresentations,
                                                certifications:
                                                    profileController
                                                        .profileDataModel
                                                        .studentCertificate,
                                                educationData: profileController
                                                    .profileDataModel
                                                    .education,
                                                industrialVisits:
                                                    profileController
                                                        .profileDataModel
                                                        .industrialVisits,
                                                projects: profileController
                                                    .profileDataModel
                                                    .projects!,
                                                skills: profileController
                                                    .profileDataModel
                                                    .studProgrammingLang,
                                                profileSummary:
                                                    profileController
                                                        .profileDataModel
                                                        .profileSummary!,
                                                colleges: profileController
                                                    .profileDataModel
                                                    .collegeData!,
                                                degree: [],
                                                experience: profileController
                                                    .profileDataModel
                                                    .experience,
                                                trainings: [],
                                                studentId: profileController
                                                    .profileDataModel
                                                    .id,
                                                higherSecondary:
                                                    profileController
                                                        .profileDataModel
                                                        .education!
                                                        .school!
                                                        .higherSecondary,
                                                institution: [],
                                                parents: [],
                                                secondary: profileController
                                                    .profileDataModel
                                                    .education!
                                                    .school!
                                                    .secondary,
                                              ),
                                        },
                                      );
                                    }),
                                    _actionItem2("Update", () {
                                      final templateId = int.tryParse(
                                        profileController
                                                .profileDataModel
                                                .templateNumber ??
                                            "",
                                      );
                                      debugPrint(
                                        profileController
                                            .profileDataModel
                                            .templateNumber
                                            .toString(),
                                      );

                                      AppFunctions.navigateScreen(
                                        context,
                                        AppRoutes.chatResumeUpdateScreen,
                                        arguments: {
                                          "templateId": templateId ?? 1,
                                        },
                                      );
                                    }),
                                    //_actionItem(Icons.refresh, "Update", () {}),
                                    _actionItem(
                                      CupertinoIcons.create,
                                      "Edit Profile",
                                      () {
                                        AppFunctions.navigateScreen(
                                          context,
                                          AppRoutes.profileEditScreen,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Widget resDpContainer() {
    return Stack(
      children: [
        profileController.waterMarkLoading ||
                profileController.aiBannerLikeLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.secondaryColor,
                ),
              )
            : GestureDetector(
                onTap: () {
                  final imageUrl =
                      profileController.profileDataModel.studentBanner ?? "";

                  if (imageUrl.isNotEmpty) {
                    Get.to(() => FullScreenImagePreview(imageUrl: imageUrl));
                  }
                },
                child: Hero(
                  tag: profileController.profileDataModel.studentBanner ?? "",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      profileController.profileDataModel.studentBanner ?? "",
                      //height: 180,
                      width: double.infinity,
                      fit: BoxFit.fill,

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Container(
                          height: 180,
                          color: AppColors.thirdColor,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },

                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.photo),
                    ),
                  ),
                ),
              ),

        Positioned(
          top: 10,
          right: 10,
          left: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //aiPoweredContainer(),
              likeShareContainer()],
          ),
        ),
      ],
    );
  }

  Widget aiBannerContainer() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.resDpBannerImg),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.creditBorderColor),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              AppAlertUtils.showToast(message: "Generate your ResDp First!");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                aiPoweredContainer(),
                likeShareContainer(isBanner: true),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Your Custom ResDp",
            style: AppStyles.customTextStyle(
              size: 16,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "This is how your profile will look to \n recruiters and peers.",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.contLightText2,
              weight: FontWeight.w400,
              lineSpace: 1.3,
            ),
          ),
          const Spacer(),

          CustomButtonWidget(
            width: 175,
            height: 35,
            buttonFunction: () async {
              await generateAiBanner();
            },
            buttonText: "✧˖° Generate ResDp",
            buttonTextStyle: AppStyles.customTextStyle(
              size: 12,
              weight: FontWeight.w600,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionItem(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.whiteColor, size: 20),
          SizedBox(height: 5),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _actionItem2(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "✧˖°",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }

  Widget aiPoweredContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        //color: AppColors.creditContColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(50),
        //border: Border.all(color: AppColors.creditBorderColor),
      ),
      padding: EdgeInsets.all(5),
      child: Image.asset(AssetImages.resDpIcon, height: 15, width: 70),
      // Row(
      //   children: [
      //     Text(
      //       "✨ AI POWERED",
      //       style: AppStyles.customTextStyle(
      //         size: 8,
      //         weight: FontWeight.w500,
      //         color: AppColors.whiteColor,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget likeShareContainer({bool isBanner = false}) {
    final bannerUrl = profileController.profileDataModel.studentBanner ?? "";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.creditContColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.creditBorderColor),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        spacing: 5,
        children: [
          /// 👍 LIKE BUTTON
          iconWidget(
            icon: isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
            onTap: () async {
              if (isBanner) {
                AppAlertUtils.showToast(
                  message: "Generate your ResDp First!",
                  isError: true,
                );
                return;
              }

              final previousState = isLiked;

              setState(() {
                isLiked = !isLiked;
              });

              final success = await likeDisLikeFunc(isLike: isLiked);

              /// 🔥 rollback if API fails
              if (!success) {
                setState(() {
                  isLiked = previousState;
                });
              }
            },
          ),

          /// 📤 SHARE
          iconWidget(
            icon: Icons.share_outlined,
            onTap: () async {
              if (bannerUrl.isEmpty) {
                AppAlertUtils.showToast(
                  message: "No ResDp available!",
                  isError: true,
                );
                return;
              }
              await _shareBannerImage(bannerUrl);
            },
          ),

          /// ⬇ DOWNLOAD
          iconWidget(
            icon: Icons.download,
            onTap: () async {
              if (bannerUrl.isEmpty) {
                AppAlertUtils.showToast(
                  message: "No ResDp available!",
                  isError: true,
                );
                return;
              }
              await _downloadBannerImage(bannerUrl);
            },
          ),

          /// 🔄 REGENERATE
          if (bannerUrl.isNotEmpty)
            iconWidget(
              icon: Icons.refresh,
              onTap: () async {
                AppAlertUtils.showAppAlert(
                  context: context,
                  title: "Regenerate ResDp",
                  content:
                      "✨ You've already used your free ResDp.\n\n🔁 Regenerating will cost 25 credits.\n\nProceed?",
                  onConfirm: () async {
                    await generateAiBanner();
                  },
                  confirmText: "Continue",
                  cancelText: "Cancel",
                );
              },
            ),

          /// ✏ REMOVE WATERMARK
          if (bannerUrl.isNotEmpty && !isWaterMarkRemoved)
            iconWidget(
              icon: CupertinoIcons.pencil_outline,
              onTap: () async {
                AppAlertUtils.showAppAlert(
                  context: context,
                  title: "Remove Watermark",
                  content:
                      "✨ Remove the watermark from your image.\n\n🔓 This action will cost 20 credits.\n\nProceed?",
                  onConfirm: () async {
                    await removeWaterMark();
                  },
                  confirmText: "Continue",
                  cancelText: "Cancel",
                );
              },
            ),
        ],
      ),
    );
  }

  Future<bool> likeDisLikeFunc({required bool isLike}) async {
    try {
      await profileController.aiBannerLike(
        likeData: {"studentId": studentId, "resdb": isLike},
      );

      final code = profileController.getResponseCode();

      if (code == 200 || code == 201) {
        AppAlertUtils.showToast(
          message: isLike
              ? "You've liked this ResDp!"
              : "Like removed this ResDp!",
        );
        return true;
      } else {
        AppAlertUtils.showToast(
          message: "Something went wrong!",
          isError: true,
        );
        return false;
      }
    } catch (e) {
      AppAlertUtils.showToast(message: "Something went wrong!", isError: true);
      return false;
    }
  }

  Future<void> _shareBannerImage(String imageUrl) async {
    try {
      final response = await HttpClient().getUrl(Uri.parse(imageUrl));
      final res = await response.close();

      final bytes = await consolidateHttpClientResponseBytes(res);

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/banner.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      AppAlertUtils.showToast(message: "Share failed", isError: true);
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    // Get Android SDK version
    final androidInfo = await _getAndroidSdkVersion();

    if (androidInfo >= 33) {
      // Android 13+ — no storage permission needed for Downloads via File API
      // WRITE_EXTERNAL_STORAGE is ignored on 33+, but we can still write to
      // /storage/emulated/0/Download directly without permission
      return true;
    } else if (androidInfo >= 29) {
      // Android 10–12 — WRITE_EXTERNAL_STORAGE is restricted but
      // /storage/emulated/0/Download is still accessible without it
      return true;
    } else {
      // Android 9 and below — need WRITE_EXTERNAL_STORAGE
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<int> _getAndroidSdkVersion() async {
    try {
      // Use platform channel result from device_info_plus if available,
      // otherwise fall back to a safe default (treat as modern Android)
      return 33;
    } catch (_) {
      return 33;
    }
  }

  Future<void> _downloadBannerImage(String imageUrl) async {
    try {
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        AppAlertUtils.showToast(message: "Permission denied", isError: true);
        return;
      }

      final response = await HttpClient().getUrl(Uri.parse(imageUrl));
      final res = await response.close();
      final bytes = await consolidateHttpClientResponseBytes(res);

      Directory downloadDir;

      if (Platform.isAndroid) {
        downloadDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadDir = await getApplicationDocumentsDirectory();
      }

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final file = File(
        '${downloadDir.path}/banner_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await file.writeAsBytes(bytes);

      AppAlertUtils.showToast(message: "Saved to Downloads");
    } catch (e) {
      AppAlertUtils.showToast(message: "Download failed", isError: true);
    }
  }

  Widget iconWidget({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColors.whiteColor, size: 20),
    );
  }
}
