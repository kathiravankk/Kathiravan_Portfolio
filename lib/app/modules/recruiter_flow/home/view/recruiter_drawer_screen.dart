import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/common_utils.dart';
import 'package:internsharks/app/core/widgets/card_widgets.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class RecruiterDrawerScreen extends StatefulWidget {
  const RecruiterDrawerScreen({super.key});

  @override
  State<RecruiterDrawerScreen> createState() => _RecruiterDrawerScreenState();
}

class _RecruiterDrawerScreenState extends State<RecruiterDrawerScreen> {
  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  String? recruiterId = "";

  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();

  Future<void> getProfileData() async {
    recruiterId = await LocalStorageService.getRecruiterId();
    try {
      await homeController.getRecruiterProfileData(recruiterId: recruiterId!);
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
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
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: AppColors.drawerColor,
      ),
      padding: const EdgeInsets.all(15),
      child: Obx(
        () => homeController.profileLoading
            ? AppAlertUtils.customLoader()
            : SafeArea(
                child: Column(
                  spacing: 15,
                  children: [
                    Row(
                      spacing: 15,
                      children: [
                        GestureDetector(
                          onTap: () {
                            CommonUtils.showProfileImageViewer(
                              context,
                              homeController.profileModel.recCompanyLogo ?? "",
                              homeController.profileModel.recCompanyName ?? "",
                            );
                          },
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.contColor2,
                            backgroundImage: NetworkImage(
                              homeController.profileModel.recCompanyLogo ?? "",
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                homeController.profileModel.recName ?? "",
                                style: AppStyles.customTextStyle(
                                  size: 16,
                                  weight: FontWeight.w700,
                                  color: AppColors.whiteColor,
                                ),
                              ),

                              Text(
                                homeController.profileModel.recEmail ?? "",
                                style: AppStyles.customTextStyle(
                                  size: 14,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    CardWidgets.settingsTile(
                      icon: Icons.person_outline,
                      title: "My Profile",
                      onTap: () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.recruiterProfileScreen,
                        );
                      },
                    ),
                    CardWidgets.settingsTile(
                      icon: Icons.school_outlined,
                      title: "Shortlisted Students",
                      onTap: () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.shortlistedStudentsListScreen,
                        );
                      },
                    ),
                    CardWidgets.settingsTile(
                      icon: Icons.account_balance_wallet_outlined,
                      title: "Buy Credits",
                      onTap: () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.recruiterCreditPlanScreen,
                          arguments: {
                            "creditBalance": homeController
                                .profileModel
                                .recruiterCreditId!
                                .balance,
                            "creditId": homeController
                                .profileModel
                                .recruiterCreditId!
                                .id,
                          },
                        );
                      },
                    ),
                    CardWidgets.settingsTile(
                      icon: Icons.groups_outlined,
                      title: "Referrals",
                      onTap: () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.recruiterReferralScreen,
                        );
                      },
                    ),
                    CardWidgets.settingsTile(
                      icon: Icons.workspace_premium_outlined,
                      title: "Certificates",
                      onTap: () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.recruiterCertificateScreen,
                        );
                      },
                    ),
                    CardWidgets.settingsTile(
                      icon: Icons.history,
                      title: "My Transaction",
                      onTap: () {
                        AppFunctions.navigateScreen(
                          context,
                          AppRoutes.recruiterCreditHistoryScreen,
                          arguments: {
                            "creditBalance": ((homeController
                                .profileModel
                                .recruiterCreditId!
                                .freeCredits ??
                                0) +
                                (homeController
                                    .profileModel
                                    .recruiterCreditId!
                                    .balance ??
                                    0))
                          }
                        );
                      },
                    ),

                    const Spacer(),

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
                    const SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildDrawerTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.white70),
      title: Text(
        title,
        style: AppStyles.customTextStyle(
          size: 15,
          color: isLogout ? AppColors.redColor : AppColors.whiteColor,
        ),
      ),
    );
  }
}
