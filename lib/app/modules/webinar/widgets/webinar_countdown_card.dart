import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';
import 'package:internsharks/app/modules/webinar/controller/webinar_controller.dart';
import 'package:internsharks/app/modules/webinar/widgets/webinar_common_widgets.dart';

class WebinarRegistrationCountdownCard extends StatelessWidget {
  final WebinarDetailData detail;
  final WebinarController webinarController;
  final bool canJoinWebinar;
  final int joinBeforeMinutes;
  final VoidCallback onRegisterTap;
  final VoidCallback onJoinTap;

  const WebinarRegistrationCountdownCard({
    super.key,
    required this.detail,
    required this.webinarController,
    required this.canJoinWebinar,
    required this.joinBeforeMinutes,
    required this.onRegisterTap,
    required this.onJoinTap,
  });

  @override
  Widget build(BuildContext context) {
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
            final regEndDate =
                WebinarDateUtils.formatDate(detail.registrationEndDate);
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

          // REGISTER NOW / JOIN BUTTON
          WebinarActionButton(
            detail: detail,
            webinarController: webinarController,
            canJoin: canJoinWebinar,
            joinBeforeMinutes: joinBeforeMinutes,
            onRegisterTap: onRegisterTap,
            onJoinTap: onJoinTap,
          ),

          const SizedBox(height: 12),

          // JOIN BEFORE INFO
          Obx(() {
            webinarController.seconds;
            final bool isRegistered = detail.registration?.isRegistered ?? false;
            final bool isCompleted =
                (detail.status ?? '').toLowerCase() == 'completed';

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
              if (canJoinWebinar) {
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
                      "Join button will enable $joinBeforeMinutes mins before start time",
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
                  "Join before $joinBeforeMinutes minutes of start time",
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
}

/// ---------------------------------------------------------------------------
/// WEBINAR ACTION BUTTON (USED ON COUNTDOWN CARD & DETAIL SCREEN BOTTOM)
/// ---------------------------------------------------------------------------
class WebinarActionButton extends StatelessWidget {
  final WebinarDetailData detail;
  final WebinarController webinarController;
  final bool canJoin;
  final int joinBeforeMinutes;
  final VoidCallback onRegisterTap;
  final VoidCallback onJoinTap;

  const WebinarActionButton({
    super.key,
    required this.detail,
    required this.webinarController,
    required this.canJoin,
    required this.joinBeforeMinutes,
    required this.onRegisterTap,
    required this.onJoinTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      webinarController.seconds;

      final bool isRegistered = detail.registration?.isRegistered ?? false;
      final bool isCompleted =
          (detail.status ?? '').toLowerCase() == 'completed';
      final bool isAlreadyPaid = detail.payment?.isPaid == true ||
          (detail.payment?.status ?? '').toLowerCase() == 'paid';
      final bool isTimerExpired = webinarController.isTimerExpired;
      final bool isRegistrationClosed = isTimerExpired ||
          (detail.allowRegistration == false && !isRegistered);
      final bool isPaid =
          (detail.webinarType ?? '').toLowerCase() == 'paid' ||
              (detail.amount != null && detail.amount! > 0);

      String buttonText;
      List<Color> gradientColors = [
        const Color(0xFF5DFDCB),
        const Color(0xFF00E5FF),
      ];
      Color textColor = const Color(0xFF071D22);
      BoxBorder? buttonBorder;
      List<BoxShadow>? buttonShadow = [
        BoxShadow(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];
      Widget? leadingIcon;
      VoidCallback onTapAction;

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
          onTapAction = onJoinTap;
        } else {
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
              msg:
                  "Webinar hasn't started yet. You can join $joinBeforeMinutes minutes before start time.",
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
      } else if (isPaid && !isAlreadyPaid) {
        buttonText = "Register Now • ₹${detail.amount ?? 0}";
        onTapAction = onRegisterTap;
      } else {
        buttonText = "Register Now";
        onTapAction = onRegisterTap;
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
}
