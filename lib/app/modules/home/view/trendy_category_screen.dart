import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart'
    show DashboardController;
import '../../../core/utils/app_functions.dart' show AppFunctions;
import '../../../data/models/home/category_list_model.dart';
import '../../../routes/app_pages.dart';

class TrendyCategoryScreen extends StatefulWidget {
  const TrendyCategoryScreen({super.key});

  @override
  State<TrendyCategoryScreen> createState() => _TrendyCategoryScreenState();
}

class _TrendyCategoryScreenState extends State<TrendyCategoryScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

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
            "Trendy Categories",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: dashboardController.categoryListModel.categoryList!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
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
            final colors = gradients[index % gradients.length];

            return buildCategoryCard(
              colors: colors,
              categoryName:
                  dashboardController
                      .categoryListModel
                      .categoryList![index]
                      .categoryName ??
                  "",
              categoryData:
                  dashboardController.categoryListModel.categoryList![index],
              categoryCount: dashboardController
                  .categoryListModel
                  .categoryList![index]
                  .count,
            );
          },
        ),
      ),
    );
  }

  Widget buildCategoryCard({
    required String categoryName,
    required CategoryListData? categoryData,
    required int? categoryCount,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: () {
        AppFunctions.navigateScreen(
          context,
          AppRoutes.categoryWiseInternshipScreen,
          arguments: {"categoryData": categoryData!},
        );
      },
      child: Container(
        //width: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(23),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                left: -30,
                child: Opacity(
                  opacity: 0.25,
                  child: Image.asset(
                    AssetImages.halftoneOverlay, // add to AssetImages
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              // Bottom-right halftone overlay
              Positioned(
                bottom: -30,
                right: -30,
                child: Opacity(
                  opacity: 0.25,
                  child: Image.asset(
                    AssetImages.halftoneOverlay,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.last.withValues(alpha: 0.45),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        child: buildAnimatedCount(categoryCount!),
                        // Text(
                        //   textAlign: TextAlign.center,
                        //   categoryCount.toString(),
                        //   style: AppStyles.customTextStyle(
                        //     size: 20,
                        //     color: AppColors.blackColor,
                        //     weight: FontWeight.w700,
                        //   ),
                        // ),
                        // Image.asset(
                        //   AppFunctions.getCategoryImage(service: categoryName),
                        //   height: 40,
                        //   width: 40,
                        //   color: AppColors.blackColor,
                        // ),
                      ),
                      Text(
                        categoryName,
                        textAlign: TextAlign.center,
                        style: AppStyles.customTextStyle(
                          lineSpace: 1.3,
                          size: 13,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                      Visibility(
                        visible: categoryCount != 0,
                        child: Text(
                          "${categoryCount.toString()} Internship Available",
                          style: AppStyles.customTextStyle(
                            size: 10,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
                size: 20,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
    );
  }
}
