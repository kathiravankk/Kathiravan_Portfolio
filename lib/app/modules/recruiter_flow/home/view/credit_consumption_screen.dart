import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

class CreditConsumptionScreen extends StatefulWidget {
  const CreditConsumptionScreen({super.key});

  @override
  State<CreditConsumptionScreen> createState() => _CreditConsumptionScreenState();
}

class _CreditConsumptionScreenState extends State<CreditConsumptionScreen> {
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
          leadingWidth: 54,
          leading: IconButton(
            splashRadius: 22,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Credit Consumption Guide",
            style: AppStyles.customTextStyle(
              size: 20,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),
              Text(
                "Feature Breakdown",
                style: AppStyles.customTextStyle(
                  size: 16,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureList(),
              const SizedBox(height: 18),
              _buildBottomInfo(),
            ],
          ),
        ),
      )
    );
  }
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            const Color(0xff102326),
            const Color(0xff0B1D20),
          ],
        ),
        border: Border.all(
          color: Colors.green.withOpacity(.15),
        ),
      ),
      child: Column(
        spacing:5,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.secondaryColor,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(5),
                child:Image.asset(AssetImages.creditsIconNew, height: 35, width: 35,),
              ),
              const SizedBox(width: 10),
              Text(
                "Understand How Credits Work",
                style: AppStyles.customTextStyle(
                  size: 18,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            "Each action in the platform consumes a certain number of credits. Use credits wisely to get the most out of premium features.",
            style: AppStyles.customTextStyle(
              size: 12,
              lineSpace: 1.5,
              color: AppColors.contLightText2,
              weight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFeatureList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.recContColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.06),
        ),
      ),
      child: Column(
        children: List.generate(
          guideList.length,
              (index) {
            final item = guideList[index];
            return Column(
              children: [
                _buildFeatureItem(item),
                if (index != guideList.length - 1)
                  Divider(
                    height: 1,
                    color: Colors.white.withOpacity(.05),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
  Widget _buildFeatureItem(CreditGuideModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureIcon(item),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppStyles.customTextStyle(
                    size: 16,
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: Colors.white60,
                    lineSpace: 1.4,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              spacing: 5,
              children: [
                Text(
                  "${item.credits}",
                  style: AppStyles.customTextStyle(
                    size: 16,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Credits",
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: Colors.white70,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
  Widget _buildFeatureIcon(
      CreditGuideModel item,
      ) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: item.color.withOpacity(.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        item.icon,
        color: item.color,
        size: 18,
      ),
    );
  }
  Widget _buildBottomInfo() {
    return Container(
      padding:  EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: AppColors.recContColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.whiteColor.withValues(alpha: .06),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xff00D68F).withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xff00D68F),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Credits are non-refundable and cannot be transferred.",
                  style: AppStyles.customTextStyle(
                    size: 16,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Make sure to review the credits required before using any feature.",
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: Colors.white60,
                    lineSpace: 1.5,
                    weight: FontWeight.w400,
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
  final List<CreditGuideModel> guideList = [

    CreditGuideModel(
      title: "Syllabus Generation",
      description: "Generate a complete syllabus for any course or topic.",
      credits: 100,
      icon: Icons.menu_book_outlined,
      color: const Color(0xff8B5CF6),
    ),

    CreditGuideModel(
      title: "Resume Review",
      description: "Get AI-powered feedback and suggestions for your resume.",
      credits: 50,
  icon: Icons.description_outlined,
      color: const Color(0xff3B82F6),
    ),

    CreditGuideModel(
      title: "Resume Optimization",
      description: "Optimize your resume for ATS and better performance.",
      credits: 30,
      icon: Icons.picture_as_pdf_outlined,
      color: const Color(0xff3B82F6),
    ),

    CreditGuideModel(
      title: "Banner Generation",
      description: "Create professional banners for your projects or promotions.",
      credits: 25,
      icon: Icons.brush_outlined,
      color: const Color(0xffD4A017),
    ),

    CreditGuideModel(
      title: "Resume Refresh",
      description: "Refresh your resume with the latest trends and formatting.",
      credits: 25,
      icon: Icons.refresh_rounded,
      color: const Color(0xff16A34A),
    ),

    CreditGuideModel(
      title: "Resume Score Analysis",
      description: "Get detailed score and analysis of your resume.",
      credits: 10,
      icon: Icons.analytics_outlined,
      color: const Color(0xff4F6BED),
    ),

    CreditGuideModel(
      title: "Resume Update",
      description: "Update your existing resume with new details.",
      credits: 25,
      icon: Icons.edit_document,
      color: const Color(0xff3B82F6),
    ),

    CreditGuideModel(
      title: "Syllabus Update",
      description: "Update or modify an existing syllabus.",
      credits: 30,
      icon: Icons.edit_note_outlined,
      color: const Color(0xffD4A017),
    ),

    CreditGuideModel(
      title: "MCQ Generation",
      description: "Generate multiple choice questions from any content.",
      credits: 30,
      icon: Icons.quiz_outlined,
      color: const Color(0xff22C1C3),
    ),

    CreditGuideModel(
      title: "Internship Post Creation",
      description: "Create and publish an internship post.",
      credits: 50,
      icon: Icons.work_outline,
      color: const Color(0xffE11D48),
    ),

  ];
}
class CreditGuideModel {
  final String title;
  final String description;
  final int credits;
  final IconData icon;
  final Color color;

  CreditGuideModel({
    required this.title,
    required this.description,
    required this.credits,
    required this.icon,
    required this.color,
  });
}
