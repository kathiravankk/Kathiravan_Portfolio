import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';
import 'package:internsharks/app/data/providers/profile_provider.dart';
import 'package:internsharks/app/data/providers/webinar_provider.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/modules/webinar/controller/webinar_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class WebinarDetailScreen extends StatefulWidget {
  final String? webinarId;

  const WebinarDetailScreen({super.key, this.webinarId});

  @override
  State<WebinarDetailScreen> createState() => _WebinarDetailScreenState();
}

class _WebinarDetailScreenState extends State<WebinarDetailScreen> {
  late final WebinarController webinarController;
  String effectiveWebinarId = '';
  String? studentId;
  String? studentName;
  String? studentEmail;
  String? studentMobile;
  String? studentCollege;
  final Set<String> _verifiedWebinarIds = <String>{};
  String? _lastRegisteredMobile;
  Timer? _joinTickerTimer;

  @override
  void initState() {
    super.initState();

    // 1. Resolve controller
    if (Get.isRegistered<WebinarController>()) {
      webinarController = Get.find<WebinarController>();
    } else {
      webinarController = Get.put(
        WebinarController(WebinarProvider(client: Dio())),
        permanent: true,
      );
    }

    // 2. Extract webinar ID from widget or Get.arguments
    if (widget.webinarId != null && widget.webinarId!.isNotEmpty) {
      effectiveWebinarId = widget.webinarId!;
    } else if (Get.arguments != null) {
      if (Get.arguments is String) {
        effectiveWebinarId = Get.arguments as String;
      } else if (Get.arguments is Map) {
        effectiveWebinarId =
            Get.arguments['webinarId'] ?? Get.arguments['id'] ?? '';
      }
    }

    // Default fallback to provided id if empty (e.g. testing)
    if (effectiveWebinarId.isEmpty) {
      effectiveWebinarId = "6abe2454646b8d0143a0a917";
    }

    // Ensure countdown starts immediately if detail is already cached
    if (webinarController.webinarDetail != null) {
      webinarController.initCountdownFromDetail(webinarController.webinarDetail!);
    }

    // Periodic ticker to automatically update join button status when the 10-minute threshold arrives
    _joinTickerTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() {});
      }
    });

    // 3. Fetch webinar detail and profile on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWebinarData();
    });
  }

  @override
  void dispose() {
    _joinTickerTimer?.cancel();
    webinarController.stopCountdown();
    super.dispose();
  }

  int _getJoinBeforeMinutes(WebinarDetailData detail) {
    final val = detail.join?.joinBeforeMinutes ?? detail.joinBeforeMinutes;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 10;
    return 10;
  }

  DateTime? _getWebinarJoinStartTime(WebinarDetailData detail) {
    // 1. If explicit joinAt provided by API
    if (detail.join?.joinAt != null && detail.join!.joinAt!.trim().isNotEmpty) {
      final parsed = DateTime.tryParse(detail.join!.joinAt!.trim());
      if (parsed != null) return parsed.toLocal();
    }

    // 2. Fallback: calculate from webinarDate + startTime - joinBeforeMinutes
    if (detail.webinarDate != null && detail.webinarDate!.isNotEmpty) {
      DateTime? baseDate = DateTime.tryParse(detail.webinarDate!)?.toLocal();
      if (baseDate == null) {
        const formats = [
          'dd-MM-yyyy',
          'dd/MM/yyyy',
          'yyyy/MM/dd',
          'yyyy-MM-dd',
          'dd MMM yyyy',
          'd MMM yyyy',
        ];
        for (final f in formats) {
          try {
            baseDate = DateFormat(f).parseLoose(detail.webinarDate!);
            break;
          } catch (_) {}
        }
      }

      if (baseDate != null) {
        int hour = 0;
        int minute = 0;
        if (detail.startTime != null && detail.startTime!.contains(':')) {
          final parts = detail.startTime!.split(':');
          hour = int.tryParse(parts[0]) ?? 0;
          minute = int.tryParse(parts[1]) ?? 0;
        }
        final webinarStart = DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          hour,
          minute,
        );
        final int minutesBefore = _getJoinBeforeMinutes(detail);
        return webinarStart.subtract(Duration(minutes: minutesBefore));
      }
    }
    return null;
  }

  bool _canJoinWebinar(WebinarDetailData detail) {
    // Cannot join if webinar is already finished
    if ((detail.status ?? '').toLowerCase() == 'completed') {
      return false;
    }

    // Check API flags
    if (detail.join?.canJoin == true || detail.join?.joinTimeReached == true) {
      return true;
    }

    // Check if current time has reached join start time
    final joinStartTime = _getWebinarJoinStartTime(detail);
    if (joinStartTime != null) {
      return DateTime.now().isAfter(joinStartTime) ||
          DateTime.now().isAtSameMomentAs(joinStartTime);
    }

    return false;
  }

  Future<void> _loadUserProfile() async {
    try {
      studentId = await LocalStorageService.getStudentId();
      final stuMap = await LocalStorageService.getStudent();
      if (stuMap != null) {
        studentName ??= stuMap['studname'] ?? stuMap['name'] ?? stuMap['studentName'];
        studentMobile ??= stuMap['studmobileno'] ?? stuMap['mobile'] ?? stuMap['studentMobileNo'];
        studentEmail ??= stuMap['studemail'] ?? stuMap['email'] ?? stuMap['studEmail'];
      }

      if (studentId != null && studentId!.isNotEmpty) {
        final ProfileController profileCtrl = Get.isRegistered<ProfileController>()
            ? Get.find<ProfileController>()
            : Get.put(
                ProfileController(ProfileProvider(client: Dio())),
              );

        if (profileCtrl.profileDataModel.id == null ||
            profileCtrl.profileDataModel.id!.isEmpty) {
          await profileCtrl.getProfileData(studentId: studentId!);
        }

        final profile = profileCtrl.profileDataModel;
        if (profile.studentName != null && profile.studentName!.isNotEmpty) {
          studentName = profile.studentName;
        }
        if (profile.studEmail != null && profile.studEmail!.isNotEmpty) {
          studentEmail = profile.studEmail;
        }
        if (profile.studMobileNo != null && profile.studMobileNo!.isNotEmpty) {
          studentMobile = profile.studMobileNo;
        }
        if (profile.collegeName != null && profile.collegeName!.isNotEmpty) {
          studentCollege = profile.collegeName;
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    }
  }

  Future<void> _loadWebinarData() async {
    if (effectiveWebinarId.isNotEmpty) {
      await webinarController.fetchWebinarDetail(effectiveWebinarId);
    }
    await _loadUserProfile();
    webinarController.fetchColleges();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: _buildCustomAppBar(),
        body: SafeArea(
          child: Obx(() {
            if (webinarController.detailLoading) {
              return _buildLoadingState();
            }

            final detail = webinarController.webinarDetail;

            if (detail == null) {
              return _buildErrorState();
            }

            return RefreshIndicator(
              color: AppColors.primaryColor,
              backgroundColor: const Color(0xFF111D28),
              onRefresh: _loadWebinarData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HERO BANNER
                    _buildBannerCard(detail),

                    const SizedBox(height: 18),

                    // 2. TITLE WITH ACCENT STYLING
                    _buildStylizedTitle(detail.title ?? 'Webinar'),

                    if (detail.shortDescription != null &&
                        detail.shortDescription!.trim().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        detail.shortDescription!.trim(),
                        style: AppStyles.customTextStyle(
                          size: 13.5,
                          color: const Color(0xFF94A3B8),
                          lineSpace: 1.45,
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // 3. REGISTRATION & COUNTDOWN TIMER CARD
                    _buildRegistrationCountdownCard(detail),

                    const SizedBox(height: 18),

                    // 4. THREE INFO CHIPS (Category, Type, Language)
                    _buildThreeInfoChips(detail),

                    const SizedBox(height: 12),

                    // 5. REGISTRATION START & END DATES ROW
                    _buildRegistrationDatesRow(detail),

                    const SizedBox(height: 10),

                    // 6. WEBINAR DATE & TIME ROW
                    _buildWebinarScheduleRow(detail),

                    const SizedBox(height: 22),

                    // 7. ABOUT THIS WEBINAR SECTION
                    _buildAboutSection(detail),

                    const SizedBox(height: 22),

                    // 8. SPEAKER SECTION
                    if (detail.speaker != null) ...[
                      _buildSpeakerSection(detail.speaker!),
                      const SizedBox(height: 22),
                    ],

                    // 9. RELATED WEBINARS SECTION
                    if (detail.similarWebinars != null &&
                        detail.similarWebinars!.isNotEmpty) ...[
                      _buildRelatedWebinarsSection(detail.similarWebinars!),
                      const SizedBox(height: 20),
                    ],

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // CUSTOM APP BAR
  // -------------------------------------------------------------
  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: AppColors.transparentColor,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Center(
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF141F24),
                border: Border.all(
                  color: const Color(0xFF22313A),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.whiteColor,
                size: 17,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        "Webinar Details",
        style: AppStyles.customTextStyle(
          size: 18,
          weight: FontWeight.w700,
          color: AppColors.whiteColor,
        ),
      ),
      actions: [
        Center(
          child: Obx(() {
            final isSaved = webinarController.isBookmarked;
            return InkWell(
              onTap: () {
                webinarController.toggleBookmark();
                Fluttertoast.showToast(
                  msg: isSaved
                      ? "Removed from saved webinars"
                      : "Webinar saved successfully",
                  backgroundColor: const Color(0xFF1E2E40),
                  textColor: AppColors.whiteColor,
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF141F24),
                  border: Border.all(
                    color: const Color(0xFF22313A),
                    width: 1,
                  ),
                ),
                child: Icon(
                  isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isSaved
                      ? AppColors.secondaryColor
                      : AppColors.whiteColor,
                  size: 20,
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: 8),
        Center(
          child: InkWell(
            onTap: _shareWebinar,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF141F24),
                border: Border.all(
                  color: const Color(0xFF22313A),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.share_outlined,
                color: AppColors.whiteColor,
                size: 19,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
      ],
    );
  }

  void _shareWebinar() {
    final detail = webinarController.webinarDetail;
    final title = detail?.title ?? "Webinar";
    final url =
        "https://dev.api.internsharks.ai/api/webinar/getwebinarbyid/$effectiveWebinarId";
    SharePlus.instance.share(
      ShareParams(
        text: "Join this exclusive webinar: '$title' on Internsharks!\n$url",
        subject: title,
      ),
    );
  }

  // -------------------------------------------------------------
  // 1. BANNER CARD
  // -------------------------------------------------------------
  Widget _buildBannerCard(WebinarDetailData detail) {
    final bool isPaid = (detail.webinarType ?? '').toLowerCase() == 'paid' ||
        (detail.amount != null && detail.amount! > 0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          // Banner Image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: const Color(0xFF15222E),
              child: detail.bannerImage != null &&
                      detail.bannerImage!.isNotEmpty
                  ? Image.network(
                      detail.bannerImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildImageFallback(),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: const Color(0xFF15222E),
                          child: const Center(
                            child: CupertinoActivityIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        );
                      },
                    )
                  : _buildImageFallback(),
            ),
          ),

          // Gradient overlay for visual depth
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),

          // Top Left: Free/Paid Webinar Pill
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isPaid
                    ? const Color(0xFF3B1569).withValues(alpha: 0.9)
                    : const Color(0xFF0F3A2E).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isPaid
                      ? const Color(0xFFA855F7).withValues(alpha: 0.5)
                      : const Color(0xFF10B981).withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    size: 15,
                    color: isPaid
                        ? const Color(0xFFC084FC)
                        : const Color(0xFF34D399),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isPaid ? "Paid Webinar" : "Free Webinar",
                    style: AppStyles.customTextStyle(
                      size: 11.5,
                      weight: FontWeight.w700,
                      color: isPaid
                          ? const Color(0xFFE9D5FF)
                          : const Color(0xFF6EE7B7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Right: Bookmark badge
          Positioned(
            top: 14,
            right: 14,
            child: Obx(() {
              final isSaved = webinarController.isBookmarked;
              return InkWell(
                onTap: webinarController.toggleBookmark,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isSaved
                        ? AppColors.secondaryColor
                        : AppColors.whiteColor,
                    size: 18,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: const Color(0xFF14202B),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 40,
              color: AppColors.primaryColor.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 6),
            Text(
              "Internsharks Webinar",
              style: AppStyles.customTextStyle(
                size: 12,
                color: const Color(0xFF64748B),
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 2. STYLIZED TITLE (Dual-tone emphasis)
  // -------------------------------------------------------------
  Widget _buildStylizedTitle(String title) {
    // If the title contains a punctuation delimiter (e.g. "?", ".", ":")
    // or question, highlight the end clause in vibrant cyan/teal
    final questionIdx = title.indexOf('?');
    if (questionIdx != -1) {
      final before = title.substring(0, questionIdx + 1);
      final words = before.trim().split(' ');
      if (words.length > 3) {
        final mainPart = words.sublist(0, words.length - 2).join(' ');
        final accentPart = words.sublist(words.length - 2).join(' ');
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$mainPart ",
                style: AppStyles.customTextStyle(
                  size: 21,
                  weight: FontWeight.w800,
                  color: AppColors.whiteColor,
                  lineSpace: 1.25,
                ),
              ),
              TextSpan(
                text: accentPart,
                style: AppStyles.customTextStyle(
                  size: 21,
                  weight: FontWeight.w800,
                  color: AppColors.primaryColor,
                  lineSpace: 1.25,
                ),
              ),
            ],
          ),
        );
      }
    }

    return Text(
      title,
      style: AppStyles.customTextStyle(
        size: 21,
        weight: FontWeight.w800,
        color: AppColors.whiteColor,
        lineSpace: 1.25,
      ),
    );
  }

  // -------------------------------------------------------------
  // 3. REGISTRATION & COUNTDOWN TIMER CARD
  // -------------------------------------------------------------
  Widget _buildRegistrationCountdownCard(WebinarDetailData detail) {
    final regCount = detail.registrationCount ?? 0;
    final maxSeats = detail.maximumSeats != null && detail.maximumSeats! > 0
        ? detail.maximumSeats!
        : 100;
    final double progress = (regCount / maxSeats).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111D28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF1E2E42),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          // Registration closes subtitle
          Obx(() {
            final regEndDate = _formatDate(detail.registrationEndDate);
            final String closesText;
            if (webinarController.isTimerExpired) {
              closesText = "Registration closed on $regEndDate";
            } else {
              final targetDate = webinarController.parseRegistrationEndDateTime(
                registrationEndDate: detail.registrationEndDate,
                webinarDate: detail.webinarDate,
                startTime: detail.startTime,
              );
              final now = DateTime.now();
              final bool isToday = targetDate != null &&
                  targetDate.year == now.year &&
                  targetDate.month == now.month &&
                  targetDate.day == now.day;
              if (isToday) {
                closesText = "Registration closes Today at 11:59 PM";
              } else {
                closesText = "Registration closes $regEndDate at 11:59 PM";
              }
            }

            return Text(
              closesText,
              style: AppStyles.customTextStyle(
                size: 13,
                weight: FontWeight.w600,
                color: const Color(0xFFE2E8F0),
              ),
            );
          }),

          const SizedBox(height: 14),

          // 4 COUNTDOWN BLOCKS (Days, Hours, Mins, Secs)
          Obx(() {
            return Row(
              children: [
                _buildCountdownBlock(webinarController.days, "Days"),
                const SizedBox(width: 8),
                _buildCountdownBlock(webinarController.hours, "Hours"),
                const SizedBox(width: 8),
                _buildCountdownBlock(webinarController.minutes, "Mins"),
                const SizedBox(width: 8),
                _buildCountdownBlock(webinarController.seconds, "Secs"),
              ],
            );
          }),

          const SizedBox(height: 16),

          // SEATS FILLED ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.people_outline_rounded,
                    size: 16,
                    color: Color(0xFF38BDF8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "$regCount / $maxSeats Seats Filled",
                    style: AppStyles.customTextStyle(
                      size: 12.5,
                      weight: FontWeight.w600,
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                ],
              ),
              Text(
                "$maxSeats",
                style: AppStyles.customTextStyle(
                  size: 12.5,
                  weight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // SEATS PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 6,
              width: double.infinity,
              color: const Color(0xFF1E2E40),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress == 0 ? 0.04 : progress,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF01CDCD),
                        Color(0xFF38BDF8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // REGISTER NOW BUTTON
          _buildRegisterButton(detail),

          const SizedBox(height: 12),

          // JOIN BEFORE INFO
          Obx(() {
            webinarController.seconds;
            final bool isRegistered = detail.registration?.isRegistered ?? false;
            final bool isCompleted = (detail.status ?? '').toLowerCase() == 'completed';
            final int minutesBefore = _getJoinBeforeMinutes(detail);

            if (isCompleted) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.event_busy_rounded,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "This webinar has ended",
                    style: AppStyles.customTextStyle(
                      size: 11.5,
                      weight: FontWeight.w500,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              );
            }

            if (isRegistered) {
              final bool canJoin = _canJoinWebinar(detail);
              if (canJoin) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Webinar is live! You can join now",
                      style: AppStyles.customTextStyle(
                        size: 11.5,
                        weight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Join button will enable $minutesBefore mins before start time",
                      style: AppStyles.customTextStyle(
                        size: 11.5,
                        weight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                );
              }
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 6),
                Text(
                  "Join before $minutesBefore minutes of start time",
                  style: AppStyles.customTextStyle(
                    size: 11.5,
                    weight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCountdownBlock(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF172637),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF22374E),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppStyles.customTextStyle(
                size: 20,
                weight: FontWeight.w800,
                color: const Color(0xFFFFD44D),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppStyles.customTextStyle(
                size: 10.5,
                weight: FontWeight.w500,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton(WebinarDetailData detail) {
    return Obx(() {
      // Access seconds so Obx evaluates on every timer tick
      webinarController.seconds;

      final bool isRegistered = detail.registration?.isRegistered ?? false;
      final bool isCompleted = (detail.status ?? '').toLowerCase() == 'completed';
      final bool isAlreadyPaid = detail.payment?.isPaid == true ||
          (detail.payment?.status ?? '').toLowerCase() == 'paid';
      final bool isPaid = !isAlreadyPaid &&
          ((detail.payment?.required == true) ||
              (detail.webinarType ?? '').toLowerCase() == 'paid' ||
              (detail.amount != null && detail.amount! > 0));
      final bool isRegistrationClosed = webinarController.isTimerExpired ||
          (detail.allowRegistration == false && !isRegistered);

      String buttonText = "Register Now";
      Color textColor = const Color(0xFF071D22);
      List<Color> gradientColors = const [
        Color(0xFF5DFDCB),
        Color(0xFF00E5FF),
      ];
      Border? buttonBorder;
      List<BoxShadow>? buttonShadow = [
        BoxShadow(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];
      Widget? leadingIcon;
      VoidCallback? onTapAction;

      if (isCompleted) {
        buttonText = "Webinar Completed";
        gradientColors = const [
          Color(0xFF2D3748),
          Color(0xFF1A202C),
        ];
        textColor = const Color(0xFF94A3B8);
        buttonShadow = null;
        onTapAction = () {
          Fluttertoast.showToast(
            msg: "This webinar has completed.",
            backgroundColor: const Color(0xFF1E2E40),
          );
        };
      } else if (isRegistered) {
        buttonText = "Join Now";
        final bool canJoin = _canJoinWebinar(detail);

        if (canJoin) {
          gradientColors = const [
            Color(0xFF5DFDCB),
            Color(0xFF00E5FF),
          ];
          textColor = const Color(0xFF071D22);
          leadingIcon = const Icon(
            Icons.play_circle_fill_rounded,
            size: 20,
            color: Color(0xFF071D22),
          );
          onTapAction = () => _handleJoinWebinar(detail);
        } else {
          // Disabled until webinar start time (joinBeforeMinutes)
          final int minutesBefore = _getJoinBeforeMinutes(detail);
          gradientColors = const [
            Color(0xFF233242),
            Color(0xFF16222E),
          ];
          textColor = const Color(0xFF64748B);
          buttonBorder = Border.all(color: const Color(0xFF2E4359), width: 1.2);
          buttonShadow = null;
          leadingIcon = const Icon(
            Icons.lock_clock_rounded,
            size: 19,
            color: Color(0xFF64748B),
          );
          onTapAction = () {
            Fluttertoast.showToast(
              msg: "Webinar hasn't started yet. You can join $minutesBefore minutes before start time.",
              backgroundColor: const Color(0xFF1E2E40),
            );
          };
        }
      } else if (isRegistrationClosed) {
        buttonText = "Registration Closed";
        gradientColors = const [
          Color(0xFF2D3748),
          Color(0xFF1A202C),
        ];
        textColor = const Color(0xFF94A3B8);
        buttonShadow = null;
        onTapAction = () {
          Fluttertoast.showToast(
            msg: "Registration for this webinar has ended.",
            backgroundColor: const Color(0xFF1E2E40),
          );
        };
      } else if (isPaid) {
        buttonText = "Register Now • ₹${detail.amount ?? 0}";
        onTapAction = () => _handleRegisterAction(detail);
      } else {
        buttonText = "Register Now";
        onTapAction = () => _handleRegisterAction(detail);
      }

      return InkWell(
        onTap: onTapAction,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: buttonBorder,
            boxShadow: buttonShadow,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon,
                  const SizedBox(width: 8),
                ],
                Text(
                  buttonText,
                  style: AppStyles.customTextStyle(
                    size: 15.5,
                    weight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _handleRegisterAction(WebinarDetailData detail) {
    if (detail.registration?.isRegistered == true) {
      _handleJoinWebinar(detail);
      return;
    }

    final bool isRegistrationClosed = webinarController.isTimerExpired ||
        (detail.allowRegistration == false && !(detail.registration?.isRegistered ?? false));

    if (isRegistrationClosed) {
      Fluttertoast.showToast(
        msg: "Registration for this webinar has ended.",
        backgroundColor: const Color(0xFF1E2E40),
      );
      return;
    }

    final bool isPaid = (detail.webinarType ?? '').toLowerCase() == 'paid' ||
        (detail.amount != null && detail.amount! > 0);

    if (isPaid) {
      // Paid Webinar Confirmation dialog
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: const Color(0xFF111D28),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Color(0xFF1E2E42)),
            ),
            title: Text(
              "Confirm Registration & Payment",
              style: AppStyles.customTextStyle(
                size: 17,
                weight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.title ?? "Webinar",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Amount payable: ₹${detail.amount ?? 0}. Would you like to proceed with registration?",
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: const Color(0xFF94A3B8),
                    lineSpace: 1.35,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  "Cancel",
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: const Color(0xFF94A3B8),
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: const Color(0xFF071D22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Fluttertoast.showToast(
                    msg: "Proceeding to payment...",
                    backgroundColor: const Color(0xFF10B981),
                  );
                },
                child: Text(
                  "Pay ₹${detail.amount ?? 0}",
                  style: AppStyles.customTextStyle(
                    size: 13,
                    weight: FontWeight.w700,
                    color: const Color(0xFF071D22),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // FREE WEBINAR REGISTRATION FLOW (matching Image 4)
      _showFreeWebinarRegistrationModal(detail);
    }
  }

  // -------------------------------------------------------------
  // FREE WEBINAR REGISTRATION MODAL (IMAGE 4)
  // -------------------------------------------------------------
  void _showFreeWebinarRegistrationModal(WebinarDetailData detail) {
    final fullNameController = TextEditingController(text: studentName ?? "");
    final emailController = TextEditingController(text: studentEmail ?? "");
    final mobileController = TextEditingController(text: studentMobile ?? "");
    final questionController = TextEditingController();

    String? selectedCollege = studentCollege;
    String? selectedCourse;
    String? selectedYearOfStudy;
    String? selectedRole;

    const List<String> courseOptions = [
      "Course / Degree",
      "BE",
      "B.Tech",
      "B.Sc",
      "BCA",
      "B.Com",
      "BA",
      "ME",
      "M.Tech",
      "M.Sc",
      "MCA",
      "M.Com",
      "MA",
      "MBA",
      "BBA",
      "BBM",
      "PhD",
      "MBBS",
      "Nursing",
      "BDS",
      "Other",
    ];

    const List<String> roleOptions = [
      "Student",
      "Working professional",
      "Job seeker",
      "Freelancer",
    ];

    const List<String> yearOfStudyOptions = [
      "1st Year",
      "2nd Year",
      "3rd Year",
      "4th Year",
      "Graduated",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.92,
              decoration: BoxDecoration(
                color: const Color(0xFF0A1521),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(
                  color: const Color(0xFF1E2E42),
                  width: 1.2,
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // TOP BAR: Title & Close Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          const SizedBox(width: 36),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Register for Webinar",
                                style: AppStyles.customTextStyle(
                                  size: 18,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFFFFD44D),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(sheetCtx).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: const BoxDecoration(
                                color: Color(0xFF172637),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // FORM CONTENT SCROLLABLE
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(18, 10, 18, bottomInset + 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. HERO WEBINAR BANNER (Left: Pill + Title + Date/Time, Right: 3D Calendar)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // FREE WEBINAR PILL
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF063A34),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: const Color(0xFF10B981)
                                                .withValues(alpha: 0.6),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.play_arrow_rounded,
                                              size: 13,
                                              color: Color(0xFF10B981),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "FREE WEBINAR",
                                              style: AppStyles.customTextStyle(
                                                size: 10.5,
                                                weight: FontWeight.w800,
                                                color: const Color(0xFF10B981),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      // TITLE
                                      Text(
                                        detail.title ?? "Webinar Session",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.customTextStyle(
                                          size: 16.5,
                                          weight: FontWeight.w800,
                                          color: Colors.white,
                                          lineSpace: 1.25,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // DATE & TIME ROW
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 12.5,
                                            color: Color(0xFF94A3B8),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _formatWebinarDate(detail.webinarDate),
                                            style: AppStyles.customTextStyle(
                                              size: 11.5,
                                              weight: FontWeight.w500,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            "|",
                                            style: TextStyle(
                                              color: Color(0xFF475569),
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Icon(
                                            Icons.access_time_rounded,
                                            size: 12.5,
                                            color: Color(0xFF94A3B8),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              _formatWebinarTime(detail),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppStyles.customTextStyle(
                                                size: 11.5,
                                                weight: FontWeight.w500,
                                                color: const Color(0xFF94A3B8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // 3D CALENDAR ILLUSTRATION
                                _buildCalendar3dIllustration(),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // 2. PERSONAL INFORMATION
                            _buildSectionHeader(
                              icon: Icons.person_outline_rounded,
                              title: "Personal Information",
                            ),

                            const SizedBox(height: 12),

                            // Side-by-side Full Name & Email Address
                            Row(
                              children: [
                                Expanded(
                                  child: _buildFormField(
                                    controller: fullNameController,
                                    hintText: "Full Name *",
                                    icon: Icons.person_outline_rounded,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildFormField(
                                    controller: emailController,
                                    hintText: "Email Address *",
                                    icon: Icons.mail_outline_rounded,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Mobile Number Full Width
                            _buildFormField(
                              controller: mobileController,
                              hintText: "Mobile Number *",
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),

                            const SizedBox(height: 20),

                            // 3. ACADEMIC / PROFESSIONAL INFORMATION
                            _buildSectionHeader(
                              icon: Icons.school_outlined,
                              title: "Academic / Professional Information",
                            ),

                            const SizedBox(height: 12),

                            // Row 1: College/University & Course/Degree
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdownSelector(
                                    icon: Icons.apartment_outlined,
                                    text: selectedCollege != null &&
                                            selectedCollege!.isNotEmpty
                                        ? selectedCollege!
                                        : "College / University *",
                                    isSelected: selectedCollege != null &&
                                        selectedCollege!.isNotEmpty,
                                    onTap: () {
                                      _showCollegeSelectorSheet(
                                        context: context,
                                        selectedCollege: selectedCollege,
                                        onSelected: (col) {
                                          setModalState(() {
                                            selectedCollege = col;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildDropdownSelector(
                                    icon: Icons.menu_book_outlined,
                                    text: selectedCourse != null &&
                                            selectedCourse!.isNotEmpty
                                        ? selectedCourse!
                                        : "Course / Degree",
                                    isSelected: selectedCourse != null &&
                                        selectedCourse!.isNotEmpty,
                                    onTap: () {
                                      _showSimplePickerSheet(
                                        context: context,
                                        title: "Select Course / Degree",
                                        options: courseOptions,
                                        selectedValue: selectedCourse,
                                        onSelected: (course) {
                                          setModalState(() {
                                            selectedCourse = course;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Row 2: Year of Study & Role
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdownSelector(
                                    icon: Icons.calendar_today_outlined,
                                    text: selectedYearOfStudy != null &&
                                            selectedYearOfStudy!.isNotEmpty
                                        ? selectedYearOfStudy!
                                        : "Year of Study *",
                                    isSelected: selectedYearOfStudy != null &&
                                        selectedYearOfStudy!.isNotEmpty,
                                    onTap: () {
                                      _showSimplePickerSheet(
                                        context: context,
                                        title: "Select Year of Study",
                                        options: yearOfStudyOptions,
                                        selectedValue: selectedYearOfStudy,
                                        onSelected: (year) {
                                          setModalState(() {
                                            selectedYearOfStudy = year;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildDropdownSelector(
                                    icon: Icons.work_outline_rounded,
                                    text: selectedRole != null &&
                                            selectedRole!.isNotEmpty
                                        ? selectedRole!
                                        : "Role *",
                                    isSelected: selectedRole != null &&
                                        selectedRole!.isNotEmpty,
                                    onTap: () {
                                      _showSimplePickerSheet(
                                        context: context,
                                        title: "Select Role",
                                        options: roleOptions,
                                        selectedValue: selectedRole,
                                        onSelected: (role) {
                                          setModalState(() {
                                            selectedRole = role;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // 4. ADDITIONAL INFORMATION (OPTIONAL)
                            _buildSectionHeader(
                              icon: Icons.chat_bubble_outline_rounded,
                              title: "Additional Information (Optional)",
                            ),

                            const SizedBox(height: 12),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F1E2E),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF1E3046),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: questionController,
                                maxLines: 3,
                                style: AppStyles.customTextStyle(
                                  size: 13.5,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Any question for the speaker?",
                                  hintStyle: AppStyles.customTextStyle(
                                    size: 13,
                                    color: const Color(0xFF64748B),
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(bottom: 36),
                                    child: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: Color(0xFF64748B),
                                      size: 18,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // REGISTER NOW SUBMIT BUTTON
                            Obx(() {
                              final isLoading = webinarController.registerLoading;
                              return InkWell(
                                onTap: isLoading
                                    ? null
                                    : () async {
                                        final name = fullNameController.text.trim();
                                        final email = emailController.text.trim();
                                        final mobile = mobileController.text
                                            .trim()
                                            .replaceAll(RegExp(r'\D'), '');

                                        if (name.isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: "Please enter your full name",
                                          );
                                          return;
                                        }
                                        if (email.isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: "Please enter your email address",
                                          );
                                          return;
                                        }
                                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                            .hasMatch(email)) {
                                          Fluttertoast.showToast(
                                            msg: "Please enter a valid email address",
                                          );
                                          return;
                                        }
                                        if (mobile.isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: "Please enter your mobile number",
                                          );
                                          return;
                                        }
                                        if (mobile.length != 10) {
                                          Fluttertoast.showToast(
                                            msg: "Please enter a valid 10-digit mobile number",
                                          );
                                          return;
                                        }
                                        if (selectedCollege == null ||
                                            selectedCollege!.trim().isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: "Please select your College / University",
                                          );
                                          return;
                                        }
                                        if (selectedYearOfStudy == null ||
                                            selectedYearOfStudy!.trim().isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: "Please select your Year of Study",
                                          );
                                          return;
                                        }
                                        if (selectedRole == null ||
                                            selectedRole!.trim().isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: "Please select your Role",
                                          );
                                          return;
                                        }

                                        String effectiveCourse = selectedCourse ?? "";
                                        if (effectiveCourse == "Course / Degree") {
                                          effectiveCourse = "";
                                        }

                                        final effectiveStudentId = studentId != null &&
                                                studentId!.isNotEmpty
                                            ? studentId!
                                            : "6ac4acb47d36299ced3414e0";

                                        final payload = {
                                          "webinarId":
                                              detail.sId ?? effectiveWebinarId,
                                          "studentId": effectiveStudentId,
                                          "fullName": name,
                                          "email": email,
                                          "mobile": mobile,
                                          "college": selectedCollege!,
                                          "course": effectiveCourse,
                                          "yearOfStudy": selectedYearOfStudy!,
                                          "role": selectedRole!,
                                          "question": questionController.text.trim(),
                                        };

                                        _lastRegisteredMobile = mobile;

                                        final res = await webinarController
                                            .registerWebinar(payload);

                                        if (res['success'] == true) {
                                          if (!sheetCtx.mounted) return;
                                          Navigator.of(sheetCtx).pop();

                                          // Refresh latest detail from server (including join & registration object)
                                          webinarController.fetchWebinarDetail(
                                            detail.sId ?? effectiveWebinarId,
                                          );

                                          Fluttertoast.showToast(
                                            msg: res['message'] ??
                                                "Successfully registered for the webinar",
                                            backgroundColor:
                                                const Color(0xFF10B981),
                                          );

                                          // Open Image 2 Confirmation Modal!
                                          _showRegistrationSuccessDialog(
                                            detail,
                                            name,
                                            email,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: res['message'] ??
                                                "Registration failed. Please try again.",
                                            backgroundColor:
                                                const Color(0xFFE11D48),
                                          );
                                        }
                                      },
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  width: double.infinity,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF5DFDCB),
                                        Color(0xFF00E5FF),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00E5FF)
                                            .withValues(alpha: 0.35),
                                        blurRadius: 14,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Color(0xFF071D22),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            "Register Now",
                                            style: AppStyles.customTextStyle(
                                              size: 15.5,
                                              weight: FontWeight.w800,
                                              color: const Color(0xFF071D22),
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 14),

                            // FOOTER: Your information is secure with us.
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 13,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Your information is secure with us.",
                                  style: AppStyles.customTextStyle(
                                    size: 11.5,
                                    weight: FontWeight.w500,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // -------------------------------------------------------------
  // REGISTRATION SUCCESS DIALOG (IMAGE 2: "You're Registered! 🎉")
  // -------------------------------------------------------------
  void _showRegistrationSuccessDialog(
    WebinarDetailData detail,
    String name,
    String email,
  ) {
    final bool canJoinNow = _canJoinWebinar(detail);
    final int joinMinutes = _getJoinBeforeMinutes(detail);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1824),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF1E2E42),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Navigator.of(dialogCtx).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF172637),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),

                // Glowing User Avatar Badge with Checkmark
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF00E5FF).withValues(alpha: 0.2),
                              const Color(0xFF10B981).withValues(alpha: 0.2),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_rounded,
                            size: 44,
                            color: Color(0xFF5DFDCB),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 8,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF10B981),
                            border: Border.all(
                              color: const Color(0xFF0D1824),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // "You're Registered! 🎉"
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppStyles.customTextStyle(
                      size: 21,
                      weight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    children: const [
                      TextSpan(text: "You're "),
                      TextSpan(
                        text: "Registered! 🎉",
                        style: TextStyle(color: Color(0xFFFFD44D)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Please confirm your registered details to\njoin the webinar.",
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: const Color(0xFF94A3B8),
                    lineSpace: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                // Name Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111F2D),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF1B2C3E),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF072B33),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: Color(0xFF00E5FF),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: AppStyles.customTextStyle(
                                size: 11,
                                color: const Color(0xFF64748B),
                                weight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              name,
                              style: AppStyles.customTextStyle(
                                size: 14,
                                color: Colors.white,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Email Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111F2D),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF1B2C3E),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF072B33),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.mail_outline_rounded,
                          color: Color(0xFF00E5FF),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: AppStyles.customTextStyle(
                                size: 11,
                                color: const Color(0xFF64748B),
                                weight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              email,
                              style: AppStyles.customTextStyle(
                                size: 13.5,
                                color: Colors.white,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Details confirmed pill
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF082E25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF10B981),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Details confirmed",
                        style: AppStyles.customTextStyle(
                          size: 12.5,
                          weight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Join Webinar Button
                InkWell(
                  onTap: () {
                    Navigator.of(dialogCtx).pop();
                    _handleJoinWebinar(detail);
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: canJoinNow
                            ? const [Color(0xFF5DFDCB), Color(0xFF00E5FF)]
                            : const [Color(0xFF233242), Color(0xFF16222E)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      border: canJoinNow
                          ? null
                          : Border.all(color: const Color(0xFF2E4359), width: 1.2),
                      boxShadow: canJoinNow
                          ? [
                              BoxShadow(
                                color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            canJoinNow
                                ? Icons.play_circle_fill_rounded
                                : Icons.lock_clock_rounded,
                            size: 18,
                            color: canJoinNow
                                ? const Color(0xFF071D22)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            canJoinNow
                                ? "Join Webinar Now"
                                : "Join Webinar (Active ${joinMinutes}m Before)",
                            style: AppStyles.customTextStyle(
                              size: 14.5,
                              weight: FontWeight.w800,
                              color: canJoinNow
                                  ? const Color(0xFF071D22)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Lock note
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      canJoinNow
                          ? Icons.check_circle_rounded
                          : Icons.lock_outline_rounded,
                      size: 12,
                      color: canJoinNow
                          ? const Color(0xFF10B981)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      canJoinNow
                          ? "Your meeting link is active and ready."
                          : "Join button will be enabled $joinMinutes minutes before start time.",
                      style: AppStyles.customTextStyle(
                        size: 10.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------
  // JOIN WEBINAR ACTION FLOW
  // -------------------------------------------------------------
  Future<void> _handleJoinWebinar(WebinarDetailData detail) async {
    final String wId = detail.sId ?? effectiveWebinarId;

    if (!_canJoinWebinar(detail)) {
      final int minutesBefore = _getJoinBeforeMinutes(detail);
      Fluttertoast.showToast(
        msg: "Webinar hasn't started yet. You can join $minutesBefore minutes before the start time.",
        backgroundColor: const Color(0xFF1E2E40),
      );
      return;
    }

    // Check mobile verification requirements based on API response
    final bool verificationRequired =
        detail.join?.mobileVerificationRequired ?? true;
    final bool isVerified = (detail.isMobileVerified == true) ||
        _verifiedWebinarIds.contains(wId);

    if (verificationRequired && !isVerified) {
      await _startMobileVerificationFlow(detail);
    } else {
      await _fetchAndShowMeetingLink(detail);
    }
  }

  // -------------------------------------------------------------
  // MOBILE OTP VERIFICATION FLOW
  // -------------------------------------------------------------
  Future<void> _startMobileVerificationFlow(WebinarDetailData detail) async {
    final String wId = detail.sId ?? effectiveWebinarId;
    String mobile = _lastRegisteredMobile ?? studentMobile ?? "";

    if (mobile.isEmpty) {
      mobile = await _promptMobileNumber(context) ?? "";
      if (mobile.isEmpty) return;
      _lastRegisteredMobile = mobile;
    }

    final sendRes = await webinarController.sendWebinarOtp(wId, mobile);

    if (sendRes['success'] == false &&
        sendRes['message'] != null &&
        sendRes['otp'] == null) {
      Fluttertoast.showToast(
        msg: sendRes['message'] ?? "Failed to send OTP",
        backgroundColor: const Color(0xFFE11D48),
      );
      return;
    }

    final String? receivedOtp = sendRes['otp']?.toString();

    Fluttertoast.showToast(
      msg: sendRes['message'] ?? "OTP sent successfully",
      backgroundColor: const Color(0xFF10B981),
    );

    if (!mounted) return;
    _showOtpVerificationDialog(detail, mobile, initialOtp: receivedOtp);
  }

  void _showOtpVerificationDialog(
    WebinarDetailData detail,
    String mobile, {
    String? initialOtp,
  }) {
    final otpController = TextEditingController(text: initialOtp ?? "");
    final String wId = detail.sId ?? effectiveWebinarId;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1824),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFF1E2E42), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top close
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Navigator.of(dialogCtx).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF172637),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),

                // Shield / OTP Icon
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00E5FF).withValues(alpha: 0.2),
                        const Color(0xFF10B981).withValues(alpha: 0.2),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.phonelink_lock_rounded,
                      color: Color(0xFF00E5FF),
                      size: 32,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  "Verify Mobile Number",
                  style: AppStyles.customTextStyle(
                    size: 19,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Enter the 4-digit code sent to +91 $mobile",
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                ),

                const SizedBox(height: 20),

                // OTP Text Field
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF071420),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1E3046), width: 1.2),
                  ),
                  child: Center(
                    child: TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF00E5FF),
                        letterSpacing: 12,
                      ),
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: "••••",
                        hintStyle: TextStyle(
                          color: Color(0xFF334155),
                          letterSpacing: 12,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Resend OTP button
                TextButton(
                  onPressed: () async {
                    final res = await webinarController.sendWebinarOtp(wId, mobile);
                    if (res['otp'] != null) {
                      otpController.text = res['otp'].toString();
                    }
                    Fluttertoast.showToast(
                      msg: res['message'] ?? "OTP resent successfully",
                      backgroundColor: const Color(0xFF10B981),
                    );
                  },
                  child: Text(
                    "Didn't receive code? Resend OTP",
                    style: AppStyles.customTextStyle(
                      size: 12.5,
                      weight: FontWeight.w600,
                      color: const Color(0xFF00E5FF),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Verify Button
                Obx(() {
                  final isVerifying = webinarController.otpVerifying;
                  return InkWell(
                    onTap: isVerifying
                        ? null
                        : () async {
                            final otp = otpController.text.trim();
                            if (otp.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please enter the OTP",
                              );
                              return;
                            }

                            final verifyRes = await webinarController
                                .verifyWebinarOtp(wId, otp);

                            if (verifyRes['success'] == true) {
                              if (!dialogCtx.mounted) return;
                              Navigator.of(dialogCtx).pop();
                              detail.isMobileVerified = true;
                              _verifiedWebinarIds.add(wId);
                              Fluttertoast.showToast(
                                msg: verifyRes['message'] ??
                                    "Mobile number verified successfully",
                                backgroundColor: const Color(0xFF10B981),
                              );

                              // PROCEED TO LIVE MEETING LINK (IMAGE 1)!
                              _fetchAndShowMeetingLink(detail);
                            } else {
                              Fluttertoast.showToast(
                                msg: verifyRes['message'] ??
                                    "Invalid OTP. Please try again.",
                                backgroundColor: const Color(0xFFE11D48),
                              );
                            }
                          },
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5DFDCB), Color(0xFF00E5FF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: isVerifying
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF071D22),
                                  ),
                                ),
                              )
                            : Text(
                                "Verify & Continue",
                                style: AppStyles.customTextStyle(
                                  size: 15,
                                  weight: FontWeight.w800,
                                  color: const Color(0xFF071D22),
                                ),
                              ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------
  // FETCH MEETING LINK & SHOW LIVE DIALOG (IMAGE 1)
  // -------------------------------------------------------------
  Future<void> _fetchAndShowMeetingLink(WebinarDetailData detail) async {
    final String wId = detail.sId ?? effectiveWebinarId;
    final res = await webinarController.getMeetingLink(wId);

    if (res['success'] == true && res['meetingLink'] != null) {
      final String link = res['meetingLink'];
      if (!mounted) return;
      _showLiveMeetingDialog(detail, link);
    } else {
      Fluttertoast.showToast(
        msg: res['message'] ?? "Webinar link will be active closer to start time.",
        backgroundColor: const Color(0xFF1E2E40),
      );
    }
  }

  void _showLiveMeetingDialog(WebinarDetailData detail, String meetingLink) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1B27),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF1E2E42),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.65),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top close button
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Navigator.of(dialogCtx).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF172637),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),

                // Glowing Confetti Celebration Badge
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow burst background
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF00E5FF).withValues(alpha: 0.35),
                              const Color(0xFF0891B2).withValues(alpha: 0.08),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFF00E5FF),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
                              blurRadius: 18,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.celebration_rounded,
                            size: 40,
                            color: Color(0xFF5DFDCB),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // "Webinar is Live Now! 🔴"
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppStyles.customTextStyle(
                      size: 21,
                      weight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    children: const [
                      TextSpan(text: "Webinar is "),
                      TextSpan(
                        text: "Live Now! ",
                        style: TextStyle(color: Color(0xFFFFD44D)),
                      ),
                      TextSpan(
                        text: "🔴",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Click the button below to join the live session\nusing Google Meet.",
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: const Color(0xFF94A3B8),
                    lineSpace: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                // Inner Meeting Link Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF091420),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF1B2C3E),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Google Meet Camera Icon & Label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFF122334),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.videocam_rounded,
                              color: Color(0xFF00E5FF),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Your Google Meet Link",
                            style: AppStyles.customTextStyle(
                              size: 13.5,
                              weight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Link URL box with Copy Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF050D16),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF1A2A3A),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                meetingLink,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.customTextStyle(
                                  size: 12.5,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: meetingLink),
                                );
                                Fluttertoast.showToast(
                                  msg: "Link copied to clipboard!",
                                  backgroundColor: const Color(0xFF10B981),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF142434),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.copy_rounded,
                                  size: 16,
                                  color: Color(0xFF00E5FF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Join Live Session Button
                      InkWell(
                        onTap: () async {
                          final uri = Uri.tryParse(meetingLink);
                          if (uri != null) {
                            try {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (_) {
                              await launchUrl(uri);
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "Invalid meeting link",
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5DFDCB), Color(0xFF00E5FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00E5FF)
                                    .withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.open_in_new_rounded,
                                  size: 18,
                                  color: Color(0xFF071D22),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Join Live Session",
                                  style: AppStyles.customTextStyle(
                                    size: 15.5,
                                    weight: FontWeight.w800,
                                    color: const Color(0xFF071D22),
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

                const SizedBox(height: 14),

                // Info card at bottom
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF091420),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1B2C3E),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0E2938),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_rounded,
                          color: Color(0xFF00E5FF),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Make sure you are signed in with your Google account to join the session.",
                          style: AppStyles.customTextStyle(
                            size: 11.5,
                            color: const Color(0xFF94A3B8),
                            lineSpace: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------
  // HELPER WIDGETS FOR REGISTRATION FORM (IMAGE 4)
  // -------------------------------------------------------------
  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF00E5FF)),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppStyles.customTextStyle(
            size: 13.5,
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3046), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppStyles.customTextStyle(
          size: 13.5,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyles.customTextStyle(
            size: 12.5,
            color: const Color(0xFF64748B),
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdownSelector({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1E2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E3046), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF64748B), size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.customTextStyle(
                  size: 12.5,
                  weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar3dIllustration() {
    return SizedBox(
      width: 78,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sparkle accents
          const Positioned(
            top: 2,
            right: 0,
            child: Icon(Icons.auto_awesome, color: Color(0xFF38BDF8), size: 13),
          ),
          const Positioned(
            left: 2,
            bottom: 12,
            child: Icon(Icons.auto_awesome, color: Color(0xFF38BDF8), size: 10),
          ),
          // Blue 3D calendar container
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF38BDF8),
                  Color(0xFF0284C7),
                  Color(0xFF0369A1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Top binder rings
                Positioned(
                  top: 4,
                  left: 12,
                  child: Container(
                    width: 5,
                    height: 7,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBAE6FD),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 12,
                  child: Container(
                    width: 5,
                    height: 7,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBAE6FD),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                // Calendar Grid lines
                Positioned(
                  top: 16,
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (_) => Container(
                            width: 7,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (_) => Container(
                            width: 7,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (_) => Container(
                            width: 7,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Green checkmark circular badge on bottom right
          Positioned(
            bottom: 2,
            right: 0,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF34D399), Color(0xFF059669)],
                ),
                border: Border.all(color: const Color(0xFF0A1521), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.check_rounded, color: Colors.white, size: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // COLLEGE SEARCHABLE SELECTOR BOTTOM SHEET
  // -------------------------------------------------------------
  Future<void> _showCollegeSelectorSheet({
    required BuildContext context,
    required String? selectedCollege,
    required ValueChanged<String> onSelected,
  }) async {
    final colleges = await webinarController.fetchColleges();
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        String searchQuery = "";
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final filtered = colleges
                .where((c) => c.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Color(0xFF0F1E2E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(color: Color(0xFF1E3046), width: 1.5),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select College / University",
                          style: AppStyles.customTextStyle(
                            size: 16,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(sheetCtx),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF091420),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF1E3046),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        onChanged: (val) {
                          setSheetState(() {
                            searchQuery = val;
                          });
                        },
                        style: AppStyles.customTextStyle(
                          size: 13.5,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search college or university...",
                          hintStyle: AppStyles.customTextStyle(
                            size: 13,
                            color: const Color(0xFF64748B),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              "No colleges found",
                              style: AppStyles.customTextStyle(
                                size: 13,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) => const Divider(
                              height: 1,
                              color: Color(0xFF162536),
                            ),
                            itemBuilder: (ctx, idx) {
                              final college = filtered[idx];
                              final isSelected = college == selectedCollege;
                              return ListTile(
                                onTap: () {
                                  onSelected(college);
                                  Navigator.pop(sheetCtx);
                                },
                                title: Text(
                                  college,
                                  style: AppStyles.customTextStyle(
                                    size: 13.5,
                                    weight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? const Color(0xFF00E5FF)
                                        : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFF00E5FF),
                                        size: 18,
                                      )
                                    : null,
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // -------------------------------------------------------------
  // SIMPLE OPTIONS PICKER BOTTOM SHEET
  // -------------------------------------------------------------
  Future<void> _showSimplePickerSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.55,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF0F1E2E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Color(0xFF1E3046), width: 1.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppStyles.customTextStyle(
                        size: 16,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(sheetCtx),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF94A3B8),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const Divider(
                    height: 1,
                    color: Color(0xFF162536),
                  ),
                  itemBuilder: (ctx, idx) {
                    final item = options[idx];
                    final isSelected = item == selectedValue;
                    return ListTile(
                      onTap: () {
                        onSelected(item);
                        Navigator.pop(sheetCtx);
                      },
                      title: Text(
                        item,
                        style: AppStyles.customTextStyle(
                          size: 14,
                          weight:
                              isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected
                              ? const Color(0xFF00E5FF)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF00E5FF),
                              size: 18,
                            )
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------
  // PROMPT MOBILE NUMBER DIALOG (FALLBACK)
  // -------------------------------------------------------------
  Future<String?> _promptMobileNumber(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0D1824),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF1E2E42)),
          ),
          title: Text(
            "Enter Mobile Number",
            style: AppStyles.customTextStyle(
              size: 17,
              weight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please provide your 10-digit mobile number to verify and get the webinar link.",
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "10-digit Mobile Number",
                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF00E5FF)),
                  filled: true,
                  fillColor: const Color(0xFF071420),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E3046)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text("Cancel", style: TextStyle(color: Color(0xFF94A3B8))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: const Color(0xFF071D22),
              ),
              onPressed: () {
                final text = controller.text.trim().replaceAll(RegExp(r'\D'), '');
                if (text.length == 10) {
                  Navigator.pop(ctx, text);
                } else {
                  Fluttertoast.showToast(msg: "Please enter valid 10 digits");
                }
              },
              child: const Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  String _formatWebinarDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "Upcoming";
    try {
      final parsed = DateTime.tryParse(rawDate);
      if (parsed != null) {
        return DateFormat("dd MMM yyyy").format(parsed);
      }
    } catch (_) {}
    return rawDate;
  }

  String _formatWebinarTime(WebinarDetailData detail) {
    final start = detail.startTime ?? '';
    final end = detail.endTime ?? '';
    final tz = detail.timezone ?? 'IST';
    if (start.isNotEmpty && end.isNotEmpty) {
      return "$start – $end $tz";
    } else if (start.isNotEmpty) {
      return "$start $tz";
    }
    return "11:00 AM – 12:30 PM IST";
  }

  // -------------------------------------------------------------
  // 4. THREE INFO CHIPS (Category, Type, Language)
  // -------------------------------------------------------------
  Widget _buildThreeInfoChips(WebinarDetailData detail) {
    final isPaid = (detail.webinarType ?? '').toLowerCase() == 'paid' ||
        (detail.amount != null && detail.amount! > 0);
    final categoryName = detail.category?.name ?? "Technology";
    final languageName = (detail.language ?? "English").capitalizeFirst ?? "English";

    return Row(
      children: [
        // Category Chip
        Expanded(
          child: _buildSmallInfoCard(
            icon: Icons.view_in_ar_rounded,
            iconColor: const Color(0xFF38BDF8),
            iconBg: const Color(0xFF0C2436),
            title: categoryName,
            subtitle: "Category",
          ),
        ),
        const SizedBox(width: 8),

        // Type Chip
        Expanded(
          child: _buildSmallInfoCard(
            icon: Icons.confirmation_number_outlined,
            iconColor: const Color(0xFFFBBF24),
            iconBg: const Color(0xFF33260A),
            title: "Webinar",
            subtitle: isPaid ? "Paid" : "Free",
            subtitleColor: isPaid
                ? const Color(0xFFFBBF24)
                : const Color(0xFF34D399),
          ),
        ),
        const SizedBox(width: 8),

        // Language Chip
        Expanded(
          child: _buildSmallInfoCard(
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF818CF8),
            iconBg: const Color(0xFF1C1D42),
            title: languageName,
            subtitle: "Language",
          ),
        ),
      ],
    );
  }

  Widget _buildSmallInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    Color? subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111D28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF1E2E42),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppStyles.customTextStyle(
                    size: 11.5,
                    weight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppStyles.customTextStyle(
                    size: 10,
                    weight: FontWeight.w500,
                    color: subtitleColor ?? const Color(0xFF94A3B8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 5. REGISTRATION START & END DATES ROW
  // -------------------------------------------------------------
  Widget _buildRegistrationDatesRow(WebinarDetailData detail) {
    return Row(
      children: [
        Expanded(
          child: _buildDateDetailCard(
            icon: Icons.calendar_today_outlined,
            title: _formatDate(detail.registrationStartDate),
            subtitle: "Registration Starts",
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDateDetailCard(
            icon: Icons.calendar_today_outlined,
            title: _formatDate(detail.registrationEndDate),
            subtitle: "Registration Ends",
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // 6. WEBINAR DATE & TIME ROW
  // -------------------------------------------------------------
  Widget _buildWebinarScheduleRow(WebinarDetailData detail) {
    final dayOfWeek = _getDayOfWeek(detail.webinarDate);
    final formattedTime = _formatTimeRange(detail.startTime, detail.endTime);

    return Row(
      children: [
        Expanded(
          child: _buildDateDetailCard(
            icon: Icons.calendar_today_outlined,
            title: _formatDate(detail.webinarDate),
            subtitle: "Webinar Date\n($dayOfWeek)",
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDateDetailCard(
            icon: Icons.access_time_rounded,
            title: formattedTime,
            subtitle: "Time (IST)\n(UTC+05:30)",
          ),
        ),
      ],
    );
  }

  Widget _buildDateDetailCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111D28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF1E2E42),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFFFBBF24),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppStyles.customTextStyle(
                    size: 12.5,
                    weight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppStyles.customTextStyle(
                    size: 10.5,
                    weight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                    lineSpace: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 7. ABOUT THIS WEBINAR SECTION
  // -------------------------------------------------------------
  Widget _buildAboutSection(WebinarDetailData detail) {
    final String description = (detail.fullDescription != null &&
            detail.fullDescription!.trim().isNotEmpty)
        ? detail.fullDescription!.trim()
        : (detail.shortDescription?.trim() ?? "No description available.");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.article_outlined,
              size: 18,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              "About This Webinar",
              style: AppStyles.customTextStyle(
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111D28),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1E2E42),
              width: 1,
            ),
          ),
          child: Text(
            description,
            style: AppStyles.customTextStyle(
              size: 13,
              color: const Color(0xFFCBD5E1),
              lineSpace: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // 8. SPEAKER SECTION
  // -------------------------------------------------------------
  Widget _buildSpeakerSection(SpeakerData speaker) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.person_outline_rounded,
              size: 18,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              "Speaker",
              style: AppStyles.customTextStyle(
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF111D28),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF1E2E42),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with cyan ring
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 2.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: speaker.profileImage != null &&
                            speaker.profileImage!.isNotEmpty
                        ? Image.network(
                            speaker.profileImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) =>
                                _buildSpeakerAvatarFallback(speaker.name),
                          )
                        : _buildSpeakerAvatarFallback(speaker.name),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Speaker Name
              Text(
                speaker.name?.isNotEmpty == true ? speaker.name! : "Speaker",
                style: AppStyles.customTextStyle(
                  size: 17,
                  weight: FontWeight.w700,
                  color: AppColors.whiteColor,
                ),
                textAlign: TextAlign.center,
              ),

              // Speaker Designation
              if (speaker.designation != null &&
                  speaker.designation!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  speaker.designation!,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    weight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              // Speaker Company
              if (speaker.company != null &&
                  speaker.company!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  speaker.company!,
                  style: AppStyles.customTextStyle(
                    size: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              // Speaker Bio
              if (speaker.bio != null && speaker.bio!.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    speaker.bio!.trim(),
                    style: AppStyles.customTextStyle(
                      size: 12.5,
                      color: const Color(0xFF94A3B8),
                      lineSpace: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              // View LinkedIn / Profile Button
              if (speaker.profileUrl != null &&
                  speaker.profileUrl!.trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _openUrl(speaker.profileUrl!),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A66C2), // LinkedIn blue
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.link_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "View LinkedIn",
                          style: AppStyles.customTextStyle(
                            size: 13,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpeakerAvatarFallback(String? name) {
    final initial = (name != null && name.trim().isNotEmpty)
        ? name.trim()[0].toUpperCase()
        : 'S';

    return Container(
      color: const Color(0xFF162534),
      child: Center(
        child: Text(
          initial,
          style: AppStyles.customTextStyle(
            size: 28,
            weight: FontWeight.w800,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Fluttertoast.showToast(msg: "Could not launch: $url");
      }
    } catch (_) {
      Fluttertoast.showToast(msg: "Invalid profile URL");
    }
  }

  // -------------------------------------------------------------
  // 9. RELATED WEBINARS SECTION
  // -------------------------------------------------------------
  Widget _buildRelatedWebinarsSection(List<SimilarWebinarData> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.grid_view_rounded,
                  size: 18,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  "Related Webinars",
                  style: AppStyles.customTextStyle(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                // Navigate back to webinars list or scroll
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      "View All",
                      style: AppStyles.customTextStyle(
                        size: 12.5,
                        weight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...list.take(6).map((similar) => _buildSimilarWebinarItem(similar)),
      ],
    );
  }

  Widget _buildSimilarWebinarItem(SimilarWebinarData item) {
    final bool isPaid = (item.webinarType ?? '').toLowerCase() == 'paid' ||
        (item.amount != null && item.amount! > 0);
    final dateStr = _formatDate(item.webinarDate);
    final timeStr = _formatSingleTime(item.startTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111D28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF1E2E42),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final targetId = item.sId ?? item.id;
            if (targetId != null && targetId.isNotEmpty) {
              Get.toNamed(
                AppRoutes.webinarDetailScreen,
                arguments: targetId,
                preventDuplicates: false,
              );
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 62,
                    height: 62,
                    color: const Color(0xFF15222E),
                    child: item.bannerImage != null &&
                            item.bannerImage!.isNotEmpty
                        ? Image.network(
                            item.bannerImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) =>
                                const Icon(
                              Icons.play_circle_fill_rounded,
                              color: AppColors.primaryColor,
                              size: 26,
                            ),
                          )
                        : const Icon(
                            Icons.play_circle_fill_rounded,
                            color: AppColors.primaryColor,
                            size: 26,
                          ),
                  ),
                ),

                const SizedBox(width: 12),

                // Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: isPaid
                              ? const Color(0xFF3B1569)
                              : const Color(0xFF0F3A2E),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          isPaid ? "Paid" : "Free",
                          style: AppStyles.customTextStyle(
                            size: 10,
                            weight: FontWeight.w700,
                            color: isPaid
                                ? const Color(0xFFC084FC)
                                : const Color(0xFF34D399),
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Title
                      Text(
                        item.title ?? "Webinar",
                        style: AppStyles.customTextStyle(
                          size: 13,
                          weight: FontWeight.w700,
                          color: AppColors.whiteColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 5),

                      // Sub-row: Date, Time, Price
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateStr,
                            style: AppStyles.customTextStyle(
                              size: 11,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeStr,
                            style: AppStyles.customTextStyle(
                              size: 11,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isPaid ? "₹${item.amount ?? 0}" : "Free",
                            style: AppStyles.customTextStyle(
                              size: 11,
                              weight: FontWeight.w600,
                              color: isPaid
                                  ? AppColors.secondaryColor
                                  : const Color(0xFF34D399),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                // Trailing Chevron
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF64748B),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // LOADING & ERROR STATES
  // -------------------------------------------------------------
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoActivityIndicator(
            radius: 16,
            color: AppColors.primaryColor,
          ),
          SizedBox(height: 14),
          Text(
            "Loading webinar details...",
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 12),
            Text(
              "Unable to load webinar",
              style: AppStyles.customTextStyle(
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              webinarController.detailErrorMessage.isNotEmpty
                  ? webinarController.detailErrorMessage
                  : "Please check your network connection and try again.",
              style: AppStyles.customTextStyle(
                size: 12.5,
                color: const Color(0xFF94A3B8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: const Color(0xFF071D22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _loadWebinarData,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // FORMATTING UTILITIES
  // -------------------------------------------------------------
  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "TBA";
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      return DateFormat("dd MMM yyyy").format(dt);
    } catch (_) {
      return rawDate;
    }
  }

  String _getDayOfWeek(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "Day TBA";
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      return DateFormat("EEEE").format(dt);
    } catch (_) {
      return "Day TBA";
    }
  }

  String _formatSingleTime(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return "";
    try {
      final clean = timeStr.trim();
      final parts = clean.split(":");
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        final period = hour >= 12 ? "PM" : "AM";
        int displayHour = hour % 12;
        if (displayHour == 0) displayHour = 12;
        final minuteStr = minute.toString().padLeft(2, '0');
        return "$displayHour:$minuteStr $period";
      }
    } catch (_) {}
    return timeStr;
  }

  String _formatTimeRange(String? start, String? end) {
    final s = _formatSingleTime(start);
    final e = _formatSingleTime(end);

    if (s.isNotEmpty && e.isNotEmpty) {
      return "$s – $e";
    } else if (s.isNotEmpty) {
      return s;
    }
    return "Time TBA";
  }
}
