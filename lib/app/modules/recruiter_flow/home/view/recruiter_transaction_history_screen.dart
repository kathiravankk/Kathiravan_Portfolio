import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart' show AppStyles;
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';

class RecruiterTransactionHistoryScreen extends StatefulWidget {
  const RecruiterTransactionHistoryScreen({super.key});

  @override
  State<RecruiterTransactionHistoryScreen> createState() =>
      _RecruiterTransactionHistoryScreenState();
}

class _RecruiterTransactionHistoryScreenState
    extends State<RecruiterTransactionHistoryScreen> {
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();

  String? recruiterId = "";

  @override
  void initState() {
    super.initState();
    getTransactionData();
  }

  Future<void> getTransactionData() async {
    try {
      recruiterId = await LocalStorageService.getRecruiterId();
      await homeController.getTransactionHistory(recruiterId: recruiterId!);
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, try again later!",
        );
      }
    } catch (err, stackTrace) {
      debugPrint("getTransactionData error: $err");
      debugPrint(stackTrace.toString());
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, try again later!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.transparentColor,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(
              CupertinoIcons.back,
              color: AppColors.whiteColor,
              size: 30,
            ),
          ),
          title: Text(
            "Credits History",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
        ),
        body: Obx(() {
          final isLoading = homeController.transactionHistoryLoading;
          final transactions = homeController.historyModel.transactionData;

          if (isLoading && transactions.isEmpty) {
            return AppAlertUtils.customLoader();
          }

          if (transactions.isEmpty) {
            return _buildEmptyState();
          }

          final credit = transactions.first.recCredit;
          final pagination = homeController.historyModel.pagination;

          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: AppColors.appBgColor_2,
            onRefresh: getTransactionData,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _buildBalanceCard(credit),
                const SizedBox(height: 24),
                _buildSectionHeader(
                  "Transaction History",
                  pagination == null
                      ? null
                      : "${transactions.length} of ${pagination.total ?? transactions.length}",
                ),
                const SizedBox(height: 12),
                ...transactions.map(_buildTransactionCard),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 56,
            color: AppColors.secondaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            "No transactions yet",
            style: AppStyles.customTextStyle(
              size: 15,
              color: Colors.white70,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? trailing) {
    return Row(
      children: [
        const Icon(
          Icons.receipt_long_outlined,
          size: 18,
          color: AppColors.secondaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: AppStyles.customTextStyle(
              size: 15,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: AppStyles.customTextStyle(
              size: 12,
              color: Colors.white54,
              weight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildBalanceCard(dynamic credit) {
    final balance = credit?.balance ?? 0;
    final totalUsed = credit?.totalUsed ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.transContCred1,
            AppColors.transContCred2,
            AppColors.transContCred3,
            AppColors.transContCred4,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available Credits",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
                Text(
                  "$balance",
                  style: AppStyles.customTextStyle(
                    size: 30,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w800,
                  ),
                ),
                Text(
                  "Use credits to unlock premium features and generate content.",
                  style: AppStyles.customTextStyle(
                    lineSpace: 1.5,
                    size: 12,
                    color: AppColors.lightColorText,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            AssetImages.transactionCreditIcon,
            height: 100,
            width: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(dynamic tx) {
    final isDebit = tx.type == "debit";
    final amountColor = isDebit
        ? AppColors.inCorrectText
        : AppColors.correctText;
    final amountPrefix = isDebit ? "-" : "+";
    final statusColor = _statusColor(tx.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.recContainerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _iconBgColor(tx.apiName).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _iconFor(tx.apiName),
              color: _iconBgColor(tx.apiName),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  _formatApiName(tx.apiName),
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatDate(tx.createdAt),
                  style: AppStyles.customTextStyle(
                    size: 11,
                    color: Colors.white54,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$amountPrefix${tx.credits ?? 0}",
                style: AppStyles.customTextStyle(
                  size: 15,
                  color: amountColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _capitalize(tx.status ?? ""),
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: statusColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case "success":
        return AppColors.correctText;
      case "failed":
        return AppColors.inCorrectText;
      case "pending":
        return AppColors.secondaryColor;
      default:
        return AppColors.lightColorText;
    }
  }

  IconData _iconFor(String? apiName) {
    switch (apiName) {
      case "generate-certificate":
        return Icons.workspace_premium_outlined;
      case "generate-syllabus":
        return Icons.menu_book_outlined;
      case "recruiter-jobpost":
        return Icons.work_outline;
      default:
        return Icons.bolt_outlined;
    }
  }

  Color _iconBgColor(String? apiName) {
    switch (apiName) {
      case "generate-certificate":
        return const Color(0xFFB794F4);
      case "generate-syllabus":
        return const Color(0xFF63B3ED);
      case "recruiter-jobpost":
        return const Color(0xFFF6AD55);
      default:
        return AppColors.secondaryColor;
    }
  }

  String _formatApiName(String? apiName) {
    switch (apiName) {
      case "generate-certificate":
        return "Certificate Generation";
      case "generate-syllabus":
        return "Syllabus Generation";
      case "recruiter-jobpost":
        return "Job Post";
      default:
        if (apiName == null || apiName.isEmpty) return "Credit Usage";
        return apiName
            .split("-")
            .map(
              (w) => w.isEmpty ? w : "${w[0].toUpperCase()}${w.substring(1)}",
            )
            .join(" ");
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat("dd MMM yyyy, hh:mm a").format(date.toLocal());
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return "${value[0].toUpperCase()}${value.substring(1)}";
  }
}
