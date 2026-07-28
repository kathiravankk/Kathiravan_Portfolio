import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_payment_history_model.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';

class RecruiterPurchaseHistoryScreen extends StatefulWidget {
  const RecruiterPurchaseHistoryScreen({super.key});

  @override
  State<RecruiterPurchaseHistoryScreen> createState() =>
      _RecruiterPurchaseHistoryScreenState();
}

class _RecruiterPurchaseHistoryScreenState
    extends State<RecruiterPurchaseHistoryScreen> {
  final RecruiterHomeController homeController =
  Get.find<RecruiterHomeController>();

  int page = 1;
  final int limit = 10;

  // null = "All Time". Otherwise 1-12 for month-wise filter.
  // NOTE: this is NOT sent to the backend — the API doesn't support it.
  // It's applied locally in the controller over whatever has been
  // fetched so far via "Load More".
  int? selectedMonth;

  final List<Map<String, dynamic>> monthOptions = const [
    {"label": "All Time", "value": 0},
    {"label": "January", "value": 1},
    {"label": "February", "value": 2},
    {"label": "March", "value": 3},
    {"label": "April", "value": 4},
    {"label": "May", "value": 5},
    {"label": "June", "value": 6},
    {"label": "July", "value": 7},
    {"label": "August", "value": 8},
    {"label": "September", "value": 9},
    {"label": "October", "value": 10},
    {"label": "November", "value": 11},
    {"label": "December", "value": 12},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitial();
    });
  }

  Future<void> _fetchInitial() async {
    page = 1;
    try {
      await homeController.getPaymentHistoryData(
        limit: limit,
        page: page,
        month: selectedMonth,
        isLoadMore: false,
      );
    } catch (err, stackTrace) {
      debugPrint("getPaymentHistory error: $err");
      debugPrint(stackTrace.toString());
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, try again later!",
      );
    }
  }

  Future<void> _loadMore() async {
    if (homeController.paymentHistoryLoadingMore ||
        !homeController.paymentHistoryHasMore) {
      return;
    }
    page++;
    try {
      await homeController.getPaymentHistoryData(
        limit: limit,
        page: page,
        month: selectedMonth,
        isLoadMore: true,
      );
    } catch (err, stackTrace) {
      page--; // revert bump so retry re-requests the same page
      debugPrint("getPaymentHistory loadMore error: $err");
      debugPrint(stackTrace.toString());
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, try again later!",
      );
    }
  }

  // void _onMonthSelected(dynamic value) {
  //   setState(() => selectedMonth = value);
  //   // Local-only filter — no API call, just re-filter what's loaded.
  //   homeController.filterPaymentHistoryByMonth(value);
  // }
  void _onMonthSelected(dynamic value) {
    setState(() {
      selectedMonth = value == 0 ? null : value;
    });

    homeController.filterPaymentHistoryByMonth(
      value == 0 ? null : value,
    );
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
            "Purchase History",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
        ),
        body: Obx(
              () => homeController.paymentHistoryLoading
              ? AppAlertUtils.customLoader()
              : Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildSummaryCard(),
                const SizedBox(height: 16),
                Expanded(
                  child: homeController.paymentHistoryList.isNotEmpty
                      ? RefreshIndicator(
                    backgroundColor: AppColors.appBgColor_2,
                    color: AppColors.primaryColor,
                    onRefresh: _fetchInitial,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 12),
                      itemCount: homeController
                          .paymentHistoryList.length +
                          1,
                      separatorBuilder: (_, __) => Divider(
                        color: AppColors.whiteColor
                            .withValues(alpha: 0.08),
                        height: 24,
                      ),
                      itemBuilder: (context, index) {
                        if (index ==
                            homeController
                                .paymentHistoryList.length) {
                          return _buildLoadMoreFooter();
                        }
                        final item = homeController
                            .paymentHistoryList[index];
                        return _buildPaymentTile(item);
                      },
                    ),
                  )
                      : const CustomEmptyWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreFooter() {
    if (!homeController.paymentHistoryHasMore) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: homeController.paymentHistoryLoadingMore
            ? CupertinoActivityIndicator(color: AppColors.secondaryColor)
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

  Widget _buildSummaryCard() {
    final currentLabel = monthOptions.firstWhere(
            (m) => m["value"] == selectedMonth,
        orElse: () => monthOptions.first)["label"] as String;

    return Container(
      padding: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.syllabusContBorder),
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(AssetImages.purchaseIcon),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Purchase Credits",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${_totalCredits()}",
                  style: AppStyles.customTextStyle(
                    size: 26,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          _buildMonthDropdown(currentLabel),
        ],
      ),
    );
  }

  int _totalCredits() {
    return homeController.paymentHistoryList
        .where((e) => e.status == "SUCCESS")
        .fold<int>(0, (sum, e) => sum + (e.creditsAdded ?? 0));
  }

  Widget _buildMonthDropdown(String currentLabel) {
    return PopupMenuButton<dynamic>(
      color: AppColors.fieldBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: _onMonthSelected,
      itemBuilder: (context) => monthOptions
          .map((m) => PopupMenuItem(
        value: m["value"],
        child: Text(
          m["label"] as String,
          style: AppStyles.customTextStyle(
            size: 14,
            color: AppColors.whiteColor,
            weight: FontWeight.w500,
          ),
        ),
      ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.syllabusContBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentLabel,
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.whiteColor,
                weight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down,
                color: AppColors.primaryColor, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTile(PaymentHisData item) {
    final statusInfo = _statusInfo(item.status);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: _planColor(item.planName).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.shopping_bag_rounded,
              color: _planColor(item.planName), size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                item.planName ?? "Custom Plan",
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              Text(
                "${item.creditsAdded ?? 0} Credits",
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.whiteColor.withValues(alpha: 0.6),
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "\u20b9${item.amount ?? 0}",
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            _formatDate(item.createdAt),
            style: AppStyles.customTextStyle(
              size: 11,
              color: AppColors.whiteColor.withValues(alpha: 0.7),
              weight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusInfo.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(statusInfo.icon, color: statusInfo.color, size: 12),
                const SizedBox(width: 4),
                Text(
                  statusInfo.label,
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: statusInfo.color,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return "-";
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return "${DateFormat('dd MMM yyyy').format(date)}\n\n"
          "${DateFormat('hh:mm a').format(date)}";
    } catch (_) {
      return "-";
    }
  }

  Color _planColor(String? planName) {
    switch (planName) {
      case "Best Value Plan":
        return const Color(0xFF9B6BFF);
      case "Popular Plan":
        return const Color(0xFF4A90E2);
      case "Starter Pack":
      case "Starter Plan":
        return const Color(0xFFE0A030);
      case "Enterprise Pack":
        return const Color(0xFF20B2AA);
      default:
        return const Color(0xFF20B2AA);
    }
  }

  _StatusInfo _statusInfo(String? status) {
    switch (status) {
      case "SUCCESS":
        return _StatusInfo("Success", Colors.greenAccent, Icons.check);
      case "PENDING":
        return _StatusInfo("Pending", Colors.orangeAccent, Icons.schedule);
      case "FAILED":
      case "CANCELLED":
        return _StatusInfo("Failed", Colors.redAccent, Icons.close);
      default:
        return _StatusInfo(status ?? "-", Colors.grey, Icons.info_outline);
    }
  }
}

class _StatusInfo {
  final String label;
  final Color color;
  final IconData icon;
  _StatusInfo(this.label, this.color, this.icon);
}