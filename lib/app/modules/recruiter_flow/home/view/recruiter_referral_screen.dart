import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/referral_utils.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/asset_images.dart';

class RecruiterReferralScreen extends StatefulWidget {
  const RecruiterReferralScreen({super.key});

  @override
  State<RecruiterReferralScreen> createState() =>
      RecruiterReferralScreenState();
}

class RecruiterReferralScreenState extends State<RecruiterReferralScreen> {
  final referralKey = GlobalKey<RecruiterReferralScreenState>();
  // @override
  // void initState() {
  //   super.initState();
  //   getProfileData();
  // }
  Future<void> refreshData() async {
    await getProfileData();
  }


  String? recruiterId = "";
  String? referCode = "";

  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();

  Future<void> getProfileData() async {
    recruiterId = await LocalStorageService.getRecruiterId();
    try {
      await homeController.getRecruiterProfileData(recruiterId: recruiterId!);
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        referCode = homeController.profileModel.recruiterData!.referCode ?? "";
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
      rethrow;
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
          iconTheme:  IconThemeData(color: AppColors.whiteColor),
        ),
        body: Obx(
          () => homeController.profileLoading
              ? AppAlertUtils.customLoader()
              : RefreshIndicator(
                  backgroundColor: AppColors.appBgColor_2,
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    await getProfileData();
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    child: Column(
                      children: [
                        SvgPicture.asset(AssetImages.referRecruiters),

                        Image.asset(AssetImages.freeCreditsUser, height: 140),

                        const SizedBox(height: 20),

                        Text(
                          "Know a recruiter, HR professional, startup founder, or company looking to hire interns and fresh talent?",
                          textAlign: TextAlign.center,
                          style: AppStyles.customTextStyle(
                            size: 16,
                            weight: FontWeight.w600,
                            color: AppColors.whiteColor,
                            lineSpace: 1.5,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Invite them to join Internsharks and help them connect with qualified candidates.",
                          textAlign: TextAlign.center,
                          style: AppStyles.customTextStyle(
                            size: 15,
                            weight: FontWeight.w400,
                            color: AppColors.lightWhiteCont,
                            lineSpace: 1.5,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _buildReferralCard(),

                        const SizedBox(height: 15),

                        _buildHowItWorks(),

                        const SizedBox(height: 15),
                        _buildShareSection(),
                        const SizedBox(height: 15),

                        _buildRewardCard(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildReferralCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.fieldBorderColor),
      ),
      child: Column(
        children: [
          Text(
            "YOUR REFERRAL CODE",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.lightText,
              weight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 15),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorderColor),
            ),
            alignment: Alignment.center,
            child: Text(
              homeController.profileModel.recruiterData!.referCode  ?? "",
              style: AppStyles.customTextStyle(
                size: 22,
                weight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: homeController.profileModel.recruiterData!.referCode!.isEmpty && homeController.profileModel.recruiterData!.referCode != null
                  ? () {
                AppAlertUtils.showToast(message: "Referral Code is Empty!", isError: true);
              }
                  : () {
                      ReferralUtils.copyCode(code: homeController.profileModel.recruiterData!.referCode ?? "");
                    },
              icon: const Icon(Icons.copy, color: Colors.white),
              label: Text(
                "Copy",
                style: AppStyles.customTextStyle(
                  size: 15,
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.fieldBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "HOW IT WORKS",
              style: AppStyles.customTextStyle(
                size: 14,
                weight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
          ),

          const SizedBox(height: 22),

          _stepWidget(
            AppColors.blueColor,
            CupertinoIcons.link,
            "1. Share",
            "Share your referral code with recruiters",
          ),

          const SizedBox(height: 18),

          _stepWidget(
            AppColors.primaryColor,
            CupertinoIcons.person_badge_plus,
            "2. Recruiter Signs Up",
            "Recruiter signs up using your code",
          ),

          const SizedBox(height: 18),

          _stepWidget(
            AppColors.orangeColor,
            CupertinoIcons.gift,
            "3. You Earn",
            "You earn 50 Credits FREE",
          ),
        ],
      ),
    );
  }

  Widget _stepWidget(
    Color color,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Icon(icon, color: AppColors.whiteColor),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Text(
                title,
                style: AppStyles.customTextStyle(
                  size: 15,
                  weight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff1D365B), Color(0xff0F4E8D)],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Image.asset(AssetImages.giftIcon),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "REWARD",
                  style: AppStyles.customTextStyle(
                    size: 16,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Earn ",
                        style: AppStyles.customTextStyle(
                          size: 13,
                          color: Colors.white70,
                        ),
                      ),

                      TextSpan(
                        text: "50 Credits FREE",
                        style: AppStyles.customTextStyle(
                          size: 13,
                          color: AppColors.primaryColor,
                          weight: FontWeight.w700,
                        ),
                      ),

                      TextSpan(
                        text: " for every successful recruiter referral.",
                        style: AppStyles.customTextStyle(
                          size: 13,
                          color: Colors.white70,
                          lineSpace: 1.4
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

  Widget _buildShareSection() {
    final List<Map<String, dynamic>> shareOptions = [
      {"label": "WhatsApp", "icon": AssetImages.whatsappIcon},
      {"label": "Telegram", "icon": AssetImages.telegramIcon},
      {"label": "Instagram", "icon": AssetImages.instagramIcon},
      {"label": "Facebook", "icon": AssetImages.faceBookIcon},
      {"label": "More", "icon": AssetImages.moreOptionsIcon},
    ];
    String shareText = '''
🏢 Refer Recruiters, 🎉 Earn Credits!

Know a recruiter, HR professional, startup founder, or company looking to hire interns and fresh talent?

Invite them to join Internsharks and help them connect with qualified candidates.

🚀 How It Works

✅ Share your referral link with recruiters
✅ Recruiter signs up using your referral code
✅ You earn 50 Credits FREE

🔗 Your Referral Link

https://internsharks.ai

🎟️ Your Referral Code: *${homeController.profileModel.recruiterData!.referCode ?? ""}*

💡 Ask the recruiter to enter this code during signup to complete your referral.

🎁 Reward

Earn 50 Credits FREE for every successful recruiter referral.

🚀 Start sharing and help recruiters discover top internship talent through Internsharks.ai!
''';

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
                //onTap: () => _shareVia(option["label"]),
                onTap: () => ReferralUtils.share(
                  platform: option["label"],
                  shareText: shareText,
                ),
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
}
