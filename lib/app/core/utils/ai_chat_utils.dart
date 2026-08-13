// A lightweight fallback preview card, used only until you wire in your real
// ShowTemplateView (see the TODO in `_buildLivePreviewBody`).
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart'
    show CustomButtonWidget;
import 'package:internsharks/app/data/models/account/chat_mcq_question_model.dart';
import 'package:internsharks/app/data/models/account/chat_mcq_result_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/modules/login/view/chat_new_resume_creation_screen.dart';

class LivePreviewSummaryCard extends StatelessWidget {
  final ExtractedResumeDataModel resumeData;

  const LivePreviewSummaryCard({super.key, required this.resumeData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resumeData.personalInfo!.name.isEmpty
                ? "Your Name"
                : resumeData.personalInfo!.name,
            style: AppStyles.customTextStyle(
              size: 20,
              weight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            resumeData.profileSummary ?? "___",
            style: AppStyles.customTextStyle(
              size: 13,
              weight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          if ((resumeData.skills ?? []).isNotEmpty) ...[
            Text(
              "Skills",
              style: AppStyles.customTextStyle(
                size: 14,
                weight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (resumeData.skills ?? [])
                  .map((s) => Chip(label: Text(s)))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// KNOWLEDGE CHECK (mandatory quiz) DIALOG
// ============================================================================

class KnowledgeCheckDialog extends StatefulWidget {
  final String sectionCode;
  final ChatMcqQuestionModel quizModel;
  final Future<ChatMcqResultModel?> Function(List<String> answers) onSubmit;

  const KnowledgeCheckDialog({
    super.key,
    required this.sectionCode,
    required this.quizModel,
    required this.onSubmit,
  });

  @override
  State<KnowledgeCheckDialog> createState() => _KnowledgeCheckDialogState();
}

class _KnowledgeCheckDialogState extends State<KnowledgeCheckDialog> {
  late final List<QuizItem> _questions = _flatten(widget.quizModel);
  final Map<int, String> _answers = {}; // questionIndex -> "A"/"B"/"C"/"D"
  bool _submitting = false;
  ChatMcqResultModel? _result;

  List<QuizItem> _flatten(ChatMcqQuestionModel model) {
    final List<QuizItem> list = [];
    for (final skillGroup in model.questions ?? <ChatQuizQuestion>[]) {
      list.addAll(skillGroup.questions ?? <QuizItem>[]);
    }
    return list;
  }

  Map<String, String> _optionMap(QuestionOptions? o) => {
    "A": o?.a ?? "",
    "B": o?.b ?? "",
    "C": o?.c ?? "",
    "D": o?.d ?? "",
  };

  bool get _allAnswered => _answers.length == _questions.length;

  Future<void> _submit() async {
    if (!_allAnswered || _submitting) return;
    setState(() => _submitting = true);

    final answers = List.generate(_questions.length, (i) => _answers[i] ?? "");
    final result = await widget.onSubmit(answers);

    if (!mounted) return;

    if (result == null) {
      setState(() => _submitting = false);
      return;
    }

    setState(() {
      _result = result;
      _submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_result != null) {
      return QuizReviewDialog(result: _result!);
    }

    final String topicLabel =
        widget.quizModel.topicLabel ??
        kQuizSectionLabel[widget.sectionCode] ??
        widget.sectionCode;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        decoration: BoxDecoration(
          color: const Color(0xFF0E1B2B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFF139E8C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Text("🎯", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text(
                          "KNOWLEDGE CHECK",
                          style: AppStyles.customTextStyle(
                            size: 16,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Verification Quiz ($topicLabel)",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            weight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: _questions.length,
                itemBuilder: (context, index) =>
                    _buildQuestionCard(index, _questions[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _allAnswered && !_submitting ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _allAnswered
                            ? const Color(0xFF139E8C)
                            : const Color(0xFF1C2B3D),
                        disabledBackgroundColor: const Color(0xFF1C2B3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Submit Quiz  →  (${_answers.length}/${_questions.length})",
                              style: AppStyles.customTextStyle(
                                size: 14,
                                weight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  if (!_allAnswered) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Answer all ${_questions.length} questions to submit",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        weight: FontWeight.w400,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index, QuizItem question) {
    final options = _optionMap(question.options!);
    final selected = _answers[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF15263B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF139E8C).withOpacity(0.25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "Q${index + 1}",
              style: AppStyles.customTextStyle(
                size: 11,
                weight: FontWeight.w700,
                color: const Color(0xFF3FD1BC),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.question ?? "",
            style: AppStyles.customTextStyle(
              size: 14,
              weight: FontWeight.w600,
              lineSpace: 1.4,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: options.entries.map((entry) {
              final isSelected = selected == entry.key;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _answers[index] = entry.key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF139E8C).withOpacity(0.25)
                          : const Color(0xFF1C2B3D),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF3FD1BC)
                            : Colors.transparent,
                        width: 1.4,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A3B52),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            entry.key,
                            style: AppStyles.customTextStyle(
                              size: 11,
                              weight: FontWeight.w700,
                              color: const Color(0xFF9FD8FF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.value,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.customTextStyle(
                              size: 12,
                              weight: FontWeight.w500,
                              color: Colors.white,
                              lineSpace: 1.3
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// QUIZ REVIEW DIALOG (post-submit score + correct/incorrect breakdown)
// ============================================================================

class QuizReviewDialog extends StatelessWidget {
  final ChatMcqResultModel result;

  const QuizReviewDialog({super.key, required this.result});

  List<ValidationQuestion> get _allQuestions {
    final List<ValidationQuestion> list = [];
    for (final skill in result.questions ?? <QuizValidation>[]) {
      list.addAll(skill.questions ?? <ValidationQuestion>[]);
    }
    return list;
  }

  Map<String, String> _optionMap(QuestionOptions? o) => {
    "A": o?.a ?? "",
    "B": o?.b ?? "",
    "C": o?.c ?? "",
    "D": o?.d ?? "",
  };

  @override
  Widget build(BuildContext context) {
    final questions = _allQuestions;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        decoration: BoxDecoration(
          color: const Color(0xFF0E1B2B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFF139E8C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Text("📊", style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text(
                          "QUIZ REVIEW",
                          style: AppStyles.customTextStyle(
                            size: 16,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Verification Quiz",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            weight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Score: ${result.score ?? 0} / ${result.total ?? questions.length}",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: questions.length,
                itemBuilder: (context, index) =>
                    buildReviewCard(index, questions[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF19C37D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Close & Continue",
                    style: AppStyles.customTextStyle(
                      size: 15,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReviewCard(int index, ValidationQuestion q) {
    final options = _optionMap(q.options);

    // 1. Determine correct option key ("A", "B", "C", or "D")
    String? correctOptionKey;

    if (result.correctIndices != null &&
        index < result.correctIndices!.length) {
      correctOptionKey = result.correctIndices![index].trim().toUpperCase();
    }

    if (correctOptionKey == null || !options.containsKey(correctOptionKey)) {
      if (q.correctAnswer != null && options.containsKey(q.correctAnswer)) {
        correctOptionKey = q.correctAnswer;
      }
    }

    if (correctOptionKey == null || !options.containsKey(correctOptionKey)) {
      final matchEntry = options.entries.firstWhere(
            (e) =>
        e.value.trim().toLowerCase() ==
            (q.correctAnswer ?? '').trim().toLowerCase(),
        orElse: () => const MapEntry("", ""),
      );
      if (matchEntry.key.isNotEmpty) {
        correctOptionKey = matchEntry.key;
      }
    }

    // 2. Normalize selected answer key ("A", "B", "C", "D")
    String? selectedOptionKey = q.selectAnswer ?? q.answer;
    if (selectedOptionKey != null && !options.containsKey(selectedOptionKey)) {
      final selectedMatch = options.entries.firstWhere(
            (e) =>
        e.value.trim().toLowerCase() ==
            selectedOptionKey!.trim().toLowerCase(),
        orElse: () => const MapEntry("", ""),
      );
      if (selectedMatch.key.isNotEmpty) {
        selectedOptionKey = selectedMatch.key;
      }
    }

    final bool isCorrect =
        selectedOptionKey != null && selectedOptionKey == correctOptionKey;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF15263B),
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(
            color: isCorrect
                ? const Color(0xFF19C37D)
                : const Color(0xFFE94F4F),
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF139E8C).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Q${index + 1}",
                  style: AppStyles.customTextStyle(
                    size: 11,
                    weight: FontWeight.w700,
                    color: const Color(0xFF3FD1BC),
                  ),
                ),
              ),
              Container(
                width: 34,
                height: 8,
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xFF19C37D)
                      : const Color(0xFFE94F4F),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            q.question ?? "",
            style: AppStyles.customTextStyle(
              size: 14,
              weight: FontWeight.w600,
              color: Colors.white,
              lineSpace: 1.3
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: options.entries.map((entry) {
              final bool isCorrectOption = entry.key == correctOptionKey;
              final bool isWrongSelected =
                  entry.key == selectedOptionKey && !isCorrectOption;

              Color borderColor = Colors.transparent;
              Color bgColor = const Color(0xFF1C2B3D);
              if (isCorrectOption) {
                borderColor = const Color(0xFF19C37D);
                bgColor = const Color(0xFF19C37D).withOpacity(0.12);
              } else if (isWrongSelected) {
                borderColor = const Color(0xFFE94F4F);
                bgColor = const Color(0xFFE94F4F).withOpacity(0.12);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 1.4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3B52),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          entry.key,
                          style: AppStyles.customTextStyle(
                            size: 11,
                            weight: FontWeight.w700,
                            color: const Color(0xFF9FD8FF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.value,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.customTextStyle(
                            size: 12,
                            weight: FontWeight.w500,
                            color: Colors.white,
                            lineSpace: 1.3
                          ),
                        ),
                      ),
                      if (isCorrectOption)
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Color(0xFF19C37D),
                        ),
                      if (isWrongSelected)
                        const Icon(
                          Icons.cancel,
                          size: 16,
                          color: Color(0xFFE94F4F),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// REGISTRATION SUCCESS DIALOG (mobile_otp_completed -> register -> success)
// ============================================================================

class RegistrationSuccessDialog extends StatelessWidget {
  final int creditsAdded;
  final VoidCallback onContinue;

  const RegistrationSuccessDialog({
    super.key,
    required this.creditsAdded,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF16536B), Color(0xFF16786B)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -16,
              right: -16,
              child: GestureDetector(
                onTap: onContinue,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF6C445).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    AssetImages.creditsIconNew,
                    height: 30,
                    width: 30,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Registration Complete! 🎉",
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 18,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onContinue,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF19C37D),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      "+$creditsAdded Credits Added",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Unlock premium templates & fonts with your new credits",
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: AppColors.whiteColor.withOpacity(0.85),
                    weight: FontWeight.w400,
                    lineSpace: 1.3,
                  ),
                ),
                const SizedBox(height: 22),
                CustomButtonWidget(
                  buttonFunction: onContinue,
                  buttonText: "CONTINUE",
                  width: 180,
                  height: 42,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResumeSectionMeta {
  final String key;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const ResumeSectionMeta(
    this.key,
    this.title,
    this.subtitle,
    this.icon,
    this.color,
  );
}
