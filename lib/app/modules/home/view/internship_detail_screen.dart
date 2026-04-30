import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/custom_tab_bar.dart';
import 'package:internsharks/app/data/models/home/review_data_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import '../../../core/utils/asset_images.dart' show AssetImages;
import '../../../data/models/home/category_wise_internship_model.dart';

class InternshipDetailScreen extends StatefulWidget {
  const InternshipDetailScreen({super.key});

  @override
  State<InternshipDetailScreen> createState() => _InternshipDetailScreenState();
}

class _InternshipDetailScreenState extends State<InternshipDetailScreen>
    with TickerProviderStateMixin {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final RegisterController registerController = Get.find<RegisterController>();
  final ProfileController profileController = Get.find<ProfileController>();

  String internshipId = "";
  bool isStatusFlow = false;
  String? studentId = "";
  InternshipData? internship;
  List<ReviewData>? reviewList = [];

  @override
  void initState() {
    super.initState();
    internshipId = Get.arguments["internshipId"] ?? "";
    isStatusFlow = Get.arguments["isStatusFlow"] ?? false;
    getDetailsData();
  }

  Future<void> getDetailsData() async {
    // final prefs = await SharedPreferences.getInstance();
    // studentId = prefs.getString('student_id');
    studentId = await LocalStorageService.getStudentId();
    await dashboardController.getInternshipViewData(
      internshipId: internshipId,
      studentId: studentId!,
    );
    if (dashboardController.getResponseCode() == 200 ||
        dashboardController.getResponseCode() == 201) {
      internship = dashboardController.internshipDetailModel.internshipData!;
    }
    await dashboardController.getReviewData(jobId: internshipId);
    reviewList = dashboardController.reviewModel.reviewList;
  }

  List<String> tabNames = ["Internship Details", "About Company", "Reviews"];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Obx(() {
      if (dashboardController.internshipDetailLoading ||
          dashboardController.reviewDataLoading) {
        return Center(
          child: CupertinoActivityIndicator(color: AppColors.secondaryColor),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.blackColor,
        floatingActionButton: Visibility(
          visible: !isStatusFlow,
          child: CustomButtonWidget(
            disable: internship!.status!.isNotEmpty,
            width: isTablet ? 400 : double.infinity,
            height: 45,
            isLoading: dashboardController.internshipApplyLoading,
            buttonFunction: () async {
              bool isVerified =
                  await LocalStorageService.getVerifiedValue() ?? false;

              if (!isVerified) {
                showKycVerifyAlertDialog();
              } else {
                var banner = profileController.profileDataModel.studentBanner;
                bool hasBanner = banner != null && banner.isNotEmpty;

                if (!hasBanner) {
                  showAiBannerRequirementDialog();
                } else {
                  await internshipApplyFunc();
                }
              }
            },
            buttonText: internship!.status!.isNotEmpty
                ? "Applied"
                : "Apply Now (10 Credits)",
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          backgroundColor: AppColors.appBgColor_2,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 12,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                /// ROLE
                Text(
                  internship!.roleType ?? "",
                  style: AppStyles.customTextStyle(
                    size: isTablet ? 20 : 16,
                    weight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
                ),

                const SizedBox(height: 6),

                /// COMPANY + RATING (FIXED OVERFLOW)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        internship!.companyName ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "( ⭐ ${internship!.averageRating ?? 0} )",
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 11,
                          weight: FontWeight.w700,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  "${internship!.totalApplication ?? 0} applicants",
                  style: AppStyles.customTextStyle(
                    size: 10,
                    weight: FontWeight.w300,
                    color: AppColors.secondaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                /// DURATION + STIPEND (FIXED OVERFLOW)
                Row(
                  children: [
                    Expanded(child: durationWidget()),
                    const SizedBox(width: 8),
                    Expanded(child: stipendWidget()),
                  ],
                ),

                const SizedBox(height: 10),

                /// TAB BAR
                Expanded(
                  child: CustomTabBar(
                    tabController: TabController(length: 3, vsync: this),
                    activeBoxColor: AppColors.selectedContColor,
                    activeTextColor: AppColors.whiteColor,
                    tabNames: tabNames,
                    tabPages: [
                      internshipDetailsWidget(),
                      buildCompanyWidget(),
                      buildReviewWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> internshipApplyFunc() async {
    await dashboardController.applyNewInternship(
      internshipId: internshipId,
      studentId: studentId!,
      //studentId: "6983122036ebb4ab9c79c38e",
    );
    if (dashboardController.getResponseCode() == 200 ||
        dashboardController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message: dashboardController.internshipApplyModel.message!,
        isError: false,
      );
      AppFunctions.showAppAlert(
        context: context,
        content: "Application Submitted!",
        title: "Success",
        confirmText: "Okay",
        onCancel: () {
          Get.back();
        },
        onConfirm: () {
          Get.close(1);
        },
      );
    } else {
      AppFunctions.showToast(
        message:
            dashboardController.internshipApplyModel.message ??
            "Failed to apply this Internship!",
        isError: true,
      );
    }
  }

  Widget internshipDetailsWidget() {
    return SingleChildScrollView(
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: AppStyles.customTextStyle(
              size: 16,
              weight: FontWeight.w700,
              color: AppColors.whiteColor,
            ),
          ),
          Text(
            internship!.aboutCompany ?? "",
            style: AppStyles.customTextStyle(
              size: 14,
              weight: FontWeight.w400,
              color: AppColors.whiteColor,
            ),
          ),
          Row(
            spacing: 10,
            children: [
              Text(
                "Location: ",
                style: AppStyles.customTextStyle(
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                internship!.companyCity ?? "NA",
                style: AppStyles.customTextStyle(
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Text(
                "Skills: ",
                style: AppStyles.customTextStyle(
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              Expanded(
                child: Text(
                  (internship!.requiredSkills != null &&
                          internship!.requiredSkills != [])
                      ? internship!.requiredSkills!.join(',')
                      : "NA",
                  maxLines: 3,
                  style: AppStyles.customTextStyle(
                    size: 14,
                    lineSpace: 1.3,
                    weight: FontWeight.w600,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "About Internship",
            style: AppStyles.customTextStyle(
              size: 16,
              weight: FontWeight.w700,
              color: AppColors.whiteColor,
            ),
          ),
          Text(
            internship!.aboutInternship ?? "NA",
            style: AppStyles.customTextStyle(
              size: 14,
              weight: FontWeight.w400,
              color: AppColors.whiteColor,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget buildCompanyWidget() {
    return SingleChildScrollView(
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Who is eligible to apply",
            style: AppStyles.customTextStyle(
              size: 16,
              weight: FontWeight.w700,
              color: AppColors.whiteColor,
            ),
          ),
          Text(
            internship!.requiredSkills!.join(",") ?? "All",
            style: AppStyles.customTextStyle(
              size: 14,
              weight: FontWeight.w400,
              color: AppColors.whiteColor,
            ),
          ),
          companyCard(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget buildReviewWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [companyCard(), reviewField(), const SizedBox(height: 50)],
      ),
    );
  }

  Widget reviewField() {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "Reviews",
          style: AppStyles.customTextStyle(
            size: 16,
            weight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        SizedBox(
          height: 100,
          child: reviewList!.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: reviewList!.length,
                  itemBuilder: (context, index) {
                    return reviewCard(
                      studentName: reviewList![index].studentData != null
                          ? reviewList![index].studentData!.studentName ?? ""
                          : "NA",
                      reviewContent: reviewList![index].review ?? "",
                    );
                  },
                )
              : CustomEmptyWidget(),
        ),
      ],
    );
  }

  Widget reviewCard({
    required String studentName,
    required String reviewContent,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 5),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),

              child: Row(
                spacing: 10,
                children: [
                  Icon(
                    Icons.person_4_outlined,
                    size: 15,
                    color: AppColors.greyIcon,
                  ),
                  Text(
                    studentName ?? "",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.blackLight,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              reviewContent ?? "",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.customTextStyle(
                size: 10,
                color: AppColors.blackColor,
                weight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget companyCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        Text(
          "About Company",
          style: AppStyles.customTextStyle(
            size: 16,
            weight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            ClipOval(
              child: Image.network(
                internship!.companyLogo ?? "",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),

            /// 🔥 FIXED OVERFLOW HERE
            Expanded(
              child: Text(
                internship!.companyName ?? "NA",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.customTextStyle(
                  size: 16,
                  weight: FontWeight.w700,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Text(
          internship!.aboutCompany ?? "NA",
          style: AppStyles.customTextStyle(
            size: 14,
            lineSpace: 1.3,
            color: AppColors.whiteColor,
          ),
        ),

        const SizedBox(height: 10),

        /// 🔥 FIX WIDTH REMOVED
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.map_outlined, size: 40),
              const SizedBox(width: 10),

              /// 🔥 FIXED OVERFLOW HERE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${internship!.companyCity}, ${internship!.companyState}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.customTextStyle(size: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppFunctions.openGoogleMap(internship!.locationLink!);
                      },
                      child: Text(
                        "View on Map",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          isUnderlined: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget durationWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 14),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              internship!.internshipDuration != null &&
                      internship!.internshipDuration!.isNotEmpty
                  ? "${internship!.internshipDuration} Months"
                  : "${internship!.days} Days",
              overflow: TextOverflow.ellipsis,
              style: AppStyles.customTextStyle(
                size: 10,
                color: AppColors.blackLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stipendWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.lightWhiteCont,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.currency_rupee, size: 14),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              internship!.internshipStipend != "N/A"
                  ? "Stipend : ${internship!.internshipStipend}"
                  : internship!.fee != "0"
                  ? "Fees : ${internship!.fee}"
                  : "Free Internship",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.customTextStyle(
                size: 10,
                color: AppColors.blackLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showKycVerifyAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.fieldBgColor,
        title: Image.asset(AssetImages.alertImage, height: 30, width: 30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Verification Pending..!",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
            Text(
              registerController.kycUpdateModel.reasoning != null
                  ? registerController.kycUpdateModel.reasoning!
                  : "Your identity verification is pending. This step is mandatory before you can apply for any internships!",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w300,
                lineSpace: 1.3,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          CustomButtonWidget(
            buttonFunction: () {
              Get.back();
              AppFunctions.navigateScreen(
                context,
                AppRoutes.kycVerificationScreen,
                arguments: {"isRegisterFlow": false},
              );
            },
            buttonText: "Check Now",
            width: 150,
            height: 40,
          ),
        ],
      ),
    );
  }

  void showAiBannerRequirementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.fieldBgColor,
        title: Image.asset(AssetImages.alertImage, height: 40, width: 40),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "AI Banner Required!",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
            Text(
              "To complete your application, you must first generate an AI Banner. This personalized visual is a required part of your profile submission!",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w300,
                lineSpace: 1.4,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          CustomButtonWidget(
            buttonFunction: () {
              Get.back();
              AppFunctions.navigateScreen(context, AppRoutes.homeProfileScreen);
            },
            buttonText: "Generate Now",
            width: 160,
            height: 45,
          ),
        ],
      ),
    );
  }
}
