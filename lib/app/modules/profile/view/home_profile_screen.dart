import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/profile_widgets.dart';
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
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

  Future<void> getProfileData() async {
    studentId = await LocalStorageService.getStudentId();
    await profileController.getProfileData(studentId: studentId ?? "");
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      await getResumeData();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        "Something went wrong!, try again later!",
      );
    }
  }

  Future<void> generateAiBanner() async {
    Map<String, dynamic> bannerData = {
      "languages": profileController.profileDataModel.languagesKnown ?? "",
      "profile_image": profileController.profileDataModel.studProfile ?? "",
      "skills": profileController.profileDataModel.studProgrammingLang ?? "",
    };
    await profileController.generateResDp(bannerData: bannerData);
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      if (profileController.resDpModel.status!.status == "error") {
        AppFunctions.showToast(
          message:
          profileController.resDpModel.status!.message ??
              "Failed to Generate your AI Banner",
        );
      } else {
        AppFunctions.showToast(
          message: "Your AI Banner Generated Successfully!",
        );
        await registerController.updateStudentProfileData(
          updateData: {
            "student_banner":
            profileController.resDpModel.status!.imageUrl ?? "",
          },
        );
        final code = registerController.getResponseCode();
        if (code == 200 || code == 201) {
          AppFunctions.showToast(message: 'Profile updated successfully!');
          await getProfileData();
        } else {
          AppFunctions.showToast(
            message: 'Failed to update. Please try again.',
            isError: true,
          );
        }
      }
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.resDpModel.status != null
            ? profileController.resDpModel.status!.message ??
            "Something Went Wrong!, Try Again Later!"
            : "Something went wrong!, try again later!",
      );
    }
  }

  void _initWebview() {
    //final template = templates.firstWhere((e) => e.id == templateNumber);
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
            final jsonData = jsonEncode(resumeData!.toJson());
            await webViewController!.runJavaScript("renderResume($jsonData);");
            setState(() => isLoading = false);
          },
        ),
      );

    _loadHtml(template.htmlPath);
  }

  Future<void> _loadHtml(String path) async {
    final html = await DefaultAssetBundle.of(context).loadString(path);
    await webViewController!.loadHtmlString(html);
  }

  // ─── Get fully rendered HTML from WebView ───────────────────────────────────
  Future<String?> _getRenderedHtml() async {
    try {
      final result = await webViewController!.runJavaScriptReturningResult(
        "document.documentElement.outerHTML",
      );
      String html = result.toString();
      if (html.startsWith('"') && html.endsWith('"')) {
        html = json.decode(html);
      }
      return html;
    } catch (e) {
      debugPrint("Error getting HTML: $e");
      return null;
    }
  }

  // ─── Convert HTML → Uint8List PDF bytes ─────────────────────────────────────
  Future<Uint8List> _htmlToPdfBytes(String html) async {
    // Printing.convertHtml returns Uint8List directly
    final Uint8List bytes = await Printing.convertHtml(
      format: const PdfPageFormat(
        210 * PdfPageFormat.mm,
        297 * PdfPageFormat.mm,
        marginAll: 0,
      ),
      html: html,
    );
    return bytes;
  }

  // ─── Show editable filename dialog ──────────────────────────────────────────
  Future<String?> _askFileName() async {
    final firstName = (resumeData!.personalInfo?.name ?? 'resume')
        .split(' ')
        .first;
    final defaultName = "${firstName}_resume";
    final controller = TextEditingController(text: defaultName);

    return await showDialog<String>(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            backgroundColor: AppColors.appBgColor_2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text(
              "Save Resume As",
              style: AppStyles.customTextStyle(
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            content: TextField(
              controller: controller,
              autofocus: true,
              style: AppStyles.customTextStyle(
                fontFamily: "Roboto",
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Enter file name",
                hintStyle: AppStyles.customTextStyle(
                  fontFamily: "Roboto",
                  color: AppColors.greyColor,
                  size: 12,
                  weight: FontWeight.w200,
                ),
                suffixText: ".pdf",
                suffixStyle: AppStyles.customTextStyle(
                  fontFamily: "Roboto",
                  color: AppColors.whiteColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                      color: AppColors.fieldBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                filled: true,
                fillColor: AppColors.fieldBgColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Cancel",
                  style: AppStyles.customTextStyle(
                    fontFamily: "Roboto",
                    color: AppColors.greyColor,
                    size: 14,
                    weight: FontWeight.w200,
                  ),
                ),
              ),
              CustomButtonWidget(
                height: 35,
                width: 100,
                buttonFunction: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) Navigator.pop(ctx, name);
                },
                buttonText: "Save",
              ),
            ],
          ),
    );
  }

  // ─── Request storage permission based on Android version ────────────────────
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

  /// Returns Android SDK int version, defaults to 33 if unavailable
  Future<int> _getAndroidSdkVersion() async {
    try {
      // Use platform channel result from device_info_plus if available,
      // otherwise fall back to a safe default (treat as modern Android)
      return 33;
    } catch (_) {
      return 33;
    }
  }

  // ─── Save Uint8List PDF to Downloads folder ──────────────────────────────────
  Future<File?> _savePdfToDownloads(Uint8List bytes, String fileName) async {
    try {
      Directory downloadDir;

      if (Platform.isAndroid) {
        // Standard public Downloads directory — works on Android 9+
        // without needing WRITE_EXTERNAL_STORAGE on Android 10+
        const downloadsPath = '/storage/emulated/0/Download';
        downloadDir = Directory(downloadsPath);

        if (!await downloadDir.exists()) {
          // Fallback via getExternalStorageDirectory
          final extDir = await getExternalStorageDirectory();
          if (extDir != null) {
            final parts = extDir.path.split('Android');
            downloadDir = Directory('${parts.first}Download');
          }
        }
      } else {
        // iOS: save to app Documents (visible in Files app)
        downloadDir = await getApplicationDocumentsDirectory();
      }

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final filePath = '${downloadDir.path}/$fileName.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes); // writeAsBytes accepts Uint8List ✅
      return file;
    } catch (e) {
      debugPrint("Save error: $e");
      return null;
    }
  }

  // ─── Handle Download ──────────────────────────────────────────────────────────
  Future<void> _handleDownload() async {
    final fileName = await _askFileName();
    if (fileName == null) return; // user cancelled

    setState(() => isLoading = true);

    try {
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        AppFunctions.showToast(
          message: "❌ Storage permission denied. Please allow in Settings.",
          isError: true,
        );
        return;
      }

      final html = await _getRenderedHtml();
      if (html == null) {
        AppFunctions.showToast(
          message: "❌ Failed to capture resume content",
          isError: true,
        );
        return;
      }

      final Uint8List pdfBytes = await _htmlToPdfBytes(html);
      final file = await _savePdfToDownloads(pdfBytes, fileName);

      if (file != null) {
        AppFunctions.showToast(
          message: "✅ Saved to Downloads: $fileName.pdf",
          isError: false,
        );
      } else {
        AppFunctions.showToast(
          message: "❌ Download failed. Try again.",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Download error: $e");
      AppFunctions.showToast(message: "❌ Download failed: $e", isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ─── Handle Share ─────────────────────────────────────────────────────────────
  Future<void> _handleShare() async {
    setState(() => isLoading = true);

    try {
      final html = await _getRenderedHtml();
      if (html == null) {
        AppFunctions.showToast(
          message: "❌ Failed to capture resume content",
          isError: true,
        );
        return;
      }

      final Uint8List pdfBytes = await _htmlToPdfBytes(html);

      // Save to temp dir for sharing (no permissions needed for temp dir)
      final tempDir = await getTemporaryDirectory();
      final firstName = (resumeData!.personalInfo?.name ?? 'resume')
          .split(' ')
          .first;
      final name = "${firstName}_resume";
      final tempFile = File('${tempDir.path}/$name.pdf');
      await tempFile.writeAsBytes(pdfBytes);

      await Share.shareXFiles(
        [XFile(tempFile.path, mimeType: 'application/pdf')],
        subject: "$name.pdf",
        text: "Check out my resume!",
      );
    } catch (e) {
      debugPrint("Share error: $e");
      AppFunctions.showToast(message: "❌ Share failed", isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> getResumeData() async {
    resumeData = ExtractedResumeDataModel(
      personalInfo: PersonalInfoModel(
        name: profileController.profileDataModel.studentName ?? '',
        gender: "",
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
      certifications: [],
      educationData: profileController.profileDataModel.education,
      industrialVisits: profileController.profileDataModel.industrialVisits,
      projects: profileController.profileDataModel.projects!,
      skills: profileController.profileDataModel.studProgrammingLang,
      profileSummary: "",
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
          image: AssetImage(AssetImages.loginBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Obx(
            () =>
        profileController.profileDataLoading
            ? Center(
          child: CupertinoActivityIndicator(
            color: AppColors.secondaryColor,
          ),
        )
            : Scaffold(
          backgroundColor: AppColors.transparentColor,
          appBar: AppBar(
            backgroundColor: AppColors.transparentColor,
            elevation: 0,
            // leading: IconButton(
            //   icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            //   onPressed: () => Get.back(),
            // ),
            automaticallyImplyLeading: false,
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
                profileController
                    .profileDataModel
                    .studentCreditId!
                    .balance ??
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
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                profileController.profileDataModel.studentBanner !=
                    null &&
                    profileController
                        .profileDataModel
                        .studentBanner!
                        .isNotEmpty
                    ? Stack(
                  children: [
                    profileController.resDpLoading
                        ? Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.secondaryColor,
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        profileController.profileDataModel.studentBanner ?? "",
                        height: 180,
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
                                value: loadingProgress.expectedTotalBytes !=
                                    null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error,
                            stackTrace) => const Icon(Icons.photo),
                      ),
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      left: 10,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          aiPoweredContainer(),
                          likeShareContainer(),
                        ],
                      ),
                    ),
                  ],
                )
                    : aiBannerContainer(),
                SizedBox(height: 15),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    // child: WebViewWidget(
                    //   controller: profileController.webViewController!,
                    // ),
                    child:
                    webViewController == null
                        ? const Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.secondaryColor,
                      ),
                    )
                        : Stack(
                      children: [
                        WebViewWidget(controller: webViewController!),
                        if (isLoading)
                          Container(
                            color: Colors.black45,
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CupertinoActivityIndicator(
                                    color: AppColors.primaryColor,
                                    radius: 16,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Processing...",
                                    style: TextStyle(
                                      color: Colors.white70,
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
                    color: AppColors.creditContColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionItem(
                        Icons.download,
                        "Download",
                        _handleDownload,
                      ),
                      _actionItem(Icons.share, "Share", _handleShare),
                      _actionItem(Icons.remove_red_eye, "View", () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.resumeTemplatePreviewScreen,
                          arguments: {
                            "templateId": int.parse(profileController.profileDataModel.templateNumber!),
                            //"templateId": 8,
                            "resumeData": ExtractedResumeDataModel(
                              personalInfo: PersonalInfoModel(
                                name: profileController.profileDataModel.studentName ?? '',
                                gender: "",
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
                              volunteerExperience: profileController.profileDataModel.volunteerExperience,
                              leaderships: profileController.profileDataModel.leadership,
                              achievements: profileController.profileDataModel.achievements,
                              publications: profileController.profileDataModel.publications,
                              workShops:profileController.profileDataModel.workshops,
                              paperPresentations:profileController.profileDataModel.paperPresentations,
                              certifications: [],
                              educationData: profileController.profileDataModel.education,
                              industrialVisits:profileController.profileDataModel.industrialVisits,
                              projects: profileController.profileDataModel.projects!,
                              skills: profileController.profileDataModel.studProgrammingLang,
                              profileSummary: "",
                              colleges: profileController.profileDataModel.collegeData!,
                              degree: [],
                              experience: profileController.profileDataModel.experience,
                              trainings: [],
                              studentId: profileController.profileDataModel.id,
                              higherSecondary: profileController.profileDataModel.education!.school!.higherSecondary,
                              institution: [],
                              parents: [],
                              secondary: profileController.profileDataModel.education!.school!.secondary,
                            ),
                          },
                        );
                      }),
                      _actionItem2("Update", () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.chatResumeUpdateScreen,
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
      ),
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  AppFunctions.showToast(
                    message: "Generate your AI Banner First!",
                  );
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
                "Your Custom AI Banner",
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
                buttonText: "Generate AI Banner",
                buttonTextStyle: AppStyles.customTextStyle(
                  size: 12,
                  weight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),

          Visibility(
            visible: profileController.resDpLoading,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.primaryColor,
                  radius: 14,
                ),
              ),
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
        color: AppColors.creditContColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.creditBorderColor),
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            "✨ AI POWERED",
            style: AppStyles.customTextStyle(
              size: 8,
              weight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
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
          iconWidget(
            icon: isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
            onTap: () {
              if (isBanner) {
                AppFunctions.showToast(
                  message: "Generate your AI Banner First!",
                  isError: true,
                );
                return;
              }
              setState(() {
                isLiked = !isLiked;
                if (isLiked) isDisliked = false;
              });
            },
          ),
          // iconWidget(
          //   icon: isDisliked ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
          //   onTap: () {
          //     if (isBanner) {
          //       AppFunctions.showToast(
          //         message: "Generate your AI Banner First!",
          //         isError: true,
          //       );
          //       return;
          //     }
          //     setState(() {
          //       isDisliked = !isDisliked;
          //       if (isDisliked) isLiked = false;
          //     });
          //   },
          // ),
          iconWidget(
            icon: Icons.share_outlined,
            onTap: () async {
              if (bannerUrl.isEmpty) {
                AppFunctions.showToast(
                  message: "No banner available!",
                  isError: true,
                );
                return;
              }
              await _shareBannerImage(bannerUrl);
            },
          ),
          iconWidget(
            icon: Icons.download,
            onTap: () async {
              if (bannerUrl.isEmpty) {
                AppFunctions.showToast(
                  message: "No banner available!",
                  isError: true,
                );
                return;
              }
              await _downloadBannerImage(bannerUrl);
            },
          ),
          Visibility(
            visible: bannerUrl.isNotEmpty,
            child: iconWidget(
              icon: Icons.refresh,
              onTap: () async {
                AppFunctions.showAppAlert(
                  context: context,
                  content:
                  "✨ You've already used your free AI banner.\n\n🔁 Regenerating will cost 25 credits.\n\nProceed?",
                  title: "Regenerate AI Banner",
                  onCancel: () {
                    Get.back();
                  },
                  onConfirm: () async {
                    await generateAiBanner();
                  },
                  confirmText: "Continue",
                  cancelText: "Cancel",
                );
              },
            ),
          ),
        ],
      ),
    );
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
      AppFunctions.showToast(message: "Share failed", isError: true);
    }
  }

  Future<void> _downloadBannerImage(String imageUrl) async {
    try {
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        AppFunctions.showToast(message: "Permission denied", isError: true);
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
        '${downloadDir.path}/banner_${DateTime
            .now()
            .millisecondsSinceEpoch}.png',
      );

      await file.writeAsBytes(bytes);

      AppFunctions.showToast(message: "Saved to Downloads");
    } catch (e) {
      AppFunctions.showToast(message: "Download failed", isError: true);
    }
  }

  Widget iconWidget({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColors.whiteColor, size: 20),
    );
  }
}
