import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/custom_tab_bar.dart';
import 'package:internsharks/app/data/models/home/review_data_model.dart';
import 'package:internsharks/app/data/models/home/recruiter_review_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
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
    internshipId = Get.arguments["internshipId"] ?? "";
    isStatusFlow = Get.arguments["isStatusFlow"] ?? false;
    getDetailsData();
    super.initState();
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
    if (isStatusFlow) {
      await profileController.getRecruiterReview(jobId: internshipId);
    }
  }

  List<String> tabNames = ["Internship Details", "About Company", "Reviews"];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    // Obx(() {
    // if (dashboardController.internshipDetailLoading ||
    //     dashboardController.reviewDataLoading) {
    //   return Center(
    //     child: CupertinoActivityIndicator(color: AppColors.secondaryColor),
    //   );
    // }

    return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetImages.appBackgroundImg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Obx(
                    () =>
                dashboardController.internshipDetailLoading ||
                    dashboardController.reviewDataLoading
                    ? AppAlertUtils.customLoader()
                    : Scaffold(
                backgroundColor: AppColors.transparentColor,
                floatingActionButton: Visibility(
                  visible: !isStatusFlow,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomButtonWidget(
                      disable: internship!.status!.isNotEmpty,
                      width: isTablet ? 400 : double.infinity,
                      height: 45,
                      isLoading: dashboardController.internshipApplyLoading,
                      buttonFunction: () async {
                        bool isVerified =
                            await LocalStorageService.getVerifiedValue() ??
                            false;

                        if (!isVerified) {
                          showKycVerifyAlertDialog();
                        } else {
                          var banner =
                              profileController.profileDataModel.studentBanner;
                          bool hasBanner = banner != null && banner.isNotEmpty;

                          if (!hasBanner) {
                            showAiBannerRequirementDialog();
                          } else if (internship!.noOfPosition != 0 &&
                              internship!.noOfPosition != null) {
                            await internshipApplyFunc();
                          } else {
                            AppAlertUtils.showToast(
                              message: "Positions filled. Applications closed!",
                              isError: true,
                            );
                          }
                        }
                      },
                      buttonText: internship!.status!.isNotEmpty
                          ? "Applied"
                          : "Apply Now (20 Credits)",
                      buttonWidget: internship!.status!.isNotEmpty
                          ? Text(
                              "Applied",
                              style: AppStyles.customTextStyle(
                                size: 16,
                                color: AppColors.whiteColor,
                                weight: FontWeight.w500,
                                fontFamily: "Roboto",
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Apply Now - ",
                                  style: AppStyles.customTextStyle(
                                    size: 16,
                                    color: AppColors.whiteColor,
                                    weight: FontWeight.w500,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                                Text(
                                  "20",
                                  style: AppStyles.customTextStyle(
                                    size: 16,
                                    color: AppColors.whiteColor,
                                    weight: FontWeight.w500,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                                Image.asset(
                                  AssetImages.creditsIconNew,
                                  height: 22,
                                  width: 22,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                appBar: AppBar(
                  backgroundColor: AppColors.transparentColor,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        /// ROLE
                        Text(
                          internship!.roleType ?? "",
                          style: AppStyles.customTextStyle(
                            size: 20,
                            weight: FontWeight.w700,
                            color: AppColors.whiteColor,
                            lineSpace: 1.4,
                          ),
                        ),

                        const SizedBox(height: 5),

                        /// COMPANY + RATING (FIXED OVERFLOW)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                internship!.companyName ?? "",
                                style: AppStyles.customTextStyle(
                                  size: 16,
                                  weight: FontWeight.w700,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                "( ⭐ ${internship!.averageRating ?? 0} Reviews)",
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.customTextStyle(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(),

                        Text(
                          "${internship!.totalApplication ?? 0} applicants",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            weight: FontWeight.w300,
                            color: AppColors.secondaryColor,
                          ),
                        ),

                        const SizedBox(),

                        /// DURATION + STIPEND (FIXED OVERFLOW)
                        Row(
                          spacing: 10,
                          children: [durationWidget(), stipendWidget()],
                        ),
                        const SizedBox(),
                        Text(
                          "Posted ${AppFunctions.convertPostedDate(internship!.createdAt ?? "")}",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            weight: FontWeight.w300,
                            color: AppColors.whiteColor,
                          ),
                        ),

                        /// TAB BAR
                        Expanded(
                          child: CustomTabBar(
                            tabController: TabController(
                              length: 3,
                              vsync: this,
                            ),
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
              ),
            ),
    );
  }

  Future<void> internshipApplyFunc() async {
    try {
      await dashboardController.applyNewInternship(
        internshipId: internshipId,
        studentId: studentId!,
        //studentId: "6983122036ebb4ab9c79c38e",
      );
      if (dashboardController.getResponseCode() == 200 ||
          dashboardController.getResponseCode() == 201) {
        AppAlertUtils.showToast(
          message: dashboardController.internshipApplyModel.message!,
          isError: false,
        );
        AppAlertUtils.showAppAlert(
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
        AppFunctions.apiErrorHandling(
          dashboardController.getResponseCode(),
          dashboardController.internshipApplyModel.message ??
              "Failed to apply this Internship!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        dashboardController.getResponseCode(),
        dashboardController.internshipApplyModel.message ??
            "Failed to apply this Internship!",
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
              color: AppColors.secondaryColor,
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
                  maxLines: 10,
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
          const SizedBox(height: 5),
          Text(
            "About Internship",
            style: AppStyles.customTextStyle(
              size: 16,
              weight: FontWeight.w700,
              color: AppColors.secondaryColor,
            ),
          ),
          Text(
            internship!.aboutInternship ?? "NA",
            style: AppStyles.customTextStyle(
              size: 14,
              lineSpace: 1.4,
              weight: FontWeight.w400,
              color: AppColors.whiteColor,
            ),
          ),
          if (isStatusFlow) recruiterFeedbackWidget(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget recruiterFeedbackWidget() {
    return Obx(() {
      if (profileController.recruiterReviewLoading) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: CupertinoActivityIndicator(color: AppColors.secondaryColor),
          ),
        );
      }

      final reviews =
          profileController.recruiterReviewModel.reviews ?? [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          const SizedBox(height: 5),
          Text(
            "Recruiter's Feedback",
            style: AppStyles.customTextStyle(
              size: 16,
              weight: FontWeight.w700,
              color: AppColors.secondaryColor,
            ),
          ),
          if (reviews.isEmpty)
            CustomEmptyWidget()
          else
            ...reviews.map((review) => recruiterFeedbackCard(review)),
        ],
      );
    });
  }

  Widget recruiterFeedbackCard(RecruiterReview review) {
    final recruiter = review.recruiter;
    final rating = int.tryParse(review.rating.toString()) ?? 0;

    String formattedDate = '';
    try {
      formattedDate = DateFormat("MMMM yyyy")
          .format(DateTime.parse(review.createdAt ?? ''));
    } catch (_) {}

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.contColor2,
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recruiter logo
              ClipOval(
                child: Image.network(
                  recruiter?.recCompanyLogo ?? '',
                  height: 38,
                  width: 38,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.contBorderColor2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_2_outlined,
                      size: 22,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 38,
                      width: 38,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Recruiter name + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      (recruiter?.recName ?? 'Recruiter').toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.customTextStyle(
                        size: 14,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    if (formattedDate.isNotEmpty)
                      Text(
                        formattedDate,
                        style: AppStyles.customTextStyle(
                          size: 12,
                          color: AppColors.lightColorText,
                          weight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              // Star rating
              Row(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(
                      Icons.star,
                      size: 18,
                      color: index < rating
                          ? AppColors.secondaryColor
                          : AppColors.whiteColor,
                    ),
                  );
                }),
              ),
            ],
          ),
          // Feedback type badge
          if ((review.feedbackType ?? '').isNotEmpty)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                review.feedbackType!,
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.primaryColor,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          // Review text
          Text(
            review.review ?? '',
            style: AppStyles.customTextStyle(
              size: 14,
              lineSpace: 1.4,
              color: AppColors.whiteColor,
              weight: FontWeight.w400,
            ),
          ),
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
              color: AppColors.secondaryColor,
            ),
          ),
          Text(
            internship!.requiredSkills!.join(","),
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
          height: 150,
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
                      createdAt: reviewList![index].createdAt ?? "",
                      rating: int.parse(reviewList![index].rating.toString()),
                      profileImage: reviewList![index].studentData != null
                          ? reviewList![index].studentData!.studentProfile ?? ""
                          : "",
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
    required int rating,
    required String createdAt,
    required String profileImage,
  }) {
    final formattedDate = DateFormat(
      "MMMM yyyy",
    ).format(DateTime.parse(createdAt));

    return Container(
      width: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.contColor2,
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.network(
                        profileImage,
                        height: 35,
                        width: 35,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.contBorderColor2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.person_2_outlined,
                              size: 25,
                              color: AppColors.whiteColor,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return SizedBox(
                            height: 25,
                            width: 25,
                            child: Center(
                              child: CupertinoActivityIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studentName.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.customTextStyle(
                              size: 14,
                              color: AppColors.whiteColor,
                              weight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: AppStyles.customTextStyle(
                              size: 12,
                              color: AppColors.lightColorText,
                              weight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),
              Row(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(
                      Icons.star,
                      size: 20,
                      color: index < rating
                          ? AppColors.secondaryColor
                          : AppColors.whiteColor,
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            reviewContent,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: 14,
              lineSpace: 1.4,
              color: AppColors.whiteColor,
              weight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget companyCard() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        Text(
          "About Company",
          style: AppStyles.customTextStyle(
            size: 16,
            weight: FontWeight.w700,
            color: AppColors.secondaryColor,
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
                style: AppStyles.customTextStyle(
                  size: 16,
                  weight: FontWeight.w700,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "( ⭐ ${internship!.averageRating ?? 0} Reviews)",
              overflow: TextOverflow.ellipsis,
              style: AppStyles.customTextStyle(
                size: 12,
                weight: FontWeight.w700,
                color: AppColors.whiteColor,
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
        GestureDetector(
          onTap: () {
            AppFunctions.openGoogleMap(internship!.locationLink!);
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.contBorderColor2),
              borderRadius: BorderRadius.circular(15),
              color: AppColors.contColor2,
            ),
            child: Row(
              spacing: 10,
              children: [
                Image.asset(AssetImages.mapViewImg, height: 50, width: 50),
                //const Icon(Icons.map_outlined, size: 40),
                Expanded(
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${internship!.companyCity}, ${internship!.companyState}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppFunctions.openGoogleMap(internship!.locationLink!);
                        },
                        child: Text(
                          "View on Map",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            isUnderlined: true,
                            underlineColor: AppColors.whiteColor,
                            weight: FontWeight.w400,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget durationWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.correctBg,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        border: Border.all(color: AppColors.correctBorder),
      ),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.access_time,
            size: 14,
            color: AppColors.lightWhiteCont,
          ),
          Text(
            internship!.internshipDuration != null &&
                    internship!.internshipDuration!.isNotEmpty
                ? "Duration: ${internship!.internshipDuration} Months"
                : "Duration: ${internship!.days} Days",
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.lightWhiteCont,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget stipendWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.contLightColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        border: Border.all(
          color: AppColors.secondaryColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.currency_rupee,
            size: 14,
            color: AppColors.lightWhiteCont,
          ),
          const SizedBox(width: 5),
          Text(
            internship!.internshipStipend != "N/A"
                ? "Stipend : ${internship!.internshipStipend}"
                : internship!.fee != "0"
                ? "Fees : ${internship!.fee}"
                : "Free Internship",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.lightWhiteCont,
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
              // registerController.kycUpdateModel.reasoning != null
              //     ? registerController.kycUpdateModel.reasoning!
              //     :
              "Your identity verification is pending. This step is mandatory before you can apply for any internships!",
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
              "ResDp Required!",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
            Text(
              "To complete your application, you must first generate an ResDp. This personalized visual is a required part of your profile submission!",
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
