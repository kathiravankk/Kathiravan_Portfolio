import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
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
                Text("Settings", style: AppTextStyles.yellow24Bold),
              ],
            ),

            const SizedBox(height: 30),

            /// ---------- BODY SCROLL ----------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// ---------------- ACCOUNT TITLE ----------------
                    const Text(
                      "Account",
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
                          icon: Icons.person_outline,
                          title: "Account Settings",
                          onTap: () {
                            Get.toNamed(AppRoutes.accountSettingsPage);
                          },
                        ),
                        _divider(),
                        _settingsSwitchTile(
                          icon: Icons.visibility_outlined,
                          title: "Resume Visibility",
                        ),
                        _divider(),
                        _settingsSwitchTile(
                          icon: Icons.notifications_outlined,
                          title: "Notification Preferences",
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// ---------------- APPLICATION ----------------
                    const Text(
                      "Application",
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
                          icon: Icons.settings_outlined,
                          title: "App Preferences",
                          onTap: () {Get.toNamed(AppRoutes.appPreferencesPage);

                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// ---------------- SUPPORT & LEGAL ----------------
                    const Text(
                      "Support & Legal",
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
                          icon: Icons.help_outline,
                          title: "FAQ",
                          onTap: () {},
                        ),
                        _divider(),
                        _settingsTile(
                          icon: Icons.description_outlined,
                          title: "Terms & Condition",
                          onTap: () {},
                        ),
                        _divider(),
                        _settingsTile(
                          icon: Icons.verified_user_outlined,
                          title: "Privacy Policy",
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

  /// CARD
  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1c2121),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(children: children),
    );
  }

  /// NORMAL TILE (uses your _buildActionTile design)
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
            _iconContainer(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  /// SWITCH TILE
  Widget _settingsSwitchTile({required IconData icon, required String title}) {
    return Row(
      children: [
        _iconContainer(icon),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(
          value: false,
          onChanged: (v) {},
          activeColor: AppColors.appYellow,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.shade700,
        ),
      ],
    );
  }

  /// ICON BOX
  Widget _iconContainer(IconData icon) {
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 1,
      color: const Color(0xFF2F2F2F),
    );
  }
}
