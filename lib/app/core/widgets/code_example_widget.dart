import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class CodeExampleWidget extends StatelessWidget {
  final String code;

  const CodeExampleWidget({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Code Example",
                style: AppStyles.customTextStyle(
                  size: 14,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w500,
                ),
              ),

              IconButton(
                icon: const Icon(
                  Icons.copy,
                  color: AppColors.greyIcon,
                  size: 20,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));

                  Get.snackbar(
                    "Copied",
                    "Code copied to clipboard",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),

          SelectableText(
            code,
            style: AppStyles.customTextStyle(
              size: 11,
              lineSpace: 1.5,
              color: AppColors.codeColor,
              weight: FontWeight.w400,
              fontFamily: "monospace",
            ),
          ),
        ],
      ),
    );
  }
}
