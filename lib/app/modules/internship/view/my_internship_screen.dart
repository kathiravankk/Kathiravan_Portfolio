import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/internship_syllabus_card.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/internship/controller/internship_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';

class MyInternshipScreen extends StatefulWidget {
  const MyInternshipScreen({super.key});

  @override
  State<MyInternshipScreen> createState() => _MyInternshipScreenState();
}

class _MyInternshipScreenState extends State<MyInternshipScreen> {
  final InternshipController internController =
      Get.find<InternshipController>();

  final CFPaymentGatewayService cfPaymentGatewayService =
      CFPaymentGatewayService();

  String studentId = "";
  List<SyllabusData>? syllabusList = [];
  String? selectedJobId;
  String? selectedCourse;

  @override
  void initState() {
    super.initState();
    _initCashFreeCallbacks();
    getInternshipData();
  }

  void _initCashFreeCallbacks() {
    cfPaymentGatewayService.setCallback(
      (orderId) async {
        debugPrint("Payment success: $orderId");
        await verifyPaymentOrder(orderId);
      },
      (orderId, error) {
        AppFunctions.showToast(
          message: "Payment failed: $error",
          isError: true,
        );
      },
    );
  }

  Future<void> getInternshipData() async {
    studentId = await LocalStorageService.getStudentId() ?? "";
    await internController.getInternshipSyllabus(studentId: studentId);
    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      syllabusList = internController.internSyllabusModel.syllabus ?? [];
    } else {
      AppFunctions.apiErrorHandling(
        internController.getResponseCode(),
        internController.internSyllabusModel.message ?? "Something went wrong!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.appBgColor_2,
      color: AppColors.primaryColor,
      onRefresh: () => getInternshipData(),
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        appBar: AppBar(
          backgroundColor: AppColors.blackColor,
          elevation: 0,
          automaticallyImplyActions: false,
          centerTitle: true,
          title: Text(
            "My Internships",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => internController.internSyllabusLoading || internController.paymentCreateLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.secondaryColor,
                  ),
                )
              : syllabusList!.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: syllabusList!.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(15),
                  itemBuilder: (context, index) {
                    final item = syllabusList![index];
                    return InternSyllabusCard(
                      title: item.subject ?? "NA",
                      subTitle: "Introduction to Software Developer",
                      totalWeeks: item.totalDays ?? 0,
                      totalTopics: item.meta!.totalTopics ?? 0,
                      isLoading: internController.paymentStatusCheckLoading,
                      viewFunc: () async {
                        selectedJobId = item.job;
                        selectedCourse = item.subject;

                        await checkPaymentStatus(
                          jobId: item.job ?? "",
                          course: item.subject ?? "",
                        );
                      },
                    );
                  },
                )
              : CustomEmptyWidget(),
        ),
      ),
    );
  }

  Future<void> checkPaymentStatus({String? jobId, String? course}) async {
    Map<String, dynamic> jobData = {"jobId": jobId, "studentId": studentId};
    await internController.checkPaymentStatus(jobData: jobData);
    if (internController.getResponseCode() == 200 ||
        internController.getResponseCode() == 201) {
      if (internController.paymentStatusModel.status == "pending") {
        if (mounted) {
          AppFunctions.showPaymentRequiredDialog(
            context: context,
            courseName: course!,
            amount: internController.paymentStatusModel.feeAmount.toString(),
            onConfirm: () async {
              Get.back();
              await createPaymentOrder(jobId: jobId!);
            },
          );
        }
      } else {
        if (mounted) {
          AppFunctions.navigateScreen(
            context,
            AppRoutes.internshipSyllabusScreen,
            arguments: {"jobId": jobId, "studentId": studentId},
          );
        }
      }
    } else {
      AppFunctions.apiErrorHandling(
        internController.getResponseCode(),
        internController.paymentStatusModel.message ?? "Something went wrong!",
      );
    }
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
          .setEnvironment(CFEnvironment.SANDBOX)
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .build();

      final payment = CFWebCheckoutPaymentBuilder().setSession(session).build();

      cfPaymentGatewayService.doPayment(payment);
    } on CFException catch (e) {
      AppFunctions.showToast(
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
      AppFunctions.showToast(message: "Payment successful 🎉", isError: false);
      if (mounted) {
        AppFunctions.navigateScreen(
          context,
          AppRoutes.internshipSyllabusScreen,
          arguments: {"jobId": selectedJobId, "studentId": studentId},
        );
      }
    } else {
      AppFunctions.showToast(
        message: "Payment verification pending",
        isError: true,
      );
    }
  }
}
