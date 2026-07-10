import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/home/credit_plan_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_credits_plan_model.dart';

class _CreditCardTheme {
  final Color accent;
  final Color accentSoft;
  final String emoji;
  final String? badgeText;
  final Color? badgeColor;
  final Color? badgeTextColor;

  const _CreditCardTheme({
    required this.accent,
    required this.accentSoft,
    required this.emoji,
    this.badgeText,
    this.badgeColor,
    this.badgeTextColor,
  });
}

const List<_CreditCardTheme> _kThemes = [
  // 0 - Starter
  _CreditCardTheme(
    accent: Color(0xFF2FE0C7),
    accentSoft: Color(0xFF14332F),
    emoji: "🚀",
  ),
  // 1 - Popular
  _CreditCardTheme(
    accent: Color(0xFFFFC93C),
    accentSoft: Color(0xFF3A2E12),
    emoji: "⚡",
    badgeText: "Popular ⭐",
    badgeColor: Color(0xFFFFC93C),
    badgeTextColor: Color(0xFF1A1A1A),
  ),
  // 2 - Best Value
  _CreditCardTheme(
    accent: Color(0xFFA477FF),
    accentSoft: Color(0xFF2A1F3D),
    emoji: "💎",
    badgeText: "Best Value 🔥",
    badgeColor: Color(0xFFA477FF),
    badgeTextColor: Color(0xFFFFFFFF),
  ),
  // 3 - Pro
  _CreditCardTheme(
    accent: Color(0xFF4DA3FF),
    accentSoft: Color(0xFF122333),
    emoji: "👑",
  ),
];

class CreditPlanCardWidget extends StatelessWidget {
  final RecruiterPlanData plan;
  final VoidCallback onPressedFunc;
  final bool isLoading;
  final bool isDisabled;

  /// Position of this card in the grid — drives which theme (color/emoji/
  /// badge) is applied. Defaults to 0 (Starter theme) if not supplied.
  final int index;

  const CreditPlanCardWidget({
    super.key,
    required this.plan,
    required this.onPressedFunc,
    this.isLoading = false,
    this.isDisabled = false,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _kThemes[index % _kThemes.length];

    return Opacity(
      opacity: isDisabled ? 0.45 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D1614),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.accent.withValues(alpha: theme.badgeText != null ? 0.9 : 0.45),
            width: 1.4,
          ),
          boxShadow: theme.badgeText != null
              ? [
            BoxShadow(
              color: theme.accent.withValues(alpha: 0.25),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 22, 14, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Icon avatar ─────────────────────────────
                  Container(
                    height: 44,
                    width: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.accentSoft,
                      border: Border.all(color: theme.accent, width: 1.2),
                    ),
                    child: Text(theme.emoji, style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 10),

                  // ── Plan name ────────────────────────────────
                  Text(
                    plan.label ?? "",
                    style: AppStyles.customTextStyle(
                      size: 15,
                      weight: FontWeight.w700,
                      color: theme.accent,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Credits ──────────────────────────────────
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${plan.credits ?? 0}",
                          style: AppStyles.customTextStyle(
                            size: 26,
                            weight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: " Credits",
                          style: AppStyles.customTextStyle(
                            size: 13,
                            weight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _DashedDivider(color: theme.accent.withValues(alpha: 0.35)),
                  const SizedBox(height: 10),

                  // ── Price ────────────────────────────────────
                  Text(
                    "₹${plan.amount ?? 0}",
                    style: AppStyles.customTextStyle(
                      size: 22,
                      weight: FontWeight.w800,
                      color: theme.accent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "+18% GST Extra",
                    style: AppStyles.customTextStyle(
                      size: 10,
                      weight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Buy Now button ───────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (isDisabled || isLoading) ? null : onPressedFunc,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.accent,
                        disabledBackgroundColor: theme.accent.withValues(alpha: 0.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                          : Text(
                        "Buy Now",
                        style: AppStyles.customTextStyle(
                          size: 13,
                          weight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Badge (Popular / Best Value) ───────────────────
            if (theme.badgeText != null)
              Positioned(
                top: -12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: theme.badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      theme.badgeText!,
                      style: AppStyles.customTextStyle(
                        size: 10,
                        weight: FontWeight.w700,
                        color: theme.badgeTextColor ?? Colors.black,
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
}

/// Simple dashed horizontal divider without extra dependencies.
class _DashedDivider extends StatelessWidget {
  final Color color;
  final double dashWidth;
  final double dashGap;

  const _DashedDivider({
    required this.color,
    this.dashWidth = 4,
    this.dashGap = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / (dashWidth + dashGap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
                (_) => Container(
              width: dashWidth,
              height: 1,
              color: color,
            ),
          ),
        );
      },
    );
  }
}