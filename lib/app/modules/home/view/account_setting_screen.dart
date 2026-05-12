import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';


class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.loginBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Account Settings",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Security ──────────────────────────────────────────────────
              Text(
                "Security",
                style: AppStyles.customTextStyle(
                  color: AppColors.whiteColor,
                  size: 16,
                  weight: FontWeight.w700,
                ),
              ),

              _settingsCard(
                children: [
                  _settingsTile(
                    icon: CupertinoIcons.phone_arrow_up_right,
                    title: "Change Mobile Number",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.mobileUpdateScreen,
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  Divider(color: AppColors.contBorderColor),
                  const SizedBox(height: 5),
                  _settingsTile(
                    icon: CupertinoIcons.mail,
                    title: "Change Email",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.emailUpdateScreen,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10,),

              // ── Privacy Policy & Terms ────────────────────────────────────
              Text(
                "Privacy Policy and Terms & Conditions",
                style: AppStyles.customTextStyle(
                  color: AppColors.whiteColor,
                  size: 16,
                  weight: FontWeight.w700,
                ),
              ),

              _settingsCard(
                children: [
                  _settingsTile(
                    icon: CupertinoIcons.lock_shield,
                    title: "Privacy Policy",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.privacyPolicyScreen,
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  Divider(color: AppColors.contBorderColor),
                  const SizedBox(height: 5),
                  _settingsTile(
                    icon: CupertinoIcons.doc_text,
                    title: "Terms and Conditions",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.termsAndConditionsScreen,
                      );
                    },
                  ),
                ],
              ),

              // ── Delete Account ────────────────────────────────────────────
              const SizedBox(height: 10),
              _settingsCard(
                children: [
                  _settingsTile(
                    isDelete: true,
                    icon: CupertinoIcons.delete,
                    title: "Delete Account",
                    onTap: () {
                      AppAlertUtils.showAppAlert(
                        context: context,
                        title: "Delete Account",
                        confirmText: "OKAY",
                        customContent: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Please contact admin to Delete your Account!",
                              textAlign: TextAlign.center,
                              style: AppStyles.customTextStyle(
                                lineSpace: 1.3,
                                size: 14,
                                color: AppColors.whiteColor,
                                weight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 10),

                            /// Copyable Email
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  const ClipboardData(
                                    text: "info@internsharks.ai",
                                  ),
                                );
                                AppAlertUtils.showToast(
                                  message: "Email copied!",
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "info@internsharks.ai",
                                      style: AppStyles.customTextStyle(
                                        size: 14,
                                        color: AppColors.primaryColor,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.copy,
                                      size: 16,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        content: '',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.contBorderColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDelete = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDelete
                    ? AppColors.lightRedColor
                    : AppColors.contLightColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: isDelete ? AppColors.redColor : AppColors.whiteColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppStyles.customTextStyle(
                  color: isDelete ? AppColors.redColor : AppColors.whiteColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            InkWell(
              onTap: onTap,
              child: Icon(
                Icons.arrow_forward_ios,
                color: isDelete ? AppColors.redColor : AppColors.whiteColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
