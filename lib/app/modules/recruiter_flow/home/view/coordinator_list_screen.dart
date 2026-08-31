import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/coordinator_data_list_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';

class CoordinatorListScreen extends StatefulWidget {
  const CoordinatorListScreen({super.key});

  @override
  State<CoordinatorListScreen> createState() => _CoordinatorListScreenState();
}

class _CoordinatorListScreenState extends State<CoordinatorListScreen> {
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    try {
      await homeController.getCoordinatorList();
      if (homeController.getResponseCode() != 200 &&
          homeController.getResponseCode() != 201) {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, try again later!",
        );
      }
    } catch (_) {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, try again later!",
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (homeController.getCoordinatorLoadingMore ||
        !homeController.coordinatorHasMore) {
      return;
    }
    try {
      await homeController.getCoordinatorList(
        isLoadMore: true,
        search: homeController.coordinatorSearchController.text.trim(),
      );
    } catch (_) {}
  }

  void _showDeleteConfirmationDialog(CoordinatorData coordinator) {
    final String coordinatorName =
        coordinator.name != null && coordinator.name!.trim().isNotEmpty
            ? coordinator.name!
            : "this coordinator";

    AppAlertUtils.showAppAlert(
      context: context,
      title: "Delete Coordinator",
      content: "Are you sure you want to delete $coordinatorName?",
      confirmText: "Delete",
      cancelText: "Cancel",
      onConfirm: () async {
        final bool success =
            await homeController.deleteCoordinator(coordinator.id ?? "");
        if (success) {
          AppAlertUtils.showToast(
            message: "Coordinator deleted successfully!",
            isError: false,
          );
        } else {
          AppAlertUtils.showToast(
            message: "Failed to delete coordinator. Please try again.",
            isError: true,
          );
        }
      },
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
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Coordinator Details",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () {
            if (homeController.getCoordinatorLoading) {
              return AppAlertUtils.customLoader();
            }

            return RefreshIndicator(
              color: AppColors.primaryColor,
              backgroundColor: AppColors.appBgColor_2,
              onRefresh: _fetchInitialData,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildSectionHeader(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: homeController.filteredCoordinatorList.isEmpty
                          ? ListView(
                              children: [
                                const SizedBox(height: 60),
                                const CustomEmptyWidget(),
                              ],
                            )
                          : ListView.separated(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 24),
                              itemCount: homeController.filteredCoordinatorList.length + 1,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                if (index ==
                                    homeController
                                        .filteredCoordinatorList.length) {
                                  return _buildLoadMoreFooter();
                                }
                                final coordinator = homeController
                                    .filteredCoordinatorList[index];
                                return _buildCoordinatorCard(coordinator);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.fieldBorderColor,
          width: 1,
        ),
      ),
      child: TextField(
        controller: homeController.coordinatorSearchController,
        onChanged: (value) => homeController.filterCoordinators(value),
        style: AppStyles.customTextStyle(
          size: 14,
          color: AppColors.whiteColor,
          weight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: "Search by name, email, mobile, role...",
          hintStyle: AppStyles.customTextStyle(
            size: 14,
            color: AppColors.greyTextColor,
            weight: FontWeight.w400,
          ),
          prefixIcon: const Icon(
            CupertinoIcons.search,
            color: AppColors.primaryColor,
            size: 23,
          ),
          suffixIcon: Obx(
            () => homeController.coordinatorSearchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.lightText,
                      size: 18,
                    ),
                    onPressed: () => homeController.clearCoordinatorSearch(),
                  )
                : const SizedBox.shrink(),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    final int count = homeController.filteredCoordinatorList.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "All Coordinators",
          style: AppStyles.customTextStyle(
            size: 16,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Text(
            "$count ${count == 1 ? 'Coordinator' : 'Coordinators'}",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.primaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoordinatorCard(CoordinatorData coordinator) {
    final String name = (coordinator.name != null && coordinator.name!.isNotEmpty)
        ? coordinator.name!
        : "Unknown Coordinator";
    final String email = coordinator.email ?? "No email provided";
    final String mobile = coordinator.mobile ?? "No mobile provided";
    final String role = coordinator.role ?? "Coordinator";
    final bool isActive = coordinator.isActive ?? true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.recContainerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.recBorderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Avatar, Name, Role badge & Delete Action Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.15),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : "C",
                    style: AppStyles.customTextStyle(
                      size: 18,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppStyles.customTextStyle(
                        size: 16,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.secondaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            role,
                            style: AppStyles.customTextStyle(
                              size: 11,
                              color: AppColors.secondaryColor,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.correctBg
                                : AppColors.inCorrectBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.correctBorder
                                  : AppColors.inCorrectBorder,
                            ),
                          ),
                          child: Text(
                            isActive ? "Active" : "Inactive",
                            style: AppStyles.customTextStyle(
                              size: 10,
                              color: isActive
                                  ? AppColors.correctText
                                  : AppColors.inCorrectText,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Delete Button
              InkWell(
                onTap: () => _showDeleteConfirmationDialog(coordinator),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.redColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.redColor.withOpacity(0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.redColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(
            color: AppColors.dividerContColor.withOpacity(0.4),
            height: 1,
          ),
          const SizedBox(height: 12),

          // Details: Email & Mobile
          Row(
            children: [
              const Icon(
                Icons.email_outlined,
                size: 16,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  email,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: AppColors.lightColorText,
                    weight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 16,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                mobile,
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.lightColorText,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreFooter() {
    if (!homeController.coordinatorHasMore) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: homeController.getCoordinatorLoadingMore
            ? const CupertinoActivityIndicator(color: AppColors.primaryColor)
            : InkWell(
                onTap: _loadMore,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    "Load More",
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
