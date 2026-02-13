import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
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
                  SizedBox(height: 5),
                  Divider(color: AppColors.contBorderColor),
                  SizedBox(height: 5),
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
              SizedBox(height: 10),
              _settingsCard(
                children: [
                  _settingsTile(
                    isDelete: true,
                    icon: CupertinoIcons.delete,
                    title: "Delete Account",
                    onTap: () {},
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
              child: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.whiteColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
