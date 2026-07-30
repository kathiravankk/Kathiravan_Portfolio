import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/models/account/student_credit_history_model.dart';
import 'package:internsharks/app/data/models/account/student_purchase_history_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_payment_history_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_transaction_history_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class StudentTransactionHistoryScreen extends StatefulWidget {
  const StudentTransactionHistoryScreen({super.key});

  @override
  State<StudentTransactionHistoryScreen> createState() =>
      _StudentTransactionHistoryScreenState();
}

class _StudentTransactionHistoryScreenState
    extends State<StudentTransactionHistoryScreen> {
  final ProfileController profileController =
  Get.find<ProfileController>();

  String? studentId = "";
  int creditBalance = 0;

  @override
  void initState() {
    super.initState();
    creditBalance = Get.arguments["creditBalance"] ?? 0;
    loadData();
  }

  Future<void> loadData() async {
    try {
      studentId = await LocalStorageService.getStudentId();

      await Future.wait([
        profileController.getPurchaseHistoryData(
          page: 1,
          limit: 5,
          isLoadMore: false,
        ),
        profileController.getCreditHistory(
          studentId: studentId!,
          page: 1,
          isLoadMore: false,
        ),
      ]);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        "Something went wrong.",
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: AppColors.whiteColor),
          ),
          title: Text(
            "My Transaction",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
        ),

        body: Obx(() {
          if (profileController.creditHistoryLoading ||
              profileController.purchaseHistoryLoading) {
            return AppAlertUtils.customLoader();
          }
          return RefreshIndicator(
            onRefresh: loadData,
            backgroundColor: AppColors.appBgColor_2,
            color: AppColors.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildPurchaseHistoryCard(),
                  const SizedBox(height: 18),
                  buildCreditHistoryCard(),
                  const SizedBox(height: 18),
                  buildConsumptionGuide(),
                  const SizedBox(height: 20),
                  buildPaymentCard(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildPaymentCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.recContainerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.recBorderColor),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Image.asset(AssetImages.creditConsumeImg, height: 35, width: 35),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  "All payments are 100% secure.",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
                Text(
                  "We do not store any payment details.",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.lightText,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCreditHistoryCard() {
    final transactionList = profileController.creditHistoryList;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.recContainerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        children: [
          _buildCreditHeader(),
          Divider(height: 1, color: Colors.white.withOpacity(.06)),
          transactionList.isEmpty
              ? _buildTransactionEmptyWidget()
              : Column(
            children: transactionList
                .take(5)
                .map((item) => _buildCreditTransactionItem(item))
                .cast<Widget>()
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.wallet_giftcard,
              color: Colors.green,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Free Credits",
              style: AppStyles.customTextStyle(
                size: 14,
                color: Colors.green,
                weight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              AppFunctions.navigateScreen(
                context,
                AppRoutes.studentCreditHistoryScreen,
                arguments: {
                  "creditBalance": 0
                  // ((profileController
                  //     .creditModel
                  //     .recruiterCreditId!
                  //     .freeCredits ??
                  //     0) +
                  //     (profileController.profileModel.recruiterCreditId!.balance ??
                  //         0)),
                },
              );
            },
            child: Row(
              children: [
                Text(
                  "View All",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: Colors.white,
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.chevron_right, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditTransactionItem(CreditHistoryData tx) {
    final isDebit = tx.type == "debit";
    final amountColor = isDebit
        ? AppColors.inCorrectText
        : AppColors.correctText;
    final prefix = isDebit ? "-" : "+";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _transactionIconColor(tx.apiName).withOpacity(.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _transactionIcon(tx.apiName),
              color: _transactionIconColor(tx.apiName),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _transactionTitle(tx),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTransactionDate(tx.createdAt),
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
                "$prefix${tx.credits ?? 0}",
                style: AppStyles.customTextStyle(
                  size: 15,
                  color: amountColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _capitalize(tx.status ?? ""),
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: amountColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, size: 18, color: Colors.white54),
        ],
      ),
    );
  }

  Widget _buildTransactionEmptyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, color: AppColors.secondaryColor, size: 48),
          const SizedBox(height: 12),
          Text(
            "No transaction history",
            style: AppStyles.customTextStyle(
              size: 14,
              color: Colors.white70,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _transactionTitle(CreditHistoryData tx) {
    if (tx.type == "credit") {
      return "Credits Added";
    }
    return _formatApiName(tx.apiName);
  }

  IconData _transactionIcon(String? apiName) {
    switch (apiName) {
      case "generate-syllabus":
        return Icons.menu_book_outlined;
      case "generate-certificate":
        return Icons.workspace_premium_outlined;
      case "resume-review":
        return Icons.description_outlined;
      case "resume-optimization":
        return Icons.picture_as_pdf_outlined;
      case "banner-generation":
        return Icons.auto_fix_high;
      case "recruiter-jobpost":
        return Icons.work_outline;
      default:
        return Icons.bolt_outlined;
    }
  }

  Color _transactionIconColor(String? apiName) {
    switch (apiName) {
      case "generate-syllabus":
        return Colors.deepPurple;
      case "generate-certificate":
        return Colors.purpleAccent;
      case "resume-review":
        return Colors.blue;
      case "resume-optimization":
        return Colors.lightBlue;
      case "banner-generation":
        return Colors.orange;
      case "recruiter-jobpost":
        return Colors.amber;
      default:
        return AppColors.primaryColor;
    }
  }

  String _formatTransactionDate(String? date) {
    if (date == null || date.isEmpty) return "-";

    try {
      final dateTime = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime.toLocal());
    } catch (e) {
      return "-";
    }
  }

  String _formatApiName(String? apiName) {
    switch (apiName) {
      case "generate-syllabus":
        return "Syllabus Generation";
      case "generate-certificate":
        return "Certificate Generation";
      case "resume-review":
        return "Resume Review";
      case "resume-optimization":
        return "Resume Optimization";
      case "banner-generation":
        return "Banner Generation";
      case "recruiter-jobpost":
        return "Job Post";
      default:
        if (apiName == null || apiName.isEmpty) {
          return "Credit Usage";
        }

        return apiName
            .split("-")
            .map(
              (e) => e.isEmpty ? e : "${e[0].toUpperCase()}${e.substring(1)}",
        )
            .join(" ");
    }
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return "${value[0].toUpperCase()}${value.substring(1)}";
  }

  Widget buildPurchaseHistoryCard() {
    final purchaseList = profileController.purchaseHistoryList;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.recContainerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        children: [
          _buildPurchaseHeader(),
          Divider(height: 1, color: Colors.white.withOpacity(.06)),
          purchaseList.isEmpty
              ? _buildPurchaseEmptyWidget()
              : Column(
            children: [
              ...purchaseList.take(5).map(_buildPurchaseItem),
              Divider(height: 1, color: Colors.white.withOpacity(.06)),
              _buildPurchaseFooter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xff8B5CF6).withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xff8B5CF6),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Purchase History",
              style: AppStyles.customTextStyle(
                size: 14,
                color: const Color(0xff8B5CF6),
                weight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              AppFunctions.navigateScreen(
                context,
                AppRoutes.studentPurchaseHistoryScreen,
              );
            },
            child: Row(
              children: [
                Text(
                  "View All",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.chevron_right, size: 18, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseItem(StudentPurchaseData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _purchaseColor(item.planName).withOpacity(.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shopping_bag,
              color: _purchaseColor(item.planName),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.planName ?? "-",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatPurchaseDate(item.createdAt),
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
                "₹${item.amount ?? 0}",
                style: AppStyles.customTextStyle(
                  size: 15,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.status ?? "",
                style: AppStyles.customTextStyle(
                  size: 10,
                  color: AppColors.primaryColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: Colors.white54, size: 18),
        ],
      ),
    );
  }

  Widget _buildPurchaseFooter() {
    final totalSpent = profileController.purchaseHistoryList
        .where((e) => e.status == "SUCCESS")
        .fold<double>(
      0,
          (sum, e) => sum + (double.tryParse(e.amount.toString()) ?? 0),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Text(
            "Total Spent",
            style: AppStyles.customTextStyle(
              size: 14,
              color: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            "₹${totalSpent.toStringAsFixed(0)}",
            style: AppStyles.customTextStyle(
              size: 16,
              color: const Color(0xff8B5CF6),
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseEmptyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Icon(Icons.shopping_bag_outlined, color: Colors.white24, size: 48),
          const SizedBox(height: 12),
          Text(
            "No purchase history",
            style: AppStyles.customTextStyle(
              size: 14,
              color: Colors.white70,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _purchaseColor(String? plan) {
    switch (plan) {
      case "Best Value Plan":
        return Colors.deepPurpleAccent;
      case "Popular Plan":
        return Colors.blueAccent;
      case "Starter Plan":
      case "Starter Pack":
        return Colors.amber;
      case "Enterprise Pack":
        return Colors.teal;
      default:
        return AppColors.primaryColor;
    }
  }

  String _formatPurchaseDate(String? date) {
    if (date == null) return "-";
    try {
      return DateFormat(
        "dd MMM yyyy, hh:mm a",
      ).format(DateTime.parse(date).toLocal());
    } catch (_) {
      return "-";
    }
  }

  Widget buildConsumptionGuide() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.recContainerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        children: [
          _buildGuideHeader(),
          Divider(height: 1, color: Colors.white.withOpacity(.06)),
          ...List.generate(guides.length, (index) {
            final item = guides[index];
            return Column(
              children: [
                _buildGuideItem(item),
                if (index != guides.length - 1)
                  Divider(height: 1, color: Colors.white.withOpacity(.06)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGuideHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.pinkColor.withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.speaker_notes_outlined,
              color: AppColors.pinkColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Credit Consumption Guide",
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.pinkColor,
                lineSpace: 1.2,
                weight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              AppFunctions.navigateScreen(
                context,
                AppRoutes.creditConsumptionScreen,
              );
            },
            child: Row(
              spacing: 5,
              children: [
                Text(
                  "View All",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: Colors.white,
                    weight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: AppColors.whiteColor,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(ConsumptionGuide item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item.color.withOpacity(.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Credits required per request",
                  style: AppStyles.customTextStyle(
                    size: 11,
                    color: Colors.white54,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: item.color.withOpacity(.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${item.credit} Credits",
              style: AppStyles.customTextStyle(
                size: 12,
                color: item.color,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<ConsumptionGuide> guides = [
    ConsumptionGuide(
      title: "Syllabus Generation",
      credit: 100,
      icon: Icons.menu_book_outlined,
      color: const Color(0xff8B5CF6),
    ),
    ConsumptionGuide(
      title: "Resume Review",
      credit: 50,
      icon: Icons.description_outlined,
      color: const Color(0xff3B82F6),
    ),
    ConsumptionGuide(
      title: "Resume Optimization",
      credit: 30,
      icon: Icons.auto_fix_high_outlined,
      color: const Color(0xff06B6D4),
    ),
    ConsumptionGuide(
      title: "Banner Generation",
      credit: 25,
      icon: Icons.image_outlined,
      color: const Color(0xffF59E0B),
    ),
    ConsumptionGuide(
      title: "Certificate Generation",
      credit: 50,
      icon: Icons.workspace_premium_outlined,
      color: const Color(0xffEC4899),
    ),
  ];
}

class ConsumptionGuide {
  final String title;
  final int credit;
  final IconData icon;
  final Color color;

  ConsumptionGuide({
    required this.title,
    required this.credit,
    required this.icon,
    required this.color,
  });
}
