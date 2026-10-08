import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';

/// ---------------------------------------------------------------------------
/// REGISTRATION SUCCESS DIALOG ("You're Registered! 🎉")
/// ---------------------------------------------------------------------------
void showWebinarRegistrationSuccessDialog({
  required BuildContext context,
  required WebinarDetailData detail,
  required String name,
  required String email,
  required bool canJoinNow,
  required int joinMinutes,
  required VoidCallback onJoinTap,
}) {
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
                  onJoinTap();
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
