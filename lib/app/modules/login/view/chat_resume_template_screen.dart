import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
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

  @override
  void initState() {
    super.initState();
    resumeData = Get.arguments["resumeData"];
    templateId = Get.arguments["templateId"];
    isRegisterFlow = Get.arguments["isRegisterFlow"] ?? true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initWebView(templates[currentTemplateIndex]);
    });
    setInitialTemplate();
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
      return;
    }
    if (templateId != null &&
        templateId! > 0 &&
        templateId! <= templates.length) {
      currentTemplateIndex = templateId! - 1;
    } else {
      currentTemplateIndex = 0;
    }
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
        currentTemplateIndex = (currentTemplateIndex + 1) % templates.length;
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
          "Choose any Resume Template",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => registerController.studentDetailsLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.secondaryColor,
                ),
              )
            : Column(
                spacing: 15,
                children: [
                  // ── Credits ────────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                                  registerController
                                      .creditDataModel
                                      .creditData!
                                      .balance ??
                                  0,
                            ),
                      const SizedBox(width: 50),
                    ],
                  ),

                  // ── Thumbnail ──────────────────────────────────────────────
                  SizedBox(
                    height: 300,
                    width: 250,
                    child: registerController.templateRefreshLoading
                        ? Center(
                            child: CupertinoActivityIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : ResumeThumbnailCard(template: template, onTap: () {}),
                  ),

                  // ── Action Bar ─────────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blackGradient1,
                          AppColors.blackGradient2,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Heart
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              isTemplateLiked = !isTemplateLiked;
                            });

                            await templateLikeDislike(
                              templateId: template.id, // ✅ important
                              isLike: isTemplateLiked,
                            );
                          },
                          icon: Icon(
                            isTemplateLiked
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: isTemplateLiked
                                ? Colors.red
                                : AppColors.whiteColor,
                            size: 20,
                          ),
                        ),

                        // ── Share ──────────────────────────────────────────
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
                                  size: 20,
                                ),
                        ),

                        // Preview
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
                            size: 20,
                          ),
                        ),

                        // ── Download ───────────────────────────────────────
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
                                  size: 20,
                                ),
                        ),

                        // Divider
                        Container(
                          height: 20,
                          width: 1.5,
                          color: AppColors.fieldBorderColor,
                        ),
                        const SizedBox(width: 10),

                        // Refresh template
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: FloatingActionButton(
                            elevation: 0,
                            mini: true,
                            backgroundColor: AppColors.primaryColor,
                            onPressed: () {
                              AppAlertUtils.showAppAlert(
                                context: context,
                                title: "Update Resume",
                                content:
                                    "Refresh the next template will consume 25 credits. Are you sure you want to continue?",
                                onConfirm: () async {
                                  await nextTemplate();
                                  _initWebView(templates[currentTemplateIndex]);
                                },
                                confirmText: "Confirm",
                                cancelText: "Cancel",
                              );
                            },
                            child: const Icon(
                              Icons.refresh,
                              color: AppColors.whiteColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

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
                    "Your resume shines! It's perfectly crafted to catch employers' eyes.",
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      lineSpace: 1.3,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomButtonWidget(
                    width: 200,
                    height: 35,
                    isLoading: registerController.updateResumeTemplateLoading,
                    buttonFunction: () async {
                      await updateResumeFunc(template);
                    },
                    buttonText: "CONTINUE",
                    bgColor: AppColors.appBgColor_2,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
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

  Future<void> updateResumeFunc(ResumeTemplateModel template) async {
    debugPrint(registerController.studentRegisterModel.studentToken ?? "");
    final studentId = await LocalStorageService.getStudentId();

    resumeData!.templateNumber = template.id.toString();
    resumeData!.studentId = studentId;
    await registerController.updateResumeProfileData(updateData: resumeData);

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
            arguments: {"activeStep": 2},
          );
        }
      } else {
        // await getProfileData();
        // Get.close(2);
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
