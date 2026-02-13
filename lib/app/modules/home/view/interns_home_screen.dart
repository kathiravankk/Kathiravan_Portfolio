import 'package:carousel_slider_plus/carousel_options.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/internship_card.dart';
import 'package:internsharks/app/data/models/home/recommand_internship_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/home/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/widgets/home_drawer.dart';

class InternsHomeScreen extends StatefulWidget {
  const InternsHomeScreen({super.key});

  @override
  State<InternsHomeScreen> createState() => _InternsHomeScreenState();
}

class _InternsHomeScreenState extends State<InternsHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int activeIndex = 0;

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    print("Current Page: $index");
  }

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final ProfileController profileController =
  Get.find<ProfileController>();

  String? studentName;
  String? studentId;

  @override
  void initState() {
    super.initState();
    getHomeScreenData();
  }

  Future<void> getHomeScreenData() async {
    // final prefs = await SharedPreferences.getInstance();
    // studentName = prefs.getString('student_name');
    studentName = await LocalStorageService.getStudentName();
    studentId = await LocalStorageService.getStudentId();
    await dashboardController.getCategoryListData();
    await dashboardController.getRecommentedInternship();
    await profileController.getProfileData(studentId: studentId!);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => profileController.profileDataLoading
          ? Center(
              child: CupertinoActivityIndicator(
                color: AppColors.secondaryColor,
              ),
            )
          : Scaffold(
              key: _scaffoldKey,
              drawer: HomeDrawer(),
              backgroundColor: AppColors.blackColor,
              appBar: AppBar(
                backgroundColor: AppColors.transparentColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.menu_sharp,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                title: Text(
                  "Welcome ${studentName ?? "User"}!",
                  style: AppStyles.customTextStyle(
                    size: 18,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w600,
                  ),
                ),
                actions: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.appBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_active_outlined,
                          color: AppColors.whiteColor,
                          size: 25,
                        ),
                      ),
                      Positioned(
                        right: 7,
                        top: 5,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF1493),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 10),
                ],
              ),
              body:
                  dashboardController.getCategoryLoading ||
                      dashboardController.recommentedInternshipLoading
                  ? Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.secondaryColor,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            _buildSearchBar(),
                            const SizedBox(height: 10),
                            _buildBannerCarousel(),
                            _buildSectionHeader(
                              title: "Recommented Internship",
                              onTabPage: () {
                                AppFunctions.navigateScreen(
                                  context,
                                  AppRoutes.recommentedInternshipScreen,
                                );
                              },
                            ),
                            _buildRecommendedInternships(),
                            _buildSectionHeader(
                              title: "Trendy Categories",
                              onTabPage: () {
                                AppFunctions.navigateScreen(
                                  context,
                                  AppRoutes.trendyCategoryScreen,
                                );
                              },
                            ),
                            _buildTrendyCategories(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.lightWhiteCont,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        spacing: 15,
        children: [
          SizedBox(),
          Icon(CupertinoIcons.search, color: AppColors.lightHintText, size: 25),
          Expanded(
            child: TextField(
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.blackColor,
                weight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.lightHintText,
                  weight: FontWeight.w400,
                ),
                border: InputBorder.none,
              ),
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
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 1,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
          items: images.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
            );
          }).toList(),
        ),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: images.length,
          effect: ExpandingDotsEffect(
            activeDotColor: AppColors.primaryColor,
            dotColor: AppColors.lightWhiteCont,
            dotHeight: 5,
            dotWidth: 5,
          ),
        ),
      ],
    );
  }

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
                  duration: recommentedList.internshipDuration ?? "",
                  applyFunc: () {},
                  viewFunc: () {
                    AppFunctions.navigateScreen(
                      context,
                      AppRoutes.internshipDetailScreen,
                      arguments: {"internshipId": recommentedList.sId},
                    );
                  },
                  eligibility: recommentedList.eligibilityCriteria ?? "",
                  qualification: recommentedList.studentQualification ?? "",
                  stipendRupees: recommentedList.internshipStipend ?? "",
                  description: recommentedList.internshipDescription ?? "",
                  imageUrl: recommentedList.companyLogo ?? "",
                  internshipMode: recommentedList.internshipMode ?? "",
                  role: recommentedList.title ?? "",
                  postedDate: recommentedList.createdAt ?? "",
                  skillList: recommentedList.requiredSkills ?? [],
                  isApplied: recommentedList.applied ?? false,
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
    return SizedBox(
      height: 120,
      child:
          dashboardController.categoryListModel.categoryList != null ||
              dashboardController.categoryListModel.categoryList!.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  dashboardController.categoryListModel.categoryList!.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  AppFunctions.navigateScreen(
                    context,
                    AppRoutes.categoryWiseInternshipScreen,
                    arguments: {
                      "categoryData": dashboardController
                          .categoryListModel
                          .categoryList![index],
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  width: 140,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.selectedContColor,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(5),
                        child: Image.asset(
                          AppFunctions.getCategoryImage(
                            service:
                                dashboardController
                                    .categoryListModel
                                    .categoryList![index]
                                    .categoryName ??
                                "",
                          ),
                          height: 35,
                          width: 35,
                          color: AppColors.blackColor,
                        ),
                      ),
                      Text(
                        dashboardController
                                .categoryListModel
                                .categoryList![index]
                                .categoryName ??
                            "",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          color: AppColors.secondaryColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  Icon(
                    Icons.file_copy_outlined,
                    size: 30,
                    color: AppColors.secondaryColor,
                  ),
                  Text(
                    "No Data Found..!",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w400,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
