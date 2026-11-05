import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_profile_model.dart';

class RecruiterProfileReviewsTab extends StatelessWidget {
  final List<RecruiterReviewItem> reviews;
  final String Function(dynamic date) formatDate;

  const RecruiterProfileReviewsTab({
    super.key,
    required this.reviews,
    required this.formatDate,
  });

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.recContainerColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.recBorderColor),
    );
  }

  Widget _divider() => Divider(
        color: AppColors.recBorderColor,
        height: 1,
        thickness: 0.8,
      );

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: _cardDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.rate_review_outlined,
                color: AppColors.primaryColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "No Reviews Yet",
              style: AppStyles.customTextStyle(
                size: 16,
                color: AppColors.whiteColor,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Feedback and reviews submitted by candidates will appear here.",
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
      );
    }

    double totalRating = 0.0;
    int ratedCount = 0;
    for (var r in reviews) {
      final num? ratingNum = r.rating is num
          ? (r.rating as num)
          : num.tryParse(r.rating?.toString() ?? "");
      if (ratingNum != null && ratingNum > 0) {
        totalRating += ratingNum;
        ratedCount++;
      }
    }
    final double avgRating = ratedCount > 0 ? (totalRating / ratedCount) : 0.0;

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary header card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: _cardDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 8,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFC107),
                    size: 26,
                  ),
                  Text(
                    avgRating > 0 ? avgRating.toStringAsFixed(1) : "0.0",
                    style: AppStyles.customTextStyle(
                      size: 18,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "out of 5.0",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.greyTextColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  "${reviews.length} ${reviews.length == 1 ? 'Review' : 'Reviews'}",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // List of reviews
        ...reviews.map((review) => _buildReviewCard(review)),
      ],
    );
  }

  Widget _buildReviewCard(RecruiterReviewItem review) {
    final avatar = (review.studentProfile ?? "").trim();
    final name = (review.studentName ?? "Candidate").trim();
    final email = (review.studentEmail ?? "").trim();
    final comment = (review.review ?? "").trim();
    final date = formatDate(review.createdAt);

    final num? ratingNum = review.rating is num
        ? (review.rating as num)
        : num.tryParse(review.rating?.toString() ?? "");
    final int ratingInt = (ratingNum ?? 0).round().clamp(0, 5);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: ClipOval(
                  child: avatar.isNotEmpty
                      ? Image.network(
                          avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      name.isNotEmpty ? name : "Candidate",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                    if (email.isNotEmpty)
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 11.5,
                          color: AppColors.greyTextColor,
                          weight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < ratingInt
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: const Color(0xFFFFC107),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            _divider(),
            Text(
              comment,
              style: AppStyles.customTextStyle(
                size: 13,
                color: const Color(0xFFE2E8F0),
                weight: FontWeight.w400,
                lineSpace: 1.45,
              ),
            ),
          ],
          _divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (review.jobRole != null && review.jobRole!.trim().isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.cardColor2,
                    border: Border.all(color: AppColors.cardBorder2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      const Icon(
                        Icons.work_outline,
                        color: AppColors.primaryColor,
                        size: 12,
                      ),
                      Text(
                        review.jobRole!.trim(),
                        style: AppStyles.customTextStyle(
                          size: 11,
                          color: AppColors.primaryColor,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink(),
              Text(
                date,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

