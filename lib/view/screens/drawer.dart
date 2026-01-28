import 'package:flutter/material.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/app/modules/login/view/splash_screen.dart';
import 'package:get/get.dart';


class Drawers extends StatefulWidget {
  const Drawers({super.key});

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.appColor,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.85,
        child: Column(
          children: [

            /// ---------------- HEADER ----------------
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: AppColors.appColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage(
                              "lib/assets/images/Virat_Kohli_in_PMO_New_Delhi.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Rokesh G", style: AppTextStyles.white16bold),
                          Text(
                            "roga719@gmail.com",
                            style: AppTextStyles.white16bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.grey.shade700),
            ),

            /// ---------------- MENU ITEMS ----------------
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      _drawerItem(
                        icon: Icons.person,
                        title: "Profile",
                        onTap: () {
                          Get.offAllNamed(
                            AppRoutes.profilePage,
                            arguments: {'showBack': true},
                          );
                        },
                      ),
                      _drawerItem(
                        icon: Icons.description_outlined,
                        title: "My Applications",
                        onTap: () {
                          Get.offAllNamed(
                            AppRoutes.myApplicationPage,
                          );

                        },
                      ),
                      _drawerItem(
                        icon: Icons.bookmark_border,
                        title: "Saved Post",
                        onTap: () {
                          // Navigator.push(context, AppPageRoute(page: MyApplicationPage()));
                        },
                      ),
                      _drawerItem(
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {
                          Get.offAllNamed(
                            AppRoutes.settingsPage,
                          );



                        },
                      ),

                      /// ---------------- LOGOUT BUTTON (FINAL WORKING) ----------------
                      // const SizedBox(height: 20),
                      InkWell(
                        onTap: () => showLogoutPopup(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: 15),
                                Text(
                                  "Logout",
                                  style: AppTextStyles.white20bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
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
    );
  }

  /// ---------------- REUSABLE DRAWER ITEM ----------------
  Widget _drawerItem({
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 25),
                  const SizedBox(width: 15),
                  Text(title, style: AppTextStyles.white20bold),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// ---------------- PROPER LOGOUT POPUP ----------------
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
              Navigator.pop(context);

              /// Clear all screens & go to splash
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => SplashScreen()),
                    (route) => false,
              );
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
