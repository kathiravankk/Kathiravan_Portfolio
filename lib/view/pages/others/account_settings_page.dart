import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';import '../../../controllers/login_controller.dart';
import '../../../core/const_file/app_button.dart';
import '../../../core/const_file/app_colors.dart';
import '../../../core/const_file/app_text_style.dart';
import '../../../core/routes/app_pages.dart';


import '200.dart';
import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';
import 'change_phoneNumber_page.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/asset/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// ---------- TITLE ----------
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 25),
                ),
                SizedBox(width: 10),
                Text("Account Settings", style: AppTextStyles.yellow24Bold),
              ],
            ),

            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ---------------- SECURITY TITLE ----------------
                    const Text(
                      "Security",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ---------------- SECURITY CARD ----------------
                    _settingsCard(
                      children: [
                        _settingsTile(
                          icon: Icons.phone_callback_outlined,
                          title: "Change Mobile Number",
                          onTap: () {
                            Get.toNamed(
                              Routes.changePhoneNumberPage,

                            );

                          },
                        ),
                        _divider(),
                        _settingsTile(
                          icon: Icons.mail_outline,
                          title: "Change Email",
                          onTap: () {
                            Get.toNamed(
                              Routes.changeEmailPage,

                            );

                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// ---------------- INTEGRATION TITLE ----------------
                    const Text(
                      "Integration",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _settingsCard(
                      children: [
                        _settingsTile(
                          icon: Icons.account_tree_outlined,
                          title: "Manage Linked Accounts",
                          onTap: () {
                            Get.toNamed(
                              Routes.manageLinkedAccountsPage,

                            );

                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// ---------------- DELETE ACCOUNT ----------------
                    _settingsCard(
                      children: [
                        _deleteTile(
                          icon: Icons.delete_outline,
                          title: "Delete Account",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- REUSABLE COMPONENTS -----------------
  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF2F2F2F)),
      ),
      child: Column(children: children),
    );
  }

  /// NORMAL TILE (uses your _buildActionTile style)
  Widget _settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            _iconBox(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  /// ICON
  Widget _iconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF5A5A3A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  /// DIVIDER
  Widget _divider() {
    return Container(
      height: 1,
      color: const Color(0xFF2F2F2F),
      margin: const EdgeInsets.symmetric(vertical: 6),
    );
  }
}
