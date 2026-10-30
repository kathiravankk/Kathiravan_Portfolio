import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
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
      final result = await recruiterRegisterProvider.fetchSubscriptionPlans();

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
  /// 1. Fetch Recruiter Profile to get recruiter ID
  /// 2. Update recruiter register via PUT API with selected plan details
  /// 3. Create Cashfree subscription payment order
  /// 4. Launch Cashfree PG checkout
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

      // 1. Get recruiterId from arguments or local storage
      String recruiterId = (Get.arguments is Map ? Get.arguments['id'] : null) ??
          await LocalStorageService.getRecruiterId() ??
          '';

      // 2. Fetch Recruiter Profile from API (POST /api/recruiter/getrecruiterbyid)
      if (recruiterId.isNotEmpty) {
        final profileRes = await recruiterRegisterProvider.fetchRecruiterProfile(
          recruiterId: recruiterId,
        );
        if (profileRes.recruiterData?.id != null &&
            profileRes.recruiterData!.id!.isNotEmpty) {
          recruiterId = profileRes.recruiterData!.id!;
        }
      }

      if (recruiterId.isEmpty) {
        isPaymentLoading.value = false;
        AppAlertUtils.showToast(
          message: 'Recruiter session not found. Please log in again.',
          isError: true,
        );
        return;
      }

      // 3. Call Recruiter Register Update API (PUT Form-Data)
      // Exactly required fields:
      // planId, billingCycle, billingCycleId, subscription_plan_id, subscriptionPlan, id, recruiterId
      final Map<String, dynamic> updatePayload = {
        'planId': plan.id ?? '',
        'billingCycle': selectedBillingCycle.value,
        'billingCycleId': cycleObj.id ?? '',
        'subscription_plan_id': plan.id ?? '',
        'subscriptionPlan': plan.id ?? '',
        'id': recruiterId,
        'recruiterId': recruiterId,
      };

      debugPrint('★★★ Calling recruiterregisterupdate before payment: $updatePayload ★★★');

      final updateResult =
          await recruiterRegisterProvider.updateRecruiterSubscription(
        updateData: updatePayload,
      );

      debugPrint('★★★ recruiterregisterupdate response: $updateResult ★★★');

      // 4. Extract subscriptionId from update response
      String subscriptionId = '';
      if (updateResult is Map) {
        if (updateResult['subscriptionId'] != null) {
          subscriptionId = updateResult['subscriptionId'].toString();
        } else if (updateResult['recruiter'] != null &&
            updateResult['recruiter'] is Map &&
            updateResult['recruiter']['subscriptionId'] != null) {
          final s = updateResult['recruiter']['subscriptionId'];
          subscriptionId = (s is Map ? (s['_id'] ?? s['id']) : s).toString();
        } else if (updateResult['subscription'] != null &&
            updateResult['subscription'] is Map) {
          final s = updateResult['subscription'];
          subscriptionId = (s['_id'] ?? s['id'] ?? '').toString();
        } else if (updateResult['data'] != null &&
            updateResult['data'] is Map) {
          final d = updateResult['data'];
          if (d['subscriptionId'] != null) {
            subscriptionId = d['subscriptionId'].toString();
          } else if (d['subscription'] != null && d['subscription'] is Map) {
            subscriptionId =
                (d['subscription']['_id'] ?? d['subscription']['id'] ?? '')
                    .toString();
          }
        }
      }

      // Fallback: If subscriptionId is not directly in update response, fetch from profile API
      if (subscriptionId.isEmpty) {
        final profileCheck =
            await recruiterRegisterProvider.fetchRecruiterProfile(
          recruiterId: recruiterId,
        );
        subscriptionId = profileCheck.recruiterData?.subscriptionId ?? '';
      }

      if (subscriptionId.isEmpty) {
        isPaymentLoading.value = false;
        AppAlertUtils.showToast(
          message: 'Failed to initiate subscription. Please try again.',
          isError: true,
        );
        return;
      }

      debugPrint('★★★ Creating subscription order for subscriptionId: $subscriptionId ★★★');

      // 5. Create Payment Order API (POST /api/recruitersubscriptionplan/create-subscription-order)
      final orderResult =
          await recruiterRegisterProvider.createSubscriptionOrder(
        subscriptionId: subscriptionId,
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

      // 6. Launch Cashfree PG Checkout
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
                      AppApiUrls.baseUrl.contains('dev.')))
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

        AppAlertUtils.showToast(
          message: verifyResult.message?.isNotEmpty == true
              ? verifyResult.message!
              : 'Subscription activated successfully! 🎉',
          isError: false,
        );

        // Navigate to recruiter dashboard with no back stack
        Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
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

  // Skip For Now button pressed (Updates recruiter subscription to Explore/Free via PUT API)
  Future<void> skipForNow() async {
    if (isPaymentLoading.value || isSkipLoading.value) return;

    try {
      isSkipLoading.value = true;

      // Recruiter ID from local storage or args
      final recruiterId = (Get.arguments is Map ? Get.arguments['id'] : null) ??
          await LocalStorageService.getRecruiterId() ??
          '';

      // Find Explore (free) plan
      final explorePlan = planList.firstWhereOrNull(
        (p) => p.name?.toLowerCase().contains('explore') == true,
      );
      final planId = explorePlan?.id ?? '6adaf3ff0a711f8f7940a716';

      final Map<String, dynamic> payload = {
        'planId': planId,
        'billingCycle': 'free',
        'subscription_plan_id': planId,
        'subscriptionPlan': planId,
        'id': recruiterId,
        'recruiterId': recruiterId,
      };

      debugPrint('★★★ Skip For Now Payload: $payload ★★★');

      final result = await recruiterRegisterProvider.updateRecruiterSubscription(
        updateData: payload,
      );

      isSkipLoading.value = false;

      debugPrint('★★★ Update Subscription Response: $result ★★★');

      if (result != null && result['success'] == true) {
        // Save updated credit ID if provided
        if (result['recruiter'] != null &&
            result['recruiter']['recruiterCreditId'] != null) {
          await LocalStorageService.saveRecruiterCreditId(
            creditId: result['recruiter']['recruiterCreditId'].toString(),
          );
        }

        AppAlertUtils.showToast(
          message: result['message'] ?? 'Recruiter profile updated successfully',
          isError: false,
        );

        // Navigate to recruiter dashboard with no back navigation
        Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
      } else {
        final msg = result != null && result['message'] != null
            ? result['message'].toString()
            : 'Failed to update subscription. Please try again.';
        AppAlertUtils.showToast(
          message: msg,
          isError: true,
        );
      }
    } catch (e) {
      isSkipLoading.value = false;
      debugPrint('[SkipForNow] Error: $e');
      AppAlertUtils.showToast(
        message: 'Something went wrong. Please try again.',
        isError: true,
      );
    }
  }
}
