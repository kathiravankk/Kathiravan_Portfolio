import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/issue_certificate_dialog.dart';
import 'package:internsharks/app/core/widgets/stipend_payment_dialog.dart';
import 'package:internsharks/app/data/models/recruiter_flow/create_stipend_order_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_test_result_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/widgets/candidate_decision_cards.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/widgets/candidate_hiring_decision_form.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/widgets/intern_test_result_cards.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:url_launcher/url_launcher.dart';

class InternTestResultScreen extends StatefulWidget {
  const InternTestResultScreen({super.key});

  @override
  State<InternTestResultScreen> createState() => _InternTestResultScreenState();
}

class _InternTestResultScreenState extends State<InternTestResultScreen> {
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();
  final InternshipPostController applicationController =
      Get.find<InternshipPostController>();
  InternTestResultData? _internData;
  final CFPaymentGatewayService cfPaymentGatewayService =
      CFPaymentGatewayService();
  bool _isStipendPaymentProcessing = false;

  int _selectedTabIndex = 0; // 0: Test Result, 1: Hiring Decision

  String studentId = "";
  String jobId = "";
  String jobType = "";
  bool showPaymentRow = false;
  bool showStipendDialog = false;

  @override
  void initState() {
    studentId = Get.arguments["studentId"] ?? "";
    jobId = Get.arguments["jobId"] ?? "";
    super.initState();
    _initCashFreeCallbacks();
    getTestResult();
    getStudentProfileData();
  }

  void _initCashFreeCallbacks() {
    cfPaymentGatewayService.setCallback(
      (orderId) async {
        debugPrint('[Cashfree] Stipend payment success: $orderId');
        await _handleStipendPaymentSuccess(orderId);
      },
      (orderId, error) {
        debugPrint('[Cashfree] Stipend payment failed: $orderId | $error');
        _handleStipendPaymentFailure(orderId.toString(), error);
      },
    );
  }

  Future<void> getTestResult() async {
    try {
      await homeController.getStudentResult(studentId: studentId, jobId: jobId);
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        setState(() {
          _internData = homeController.testResultModel.testData;
          final stipend = _internData?.testResult?.job?.internshipStipend;
          final fee = _internData?.testResult?.job?.fee;
          jobType = (stipend != null && stipend != "N/A" && stipend.isNotEmpty)
              ? "STIPEND"
              : (fee != null && fee != "0" && fee.isNotEmpty)
              ? "FEES"
              : "FREE";
        });
        if (jobType != "FREE") {
          await checkStipendStatus();
        }
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  Future<void> getStudentProfileData() async {
    try {
      await applicationController.getStudentProfile(studentId: studentId);
      if (applicationController.getResponseCode() != 200 &&
          applicationController.getResponseCode() != 201) {
        AppFunctions.apiErrorHandling(
          applicationController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        applicationController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // BUILD SCREEN
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        image: DecorationImage(
          image: AssetImage(AssetImages.dashBoardBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Obx(
        () =>
            applicationController.studentProfileLoading ||
                homeController.studentResultLoading ||
                applicationController.checkStatusLoading
            ? AppAlertUtils.customLoader()
            : Scaffold(
                backgroundColor: AppColors.transparentColor,
                appBar: _buildAppBar(),
                body: _internData == null
                    ? Center(
                        child: Text(
                          "No test result available.",
                          style: AppStyles.customTextStyle(
                            size: 14,
                            color: AppColors.lightTextColor,
                            weight: FontWeight.w400,
                          ),
                        ),
                      )
                    : SafeArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                          child: Column(
                            spacing: 16,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _profileHeader(),
                              _buildTabBar(),
                              if (_selectedTabIndex == 0) ...[
                                ScoreAndRatingRow(
                                  score: _internData?.testResult
                                      ?.testResultDetails?.score,
                                  stars: _internData?.testResult
                                          ?.testResultDetails?.stars ??
                                      0,
                                ),
                                DailyProgressCard(
                                  progress: _internData?.weeklyReport
                                          ?.dailyProgress ??
                                      [],
                                ),
                                if ((_internData?.weeklyReport
                                            ?.internProjectLink ??
                                        [])
                                    .isNotEmpty)
                                  ProjectLinkCard(
                                    links: List<String>.from(
                                      _internData!.weeklyReport!
                                          .internProjectLink!,
                                    ),
                                  ),
                                Text(
                                  "Answer Review",
                                  style: AppStyles.customTextStyle(
                                    size: 18,
                                    color: AppColors.whiteColor,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                                ..._answerReviewCards(),
                                if (showPaymentRow == true)
                                  PaymentStatusCard(
                                    fee: _internData
                                        ?.testResult?.job?.fee,
                                    updatedAt: _internData
                                        ?.testResult?.updatedAt,
                                  ),
                              ] else ...[
                                _buildHiringDecisionSection(),
                              ],
                            ],
                          ),
                        ),
                      ),
                floatingActionButton:
                    (_internData == null || _selectedTabIndex != 0)
                        ? null
                        : _certificateButton(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.transparentColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
          color: AppColors.whiteColor,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Test Result",
        style: AppStyles.customTextStyle(
          size: 18,
          color: AppColors.secondaryColor,
          weight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _profileHeader() {
    final status = _internData?.weeklyReport?.status ?? "";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        CircleAvatar(
          maxRadius: 30,
          backgroundImage: NetworkImage(
            applicationController.internStudentProfileModel.studProfile ?? "",
          ),
        ),
        Expanded(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                applicationController.internStudentProfileModel.studName ??
                    "Student",
                style: AppStyles.customTextStyle(
                  size: 17,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              Text(
                applicationController
                        .internStudentProfileModel
                        .studentCollegeName ??
                    "College",
                style: AppStyles.customTextStyle(
                  size: 12,
                  color: AppColors.lightTextColor,
                  weight: FontWeight.w400,
                ),
              ),
              if (status.isNotEmpty) ...[_statusChip(status)],
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusChip(String status) {
    final isCompleted = status.toLowerCase() == "completed";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.correctBg : AppColors.disableContColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.pending,
            size: 14,
            color: isCompleted
                ? AppColors.correctText
                : AppColors.lightTextColor,
          ),
          const SizedBox(width: 5),
          Text(
            status.toUpperCase(),
            style: AppStyles.customTextStyle(
              size: 10,
              color: isCompleted
                  ? AppColors.correctText
                  : AppColors.lightTextColor,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _answerReviewCards() {
    final answers =
        _internData?.testResult?.testResultDetails?.correctAnswer ?? [];

    if (answers.isEmpty) {
      return [
        Text(
          "No answers recorded.",
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.lightTextColor,
            weight: FontWeight.w300,
          ),
        ),
      ];
    }

    return List.generate(answers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: QuestionReviewCard(data: answers[index], index: index),
      );
    });
  }

  Widget _certificateButton() {
    final alreadyIssued = _internData?.isCertificate == true;
    final bool stipendPending = jobType == "STIPEND" && showStipendDialog;

    return CustomButtonWidget(
      disable: !alreadyIssued &&
          (_internData?.weeklyReport?.status != "Completed" || stipendPending),
      width: 300,
      buttonFunction: alreadyIssued ? _viewCertificate : _generateCertificate,
      isLoading: homeController.generateCertificateLoading,
      buttonWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            alreadyIssued ? "View Certificate" : "Generate Certificate",
            style: AppStyles.customTextStyle(
              size: 15,
              color: AppColors.blackColor,
              weight: FontWeight.w700,
            ),
          ),
          if (!alreadyIssued) ...[
            const SizedBox(width: 6),
            Text(
              "100",
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.blackColor,
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 5),
            Image.asset(AssetImages.creditsIconNew, height: 22, width: 22),
          ],
        ],
      ),
    );
  }

  Future<void> checkStipendStatus() async {
    try {
      await applicationController.checkStipendStatus(
        studentId: studentId,
        jobId: jobId,
      );
      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        if ((applicationController.statusCheckModel.message ==
                "Fee payment completed for this job") &&
            jobType == "FEES") {
          setState(() => showPaymentRow = true);
        } else if ((applicationController.statusCheckModel.message ==
                "Stipend not paid for this job") &&
            jobType == "STIPEND") {
          setState(() => showStipendDialog = true);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _showStipendPaymentDialog();
          });
        } else {
          if (mounted) setState(() => showStipendDialog = false);
        }
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  void _showStipendPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StipendPaymentDialog(
        studentName: _internData?.testResult?.student?.studName ?? "",
        internship: _internData?.testResult?.job?.roleType ?? "",
        amount: _internData?.testResult?.job?.internshipStipend ?? "",
        onPay: _createStipendOrderAndPay,
      ),
    );
  }

  Future<void> _createStipendOrderAndPay() async {
    if (_isStipendPaymentProcessing) return;
    _isStipendPaymentProcessing = true;

    try {
      Get.back();
      AppAlertUtils.showToast(message: "Creating payment order...");

      await applicationController.createStipendPaymentOrder(
        studentId: studentId,
        jobId: jobId,
      );

      if (applicationController.getResponseCode() == 200 ||
          applicationController.getResponseCode() == 201) {
        final orderData = applicationController.createStipendOrderModel;

        if (orderData.orderId == null ||
            orderData.orderId!.isEmpty ||
            orderData.paymentSessionId == null ||
            orderData.paymentSessionId!.isEmpty) {
          AppAlertUtils.showToast(
            message: "Invalid order details received. Please try again.",
            isError: true,
          );
          return;
        }

        _openStipendCashfreeCheckout(orderData);
      } else {
        AppFunctions.apiErrorHandling(
          applicationController.getResponseCode(),
          "Failed to create stipend order. Please try again.",
        );
      }
    } catch (e) {
      AppAlertUtils.showToast(
        message: "Something went wrong: $e",
        isError: true,
      );
    } finally {
      _isStipendPaymentProcessing = false;
    }
  }

  void _openStipendCashfreeCheckout(CreateStipendOrderModel orderData) {
    try {
      final CFEnvironment environment =
          (orderData.environment?.toUpperCase() == 'SANDBOX' ||
                  (orderData.environment == null && AppApiUrls.isDevEnvironment))
              ? CFEnvironment.SANDBOX
              : CFEnvironment.PRODUCTION;

      debugPrint(
        '[Cashfree Stipend] Launching checkout for orderId: ${orderData.orderId} in env: $environment',
      );

      final session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderData.orderId!)
          .setPaymentSessionId(orderData.paymentSessionId!)
          .build();

      final dropPayment =
          CFWebCheckoutPaymentBuilder().setSession(session).build();

      cfPaymentGatewayService.doPayment(dropPayment);
    } on CFException catch (e) {
      AppAlertUtils.showToast(message: "Payment error: ${e.message}", isError: true);
    } catch (e) {
      AppAlertUtils.showToast(message: "Error opening payment: $e", isError: true);
    }
  }

  Future<void> _handleStipendPaymentSuccess(String orderId) async {
    AppAlertUtils.showToast(message: "Verifying your payment…");

    await applicationController.verifyStipendPaymentOrder(orderId: orderId);

    final int code = applicationController.getResponseCode();
    if (code == 200 || code == 201) {
      AppAlertUtils.showToast(
        message: applicationController.statusCheckModel.message ??
            "Stipend payment verified successfully!",
      );
      if (mounted) {
        setState(() {
          showStipendDialog = false;
          showPaymentRow = false;
        });
      }
      await getTestResult();
      await getStudentProfileData();
    } else {
      AppAlertUtils.showToast(
        message:
            "Verification failed. Please contact support with order ID: $orderId",
        isError: true,
      );
    }
  }

  void _handleStipendPaymentFailure(String orderId, String error) {
    AppAlertUtils.showToast(message: "Payment failed: $error", isError: true);
  }

  void _generateCertificate() {
    showDialog(
      context: context,
      builder: (_) => IssueCertificateDialog(
        onSubmit: (rating, feedback) {
          generateCertificate(rating: rating, feedback: feedback);
        },
      ),
    );
  }

  Future<void> generateCertificate({
    required int rating,
    required String feedback,
  }) async {
    try {
      await homeController.generateAiCertificate(
        requireData: {
          "studentId": studentId,
          "student": studentId,
          "job": jobId,
          "rating": rating,
          "description": feedback,
        },
      );
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        AppAlertUtils.showToast(message: "Certificate generated successfully");
        await getTestResult();
        await getStudentProfileData();
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  void _viewCertificate() {
    AppFunctions.navigateScreen(
      context,
      AppRoutes.certificateViewScreen,
      arguments: {"jobId": jobId, "studentId": studentId},
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TAB BAR & HIRING DECISION ROUTING
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.contColor2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.contBorderColor2),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(
              index: 0,
              title: "Test Result",
              icon: CupertinoIcons.doc_text_fill,
            ),
          ),
          Expanded(
            child: _buildTabItem(
              index: 1,
              title: "Hiring Decision",
              icon: CupertinoIcons.person_crop_circle_badge_checkmark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        if (_selectedTabIndex != index) {
          setState(() {
            _selectedTabIndex = index;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.black : AppColors.lightTextColor,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppStyles.customTextStyle(
                size: 13,
                color: isSelected ? Colors.black : AppColors.lightTextColor,
                weight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _isInterviewSubmitted {
    final res = homeController.testResultModel;
    final data = _internData;
    final details = res.interviewDetails ?? data?.interviewDetails;
    if (details != null &&
        (details.type?.toLowerCase() == 'interview' ||
            (details.interviewRound?.isNotEmpty ?? false) ||
            (details.meetingLinkOrLocation?.isNotEmpty ?? false))) {
      return true;
    }
    if ((res.isInterview == true || data?.isInterview == true) &&
        (details?.type?.toLowerCase() != 'placement')) {
      return details != null;
    }
    return false;
  }

  bool get _isPlacementSubmitted {
    final res = homeController.testResultModel;
    final data = _internData;
    final details = res.placementDetails ?? data?.placementDetails;
    if (details != null &&
        (details.type?.toLowerCase() == 'placement' ||
            (details.jobTitle?.isNotEmpty ?? false) ||
            (details.annualSalary?.isNotEmpty ?? false))) {
      return true;
    }
    if ((res.isPlacement == true || data?.isPlacement == true) &&
        (details?.type?.toLowerCase() == 'placement' ||
            (details?.jobTitle?.isNotEmpty ?? false))) {
      return true;
    }
    return false;
  }

  Widget _buildHiringDecisionSection() {
    if (_isPlacementSubmitted) {
      return PlacementDecisionDetailsCard(
        details: homeController.testResultModel.placementDetails ??
            _internData?.placementDetails,
        fallbackCompanyName: _internData?.testResult?.job?.companyname,
        onOpenUrl: _openUrl,
      );
    }

    if (_isInterviewSubmitted) {
      return InterviewDecisionDetailsCard(
        details: homeController.testResultModel.interviewDetails ??
            _internData?.interviewDetails,
        fallbackCompanyName: _internData?.testResult?.job?.companyname,
        onOpenUrl: _openUrl,
      );
    }

    return CandidateHiringDecisionForm(
      studentId: studentId,
      jobId: jobId,
      defaultJobTitle: _internData?.testResult?.job?.roleType,
      onSuccess: () async {
        await getTestResult();
        await getStudentProfileData();
      },
      onCancel: () {
        setState(() {
          _selectedTabIndex = 0;
        });
      },
    );
  }

  Future<void> _openUrl(String url) async {
    final cleanUrl = url.trim();
    final uri = Uri.tryParse(cleanUrl);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        AppAlertUtils.showToast(
          message: "Could not open link: $cleanUrl",
          isError: true,
        );
      }
    }
  }
}
