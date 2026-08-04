import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/ai_chat_utils.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/core/widgets/show_template_view.dart';
import 'package:internsharks/app/data/models/account/chat_mcq_question_model.dart'
    hide QuestionOptions;
import 'package:internsharks/app/data/models/account/chat_mcq_result_model.dart';
import 'package:internsharks/app/data/models/account/create_new_resume_model.dart';
import 'package:internsharks/app/data/models/account/create_resume_model.dart';
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/student_profile_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/modules/login/controllers/student_login_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// Section <-> quiz-section-code mapping (only these 5 sections gate a quiz)
// ============================================================================
const Map<String, String> kQuizGatedSections = {
  "skills_completed": "skill",
  "internships_completed": "internship",
  "projects_completed": "project",
  "paper_presentations_completed": "paperpresentation",
  "certifications_completed": "certification",
};

const Map<String, String> kQuizSectionLabel = {
  "skill": "Skills",
  "internship": "Internships",
  "project": "Projects",
  "paperpresentation": "Paper Presentations",
  "certification": "Certifications",
};

class ChatNewResumeCreationScreen extends StatefulWidget {
  const ChatNewResumeCreationScreen({super.key});

  @override
  State<ChatNewResumeCreationScreen> createState() =>
      _ChatNewResumeCreationScreenState();
}

class _ChatNewResumeCreationScreenState
    extends State<ChatNewResumeCreationScreen> {
  final StudentLoginController loginController =
      Get.find<StudentLoginController>();
  final RegisterController registerController = Get.find<RegisterController>();

  final TextEditingController chatTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode chatFocusNode = FocusNode();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxInt currentTabIndex = 0.obs; // 0 Chat, 1 Live Preview, 2 Sections

  List<String> availableOptions = [];
  List<String> selectedOptions = [];

  String? userId = "";

  // Set of completed sections received from chat backend
  final Set<String> _completedSections = {};
  final Set<String> _handledCompletionSignatures = {};

  bool _quizDialogOpen = false;
  bool isInitialLoading = true;

  // Section Form Field Controllers (Reused from Profile Edit Screen)
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();
  final _summaryCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  final _languagesCtrl = TextEditingController();
  final _hobbiesCtrl = TextEditingController();
  final _interestsCtrl = TextEditingController();

  // College Controllers
  final _degreeCtrl = TextEditingController();
  final _institutionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Automatically sync text controllers whenever GetX updates the resume model
    ever(loginController.createNewResumeModel.obs, (_) {
      _syncControllersFromCollectedData(
        loginController.createNewResumeModel.collectedData,
      );
    });

    createChatResume(reqData: {"action": "start_chat"}, isChatStarted: true);
  }

  @override
  void dispose() {
    chatTextController.dispose();
    scrollController.dispose();
    chatFocusNode.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _linkedinCtrl.dispose();
    _githubCtrl.dispose();
    _summaryCtrl.dispose();
    _skillsCtrl.dispose();
    _languagesCtrl.dispose();
    _hobbiesCtrl.dispose();
    _interestsCtrl.dispose();
    _degreeCtrl.dispose();
    _institutionCtrl.dispose();
    super.dispose();
  }

  // ==========================================================================
  // CHAT: send_message / start_chat
  // ==========================================================================

  Future<void> createChatResume({
    required Map<String, dynamic> reqData,
    bool? isChatStarted = false,
  }) async {
    final String userMessage = reqData["message"] ?? "";

    if (userMessage.isNotEmpty) {
      messages.add(ChatMessage(text: userMessage, isBot: false));
      chatTextController.clear();
      selectedOptions.clear();
      availableOptions.clear();
      scrollToBottom();
      FocusScope.of(context).unfocus();
    }

    try {
      await loginController.createNewChatResume(chatRequestData: reqData);

      if (loginController.getResponseCode() == 200 ||
          loginController.getResponseCode() == 201) {
        final reply = loginController.createNewResumeModel.collectedData;

        if (isChatStarted == true) {
          userId =
              loginController.createNewResumeModel.userId ??
              reply?.personalInfo?.name ??
              userId;
          userId = loginController.createNewResumeModel.userId ?? userId;
        }

        if (loginController.createNewResumeModel.message != null &&
            loginController.createNewResumeModel.message!.isNotEmpty) {
          messages.add(
            ChatMessage(
              text: loginController.createNewResumeModel.message!,
              isBot: true,
            ),
          );
        }

        // Sync controllers with newly collected data
        _syncControllersFromCollectedData(reply);

        final String? completedSection =
            loginController.createNewResumeModel.completedSection;

        if (completedSection != null && completedSection.isNotEmpty) {
          _completedSections.add(completedSection);
          await _handleCompletedSection(completedSection);
        }
      } else {
        AppFunctions.apiErrorHandling(
          loginController.getResponseCode(),
          loginController.createNewResumeModel.message ??
              "Something went wrong!, try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        loginController.getResponseCode(),
        loginController.createNewResumeModel.message ??
            "Something went wrong!, try again later!",
      );
    } finally {
      if (isInitialLoading) {
        setState(() {
          isInitialLoading = false;
        });
      } else {
        setState(() {});
      }
      scrollToBottom();
    }
  }

  void _syncControllersFromCollectedData(ResumeCollectedData? data) {
    if (data == null) return;

    if (data.personalInfo != null) {
      if (_nameCtrl.text.isEmpty) _nameCtrl.text = data.personalInfo!.name ?? "";
      if (_emailCtrl.text.isEmpty) _emailCtrl.text = data.personalInfo!.email ?? "";
      if (_mobileCtrl.text.isEmpty) _mobileCtrl.text = data.personalInfo!.phone ?? "";
      if (_linkedinCtrl.text.isEmpty) _linkedinCtrl.text = data.personalInfo!.linkedIn ?? "";
      if (_githubCtrl.text.isEmpty) _githubCtrl.text = data.personalInfo!.github ?? "";
    }

    if (_summaryCtrl.text.isEmpty) _summaryCtrl.text = data.profileSummary ?? "";
    if (_skillsCtrl.text.isEmpty && data.skills != null) {
      _skillsCtrl.text = data.skills!.join(", ");
    }
    if (_languagesCtrl.text.isEmpty && data.languages != null) {
      _languagesCtrl.text = data.languages!.join(", ");
    }
    if (_hobbiesCtrl.text.isEmpty && data.hobbies != null) {
      _hobbiesCtrl.text = data.hobbies!.join(", ");
    }
    if (_interestsCtrl.text.isEmpty && data.areasOfInterest != null) {
      _interestsCtrl.text = data.areasOfInterest!.join(", ");
    }

    if (data.education?.college != null && data.education!.college!.isNotEmpty) {
      if (_degreeCtrl.text.isEmpty) {
        _degreeCtrl.text = data.education!.college!.first.degree ?? "";
      }
      if (_institutionCtrl.text.isEmpty) {
        _institutionCtrl.text = data.education!.college!.first.institution ?? "";
      }
    }
  }

  // ==========================================================================
  // COMPLETED-SECTION ROUTER
  // ==========================================================================

  Future<void> _handleCompletedSection(String completedSection) async {
    final String? quizSection = kQuizGatedSections[completedSection];
    if (quizSection != null &&
        !_handledCompletionSignatures.contains(completedSection)) {
      _handledCompletionSignatures.add(completedSection);
      await Future.delayed(const Duration(milliseconds: 500));
      await _startKnowledgeCheck(quizSection);
    }

    // Call Update Profile API on every section completion or DONE trigger
    await registerNewStudent(isDone: completedSection == "DONE");
  }

  // ==========================================================================
  // QUIZ: start_quiz / submit_quiz
  // ==========================================================================

  Future<void> _startKnowledgeCheck(String section) async {
    if (_quizDialogOpen) return;

    final Map<String, dynamic> quizData = {
      "action": "start_quiz",
      "user_id": userId,
      "section": section,
    };

    try {
      await loginController.getChatMcqQuestion(chatRequestData: quizData);

      if (loginController.getResponseCode() == 200 ||
          loginController.getResponseCode() == 201) {
        final ChatMcqQuestionModel quizModel =
            loginController.chatMcqQuestionModel;

        _quizDialogOpen = true;
        if (!mounted) return;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => PopScope(
            canPop: false,
            child: KnowledgeCheckDialog(
              sectionCode: section,
              quizModel: quizModel,
              onSubmit: (answers) => _submitKnowledgeCheck(
                validationId: quizModel.validationId ?? "",
                answers: answers,
              ),
            ),
          ),
        );
        _quizDialogOpen = false;
      } else {
        AppFunctions.apiErrorHandling(
          loginController.getResponseCode(),
          "Couldn't load the verification quiz, try again!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        loginController.getResponseCode(),
        "Couldn't load the verification quiz, try again!",
      );
    }
  }

  Future<ChatMcqResultModel?> _submitKnowledgeCheck({
    required String validationId,
    required List<String> answers,
  }) async {
    final Map<String, dynamic> resultData = {
      "action": "submit_quiz",
      "validation_id": validationId,
      "answers": answers,
    };

    try {
      await loginController.getChatMcqResult(chatRequestData: resultData);

      if (loginController.getResponseCode() == 200 ||
          loginController.getResponseCode() == 201) {
        return loginController.chatMcqResultModel;
      } else {
        AppFunctions.apiErrorHandling(
          loginController.getResponseCode(),
          "Something went wrong submitting the quiz!",
        );
        return null;
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        loginController.getResponseCode(),
        "Something went wrong submitting the quiz!",
      );
      return null;
    }
  }

  // ==========================================================================
  // UPDATE PROFILE API & NAVIGATE TO TEMPLATES ON DONE
  // ==========================================================================

  Future<void> registerNewStudent({
    bool isDone = false,
    String? completedSection,
  }) async {
    final reply = loginController.createNewResumeModel.collectedData;
    final ResumeCollectedData? collected = reply;

    // 1. Build Flat Payload for Register/Update APIs
    final collegeArray = collected?.education?.college ?? [];
    final secondaryData = collected?.education?.school?.secondary;
    final higherSecondaryData = collected?.education?.school?.higherSecondary;

    final collegeList = collegeArray.isNotEmpty
        ? collegeArray
        .map((c) => {
      'degree': c.degree ?? '',
      'department': c.department ?? '',
      'institution': c.institution ?? '',
      'start_year': c.startYear ?? '',
      'end_year': c.endYear ?? '',
    })
        .toList()
        : [];

    final secondaryList = secondaryData != null ? [secondaryData.toJson()] : [];
    final higherSecondaryList =
    higherSecondaryData != null ? [higherSecondaryData.toJson()] : [];

    final educationObject = {
      'school': {
        'higher_secondary': higherSecondaryData?.toJson() ?? {},
        'secondary': secondaryData?.toJson() ?? {},
      },
      'college': collegeList,
    };

    Map<String, dynamic> payload = {
      "studname": _nameCtrl.text.trim().isNotEmpty
          ? _nameCtrl.text.trim()
          : collected?.personalInfo?.name ?? "",
      "studemail": _emailCtrl.text.trim().isNotEmpty
          ? _emailCtrl.text.trim()
          : collected?.personalInfo?.email ?? "",
      "studmobileno": _mobileCtrl.text.trim().isNotEmpty
          ? _mobileCtrl.text.trim()
          : collected?.personalInfo?.phone ?? "",
      "profile_summary": _summaryCtrl.text.trim().isNotEmpty
          ? _summaryCtrl.text.trim()
          : collected?.profileSummary ?? "",
      "studprogramminglang": _skillsCtrl.text.trim().isNotEmpty
          ? _skillsCtrl.text
          .split(",")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList()
          : collected?.skills ?? [],
      "projects": jsonEncode(
        collected?.projects?.map((e) => e.toJson()).toList() ?? [],
      ),
      "paper_presentations": jsonEncode(
        collected?.paperPresentations?.map((e) => e.toJson()).toList() ?? [],
      ),
      "internships": jsonEncode(
        collected?.internships?.map((e) => e.toJson()).toList() ?? [],
      ),
      "studentcertificate": jsonEncode(
        collected?.certifications?.map((e) => e.toJson()).toList() ?? [],
      ),
      "workshops": jsonEncode(collected?.workshops ?? []),
      "publications": jsonEncode(collected?.publications ?? []),
      "achievements": jsonEncode(collected?.achievements ?? []),
      "leadership": jsonEncode(collected?.leadership ?? []),
      "volunteer_experience": jsonEncode(collected?.volunteerExperience ?? []),
      "languages_known": _languagesCtrl.text.trim().isNotEmpty
          ? jsonEncode(
        _languagesCtrl.text.split(",").map((e) => e.trim()).toList(),
      )
          : jsonEncode(collected?.languages ?? []),
      "areas_of_interest": _interestsCtrl.text.trim().isNotEmpty
          ? jsonEncode(
        _interestsCtrl.text.split(",").map((e) => e.trim()).toList(),
      )
          : jsonEncode(collected?.areasOfInterest ?? []),
      "hobbies": _hobbiesCtrl.text.trim().isNotEmpty
          ? jsonEncode(
        _hobbiesCtrl.text.split(",").map((e) => e.trim()).toList(),
      )
          : jsonEncode(collected?.hobbies ?? []),
      "industrial_visits": jsonEncode(collected?.industrialVisits ?? []),
      "linkedIn": _linkedinCtrl.text.trim().isNotEmpty
          ? _linkedinCtrl.text.trim()
          : collected?.personalInfo?.linkedIn ?? "",
      "github": _githubCtrl.text.trim().isNotEmpty
          ? _githubCtrl.text.trim()
          : collected?.personalInfo?.github ?? "",
      "portfolio_website": _githubCtrl.text.trim().isNotEmpty
          ? _githubCtrl.text.trim()
          : collected?.personalInfo?.github ?? "",
      "secondary": jsonEncode(secondaryList),
      "higher_secondary": jsonEncode(higherSecondaryList),
      "college": jsonEncode(collegeList),
      "education": jsonEncode(educationObject),
      "studentdegree": _degreeCtrl.text.trim().isNotEmpty
          ? _degreeCtrl.text.trim()
          : (collegeArray.isNotEmpty ? collegeArray.first.degree ?? "" : ""),
      "studentcollegename": _institutionCtrl.text.trim().isNotEmpty
          ? _institutionCtrl.text.trim()
          : (collegeArray.isNotEmpty ? collegeArray.first.institution ?? "" : ""),
    };

    try {
      if (completedSection == "mobile_otp_completed") {
        // 2A. Initial Registration execution
        await registerController.registerNewStudent(registerData: payload);
      } else {
        // 2B. Build Chat Resume Payload with populated fields across all sections
        Map<String, dynamic> chatPayload = {
          "action": "send_message",
          "user_id": userId,
          "message": "",
          "collected_data": {
            "profile_summary": payload["profile_summary"],
            "personal_info": {
              "name": payload["studname"],
              "surname": "",
              "email": payload["studemail"],
              "phone": payload["studmobileno"],
              "linkedIn": payload["linkedIn"],
              "github": payload["github"],
              "portfolio": payload["portfolio_website"],
              "location": "",
              "role": payload["studentdegree"],
            },
            "refcode": "",
            "skills": payload["studprogramminglang"],
            "internships": collected?.internships?.map((e) => e.toJson()).toList() ?? [],
            "projects": collected?.projects?.map((e) => e.toJson()).toList() ?? [],
            "industrial_visits": collected?.industrialVisits ?? [],
            "education": educationObject,
            "certifications": collected?.certifications?.map((e) => e.toJson()).toList() ?? [],
            "paper_presentations": collected?.paperPresentations?.map((e) => e.toJson()).toList() ?? [],
            "workshops": collected?.workshops ?? [],
            "publications": collected?.publications ?? [],
            "achievements": collected?.achievements ?? [],
            "leadership": collected?.leadership ?? [],
            "volunteer_experience": collected?.volunteerExperience ?? [],
            "languages": _languagesCtrl.text.trim().isNotEmpty
                ? _languagesCtrl.text.split(",").map((e) => e.trim()).toList()
                : collected?.languages ?? [],
            "areas_of_interest": _interestsCtrl.text.trim().isNotEmpty
                ? _interestsCtrl.text.split(",").map((e) => e.trim()).toList()
                : collected?.areasOfInterest ?? [],
            "hobbies": _hobbiesCtrl.text.trim().isNotEmpty
                ? _hobbiesCtrl.text.split(",").map((e) => e.trim()).toList()
                : collected?.hobbies ?? [],
            "colleges1": collegeList,
            "colleges2": [],
            "colleges3": [],
            "institution": [
              {
                "institution1": payload["studentcollegename"],
                "institution2": "",
                "institution3": ""
              }
            ],
            "degree": [
              {
                "degree1": payload["studentdegree"],
                "degree2": "",
                "degree3": ""
              }
            ]
          }
        };

        // Call Chat Resume Sync API first
        await loginController.createNewChatResume(chatRequestData: chatPayload);

        // Call Profile Update API
        await registerController.updateStudentProfileData(updateData: payload);
      }

      final int statusCode = registerController.getResponseCode();

      if (statusCode == 200 || statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();

        if (completedSection == "mobile_otp_completed" &&
            registerController.studentRegisterModel.studentToken != null) {
          await LocalStorageService.saveStudent(
            token: registerController.studentRegisterModel.studentToken!,
            student: registerController.studentRegisterModel.registerData!,
          );
          await prefs.setString(
            LocalStorageService.studentNameKey,
            registerController.studentRegisterModel.registerData!.studentName ??
                "",
          );
          await prefs.setString(
            LocalStorageService.tokenKey,
            registerController.studentRegisterModel.studentToken ?? "",
          );
        }

        // Refresh Live Preview Model
        loginController.createNewResumeModel.collectedData = ResumeCollectedData(
          personalInfo: PersonalInfoModel(
            name: payload["studname"],
            email: payload["studemail"],
            phone: payload["studmobileno"],
            linkedIn: payload["linkedIn"],
            github: payload["github"],
            gender: "",
            location: "",
          ),
          profileSummary: payload["profile_summary"],
          skills: List<String>.from(payload["studprogramminglang"] ?? []),
          hobbies: _hobbiesCtrl.text.trim().isNotEmpty
              ? _hobbiesCtrl.text.split(",").map((e) => e.trim()).toList()
              : collected?.hobbies,
          languages: _languagesCtrl.text.trim().isNotEmpty
              ? _languagesCtrl.text.split(",").map((e) => e.trim()).toList()
              : collected?.languages,
          areasOfInterest: _interestsCtrl.text.trim().isNotEmpty
              ? _interestsCtrl.text.split(",").map((e) => e.trim()).toList()
              : collected?.areasOfInterest,
          projects: collected?.projects,
          internships: collected?.internships,
          certifications: collected?.certifications,
          education: collected?.education,
        );

        loginController.createNewResumeModel.obs.refresh();

        if (isDone && mounted) {
          await getStudentProfileData();
        }
      } else {
        AppFunctions.apiErrorHandling(
          statusCode,
          registerController.studentRegisterModel.message ??
              "Failed to update profile. Please try again.",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Failed to save section update: $error",
      );
    }
  }

  Future<void> getStudentProfileData() async {
    final String studentId =
        registerController.studentRegisterModel.registerData?.id ?? "";
    if (studentId.isEmpty) return;

    await registerController.getStudentProfile(studentId: studentId);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      StudentProfileModel data = registerController.studentProfileModel;
      if (!mounted) return;
      AppFunctions.navigateScreen(
        context,
        AppRoutes.chatResumeTemplateScreen,
        arguments: {
          "resumeData": ExtractedResumeDataModel(
            personalInfo: PersonalInfoModel(
              name: data.studentName ?? "",
              gender: data.studentGender,
              email: data.studEmail ?? "",
              phone: data.studMobileNo ?? "",
              linkedIn: data.linkedIn,
              github: data.github,
              location: "",
            ),
            internships: data.internships ?? [],
            hobbies: data.hobbies,
            areasOfInterest: data.areasOfInterest,
            languages: data.languagesKnown,
            volunteerExperience: data.volunteerExperience,
            leaderships: data.leadership,
            achievements: data.achievements,
            publications: data.publications,
            workShops: data.workshops,
            paperPresentations: data.paperPresentations,
            educationData: data.education,
            industrialVisits: data.industrialVisits,
            projects: data.projects,
            skills: data.studProgrammingLang,
            profileSummary: (data.profileSummary ?? "").replaceAll('"', ''),
            colleges: data.college,
            degree: const [],
            experience: data.experience,
            trainings: const [],
            studentId: data.id,
            higherSecondary: data.education?.school?.higherSecondary,
            institution: const [],
            parents: const [],
            secondary: data.education?.school?.secondary,
          ),
          "templateId": 1,
          "isRegisterFlow": true,
        },
      );
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Failed to load your profile!",
      );
    }
  }

  // ==========================================================================
  // SEND HELPERS
  // ==========================================================================

  Future<void> sendSelectedOptions() async {
    if (selectedOptions.isEmpty) return;
    final message = selectedOptions.join(", ");
    setState(() {
      availableOptions.clear();
      selectedOptions.clear();
    });
    await createChatResume(
      reqData: {
        "action": "send_message",
        "user_id": userId,
        "message": message,
      },
    );
  }

  Future<void> sendTypedMessage() async {
    final text = chatTextController.text.trim();
    if (text.isEmpty) return;
    await createChatResume(
      reqData: {"action": "send_message", "user_id": userId, "message": text},
    );
  }

  void scrollToBottom() {
    Timer(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ==========================================================================
  // UI BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.chatScreenBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Get.back(),
          ),
          title: Obx(
            () => Text(
              _titleForTab(currentTabIndex.value),
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.secondaryColor,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: Obx(
          () =>
              (isInitialLoading && loginController.createNewResumeLoading) ||
                  registerController.studentRegisterLoading
              ? AppAlertUtils.customLoader()
              : IndexedStack(
                  index: currentTabIndex.value,
                  children: [
                    _buildChatBody(),
                    _buildLivePreviewBody(),
                    _buildSectionsBody(),
                  ],
                ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  String _titleForTab(int index) {
    switch (index) {
      case 1:
        return "Live Preview";
      case 2:
        return "Resume Sections";
      default:
        return "Create Resume";
    }
  }

  // -------------------------- CHAT TAB --------------------------

  Widget _buildChatBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, i) => _buildChatBubble(messages[i]),
              ),
            ),
          ),
          Obx(
            () => loginController.createNewResumeLoading
                ? loadingContainer()
                : const SizedBox.shrink(),
          ),
          if (availableOptions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _buildOptionsChips(),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    bool isBot = msg.isBot;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
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
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: isBot
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isBot) ...[
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(AssetImages.aiBotImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isBot
                          ? [AppColors.chatGradient3, AppColors.chatGradient3]
                          : [AppColors.chatGradient1, AppColors.chatGradient2],
                    ),
                    borderRadius: isBot
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )
                        : const BorderRadius.only(
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

  Widget _buildInputArea() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.chatGradient3,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: chatTextController,
              focusNode: chatFocusNode,
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
                  await sendTypedMessage();
                }
              },
            ),
          ),
        ),
        IconButton(
          icon: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: const Icon(
              Icons.send_rounded,
              color: AppColors.whiteColor,
              size: 22,
            ),
          ),
          onPressed: () async {
            if (selectedOptions.isNotEmpty) {
              await sendSelectedOptions();
            } else {
              await sendTypedMessage();
            }
          },
        ),
      ],
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
          const SizedBox(height: 5),
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
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
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

  // -------------------------- LIVE PREVIEW TAB --------------------------

  Widget _buildLivePreviewBody() {
    return Obx(() {
      final ResumeCollectedData? collected =
          loginController.createNewResumeModel.collectedData;

      if (collected == null) {
        return Center(
          child: Text(
            "Your live preview will appear here once we've\ncollected a bit more of your details.",
            textAlign: TextAlign.center,
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.chatTextColor,
              weight: FontWeight.w400,
            ),
          ),
        );
      }

      final resumeData = ExtractedResumeDataModel(
        personalInfo: PersonalInfoModel(
          name: collected.personalInfo?.name ?? "",
          gender: collected.personalInfo?.gender,
          email: collected.personalInfo?.email ?? "",
          phone: collected.personalInfo?.phone ?? "",
          linkedIn: collected.personalInfo?.linkedIn,
          github: collected.personalInfo?.github,
          location: "",
        ),
        internships: collected.internships ?? [],
        hobbies: collected.hobbies,
        areasOfInterest: collected.areasOfInterest,
        languages: collected.languages,
        volunteerExperience: collected.volunteerExperience,
        leaderships: collected.leadership,
        achievements: collected.achievements,
        publications: collected.publications,
        workShops: collected.workshops,
        paperPresentations: collected.paperPresentations,
        educationData: collected.education,
        industrialVisits: collected.industrialVisits,
        projects: collected.projects,
        skills: collected.skills,
        profileSummary: collected.profileSummary ?? "",
        colleges: collected.education?.college,
        degree: const [],
        experience: const [],
        trainings: const [],
        studentId: null,
        higherSecondary: collected.education?.school?.higherSecondary,
        institution: const [],
        parents: const [],
        secondary: collected.education?.school?.secondary,
      );

      return ShowTemplateView(
        htmlAssetPath: 'assets/images/html_templates/resume_template_1.html',
        resumeData: resumeData,
      );
    });
  }

  // -------------------------- SECTIONS TAB (EXPANSION TILES) --------------------------

  static const List<ResumeSectionMeta> _sectionMeta = [
    ResumeSectionMeta(
      "personal_info",
      "Personal Info",
      "Your contact details",
      Icons.person,
      Color(0xFF2D5CF2),
    ),
    ResumeSectionMeta(
      "profile_summary",
      "Profile Summary",
      "Summary about you",
      Icons.description,
      Color(0xFF17A398),
    ),
    ResumeSectionMeta(
      "skills",
      "Skills",
      "Your technical skills",
      Icons.bolt,
      Color(0xFFF6A509),
    ),
    ResumeSectionMeta(
      "education",
      "Education",
      "Your education details",
      Icons.school,
      Color(0xFF162447),
    ),
    ResumeSectionMeta(
      "languages",
      "Languages",
      "Languages you know",
      Icons.language,
      Color(0xFF1F9D6C),
    ),
    ResumeSectionMeta(
      "interests",
      "Interests",
      "Your areas of interest",
      Icons.favorite,
      Color(0xFFE0457B),
    ),
    ResumeSectionMeta(
      "hobbies",
      "Hobbies",
      "Your hobbies",
      Icons.sports_esports,
      Color(0xFF7A4FE0),
    ),
  ];

  bool _isSectionEditable(String key, ResumeCollectedData? collected) {
    if (collected == null) return false;
    switch (key) {
      case "personal_info":
        final p = collected.personalInfo;
        return (p != null && (p.name?.trim().isNotEmpty == true || p.email?.trim().isNotEmpty == true)) ||
            _completedSections.contains("personal_info_completed");

      case "profile_summary":
        return (collected.profileSummary?.trim().isNotEmpty == true) ||
            _completedSections.contains("profile_summary_completed");

      case "skills":
        return (collected.skills != null && collected.skills!.isNotEmpty) ||
            _completedSections.contains("skills_completed");

      case "education":
        final hasCollege = collected.education?.college?.isNotEmpty == true;
        return hasCollege || _completedSections.contains("education_completed");

      case "languages":
        return (collected.languages != null && collected.languages!.isNotEmpty) ||
            _completedSections.contains("languages_completed");

      case "interests":
        return (collected.areasOfInterest != null && collected.areasOfInterest!.isNotEmpty) ||
            _completedSections.contains("interests_completed");

      case "hobbies":
        return (collected.hobbies != null && collected.hobbies!.isNotEmpty) ||
            _completedSections.contains("hobbies_completed");

      default:
        return false;
    }
  }

  Widget _buildSectionsBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Obx(() {
          final collected = loginController.createNewResumeModel.collectedData;

          // Filter to only display editable/non-empty sections
          final activeSections = _sectionMeta.where((meta) {
            return _isSectionEditable(meta.key, collected);
          }).toList();

          if (activeSections.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  "No completed sections available to edit yet.\nComplete details in chat first!",
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.chatTextColor,
                  ),
                ),
              ),
            );
          }

          return Column(
            children: activeSections.map((meta) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.recContainerColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.4),
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: meta.color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(meta.icon, color: Colors.white, size: 20),
                    ),
                    title: Text(
                      meta.title,
                      style: AppStyles.customTextStyle(
                        size: 15,
                        weight: FontWeight.w600,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    subtitle: Text(
                      meta.subtitle,
                      style: AppStyles.customTextStyle(
                        size: 12,
                        weight: FontWeight.w400,
                        color: AppColors.chatTextColor,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildSectionFormFields(meta.key),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ),
    );
  }

  Widget _buildSectionFormFields(String key) {
    switch (key) {
      case "personal_info":
        return Column(
          children: [
            CustomTextField(
              controller: _nameCtrl,
              labelText: "Full Name",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _emailCtrl,
              labelText: "Email Address",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _mobileCtrl,
              labelText: "Mobile Number",
              isNumberKeyboard: true,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _linkedinCtrl,
              labelText: "LinkedIn Profile",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _githubCtrl,
              labelText: "GitHub Profile",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Personal Info",
              buttonFunction: () async {
                await registerNewStudent();
                AppAlertUtils.showToast(message: "Personal info updated!");
              },
            ),
          ],
        );
      case "profile_summary":
        return Column(
          children: [
            CustomTextField(
              controller: _summaryCtrl,
              labelText: "Profile Summary",
              maxLines: 4,
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Summary",
              buttonFunction: () async {
                await registerNewStudent();
                AppAlertUtils.showToast(message: "Summary updated!");
              },
            ),
          ],
        );
      case "skills":
        return Column(
          children: [
            CustomTextField(
              controller: _skillsCtrl,
              labelText: "Skills (comma separated)",
              hintText: "e.g., Flutter, Dart, Python",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Skills",
              buttonFunction: () async {
                await registerNewStudent();
                AppAlertUtils.showToast(message: "Skills updated!");
              },
            ),
          ],
        );
      case "education":
        return Column(
          children: [
            CustomTextField(
              controller: _degreeCtrl,
              labelText: "Degree / Course",
              hintText: "e.g., B.Tech Information Technology",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _institutionCtrl,
              labelText: "College / University Name",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Education",
              buttonFunction: () async {
                await registerNewStudent();
                AppAlertUtils.showToast(message: "Education updated!");
              },
            ),
          ],
        );
      case "languages":
        return Column(
          children: [
            CustomTextField(
              controller: _languagesCtrl,
              labelText: "Languages Known (comma separated)",
              hintText: "e.g., English, Tamil",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Languages",
              buttonFunction: () async {
                await registerNewStudent();
                AppAlertUtils.showToast(message: "Languages updated!");
              },
            ),
          ],
        );
      case "interests":
        return Column(
          children: [
            CustomTextField(
              controller: _interestsCtrl,
              labelText: "Areas of Interest (comma separated)",
              hintText: "e.g., Mobile App Development, AI",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Interests",
              buttonFunction: () async {
                await registerNewStudent();
                AppAlertUtils.showToast(message: "Interests updated!");
              },
            ),
          ],
        );
      case "hobbies":
        return Column(
          children: [
            CustomTextField(
              controller: _hobbiesCtrl,
              labelText: "Hobbies (comma separated)",
              hintText: "e.g., Photography, Gaming",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Hobbies",
              buttonFunction: () async {
                await registerNewStudent();
                AppAlertUtils.showToast(message: "Hobbies updated!");
              },
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // -------------------------- BOTTOM NAV --------------------------

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.chatGradient3,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: CupertinoIcons.chat_bubble_2_fill,
              label: "My Chat",
            ),
            _buildNavItem(
              index: 1,
              icon: CupertinoIcons.eye_fill,
              label: "Live Preview",
            ),
            _buildNavItem(
              index: 2,
              icon: CupertinoIcons.square_list_fill,
              label: "Sections",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = currentTabIndex.value == index;
    return GestureDetector(
      //onTap: () => currentTabIndex.value = index,
      onTap: () {
        currentTabIndex.value = index;
        if (index == 2) {
          // Force controller sync when switching to Sections tab
          _syncControllersFromCollectedData(
            loginController.createNewResumeModel.collectedData,
          );
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.chatTextColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppStyles.customTextStyle(
                size: 13,
                weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.chatTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
