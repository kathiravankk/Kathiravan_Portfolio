import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';
import 'package:internsharks/app/modules/webinar/controller/webinar_controller.dart';
import 'package:internsharks/app/modules/webinar/widgets/webinar_common_widgets.dart';
export 'webinar_speaker_section.dart';
export 'webinar_related_section.dart';

/// ---------------------------------------------------------------------------
/// 1. WEBINAR HERO BANNER CARD
/// ---------------------------------------------------------------------------
class WebinarBannerCard extends StatelessWidget {
  final WebinarDetailData detail;
  final WebinarController webinarController;

  const WebinarBannerCard({
    super.key,
    required this.detail,
    required this.webinarController,
  });

  @override
  Widget build(BuildContext context) {
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
}

/// ---------------------------------------------------------------------------
/// 2. STYLIZED TITLE (Dual-tone emphasis)
/// ---------------------------------------------------------------------------
class WebinarStylizedTitle extends StatelessWidget {
  final String title;

  const WebinarStylizedTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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
}

/// ---------------------------------------------------------------------------
/// 3. THREE INFO CHIPS (Category, Type, Language)
/// ---------------------------------------------------------------------------
class WebinarThreeInfoChips extends StatelessWidget {
  final WebinarDetailData detail;

  const WebinarThreeInfoChips({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final isPaid = (detail.webinarType ?? '').toLowerCase() == 'paid' ||
        (detail.amount != null && detail.amount! > 0);
    final categoryName = detail.category?.name ?? "Technology";
    final languageName =
        (detail.language ?? "English").capitalizeFirst ?? "English";

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
}

/// ---------------------------------------------------------------------------
/// 4. REGISTRATION DATES & WEBINAR SCHEDULE ROWS
/// ---------------------------------------------------------------------------
class WebinarRegistrationDatesRow extends StatelessWidget {
  final WebinarDetailData detail;

  const WebinarRegistrationDatesRow({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateDetailCard(
            icon: Icons.calendar_today_outlined,
            title: WebinarDateUtils.formatDate(detail.registrationStartDate),
            subtitle: "Registration Starts",
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDateDetailCard(
            icon: Icons.calendar_today_outlined,
            title: WebinarDateUtils.formatDate(detail.registrationEndDate),
            subtitle: "Registration Ends",
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
          Icon(icon, size: 16, color: const Color(0xFFFBBF24)),
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
}

class WebinarScheduleRow extends StatelessWidget {
  final WebinarDetailData detail;

  const WebinarScheduleRow({super.key, required this.detail});

  String _getDayOfWeek(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "Day TBA";
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      return DateFormat("EEEE").format(dt);
    } catch (_) {
      return "Day TBA";
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = _getDayOfWeek(detail.webinarDate);
    final formattedTime =
        WebinarDateUtils.formatTimeRange(detail.startTime, detail.endTime);

    return Row(
      children: [
        Expanded(
          child: _buildDateDetailCard(
            icon: Icons.calendar_today_outlined,
            title: WebinarDateUtils.formatDate(detail.webinarDate),
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
          Icon(icon, size: 16, color: const Color(0xFFFBBF24)),
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
}

/// ---------------------------------------------------------------------------
/// 5. ABOUT WEBINAR SECTION
/// ---------------------------------------------------------------------------
class WebinarAboutSection extends StatelessWidget {
  final WebinarDetailData detail;

  const WebinarAboutSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
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
}

/// ---------------------------------------------------------------------------
/// 8. LOADING & ERROR STATES
/// ---------------------------------------------------------------------------
class WebinarLoadingState extends StatelessWidget {
  const WebinarLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
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
}

class WebinarErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const WebinarErrorState({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
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
              errorMessage.isNotEmpty
                  ? errorMessage
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
              onPressed: onRetry,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
