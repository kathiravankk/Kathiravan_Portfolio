import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/card_widgets.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final ProfileController profileController = Get.find<ProfileController>();
  bool? isVerified = true;

  @override
  void initState() {
    checkVerifiedUser();
    super.initState();
  }

  Future<void> checkVerifiedUser() async {
    isVerified = await LocalStorageService.getVerifiedValue();
    debugPrint("$isVerified...............**************");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: AppColors.fieldBgColor,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        spacing: 15,
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 15,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: isVerified!
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF00D9F5),
                                Color(0xFF00F5A0),
                                Color(0xFF0093B4),
                                Color(0xFF00F5A0),
                                Color(0xFF00D9F5),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          )
                        : BoxDecoration(color: AppColors.transparentColor),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.whiteColor,
                      backgroundImage: NetworkImage(
                        profileController.profileDataModel.studProfile ?? "",
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          Text(
                            profileController.profileDataModel.studentName ??
                                "",
                            style: AppStyles.customTextStyle(
                              size: 14,
                              color: AppColors.secondaryColor,
                              weight: FontWeight.w700,
                            ),
                          ),
                          Visibility(
                            visible: isVerified!,
                            child: Icon(
                              Icons.verified_sharp,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        profileController.profileDataModel.studEmail ?? "",
                        style: AppStyles.customTextStyle(
                          size: 12,
                          color: AppColors.lightWhiteCont,
                          weight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Expanded(
              //   child: IconButton(
              //     onPressed: () {
              //       Get.back();
              //     },
              //     icon: Icon(
              //       Icons.close_sharp,
              //       color: AppColors.failTextColor,
              //       size: 22,
              //     ),
              //   ),
              // ),
            ],
          ),
          Divider(color: AppColors.contBorderColor),
          Visibility(
            visible: !isVerified!,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blackGradient1,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.primaryColor),
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    "${profileController.profileDataModel.studentName ?? "User"}, you aren't not verified!",
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () => Get.back(),
                  //   child: Icon(
                  //     Icons.close_sharp,
                  //     color: AppColors.primaryColor,
                  //     size: 20,
                  //   ),
                  // ),
                  Text(
                    "AI verification is a signal of trust, giving \nRecruiters more confidence to interact with you.",
                    style: AppStyles.customTextStyle(
                      lineSpace: 1.3,
                      size: 12,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w300,
                    ),
                  ),
                  CustomButtonWidget(
                    height: 35,
                    width: 120,
                    buttonFunction: () {
                      Get.back();
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.kycVerificationScreen,
                        arguments: {"isRegisterFlow": false},
                      );
                    },
                    buttonText: "Verify Now",
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: [
                  CardWidgets.settingsTile(
                    icon: Icons.category_outlined,
                    title: "Profile",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.homeProfileScreen,
                      );
                    },
                  ),

                  CardWidgets.settingsTile(
                    icon: Icons.description_outlined,
                    title: "My Applications",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.myAppliesScreen,
                      );
                    },
                  ),
                  CardWidgets.settingsTile(
                    icon: Icons.bookmark_border_sharp,
                    title: "Saved Post",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.savedInternshipScreen,
                      );
                    },
                  ),
                  CardWidgets.settingsTile(
                    icon: CupertinoIcons.settings,
                    title: "Settings",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.accountSettingScreen,
                      );
                    },
                  ),
                  CardWidgets.settingsTile(
                    icon: Icons.card_membership_sharp,
                    title: "Certificates",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.myCertificatesScreen,
                      );
                    },
                  ),
                  CardWidgets.settingsTile(
                    icon: Icons.currency_exchange_sharp,
                    title: "Buy Credits",
                    onTap: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.buyCreditsScreen,
                      );
                    },
                  ),
                  CardWidgets.settingsCard(
                    children: [
                      CardWidgets.settingsTile(
                        isDelete: true,
                        icon: Icons.logout_sharp,
                        title: "Logout",
                        onTap: () {
                          //showLogoutPopup(context);
                          AppAlertUtils.showAppAlert(
                            context: context,
                            content: "Are you sure you want to logout?",
                            confirmText: "Confirm",
                            title: "Logout",
                            onConfirm: () {
                              AppFunctions.logOutFunc(context);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogOut = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              spacing: 15,
              children: [
                Icon(
                  icon,
                  color: isLogOut
                      ? AppColors.failTextColor
                      : AppColors.whiteColor,
                  size: 23,
                ),
                Text(
                  title,
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: isLogOut
                        ? AppColors.failTextColor
                        : AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

void showLogoutPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Logout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              AppFunctions.logOutFunc(context);
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      );
    },
  );
}
