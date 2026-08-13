import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/internship_card.dart';
import 'package:internsharks/app/data/models/home/category_list_model.dart';
import 'package:internsharks/app/data/models/home/category_wise_internship_model.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class CategoryWiseInternshipScreen extends StatefulWidget {
  const CategoryWiseInternshipScreen({super.key});

  @override
  State<CategoryWiseInternshipScreen> createState() =>
      _CategoryWiseInternshipScreenState();
}

class _CategoryWiseInternshipScreenState
    extends State<CategoryWiseInternshipScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final ProfileController profileController = Get.find<ProfileController>();

  CategoryListData? categoryData;
  List<InternshipData> _allInternships = [];
  List<InternshipData> _filteredInternships = [];

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    categoryData = Get.arguments["categoryData"];
    getInternshipData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredInternships = List.from(_allInternships);
      } else {
        _filteredInternships = _allInternships.where((job) {
          final company = (job.companyName ?? '').toLowerCase();
          final role = (job.roleType ?? '').toLowerCase();
          final city = (job.companyCity ?? '').toLowerCase();
          final mode = (job.internshipMode ?? '').toLowerCase();
          final skills =
              (job.requiredSkills ?? []).join(' ').toLowerCase();
          final about = (job.aboutInternship ?? '').toLowerCase();
          return company.contains(query) ||
              role.contains(query) ||
              city.contains(query) ||
              mode.contains(query) ||
              skills.contains(query) ||
              about.contains(query);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _isSearchActive = false;
      _filteredInternships = List.from(_allInternships);
    });
  }

  Future<void> getInternshipData() async {
    try {
      await dashboardController.getCategoryInternshipData(
        categoryId: categoryData!.categoryId ?? "",
      );
      if (dashboardController.getResponseCode() == 200 ||
          dashboardController.getResponseCode() == 201) {
        setState(() {
          _allInternships =
              dashboardController.categoryInternshipModel.jobs ?? [];
          _filteredInternships = List.from(_allInternships);
          // Re-apply any active search
          if (_searchController.text.trim().isNotEmpty) {
            _onSearchChanged();
          }
        });
      } else {
        AppFunctions.apiErrorHandling(
          dashboardController.getResponseCode(),
          dashboardController.categoryInternshipModel.message ??
              "Something went wrong!, try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        dashboardController.getResponseCode(),
        dashboardController.categoryInternshipModel.message ??
            "Something went wrong!, try again later!",
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
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: _isSearchActive
              ? _buildSearchField()
              : Text(
                  categoryData!.categoryName ?? "",
                  style: AppStyles.customTextStyle(
                    size: 18,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w600,
                  ),
                ),
          actions: [
            _isSearchActive
                ? IconButton(
                    icon: const Icon(Icons.close, color: AppColors.whiteColor),
                    onPressed: _clearSearch,
                  )
                : IconButton(
                    icon:  Icon(CupertinoIcons.search, color: AppColors.whiteColor, size: 25),
                    onPressed: () {
                      setState(() => _isSearchActive = true);
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        () => _searchFocusNode.requestFocus(),
                      );
                    },
                  ),
            const SizedBox(width: 10,)
          ],
        ),
        body: Obx(
          () => dashboardController.categoryInternshipLoading
              ? AppAlertUtils.customLoader()
              : dashboardController.categoryInternshipModel.jobs!.isNotEmpty
              ? RefreshIndicator(
                  color: AppColors.primaryColor,
                  backgroundColor: AppColors.appBgColor_2,
                  onRefresh: () async {
                    await getInternshipData();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header ──────────────────────────────────────
                        if (!_isSearchActive) ...[
                          Text(
                            "${categoryData!.count}+ Internships Available",
                            style: AppStyles.customTextStyle(
                              size: 16,
                              color: AppColors.whiteColor,
                              weight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Explore opportunities in ${categoryData!.categoryName}.",
                            style: AppStyles.customTextStyle(
                              size: 14,
                              color: AppColors.whiteColor,
                              weight: FontWeight.w300,
                            ),
                          ),
                        ],

                        // ── Search result count ──────────────────────────
                        if (_isSearchActive) ...[
                          _buildSearchResultChip(),
                        ],

                        const SizedBox(height: 4),

                        // ── Internship List or Empty State ───────────────
                        Expanded(
                          child: _filteredInternships.isEmpty
                              ? _buildNoResultsWidget()
                              : ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 15),
                                  itemCount: _filteredInternships.length,
                                  itemBuilder: (context, index) {
                                    final job = _filteredInternships[index];
                                    // Find original index for save function
                                    final originalIndex =
                                        dashboardController
                                            .categoryInternshipModel
                                            .jobs!
                                            .indexWhere(
                                                (j) => j.sId == job.sId);
                                    return InternshipCard(
                                      isCategoryFlow: true,
                                      viewFunc: () {
                                        AppFunctions.navigateScreen(
                                          context,
                                          AppRoutes.internshipDetailScreen,
                                          arguments: {
                                            "internshipId": job.sId,
                                          },
                                        );
                                      },
                                      saveFunc: () async {
                                        if (originalIndex >= 0) {
                                          dashboardController
                                              .internshipSaveFunc(
                                                  originalIndex);
                                        }
                                      },
                                      isSaved: job.isSaved ?? false,
                                      position: job.noOfPosition ?? 0,
                                      postedDate: job.createdAt!,
                                      role: job.roleType ?? "",
                                      companyName: job.companyName ?? "",
                                      internshipMode:
                                          job.internshipMode ?? "NA",
                                      imageUrl: job.companyLogo ?? "",
                                      description: job.aboutInternship ?? "",
                                      duration: job.internshipDuration
                                                  ?.isNotEmpty ==
                                              true
                                          ? "${job.internshipDuration!} Months"
                                          : "${job.days} Days",
                                      stipendRupees:
                                          job.internshipStipend ?? "NA",
                                      qualification: job
                                          .studentQualification!
                                          .join(", "),
                                      eligibility:
                                          job.requiredSkills!.join(","),
                                      skillList: job.requiredSkills ?? [],
                                      internFees: job.fee ?? 'NA',
                                      location: job.companyCity ?? "NA",
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                )
              : CustomEmptyWidget(),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      autofocus: true,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Search by role, company, city...',
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 15),
        border: InputBorder.none,
        isDense: true,
      ),
    );
  }

  Widget _buildSearchResultChip() {
    final query = _searchController.text.trim();
    final count = _filteredInternships.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search, color: Colors.white70, size: 16),
          const SizedBox(width: 6),
          Text(
            count == 0
                ? 'No results for "$query"'
                : '$count result${count == 1 ? '' : 's'} for "$query"',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 70,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No internships found',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different keyword',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: _clearSearch,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'Clear Search',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addToSaved({required String jobId}) async {
    await profileController.addSavedJobsData(jobId: jobId);
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message: profileController.savedJobModel.message ??
            "Internship added to your saved posts!",
      );
      await getInternshipData();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.savedJobModel.message ??
            "Something went wrong!, Please try again later",
      );
    }
  }

  Future<void> removeToSaved({required String jobId}) async {
    await profileController.removeSavedJobsData(jobId: jobId);
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message: profileController.savedJobModel.message ??
            "Internship removed from your saved posts!",
      );
      await getInternshipData();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.savedJobModel.message ??
            "Something went wrong!, Please try again later",
      );
    }
  }
}
