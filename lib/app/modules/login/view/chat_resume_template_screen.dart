import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/profile_widgets.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/resume_template_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/utils/app_functions.dart' show AppFunctions;
import '../../../core/utils/resume_file_utils.dart';
import '../../../core/widgets/resume_thumbnail_card.dart';

class ChatResumeTemplateScreen extends StatefulWidget {
  const ChatResumeTemplateScreen({super.key});

  @override
  State<ChatResumeTemplateScreen> createState() =>
      _ChatResumeTemplateScreenState();
}

class _ChatResumeTemplateScreenState extends State<ChatResumeTemplateScreen> {
  ExtractedResumeDataModel? resumeData;
  bool? isRegisterFlow;

  final RegisterController registerController = Get.find<RegisterController>();
  final ProfileController profileController = Get.find<ProfileController>();

  int currentTemplateIndex = 0;
  int? templateId;

  // ── loading flags for share/download ────────────────────────────────────────
  bool _isDownloading = false;
  bool _isSharing = false;

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

  String studentId = "";
  bool isTemplateLiked = false;

  WebViewController? webViewController;
  bool isWebLoaded = false;

  List<int> templateHistory = [];
  int latestGeneratedTemplateIndex = 0;

  @override
  void initState() {
    super.initState();

    resumeData = Get.arguments["resumeData"];
    templateId = Get.arguments["templateId"];
    isRegisterFlow = Get.arguments["isRegisterFlow"] ?? true;

    /// FIRST set correct template
    setInitialTemplate();

    /// THEN initialize webview
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initWebView(
        templates[currentTemplateIndex],
      );
    });

    getProfileData();
  }

  void _initWebView(ResumeTemplateModel template) async {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            final jsonData = jsonEncode(resumeData!.toJson());
            final safeJson = jsonEncode(jsonData);

            await webViewController!.runJavaScript(
              "renderResume(JSON.parse($safeJson));",
            );

            isWebLoaded = true;
          },
        ),
      );

    String html = await DefaultAssetBundle.of(
      context,
    ).loadString(template.htmlPath);

    html = html.replaceFirst(
      '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
      '<meta name="viewport" content="width=900, initial-scale=1.0, shrink-to-fit=no">',
    );

    await webViewController!.loadHtmlString(html);
  }

  void setInitialTemplate() {
    if (isRegisterFlow == true) {
      currentTemplateIndex = 0;
      latestGeneratedTemplateIndex = 0;

      templateHistory.add(currentTemplateIndex);

      return;
    }

    if (templateId != null &&
        templateId! > 0 &&
        templateId! <= templates.length) {
      currentTemplateIndex = templateId! - 1;

      latestGeneratedTemplateIndex = currentTemplateIndex;
    } else {
      currentTemplateIndex = 0;
      latestGeneratedTemplateIndex = 0;
    }

    templateHistory.add(currentTemplateIndex);
  }

  Future<void> getProfileData() async {
    studentId = (await LocalStorageService.getStudentId())!;
    await registerController.getStudentProfile(studentId: studentId);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      creditIdString =
          registerController.studentProfileModel.studentCreditId!.cId ?? "";
      await getCreditData(creditId: creditIdString);
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Something went wrong!, try again later!",
      );
    }
  }

  String creditIdString = "";

  Future<void> getCreditData({required String creditId}) async {
    await registerController.getCreditData(creditId: creditId);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      creditIdString = registerController.creditDataModel.creditData!.id ?? "";
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Something went wrong!, Try again later!",
      );
    }
  }

  Future<void> nextTemplate() async {
    await registerController.templateRefreshCredit();

    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      await getCreditData(creditId: creditIdString);

      setState(() {
        /// move to next generated template
        latestGeneratedTemplateIndex =
            (latestGeneratedTemplateIndex + 1) % templates.length;

        /// preview newly generated template
        currentTemplateIndex = latestGeneratedTemplateIndex;

        /// store ALL generated templates including current
        if (!templateHistory.contains(currentTemplateIndex)) {
          templateHistory.add(currentTemplateIndex);
        }
      });
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Something went wrong!, Try again later!",
      );
    }
  }

  // ── Load the HTML asset for the current template and inject resume data ──────
  Future<String> _buildResumeHtml(ResumeTemplateModel template) async {
    String html = await DefaultAssetBundle.of(
      context,
    ).loadString(template.htmlPath);

    // Replace the 900px viewport with A4-friendly width before PDF conversion
    html = html.replaceFirst(
      '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
      '<meta name="viewport" content="width=900, initial-scale=1.0, shrink-to-fit=no">',
    );

    return html;
  }

  // ── Download handler ─────────────────────────────────────────────────────────
  Future<void> _handleDownload() async {
    if (webViewController == null || !isWebLoaded) return;

    final firstName = (resumeData?.personalInfo?.name ?? 'resume')
        .split(' ')
        .first;
    await ResumeFileUtils.handleDownload(
      webViewController: webViewController!,
      fileName: "${firstName}_resume",
    );
  }

  // ── Share handler ────────────────────────────────────────────────────────────
  Future<void> _handleShare() async {
    if (webViewController == null || !isWebLoaded) return;

    final firstName = (resumeData?.personalInfo?.name ?? 'resume')
        .split(' ')
        .first;

    await ResumeFileUtils.handleShare(
      webViewController: webViewController!,
      fileName: "${firstName}_resume",
    );
  }

  @override
  Widget build(BuildContext context) {
    final template = templates[currentTemplateIndex];

    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.transparentColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Resume Template",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
        actions: [
          registerController.creditDataLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.secondaryColor,
                  ),
                )
              : ProfileWidgets.creditContainer(
                  viewFunc: () {
                    AppFunctions.navigateScreen(
                      context,
                      AppRoutes.buyCreditsScreen,
                    );
                  },
                  creditCount:
                      registerController.creditDataModel.creditData!.balance ??
                      0,
                ),
          const SizedBox(width: 10),
        ],
      ),
      body: Obx(
        () => registerController.studentDetailsLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.secondaryColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  spacing: 15,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        spacing: 15,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: registerController.templateRefreshLoading
                                  ? Center(
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : ResumeThumbnailCard(
                                      template: template,
                                      onTap: () {
                                        AppFunctions.navigateScreen(
                                          context,
                                          AppRoutes.resumeTemplateViewScreen,
                                          arguments: {
                                            "templateData": template,
                                            "resumeData": resumeData,
                                            "isChatFlow": true,
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ),
                          actionBar(template: template),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            spacing: 10,
                            children: [
                              Text(
                                "Wow! Your Ready to Impress..!",
                                textAlign: TextAlign.center,
                                style: AppStyles.customTextStyle(
                                  size: 16,
                                  weight: FontWeight.w600,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                              Text(
                                "Your resume shines! It's perfectly crafted to catch employers' eyes. highlighting your unique strengths and achievements. You're ready to make a powerful impression!",
                                textAlign: TextAlign.center,
                                style: AppStyles.customTextStyle(
                                  size: 14,
                                  lineSpace: 1.3,
                                  color: AppColors.whiteColor,
                                  weight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          CustomButtonWidget(
                            width: double.infinity,
                            height: 45,
                            isLoading:
                                registerController.updateResumeTemplateLoading,
                            buttonFunction: () async {
                              await updateResumeFunc();
                            },
                            buttonText: "CONTINUE",
                            bgColor: AppColors.appBgColor_2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget actionBar({required ResumeTemplateModel template}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 20,
      children: [
        /// Undo History
        if (templateHistory.isNotEmpty)
          SizedBox(
            height: 75,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: templateHistory.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final historyIndex = templateHistory[index];
                final historyTemplate = templates[historyIndex];

                final bool isSelected = currentTemplateIndex == historyIndex;

                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      currentTemplateIndex = historyIndex;
                    });

                    _initWebView(templates[currentTemplateIndex]);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 60,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.transparentColor,
                        width: 2,
                      ),
                      color: Colors.black12,
                    ),
                    child: Stack(
                      children: [
                        /// Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            historyTemplate.thumbnailPath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),

                        /// Template Number
                        Positioned(
                          top: 3,
                          right: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${historyIndex + 1}",
                              style: AppStyles.customTextStyle(
                                size: 9,
                                color: AppColors.whiteColor,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        /// Main Action Bar
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.blackGradient1, AppColors.blackGradient2],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Like
              IconButton(
                onPressed: () async {
                  setState(() {
                    isTemplateLiked = !isTemplateLiked;
                  });

                  await templateLikeDislike(
                    templateId: template.id,
                    isLike: isTemplateLiked,
                  );
                },
                icon: Icon(
                  isTemplateLiked
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: isTemplateLiked ? Colors.red : AppColors.whiteColor,
                ),
              ),

              /// Share
              IconButton(
                onPressed: _isSharing ? null : _handleShare,
                icon: _isSharing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CupertinoActivityIndicator(
                          color: AppColors.whiteColor,
                        ),
                      )
                    : const Icon(
                        CupertinoIcons.share,
                        color: AppColors.whiteColor,
                      ),
              ),

              /// Preview
              IconButton(
                onPressed: () {
                  AppFunctions.navigateScreen(
                    context,
                    AppRoutes.resumeTemplateViewScreen,
                    arguments: {
                      "templateData": template,
                      "resumeData": resumeData,
                      "isChatFlow": true,
                    },
                  );
                },
                icon: const Icon(
                  CupertinoIcons.eye,
                  color: AppColors.whiteColor,
                ),
              ),

              /// Download
              IconButton(
                onPressed: _isDownloading ? null : _handleDownload,
                icon: _isDownloading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CupertinoActivityIndicator(
                          color: AppColors.whiteColor,
                        ),
                      )
                    : const Icon(
                        CupertinoIcons.arrow_down_doc,
                        color: AppColors.whiteColor,
                      ),
              ),

              Container(height: 20, width: 1.5, color: AppColors.whiteColor),

              const SizedBox(width: 10),

              /// Refresh
              SizedBox(
                height: 35,
                width: 50,
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  elevation: 0,
                  mini: true,
                  backgroundColor: AppColors.primaryColor,
                  onPressed: () async {
                    await nextTemplate();

                    _initWebView(templates[currentTemplateIndex]);
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: AppColors.whiteColor,
                    size: 30,
                  ),
                ),
              ),

              Image.asset(AssetImages.creditsIconNew, height: 28, width: 28),

              Text(
                "25",
                style: AppStyles.customTextStyle(
                  size: 16,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> templateLikeDislike({
    required int templateId,
    required bool isLike,
  }) async {
    try {
      await profileController.aiBannerLike(
        likeData: {
          "studentId": studentId,
          "templates": {"templateId": templateId, "liked": isLike},
        },
      );

      if (registerController.getResponseCode() == 200 ||
          registerController.getResponseCode() == 201) {
        AppAlertUtils.showToast(
          message: isLike ? "❤️ Template Liked!" : "💔 Template Unliked!",
        );
      } else {
        AppAlertUtils.showToast(
          message: "Something went wrong!, Try again later!",
        );
      }
    } catch (e) {
      AppAlertUtils.showToast(
        message: "Something went wrong!, Try again later!",
      );
    }
  }

  Future<void> updateResumeFunc() async {

    debugPrint(
      "PREVIEW TEMPLATE INDEX => $currentTemplateIndex",
    );

    debugPrint(
      "LATEST GENERATED TEMPLATE INDEX => "
          "$latestGeneratedTemplateIndex",
    );

    final studentId =
    await LocalStorageService.getStudentId();

    /// ALWAYS SAVE LATEST GENERATED TEMPLATE
    final selectedTemplate =
    templates[latestGeneratedTemplateIndex];

    resumeData!.templateNumber =
        selectedTemplate.id.toString();

    debugPrint(
      "FINAL templateNumber => "
          "${resumeData!.templateNumber}",
    );

    resumeData!.studentId = studentId;

    await registerController.updateResumeProfileData(
      updateData: resumeData,
    );

    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {

      AppAlertUtils.showToast(
        message: "Resume updated successfully!",
        isError: false,
      );

      await registerController.getStudentProfile(
        studentId: resumeData!.studentId ?? "",
      );

      if (isRegisterFlow!) {

        if (mounted) {
          AppFunctions.navigateScreen(
            context,
            AppRoutes.stepUpdateScreen,
            arguments: {
              "activeStep": 2,
            },
          );
        }

      } else {

        if (mounted) {
          AppFunctions.navigateInitialScreen(
            context,
            AppRoutes.dashBoardScreen,
          );
        }
      }

    } else {

      AppAlertUtils.showToast(
        message:
        registerController.updateProfileModel.message ??
            "Something went wrong!",
        isError: true,
      );
    }
  }
}
