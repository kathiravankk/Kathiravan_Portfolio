import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class CardWidgets {
  static Widget settingsCard({required List<Widget> children}) {
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

  static Widget settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDelete = false,
    bool isResumeFlow = false,
    Widget titleWidget = const Text(""),
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
              child: isResumeFlow
                  ? titleWidget
                  : Text(
                      title,
                      style: AppStyles.customTextStyle(
                        color: isDelete
                            ? AppColors.redColor
                            : AppColors.whiteColor,
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
