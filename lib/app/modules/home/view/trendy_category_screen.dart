import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
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
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Trendy Categories",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: dashboardController.categoryListModel.categoryList!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) => buildCategoryCard(
          categoryName:
              dashboardController
                  .categoryListModel
                  .categoryList![index]
                  .categoryName ??
              "",
          categoryData:
              dashboardController.categoryListModel.categoryList![index],
          categoryCount:
              dashboardController.categoryListModel.categoryList![index].count,
        ),
      ),
    );
  }

  Widget buildCategoryCard({
    required String categoryName,
    required CategoryListData? categoryData,
    required int? categoryCount,
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
          borderRadius: BorderRadius.circular(30),
          color: AppColors.whiteColor,
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.lightWhiteCont,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                textAlign: TextAlign.center,
                categoryCount.toString(),
                style: AppStyles.customTextStyle(
                  size: 20,
                  color: AppColors.blackColor,
                  weight: FontWeight.w700,
                ),
              ),

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
                size: 12,
                color: AppColors.primaryColor,
                weight: FontWeight.w700,
              ),
            ),
            Visibility(
              visible: categoryCount != 0,
              child: Text(
                "${categoryCount.toString()} Internship Available",
                style: AppStyles.customTextStyle(
                  size: 10,
                  color: AppColors.blackColor,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
