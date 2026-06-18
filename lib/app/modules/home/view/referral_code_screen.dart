import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferralCodeScreen extends StatefulWidget {
  const ReferralCodeScreen({super.key});

  @override
  State<ReferralCodeScreen> createState() => _ReferralCodeScreenState();
}

class _ReferralCodeScreenState extends State<ReferralCodeScreen> {
  String referralCode = "";
  int creditAmount = 20;

  @override
  void initState() {
    super.initState();
    referralCode = Get.arguments?["referralCode"] ?? "";
    creditAmount = Get.arguments?["creditAmount"] ?? 20;
  }

  String get _shareText =>
      '''
📚 Share Opportunities, 🎉 Get Credits!

Know a student or fresher searching for the right internship?

Invite your friends to Internsharks and help them discover exciting internship opportunities.

🚀 *How It Works*
✅ Share your referral link with friends
✅ Friend signs up using your referral code
✅ You earn $creditAmount Credits FREE

🔗 *Your Referral Link*
https://play.google.com/store/apps/details?id=com.doubletap.internsharks.ai

🎟️ *Your Referral Code*

*$referralCode*

💡 Ask your friends to enter this code during signup to complete your referral.

🎁 *Reward*
Earn *$creditAmount Credits FREE* for every successful referral.
''';

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: referralCode));
    AppAlertUtils.showToast(message: "Referral code copied!");
  }

  // void _shareVia(String platform) {
  //   // share_plus opens the native share sheet; platform-specific
  //   // deep links (whatsapp://, fb-messenger://, etc.) can be added
  //   // here if you want to target a single app directly.
  //   Share.share(_shareText);
  // }

  Future<void> _shareVia(String platform) async {
    final String encodedText = Uri.encodeComponent(_shareText);

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
        AppAlertUtils.showToast(
          message:
              "Instagram doesn't support direct text sharing. Please copy and paste the referral code.",
        );
        await Clipboard.setData(ClipboardData(text: _shareText));
        return;

      default:
        Share.share(_shareText);
        return;
    }

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppAlertUtils.showToast(message: "$platform is not installed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close, size: 30, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              _buildIllustration(),
              _buildReferralCodeCard(),
              const SizedBox(height: 15),
              _buildShareSection(),
              const SizedBox(height: 15),
              _buildHowItWorks(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      spacing: 12,
      children: [
        Text(
          "Refer Internsharks.ai & \nGet Free Credits!",
          textAlign: TextAlign.center,
          style: AppStyles.customTextStyle(
            size: 26,
            lineSpace: 1.4,
            color: AppColors.whiteColor,
            weight: FontWeight.w700,
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "Refer your friends and get ",
                style: AppStyles.customTextStyle(
                  size: 16,
                  color: AppColors.lightWhiteCont,
                  weight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: "$creditAmount Credits FREE ",
                style: AppStyles.customTextStyle(
                  size: 16,
                  color: AppColors.primaryColor,
                  weight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: "once they register!",
                style: AppStyles.customTextStyle(
                  size: 16,
                  lineSpace: 1.5,
                  color: AppColors.lightWhiteCont,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Illustration ─────────────────────────────────────────────────────
  Widget _buildIllustration() {
    return Image.asset(
      AssetImages.referralImage,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  // ── Referral code card ──────────────────────────────────────────────
  Widget _buildReferralCodeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.fieldBorderColor),
      ),
      child: Column(
        spacing: 14,
        children: [
          Text(
            "YOUR REFERRAL CODE",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.lightText,
              weight: FontWeight.w300,
            ),
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.5),
                      style: BorderStyle.solid,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    referralCode,
                    style: AppStyles.customTextStyle(
                      size: 20,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w800,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _copyCode,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      const Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      Text(
                        "Copy",
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Share section ────────────────────────────────────────────────────
  Widget _buildShareSection() {
    final List<Map<String, dynamic>> shareOptions = [
      {"label": "WhatsApp", "icon": AssetImages.whatsappIcon},
      {"label": "Telegram", "icon": AssetImages.telegramIcon},
      {"label": "Instagram", "icon": AssetImages.instagramIcon},
      {"label": "Facebook", "icon": AssetImages.faceBookIcon},
      {"label": "More", "icon": AssetImages.moreOptionsIcon},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.fieldBorderColor),
      ),
      child: Column(
        spacing: 16,
        children: [
          Text(
            "SHARE YOUR CODE",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.lightText,
              weight: FontWeight.w300,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: shareOptions.map((option) {
              return GestureDetector(
                onTap: () => _shareVia(option["label"]),
                child: Column(
                  spacing: 8,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(option["icon"]),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      option["label"],
                      style: AppStyles.customTextStyle(
                        size: 10,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── How it works ─────────────────────────────────────────────────────
  Widget _buildHowItWorks() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.fieldBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Container(
            width: 70,
            height: 70,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.fieldBorderColor),
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AssetImages.giftIcon),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  "How it works?",
                  style: AppStyles.customTextStyle(
                    size: 16,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w700,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "Share your referral code with your friends. Once they install Internsharks using your code, you get ",
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: AppColors.lightWhiteCont,
                          weight: FontWeight.w300,
                          lineSpace: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "$creditAmount Credits FREE!",
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: AppColors.primaryColor,
                          weight: FontWeight.w500,
                          lineSpace: 1.5,
                        ),
                      ),
                    ],
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
