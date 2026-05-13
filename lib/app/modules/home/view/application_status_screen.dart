import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/internship_card.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/data/models/home/applied_internship_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/internship/controller/internship_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import '../../../data/models/home/recommand_internship_model.dart';

class ApplicationStatusScreen extends StatefulWidget {
  const ApplicationStatusScreen({super.key});

  @override
  State<ApplicationStatusScreen> createState() =>
      _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  ApplicationData? appliedData;
  List<RecommentedData> similarList = [];

  String studentId = "";
  String? selectedJobId;

  final ProfileController profileController = Get.find<ProfileController>();
  final InternshipController internController =
      Get.find<InternshipController>();
  final CFPaymentGatewayService cfPaymentGatewayService =
      CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    _initCashFreeCallbacks();
    appliedData = Get.arguments["appliedData"];
    //if (appliedData!.jobType == "Fee" || appliedData!.jobType == "fee") {
    checkPaymentStatus(
      course: appliedData!.jobData!.roleType,
      jobId: appliedData!.jobData!.sId,
    );
    //}
    getSimilarData();
  }

  void _initCashFreeCallbacks() {
    cfPaymentGatewayService.setCallback(
      (orderId) async {
        debugPrint("Payment success: $orderId");
        await verifyPaymentOrder(orderId);
      },
      (orderId, error) {
        AppAlertUtils.showToast(
          message: "Payment failed: $error",
          isError: true,
        );
      },
    );
  }

  Future<void> checkPaymentStatus({String? jobId, String? course}) async {
    studentId = (await LocalStorageService.getStudentId())!;
    Map<String, dynamic> jobData = {"jobId": jobId, "studentId": studentId};
    await internController.checkPaymentStatus(jobData: jobData);
    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      // if (internController.paymentStatusModel.status == "pending") {
      //   if (mounted) {
      //     AppFunctions.showPaymentRequiredDialog(
      //       context: context,
      //       courseName: course!,
      //       amount: internController.paymentStatusModel.feeAmount.toString(),
      //       onConfirm: () async {
      //         Get.back();
      //         await createPaymentOrder(jobId: jobId!);
      //       },
      //     );
      //   }
      // } else {
      //   if (mounted) {
      //     AppFunctions.navigateScreen(
      //       context,
      //       AppRoutes.internshipSyllabusScreen,
      //       arguments: {"jobId": jobId, "studentId": studentId},
      //     );
      //   }
      // }
    } else {
      AppFunctions.apiErrorHandling(
        internController.getResponseCode(),
        internController.paymentStatusModel.message ?? "Something went wrong!",
      );
    }
  }

  Future<void> getSimilarData() async {
    await dashboardController.getSimilarInternship(
      skillList: appliedData!.jobData!.requiredSkills ?? [],
    );
    if (dashboardController.getResponseCode() == 200 ||
        dashboardController.getResponseCode() == 201) {
      similarList =
          dashboardController.similarInternshipModel.similarList ?? [];
    }
  }

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
      ),
      body: Obx(
        () => internController.paymentStatusCheckLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.secondaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appliedData!.jobData!.roleType ?? "",
                        style: AppStyles.customTextStyle(
                          size: 18,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),

                      Text(
                        appliedData!.jobData!.companyName ?? "",
                        style: AppStyles.customTextStyle(
                          size: 16,
                          color: AppColors.secondaryColor,
                          weight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppFunctions.navigateScreen(
                            context,
                            AppRoutes.internshipDetailScreen,
                            arguments: {
                              "internshipId": appliedData!.jobData!.sId,
                              "isStatusFlow": true,
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            "View Details",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.customTextStyle(
                              size: 12,
                              color: AppColors.lightBlackText2,
                              weight: FontWeight.w400,
                              //isUnderlined: true,
                              //underlineColor: AppColors.lightBlackText2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Your Application Status',
                        style: AppStyles.customTextStyle(
                          size: 16,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                      Column(
                        children: [
                          _buildStatusItem(
                            iconWidget: Icon(
                              Icons.check_circle_sharp,
                              color: AppColors.selectedContColor,
                              size: 20,
                            ),
                            title: 'Applied',
                            date: AppFunctions.formatIsoDate(
                              appliedData!.jobData!.createdAt ?? "",
                            ),
                            showLine: true,
                          ),
                          _buildStatusItem(
                            iconWidget: Icon(
                              Icons.check_circle_sharp,
                              color: AppColors.selectedContColor,
                              size: 20,
                            ),
                            title: 'Application Sent',
                            date: AppFunctions.formatIsoDate(
                              appliedData!.jobData!.createdAt ?? "",
                            ),
                            showLine: true,
                          ),
                          _buildStatusItem(
                            iconWidget: appliedData!.status != "Applied"
                                ? Icon(
                                    Icons.check_circle_sharp,
                                    color: AppColors.selectedContColor,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.circle_outlined,
                                    color: AppColors.whiteColor,
                                    size: 20,
                                  ),
                            title: 'Application viewed by recruiter',
                            showLine: appliedData!.status != "Applied"
                                ? true
                                : false,
                          ),
                          Visibility(
                            visible: appliedData!.status != "Applied",
                            child: _buildStatusItem(
                              iconWidget:
                                  appliedData!.status == "Selected" ||
                                      appliedData!.status == "Shortlisted"
                                  ? Icon(
                                      Icons.check_circle_sharp,
                                      color: AppColors.sucTextColor,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.close,
                                      color: AppColors.failTextColor,
                                      size: 20,
                                    ),
                              title: appliedData!.status!,
                              showLine:
                                  appliedData!.jobType == "Fee" ||
                                      appliedData!.jobType == "fee"
                                  ? true
                                  : false,
                            ),
                          ),
                          Visibility(
                            visible:
                                appliedData!.jobType == "Fee" ||
                                appliedData!.jobType == "fee",
                            child: _buildStatusItem(
                              iconWidget:
                                  internController.paymentStatusModel.status ==
                                      "completed"
                                  ? Icon(
                                      Icons.check_circle_sharp,
                                      color: AppColors.sucTextColor,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.close,
                                      color: AppColors.failTextColor,
                                      size: 20,
                                    ),
                              title:
                                  internController.paymentStatusModel.message ??
                                  "NA",
                              showLine: false,
                            ),
                          ),
                          SizedBox(height: 10),
                          if (appliedData!.jobType == "Fee")
                            _buildPaymentSection(),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Text(
                        'Similar Internship',
                        style: AppStyles.customTextStyle(
                          size: 16,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),

                      dashboardController.similarInternshipLoading
                          ? Center(
                              child: CupertinoActivityIndicator(
                                color: AppColors.secondaryColor,
                              ),
                            )
                          : SizedBox(
                              height: 220,
                              child:
                                  dashboardController
                                      .similarInternshipModel
                                      .similarList!
                                      .isNotEmpty
                                  ? ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(width: 10),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: dashboardController
                                          .similarInternshipModel
                                          .similarList!
                                          .length,
                                      itemBuilder: (context, index) {
                                        // RecommentedData similar =
                                        //     dashboardController
                                        //         .similarInternshipModel
                                        //         .similarList![index];
                                        return InternshipCard(
                                          width: 360,
                                          companyName:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .companyName ??
                                              "",
                                          isSaved:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .isSaved ??
                                              false,
                                          duration:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .internshipDuration ??
                                              "",
                                          // saveFunc: () {
                                          //   similar.isSaved!
                                          //       ? removeToSaved(jobId: similar.sId!)
                                          //       : addToSaved(jobId: similar.sId!);
                                          // },
                                          saveFunc: () async {
                                            dashboardController.similarSaveFunc(
                                              index,
                                            );
                                          },
                                          viewFunc: () {
                                            AppFunctions.navigateScreen(
                                              context,
                                              AppRoutes.internshipDetailScreen,
                                              arguments: {
                                                "internshipId":
                                                    dashboardController
                                                        .similarInternshipModel
                                                        .similarList![index]
                                                        .sId,
                                              },
                                            );
                                          },
                                          eligibility:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .eligibilityCriteria ??
                                              "",
                                          qualification:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .studentQualification!
                                                  .join(", "),
                                          stipendRupees:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .internshipStipend ??
                                              "",
                                          description:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .internshipDescription ??
                                              "",
                                          imageUrl:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .companyLogo ??
                                              "",
                                          internshipMode:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .internshipMode ??
                                              "NA",
                                          role:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .roleType ??
                                              "",
                                          postedDate:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .createdAt ??
                                              "",
                                          skillList:
                                              dashboardController
                                                  .similarInternshipModel
                                                  .similarList![index]
                                                  .requiredSkills ??
                                              [],
                                        );
                                      },
                                    )
                                  : CustomEmptyWidget(),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> createPaymentOrder({required String jobId}) async {
    Map<String, dynamic> jobData = {"jobId": jobId, "studentId": studentId};

    await internController.createPaymentOrder(jobData: jobData);

    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      final orderData = internController.paymentCreateModel;
      openCashFreeCheckout(
        orderId: orderData.orderId ?? "",
        paymentSessionId: orderData.paymentSessionId ?? "",
      );
    } else {
      AppFunctions.apiErrorHandling(
        internController.getResponseCode(),
        "Unable to create payment order",
      );
    }
  }

  void openCashFreeCheckout({
    required String orderId,
    required String paymentSessionId,
  }) {
    try {
      final session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.PRODUCTION)  // need to make PRODUCTION for live
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .build();

      final payment = CFWebCheckoutPaymentBuilder().setSession(session).build();

      cfPaymentGatewayService.doPayment(payment);
    } on CFException catch (e) {
      AppAlertUtils.showToast(
        message: "Payment error: ${e.message}",
        isError: true,
      );
    }
  }

  Future<void> verifyPaymentOrder(String orderId) async {
    Map<String, dynamic> jobData = {"orderId": orderId};

    await internController.verifyPaymentOrder(jobData: jobData);

    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      AppAlertUtils.showToast(message: "Payment successful 🎉", isError: false);
      if (mounted) {
        AppFunctions.navigateScreen(
          context,
          AppRoutes.internshipSyllabusScreen,
          arguments: {
            "jobId": appliedData!.jobData!.sId,
            "studentId": studentId,
          },
        );
      }
    } else {
      AppAlertUtils.showToast(
        message: "Payment verification pending",
        isError: true,
      );
    }
  }

  Future<void> addToSaved({required String jobId}) async {
    await profileController.addSavedJobsData(jobId: jobId);
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
            profileController.savedJobModel.message ??
            "Internship added to your saved posts!",
      );
      await getSimilarData();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.savedJobModel.message ??
            "Something went wrong!, Please try again later",
      );
    }
  }

  Future<void> removeToSaved({required String jobId}) async {
    await profileController.removeSavedJobsData(jobId: jobId);
    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
            profileController.savedJobModel.message ??
            "Internship removed from your saved posts!",
      );
      await getSimilarData();
    } else {
      AppFunctions.apiErrorHandling(
        profileController.getResponseCode(),
        profileController.savedJobModel.message ??
            "Something went wrong!, Please try again later",
      );
    }
  }

  Widget _buildPaymentSection() {
    final bool isPending =
        internController.paymentStatusModel.status == "pending";
    final bool isPaid =
        internController.paymentStatusModel.status == "completed";

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.fieldBgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "PAYMENT DETAILS",
              style: AppStyles.customTextStyle(
                size: 10,
                color: AppColors.darkText,
                weight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Internship Fee",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  isPaid ? "Paid Status: Done" : "Paid Status: Pending",
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: isPaid
                        ? AppColors.sucTextColor
                        : AppColors.secondaryColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            CustomButtonWidget(
              height: 35,
              buttonFunction: isPending
                  ? () async {
                AppAlertUtils.showPaymentRequiredDialog(
                        context: context,
                        courseName: appliedData!.jobData!.roleType!,
                        amount: internController.paymentStatusModel.feeAmount
                            .toString(),
                        onConfirm: () async {
                          Get.back();
                          await createPaymentOrder(
                            jobId: appliedData!.jobData!.sId!,
                          );
                        },
                      );
                    }
                  : () {},
              bgColor: isPaid ? AppColors.sucTextColor : AppColors.primaryColor,
              buttonText: isPaid ? "Paid" : "Pay Now",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required Widget iconWidget,
    required String title,
    String date = "",
    required bool showLine,
  }) {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            iconWidget,
            if (showLine)
              Container(
                width: 2,
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white.withOpacity(0.3)],
                  ),
                ),
              ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyles.customTextStyle(
                size: 12,
                color: AppColors.whiteColor,
                weight: FontWeight.w400,
              ),
            ),
            if (date.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  date,
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: AppColors.darkText,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            SizedBox(height: showLine ? 20 : 0),
          ],
        ),
      ],
    );
  }
}
