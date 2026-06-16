import 'package:carousel_slider_plus/carousel_options.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/category_card_widget.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart'
    show CustomEmptyWidget;
import 'package:internsharks/app/core/widgets/internship_card.dart';
import 'package:internsharks/app/core/widgets/profile_widgets.dart';
import 'package:internsharks/app/data/models/home/all_internship_model.dart';
import 'package:internsharks/app/data/models/home/recommand_internship_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import '../../../core/widgets/home_drawer.dart';

class InternsHomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey; // ADD THIS
  const InternsHomeScreen({super.key, required this.scaffoldKey});

  @override
  State<InternsHomeScreen> createState() => _InternsHomeScreenState();
}

class _InternsHomeScreenState extends State<InternsHomeScreen> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int activeIndex = 0;

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    print("Current Page: $index");
  }

  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final RegisterController registerController = Get.find<RegisterController>();

  final ProfileController profileController = Get.find<ProfileController>();

  String? studentName;
  String? studentId;
  String? creditId = "";
  int? creditBalance;

  @override
  void initState() {
    super.initState();
    getHomeScreenData();
    getCreditData();
  }

  Future<void> getCreditData() async {
    creditId = await LocalStorageService.getStudentCreditId();
    await registerController.getCreditData(creditId: creditId!);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      if (mounted) {
        creditBalance =
            registerController.creditDataModel.creditData?.balance ?? 0;
      }
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Something went wrong!, Try again later",
      );
    }
  }

  Future<void> getHomeScreenData() async {
    // final prefs = await SharedPreferences.getInstance();
    // studentName = prefs.getString('student_name');
    studentName = await LocalStorageService.getStudentName();
    studentId = await LocalStorageService.getStudentId();
    await profileController.getProfileData(studentId: studentId ?? "");
    await dashboardController.getCategoryListData();
    await dashboardController.getRecommentedInternship();
    await dashboardController.getAllInternship(
      companyCity: "",
      companyState: "",
      duration: "",
      internshipMode: "",
      limit: 5,
      page: 1,
      qualification: "",
      roleType: "",
      stipend: "",
      days: "",
    );
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.profileDataModel.message ?? "",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          profileController.profileDataLoading ||
              dashboardController.getCategoryLoading ||
              dashboardController.recommentedInternshipLoading ||
              registerController.creditDataLoading ||
              dashboardController.allInternshipLoading
          ? AppAlertUtils.customLoader()
          : RefreshIndicator(
              color: AppColors.primaryColor,
              backgroundColor: AppColors.appBgColor_2,
              onRefresh: () async {
                await getHomeScreenData();
                await getCreditData();
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AssetImages.appBackgroundImg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Scaffold(
                  // drawer: HomeDrawer(),
                  backgroundColor: AppColors.transparentColor,
                  appBar: AppBar(
                    backgroundColor: AppColors.transparentColor,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(
                        CupertinoIcons.list_bullet,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          widget.scaffoldKey.currentState?.openDrawer(),
                    ),
                    title: Text(
                      "Hi ${profileController.profileDataModel.studentName ?? "User"}!",
                      style: AppStyles.customTextStyle(
                        size: 17,
                        color: AppColors.secondaryColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                    actions: [
                      ProfileWidgets.creditContainer(
                        creditCount: creditBalance ?? 0,
                        viewFunc: () {
                          AppFunctions.navigateScreen(
                            context,
                            AppRoutes.buyCreditsScreen,
                          );
                        },
                      ),

                      const SizedBox(width: 10),
                    ],
                    // actions: [
                    //   Stack(
                    //     children: [
                    //       Container(
                    //         padding: EdgeInsets.all(6),
                    //         decoration: BoxDecoration(
                    //           color: AppColors.appBgColor,
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         child: const Icon(
                    //           Icons.notifications_active_outlined,
                    //           color: AppColors.whiteColor,
                    //           size: 25,
                    //         ),
                    //       ),
                    //       Positioned(
                    //         right: 7,
                    //         top: 5,
                    //         child: Container(
                    //           width: 7,
                    //           height: 7,
                    //           decoration: const BoxDecoration(
                    //             color: Color(0xFFFF1493),
                    //             shape: BoxShape.circle,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //
                    //   SizedBox(width: 10),
                    // ],
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          _buildSearchBar(),
                          const SizedBox(height: 10),
                          _buildBannerCarousel(),
                          dashboardController.recommentedModel.internshipList !=
                                      null &&
                                  dashboardController
                                      .recommentedModel
                                      .internshipList!
                                      .isNotEmpty
                              ? Column(
                                  children: [
                                    _buildSectionHeader(
                                      title: "Recommended Internship",
                                      onTabPage: () {
                                        AppFunctions.navigateScreen(
                                          context,
                                          AppRoutes.recommentedInternshipScreen,
                                        );
                                      },
                                    ),
                                    _buildRecommendedInternships(),
                                  ],
                                )
                              : Column(
                                  children: [
                                    _buildSectionHeader(
                                      title: "Suggested Internships",
                                      onTabPage: () {
                                        AppFunctions.navigateScreen(
                                          context,
                                          AppRoutes.allInternshipScreen,
                                          arguments: {
                                            "screenTitle":
                                                "Suggested Internships",
                                          },
                                        );
                                      },
                                    ),
                                    _buildSuggestedInternships(),
                                  ],
                                ),
                          _buildSectionHeader(
                            title: "Trendy Categories",
                            onTabPage: () {
                              AppFunctions.navigateScreen(
                                context,
                                AppRoutes.trendyCategoryScreen,
                              );
                            },
                          ),
                          dashboardController.categoryListModel.categoryList ==
                                      null ||
                                  dashboardController
                                      .categoryListModel
                                      .categoryList!
                                      .isEmpty
                              ? CustomEmptyWidget()
                              : _buildTrendyCategories(),

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        AppFunctions.navigateScreen(context, AppRoutes.allInternshipScreen);
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.lightWhiteCont,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          spacing: 15,
          children: [
            SizedBox(),
            Icon(
              CupertinoIcons.search,
              color: AppColors.lightHintText,
              size: 25,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tap to search..!",
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.lightHintText,
                      weight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.tune,
                      color: AppColors.lightHintText,
                      size: 25,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    List<String> images = [
      AssetImages.homeScreenBannerImg,
      AssetImages.homeScreenBannerImg,
      AssetImages.homeScreenBannerImg,
    ];

    return Column(
      spacing: 10,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 1,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
          items: images.map((imageUrl) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            bool isActive = activeIndex == entry.key;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 20 : 5,
              height: 5,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryColor
                    : AppColors.lightWhiteCont,
                borderRadius: BorderRadius.circular(8.0),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Widget _buildBannerCarousel() {
  //   List<String> images = [
  //     AssetImages.homeScreenBannerImg,
  //     AssetImages.homeScreenBannerImg,
  //     AssetImages.homeScreenBannerImg,
  //   ];
  //
  //   return Column(
  //     spacing: 10,
  //     children: [
  //       CarouselSlider(
  //         options: CarouselOptions(
  //           height: 150,
  //           autoPlay: true,
  //           autoPlayInterval: Duration(seconds: 3),
  //           autoPlayAnimationDuration: Duration(milliseconds: 800),
  //           viewportFraction: 1,
  //           enlargeCenterPage: false,
  //           onPageChanged: (index, reason) {
  //             setState(() {
  //               activeIndex = index;
  //             });
  //           },
  //         ),
  //         items: images.map((imageUrl) {
  //           return Builder(
  //             builder: (BuildContext context) {
  //               return ClipRRect(
  //                 borderRadius: BorderRadius.circular(25),
  //                 child: Image.asset(
  //                   imageUrl,
  //                   fit: BoxFit.cover,
  //                   width: double.infinity,
  //                 ),
  //               );
  //             },
  //           );
  //         }).toList(),
  //       ),
  //       AnimatedSmoothIndicator(
  //         activeIndex: activeIndex,
  //         count: images.length,
  //         effect: ExpandingDotsEffect(
  //           activeDotColor: AppColors.primaryColor,
  //           dotColor: AppColors.lightWhiteCont,
  //           dotHeight: 5,
  //           dotWidth: 5,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onTabPage,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.customTextStyle(
            size: 16,
            color: AppColors.whiteColor,
            weight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: onTabPage,
          child: Text(
            "See All",
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.secondaryColor,
              weight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedInternships() {
    return SizedBox(
      height: 210,
      child:
          dashboardController.recommentedModel.internshipList != null &&
              dashboardController.recommentedModel.internshipList!.isNotEmpty
          ? ListView.separated(
              separatorBuilder: (context, index) => SizedBox(width: 10),
              scrollDirection: Axis.horizontal,
              itemCount:
                  dashboardController.recommentedModel.internshipList!.length,
              itemBuilder: (context, index) {
                RecommentedData recommentedList =
                    dashboardController.recommentedModel.internshipList![index];
                return InternshipCard(
                  width: 360,
                  companyName: recommentedList.companyName ?? "",
                  position: recommentedList.noOfPosition ?? 0,
                  //duration: recommentedList.internshipDuration ?? "",
                  duration:
                      recommentedList.internshipDuration!.isNotEmpty &&
                          recommentedList.internshipDuration != null
                      ? "${recommentedList.internshipDuration!} Months"
                      : "${recommentedList.days} Days",
                  internFees: recommentedList.internFees ?? "",
                  location: recommentedList.companyCity ?? "",
                  isSaved: recommentedList.isSaved ?? false,
                  // saveFunc: () {
                  //   recommentedList.isSaved!
                  //       ? removeToSaved(jobId: recommentedList.sId!)
                  //       : addToSaved(jobId: recommentedList.sId!);
                  // },
                  saveFunc: () async {
                    await dashboardController.toggleSave(index);
                  },
                  viewFunc: () {
                    AppFunctions.navigateScreen(
                      context,
                      AppRoutes.internshipDetailScreen,
                      arguments: {"internshipId": recommentedList.sId},
                    );
                  },
                  eligibility: recommentedList.eligibilityCriteria ?? "",
                  qualification: recommentedList.studentQualification!.join(
                    ", ",
                  ),
                  stipendRupees: recommentedList.internshipStipend ?? "",
                  description: recommentedList.internshipDescription ?? "",
                  imageUrl: recommentedList.companyLogo ?? "",
                  internshipMode: recommentedList.internshipMode ?? "",
                  role: recommentedList.roleType ?? "",
                  postedDate: recommentedList.createdAt ?? "",
                  skillList: recommentedList.requiredSkills ?? [],
                );
              },
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  Icon(
                    Icons.file_copy_outlined,
                    color: AppColors.secondaryColor,
                    size: 30,
                  ),
                  Text(
                    "No Data Found..!",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      weight: FontWeight.w400,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSuggestedInternships() {
    return SizedBox(
      height: 210,
      child:
          dashboardController.internshipModel.internship != null &&
              dashboardController.internshipModel.internship!.isNotEmpty
          ? ListView.separated(
              separatorBuilder: (context, index) => SizedBox(width: 10),
              scrollDirection: Axis.horizontal,
              itemCount: dashboardController.internshipModel.internship!.length,
              itemBuilder: (context, index) {
                InternshipModel recommentedList =
                    dashboardController.internshipModel.internship![index];
                return InternshipCard(
                  width: 360,
                  viewFunc: () {
                    AppFunctions.navigateScreen(
                      context,
                      AppRoutes.internshipDetailScreen,
                      arguments: {"internshipId": recommentedList.id},
                    );
                  },
                  isSaved: recommentedList.isSaved ?? false,
                  position: recommentedList.noOfPosition ?? 0,
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
                    await dashboardController.searchFilterSaveFunc(
                      recommentedList,
                    );
                    setState(() {});
                  },
                  postedDate: recommentedList.createdAt!,
                  role: recommentedList.roleType ?? '',
                  companyName: recommentedList.companyName ?? '',
                  internshipMode: recommentedList.internshipMode ?? 'NA',
                  imageUrl: recommentedList.companyLogo ?? '',
                  description: recommentedList.internshipDescription ?? '',
                  //duration: item.internshipDuration ?? 'NA',
                  duration:
                      recommentedList.internshipDuration!.isNotEmpty &&
                          recommentedList.internshipDuration != null
                      ? "${recommentedList.internshipDuration!} Months"
                      : "${recommentedList.days} Days",
                  stipendRupees: recommentedList.internshipStipend ?? 'NA',
                  location: recommentedList.companyCity ?? 'NA',
                  internFees: recommentedList.fee ?? 'NA',
                  qualification:
                      recommentedList.studentQualification?.join(', ') ?? 'All',
                  eligibility: recommentedList.eligibilityCriteria ?? 'All',
                  skillList: recommentedList.requiredSkills ?? [],
                );
              },
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  Icon(
                    Icons.file_copy_outlined,
                    color: AppColors.secondaryColor,
                    size: 30,
                  ),
                  Text(
                    "No Data Found..!",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      weight: FontWeight.w400,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTrendyCategories() {
    // 8 gradient presets cycling for dynamic categories
    final List<List<Color>> gradients = [
      [const Color(0xFF1565C0), const Color(0xFF1E88E5)],
      [const Color(0xFF1B5E20), const Color(0xFF43A047)],
      [const Color(0xFF827717), const Color(0xFFAFB42B)],
      [const Color(0xFF4A148C), const Color(0xFF8E24AA)],
      [const Color(0xFFBF360C), const Color(0xFFEF6C00)],
      [const Color(0xFF006064), const Color(0xFF00ACC1)],
      [const Color(0xFF880E4F), const Color(0xFFE91E63)],
      [const Color(0xFF212121), const Color(0xFF546E7A)],
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dashboardController.categoryListModel.categoryList!.length,
        itemBuilder: (context, index) {
          final category =
              dashboardController.categoryListModel.categoryList![index];
          // Cycle through 8 gradients if more than 8 categories
          final colors = gradients[index % gradients.length];

          return CategoryCard(
            colors: colors,
            count: category.count ?? 0,
            categoryName: category.categoryName ?? "",
            onTap: () {
              AppFunctions.navigateScreen(
                context,
                AppRoutes.categoryWiseInternshipScreen,
                arguments: {"categoryData": category},
              );
            },
          );
        },
      ),
    );
  }

  Widget buildAnimatedCount(int count) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: count == 0 ? 1 : count.toDouble()),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value / (count == 0 ? 1 : count)) * 0.2,
          child: Opacity(
            opacity: 0.5 + (value / (count == 0 ? 1 : count)) * 0.5,
            child: Text(
              count == 0 ? "0" : value.toInt().toString(),
              style: AppStyles.customTextStyle(
                size: 25,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
                fontFamily: "Roboto",
              ),
            ),
          ),
        );
      },
    );
  }

  // String _formatNumber(int number) {
  //   return number.toString().replaceAllMapped(
  //     RegExp(r'\B(?=(\d{3})+(?!\d))'),
  //     (match) => ',',
  //   );
  // }

  Future<void> addToSaved({required String jobId}) async {
    await profileController.addSavedJobsData(jobId: jobId);
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
            profileController.savedJobModel.message ??
            "Internship added to your saved posts!",
      );
      await dashboardController.getRecommentedInternship();
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
        message:
            profileController.savedJobModel.message ??
            "Internship removed from your saved posts!",
      );
      await dashboardController.getRecommentedInternship();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.savedJobModel.message ??
            "Something went wrong!, Please try again later",
      );
    }
  }
}
