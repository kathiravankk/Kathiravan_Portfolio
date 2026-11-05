import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/widgets/recruiter_profile_about_tab.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/widgets/recruiter_profile_header.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/widgets/recruiter_profile_placements_tab.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/widgets/recruiter_profile_reviews_tab.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class RecruiterProfileScreen extends StatefulWidget {
  const RecruiterProfileScreen({super.key});

  @override
  State<RecruiterProfileScreen> createState() => _RecruiterProfileScreenState();
}

class _RecruiterProfileScreenState extends State<RecruiterProfileScreen> {
  final RecruiterHomeController profileController =
      Get.find<RecruiterHomeController>();

  int _selectedMainTab = 0; // 0: ABOUT, 1: REVIEWS, 2: PLACEMENT LIST

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfile();
    });
  }

  Future<void> getProfile() async {
    try {
      await profileController.getRecruiterProfile();
      if (profileController.getResponseCode() == 200 ||
          profileController.getResponseCode() == 201) {
        // Success
      } else {
        AppFunctions.apiErrorHandling(
          profileController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final clean = url.trim();
    if (clean.isEmpty) return;
    final uri =
        Uri.tryParse(clean.startsWith("http") ? clean : "https://$clean");
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppAlertUtils.showToast(message: "Couldn't open this link", isError: true);
    }
  }

  Future<void> _openInMaps(String address) async {
    final clean = address.trim();
    if (clean.isEmpty) return;
    final encoded = Uri.encodeComponent(clean);
    final uri =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$encoded");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppAlertUtils.showToast(message: "Couldn't open Maps", isError: true);
    }
  }

  String _formatDate(dynamic raw) {
    if (raw == null) return "—";
    final str = raw.toString().trim();
    if (str.isEmpty) return "—";
    try {
      final dt = DateTime.parse(str);
      return DateFormat("dd MMM yyyy").format(dt);
    } catch (_) {
      return str;
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
        appBar: _buildAppBar(),
        body: Obx(
          () {
            if (profileController.profileLoading) {
              return AppAlertUtils.customLoader();
            }

            final profile = profileController.profileModel;
            final reviews = profile.reviews ?? profile.recruiterData?.reviews ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RecruiterProfileHeaderWidget(profile: profile),
                  RecruiterProfileStatRowWidget(profile: profile),
                  _buildMainTabBar(),
                  if (_selectedMainTab == 0) ...[
                    RecruiterProfileAboutTab(
                      profile: profile,
                      onLaunchUrl: _launchUrl,
                      onOpenMaps: _openInMaps,
                    ),
                  ] else if (_selectedMainTab == 1) ...[
                    RecruiterProfileReviewsTab(
                      reviews: reviews,
                      formatDate: _formatDate,
                    ),
                  ] else ...[
                    RecruiterProfilePlacementsTab(
                      profileController: profileController,
                      onLaunchUrl: _launchUrl,
                      formatDate: _formatDate,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
        "My Profile",
        style: AppStyles.customTextStyle(
          size: 18,
          color: AppColors.secondaryColor,
          weight: FontWeight.w600,
        ),
      ),
      actions: [
        if (_selectedMainTab == 0)
          GestureDetector(
            onTap: () {
              AppFunctions.navigateScreen(
                context,
                AppRoutes.recruiterProfileEditScreen,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.primaryColor),
                color: AppColors.primaryColor.withValues(alpha: 0.15),
              ),
              child: Row(
                spacing: 5,
                children: [
                  const Icon(
                    CupertinoIcons.pencil_outline,
                    color: AppColors.primaryColor,
                    size: 14,
                  ),
                  Text(
                    "Edit Profile",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.primaryColor,
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

  Widget _buildMainTabBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.recContainerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.recBorderColor),
      ),
      child: Row(
        children: [
          _buildMainTabItem(index: 0, title: "ABOUT"),
          _buildMainTabItem(index: 1, title: "REVIEWS"),
          _buildMainTabItem(index: 2, title: "PLACEMENT LIST"),
        ],
      ),
    );
  }

  Widget _buildMainTabItem({required int index, required String title}) {
    final isSelected = _selectedMainTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMainTab = index;
          });
          if (index == 2) {
            if (profileController.interviewList.isEmpty &&
                !profileController.interviewLoading.value) {
              profileController.fetchInterviews();
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: 12,
              color: isSelected ? AppColors.blackColor : AppColors.greyTextColor,
              weight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
