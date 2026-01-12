import 'package:flutter/material.dart';
import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';

class TrendyCategoryListingPage extends StatefulWidget {
  const TrendyCategoryListingPage({super.key});

  @override
  State<TrendyCategoryListingPage> createState() =>
      _TrendyCategoryListingPageState();
}

class _TrendyCategoryListingPageState extends State<TrendyCategoryListingPage> {
  @override
  final List<Map<String, dynamic>> categories = [
    {
      "image": "lib/asset/images/icons/Vector (4).png",
      "title": "IT / Software",
      "count": "52 Internships Available",
      "color": Colors.white,
    },
    {
      "image": "lib/asset/images/icons/Vector (5).png",
      "title": "Customer Service",
      "count": "70 Internships Available",
      "color": Colors.white,
    },
    {
      "image": "lib/asset/images/icons/Vector (6).png",
      "title": "Marketing",
      "count": "40 Internships Available",
      "color": Colors.white,
    },
    {
      "image": "lib/asset/images/icons/Vector (4).png",
      "title": "Design",
      "count": "35 Internships Available",
      "color": Colors.white,
    },
    {
      "image": "lib/asset/images/icons/Vector (4).png",
      "title": "Business",
      "count": "25 Internships Available",
      "color": Colors.white,
    },
    {
      "image": "lib/asset/images/icons/Vector (6).png",
      "title": "Sales",
      "count": "68 Internships Available",
      "color": Colors.white,
    },
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/asset/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),


                Text("Trendy Categories", style: AppTextStyles.white24Bold),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(child: _buildTrendyCategoriesGrid()),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------
  Widget _buildTrendyCategoriesGrid() {


    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 Columns
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2, // perfect height
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              // ICON BOX
              Container(
                padding: const EdgeInsets.all(8),
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

              const SizedBox(height: 8),

              // TITLE
              Text(
                category['title'] as String,
                style: TextStyle(
                  color: AppColors.appBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // const SizedBox(height: 4),

              // COUNT
              Text(
                category['count'] as String,
                textAlign: TextAlign.center,
                style:AppTextStyles.black14bold
              ),
            ],
          ),
        );
      },
    );
  }
}
