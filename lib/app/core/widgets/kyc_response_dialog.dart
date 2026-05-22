import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/account/kyc_update_model.dart';
import 'package:internsharks/app/routes/app_pages.dart';

Future<void> showKycResultDialog({
  required BuildContext context,
  required KycUpdateModel model,
  required bool isRegisterFlow,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        _KycResultDialog(model: model, isRegisterFlow: isRegisterFlow),
  );
}

class _KycResultDialog extends StatelessWidget {
  final KycUpdateModel model;
  final bool isRegisterFlow;

  const _KycResultDialog({required this.model, required this.isRegisterFlow});

  static String _subtitle(String field, String status) {
    if (status == 'valid') {
      return switch (field) {
        'name' => 'Your registered name is valid.',
        'aadhaar' => 'Valid Aadhaar Document detected.',
        'aadhaarName' => 'Name on Aadhaar matches your registered name.',
        'collegeId' => 'Valid College ID Document detected.',
        'collegeName' => 'Name on College ID matches your registered name.',
        _ => 'Verified successfully.',
      };
    }
    return switch (field) {
      'name' => 'Your registered name could not be verified.',
      'aadhaar' => 'Aadhaar document not recognized or unclear.',
      'aadhaarName' => 'Name on Aadhaar does not match your registered name.',
      'collegeId' => 'College ID not recognized or unclear.',
      'collegeName' =>
        'Name on College ID does not match your registered name.',
      _ => 'Verification failed.',
    };
  }

  void _dismiss(BuildContext ctx) {
    Get.back();
    if (isRegisterFlow) {
      AppFunctions.navigateScreen(
        ctx,
        AppRoutes.stepUpdateScreen,
        arguments: {'activeStep': 4},
      );
    } else {
      AppFunctions.navigateInitialScreen(
        ctx,
        AppRoutes.dashBoardScreen,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final checks = [
      _CheckItem(
        label: 'Name Integrity',
        field: 'name',
        status: model.name ?? '',
      ),
      // _CheckItem(
      //   label: 'Aadhaar Document',
      //   field: 'aadhaar',
      //   status: model.aadhaarDocument ?? '',
      // ),
      // _CheckItem(
      //   label: 'Aadhaar Name Match',
      //   field: 'aadhaarName',
      //   status: model.aadhaarName ?? '',
      // ),
      _CheckItem(
        label: 'College ID Document',
        field: 'collegeId',
        status: model.collegeId ?? '',
      ),
      _CheckItem(
        label: 'College ID Name Match',
        field: 'collegeName',
        status: model.collegeName ?? '',
      ),
    ];

    final anyInvalid = checks.any((c) => c.status.toLowerCase() != 'valid');

    return AlertDialog(
      backgroundColor: AppColors.fieldBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      contentPadding: EdgeInsets.zero,

      content: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetImages.appAlertImage, height: 30, width: 30),

            const SizedBox(height: 10),
            Text(
              'KYC Verification',
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            const Divider(color: AppColors.dividerContColor),

            const SizedBox(height: 5),

            ...checks.map(
              (c) => _CheckRow(
                label: c.label,
                subtitle: _subtitle(c.field, c.status.toLowerCase()),
                isValid: c.status.toLowerCase() == 'valid',
              ),
            ),

            const SizedBox(height: 10),

            if (anyInvalid)
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.lightColorText,
                    lineSpace: 1.4,
                  ),
                  children: [
                    TextSpan(text: 'Please fix the documents shown as '),
                    TextSpan(
                      text: 'Invalid',
                      style: AppStyles.customTextStyle(
                        size: 12,
                        color: AppColors.inCorrectText,
                        weight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' and re-upload to complete your verification. Our team will also review your submission.',
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            CustomButtonWidget(
              height: 40,
              buttonFunction: () => _dismiss(context),
              buttonText: anyInvalid ? "Ok, I'll Fix It" : 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isValid;

  const _CheckRow({
    required this.label,
    required this.subtitle,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = isValid
        ? AppColors.correctText
        : AppColors.inCorrectText;

    final badgeBg = isValid ? AppColors.correctBg : AppColors.inCorrectBg;
    final badgeBorder = isValid
        ? AppColors.correctBorder
        : AppColors.inCorrectBorder;
    final badgeText = isValid ? 'Valid' : 'Invalid';
    final badgeIcon = isValid ? Icons.check_circle : Icons.cancel;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppStyles.customTextStyle(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: badgeBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(badgeIcon, size: 15, color: badgeColor),
                    const SizedBox(width: 4),
                    Text(
                      badgeText,
                      style: AppStyles.customTextStyle(
                        size: 10,
                        weight: FontWeight.w400,
                        color: badgeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            style: AppStyles.customTextStyle(
              size: 12,
              color: badgeColor,
              lineSpace: 1.3,
              weight: FontWeight.w300,
            ),
          ),
          const Divider(color: AppColors.dividerContColor),
        ],
      ),
    );
  }
}

class _CheckItem {
  final String label;
  final String field;
  final String status;

  const _CheckItem({
    required this.label,
    required this.field,
    required this.status,
  });
}
