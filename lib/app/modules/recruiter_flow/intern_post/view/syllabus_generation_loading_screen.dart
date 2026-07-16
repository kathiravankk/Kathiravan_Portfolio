import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

class SyllabusGeneratingScreen extends StatefulWidget {
  final Future<bool> Function() onProcess;

  const SyllabusGeneratingScreen({super.key, required this.onProcess});

  @override
  State<SyllabusGeneratingScreen> createState() =>
      _SyllabusGeneratingScreenState();
}

class _SyllabusGeneratingScreenState extends State<SyllabusGeneratingScreen> {
  static const List<String> _steps = [
    '🧠 Analyzing candidate skills and knowledge gaps.',
    '📊 Identifying relevant topics based on goals.',
    '📚 Selecting structured learning modules.',
    '🔍 Prioritizing concepts based on importance.',
    '🧩 Mapping dependencies between topics.',
    '🗂️ Organizing content into a logical sequence.',
    '📅 Structuring syllabus with timeline.',
    '⚙️ Customizing difficulty based on user level.',
    '📈 Ensuring progressive learning flow.',
    '✅ Personalized syllabus generated successfully.',
  ];

  int _currentStep = 0;
  Timer? _timer;
  bool _apiDone = false;
  bool _success = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startStepCycle();
    _runProcess();
  }

  void _startStepCycle() {
    _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (!mounted) return;

      final atSecondToLast = _currentStep == _steps.length - 2;
      final canAdvance =
          _currentStep < _steps.length - 1 && !(atSecondToLast && !_apiDone);

      if (canAdvance) {
        setState(() => _currentStep++);
        _scrollToCurrent();
      }

      if (_success && _apiDone && _currentStep >= _steps.length - 1) {
        timer.cancel();
        _finishAndPop();
      }
    });
  }

  Future<void> _runProcess() async {
    try {
      _success = await widget.onProcess();
    } catch (_) {
      _success = false;
    }

    if (!mounted) return;

    /// API completed
    _apiDone = true;

    /// If failed don't wait for remaining fake steps.
    if (!_success) {
      _timer?.cancel();

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.pop(context, false);
        }
      });

      return;
    }

    /// Success
    if (_currentStep >= _steps.length - 1) {
      _timer?.cancel();
      _finishAndPop();
    }
  }

  void _finishAndPop() {
    if (!mounted) return;
    setState(() => _currentStep = _steps.length - 1);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) Navigator.of(context).pop(_success);
    });
  }

  void _scrollToCurrent() {
    if (!_scrollController.hasClients) return;
    final target = (_currentStep * 52).toDouble();
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentStep + 1) / _steps.length;

    return PopScope(
      canPop: false,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.chatScreenBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: AppColors.blackColor.withValues(alpha: 0.5),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.syllabusContColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.syllabusContBorder),
                    ),
                    child: Column(
                      spacing: 20,
                      children: [
                        SizedBox(
                          height: 140,
                          width: 140,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 140,
                                width: 140,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 6,
                                  backgroundColor: AppColors.whiteColor
                                      .withValues(alpha: 0.15),
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.primaryColor,
                                  ),
                                ),
                              ),
                              Column(
                                spacing: 15,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${(progress * 100).round()}%",
                                    style: AppStyles.customTextStyle(
                                      size: 30,
                                      color: AppColors.whiteColor,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "PROGRESS",
                                    style: AppStyles.customTextStyle(
                                      size: 12,
                                      color: AppColors.primaryColor,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Generating Syllabus",
                          style: AppStyles.customTextStyle(
                            size: 20,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Crafting your personalized path to mastery...",
                          textAlign: TextAlign.center,
                          style: AppStyles.customTextStyle(
                            size: 13,
                            color: AppColors.greyTextColor,
                            weight: FontWeight.w400,
                            lineSpace: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _steps.length,
                      itemBuilder: (context, index) {
                        final bool isDone =
                            index < _currentStep ||
                            (index == _currentStep &&
                                _apiDone &&
                                _currentStep == _steps.length - 1);
                        final bool isActive = index == _currentStep && !isDone;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isDone
                                  ? Icon(
                                      Icons.check_circle,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    )
                                  : isActive
                                  ? Container(
                                      height: 12,
                                      width: 12,
                                      margin: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.secondaryColor,
                                      ),
                                    )
                                  : Icon(
                                      Icons.circle_outlined,
                                      color: AppColors.greyTextColor,
                                      size: 20,
                                    ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _steps[index],
                                  style: AppStyles.customTextStyle(
                                    size: 14,
                                    color: isDone || isActive
                                        ? AppColors.whiteColor
                                        : AppColors.greyTextColor,
                                    weight: isActive
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
