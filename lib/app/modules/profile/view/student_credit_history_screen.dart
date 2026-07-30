import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart' show AppStyles;
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';

class StudentCreditsHistoryScreen extends StatefulWidget {
  const StudentCreditsHistoryScreen({super.key});

  @override
  State<StudentCreditsHistoryScreen> createState() =>
      _StudentCreditsHistoryScreenState();
}

class _StudentCreditsHistoryScreenState
    extends State<StudentCreditsHistoryScreen> {
  final ProfileController profileController =
  Get.find<ProfileController>();

  String? studentId = "";
  int? creditBalance = 0;
  int page = 1;

  @override
  void initState() {
    super.initState();
    creditBalance = Get.arguments["creditBalance"] ?? 0;
    getTransactionData();
  }

  Future<void> getTransactionData() async {
    page = 1;

    try {
      studentId = await LocalStorageService.getStudentId();

      await profileController.getCreditHistory(
        studentId: studentId!,
        page: page,
        isLoadMore: false,
      );

      if (profileController.getResponseCode() != 200 &&
          profileController.getResponseCode() != 201) {
        AppFunctions.apiErrorHandling(
          profileController.getResponseCode(),
          "Something went wrong, try again later!",
        );
      }
    } catch (err, stackTrace) {
      debugPrint(err.toString());
      debugPrint(stackTrace.toString());

      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        "Something went wrong, try again later!",
      );
    }
  }
  Future<void> _loadMore() async {
    if (profileController.creditHistoryLoadingMore ||
        !profileController.creditHistoryHasMore) {
      return;
    }

    page++;

    try {
      await profileController.getCreditHistory(
        studentId: studentId!,
        page: page,
        isLoadMore: true,
      );
    } catch (_) {
      page--;
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
            child: Icon(
              Icons.arrow_back,
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
        body: Obx(
              () => profileController.creditHistoryLoading
              ? AppAlertUtils.customLoader()
              : profileController.creditHistoryList.isNotEmpty
              ? RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: AppColors.appBgColor_2,
            onRefresh: getTransactionData,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                children: [
                  _buildBalanceCard(creditBalance ?? 0),
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    "Credits History",
                    profileController.creditModel.pagination == null
                        ? null
                        : "${profileController.creditHistoryList.length} of ${profileController.creditModel.pagination?.total ?? 0}",
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: profileController.creditHistoryList.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {

                        if (index ==
                            profileController.creditHistoryList.length) {
                          return Visibility(
                              visible: !(profileController.creditHistoryList.length == profileController.creditModel.pagination?.total),
                              child: _buildLoadMoreFooter());
                        }

                        return _buildTransactionCard(
                          profileController.creditHistoryList[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
              : _buildEmptyState(),
        ),
      ),
    );
  }

  Widget _buildLoadMoreFooter() {
    if (!profileController.creditHistoryHasMore) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: profileController.creditHistoryLoadingMore
            ? const CupertinoActivityIndicator()
            : InkWell(
          onTap: _loadMore,
          child: Text(
            "Load More",
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.primaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
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
              color: AppColors.secondaryColor,
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

  Widget _buildBalanceCard(int credit) {
    // final balance = credit?.balance ?? 0;
    // final totalUsed = credit?.totalUsed ?? 0;

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
                  "$credit",
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
