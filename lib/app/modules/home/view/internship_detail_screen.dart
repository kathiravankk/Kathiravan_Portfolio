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

  String internshipId = "";
  String? studentId = "";
  InternshipData? internship;

  @override
  void initState() {
    super.initState();
    internshipId = Get.arguments["internshipId"] ?? "";
    getDetailsData();
  }

  Future<void> getDetailsData() async {
    // final prefs = await SharedPreferences.getInstance();
    // studentId = prefs.getString('student_id');
     studentId = await LocalStorageService.getStudentId();
    await dashboardController.getInternshipViewData(internshipId: internshipId);
    if (dashboardController.getResponseCode() == 200 ||
        dashboardController.getResponseCode() == 201) {
      internship = dashboardController.internshipDetailModel.internshipData!;
    }
    await dashboardController.getReviewData(jobId: internshipId);


  }

  List<String> tabNames = ["Internship Details", "About Company", "Reviews"];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.blackColor,
        floatingActionButton: CustomButtonWidget(
          width: 350,
          height: 40,
          isLoading: dashboardController.internshipApplyLoading,
          buttonFunction: () async {
            await internshipApplyFunc();
          },
          buttonText: "Apply Now",
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          backgroundColor: AppColors.blackColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: dashboardController.internshipDetailLoading || dashboardController.reviewDataLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.secondaryColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      internship!.title ?? "",
                      style: AppStyles.customTextStyle(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    Text(
                      internship!.companyName ?? "",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 12,
                          ),
                          child: Row(
                            spacing: 6,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 15,
                                color: AppColors.greyIcon,
                              ),
                              Text(
                                "Duration : ${internship!.internshipDuration ?? "NA"}",
                                style: AppStyles.customTextStyle(
                                  size: 10,
                                  weight: FontWeight.w400,
                                  color: AppColors.blackLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightWhiteCont,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 12,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.currency_rupee,
                                size: 15,
                                color: AppColors.greyIcon,
                              ),
                              Text(
                                "Stipend : ${internship!.internshipStipend ?? "NA"}",
                                style: AppStyles.customTextStyle(
                                  size: 10,
                                  weight: FontWeight.w400,
                                  color: AppColors.blackLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: CustomTabBar(
                        tabController: TabController(
                          length: 3,
                          vsync: this,
                          initialIndex: 0,
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
    );
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
          Get.close(2);
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
    return Column(
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
          internship!.internshipDescription ?? "",
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
            Text(
              (internship!.requiredSkills != null &&
                      internship!.requiredSkills != [])
                  ? internship!.requiredSkills!.join(',')
                  : "NA",
              style: AppStyles.customTextStyle(
                size: 14,
                weight: FontWeight.w600,
                color: AppColors.whiteColor,
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
      ],
    );
  }

  Widget buildCompanyWidget() {
    return Column(
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
          internship!.eligibilityCriteria ?? "All",
          style: AppStyles.customTextStyle(
            size: 14,
            weight: FontWeight.w400,
            color: AppColors.whiteColor,
          ),
        ),
        companyCard(),
      ],
    );
  }

  Widget buildReviewWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [companyCard(), reviewField()],
    );
  }

  Widget reviewField(){
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Text(
          "Reviews",
          style: AppStyles.customTextStyle(
            size: 16,
            weight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        SizedBox(
          height: 210,
          child: dashboardController.reviewModel.reviewList!.isNotEmpty
              ? ListView.separated(
            separatorBuilder: (context, index) =>
                SizedBox(width: 10),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: dashboardController.reviewModel.reviewList!.length,
            itemBuilder: (context, index) {
              ReviewData reviewData = dashboardController.reviewModel.reviewList![index];
              return reviewCard(

              );
            },
          )
              : CustomEmptyWidget(),
        )
      ],
    );
  }

  Widget reviewCard(){
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomLeft: Radius.circular(8))
            ),

            child: Row(
              children: [
                Icon(Icons.person_4_outlined),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget companyCard() {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "About Company",
          style: AppStyles.customTextStyle(
            size: 16,
            weight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        Row(
          spacing: 15,
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.navBarColor, width: 0.5),
              ),
              child: Image.network(
                internship!.companyLogo ?? "",
                height: 40,
                width: 40,
                errorBuilder: (context, error, stackTrace) => CircleAvatar(
                  backgroundColor: AppColors.whiteColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_outlined,
                        color: AppColors.lightHintText,
                        size: 30,
                      ),
                      Text(
                        "Error!",
                        style: AppStyles.customTextStyle(
                          size: 5,
                          weight: FontWeight.w400,
                          color: AppColors.failTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                internship!.companyName ?? "NA",
                maxLines: 2,
                softWrap: true,
                style: AppStyles.customTextStyle(
                  size: 16,
                  lineSpace: 1.3,
                  weight: FontWeight.w700,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),
        Text(
          internship!.aboutCompany ?? "NA",
          style: AppStyles.customTextStyle(
            size: 14,
            weight: FontWeight.w400,
            lineSpace: 1.3,
            color: AppColors.whiteColor,
          ),
        ),
        Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.secondaryColor,
          ),
          padding: EdgeInsets.all(5),
          child: Row(
            spacing: 15,
            children: [
              Icon(Icons.map_outlined, size: 50, color: AppColors.whiteColor),
              Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${internship!.companyCity ?? "NA"} , ${internship!.companyState ?? "NA"}",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      weight: FontWeight.w600,
                      color: AppColors.selectedContColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      AppFunctions.openGoogleMap(internship!.locationLink!);
                    },
                    child: Text(
                      "View on Map",
                      style: AppStyles.customTextStyle(
                        size: 10,
                        weight: FontWeight.w400,
                        color: AppColors.selectedContColor,
                        isUnderlined: true,
                        underlineColor: AppColors.selectedContColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          spacing: 10,
          children: [
            Text(
              "Website: ",
              style: AppStyles.customTextStyle(
                size: 14,
                weight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            GestureDetector(
              onTap: (){
                AppFunctions.launchWebURL(webUrl: internship!.companyWebsite!);
              },
              child: Text(
                internship!.companyWebsite ?? "NA",
                style: AppStyles.customTextStyle(
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
