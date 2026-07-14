import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

class StipendPaymentDialog extends StatelessWidget {
  const StipendPaymentDialog({
    super.key,
    required this.studentName,
    required this.internship,
    required this.amount,
    required this.onPay,
  });

  final String studentName;
  final String internship;
  final String amount;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.recContainerColor2,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Image.asset(
              AssetImages.paymentRequiredIcon,
              height: 90,
            ),

            const SizedBox(height: 16),

            Text(
              "Stipend Payment Required",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 22,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Please ensure the stipend is paid before issuing the certificate.",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.greyTextColor,
                lineSpace: 1.4,
              ),
            ),

            const SizedBox(height: 18),

            Divider(color: AppColors.statusBorder),

            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: AppColors.recContainerColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.statusBorder),
              ),
              child: Column(
                children: [

                  _tile(
                    Icons.person,
                    "Student",
                    studentName,
                  ),

                  Divider(
                    height: 1,
                    color: AppColors.statusBorder,
                  ),

                  _tile(
                    Icons.work,
                    "Internship",
                    internship,
                  ),

                  Divider(
                    height: 1,
                    color: AppColors.statusBorder,
                  ),

                  _tile(
                    Icons.currency_rupee,
                    "Amount",
                    "₹$amount",
                    subtitle: "+18% GST Extra",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            CustomButtonWidget(
              buttonFunction: onPay,
              buttonText: "Pay ₹$amount",
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
      IconData icon,
      String title,
      String value, {
        String? subtitle,
      }) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [

          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade800,
            child: Icon(
              icon,
              color: AppColors.primaryColor,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  "$title:",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.greyTextColor,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: AppStyles.customTextStyle(
                    size: 22,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                  ),
                ),

                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle,
                      style: AppStyles.customTextStyle(
                        size: 13,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}