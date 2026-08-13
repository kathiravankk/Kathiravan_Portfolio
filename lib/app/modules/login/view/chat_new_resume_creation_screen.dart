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
import 'package:internsharks/app/data/models/account/new_student_profile_model.dart';
import 'package:internsharks/app/data/models/account/education_model.dart'
    hide School;
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
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
  final Set<String> _verifiedItems = {};

  bool _quizDialogOpen = false;
  bool isInitialLoading = true;
  bool _isChatCompleted = false;

  // Section Form Field Controllers (Reused from Profile Edit Screen)
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController(); // ADDED
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();
  final _summaryCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  final _languagesCtrl = TextEditingController();
  final _hobbiesCtrl = TextEditingController();
  final _interestsCtrl = TextEditingController();

  final _degreeCtrl = TextEditingController();
  final _institutionCtrl = TextEditingController();

  final _higherInstCtrl = TextEditingController();
  final _higherBoardCtrl = TextEditingController();
  final _higherPercCtrl = TextEditingController();
  final _higherYearCtrl = TextEditingController();

  final _secInstCtrl = TextEditingController();
  final _secBoardCtrl = TextEditingController();
  final _secPercCtrl = TextEditingController();
  final _secYearCtrl = TextEditingController();

  final _workshopsCtrl = TextEditingController();
  final _achievementsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Automatically sync text controllers whenever GetX updates the resume model
    ever(loginController.createNewResumeModelRx, (_) {
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
    _surnameCtrl.dispose(); // ADDED
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

  String _capitalizeName(String text) {
    if (text.trim().isEmpty) return "";
    return text
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return "";
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(" ");
  }

  // Combines name and surname: "Kathir" + "Kannan" -> "Kathir Kannan"
  String _getCombinedFullName() {
    final firstName = _capitalizeName(_nameCtrl.text);
    final surname = _capitalizeName(_surnameCtrl.text);

    return [firstName, surname].where((s) => s.isNotEmpty).join(" ");
  }

  void _logApi({required String title, dynamic data}) {
    try {
      final String prettyJson = const JsonEncoder.withIndent('  ').convert(data);
      debugPrint('\n==================================================');
      debugPrint('➡️ API LOG: $title');
      debugPrint(prettyJson, wrapWidth: 1024);
      debugPrint('==================================================\n');
    } catch (e) {
      debugPrint('\n➡️ API LOG: $title => $data\n');
    }
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

    // ── Snapshot current collectedData before API call ──
    // If the API errors out, we restore this so the Live Preview isn't wiped.
    final ResumeCollectedData? previousCollectedData =
        loginController.createNewResumeModel.collectedData;

    try {
      _logApi(title: "createChatResume REQUEST", data: reqData);
      await loginController.createNewChatResume(chatRequestData: reqData);
      _logApi(
        title:
            "createChatResume RESPONSE [Status: ${loginController.getResponseCode()}]",
        data: loginController.createNewResumeModel.toJson(),
      );

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

        // ── After start_chat, merge existing profile data into collectedData ──
        // The chat API's collected_data may not include data already saved to the
        // profile (paper_presentations, internships, projects, college, etc.).
        // We fetch the profile API and merge those into collectedData so the
        // Live Preview shows all existing sections immediately.
        if (isChatStarted == true) {
          // Fetch latest profile if we don't have it yet
          final storedId = await LocalStorageService.getStudentId() ?? '';
          if (storedId.isNotEmpty &&
              registerController.studentProfileModel.studentName == null) {
            await registerController.getStudentProfile(studentId: storedId);
          }

          final profileModel = registerController.studentProfileModel;
          final current = loginController.createNewResumeModel.collectedData;

          // Build a merged ResumeCollectedData that prefers chat API data where
          // available, but fills in blanks from the profile API.
          loginController.createNewResumeModel.collectedData = ResumeCollectedData(
            personalInfo: current?.personalInfo ??
                (profileModel.studentName != null
                    ? PersonalInfoModel(
                        name: profileModel.studentName ?? '',
                        sureName: '',
                        role: profileModel.role,
                        email: profileModel.studEmail ?? '',
                        phone: profileModel.studMobileNo ?? '',
                        linkedIn: profileModel.linkedIn,
                        github: profileModel.github,
                        gender: profileModel.studentGender ?? '',
                        location: profileModel.location ?? '',
                      )
                    : null),
            profileSummary:
                (current?.profileSummary?.isNotEmpty == true)
                    ? current!.profileSummary
                    : profileModel.profileSummary,
            skills: (current?.skills?.isNotEmpty == true)
                ? current!.skills
                : profileModel.studProgrammingLang,
            // Backend-owned list fields — prefer chat, fallback to profile API
            paperPresentations: (current?.paperPresentations?.isNotEmpty == true)
                ? current!.paperPresentations
                : profileModel.paperPresentations,
            projects: (current?.projects?.isNotEmpty == true)
                ? current!.projects
                : profileModel.projects,
            internships: (current?.internships?.isNotEmpty == true)
                ? current!.internships
                : profileModel.internships,
            industrialVisits: (current?.industrialVisits?.isNotEmpty == true)
                ? current!.industrialVisits
                : profileModel.industrialVisits,
            certifications: current?.certifications,
            education: current?.education ?? profileModel.education,
            colleges1: current?.colleges1 ??
                (profileModel.college is List<dynamic>
                    ? (profileModel.college as List<dynamic>)
                        .whereType<Map<String, dynamic>>()
                        .map((e) => CollegeData.fromJson(e))
                        .toList()
                    : null),
            workshops: (current?.workshops?.isNotEmpty == true)
                ? current!.workshops
                : profileModel.workshops,
            publications: (current?.publications?.isNotEmpty == true)
                ? current!.publications
                : profileModel.publications,
            achievements: (current?.achievements?.isNotEmpty == true)
                ? current!.achievements
                : profileModel.achievements,
            leadership: (current?.leadership?.isNotEmpty == true)
                ? current!.leadership
                : profileModel.leadership,
            volunteerExperience:
                (current?.volunteerExperience?.isNotEmpty == true)
                    ? current!.volunteerExperience
                    : profileModel.volunteerExperience,
            languages: (current?.languages?.isNotEmpty == true)
                ? current!.languages
                : profileModel.languagesKnown,
            hobbies: (current?.hobbies?.isNotEmpty == true)
                ? current!.hobbies
                : profileModel.hobbies,
            areasOfInterest: (current?.areasOfInterest?.isNotEmpty == true)
                ? current!.areasOfInterest
                : profileModel.areasOfInterest,
          );
          loginController.createNewResumeModelRx.refresh();
        }

        final String? completedSection =
            loginController.createNewResumeModel.completedSection;

        final String? nextField =
            loginController.createNewResumeModel.nextField;

        if ((completedSection == "DONE" ||
            completedSection == "achievements_completed" ||
            nextField == "DONE") && !_isChatCompleted) {
          _isChatCompleted = true;
          messages.add(
            ChatMessage(
              text:
                  "🎉 Your resume is complete! You are being redirected to further steps...",
              isBot: true,
            ),
          );
          if (mounted) setState(() {});
          Future.delayed(const Duration(seconds: 3), () async {
            if (mounted) {
              await getStudentProfileData();
            }
          });
        } else if (completedSection != null && completedSection.isNotEmpty) {
          _completedSections.add(completedSection);
          await _handleCompletedSection(completedSection);
        }
      } else {
        // ── Restore previous collectedData on API error ──
        if (previousCollectedData != null) {
          loginController.createNewResumeModel.collectedData =
              previousCollectedData;
          loginController.createNewResumeModelRx.refresh();
        }
        final errorMsg = loginController.createNewResumeModel.message;
        messages.add(
          ChatMessage(
            text: errorMsg ?? "Something went wrong! Please try again.",
            isBot: true,
          ),
        );
      }
    } catch (error) {
      // ── Restore previous collectedData on exception ──
      if (previousCollectedData != null) {
        loginController.createNewResumeModel.collectedData =
            previousCollectedData;
        loginController.createNewResumeModelRx.refresh();
      }
      messages.add(
        ChatMessage(
          text: "Something went wrong! Please try again.",
          isBot: true,
        ),
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
      String fullName = data.personalInfo!.name;
      String surname = data.personalInfo!.sureName ?? "";

      // If name coming from backend already includes surname, assign full name cleanly
      if (surname.isNotEmpty && fullName.endsWith(surname)) {
        _nameCtrl.text = fullName.substring(0, fullName.length - surname.length).trim();
        _surnameCtrl.text = surname;
      } else {
        _nameCtrl.text = fullName;
        _surnameCtrl.text = surname;
      }

      _emailCtrl.text = data.personalInfo!.email.isNotEmpty
          ? data.personalInfo!.email
          : _emailCtrl.text;

      _mobileCtrl.text = data.personalInfo!.phone.isNotEmpty
          ? data.personalInfo!.phone
          : _mobileCtrl.text;

      _linkedinCtrl.text = data.personalInfo!.linkedIn ?? _linkedinCtrl.text;
      _githubCtrl.text = data.personalInfo!.github ?? _githubCtrl.text;
    }

    if (data.profileSummary != null && data.profileSummary!.isNotEmpty) {
      _summaryCtrl.text = data.profileSummary!;
    }
    if (data.skills != null && data.skills!.isNotEmpty) {
      _skillsCtrl.text = data.skills!.join(", ");
    }
    if (data.languages != null && data.languages!.isNotEmpty) {
      _languagesCtrl.text = data.languages!.join(", ");
    }
    if (data.hobbies != null && data.hobbies!.isNotEmpty) {
      _hobbiesCtrl.text = data.hobbies!.join(", ");
    }
    if (data.areasOfInterest != null && data.areasOfInterest!.isNotEmpty) {
      _interestsCtrl.text = data.areasOfInterest!.join(", ");
    }
    if (data.workshops != null && data.workshops!.isNotEmpty) {
      _workshopsCtrl.text = data.workshops!.join(", ");
    }
    if (data.achievements != null && data.achievements!.isNotEmpty) {
      _achievementsCtrl.text = data.achievements!.join(", ");
    }

    final higherSec = data.education?.school?.higherSecondary;
    if (higherSec != null) {
      _higherInstCtrl.text = higherSec.institution ?? _higherInstCtrl.text;
      _higherBoardCtrl.text = higherSec.board?.toString() ?? _higherBoardCtrl.text;
      _higherPercCtrl.text = higherSec.percentage ?? _higherPercCtrl.text;
      _higherYearCtrl.text = higherSec.yearOfPassing ?? _higherYearCtrl.text;
    }

    final sec = data.education?.school?.secondary;
    if (sec != null) {
      _secInstCtrl.text = sec.institution ?? _secInstCtrl.text;
      _secBoardCtrl.text = sec.board?.toString() ?? _secBoardCtrl.text;
      _secPercCtrl.text = sec.percentage ?? _secPercCtrl.text;
      _secYearCtrl.text = sec.yearOfPassing ?? _secYearCtrl.text;
    }

    final colleges = data.education?.college;
    if (colleges != null && colleges.isNotEmpty) {
      _degreeCtrl.text = colleges.first.degree ?? _degreeCtrl.text;
      _institutionCtrl.text = colleges.first.institution ?? _institutionCtrl.text;
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
    await updateCompleteSectionInfo(
      isDone: completedSection == "DONE",
      completedSection: completedSection,
    );
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
      _logApi(title: "_startKnowledgeCheck REQUEST", data: quizData);
      await loginController.getChatMcqQuestion(chatRequestData: quizData);
      _logApi(
        title:
            "_startKnowledgeCheck RESPONSE [Status: ${loginController.getResponseCode()}]",
        data: loginController.chatMcqQuestionModel.toJson(),
      );

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

        // Process quiz result after dialog closes
        final ChatMcqResultModel result = loginController.chatMcqResultModel;
        if (result.score != null) {
          final int score = result.score!;
          final int total = result.total ?? 0;

          // 1. Post AI chat message with score
          messages.add(
            ChatMessage(
              text: "🎯 Quiz done! Score: $score/$total.",
              isBot: true,
            ),
          );
          scrollToBottom();

          // 2. Track verified items if quiz passed
          final bool isVerified =
              result.verified == true || (total > 0 && score / total >= 0.5);

          if (isVerified) {
            if (result.questions != null && result.questions!.isNotEmpty) {
              for (final qv in result.questions!) {
                if ((qv.verified == true || isVerified) &&
                    qv.skill != null &&
                    qv.skill!.trim().isNotEmpty) {
                  _verifiedItems.add(qv.skill!.trim().toLowerCase());
                  _verifiedItems.add(qv.skill!.trim());
                }
              }
            }

            final collected =
                loginController.createNewResumeModel.collectedData;
            if (collected != null) {
              if (section == "skill" && collected.skills != null) {
                for (final s in collected.skills!) {
                  if (s.trim().isNotEmpty) {
                    _verifiedItems.add(s.trim().toLowerCase());
                    _verifiedItems.add(s.trim());
                  }
                }
              } else if (section == "certification" &&
                  collected.certifications != null) {
                for (final c in collected.certifications!) {
                  if ((c.name ?? "").trim().isNotEmpty) {
                    _verifiedItems.add(c.name!.trim().toLowerCase());
                    _verifiedItems.add(c.name!.trim());
                  }
                }
              } else if (section == "project" && collected.projects != null) {
                for (final p in collected.projects!) {
                  if ((p.title ?? "").trim().isNotEmpty) {
                    _verifiedItems.add(p.title!.trim().toLowerCase());
                    _verifiedItems.add(p.title!.trim());
                  }
                }
              } else if (section == "internship" &&
                  collected.internships != null) {
                for (final i in collected.internships!) {
                  if ((i.role ?? "").trim().isNotEmpty) {
                    _verifiedItems.add(i.role!.trim().toLowerCase());
                    _verifiedItems.add(i.role!.trim());
                  }
                  if ((i.company ?? "").trim().isNotEmpty) {
                    _verifiedItems.add(i.company!.trim().toLowerCase());
                    _verifiedItems.add(i.company!.trim());
                  }
                }
              } else if (section == "paperpresentation" &&
                  collected.paperPresentations != null) {
                for (final pp in collected.paperPresentations!) {
                  if ((pp.title ?? "").trim().isNotEmpty) {
                    _verifiedItems.add(pp.title!.trim().toLowerCase());
                    _verifiedItems.add(pp.title!.trim());
                  }
                }
              }
            }
          }

          setState(() {});
        }
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
      _logApi(title: "_submitKnowledgeCheck REQUEST", data: resultData);
      await loginController.getChatMcqResult(chatRequestData: resultData);
      _logApi(
        title:
            "_submitKnowledgeCheck RESPONSE [Status: ${loginController.getResponseCode()}]",
        data: loginController.chatMcqResultModel.toJson(),
      );

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

  dynamic sanitizePayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      final Map<String, dynamic> cleanedMap = {};
      data.forEach((key, value) {
        // Omit empty or null _id fields entirely
        if (key == '_id' &&
            (value == null || value.toString().trim().isEmpty)) {
          return;
        }
        cleanedMap[key] = sanitizePayload(value);
      });
      return cleanedMap;
    } else if (data is List) {
      return data.map((item) => sanitizePayload(item)).toList();
    }
    return data;
  }

  Future<void> updateCompleteSectionInfo({
    bool isDone = false,
    String? completedSection,
  }) async {
    final reply = loginController.createNewResumeModel.collectedData;
    final ResumeCollectedData? collected = reply;

    final String resolvedRole = (collected?.personalInfo?.role != null &&
            collected!.personalInfo!.role!.trim().isNotEmpty)
        ? collected.personalInfo!.role!
        : (loginController.createNewResumeModel.collectedData?.personalInfo?.role ?? "");

    final String combinedName = _getCombinedFullName();
    final String formattedSurname = _capitalizeName(_surnameCtrl.text);

    final String resolvedName = combinedName.isNotEmpty
        ? combinedName
        : (collected?.personalInfo?.name ?? "");
    final String resolvedSurname = formattedSurname.isNotEmpty
        ? formattedSurname
        : (collected?.personalInfo?.sureName ?? "");
    final String resolvedEmail = _emailCtrl.text.trim().isNotEmpty
        ? _emailCtrl.text.trim()
        : (collected?.personalInfo?.email ?? "");
    final String resolvedPhone = _mobileCtrl.text.trim().isNotEmpty
        ? _mobileCtrl.text.trim()
        : (collected?.personalInfo?.phone ?? "");
    final String resolvedSummary = _summaryCtrl.text.trim().isNotEmpty
        ? _summaryCtrl.text.trim()
        : (collected?.profileSummary ?? "");
    final String resolvedLinkedIn = _linkedinCtrl.text.trim().isNotEmpty
        ? _linkedinCtrl.text.trim()
        : (collected?.personalInfo?.linkedIn ?? "");
    final String resolvedGitHub = _githubCtrl.text.trim().isNotEmpty
        ? _githubCtrl.text.trim()
        : (collected?.personalInfo?.github ?? "");
    final String resolvedLocation = collected?.personalInfo?.location ?? "";

    final collegeArray = collected?.education?.college ?? [];
    final secondaryData = collected?.education?.school?.secondary;
    final higherSecondaryData = collected?.education?.school?.higherSecondary;

    final collegeList = collegeArray.isNotEmpty
        ? collegeArray
              .map(
                (c) => {
                  'degree': c.degree ?? '',
                  'department': c.department ?? '',
                  'institution': c.institution ?? '',
                  'start_year': c.startYear ?? '',
                  'end_year': c.endYear ?? '',
                },
              )
              .toList()
        : [];

    final higherSecMap = {
      'institution': _higherInstCtrl.text.trim().isNotEmpty
          ? _higherInstCtrl.text.trim()
          : (higherSecondaryData?.institution ?? ''),
      'board': _higherBoardCtrl.text.trim().isNotEmpty
          ? _higherBoardCtrl.text.trim()
          : (higherSecondaryData?.board?.toString() ?? ''),
      'percentage': _higherPercCtrl.text.trim().isNotEmpty
          ? _higherPercCtrl.text.trim()
          : (higherSecondaryData?.percentage ?? ''),
      'year_of_passing': _higherYearCtrl.text.trim().isNotEmpty
          ? _higherYearCtrl.text.trim()
          : (higherSecondaryData?.yearOfPassing ?? ''),
    };

    final secondaryMap = {
      'institution': _secInstCtrl.text.trim().isNotEmpty
          ? _secInstCtrl.text.trim()
          : (secondaryData?.institution ?? ''),
      'board': _secBoardCtrl.text.trim().isNotEmpty
          ? _secBoardCtrl.text.trim()
          : (secondaryData?.board?.toString() ?? ''),
      'percentage': _secPercCtrl.text.trim().isNotEmpty
          ? _secPercCtrl.text.trim()
          : (secondaryData?.percentage ?? ''),
      'year_of_passing': _secYearCtrl.text.trim().isNotEmpty
          ? _secYearCtrl.text.trim()
          : (secondaryData?.yearOfPassing ?? ''),
    };

    final secondaryList = (secondaryMap['institution'] as String).isNotEmpty ||
            (secondaryMap['board'] as String).isNotEmpty
        ? [secondaryMap]
        : (secondaryData != null ? [secondaryData.toJson()] : []);
    final higherSecondaryList = (higherSecMap['institution'] as String).isNotEmpty ||
            (higherSecMap['board'] as String).isNotEmpty
        ? [higherSecMap]
        : (higherSecondaryData != null ? [higherSecondaryData.toJson()] : []);

    final educationObject = {
      'school': {
        'higher_secondary': higherSecMap,
        'secondary': secondaryMap,
      },
      'college': collegeList,
    };

    final sanitizedSecondary = sanitizePayload(secondaryList);
    final sanitizedHigherSecondary = sanitizePayload(higherSecondaryList);
    final sanitizedEducation = sanitizePayload(educationObject);
    final sanitizedCollege = sanitizePayload(collegeList);

    final rawSkills = _skillsCtrl.text.trim().isNotEmpty
        ? _skillsCtrl.text
              .split(",")
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : (collected?.skills ?? []);

    final rawLanguages = _languagesCtrl.text.trim().isNotEmpty
        ? _languagesCtrl.text
              .split(",")
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : (collected?.languages ?? []);

    final rawInterests = _interestsCtrl.text.trim().isNotEmpty
        ? _interestsCtrl.text
              .split(",")
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : (collected?.areasOfInterest ?? []);

    final rawHobbies = _hobbiesCtrl.text.trim().isNotEmpty
        ? _hobbiesCtrl.text
              .split(",")
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : (collected?.hobbies ?? []);

    final rawWorkshops = _workshopsCtrl.text.trim().isNotEmpty
        ? _workshopsCtrl.text
              .split(",")
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : (collected?.workshops ?? []);

    final rawAchievements = _achievementsCtrl.text.trim().isNotEmpty
        ? _achievementsCtrl.text
              .split(",")
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : (collected?.achievements ?? []);

    final rawProjects = sanitizePayload(
      collected?.projects?.map((e) => e.toJson()).toList() ?? [],
    );
    final rawInternships = sanitizePayload(
      collected?.internships?.map((e) => e.toJson()).toList() ?? [],
    );
    final rawPaperPresentations = sanitizePayload(
      collected?.paperPresentations?.map((e) => e.toJson()).toList() ?? [],
    );
    final rawCertifications = sanitizePayload(
      collected?.certifications?.map((e) => e.toJson()).toList() ?? [],
    );
    final rawIndustrialVisits = sanitizePayload(
      collected?.industrialVisits?.map((e) => e.toJson()).toList() ?? [],
    );
    final rawPublications = collected?.publications ?? [];
    final rawLeadership = collected?.leadership ?? [];
    final rawVolunteerExperience = collected?.volunteerExperience ?? [];

    final resolvedDegree = _degreeCtrl.text.trim().isNotEmpty
        ? _degreeCtrl.text.trim()
        : (collegeArray.isNotEmpty ? collegeArray.first.degree ?? "" : "");

    final resolvedCollegeName = _institutionCtrl.text.trim().isNotEmpty
        ? _institutionCtrl.text.trim()
        : (collegeArray.isNotEmpty
              ? collegeArray.first.institution ?? ""
              : "");

    // 1. Build Payload for Profile Update API (jsonEncode for array/object fields to support FormData)
    Map<String, dynamic> apiPayload = {
      "studname": resolvedName,
      "surname": resolvedSurname,
      "role": resolvedRole,
      "studemail": resolvedEmail,
      "studmobileno": resolvedPhone,
      "profile_summary": resolvedSummary,
      "location": resolvedLocation,
      "refcode": "",
      "linkedIn": resolvedLinkedIn,
      "github": resolvedGitHub,
      "portfolio_website": resolvedGitHub,

      "studprogramminglang": jsonEncode(rawSkills),
      "languages_known": jsonEncode(rawLanguages),
      "areas_of_interest": jsonEncode(rawInterests),
      "hobbies": jsonEncode(rawHobbies),

      "projects": jsonEncode(rawProjects),
      "internships": jsonEncode(rawInternships),
      "paper_presentations": jsonEncode(rawPaperPresentations),
      "studentcertificate": jsonEncode(rawCertifications),
      "industrial_visits": jsonEncode(rawIndustrialVisits),
      "workshops": jsonEncode(rawWorkshops),
      "publications": jsonEncode(rawPublications),
      "achievements": jsonEncode(rawAchievements),
      "leadership": jsonEncode(rawLeadership),
      "volunteer_experience": jsonEncode(rawVolunteerExperience),

      "secondary": jsonEncode(sanitizedSecondary),
      "higher_secondary": jsonEncode(sanitizedHigherSecondary),
      "college": jsonEncode(sanitizedCollege),
      "education": jsonEncode(sanitizedEducation),
      "colleges1": jsonEncode(sanitizedCollege),
      "colleges2": jsonEncode([]),
      "colleges3": jsonEncode([]),
      "studentdegree": resolvedDegree,
      "studentcollegename": resolvedCollegeName,
      "institution": jsonEncode([
        {
          "institution1": resolvedCollegeName,
          "institution2": "",
          "institution3": "",
        },
      ]),
      "degree": jsonEncode([
        {
          "degree1": resolvedDegree,
          "degree2": "",
          "degree3": "",
        },
      ]),
    };

    try {
      // 2. Build Chat Resume Payload (native Dart maps/lists for JSON body)
      Map<String, dynamic> chatPayload = {
        "action": "send_message",
        "user_id": userId,
        "message": "",
        "collected_data": {
          "profile_summary": resolvedSummary,
          "personal_info": {
            "name": resolvedName,
            "surname": resolvedSurname,
            "email": resolvedEmail,
            "phone": resolvedPhone,
            "linkedIn": resolvedLinkedIn,
            "github": resolvedGitHub,
            "portfolio": resolvedGitHub,
            "location": resolvedLocation,
            "role": resolvedRole,
          },
          "refcode": "",
          "skills": rawSkills,
          "internships": rawInternships,
          "projects": rawProjects,
          "industrial_visits": rawIndustrialVisits,
          "education": sanitizedEducation,
          "certifications": rawCertifications,
          "paper_presentations": rawPaperPresentations,
          "workshops": rawWorkshops,
          "publications": rawPublications,
          "achievements": rawAchievements,
          "leadership": rawLeadership,
          "volunteer_experience": rawVolunteerExperience,
          "languages": rawLanguages,
          "areas_of_interest": rawInterests,
          "hobbies": rawHobbies,
          "colleges1": sanitizedCollege,
          "colleges2": [],
          "colleges3": [],
          "institution": [
            {
              "institution1": resolvedCollegeName,
              "institution2": "",
              "institution3": "",
            },
          ],
          "degree": [
            {"degree1": resolvedDegree, "degree2": "", "degree3": ""},
          ],
        },
      };

      // Call Chat Resume Sync API first
      _logApi(title: "updateCompleteSectionInfo -> createNewChatResume REQUEST", data: chatPayload);
      await loginController.createNewChatResume(chatRequestData: chatPayload);
      _logApi(
        title: "updateCompleteSectionInfo -> createNewChatResume RESPONSE [Status: ${loginController.getResponseCode()}]",
        data: loginController.createNewResumeModel.toJson(),
      );

      final int statusCode = loginController.getResponseCode();

      if (statusCode == 200 || statusCode == 201) {
        debugPrint("%%%%%%%%%%%%%%%%%%%");
        debugPrint(completedSection.toString());
        if (completedSection == "mobile_otp_completed") {
          debugPrint("&&&&&&&&&&&&&&&");
          await callRegisterApi(payload: apiPayload);
        }

        // Call Profile Update API
        if ((apiPayload["studemail"] != null && apiPayload["studemail"] != "") &&
            (apiPayload["studmobileno"] != null &&
                apiPayload["studmobileno"] != "")) {
          _logApi(title: "updateStudentProfileData (apiPayload) REQUEST", data: apiPayload);
          await registerController.updateChatStudentProfileData(
            updateData: apiPayload,
          );
          _logApi(
            title: "updateStudentProfileData (apiPayload) RESPONSE [Status: ${registerController.getResponseCode()}]",
            data: {
              "message": registerController.updateChatProfileModel.message,
              "student": registerController.updateChatProfileModel.profileUpdateData?.toJson(),
            },
          );
        }

        // Refresh Live Preview Model — use FRESH data from API response as base,
        // then overlay local controller edits on top
        final freshCollected =
            loginController.createNewResumeModel.collectedData;

        loginController.createNewResumeModel.collectedData =
            ResumeCollectedData(
              personalInfo: PersonalInfoModel(
                name: resolvedName,
                sureName: resolvedSurname,
                role: resolvedRole,
                email: resolvedEmail,
                phone: resolvedPhone,
                linkedIn: resolvedLinkedIn,
                github: resolvedGitHub,
                gender: "",
                location: resolvedLocation,
              ),
              profileSummary: resolvedSummary,
              skills: rawSkills,
              hobbies: _hobbiesCtrl.text.trim().isNotEmpty
                  ? _hobbiesCtrl.text.split(",").map((e) => e.trim()).toList()
                  : (freshCollected?.hobbies ?? collected?.hobbies),
              languages: _languagesCtrl.text.trim().isNotEmpty
                  ? _languagesCtrl.text.split(",").map((e) => e.trim()).toList()
                  : (freshCollected?.languages ?? collected?.languages),
              areasOfInterest: _interestsCtrl.text.trim().isNotEmpty
                  ? _interestsCtrl.text.split(",").map((e) => e.trim()).toList()
                  : (freshCollected?.areasOfInterest ?? collected?.areasOfInterest),
              // Use fresh API data for projects, internships, certs, education,
              // paper presentations — these come from the backend, not local controllers
              projects: freshCollected?.projects ?? collected?.projects,
              internships: freshCollected?.internships ?? collected?.internships,
              certifications: freshCollected?.certifications ?? collected?.certifications,
              education: freshCollected?.education ?? collected?.education,
              paperPresentations: freshCollected?.paperPresentations ?? collected?.paperPresentations,
              industrialVisits: freshCollected?.industrialVisits ?? collected?.industrialVisits,
              workshops: freshCollected?.workshops ?? collected?.workshops,
              publications: freshCollected?.publications ?? collected?.publications,
              achievements: freshCollected?.achievements ?? collected?.achievements,
              leadership: freshCollected?.leadership ?? collected?.leadership,
              volunteerExperience: freshCollected?.volunteerExperience ?? collected?.volunteerExperience,
              colleges1: freshCollected?.colleges1 ?? collected?.colleges1,
            );
        debugPrint("%%%%%%%%%%%%%%%%");
        loginController.createNewResumeModelRx.refresh();
        debugPrint(
          "REFRESH DONE — collectedData name: ${loginController.createNewResumeModel.collectedData?.personalInfo?.name}",
        );
        debugPrint("%%%%%%%%%%%%%%%%");
        //await registerController.getStudentProfile(studentId: "");
        if (isDone && mounted) {
          debugPrint("^^^^^^^^^^^^^^^^^^^^^^^^^");
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
      debugPrint("getStudentProfile(empty id) THREW: $error");
    }
  }

  Future<void> callRegisterApi({required Map<String, dynamic> payload}) async {
    try {
      _logApi(title: "callRegisterApi REQUEST", data: payload);
      await registerController.registerNewStudent(registerData: payload);
      _logApi(
        title: "callRegisterApi RESPONSE [Status: ${registerController.getResponseCode()}]",
        data: {
          "message": registerController.studentRegisterModel.message,
          "studentToken": registerController.studentRegisterModel.studentToken,
          "registerData": registerController.studentRegisterModel.registerData?.toJson(),
        },
      );
      if (registerController.getResponseCode() == 200 ||
          registerController.getResponseCode() == 201) {
        final prefs = await SharedPreferences.getInstance();
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
        if (!mounted) return;
        await _showRegistrationSuccessDialog();
      } else {
        AppFunctions.apiErrorHandling(
          registerController.getResponseCode(),
          "Failed to Register!. Please try again!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Failed to Register!. Please try again!",
      );
    }
  }

  Future<void> _showRegistrationSuccessDialog() async {
    const int creditsAdded = 200;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => RegistrationSuccessDialog(
        creditsAdded: creditsAdded,
        onContinue: () async {
          Get.back();
          //await getStudentProfileData();
        },
      ),
    );
  }

  Future<void> getStudentProfileData() async {
    final String studentId =
        registerController.studentRegisterModel.registerData?.id ?? "";
    if (studentId.isEmpty) return;

    _logApi(title: "getStudentProfileData REQUEST", data: {"studentId": studentId});
    await registerController.getStudentProfile(studentId: studentId);
    _logApi(
      title: "getStudentProfileData RESPONSE [Status: ${registerController.getResponseCode()}]",
      data: registerController.studentProfileModel.toJson(),
    );
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      if (!mounted) return;
      AppFunctions.navigateScreen(
        context,
        AppRoutes.chatResumeTemplateScreen,
        arguments: {
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
    bool isQuizMessage = isBot && msg.text.contains("Quiz done!");
    bool isSuccessMessage = isBot && msg.text.contains("🎉 Your resume is complete!");

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSuccessMessage
                        ? const LinearGradient(
                            colors: [Color(0xFF0F5257), Color(0xFF0B6623)],
                          )
                        : isQuizMessage
                            ? const LinearGradient(
                                colors: [Color(0xFF0D3B3F), Color(0xFF0F4C47)],
                              )
                            : LinearGradient(
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
                    border: isSuccessMessage
                        ? Border.all(
                            color: const Color(0xFF25D366),
                            width: 1.5,
                          )
                        : isQuizMessage
                            ? Border.all(
                                color: const Color(0xFF19C37D).withOpacity(0.6),
                                width: 1,
                              )
                            : null,
                  ),
                  child: Text(
                    msg.text,
                    style: AppStyles.customTextStyle(
                      lineSpace: 1.2,
                      size: 14,
                      weight: isQuizMessage ? FontWeight.w600 : FontWeight.w400,
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
    if (_isChatCompleted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.chatGradient3.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF25D366).withOpacity(0.5)),
        ),
        child: Text(
          "Resume build completed! Redirecting...",
          textAlign: TextAlign.center,
          style: AppStyles.customTextStyle(
            size: 13,
            weight: FontWeight.w600,
            color: const Color(0xFF25D366),
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end, // Keeps send button aligned to bottom as box expands
      children: [
        Expanded(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.chatGradient3,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: chatTextController,
                focusNode: chatFocusNode,
                minLines: 1, // Starts at 1 line
                maxLines: 5, // Expands up to 5 lines dynamically
                keyboardType: TextInputType.multiline,
                style: AppStyles.customTextStyle(
                  size: 14,
                  weight: FontWeight.w400,
                  color: AppColors.whiteColor,
                ),
                cursorColor: AppColors.primaryColor,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero, // Allows Container padding to govern layout
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
        ),
        IconButton(
          icon: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child:  Icon(
              CupertinoIcons.location,
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

      // Extract skills, languages, hobbies, interests dynamically from controllers if available
      final skillsList = _skillsCtrl.text.trim().isNotEmpty
          ? _skillsCtrl.text
                .split(",")
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList()
          : (collected.skills ?? []);

      final languagesList = _languagesCtrl.text.trim().isNotEmpty
          ? _languagesCtrl.text
                .split(",")
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList()
          : (collected.languages ?? []);

      final hobbiesList = _hobbiesCtrl.text.trim().isNotEmpty
          ? _hobbiesCtrl.text
                .split(",")
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList()
          : (collected.hobbies ?? []);

      final interestsList = _interestsCtrl.text.trim().isNotEmpty
          ? _interestsCtrl.text
                .split(",")
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList()
          : (collected.areasOfInterest ?? []);
      debugPrint("*****************");
      debugPrint(collected.personalInfo?.name);

      final resumeData = NewStudentProfileModel(
        // Personal Details (Flattened)
        // studentName: _nameCtrl.text.trim().isNotEmpty
        //     ? _nameCtrl.text.trim()
        //     : (collected.personalInfo?.name ?? ""),
        studentName: collected.personalInfo?.name,
        studentGender: collected.personalInfo?.gender ?? "",
        studEmail: _emailCtrl.text.trim().isNotEmpty
            ? _emailCtrl.text.trim()
            : (collected.personalInfo?.email ?? ""),
        role: collected.personalInfo?.role,
        studMobileNo: _mobileCtrl.text.trim().isNotEmpty
            ? _mobileCtrl.text.trim()
            : (collected.personalInfo?.phone ?? ""),
        linkedIn: _linkedinCtrl.text.trim().isNotEmpty
            ? _linkedinCtrl.text.trim()
            : collected.personalInfo?.linkedIn,
        github: _githubCtrl.text.trim().isNotEmpty
            ? _githubCtrl.text.trim()
            : collected.personalInfo?.github,
        location: collected.personalInfo?.location ?? "",
        profileSummary: _summaryCtrl.text.trim().isNotEmpty
            ? _summaryCtrl.text.trim()
            : (collected.profileSummary ?? ""),

        // Lists & Collections
        studProgrammingLang: skillsList,
        languagesKnown: languagesList,
        hobbies: hobbiesList,
        areasOfInterest: interestsList,
        internships: collected.internships ?? [],
        projects: collected.projects ?? [],
        industrialVisits: collected.industrialVisits ?? [],
        volunteerExperience: collected.volunteerExperience ?? [],
        leadership: collected.leadership ?? [],
        achievements: collected.achievements ?? [],
        publications: collected.publications ?? [],
        workshops: collected.workshops ?? [],
        paperPresentations: collected.paperPresentations ?? [],

        // Education & Schooling
        education: collected.education,
        college: (collected.education?.college != null && collected.education!.college!.isNotEmpty)
            ? collected.education!.college!
            : (collected.colleges1 != null && collected.colleges1!.isNotEmpty)
                ? collected.colleges1!
                : [],
        higherSecondary: collected.education?.school?.higherSecondary != null
            ? [collected.education!.school!.higherSecondary!]
            : [],
        secondary: collected.education?.school?.secondary != null
            ? [collected.education!.school!.secondary!]
            : [],

        studentCertificate: collected.certifications != null
            ? collected.certifications!
                .map((c) => StudentCertificate(
                      name: c.name,
                      issuer: c.issuer,
                      date: c.date?.toString(),
                    ))
                .toList()
            : [],
        verifiedItems: _verifiedItems.toList(),

        // Empty Defaults
        experience: const [],
        trainings: const [],
        parents: const [],
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
      "higher_secondary",
      "Higher Secondary",
      "12th Grade Details",
      Icons.school_outlined,
      Color(0xFFE67E22),
    ),
    ResumeSectionMeta(
      "secondary",
      "Secondary",
      "10th Grade Details",
      Icons.school_outlined,
      Color(0xFFD35400),
    ),
    ResumeSectionMeta(
      "education",
      "College",
      "Degree & College Details",
      Icons.school,
      Color(0xFF162447),
    ),
    ResumeSectionMeta(
      "internships",
      "Internships",
      "Work Experience",
      Icons.work,
      Color(0xFF8E44AD),
    ),
    ResumeSectionMeta(
      "projects",
      "Projects",
      "Academic & Personal Projects",
      Icons.rocket_launch,
      Color(0xFFE74C3C),
    ),
    ResumeSectionMeta(
      "certifications",
      "Certifications",
      "Courses & Certifications",
      Icons.card_membership,
      Color(0xFF27AE60),
    ),
    ResumeSectionMeta(
      "paper_presentations",
      "Paper Presentations",
      "Conference Papers & Events",
      Icons.article,
      Color(0xFF2980B9),
    ),
    ResumeSectionMeta(
      "industrial_visits",
      "Industrial Visits",
      "Exposure & Company Visits",
      Icons.factory,
      Color(0xFF16A085),
    ),
    ResumeSectionMeta(
      "workshops",
      "Workshops",
      "Workshops Attended",
      Icons.build,
      Color(0xFFF39C12),
    ),
    ResumeSectionMeta(
      "achievements",
      "Achievements",
      "Awards & Honors",
      Icons.emoji_events,
      Color(0xFFF1C40F),
    ),
    ResumeSectionMeta(
      "languages",
      "Languages",
      "Languages Known",
      Icons.language,
      Color(0xFF1F9D6C),
    ),
    ResumeSectionMeta(
      "interests",
      "Areas of Interest",
      "Domain Interests",
      Icons.favorite,
      Color(0xFFE0457B),
    ),
    ResumeSectionMeta(
      "hobbies",
      "Hobbies",
      "Your Interests & Hobbies",
      Icons.sports_esports,
      Color(0xFF7A4FE0),
    ),
  ];

  bool _isSectionEditable(String key, ResumeCollectedData? collected) {
    return true; // Always display all sections for complete user accessibility
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
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    iconColor: AppColors.primaryColor,
                    collapsedIconColor: AppColors.primaryColor,
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
              isEnabled: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _mobileCtrl,
              labelText: "Mobile Number",
              isNumberKeyboard: true,
              isEnabled: false,
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
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                await updateCompleteSectionInfo();
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
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                await updateCompleteSectionInfo();
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
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                await updateCompleteSectionInfo();
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
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                await updateCompleteSectionInfo();
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
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                await updateCompleteSectionInfo();
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
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                await updateCompleteSectionInfo();
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
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                await updateCompleteSectionInfo();
                AppAlertUtils.showToast(message: "Hobbies updated!");
              },
            ),
          ],
        );
      case "higher_secondary":
        return Column(
          children: [
            CustomTextField(
              controller: _higherInstCtrl,
              labelText: "Institution / School Name",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _higherBoardCtrl,
              labelText: "Board (e.g. State, CBSE)",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _higherPercCtrl,
              labelText: "Percentage / Marks",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _higherYearCtrl,
              labelText: "Year of Passing",
              isNumberKeyboard: true,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Higher Secondary",
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                final collected = loginController.createNewResumeModel.collectedData;
                final existingSchool = collected?.education?.school;
                final updatedHigher = HigherSecondary(
                  institution: _higherInstCtrl.text.trim(),
                  board: _higherBoardCtrl.text.trim(),
                  percentage: _higherPercCtrl.text.trim(),
                  yearOfPassing: _higherYearCtrl.text.trim(),
                );
                collected?.education = NewEducationData(
                  school: School(
                    higherSecondary: updatedHigher,
                    secondary: existingSchool?.secondary ?? Secondary(),
                  ),
                  college: collected.education?.college,
                );
                await updateCompleteSectionInfo();
                AppAlertUtils.showToast(message: "Higher Secondary updated!");
              },
            ),
          ],
        );
      case "secondary":
        return Column(
          children: [
            CustomTextField(
              controller: _secInstCtrl,
              labelText: "Institution / School Name",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _secBoardCtrl,
              labelText: "Board (e.g. State, CBSE)",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _secPercCtrl,
              labelText: "Percentage / Marks",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _secYearCtrl,
              labelText: "Year of Passing",
              isNumberKeyboard: true,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Secondary",
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                final collected = loginController.createNewResumeModel.collectedData;
                final existingSchool = collected?.education?.school;
                final updatedSec = Secondary(
                  institution: _secInstCtrl.text.trim(),
                  board: _secBoardCtrl.text.trim(),
                  percentage: _secPercCtrl.text.trim(),
                  yearOfPassing: _secYearCtrl.text.trim(),
                );
                collected?.education = NewEducationData(
                  school: School(
                    higherSecondary: existingSchool?.higherSecondary ?? HigherSecondary(),
                    secondary: updatedSec,
                  ),
                  college: collected.education?.college,
                );
                await updateCompleteSectionInfo();
                AppAlertUtils.showToast(message: "Secondary updated!");
              },
            ),
          ],
        );
      case "workshops":
        return Column(
          children: [
            CustomTextField(
              controller: _workshopsCtrl,
              labelText: "Workshops Attended (comma separated)",
              hintText: "e.g., AI Workshop, Cloud Seminar",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Workshops",
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                final collected = loginController.createNewResumeModel.collectedData;
                collected?.workshops = _workshopsCtrl.text
                    .split(",")
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                await updateCompleteSectionInfo();
                AppAlertUtils.showToast(message: "Workshops updated!");
              },
            ),
          ],
        );
      case "achievements":
        return Column(
          children: [
            CustomTextField(
              controller: _achievementsCtrl,
              labelText: "Achievements (comma separated)",
              hintText: "e.g., Hackathon 1st Place, Best Paper Award",
              isNumberKeyboard: false,
              isProfileFlow: true,
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              buttonText: "Update Achievements",
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                final collected = loginController.createNewResumeModel.collectedData;
                collected?.achievements = _achievementsCtrl.text
                    .split(",")
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                await updateCompleteSectionInfo();
                AppAlertUtils.showToast(message: "Achievements updated!");
              },
            ),
          ],
        );
      case "internships":
      case "projects":
      case "certifications":
      case "paper_presentations":
      case "industrial_visits":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Section details are collected dynamically in the chat or live preview.",
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.chatTextColor,
              ),
            ),
            const SizedBox(height: 10),
            CustomButtonWidget(
              buttonText: "Save & Refresh Section",
              isLoading: registerController.updateChatProfileLoading,
              buttonFunction: () async {
                await updateCompleteSectionInfo();
                AppAlertUtils.showToast(message: "Section data synced!");
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
