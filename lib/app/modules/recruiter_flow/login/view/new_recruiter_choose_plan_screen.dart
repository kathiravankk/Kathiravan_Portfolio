import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_subscription_plan_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/new_recruiter_choose_plan_controller.dart';

class NewRecruiterChoosePlanScreen extends StatelessWidget {
  const NewRecruiterChoosePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewRecruiterChoosePlanController>();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        backgroundColor: AppColors.transparentColor,
        body: SafeArea(
          child: Column(
            children: [
              /// TOP BAR (Back button + Step 4 of 4)
              //_buildTopBar(),

              /// SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// STEP INDICATOR (4 Steps)
                      _buildStepIndicator(),

                      const SizedBox(height: 22),

                      /// HEADER TITLE & SUBTITLE
                      _buildHeader(),

                      const SizedBox(height: 18),

                      /// BILLING CYCLE TOGGLE (Monthly / Annual)
                      Obx(() => _buildBillingCycleToggle(controller)),

                      const SizedBox(height: 20),

                      /// PLANS LIST
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 60),
                              child: CupertinoActivityIndicator(
                                radius: 14,
                                color: Color(0xFF00E5FF),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            /// Dynamic API Plans (Explore, Launch, Growth, Scale, etc.)
                            ..._buildAllPlanCards(controller),

                            /// Static Enterprise Tier (matching screenshot)
                            _buildEnterpriseCard(context),

                            /// GST Disclaimer Note
                            _buildGstDisclaimer(),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),

              /// BOTTOM CONTINUE BUTTON
              _buildBottomButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  // ─── TOP BAR ────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF0F1726),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1E293B), width: 1),
              ),
              child: const Icon(
                CupertinoIcons.back,
                color: AppColors.whiteColor,
                size: 18,
              ),
            ),
          ),
          Text(
            'Step 4 of 4',
            style: AppStyles.customTextStyle(
              size: 13,
              color: const Color(0xFFF5BA41),
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ─── STEP PROGRESS INDICATOR (4 STEPS) ──────────────────────────────
  Widget _buildStepIndicator() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Step 1 — Personal Details (Completed)
        Expanded(
          child: Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF10B981),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.checkmark,
                  color: AppColors.whiteColor,
                  size: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Personal Details',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 10,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Tell us about yourself',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 8.5,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        /// Connector 1 -> 2
        Container(
          width: 18,
          height: 1.5,
          color: const Color(0xFF10B981),
          margin: const EdgeInsets.only(top: 14),
        ),

        /// Step 2 — Company Information (Completed)
        Expanded(
          child: Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF10B981),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.checkmark,
                  color: AppColors.whiteColor,
                  size: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Company Information',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 10,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Add your company details',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 8.5,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        /// Connector 2 -> 3
        Container(
          width: 18,
          height: 1.5,
          color: const Color(0xFF10B981),
          margin: const EdgeInsets.only(top: 14),
        ),

        /// Step 3 — Review (Completed)
        Expanded(
          child: Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF10B981),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.checkmark,
                  color: AppColors.whiteColor,
                  size: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Review',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 10,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Verify details',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 8.5,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        /// Connector 3 -> 4
        Container(
          width: 18,
          height: 1.5,
          color: const Color(0xFF00E5FF),
          margin: const EdgeInsets.only(top: 14),
        ),

        /// Step 4 — Choose Plan (Active)
        Expanded(
          child: Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF00E5FF),
                ),
                alignment: Alignment.center,
                child: Text(
                  '4',
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: AppColors.blackColor,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose Plan',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 10,
                  color: const Color(0xFFF5BA41),
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Select your plan',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 8.5,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── HEADER TITLE & SUBTITLE ─────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Choose your ',
                style: AppStyles.customTextStyle(
                  size: 23,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Recruiter Plan',
                style: AppStyles.customTextStyle(
                  size: 23,
                  color: const Color(0xFF00E5FF),
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Select a plan that fits your hiring needs. You can upgrade or change it anytime.',
          style: AppStyles.customTextStyle(
            size: 13,
            color: const Color(0xFF94A3B8),
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ─── BILLING CYCLE TOGGLE (DYNAMIC MULTI-CYCLE) ─────────────────────
  Widget _buildBillingCycleToggle(NewRecruiterChoosePlanController controller) {
    final cycles = controller.availableCycles;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1622),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF142434), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: cycles.map((cycleKey) {
            final isSelected =
                controller.selectedBillingCycle.value.toLowerCase() ==
                cycleKey.toLowerCase();
            final title = _getCycleDisplayName(cycleKey);
            final hasBadge =
                cycleKey.toLowerCase().contains('year') ||
                cycleKey.toLowerCase().contains('annual');

            return GestureDetector(
              onTap: () => controller.toggleBillingCycle(cycleKey),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFF5BA41)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppStyles.customTextStyle(
                        size: 13,
                        color: isSelected
                            ? AppColors.blackColor
                            : AppColors.whiteColor,
                        weight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                    if (hasBadge) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF063E3F)
                              : const Color(0xFF072F32),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(
                              0xFF00E5FF,
                            ).withValues(alpha: 0.5),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          'Save 2 Months',
                          style: AppStyles.customTextStyle(
                            size: 9,
                            color: const Color(0xFF00E5FF),
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── DYNAMIC API PLANS BUILDER ────────────────────────────────────────
  List<Widget> _buildAllPlanCards(NewRecruiterChoosePlanController controller) {
    final plans = List<RecruiterSubscriptionPlanData>.from(controller.planList);

    // If API didn't include "Scale", add it as a fallback plan matching screenshot
    final hasScale = plans.any(
      (p) => p.name?.toLowerCase().contains('scale') == true,
    );
    if (!hasScale) {
      plans.add(
        RecruiterSubscriptionPlanData(
          id: 'scale_plan_id',
          name: 'Scale',
          coordinatorlimit: 15,
          internshipLimit: 30,
          activeInternLimit: 200,
          billingCycles: [
            SubscriptionBillingCycle(
              id: 'scale_monthly',
              cycle: 'monthly',
              price: 7999,
              creditLimit: 10000,
            ),
            SubscriptionBillingCycle(
              id: 'scale_3months',
              cycle: '3months',
              price: 21999,
              creditLimit: 30000,
            ),
            SubscriptionBillingCycle(
              id: 'scale_6months',
              cycle: '6months',
              price: 41999,
              creditLimit: 60000,
            ),
            SubscriptionBillingCycle(
              id: 'scale_yearly',
              cycle: 'yearly',
              price: 79999,
              creditLimit: 120000,
            ),
          ],
        ),
      );
    }

    return plans.map((plan) => _buildPlanCard(controller, plan)).toList();
  }

  // ─── SINGLE PLAN CARD ────────────────────────────────────────────────
  Widget _buildPlanCard(
    NewRecruiterChoosePlanController controller,
    RecruiterSubscriptionPlanData plan,
  ) {
    final planName = plan.name?.trim() ?? 'Plan';
    final isSelected = controller.isPlanSelected(plan);
    final selectedCycle = controller.selectedBillingCycle.value;

    // Check if Growth / Popular
    final isPopular =
        planName.toLowerCase().contains('growth') ||
        planName.toLowerCase().contains('popular');

    // Visual attributes per plan
    final planColor = _getPlanGradient(planName);
    final planIcon = _getPlanIcon(planName);

    // Dynamic pricing based on selected cycle
    String priceText;
    String subtitleText;

    if (planName.toLowerCase().contains('explore') ||
        (plan.billingCycles == null || plan.billingCycles!.isEmpty)) {
      priceText = '₹0';
      subtitleText = 'Free forever';
    } else {
      final cycleObj = plan.getCycle(selectedCycle);
      final price = cycleObj?.price ?? (plan.monthlyCycle?.price ?? 999);
      priceText = '₹${_formatCurrency(price)}';
      subtitleText = _getCycleSubtitle(selectedCycle);
    }

    // Dynamic features based on selected cycle
    final features = _getFeaturesForPlan(plan, selectedCycle);

    return GestureDetector(
      onTap: () => controller.selectPlan(plan),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0C1724),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00E5FF)
                : const Color(0xFF162534),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.18),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// MOST POPULAR TAG (if applicable)
            if (isPopular)
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3.5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'MOST POPULAR',
                    style: AppStyles.customTextStyle(
                      size: 9.5,
                      color: AppColors.blackColor,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

            /// CARD CONTENT ROW
            Padding(
              padding: EdgeInsets.fromLTRB(14, isPopular ? 10 : 14, 14, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// LEFT COLUMN: Icon + Name + Price
                  SizedBox(
                    width: 95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: planColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            planIcon,
                            color: AppColors.whiteColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          planName,
                          style: AppStyles.customTextStyle(
                            size: 15,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          priceText,
                          style: AppStyles.customTextStyle(
                            size: 17,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          subtitleText,
                          style: AppStyles.customTextStyle(
                            size: 10.5,
                            color: const Color(0xFF94A3B8),
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 6),

                  /// MIDDLE COLUMN: Features
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: features.map((feat) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 13,
                                height: 13,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00E5FF),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.check,
                                  color: AppColors.blackColor,
                                  size: 9.5,
                                  weight: 800,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  feat,
                                  style: AppStyles.customTextStyle(
                                    size: 10.5,
                                    color: const Color(0xFFCBD5E1),
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// RIGHT COLUMN: Button (Select Plan / ✓ Selected)
                  GestureDetector(
                    onTap: () => controller.selectPlan(plan),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 10 : 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF00E5FF)
                            : const Color(0xFF08131E),
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: const Color(0xFF1E3A52),
                                width: 1.2,
                              ),
                      ),
                      child: isSelected
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: AppColors.blackColor,
                                  size: 13,
                                  weight: 800,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Selected',
                                  style: AppStyles.customTextStyle(
                                    size: 11.5,
                                    color: AppColors.blackColor,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Select Plan',
                              style: AppStyles.customTextStyle(
                                size: 11.5,
                                color: AppColors.whiteColor,
                                weight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ENTERPRISE TIER CARD (CUSTOM) ──────────────────────────────────
  Widget _buildEnterpriseCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1724),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF162534), width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// LEFT COLUMN: Icon + Enterprise + Custom
            SizedBox(
              width: 95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE11D48), Color(0xFF9F1239)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      CupertinoIcons.building_2_fill,
                      color: AppColors.whiteColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enterprise',
                    style: AppStyles.customTextStyle(
                      size: 15,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Custom',
                    style: AppStyles.customTextStyle(
                      size: 15,
                      color: const Color(0xFFCBD5E1),
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            /// MIDDLE COLUMN: Features
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEnterpriseFeature('Custom Seats'),
                  _buildEnterpriseFeature('Custom Listings'),
                  _buildEnterpriseFeature('Custom Capacity'),
                  _buildEnterpriseFeature('Dedicated\nSupport'),
                ],
              ),
            ),

            const SizedBox(width: 8),

            /// RIGHT COLUMN: Talk to Sales
            GestureDetector(
              onTap: () => _showTalkToSalesDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF08131E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF1E3A52),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  'Talk to Sales',
                  style: AppStyles.customTextStyle(
                    size: 11.5,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnterpriseFeature(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 13,
            height: 13,
            margin: const EdgeInsets.only(top: 2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00E5FF),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.check,
              color: AppColors.blackColor,
              size: 9.5,
              weight: 800,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              title,
              style: AppStyles.customTextStyle(
                size: 10.5,
                color: const Color(0xFFCBD5E1),
                weight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── GST DISCLAIMER NOTE ─────────────────────────────────────────────
  Widget _buildGstDisclaimer() {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1520),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF142434), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.info_circle_fill,
            color: Color(0xFF00E5FF),
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'All prices exclude applicable GST. Your selected plan will activate after registration and payment.',
              style: AppStyles.customTextStyle(
                size: 11,
                color: const Color(0xFF94A3B8),
                weight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── BOTTOM CONTINUE BUTTON ──────────────────────────────────────────
  // ─── BOTTOM CONTINUE & SKIP BUTTONS ─────────────────────────────────
  Widget _buildBottomButton(NewRecruiterChoosePlanController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF070F18).withValues(alpha: 0.95),
        border: const Border(
          top: BorderSide(color: Color(0xFF101F2E), width: 1),
        ),
      ),
      child: Obx(() {
        final isPaymentLoading = controller.isPaymentLoading.value;
        final isSkipLoading = controller.isSkipLoading.value;
        final isEnabled =
            controller.isContinueEnabled && !isPaymentLoading && !isSkipLoading;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// "Continue to Payment" Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: isEnabled || isPaymentLoading
                    ? const LinearGradient(
                        colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: (isEnabled || isPaymentLoading)
                    ? null
                    : const Color(0xFF152230),
                border: (isEnabled || isPaymentLoading)
                    ? null
                    : Border.all(color: const Color(0xFF1E3547), width: 1),
                boxShadow: (isEnabled || isPaymentLoading)
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: isEnabled
                      ? () => controller.onContinueToPayment()
                      : null,
                  child: Center(
                    child: isPaymentLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CupertinoActivityIndicator(
                              radius: 10,
                              color: AppColors.blackColor,
                            ),
                          )
                        : Text(
                            'Continue to Payment',
                            style: AppStyles.customTextStyle(
                              size: 16,
                              color: isEnabled
                                  ? AppColors.blackColor
                                  : const Color(0xFF64748B),
                              weight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// "Skip For Now" Text Button
            GestureDetector(
              onTap: (isSkipLoading || isPaymentLoading)
                  ? null
                  : () => controller.skipForNow(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: isSkipLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CupertinoActivityIndicator(
                            radius: 9,
                            color: Color(0xFF00E5FF),
                          ),
                        )
                      : Text(
                          'Skip For Now',
                          style: AppStyles.customTextStyle(
                            size: 14,
                            color: const Color(0xFF94A3B8),
                            weight: FontWeight.w600,
                            isUnderlined: true,
                            underlineColor: const Color(0xFF94A3B8),
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ─── HELPER: FEATURES EXTRACTION ─────────────────────────────────────
  List<String> _getFeaturesForPlan(
    RecruiterSubscriptionPlanData plan,
    String selectedCycle,
  ) {
    final name = plan.name?.toLowerCase() ?? '';
    final cycleObj = plan.getCycle(selectedCycle);
    final cycleLabel = _getCycleLabel(selectedCycle);

    if (name.contains('explore')) {
      final seats = plan.coordinatorlimit ?? 1;
      final liveInt = plan.internshipLimit ?? 1;
      final activeInt = plan.activeInternLimit ?? 3;
      final credits = plan.freeCredits ?? 500;
      return [
        '$seats Seat${seats > 1 ? 's' : ''}',
        '$liveInt Live Internship${liveInt > 1 ? 's' : ''}',
        '$activeInt Active Interns',
        '$credits SharkPoints\nonce',
      ];
    }

    if (name.contains('launch')) {
      final seats = plan.coordinatorlimit != null && plan.coordinatorlimit! > 1
          ? plan.coordinatorlimit!
          : 2;
      final liveInt = plan.internshipLimit ?? 3;
      final activeInt =
          plan.activeInternLimit != null && plan.activeInternLimit! > 5
          ? plan.activeInternLimit!
          : 15;
      final credits = cycleObj?.creditLimit ?? 500;
      return [
        '$seats Seats',
        '$liveInt Live Internships',
        '$activeInt Active Interns',
        '${_formatCurrency(credits)} SharkPoints /\n$cycleLabel',
      ];
    }

    if (name.contains('growth')) {
      final seats = plan.coordinatorlimit != null && plan.coordinatorlimit! > 2
          ? plan.coordinatorlimit!
          : 5;
      final liveInt = plan.internshipLimit ?? 10;
      final activeInt =
          plan.activeInternLimit != null && plan.activeInternLimit! > 5
          ? plan.activeInternLimit!
          : 50;
      final credits = cycleObj?.creditLimit ?? 1000;
      return [
        '$seats Seats',
        '$liveInt Live Internships',
        '$activeInt Active Interns',
        '${_formatCurrency(credits)} SharkPoints /\n$cycleLabel',
      ];
    }

    if (name.contains('scale')) {
      final seats = plan.coordinatorlimit ?? 15;
      final liveInt = plan.internshipLimit ?? 30;
      final activeInt = plan.activeInternLimit ?? 200;
      final credits = cycleObj?.creditLimit ?? 10000;
      return [
        '$seats Seats',
        '$liveInt Live Internships',
        '$activeInt Active Interns',
        '${_formatCurrency(credits)} SharkPoints /\n$cycleLabel',
      ];
    }

    // Generic fallback for any other dynamic plans
    final seats = plan.coordinatorlimit ?? 1;
    final liveInt = plan.internshipLimit ?? 1;
    final activeInt = plan.activeInternLimit ?? 5;
    final credits = cycleObj?.creditLimit ?? plan.freeCredits ?? 500;
    return [
      '$seats Seat${seats > 1 ? 's' : ''}',
      '$liveInt Live Internship${liveInt > 1 ? 's' : ''}',
      '$activeInt Active Interns',
      '${_formatCurrency(credits)} SharkPoints /\n$cycleLabel',
    ];
  }

  // ─── HELPER: CYCLE LABELS ────────────────────────────────────────────
  String _getCycleDisplayName(String cycle) {
    final lower = cycle.toLowerCase().trim();
    if (lower == 'monthly') return 'Monthly';
    if (lower == '3months' || lower.contains('3')) return '3 Months';
    if (lower == '6months' || lower.contains('6')) return '6 Months';
    if (lower == 'yearly' || lower.contains('year') || lower == 'annual') {
      return 'Yearly';
    }
    return cycle.capitalizeFirst ?? cycle;
  }

  String _getCycleSubtitle(String cycle) {
    final lower = cycle.toLowerCase().trim();
    if (lower.contains('3')) return '/3 months';
    if (lower.contains('6')) return '/6 months';
    if (lower.contains('year') || lower.contains('annual')) return '/year';
    return '/month';
  }

  String _getCycleLabel(String cycle) {
    final lower = cycle.toLowerCase().trim();
    if (lower.contains('3')) return '3 months';
    if (lower.contains('6')) return '6 months';
    if (lower.contains('year') || lower.contains('annual')) return 'year';
    return 'month';
  }

  // ─── HELPER: GRADIENTS ───────────────────────────────────────────────
  LinearGradient _getPlanGradient(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('explore')) {
      return const LinearGradient(
        colors: [Color(0xFF00ADB5), Color(0xFF007799)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('launch')) {
      return const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('growth')) {
      return const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('scale')) {
      return const LinearGradient(
        colors: [Color(0xFFF97316), Color(0xFFEA580C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // ─── HELPER: ICONS ───────────────────────────────────────────────────
  IconData _getPlanIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('explore')) {
      return CupertinoIcons.paperplane_fill;
    }
    if (lower.contains('launch')) {
      return CupertinoIcons.rocket_fill;
    }
    if (lower.contains('growth')) {
      return CupertinoIcons.chart_bar_fill;
    }
    if (lower.contains('scale')) {
      return CupertinoIcons.person_3_fill;
    }
    return CupertinoIcons.star_fill;
  }

  // ─── HELPER: NUMBER COMMAS ───────────────────────────────────────────
  String _formatCurrency(num? value) {
    if (value == null) return '0';
    final str = value.toInt().toString();
    final regex = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(regex, (match) => '${match[1]},');
  }

  // ─── TALK TO SALES DIALOG ────────────────────────────────────────────
  void _showTalkToSalesDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF0F1A28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1E2D3E), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE11D48), Color(0xFF9F1239)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  CupertinoIcons.building_2_fill,
                  color: AppColors.whiteColor,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Enterprise Custom Plan',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 18,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Need custom seats, custom listings, dedicated account management, or custom billing?\nOur enterprise hiring experts are ready to assist you.',
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 12.5,
                  color: const Color(0xFF94A3B8),
                  weight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      Get.back();
                      Get.snackbar(
                        'Inquiry Sent',
                        'Thank you! Our sales team will reach out within 24 hours.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF10B981),
                        colorText: AppColors.whiteColor,
                        margin: const EdgeInsets.all(16),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Request Callback',
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: AppColors.blackColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Close',
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: const Color(0xFF94A3B8),
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
