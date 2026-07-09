import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_alert_utils.dart';

class ReferralUtils {
  ReferralUtils._();

  static void copyCode({
    required String code,
    String message = "Referral code copied!",
  }) {
    Clipboard.setData(ClipboardData(text: code));
    AppAlertUtils.showToast(message: message);
  }

  static Future<void> share({
    required String shareText,
    String platform = "more",
  }) async {
    final encodedText = Uri.encodeComponent(shareText);

    String? url;

    switch (platform.toLowerCase()) {
      case "whatsapp":
        url = "https://wa.me/?text=$encodedText";
        break;

      case "telegram":
        url = "https://t.me/share/url?text=$encodedText";
        break;

      case "facebook":
        url =
        "https://www.facebook.com/sharer/sharer.php?u=https://play.google.com/store/apps/details?id=com.doubletap.internsharks.ai&quote=$encodedText";
        break;

      case "instagram":
        Clipboard.setData(ClipboardData(text: shareText));
        AppAlertUtils.showToast(
          message:
          "Instagram doesn't support direct text sharing. Text copied.",
        );
        return;

      default:
        Share.share(shareText);
        return;
    }

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppAlertUtils.showToast(message: "$platform is not installed");
    }
  }
}