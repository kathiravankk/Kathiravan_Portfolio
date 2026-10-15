import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/data/models/webinar/webinar_model.dart';
import 'package:internsharks/app/data/providers/webinar_provider.dart';
import 'package:internsharks/app/modules/webinar/controller/webinar_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class InternWebinarScreen extends StatefulWidget {
  final bool showBack;

  const InternWebinarScreen({super.key, this.showBack = false});

  @override
  State<InternWebinarScreen> createState() => InternWebinarScreenState();
}

class InternWebinarScreenState extends State<InternWebinarScreen> {
  late final WebinarController webinarController;
  late final PageController _pageController;
  int _activeCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);

    if (Get.isRegistered<WebinarController>()) {
      webinarController = Get.find<WebinarController>();
    } else {
      webinarController = Get.put(
        WebinarController(WebinarProvider(client: Dio())),
        permanent: true,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      webinarController.refreshData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    await webinarController.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: widget.showBack
            ? AppBar(
                backgroundColor: AppColors.transparentColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.whiteColor,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                centerTitle: true,
                title: Text(
                  "Webinars",
                  style: AppStyles.customTextStyle(
                    size: 18,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: AppColors.appBgColor_2,
            onRefresh: refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 110, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TOP HERO BANNER ("Learn.Connect. Grow.")
                  _buildTopHeroBanner(),

                  const SizedBox(height: 22),

                  // 2. UPCOMING WEBINARS SECTION HEADER
                  _buildUpcomingHeader(),

                  const SizedBox(height: 14),

                  // 3. UPCOMING WEBINARS CAROUSEL
                  _buildUpcomingCarouselSection(),

                  const SizedBox(height: 26),

                  // 4. BROWSE WEBINARS HEADER & SORT DROPDOWN
                  _buildBrowseHeader(),

                  const SizedBox(height: 12),

                  // 5. FILTER CHIPS ROW
                  _buildFilterChipsRow(),

                  const SizedBox(height: 14),

                  // 6. BROWSE WEBINARS VERTICAL LIST
                  _buildBrowseListSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 1. TOP HERO BANNER: "Learn.Connect. Grow." + 3D Illustration
  // -------------------------------------------------------------
  Widget _buildTopHeroBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(18),
      //   gradient: const LinearGradient(
      //     colors: [
      //       Color(0xFF0F2625),
      //       Color(0xFF0A181C),
      //       Color(0xFF061113),
      //     ],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   border: Border.all(
      //     color: AppColors.primaryColor.withValues(alpha: 0.22),
      //     width: 1.2,
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withValues(alpha: 0.35),
      //       blurRadius: 16,
      //       offset: const Offset(0, 6),
      //     ),
      //   ],
      // ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 16, 120, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Learn.Connect.\n",
                        style: AppStyles.customTextStyle(
                          size: 20,
                          weight: FontWeight.w800,
                          color: AppColors.whiteColor,
                          lineSpace: 1.15,
                        ),
                      ),
                      TextSpan(
                        text: "Grow.",
                        style: AppStyles.customTextStyle(
                          size: 20,
                          weight: FontWeight.w800,
                          color: AppColors.secondaryColor,
                          lineSpace: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join expert-led webinars designed to help students build skills, explore careers and stay ahead in the future.",
                  style: AppStyles.customTextStyle(
                    size: 11,
                    weight: FontWeight.w400,
                    color: const Color(0xFFCBD5E1),
                    lineSpace: 1.35,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 4,
            child: SizedBox(
              width: 125,
              child: Image.asset(
                AssetImages.webinarHeroBanner,
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 2. UPCOMING WEBINARS SECTION HEADER
  // -------------------------------------------------------------
  Widget _buildUpcomingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Upcoming Webinars",
            style: AppStyles.customTextStyle(
              size: 16,
              weight: FontWeight.w700,
              color: AppColors.secondaryColor,
            ),
          ),
          InkWell(
            onTap: () {
              // Switch to "Upcoming" filter tab in Browse section
              webinarController.changeFilter(1);
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                children: [
                  Text(
                    "View All",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      weight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 3. UPCOMING WEBINARS CAROUSEL SECTION
  // -------------------------------------------------------------
  Widget _buildUpcomingCarouselSection() {
    return Obx(() {
      if (webinarController.upcomingLoading) {
        return  SizedBox(
          height: 380,
          child: AppAlertUtils.customLoader()
          //Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
        );
      }

      final webinars = webinarController.upcomingWebinars;
      if (webinars.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: CustomEmptyWidget(),
        );
      }

      return Column(
        children: [
          SizedBox(
            height: 385,
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
              itemCount: webinars.length,
              onPageChanged: (index) {
                setState(() {
                  _activeCardIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final webinar = webinars[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16 : 8,
                    right: index == webinars.length - 1 ? 16 : 8,
                  ),
                  child: _buildUpcomingCard(webinar),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          _buildPageIndicators(webinars.length),
        ],
      );
    });
  }

  // -------------------------------------------------------------
  // SINGLE UPCOMING WEBINAR CARD
  // -------------------------------------------------------------
  Widget _buildUpcomingCard(WebinarData webinar) {
    final bool isPaid = (webinar.webinarType ?? '').toLowerCase() == 'paid' ||
        (webinar.amount != null && webinar.amount! > 0);

    final String formattedDate = _formatWebinarDate(webinar.webinarDate);
    final String formattedTime = _formatWebinarTime(
      webinar.startTime,
      webinar.endTime,
      webinar.timezone,
    );
    final String speakerText = _formatSpeaker(webinar.speaker);

    final int regCount = webinar.registrationCount ?? 0;
    final int maxSeats = (webinar.maximumSeats != null && webinar.maximumSeats! > 0)
        ? webinar.maximumSeats!
        : 100;
    final double seatRatio = (regCount / maxSeats).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131D24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BANNER IMAGE WITH BADGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  color: const Color(0xFF1B2830),
                  child: webinar.bannerImage != null &&
                          webinar.bannerImage!.isNotEmpty
                      ? Image.network(
                          webinar.bannerImage!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: const Color(0xFF1B2830),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryColor,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImageFallback(),
                        )
                      : _buildImageFallback(),
                ),

                // BADGE: "PAID" (purple) or "FREE" (emerald green)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isPaid
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      isPaid ? "PAID" : "FREE",
                      style: AppStyles.customTextStyle(
                        size: 9.5,
                        weight: FontWeight.w800,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // TITLE ROW WITH DETAIL CIRCLE BUTTON
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  (webinar.title ?? '').trim().isNotEmpty
                      ? webinar.title!.trim()
                      : "Webinar Session",
                  style: AppStyles.customTextStyle(
                    size: 14.5,
                    weight: FontWeight.w700,
                    color: AppColors.whiteColor,
                    lineSpace: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _showWebinarDetails(webinar),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // DATE ROW
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: Color(0xFF7E8B9B),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  formattedDate,
                  style: AppStyles.customTextStyle(
                    size: 11.5,
                    color: const Color(0xFF94A3B8),
                    weight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // TIME ROW
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 13,
                color: Color(0xFF7E8B9B),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  formattedTime,
                  style: AppStyles.customTextStyle(
                    size: 11.5,
                    color: const Color(0xFF94A3B8),
                    weight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // SPEAKER ROW
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 13,
                color: Color(0xFF7E8B9B),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  speakerText,
                  style: AppStyles.customTextStyle(
                    size: 11.5,
                    color: const Color(0xFF94A3B8),
                    weight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const Spacer(),

          // BOTTOM ROW: SEATS PROGRESS BAR & VIEW DETAILS BUTTON
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Seats Filled + Progress
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$regCount / $maxSeats Seats Filled",
                    style: AppStyles.customTextStyle(
                      size: 10.5,
                      color: const Color(0xFF94A3B8),
                      weight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 120,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22313A),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: seatRatio == 0.0 ? 0.05 : seatRatio,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // View Details Button (and price if paid)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isPaid && (webinar.amount ?? 0) > 0) ...[
                    Text(
                      "₹${webinar.amount}",
                      style: AppStyles.customTextStyle(
                        size: 13,
                        weight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  InkWell(
                    onTap: () => _showWebinarDetails(webinar),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "View Details",
                        style: AppStyles.customTextStyle(
                          size: 11.5,
                          weight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 4. BROWSE WEBINARS HEADER & SORT DROPDOWN
  // -------------------------------------------------------------
  Widget _buildBrowseHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Browse Webinars",
            style: AppStyles.customTextStyle(
              size: 16,
              weight: FontWeight.w700,
              color: AppColors.whiteColor,
            ),
          ),
          Obx(
            () => PopupMenuButton<String>(
              color: const Color(0xFF1B2930),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              onSelected: (sortValue) {
                webinarController.changeSort(sortValue);
              },
              itemBuilder: (context) => [
                _buildSortMenuItem("Latest First"),
                _buildSortMenuItem("Oldest First"),
                _buildSortMenuItem("Price: Low to High"),
                _buildSortMenuItem("Price: High to Low"),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF162228),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      webinarController.selectedSort,
                      style: AppStyles.customTextStyle(
                        size: 11,
                        weight: FontWeight.w500,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 14,
                      color: Color(0xFFCBD5E1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(String text) {
    final bool isSelected = webinarController.selectedSort == text;
    return PopupMenuItem<String>(
      value: text,
      height: 38,
      child: Text(
        text,
        style: AppStyles.customTextStyle(
          size: 12,
          weight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.primaryColor : Colors.white,
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 5. FILTER CHIPS ROW: All Webinars | Upcoming | Free | Paid | Completed
  // -------------------------------------------------------------
  Widget _buildFilterChipsRow() {
    return Obx(() {
      final selected = webinarController.selectedFilterIndex;
      final filters = webinarController.filterTitles;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(filters.length, (index) {
            final bool isCurrent = selected == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => webinarController.changeFilter(index),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.primaryColor
                        : const Color(0xFF162228),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCurrent
                          ? AppColors.primaryColor
                          : Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    filters[index],
                    style: AppStyles.customTextStyle(
                      size: 11.5,
                      weight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent
                          ? Colors.black
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  // -------------------------------------------------------------
  // 6. BROWSE WEBINARS VERTICAL LIST SECTION
  // -------------------------------------------------------------
  Widget _buildBrowseListSection() {
    return Obx(() {
      if (webinarController.browseLoading) {
        return  Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: AppAlertUtils.customLoader()
          // Center(
          //   child: CircularProgressIndicator(color: AppColors.primaryColor),
          // ),
        );
      }

      final browseList = webinarController.browseList;
      if (browseList.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: CustomEmptyWidget(),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: browseList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final webinar = browseList[index];
          return _buildBrowseCard(webinar);
        },
      );
    });
  }

  // -------------------------------------------------------------
  // SINGLE BROWSE CARD (EXACTLY MATCHING FIGMA SCREENSHOT)
  // -------------------------------------------------------------
  Widget _buildBrowseCard(WebinarData webinar) {
    final bool isPaid = (webinar.webinarType ?? '').toLowerCase() == 'paid' ||
        (webinar.amount != null && webinar.amount! > 0);

    final String formattedDate = _formatWebinarDate(webinar.webinarDate);
    final String formattedTime = _formatTime(webinar.startTime);
    final String dateTimeText = formattedTime.isNotEmpty
        ? "$formattedDate • $formattedTime"
        : formattedDate;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF131D24),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // THUMBNAIL IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 62,
              height: 62,
              color: const Color(0xFF1B2830),
              child: webinar.bannerImage != null && webinar.bannerImage!.isNotEmpty
                  ? Image.network(
                      webinar.bannerImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildSmallFallback(),
                    )
                  : _buildSmallFallback(),
            ),
          ),

          const SizedBox(width: 12),

          // MIDDLE COLUMN (BADGE, TITLE, DATE/TIME, SEATS/PRICE)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // BADGE: "FREE" (green) or "PAID" (amber/gold)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? const Color(0xFFF59E0B).withValues(alpha: 0.18)
                        : const Color(0xFF10B981).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isPaid
                          ? const Color(0xFFF59E0B).withValues(alpha: 0.4)
                          : const Color(0xFF10B981).withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    isPaid ? "PAID" : "FREE",
                    style: AppStyles.customTextStyle(
                      size: 9.5,
                      weight: FontWeight.w800,
                      color: isPaid
                          ? const Color(0xFFFBBF24)
                          : const Color(0xFF34D399),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // TITLE
                Text(
                  (webinar.title ?? '').trim().isNotEmpty
                      ? webinar.title!.trim()
                      : "Webinar Session",
                  style: AppStyles.customTextStyle(
                    size: 13,
                    weight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 3),

                // DATE & TIME
                Text(
                  dateTimeText,
                  style: AppStyles.customTextStyle(
                    size: 11,
                    color: const Color(0xFF94A3B8),
                    weight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 3),

                // SEATS (if free) OR AMOUNT (if paid)
                if (isPaid)
                  Text(
                    "₹${webinar.amount ?? 0}",
                    style: AppStyles.customTextStyle(
                      size: 12.5,
                      weight: FontWeight.w700,
                      color: AppColors.whiteColor,
                    ),
                  )
                else
                  Text(
                    "${webinar.registrationCount ?? 0} / ${webinar.maximumSeats ?? 100} Seats",
                    style: AppStyles.customTextStyle(
                      size: 11,
                      color: const Color(0xFF94A3B8),
                      weight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // "VIEW" OUTLINED BUTTON
          InkWell(
            onTap: () => _showWebinarDetails(webinar),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "View",
                style: AppStyles.customTextStyle(
                  size: 11.5,
                  weight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // SMALL THUMBNAIL FALLBACK
  // -------------------------------------------------------------
  Widget _buildSmallFallback() {
    return Container(
      color: const Color(0xFF1B2830),
      child: const Center(
        child: Icon(
          Icons.video_library_rounded,
          size: 24,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // IMAGE FALLBACK (LARGE)
  // -------------------------------------------------------------
  Widget _buildImageFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B2830), Color(0xFF121B21)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.video_library_rounded,
          size: 36,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // PAGE INDICATOR DOTS
  // -------------------------------------------------------------
  Widget _buildPageIndicators(int count) {
    if (count <= 1) return const SizedBox.shrink();
    final int displayCount = count > 5 ? 5 : count;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(displayCount, (index) {
        final bool isActive = _activeCardIndex % displayCount == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryColor
                : Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  // -------------------------------------------------------------
  // WEBINAR DETAILS NAVIGATION
  // -------------------------------------------------------------
  void _showWebinarDetails(WebinarData webinar) {
    final String id = webinar.sId ?? '';
    if (id.isNotEmpty) {
      Get.toNamed(
        AppRoutes.webinarDetailScreen,
        arguments: id,
      );
    }
  }

  // -------------------------------------------------------------
  // FORMATTING HELPERS
  // -------------------------------------------------------------
  String _formatWebinarDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "Date TBA";
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      return DateFormat("dd MMM yyyy").format(dt);
    } catch (_) {
      return rawDate;
    }
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return "";
    try {
      final clean = timeStr.trim();
      final parts = clean.split(":");
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        final period = hour >= 12 ? "PM" : "AM";
        int displayHour = hour % 12;
        if (displayHour == 0) displayHour = 12;
        final minuteStr = minute.toString().padLeft(2, '0');
        return "$displayHour:$minuteStr $period";
      }
    } catch (_) {}
    return timeStr;
  }

  String _formatWebinarTime(String? start, String? end, String? tz) {
    final s = _formatTime(start);
    final e = _formatTime(end);
    final isIST = tz != null && tz.toLowerCase().contains("kolkata");
    final suffix = isIST ? " (IST)" : (tz != null && tz.isNotEmpty ? " ($tz)" : "");

    if (s.isNotEmpty && e.isNotEmpty) {
      return "$s – $e$suffix";
    } else if (s.isNotEmpty) {
      return "$s$suffix";
    }
    return "Time TBA";
  }

  String _formatSpeaker(SpeakerData? speaker) {
    if (speaker == null) return "Expert Speaker";
    final name = (speaker.name ?? "").trim();
    final desig = (speaker.designation ?? "").trim();
    if (name.isNotEmpty && desig.isNotEmpty) {
      return "$name, $desig";
    } else if (name.isNotEmpty) {
      return name;
    } else if (desig.isNotEmpty) {
      return desig;
    }
    return "Expert Speaker";
  }
}
