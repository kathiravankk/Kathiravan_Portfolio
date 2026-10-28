import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_subscription_plan_model.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_register_provider.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class NewRecruiterChoosePlanController extends GetxController {
  final RecruiterRegisterProvider recruiterRegisterProvider;

  NewRecruiterChoosePlanController({required this.recruiterRegisterProvider});

  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isSkipLoading = false.obs;

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
    fetchPlans();
  }

  // Fetch subscription plans from API
  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      final result = await recruiterRegisterProvider.fetchSubscriptionPlans();

      if (result.success == true && result.data != null && result.data!.isNotEmpty) {
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

  // Continue to Payment button pressed
  void onContinueToPayment() {
    if (!isContinueEnabled) {
      AppAlertUtils.showToast(
        message: 'Explore plan is free. Tap "Skip For Now" to proceed.',
        isError: true,
      );
      return;
    }

    final cycleObj = selectedPlan.value?.getCycle(selectedBillingCycle.value);

    debugPrint('★★★ Proceeding to Payment ★★★');
    debugPrint('Plan: ${selectedPlanName.value}');
    debugPrint('PlanId: ${selectedPlanId.value}');
    debugPrint('Cycle: ${selectedBillingCycle.value}');
    debugPrint('Price: ${cycleObj?.price}');
    debugPrint('CreditLimit: ${cycleObj?.creditLimit}');

    AppAlertUtils.showToast(
      message:
          'Selected: ${selectedPlanName.value} (₹${cycleObj?.price ?? ''})',
      isError: false,
    );
  }

  // Skip For Now button pressed (Updates recruiter subscription to Explore/Free via PUT API)
  Future<void> skipForNow() async {
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
