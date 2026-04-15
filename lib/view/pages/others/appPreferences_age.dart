import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
class AppPreferencesPage extends StatefulWidget {
  const AppPreferencesPage({super.key});

  @override
  State<AppPreferencesPage> createState() => _AppPreferencesPageState();
}

class _AppPreferencesPageState extends State<AppPreferencesPage> {
  bool isDarkTheme = false;
  String selectedLanguage = "English";
  String selectedFontSize = "Default";
  String selectedDataUsage = "Standard";
  String cacheSize = "12.5 MB";

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
            // Header
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
                ),
                const SizedBox(width: 5),
                Text("App Preferences", style: AppTextStyles.yellow24Bold),
              ],
            ),
            const SizedBox(height: 30),

            // Preferences Container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A).withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF3A3A3A),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Dark Theme
                  _buildPreferenceItem(
                    icon: Icons.nightlight_round,
                    title: "Dark Theme",
                    trailing: Switch(
                      value: isDarkTheme,
                      onChanged: (value) {
                        setState(() {
                          isDarkTheme = value;
                        });
                      },
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF4A5568),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFF4A5568),
                    ),
                  ),

                  const Divider(color: Color(0xFF3A3A3A), height: 1),

                  // Language
                  _buildPreferenceItem(
                    icon: Icons.language,
                    title: "Language",
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedLanguage,
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to language selection
                    },
                  ),

                  const Divider(color: Color(0xFF3A3A3A), height: 1),

                  // Font Size
                  _buildPreferenceItem(
                    icon: Icons.text_fields,
                    title: "Font size",
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedFontSize,
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to font size selection
                    },
                  ),

                  const Divider(color: Color(0xFF3A3A3A), height: 1),

                  // Data Usage
                  _buildPreferenceItem(
                    icon: Icons.data_usage,
                    title: "Data Usage",
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedDataUsage,
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to data usage selection
                    },
                  ),

                  const Divider(color: Color(0xFF3A3A3A), height: 1),

                  // Clear Cache
                  _buildPreferenceItem(
                    icon: Icons.cleaning_services,
                    title: "Clear Cache",
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cacheSize,
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                    onTap: () {
                      // Show clear cache confirmation
                      _showClearCacheDialog();
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Save Changes Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved successfully')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Changes',
                  style: AppTextStyles.white18bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Icon Container
            Container(
             padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF5A6B4A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Trailing Widget
            trailing,
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Clear Cache',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to clear $cacheSize of cache?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                cacheSize = "0 MB";
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: Text('Clear', style: TextStyle(color: AppColors.appBlue)),
          ),
        ],
      ),
    );
  }}