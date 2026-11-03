import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_subscription_order_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_subscription_plan_model.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_register_provider.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class NewRecruiterChoosePlanController extends GetxController {
  final RecruiterRegisterProvider recruiterRegisterProvider;

  NewRecruiterChoosePlanController({required this.recruiterRegisterProvider});

  // Cashfree Payment Gateway Service
  final CFPaymentGatewayService cfPaymentGatewayService =
      CFPaymentGatewayService();

  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isSkipLoading = false.obs;
  final RxBool isPaymentLoading = false.obs;

  // Plan List
  final RxList<RecruiterSubscriptionPlanData> planList =
      <RecruiterSubscriptionPlanData>[].obs;

  // Available Billing Cycles: 'monthly', '3months', '6months', 'yearly'
  final RxList<String> availableCycles = <String>[
    'monthly',
    '3months',
    '6months',
    'yearly',
  ].obs;

  // Selected Billing Cycle
  final RxString selectedBillingCycle = 'monthly'.obs;

  // Selected Plan
  final RxString selectedPlanId = ''.obs;
  final RxString selectedPlanName = 'Growth'.obs;
  final Rx<RecruiterSubscriptionPlanData?> selectedPlan =
      Rx<RecruiterSubscriptionPlanData?>(null);

  /// Only enabled when choosing a paid plan (NOT Explore / Free)
  bool get isContinueEnabled {
    final name = selectedPlanName.value.toLowerCase().trim();
    if (name.contains('explore') || name.isEmpty) return false;
    final plan = selectedPlan.value;
    if (plan == null) return false;
    if (plan.billingCycles == null || plan.billingCycles!.isEmpty) return false;
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    _initCashFreeCallbacks();
    fetchPlans();
  }

  /// Set up Cashfree success and failure callbacks
  void _initCashFreeCallbacks() {
    cfPaymentGatewayService.setCallback(
      // ── PAYMENT SUCCESS ──────────────────────────────────────────────────
      (orderId) async {
        debugPrint('[Cashfree] Payment success for orderId: $orderId');
        await handlePaymentSuccess(orderId.toString());
      },
      // ── PAYMENT FAILURE ──────────────────────────────────────────────────
      (orderId, error) {
        debugPrint(
          '[Cashfree] Payment failed for orderId: $orderId | error: $error',
        );
        handlePaymentFailure(orderId.toString(), error.toString());
      },
    );
  }

  // Fetch subscription plans from API
  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      final String recruiterId =
          (Get.arguments is Map ? Get.arguments['id'] : null) ??
          await LocalStorageService.getRecruiterId() ??
          '';

      final result = await recruiterRegisterProvider.fetchSubscriptionPlans(
        recruiterId: recruiterId,
      );

      if (result.success == true &&
          result.data != null &&
          result.data!.isNotEmpty) {
        // Filter out inactive or deleted plans
        final activePlans = result.data!
            .where((p) => p.isActive != false && p.isDeleted != true)
            .toList();

        // Extract available billing cycles from active plans
        final Set<String> cyclesFound = {};
        for (var p in activePlans) {
          if (p.billingCycles != null) {
            for (var b in p.billingCycles!) {
              if (b.cycle != null && b.cycle!.trim().isNotEmpty) {
                cyclesFound.add(b.cycle!.trim().toLowerCase());
              }
            }
          }
        }

        if (cyclesFound.isNotEmpty) {
          final preferredOrder = ['monthly', '3months', '6months', 'yearly'];
          final orderedCycles = <String>[];
          for (var c in preferredOrder) {
            if (cyclesFound.contains(c)) orderedCycles.add(c);
          }
          for (var c in cyclesFound) {
            if (!orderedCycles.contains(c)) orderedCycles.add(c);
          }
          availableCycles.value = orderedCycles;
        }

        // Distinct by plan name (case-insensitive) to prevent duplicates
        final Map<String, RecruiterSubscriptionPlanData> uniqueByName = {};
        for (var p in activePlans) {
          final cleanName = p.name?.trim() ?? '';
          if (cleanName.isNotEmpty &&
              !uniqueByName.containsKey(cleanName.toLowerCase())) {
            uniqueByName[cleanName.toLowerCase()] = p;
          }
        }

        // Preferred order: Explore, Launch, Growth, Scale
        final order = ['explore', 'launch', 'growth', 'scale'];
        final sorted = <RecruiterSubscriptionPlanData>[];
        for (var key in order) {
          if (uniqueByName.containsKey(key)) {
            sorted.add(uniqueByName.remove(key)!);
          }
        }
        sorted.addAll(uniqueByName.values);

        planList.value = sorted;

        // Auto-select Growth if present (matching screenshot), otherwise first paid plan or first item
        final growthPlan = planList.firstWhereOrNull(
          (p) => p.name?.toLowerCase().contains('growth') == true,
        );
        if (growthPlan != null) {
          selectPlan(growthPlan);
        } else if (planList.isNotEmpty) {
          selectPlan(planList.first);
        }
      } else {
        AppAlertUtils.showToast(
          message: result.message ?? 'Failed to load subscription plans',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('[SubscriptionPlan] Error: $e');
      AppAlertUtils.showToast(
        message: 'Failed to load subscription plans. Please try again.',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle or select Billing Cycle (instantly reflects new price in UI)
  void toggleBillingCycle(String cycle) {
    selectedBillingCycle.value = cycle;
  }

  // Select Plan
  void selectPlan(RecruiterSubscriptionPlanData plan) {
    selectedPlanId.value = plan.id ?? '';
    selectedPlanName.value = plan.name ?? '';
    selectedPlan.value = plan;
  }

  // Check if a plan is currently selected
  bool isPlanSelected(RecruiterSubscriptionPlanData plan) {
    if (selectedPlanId.value.isNotEmpty && plan.id != null) {
      return selectedPlanId.value == plan.id;
    }
    return selectedPlanName.value.toLowerCase() ==
        (plan.name?.toLowerCase() ?? '');
  }

  // ── CASHFREE PAYMENT FLOW ──────────────────────────────────────────────────

  /// Continue to Payment:
  /// 1. Validate chosen plan and cycle
  /// 2. Directly create Cashfree subscription payment order (without calling recruiterregisterupdate)
  /// 3. Launch Cashfree PG checkout
  Future<void> onContinueToPayment() async {
    if (isPaymentLoading.value) return; // Prevent double taps

    if (!isContinueEnabled) {
      AppAlertUtils.showToast(
        message: 'Explore plan is free. Tap "Skip For Now" to proceed.',
        isError: true,
      );
      return;
    }

    final plan = selectedPlan.value;
    if (plan == null) {
      AppAlertUtils.showToast(
        message: 'Please select a subscription plan.',
        isError: true,
      );
      return;
    }

    final cycleObj = plan.getCycle(selectedBillingCycle.value);
    if (cycleObj == null) {
      AppAlertUtils.showToast(
        message: 'Please select a valid billing cycle.',
        isError: true,
      );
      return;
    }

    try {
      isPaymentLoading.value = true;

      debugPrint(
        '★★★ Creating subscription order for planId: ${plan.id}, cycle: ${selectedBillingCycle.value} ★★★',
      );

      // Create Payment Order API directly (POST /api/recruitersubscriptionplan/create-subscription-order)
      final orderResult =
          await recruiterRegisterProvider.createSubscriptionOrder(
        planId: plan.id,
        billingCycle: selectedBillingCycle.value,
      );

      if (orderResult.success != true ||
          orderResult.data == null ||
          orderResult.data!.orderId == null ||
          orderResult.data!.orderId!.isEmpty ||
          orderResult.data!.paymentSessionId == null ||
          orderResult.data!.paymentSessionId!.isEmpty) {
        isPaymentLoading.value = false;
        AppAlertUtils.showToast(
          message: orderResult.message?.isNotEmpty == true
              ? orderResult.message!
              : 'Failed to create payment order. Please try again.',
          isError: true,
        );
        return;
      }

      // Launch Cashfree PG Checkout
      openCashFreeCheckout(orderResult.data!);
    } catch (e) {
      isPaymentLoading.value = false;
      debugPrint('[onContinueToPayment] Exception: $e');
      AppAlertUtils.showToast(
        message: 'Something went wrong: $e',
        isError: true,
      );
    }
  }

  /// Launch Cashfree Web Checkout sheet
  void openCashFreeCheckout(RecruiterSubscriptionOrderData orderData) {
    try {
      final CFEnvironment environment =
          (orderData.environment?.toUpperCase() == 'SANDBOX' ||
                  (orderData.environment == null &&
                      AppApiUrls.isDevEnvironment))
              ? CFEnvironment.SANDBOX
              : CFEnvironment.PRODUCTION;

      debugPrint('[Cashfree] Launching checkout for orderId: ${orderData.orderId} in env: $environment');

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
      isPaymentLoading.value = false;
      AppAlertUtils.showToast(
        message: 'Payment error: ${e.message}',
        isError: true,
      );
    } catch (e) {
      isPaymentLoading.value = false;
      AppAlertUtils.showToast(
        message: 'Error opening payment: $e',
        isError: true,
      );
    }
  }

  /// Verify with backend after Cashfree reports success
  Future<void> handlePaymentSuccess(String orderId) async {
    try {
      AppAlertUtils.showToast(
        message: 'Verifying payment…',
        isError: false,
      );

      final verifyResult =
          await recruiterRegisterProvider.verifySubscriptionPayment(
        orderId: orderId,
      );

      isPaymentLoading.value = false;

      if (verifyResult.success == true) {
        // Save wallet / credit ID if returned
        final walletId = verifyResult.data?.wallet?.id;
        if (walletId != null && walletId.isNotEmpty) {
          await LocalStorageService.saveRecruiterCreditId(creditId: walletId);
        }

        // Show payment success dialog, then navigate to dashboard
        showPaymentSuccessDialog(
          planName: selectedPlanName.value,
          billingCycle: selectedBillingCycle.value,
          orderId: orderId,
          message: verifyResult.message?.isNotEmpty == true
              ? verifyResult.message!
              : 'Subscription activated successfully! Welcome to InternSharks.',
        );
      } else {
        AppAlertUtils.showToast(
          message: verifyResult.message?.isNotEmpty == true
              ? verifyResult.message!
              : 'Payment verification failed. Please contact support.',
          isError: true,
        );
      }
    } catch (e) {
      isPaymentLoading.value = false;
      debugPrint('[handlePaymentSuccess] Error: $e');
      AppAlertUtils.showToast(
        message: 'Error verifying payment. Order ID: $orderId',
        isError: true,
      );
    }
  }

  /// Handle failure reported by Cashfree SDK
  void handlePaymentFailure(String orderId, String error) {
    isPaymentLoading.value = false;
    AppAlertUtils.showToast(
      message: 'Payment cancelled or failed: $error',
      isError: true,
    );
  }

  /// Show payment success alert dialog before going to dashboard
  void showPaymentSuccessDialog({
    required String planName,
    required String billingCycle,
    required String orderId,
    required String message,
  }) {
    final context = Get.context;
    if (context == null) {
      Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.fieldBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFF1E3547), width: 1),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.blackColor,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Payment Successful!',
                style: AppStyles.customTextStyle(
                  size: 20,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: const Color(0xFF94A3B8),
                  weight: FontWeight.w400,
                  lineSpace: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1622),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF162534),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildDialogRow(
                      'Plan',
                      planName,
                      valueColor: const Color(0xFF00E5FF),
                      isBold: true,
                    ),
                    const SizedBox(height: 6),
                    _buildDialogRow(
                      'Billing Cycle',
                      _formatBillingCycle(billingCycle),
                    ),
                    const SizedBox(height: 6),
                    _buildDialogRow('Order ID', orderId, isSmall: true),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              CustomButtonWidget(
                height: 44,
                buttonText: 'Go to Dashboard',
                buttonFunction: () {
                  Get.back();
                  Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Skip For Now button pressed:
  /// Directly shows alert dialog notifying that basic plan is chosen automatically,
  /// and navigates to recruiter dashboard WITHOUT calling any API.
  void skipForNow() {
    if (isPaymentLoading.value || isSkipLoading.value) return;
    showSkipWelcomeDialog();
  }

  /// Show alert dialog notifying basic plan is chosen automatically and welcoming to Internsharks
  void showSkipWelcomeDialog() {
    final context = Get.context;
    if (context == null) {
      Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.fieldBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFF1E3547), width: 1),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.blackColor,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to Internsharks!',
                style: AppStyles.customTextStyle(
                  size: 20,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Basic plan has been chosen automatically, but you can upgrade it anytime later.\nWelcome to Internsharks!',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 13.5,
                  color: const Color(0xFF94A3B8),
                  weight: FontWeight.w400,
                  lineSpace: 1.3,
                ),
              ),
              const SizedBox(height: 22),
              CustomButtonWidget(
                height: 44,
                buttonText: 'Go to Dashboard',
                buttonFunction: () {
                  Get.back();
                  Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogRow(
    String label,
    String value, {
    Color valueColor = AppColors.whiteColor,
    bool isBold = false,
    bool isSmall = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.customTextStyle(
            size: isSmall ? 11 : 12,
            color: const Color(0xFF94A3B8),
            weight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: isSmall ? 11 : 13,
              color: valueColor,
              weight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _formatBillingCycle(String cycle) {
    switch (cycle.toLowerCase()) {
      case 'monthly':
        return 'Monthly';
      case '3months':
        return '3 Months';
      case '6months':
        return '6 Months';
      case 'yearly':
      case 'annual':
        return 'Yearly';
      default:
        return cycle.capitalizeFirst ?? cycle;
    }
  }
}
