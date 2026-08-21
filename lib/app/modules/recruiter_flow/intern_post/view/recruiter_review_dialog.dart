import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_review_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';

class RecruiterReviewDialog extends StatefulWidget {
  final String? internshipId;

  const RecruiterReviewDialog({super.key, this.internshipId});

  @override
  State<RecruiterReviewDialog> createState() => _RecruiterReviewDialogState();
}

class _RecruiterReviewDialogState extends State<RecruiterReviewDialog> {
  final InternshipPostController postController =
      Get.find<InternshipPostController>();

  @override
  void initState() {
    getReviewData();
    super.initState();
  }

  List<RecReviewData> reviewsList = [];

  Future<void> getReviewData() async {
    try {
      debugPrint("++++++++++++++++++ ${widget.internshipId}");
      await postController.getRecruiterReview(jobId: widget.internshipId!);
      if (postController.getResponseCode() == 200 ||
          postController.getResponseCode() == 201) {
        reviewsList = postController.recruiterReviewModel.reviewsList ?? [];
      } else {
        AppFunctions.apiErrorHandling(
          postController.getResponseCode(),
          "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        postController.getResponseCode(),
        "Something went wrong!, Try again later",
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparentColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),

        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.alertGradColor, AppColors.alertGradColor2],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.whiteColor.withOpacity(0.08)),
        ),
        child: Obx(() {
          if (postController.recruiterReviewLoading) {
            return AppAlertUtils.customLoader();
          }
          return Column(
            spacing: 15,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Reviews For Internship",
                    style: AppStyles.customTextStyle(
                      size: 18,
                      weight: FontWeight.w700,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
              if (reviewsList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CustomEmptyWidget(),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: reviewsList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final reviewData = reviewsList[index];
                      return _buildReviewSection(review: reviewData);
                    },
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildReviewSection({required RecReviewData review}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  spacing: 10,
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.secondaryColor,
                      size: 20,
                    ),
                    Expanded(
                      child: Text(
                        "Internship Review",
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 16,
                          color: Colors.white,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
                      color: AppColors.blackColor,
                    ),
                    Text(
                      "${review.rating} RATING",
                      style: AppStyles.customTextStyle(
                        size: 11,
                        color: AppColors.blackColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        review.student != null
                            ? review.student!.studName ?? "---"
                            : "Anonymous Student",
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < review.rating! ? Icons.star : Icons.star_border,
                          size: 15,
                          color: AppColors.secondaryColor,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  review.review ?? "---",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
