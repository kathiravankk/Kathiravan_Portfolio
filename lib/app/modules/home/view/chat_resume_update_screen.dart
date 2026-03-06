import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/models/account/create_resume_model.dart';
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/home/controller/profile_controller.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

import '../../../data/models/account/student_profile_model.dart';

class ChatResumeUpdateScreen extends StatefulWidget {
  const ChatResumeUpdateScreen({super.key});

  @override
  State<ChatResumeUpdateScreen> createState() => _ChatResumeUpdateScreenState();
}

class _ChatResumeUpdateScreenState extends State<ChatResumeUpdateScreen> {
  final TextEditingController chatTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  final RegisterController registerController = Get.find<RegisterController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  List<String> availableOptions = [];
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    getInitialChatData();
  }

  // ================= INITIAL LOAD =================

  Future<void> getInitialChatData() async {
    Map<String, dynamic> resumeData = {
      "personal_info": {
        "name": profileController.profileDataModel.studentName,
        "gender": "",
        "email": profileController.profileDataModel.studEmail,
        "phone": profileController.profileDataModel.studMobileNo,
        "linkedIn": profileController.profileDataModel.linkedIn,
        "github": profileController.profileDataModel.github,
      },
      "profile_summary": profileController.profileDataModel.studProfile ?? "",
      "skills": profileController.profileDataModel.studProgrammingLang ?? [],
      "projects": profileController.profileDataModel.projects != null
          ? profileController.profileDataModel.projects!
                .map((e) => e.toJson())
                .toList()
          : [],

      "experience": profileController.profileDataModel.experience != null
          ? profileController.profileDataModel.experience!
                .map((e) => e.toJson())
                .toList()
          : [],

      "internships": profileController.profileDataModel.internships != null
          ? profileController.profileDataModel.internships!
                .map((e) => e.toJson())
                .toList()
          : [],

      "education": profileController.profileDataModel.education?.toJson(),
    };

    await dashboardController.getUpdateResumeData(resumeData: resumeData);

    if (dashboardController.getResponseCode() == 200 ||
        dashboardController.getResponseCode() == 201) {
      final ats = dashboardController.updateChatModel.atsResult;

      messages.add(ChatMessage(text: ats?.response ?? "", isBot: true));

      availableOptions = ats?.option ?? [];

      setState(() {});
    } else {
      AppFunctions.apiErrorHandling(
        dashboardController.getResponseCode(),
        "Something went wrong!, Tyr again later!",
      );
    }
  }

  // ================= CHAT SEND =================

  Future<void> updateChatResume({required String message}) async {
    if (message.isEmpty) return;

    messages.add(ChatMessage(text: message, isBot: false));
    chatTextController.clear();
    scrollToBottom();
    FocusScope.of(context).unfocus();

    await dashboardController.updateChatResumeData(
      resumeData: {
        "user_id": dashboardController.updateChatModel.atsResult?.userId ?? "",
        "message": message,
      },
    );

    if (dashboardController.getResponseCode() == 200 ||
        dashboardController.getResponseCode() == 201) {
      final ai = dashboardController.updateChatResumeModel.aiResponse;

      String botResponse = ai?.response ?? "";

      if (botResponse.isNotEmpty) {
        messages.add(ChatMessage(text: botResponse, isBot: true));
      }
      if (ai?.option != null && ai!.option!.isNotEmpty) {
        availableOptions = ai.option!;
      } else {
        availableOptions.clear();
      }

      setState(() {});
      scrollToBottom();

      //if (botResponse.contains("Chat ended")) {
      if (ai?.status == "completed") {
        Future.delayed(const Duration(milliseconds: 800), () {
          availableOptions.clear();
          selectedOptions.clear();
          updateStudentProfile();
        });
      }
    } else {
      AppFunctions.apiErrorHandling(
        dashboardController.getResponseCode(),
        "Something went wrong!, try again later!",
      );
    }
  }

  Future<void> updateStudentProfile() async {
    ReplyData? profileData =
        dashboardController.updateChatResumeModel.aiResponse!.finalUpdatedData;
    Map<String, dynamic> updateData = {
      "studmobileno": profileData!.personalInfo!.phone,

      "studemail": profileData.personalInfo!.email,

      "studname": profileData.personalInfo!.name,
      "studgender": profileData.personalInfo!.gender ?? "",

      "studdob": "",

      "studentaddress": profileData.personalInfo!.location,

      "studentdegree": profileData.education!.college!.isNotEmpty
          ? profileData.education!.college!.first.degree ?? ""
          : "",

      "studentfieldofstudy":
          profileData.education!.college!.first.department ?? "",

      "studentcollegename":
          profileData.education!.college!.first.institution ?? "",

      "studcollegestartyear":
          profileData.education!.college!.first.startYear?.toString() ?? "",
      "studcollegelocation": "",

      "studhighschollname":
          profileData.education!.school!.higherSecondary.institution ?? "",

      "studhighschoolpercentage":
          profileData.education!.school!.higherSecondary.percentage
              ?.toString() ??
          "",

      "studentsecondaryschoolname":
          profileData.education!.school!.secondary.institution ?? "",

      "studentsecondaryschoolpercentage":
          profileData.education!.school!.secondary.percentage?.toString() ?? "",

      "projects": jsonEncode(
        profileData.projects?.map((e) => e.toJson()).toList() ?? [],
      ),

      "areas_of_interest": jsonEncode(profileData.areasOfInterest ?? []),

      "hobbies": jsonEncode(profileData.hobbies ?? []),

      "languages_known": jsonEncode(profileData.languages ?? []),

      "volunteer_experience": jsonEncode(profileData.volunteerExperience ?? []),

      "leadership": jsonEncode(profileData.leadership ?? []),

      "achievements": jsonEncode(profileData.achievements ?? []),

      "publications": jsonEncode(profileData.publications ?? []),

      "workshops": jsonEncode(profileData.workshops ?? []),

      "paper_presentations": [],

      "tools_and_technologies": jsonEncode([]),

      "experience": jsonEncode(
        profileData.experience?.map((e) => e.toJson()).toList() ?? [],
      ),

      "internships": jsonEncode(profileData.internships ?? []),

      "industrial_visits": jsonEncode(profileData.industrialVisits ?? []),

      "trainings": jsonEncode([]),

      "education": jsonEncode(profileData.education!.toJson()),

      "studprogramminglang": jsonEncode(profileData.skills ?? []),

      "linkedIn": profileData.personalInfo!.linkedIn ?? "",

      "github": profileData.personalInfo!.github ?? "",

      "portfolio_website": "",

      "student_banner": "",
    };
    debugPrint(updateData.toString());
    await registerController.updateStudentProfileData(updateData: updateData);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      StudentProfileModel studentData =
          registerController.updateProfileModel.profileUpdateData!;
      AppFunctions.navigateScreen(
        context,
        AppRoutes.chatResumeTemplateScreen,
        arguments: {
          "resumeData": ExtractedResumeDataModel(
            personalInfo: PersonalInfoModel(
              name: studentData.studentName!,
              gender: "",
              email: studentData.studEmail!,
              phone: studentData.studMobileNo!,
              linkedIn: studentData.linkedIn,
              github: studentData.github,
              location: "",
            ),
            internships: studentData.internships!,
            hobbies: studentData.hobbies,
            areasOfInterest: studentData.areasOfInterest,
            languages: studentData.languagesKnown,
            volunteerExperience: studentData.volunteerExperience,
            leaderships: studentData.leadership,
            achievements: studentData.achievements,
            publications: studentData.publications,
            workShops: studentData.workshops,
            paperPresentations: studentData.paperPresentations,
            certifications: [],
            educationData: studentData.education,
            industrialVisits: studentData.industrialVisits,
            projects: studentData.projects,
            skills: studentData.studProgrammingLang,
            profileSummary: "",
            colleges: studentData.college,
            degree: [],
            experience: studentData.experience,
            trainings: [],
            studentId: studentData.id,
            higherSecondary: studentData.education!.school!.higherSecondary,
            institution: [],
            parents: [],
            secondary: studentData.education!.school!.secondary,
          ),
          "isRegisterFlow": false,
        },
      );
    }
  }

  // ================= SEND SELECTED OPTIONS =================

  Future<void> sendSelectedOptions() async {
    if (selectedOptions.isEmpty) return;

    final message = selectedOptions.join(", ");

    setState(() {
      availableOptions.clear();
      selectedOptions.clear();
    });

    await updateChatResume(message: message);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor_2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: AppColors.whiteColor,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        title: Text(
          "Update Resume",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => dashboardController.getUpdateChatLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.secondaryColor,
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, i) =>
                                _buildChatBubble(messages[i]),
                          ),
                        ),
                        if (dashboardController.resumeUpdateChatLoading)
                          loadingContainer(),
                        if (availableOptions.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _buildOptionsChips(),
                          ),

                        _buildInputArea(),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: registerController.updateProfileLoading,
                    child: Positioned(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CupertinoActivityIndicator(
                              color: AppColors.secondaryColor,
                            ),
                            Text(
                              "AI Updating your resume..!",
                              textAlign: TextAlign.center,
                              style: AppStyles.customTextStyle(
                                size: 14,
                                weight: FontWeight.w600,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ================= OPTIONS CHIPS =================

  Widget _buildOptionsChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableOptions.map((option) {
        final isSelected = selectedOptions.contains(option);

        return GestureDetector(
          onTap: () async {
            selectedOptions = [option];
            await sendSelectedOptions();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.chatGradient3,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              option.replaceAll("_", " "),
              style: AppStyles.customTextStyle(
                size: 13,
                weight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ================= INPUT AREA =================

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.chatGradient3,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatTextController,
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
                ),
                border: InputBorder.none,
              ),
              onSubmitted: (value) async {
                if (selectedOptions.isNotEmpty) {
                  await sendSelectedOptions();
                } else {
                  await updateChatResume(message: chatTextController.text);
                }
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
              child: const Icon(
                Icons.send_outlined,
                color: AppColors.whiteColor,
              ),
            ),
            onPressed: () async {
              if (selectedOptions.isNotEmpty) {
                await sendSelectedOptions();
              } else {
                await updateChatResume(message: chatTextController.text);
              }
              //await updateStudentProfile();
            },
          ),
        ],
      ),
    );
  }

  // ================= CHAT BUBBLE =================

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
            isBot ? "Shark Bot" : "You",
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

  Widget loadingContainer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "Shark Bot",
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
                    "Shark AI typing...",
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

  // ================= SCROLL =================

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
