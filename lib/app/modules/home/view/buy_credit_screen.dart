import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/credit_plan_card.dart';
import 'package:internsharks/app/data/models/home/credit_plan_model.dart';
import 'package:internsharks/app/data/models/home/order_create_credit_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';


class BuyCreditScreen extends StatefulWidget {
  const BuyCreditScreen({super.key});

  @override
  State<BuyCreditScreen> createState() => _BuyCreditScreenState();
}

class _BuyCreditScreenState extends State<BuyCreditScreen> {
  final DashboardController homeController = Get.find<DashboardController>();
  final RegisterController registerController = Get.find<RegisterController>();

  // Cashfree payment gateway service instance
  final CFPaymentGatewayService cfPaymentGatewayService =
      CFPaymentGatewayService();

  List<PlanData>? creditPlan = [];
  String? creditId = "";
  int? creditBalance;

  // Track which plan is currently being processed
  String? _processingPlanId;

  @override
  void initState() {
    super.initState();
    _initCashFreeCallbacks();
    getCreditData();
    getCreditPlanData();
  }

  /// Set up Cashfree success and failure callbacks once
  void _initCashFreeCallbacks() {
    cfPaymentGatewayService.setCallback(
      // ── PAYMENT SUCCESS ──────────────────────────────────────────────────
      (orderId) async {
        debugPrint('[Cashfree] Payment success for orderId: $orderId');
        await handlePaymentSuccess(orderId);
      },
      // ── PAYMENT FAILURE ──────────────────────────────────────────────────
      (orderId, error) {
        debugPrint(
          '[Cashfree] Payment failed for orderId: $orderId | error: $error',
        );
        handlePaymentFailure(orderId.toString(), error);
      },
    );
  }

  // ── DATA FETCHING ──────────────────────────────────────────────────────────

  Future<void> getCreditData() async {
    creditId = await LocalStorageService.getStudentCreditId();
    await registerController.getCreditData(creditId: creditId!);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      if (mounted) {
        setState(() {
          creditBalance =
              registerController.creditDataModel.creditData?.balance ?? 0;
        });
      }
    }
  }

  Future<void> getCreditPlanData() async {
    await homeController.getCreditPlanData();
    if (homeController.getResponseCode() == 200 ||
        homeController.getResponseCode() == 201) {
      if (mounted) {
        setState(() {
          creditPlan = homeController.creditPlanModel.creditPlan ?? [];
        });
      }
    } else {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong!, try again later!",
      );
    }
  }

  // ── CASHFREE PAYMENT FLOW ──────────────────────────────────────────────────

  /// Step 1 – Create an order on your backend, then open the Cashfree checkout.
  Future<void> onBuyTapped(PlanData plan) async {
    if (_processingPlanId != null) return; // prevent double-tap

    setState(() => _processingPlanId = plan.id);

    try {
      // Create order via your existing controller method
      await homeController.createCreditPlanOrder(
        creditId: creditId!,
        planId: plan.id ?? "",
      );

      if (homeController.getResponseCode() != 200 &&
          homeController.getResponseCode() != 201) {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Failed to create order. Please try again.",
        );
        return;
      }

      // Retrieve the order data returned by the controller
      final OrderCreateCreditModel orderData =
          homeController.createCreditOrderModel;

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

      // Step 2 – Open Cashfree checkout
      openCashFreeCheckout(orderData);
    } catch (e) {
      AppAlertUtils.showToast(
        message: "Something went wrong: $e",
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _processingPlanId = null);
    }
  }

  /// Step 2 – Launch the Cashfree Web Checkout sheet.
  void openCashFreeCheckout(OrderCreateCreditModel orderData) {
    try {
      // Determine environment from the order response (fallback: SANDBOX)
      final CFEnvironment environment =
          (orderData.environment?.toUpperCase() == "SANDBOX")
          ? CFEnvironment.SANDBOX
          : CFEnvironment.PRODUCTION;

      final session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderData.orderId!)
          .setPaymentSessionId(orderData.paymentSessionId!)
          .build();

      final dropPayment = CFWebCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      cfPaymentGatewayService.doPayment(dropPayment);
    } on CFException catch (e) {
      AppAlertUtils.showToast(
        message: "Payment error: ${e.message}",
        isError: true,
      );
    } catch (e) {
      AppAlertUtils.showToast(
        message: "Error opening payment: $e",
        isError: true,
      );
    }
  }

  /// Step 3a – Verify with backend after Cashfree reports success.
  Future<void> handlePaymentSuccess(String orderId) async {
    // Show a temporary "verifying" snackbar
    _showInfo("Verifying your payment…");

    await homeController.verifyCreditPlanOrder(orderId: orderId);

    final int code = homeController.getResponseCode();
    if (code == 200 || code == 201) {
      final verifyData = homeController.verifyCreditOrderModel;

      if (verifyData.orderStatus?.toUpperCase() == "PAID") {
        // Refresh credit balance
        await getCreditData();
        AppAlertUtils.showToast(
          message: verifyData.message ?? "Credits added successfully! 🎉",
        );
      } else {
        AppAlertUtils.showToast(
          message:
              verifyData.message ??
              "Payment verification pending. Credits will be added shortly.",
          isError: true,
        );
      }
    } else {
      AppAlertUtils.showToast(
        message:
            "Verification failed. Please contact support with order ID: $orderId",
        isError: true,
      );
    }
  }

  /// Step 3b – Handle failure reported by Cashfree SDK.
  void handlePaymentFailure(String orderId, String error) {
    AppAlertUtils.showToast(message: "Payment failed: $error", isError: true);
  }

  void _showInfo(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── BUILD ──────────────────────────────────────────────────────────────────

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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColors.whiteColor,
            ),
            onPressed: (){
              Get.back();
              getCreditData();
              },
          ),
          elevation: 0,
          title: Text(
            "Buy Credits",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => homeController.creditPlanLoading
              ? AppAlertUtils.customLoader()
              : SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Title ─────────────────────────────────────────────
                        Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AssetImages.creditsIconNew, height: 25,width: 25,),
                            Text(
                              "Buy Credits",
                              style: AppStyles.customTextStyle(
                                size: 16,
                                weight: FontWeight.w700,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // ── Subtitle ──────────────────────────────────────────
                        Text(
                          "Use credits to apply internships & unlock premium features",
                          textAlign: TextAlign.center,
                          style: AppStyles.customTextStyle(
                            size: 12,
                            weight: FontWeight.w400,
                            color: AppColors.blackLight,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // ── Balance banner ────────────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Your Balance: ${creditBalance ?? 0} Credits",
                            textAlign: TextAlign.center,
                            style: AppStyles.customTextStyle(
                              size: 13,
                              weight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // ── Section label ──────────────────────────────────────
                        Text(
                          "CHOOSE A TOP-UP PLAN",
                          style: AppStyles.customTextStyle(
                            size: 14,
                            weight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // ── Plan grid ─────────────────────────────────────────
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: creditPlan!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemBuilder: (context, index) {
                            final plan = creditPlan![index];
                            final bool isThisPlanLoading =
                                _processingPlanId == plan.id;

                            return CreditPlanCard(
                              plan: plan,
                              onPressedFunc: () => onBuyTapped(plan),
                              // Show loader only on the tapped card
                              isLoading: isThisPlanLoading,
                              // Disable all cards while any order is processing
                              isDisabled:
                                  _processingPlanId != null && !isThisPlanLoading,
                            );
                          },
                        ),
                        const SizedBox(height: 15),

                        // ── Feature tags ──────────────────────────────────────
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightWhiteCont,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "✅ No expiry",
                                style: AppStyles.customTextStyle(
                                  size: 10,
                                  weight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                ),
                              ),
                              Text(
                                "⚡ Instant activation",
                                style: AppStyles.customTextStyle(
                                  size: 10,
                                  weight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                ),
                              ),
                              Text(
                                "🔒 Secure payment",
                                style: AppStyles.customTextStyle(
                                  size: 10,
                                  weight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ── Footer ────────────────────────────────────────────
                        Text(
                          "Powered by Cashfree • 100% Secure Payments",
                          style: AppStyles.customTextStyle(
                            size: 10,
                            weight: FontWeight.w500,
                            color: AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}



