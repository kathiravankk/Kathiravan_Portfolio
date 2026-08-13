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
import '../../../data/models/home/recommand_internship_model.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class SimilarInternshipScreen extends StatefulWidget {
  const SimilarInternshipScreen({super.key});

  @override
  State<SimilarInternshipScreen> createState() =>
      _SimilarInternshipScreenState();
}

class _SimilarInternshipScreenState extends State<SimilarInternshipScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  List<RecommentedData> _allInternships = [];
  List<RecommentedData> _filteredInternships = [];

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _allInternships =
        dashboardController.similarInternshipModel.similarList ?? [];
    _filteredInternships = List.from(_allInternships);
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
          final skills = (job.requiredSkills ?? []).join(' ').toLowerCase();
          final about = (job.internshipDescription ?? '').toLowerCase();
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
                  "Similar Internships",
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
          ],
        ),
        body: Obx(
          () => dashboardController.similarInternshipLoading
              ? AppAlertUtils.customLoader()
              : _allInternships.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header info ───────────────────────────────
                      if (!_isSearchActive) ...[
                        Text(
                          "${_allInternships.length} Similar Internships Found",
                          style: AppStyles.customTextStyle(
                            size: 16,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Explore similar internship opportunities based on your skills.",
                          style: AppStyles.customTextStyle(
                            size: 14,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w300,
                            lineSpace: 1.4
                          ),
                        ),
                      ],

                      // ── Search results status info ──────────────────
                      if (_isSearchActive) ...[
                        _buildSearchResultChip(),
                      ],

                      const SizedBox(height: 4),

                      // ── List of Cards ───────────────────────────────
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
                                  final originalIndex = dashboardController
                                      .similarInternshipModel.similarList!
                                      .indexWhere((j) => j.sId == job.sId);

                                  return InternshipCard(
                                    isCategoryFlow: true,
                                    companyName: job.companyName ?? "",
                                    position: job.noOfPosition ?? 0,
                                    isSaved: job.isSaved ?? false,
                                    duration: job.internshipDuration!
                                                .isNotEmpty &&
                                            job.internshipDuration != null
                                        ? "${job.internshipDuration!} Months"
                                        : "${job.days} Days",
                                    internFees: job.internFees ?? "",
                                    location: job.companyCity ?? "",
                                    saveFunc: () async {
                                      if (originalIndex >= 0) {
                                        await dashboardController
                                            .similarSaveFunc(originalIndex);
                                        setState(() {
                                          job.isSaved = !(job.isSaved ?? false);
                                        });
                                      }
                                    },
                                    viewFunc: () {
                                      AppFunctions.navigateScreen(
                                        context,
                                        AppRoutes.internshipDetailScreen,
                                        arguments: {
                                          "internshipId": job.sId,
                                        },
                                      );
                                    },
                                    eligibility: job.eligibilityCriteria ?? "",
                                    qualification: job.studentQualification!
                                        .join(", "),
                                    stipendRupees: job.internshipStipend ?? "",
                                    description: job.internshipDescription ?? "",
                                    imageUrl: job.companyLogo ?? "",
                                    internshipMode: job.internshipMode ?? "NA",
                                    role: job.roleType ?? "",
                                    postedDate: job.createdAt ?? "",
                                    skillList: job.requiredSkills ?? [],
                                  );
                                },
                              ),
                      ),
                    ],
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
        hintText: 'Search similar internships...',
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 15,
        ),
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
           Icon(CupertinoIcons.search, color: Colors.white70, size: 16),
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
}
