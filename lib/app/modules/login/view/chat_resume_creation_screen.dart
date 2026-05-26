import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/account/create_resume_model.dart';
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/student_profile_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatResumeCreationScreen extends StatefulWidget {
  const ChatResumeCreationScreen({super.key});

  @override
  State<ChatResumeCreationScreen> createState() =>
      _ChatResumeCreationScreenState();
}

class _ChatResumeCreationScreenState extends State<ChatResumeCreationScreen> {
  final TextEditingController chatTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  final RegisterController registerController = Get.find<RegisterController>();

  String? studentId = "";
  TextInputType currentKeyboard = TextInputType.text;

  @override
  void initState() {
    createChatResume(chatData: {"message": ""});
    super.initState();
  }

  Future<void> createChatResume({
    required Map<String, dynamic> chatData,
  }) async {
    String userMessage = chatData["message"] ?? "";

    if (userMessage.isNotEmpty) {
      messages.add(ChatMessage(text: userMessage, isBot: false));
      chatTextController.clear();
      scrollToBottom();
      FocusScope.of(context).unfocus();
    }

    await registerController.createChatResume(chatMessage: chatData);

    if (registerController.getResponseCode() == 200) {
      final reply = registerController.createResumeModel.replyData;

      studentId = reply?.userId ?? "";

      // if (reply?.state == "MOBILE" ||
      //     reply?.state == "MOBILE_OTP" ||
      //     reply?.state == "EMAIL_OTP") {
      //   currentKeyboard = TextInputType.phone;
      // } else {
      //   currentKeyboard = TextInputType.text;
      // }

      if (reply?.response != null) {
        messages.add(ChatMessage(text: reply!.response!, isBot: true));
      }
      if (reply?.state == "COMPLETED") {
        Future.delayed(const Duration(milliseconds: 800), () {
          registerNewStudent();
        });
      }

      scrollToBottom();
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Something went wrong!, Try again later!",
      );
    }
  }

  void scrollToBottom() {
    Timer(Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor_2,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: AppColors.whiteColor,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Create Resume",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () =>
            registerController.studentDetailsLoading ||
                registerController.studentRegisterLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.secondaryColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, i) =>
                            _buildChatBubble(messages[i]),
                      ),
                    ),
                    if (registerController.chatResumeLoading)
                      loadingContainer(),
                    _buildInputArea(currentKeyboard),
                    SizedBox(height: 10),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> registerNewStudent() async {
    final reply = registerController.createResumeModel.replyData;
    Map<String, dynamic> registerData = {
      "studname": reply?.personalInfo?.name ?? "",
      "studemail": reply?.personalInfo?.email ?? "",
      "studmobileno": reply?.personalInfo?.phone ?? "",
      "profile_summary": reply?.profileSummary ?? "",
      "studprogramminglang": reply?.skills ?? [],
      "projects": jsonEncode(
        reply?.projects?.map((e) => e.toJson()).toList() ?? [],
      ),
      "paper_presentations": jsonEncode(
        reply?.paperPresentations?.map((e) => e.toJson()).toList() ?? [],
      ),
      "internships": jsonEncode(
        reply?.internships?.map((e) => e.toJson()).toList() ?? [],
      ),
      "studentcertificate": jsonEncode(
        reply?.certifications?.map((e) => e.toJson()).toList() ?? [],
      ),
      "workshops": jsonEncode(reply?.workshops ?? []),
      "publications": jsonEncode(reply?.publications ?? []),
      "achievements": jsonEncode(reply?.achievements ?? []),
      "leadership": jsonEncode(reply?.leadership ?? []),
      "volunteer_experience": jsonEncode(reply?.volunteerExperience ?? []),
      "languages_known": jsonEncode(reply?.languages ?? []),
      "areas_of_interest": jsonEncode(reply?.areasOfInterest ?? []),
      "hobbies": jsonEncode(reply?.hobbies ?? []),
      "industrial_visits": jsonEncode(reply?.industrialVisits ?? []),
      "linkedIn": reply?.personalInfo!.linkedIn ?? "XXXXX",
      "github": reply?.personalInfo!.github,
      "secondary": jsonEncode([reply?.education!.school?.secondary.toJson()]),
      "higher_secondary": jsonEncode([
        reply?.education!.school?.higherSecondary.toJson(),
      ]),
      "college": jsonEncode(reply?.education!.college ?? []),
      "studentdegree":
          reply?.education!.college != null &&
              reply!.education!.college!.isNotEmpty
          ? reply.education!.college!.first.degree ?? ""
          : "",
      "studentcollegename":
          reply?.education!.college != null &&
              reply!.education!.college!.isNotEmpty
          ? reply.education!.college!.first.institution ?? ""
          : "",
    };

    debugPrint(registerData.toString(), wrapWidth: 1024);
    await registerController.registerNewStudent(registerData: registerData);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
            registerController.studentRegisterModel.message ??
            "Student registered successfully!",
        isError: false,
      );
      final prefs = await SharedPreferences.getInstance();
      await LocalStorageService.saveStudent(
        token: registerController.studentRegisterModel.studentToken!,
        student: registerController.studentRegisterModel.registerData!,
      );
      await prefs.setString(
        LocalStorageService.studentNameKey,
        registerController.studentRegisterModel.registerData!.studentName ?? "",
      );
      await prefs.setString(
        LocalStorageService.tokenKey,
        registerController.studentRegisterModel.studentToken ?? "",
      );
      showAlertDialog();
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.studentRegisterModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }

  Future<void> getStudentProfileData() async {
    await registerController.getStudentProfile(
      studentId: registerController.studentRegisterModel.registerData!.id ?? "",
    );
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      StudentProfileModel? data = registerController.studentProfileModel;
      AppFunctions.navigateScreen(
        context,
        AppRoutes.chatResumeTemplateScreen,
        arguments: {
          "resumeData": ExtractedResumeDataModel(
            personalInfo: PersonalInfoModel(
              name: data.studentName!,
              gender: data.studentGender,
              email: data.studEmail!,
              phone: data.studMobileNo!,
              linkedIn: data.linkedIn,
              github: data.github,
              location: "",
            ),
            internships: data.internships!,
            hobbies: data.hobbies,
            areasOfInterest: data.areasOfInterest,
            languages: data.languagesKnown,
            volunteerExperience: data.volunteerExperience,
            leaderships: data.leadership,
            achievements: data.achievements,
            publications: data.publications,
            workShops: data.workshops,
            paperPresentations: data.paperPresentations,
            certifications: data.studentCertificate,
            educationData: data.education,
            industrialVisits: data.industrialVisits,
            projects: data.projects,
            skills: data.studProgrammingLang,
            profileSummary: data.profileSummary,
            colleges: data.college,
            //degree: data.,
            experience: data.experience,
            trainings: data.trainings,
            studentId: data.id,
            higherSecondary: data.education!.school!.higherSecondary,
            //institution: [],
            //parents: [],
            secondary: data.education!.school!.secondary,
          ),
        },
      );
    }
  }

  Widget _buildChatBubble(ChatMessage msg) {
    bool isBot = msg.isBot;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        spacing: 5,
        crossAxisAlignment: isBot
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            isBot ? "Sharks Bot" : "You",
            style: AppStyles.customTextStyle(
              color: AppColors.chatTextColor,
              size: 12,
              weight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: isBot
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (isBot)
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(AssetImages.aiBotImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isBot
                          ? [AppColors.chatGradient3, AppColors.chatGradient3]
                          : [AppColors.chatGradient1, AppColors.chatGradient2],
                    ),
                    borderRadius: isBot
                        ? BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )
                        : BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                  ),
                  child: Text(
                    msg.text,
                    style: AppStyles.customTextStyle(
                      lineSpace: 1.2,
                      size: 14,
                      weight: FontWeight.w400,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(TextInputType kType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.chatGradient3,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatTextController,
              keyboardType: kType,
              style: AppStyles.customTextStyle(
                size: 14,
                weight: FontWeight.w400,
                color: AppColors.whiteColor,
              ),
              cursorColor: AppColors.primaryColor,
              decoration: InputDecoration(
                hintText: 'Type here...',
                hintStyle: AppStyles.customTextStyle(
                  color: AppColors.chatTextColor,
                  size: 12,
                  weight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
              onSubmitted: (value) async {
                await createChatResume(
                  chatData: {
                    "user_id": studentId,
                    "message": chatTextController.text,
                  },
                );
              },
            ),
          ),
          IconButton(
            icon: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.send_outlined, color: AppColors.whiteColor),
            ),
            onPressed: () async {
              await createChatResume(
                chatData: {
                  "user_id": studentId,
                  "message": chatTextController.text,
                },
              );
              //showAlertDialog();
              //registerNewStudent();
            },
          ),
        ],
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.fieldBgColor,
        title: Image.asset(AssetImages.appAlertImage, height: 30, width: 30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Step 1 Registration Successful! 🎉",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
            Text(
              "Welcome to Internsharks.ai Please complete the remaining steps to continue",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w300,
                lineSpace: 1.3,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          CustomButtonWidget(
            buttonFunction: () async {
              Get.back();
              await getStudentProfileData();
            },
            buttonText: "NEXT",
            width: 150,
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget loadingContainer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "Sharks Bot",
            style: AppStyles.customTextStyle(
              color: AppColors.chatTextColor,
              size: 12,
              weight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(AssetImages.appIconImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.chatGradient3,
                        AppColors.chatGradient3,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Shark Bot typing...",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
