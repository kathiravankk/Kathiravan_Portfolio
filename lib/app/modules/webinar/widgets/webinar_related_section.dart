import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';
import 'package:internsharks/app/modules/webinar/widgets/webinar_common_widgets.dart';
import 'package:internsharks/app/routes/app_pages.dart';

/// ---------------------------------------------------------------------------
/// RELATED WEBINARS SECTION
/// ---------------------------------------------------------------------------
class WebinarRelatedWebinarsSection extends StatelessWidget {
  final List<SimilarWebinarData> list;

  const WebinarRelatedWebinarsSection({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
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
        ...list.take(6).map((similar) => _buildSimilarWebinarItem(context, similar)),
      ],
    );
  }

  Widget _buildSimilarWebinarItem(
    BuildContext context,
    SimilarWebinarData item,
  ) {
    final bool isPaid = (item.webinarType ?? '').toLowerCase() == 'paid' ||
        (item.amount != null && item.amount! > 0);
    final dateStr = WebinarDateUtils.formatDate(item.webinarDate);
    final timeStr = WebinarDateUtils.formatSingleTime(item.startTime);

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
                            errorBuilder: (ctx, err, stack) => const Icon(
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
}
