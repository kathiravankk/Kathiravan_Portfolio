import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';
import 'package:internsharks/app/modules/webinar/controller/webinar_controller.dart';

export 'webinar_success_dialog.dart';


/// ---------------------------------------------------------------------------
/// 2. OTP VERIFICATION DIALOG
/// ---------------------------------------------------------------------------
void showWebinarOtpVerificationDialog({
  required BuildContext context,
  required WebinarDetailData detail,
  required String mobile,
  required WebinarController webinarController,
  String? initialOtp,
  required VoidCallback onVerifiedSuccess,
}) {
  final otpController = TextEditingController(text: initialOtp ?? "");
  final String wId = detail.sId ?? '';

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
                            Fluttertoast.showToast(
                              msg: verifyRes['message'] ??
                                  "Mobile number verified successfully",
                              backgroundColor: const Color(0xFF10B981),
                            );
                            onVerifiedSuccess();
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

/// ---------------------------------------------------------------------------
/// 3. LIVE MEETING DIALOG
/// ---------------------------------------------------------------------------
void showWebinarLiveMeetingDialog({
  required BuildContext context,
  required WebinarDetailData detail,
  required String meetingLink,
}) {
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
