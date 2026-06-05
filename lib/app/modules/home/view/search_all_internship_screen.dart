import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/filter_bottom_sheet.dart';
import 'package:internsharks/app/core/widgets/internship_card.dart';
import 'package:internsharks/app/data/models/home/all_internship_model.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class SearchAllInternshipScreen extends StatefulWidget {
  const SearchAllInternshipScreen({super.key});

  @override
  State<SearchAllInternshipScreen> createState() =>
      _SearchAllInternshipScreenState();
}

class _SearchAllInternshipScreenState extends State<SearchAllInternshipScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final ProfileController profileController = Get.find<ProfileController>();

  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // ── Pagination ───────────────────────────────────────────────────────────────
  static const int limit = 10;
  int _currentPage = 1;
  int _totalPages = 1;

  /// Accumulated list across all loaded pages
  final List<InternshipModel> internshipList = [];

  /// True only while loading page 2+ (so the full-screen loader is NOT shown)
  bool _isPaginating = false;

  // ── Filter state ─────────────────────────────────────────────────────────────
  String companyState = '';
  String companyCity = '';
  String qualification = '';
  String duration = '';
  String stipend = '';
  String internshipMode = '';

  bool get _hasActiveFilters =>
      companyState.isNotEmpty ||
      companyCity.isNotEmpty ||
      qualification.isNotEmpty ||
      duration.isNotEmpty ||
      stipend.isNotEmpty ||
      internshipMode.isNotEmpty;

  // ── Lifecycle ────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getFilterOption();
    _fetchPage(page: 1, isNewSearch: true);
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Scroll listener ──────────────────────────────────────────────────────────

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= (maxScroll * 0.8)) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    if (_isPaginating) return;
    if (dashboardController.allInternshipLoading) return;
    if (_currentPage >= _totalPages) return;

    _fetchPage(page: _currentPage + 1, isNewSearch: false);
  }

  // ── Data fetching ────────────────────────────────────────────────────────────

  Future<void> getFilterOption() async {
    await profileController.getFilterOption();
    if (profileController.getResponseCode() != 200 &&
        profileController.getResponseCode() != 201) {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        "Something went wrong! try again later!",
      );
    }
  }

  /// [isNewSearch] = true  → clears the list and resets to page 1.
  /// [isNewSearch] = false → appends results to the existing list.
  Future<void> _fetchPage({
    required int page,
    required bool isNewSearch,
  }) async {
    if (isNewSearch) {
      setState(() {
        internshipList.clear();
        _currentPage = 1;
        _totalPages = 1;
      });
    } else {
      if (_isPaginating) return;
      setState(() => _isPaginating = true);
    }

    await dashboardController.getAllInternship(
      companyState: companyState,
      companyCity: companyCity,
      qualification: qualification,
      duration: duration,
      stipend: stipend,
      internshipMode: internshipMode,
      roleType: searchController.text.trim(),
      page: page,
      limit: limit,
    );

    final model = dashboardController.internshipModel;
    final newItems = model.internship ?? [];

    if (!mounted) return;

    setState(() {
      if (isNewSearch) {
        internshipList.assignAll(newItems);
      } else {
        internshipList.addAll(newItems);
      }

      _currentPage = model.page ?? page;
      _totalPages = model.totalPages ?? 1;
      _isPaginating = false;
    });
  }

  /// Called by search submit + filter apply — always resets to page 1
  Future<void> getInternshipData() => _fetchPage(page: 1, isNewSearch: true);

  // ── Filter sheet ─────────────────────────────────────────────────────────────

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparentColor,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => FilterBottomSheet(
          filterOptionModel: profileController.filterModel,
          initialState: companyState,
          initialCity: companyCity,
          initialQualification: qualification,
          initialDuration: duration,
          initialStipend: stipend,
          initialMode: internshipMode,
          onApply:
              ({
                required String companyState,
                required String companyCity,
                required String qualification,
                required String duration,
                required String stipend,
                required String internshipMode,
              }) {
                setState(() {
                  this.companyState = companyState;
                  this.companyCity = companyCity;
                  this.qualification = qualification;
                  this.duration = duration;
                  this.stipend = stipend;
                  this.internshipMode = internshipMode;
                });
                getInternshipData();
              },
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

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
          title: Text(
            'Search Internships',
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 10,
            children: [
              _buildSearchBar(),
              if (_hasActiveFilters) _buildActiveFilterRow(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Body ─────────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    return Obx(() {
      if ((dashboardController.allInternshipLoading &&
              internshipList.isEmpty) ||
          profileController.filterLoading) {
        return AppAlertUtils.customLoader();
      }

      if (internshipList.isEmpty) {
        return const CustomEmptyWidget();
      }

      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: internshipList.length + 1,
        itemBuilder: (context, index) {
          if (index == internshipList.length) {
            return _isPaginating
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                : const SizedBox.shrink();
          }

          final item = internshipList[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InternshipCard(
              viewFunc: () {
                AppFunctions.navigateScreen(
                  context,
                  AppRoutes.internshipDetailScreen,
                  arguments: {"internshipId": item.id},
                );
              },
              isSaved: item.isSaved ?? false,
              position: item.noOfPosition ??0,
              // saveFunc: () =>
              //     dashboardController.searchFilterSaveFunc(index),
              // saveFunc: () async {
              //   final oldValue = item.isSaved ?? false;
              //
              //   setState(() {
              //     item.isSaved = !oldValue;
              //   });
              //
              //   await dashboardController.searchFilterSaveFunc(index);
              //
              //   if (dashboardController.getResponseCode() != 200 &&
              //       dashboardController.getResponseCode() != 201) {
              //     setState(() {
              //       item.isSaved = oldValue;
              //     });
              //   }
              // },
              saveFunc: () async {
                setState(() {});
                await dashboardController.searchFilterSaveFunc(item);
                setState(() {});
              },
              postedDate: item.createdAt!,
              role: item.roleType ?? '',
              companyName: item.companyName ?? '',
              internshipMode: item.internshipMode ?? 'NA',
              imageUrl: item.companyLogo ?? '',
              description: item.internshipDescription ?? '',
              //duration: item.internshipDuration ?? 'NA',
              duration:
                  item.internshipDuration!.isNotEmpty &&
                      item.internshipDuration != null
                  ? "${item.internshipDuration!} Months"
                  : "${item.days} Days",
              stipendRupees: item.internshipStipend ?? 'NA',
              location: item.companyCity ?? 'NA',
              internFees: item.fee ?? 'NA',
              qualification: item.studentQualification?.join(', ') ?? 'All',
              eligibility: item.eligibilityCriteria ?? 'All',
              skillList: item.requiredSkills ?? [],
            ),
          );
        },
      );
    });
  }

  // ── Search Bar ───────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.lightWhiteCont,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          Icon(CupertinoIcons.search, color: AppColors.lightHintText, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              onSubmitted: (_) => getInternshipData(),
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.blackColor,
                weight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Search here..',
                hintStyle: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.lightHintText,
                  weight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: Icon(
                  Icons.tune,
                  color: _hasActiveFilters
                      ? AppColors.primaryColor
                      : AppColors.greyIcon,
                  size: 25,
                ),
                onPressed: _openFilterSheet,
              ),
              if (_hasActiveFilters)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.failTextColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Active Filter Pills ───────────────────────────────────────────────────────

  Widget _buildActiveFilterRow() {
    final Map<String, String> activeFilters = {};
    if (companyState.isNotEmpty) activeFilters['State'] = companyState;
    if (companyCity.isNotEmpty) activeFilters['City'] = companyCity;
    if (qualification.isNotEmpty) activeFilters['Qual'] = qualification;
    if (duration.isNotEmpty) activeFilters['Duration'] = '$duration mo';
    if (stipend.isNotEmpty) {
      activeFilters['Stipend'] = stipend == '1' ? 'Paid' : 'Unpaid';
    }
    if (internshipMode.isNotEmpty) activeFilters['Mode'] = internshipMode;

    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...activeFilters.entries.map(
            (e) => Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.secondaryColor.withOpacity(0.5),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${e.key}: ${e.value}',
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.secondaryColor,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                companyState = '';
                companyCity = '';
                qualification = '';
                duration = '';
                stipend = '';
                internshipMode = '';
              });
              getInternshipData();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.failTextColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.failTextColor.withValues(alpha: 0.4),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.close,
                    size: 12,
                    color: AppColors.failTextColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Clear All',
                    style: AppStyles.customTextStyle(
                      size: 11,
                      color: AppColors.failTextColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
