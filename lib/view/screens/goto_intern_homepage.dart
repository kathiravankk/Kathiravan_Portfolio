import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get_core/src/get_main.dart';
import 'package:get_x/get_navigation/src/extension_navigation.dart';import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


import '../pages/others/115.dart';
import '../pages/others/applies_page.dart';
import '../pages/others/recommended_Internships_page.dart';
import '../pages/others/trendy_category_listing_page.dart';
import 'drawer.dart';
import '../pages/others/internship_details_page.dart';

class InternshipHomePage extends StatefulWidget {
  const InternshipHomePage({super.key});

  @override
  State<InternshipHomePage> createState() => _InternshipHomePageState();
}

class _InternshipHomePageState extends State<InternshipHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int activeIndex = 0;

  int _selectedNavIndex = 0;

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    print("Current Page: $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawers(),
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 30),
            _buildAppBar(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),

                    const SizedBox(height: 20),

                    _buildBannerCarousel(),

                    const SizedBox(height: 16),

                    _buildSectionHeader(
                      'Recommended Internship',
                      'See All',
                      context,
                      RecommendedInternshipsPage(),
                    ),

                    const SizedBox(height: 16),

                    _buildRecommendedInternships(),

                    const SizedBox(height: 16),

                    // Trendy Categories Section
                    _buildSectionHeader(
                      'Trendy Categories',
                      'See All',
                      context,
                      TrendyCategoryListingPage(),
                    ),

                    const SizedBox(height: 16),

                    _buildTrendyCategories(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  // App Bar
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          const SizedBox(width: 12),
          const Text(
            'Welcome Vishva!',
            style: AppTextStyles.yellow20Bold
          ),
          const Spacer(),

          const SizedBox(width: 4),
          Stack(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF1493),
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

  // Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            const Icon(Icons.search, color: Colors.grey, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.tune, color: Colors.grey, size: 24),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  // Banner Carousel
  Widget _buildBannerCarousel() {
    List<String> images = [
      "lib/asset/images/banner 1.jpg",
      "lib/asset/images/banner 1.jpg",
      "lib/asset/images/banner 1.jpg",
    ];

    return Column(
      children: [
        // Carousel
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),

        // Dot Indicator BELOW the image
        const SizedBox(height: 8),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: images.length,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.blue,
            dotColor: Colors.grey,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
      ],
    );
  }

  // Section Header
  Widget _buildSectionHeader(
    String title,
    String actionText,
    BuildContext context,
    Widget onTabPage,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:AppTextStyles.white20bold
          ),
          InkWell(
            onTap: () {
              Get.to(() => onTabPage);
            },
            child: Text(
              actionText,
                style: AppTextStyles.yellow18Bold
            ),
          ),
        ],
      ),
    );
  }

  // Recommended Internships - Horizontal Scroll
  Widget _buildRecommendedInternships() {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildInternshipCard(
            postedDate: '2 Days Ago',
            title: index % 2 == 0 ? 'APP DEVELOPER' : 'Web DEVELOPER',
            company: index % 2 == 0 ? 'Agro' : 'HCL',
            location: index % 2 == 0 ? 'Trichy' : 'Chennai',
            duration: index % 2 == 0 ? '3 Month' : '2 Month',
            stipend: '10K',
            education: index % 2 == 0 ? 'B.Sc' : 'B.Tech',
            availability: 'Fresher',
            daysLeft: 12,
          );
        },
      ),
    );
  }

  // Internship Card
  Widget _buildInternshipCard({
    required String postedDate,
    required String title,
    required String company,
    required String location,
    required String duration,
    required String stipend,
    required String education,
    required String availability,
    required int daysLeft,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posted Date
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Text(
              postedDate,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
          const SizedBox(height: 5),

          // Title & Company
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.appBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        company,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          color: AppColors.appBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Image(
                  width: 40,
                  image: AssetImage("lib/asset/images/Ellipse 9.png"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Description
          Text(
            'To connect this element to content from your collection, select the element and click Connect to Data.',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          // Duration & Stipend
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.appYellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Duration : $duration',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  // border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.money, size: 14, color: Colors.black),
                    SizedBox(width: 5),
                    Text(
                      'Stipend : $stipend',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Education & Availability
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Education : ',
                        style: TextStyle(
                          color: AppColors.appBlue,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        education,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Available : ',
                        style: TextStyle(
                          color: AppColors.appBlue,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        availability,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$daysLeft Days Left To Apply',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 5),
              InkWell(
                onTap: () {
                  Get.to(() => InternshipDetailsPage());

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF042e84),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          // const Spacer(),

          // Footer
        ],
      ),
    );
  }

  // Trendy Categories - Horizontal Scroll
  Widget _buildTrendyCategories() {
    final categories = [
      {
        // 'icon': Icons.computer,
        'title': 'IT/Software',
        "image": "lib/asset/images/icons/Vector (4).png",
        'count': '52 Internship Available',
        'color': const Color(0xFF042e84),
      },
      {
        "image": "lib/asset/images/icons/Vector (5).png",
        'title': 'Customer Service',
        'count': '70 Internship Available',
        'color': Colors.white,
      },
      {
        "image": "lib/asset/images/icons/Vector (6).png",
        'title': 'Marketing',
        'count': '40 Internship Available',
        'color': Colors.white,
      },
      {
        "image": "lib/asset/images/icons/Vector (4).png",
        'title': 'Design',
        'count': '35 Internship Available',
        'color': Colors.white,
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () {Get.toNamed(Routes.internshipListPage);

            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: category['color'] as Color,
                borderRadius: BorderRadius.circular(20),
                border: category['color'] == Colors.white
                    ? Border.all(color: Colors.grey[300]!)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: category['color'] == Colors.white
                          ? Colors.grey[100]
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      category['image'] as String, // null -> String ❌
                      // ← CORRECT usage
                      width: 30,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    category['title'] as String,
                    style: TextStyle(
                      color: category['color'] == Colors.white
                          ? Colors.black
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category['count'] as String,
                    style: TextStyle(
                      color: category['color'] == Colors.white
                          ? Colors.grey[600]
                          : Colors.white.withOpacity(0.8),
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
