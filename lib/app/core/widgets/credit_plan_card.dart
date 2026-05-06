import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/home/credit_plan_model.dart';

class CreditPlanCard extends StatelessWidget {
  final PlanData plan;
  final VoidCallback? onPressedFunc;
  final bool isLoading;

  /// When another plan is being processed, disable this card visually.
  final bool isDisabled;

  const CreditPlanCard({
    super.key,
    required this.plan,
    this.onPressedFunc,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPopular = plan.label == "Popular";
    final isBest = plan.label == "Best Value";

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        decoration: BoxDecoration(
          color: isPopular
              ? AppColors.purpleColor.withValues(alpha: 0.05)
              : isBest
              ? AppColors.orangeColor.withValues(alpha: 0.05)
              : AppColors.lightWhiteCont,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isPopular
                ? AppColors.purpleColor
                : isBest
                ? AppColors.orangeColor
                : AppColors.lightText,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Label badge ───────────────────────────────────────────────
            if (isPopular || isBest)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: isPopular
                      ? AppColors.purpleColor
                      : AppColors.orangeColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  isPopular ? "⭐ Popular" : "🔥 Best Value",
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 10,
                    weight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                ),
              )
            else
              const SizedBox(height: 10),

            // ── Credits info ──────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  plan.label ?? "",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    weight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${plan.credits}",
                  style: AppStyles.customTextStyle(
                    size: 18,
                    weight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Credits",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    weight: FontWeight.w500,
                    color: AppColors.lightBlackText2,
                  ),
                ),
              ],
            ),

            // ── Price + Buy button ────────────────────────────────────────
            Column(
              children: [
                Text(
                  "₹${plan.amount}",
                  style: AppStyles.customTextStyle(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // Disable button when loading or another plan is processing
                    onPressed: (isLoading || isDisabled) ? null : onPressedFunc,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular
                          ? Colors.deepPurple
                          : isBest
                          ? AppColors.orangeColor
                          : AppColors.whiteColor,
                      disabledBackgroundColor: isPopular
                          ? Colors.deepPurple.withValues(alpha: 0.6)
                          : isBest
                          ? AppColors.orangeColor.withValues(alpha: 0.6)
                          : AppColors.whiteColor.withValues(alpha: 0.6),
                      side: BorderSide(
                        color: isPopular || isBest
                            ? AppColors.transparentColor
                            : AppColors.greyColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? Center(
                      child: CupertinoActivityIndicator(
                        color: isPopular || isBest
                            ? AppColors.whiteColor
                            : AppColors.blackColor,
                      ),
                    )
                        : Text(
                      "Buy Now",
                      style: AppStyles.customTextStyle(
                        size: 12,
                        weight: FontWeight.w700,
                        color: isPopular || isBest
                            ? AppColors.whiteColor
                            : AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}