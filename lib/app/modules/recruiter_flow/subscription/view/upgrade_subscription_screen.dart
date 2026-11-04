import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_subscription_plan_model.dart';
import 'package:internsharks/app/modules/recruiter_flow/subscription/controller/upgrade_subscription_controller.dart';

class UpgradeSubscriptionScreen extends StatelessWidget {
  const UpgradeSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UpgradeSubscriptionController>();

    return Container(
      decoration: const BoxDecoration(
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
            icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Upgrade Subscription',
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: AppColors.transparentColor,
        body: SafeArea(
          child: Column(
            children: [
              /// SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER TITLE & SUBTITLE
                      _buildHeader(),

                      const SizedBox(height: 18),

                      /// BILLING CYCLE TOGGLE (Monthly / 3 Months / 6 Months / Annual)
                      Obx(() => _buildBillingCycleToggle(controller)),

                      const SizedBox(height: 20),

                      /// PLANS LIST
                      Obx(() {
                        if (controller.isLoading.value) {
                          return AppAlertUtils.customLoader();
                        }

                        return Column(
                          children: [
                            /// Dynamic API Plans (Explore, Launch, Growth, Scale)
                            ..._buildAllPlanCards(controller),

                            /// Static Enterprise Tier
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

              /// BOTTOM UPGRADE BUTTON
              _buildBottomButton(context, controller),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HEADER TITLE & SUBTITLE ────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Upgrade your ',
                style: AppStyles.customTextStyle(
                  size: 22,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Hiring Power',
                style: AppStyles.customTextStyle(
                  size: 22,
                  color: const Color(0xFF00E5FF),
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Unlock more coordinator seats, live internships, candidate views, and SharkPoints credits.',
          style: AppStyles.customTextStyle(
            size: 13,
            color: const Color(0xFF94A3B8),
            weight: FontWeight.w400,
            lineSpace: 1.3,
          ),
        ),
      ],
    );
  }

  // ─── BILLING CYCLE TOGGLE (DYNAMIC MULTI-CYCLE) ─────────────────────
  Widget _buildBillingCycleToggle(UpgradeSubscriptionController controller) {
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
  List<Widget> _buildAllPlanCards(UpgradeSubscriptionController controller) {
    final plans = List<RecruiterSubscriptionPlanData>.from(controller.planList);

    // If API didn't include "Scale", add it as a fallback plan matching theme
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
    UpgradeSubscriptionController controller,
    RecruiterSubscriptionPlanData plan,
  ) {
    final planName = plan.name?.trim() ?? 'Plan';
    final isSelected = controller.isPlanSelected(plan);
    final selectedCycle = controller.selectedBillingCycle.value;

    // Check if Active Plan
    final isActivePlan = controller.isPlanActive(plan);

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
      subtitleText = 'Free starter plan';
    } else {
      final cycleObj = plan.getCycle(selectedCycle);
      final price = cycleObj?.price ?? (plan.monthlyCycle?.price ?? 999);
      priceText = '₹${_formatCurrency(price)}';
      subtitleText = _getCycleSubtitle(selectedCycle);
    }

    // Dynamic features based on selected cycle
    final features = _getFeaturesForPlan(plan, selectedCycle);

    final hasTopTag = isActivePlan || isPopular;

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
            /// ACTIVE / RECOMMENDED TAGS (if applicable)
            if (hasTopTag)
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isActivePlan)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'ACTIVE',
                          style: AppStyles.customTextStyle(
                            size: 9.5,
                            color: AppColors.blackColor,
                            weight: FontWeight.w800,
                          ),
                        ),
                      ),
                    if (isActivePlan && isPopular) const SizedBox(width: 6),
                    if (isPopular)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'RECOMMENDED',
                          style: AppStyles.customTextStyle(
                            size: 9.5,
                            color: AppColors.blackColor,
                            weight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            /// CARD CONTENT ROW
            Padding(
              padding: EdgeInsets.fromLTRB(14, hasTopTag ? 10 : 14, 14, 14),
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
                            size: 10,
                            color: AppColors.greyTextColor,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// VERTICAL DIVIDER
                  Container(
                    width: 1,
                    height: 90,
                    color: const Color(0xFF162534),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  ),

                  /// RIGHT COLUMN: 4 Features
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: features.map((f) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.5),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.checkmark_alt,
                                color: Color(0xFF00E5FF),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  f,
                                  style: AppStyles.customTextStyle(
                                    size: 11.5,
                                    color: const Color(0xFFCBD5E1),
                                    weight: FontWeight.w400,
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

                  /// RADIO SELECTION INDICATOR
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF00E5FF)
                            : const Color(0xFF475569),
                        width: 1.8,
                      ),
                      color: isSelected
                          ? const Color(0xFF00E5FF)
                          : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: AppColors.blackColor,
                            size: 14,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ENTERPRISE TIER CARD ──────────────────────────────────────────
  Widget _buildEnterpriseCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1724),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF162534), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.business_center_rounded,
                  color: AppColors.whiteColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      'Custom tailored for large organizations',
                      style: AppStyles.customTextStyle(
                        size: 11,
                        color: AppColors.greyTextColor,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF162534), height: 1),
          const SizedBox(height: 12),
          _enterpriseFeature('Unlimited coordinator seats & active internships'),
          _enterpriseFeature('Dedicated account manager & 24/7 priority SLA'),
          _enterpriseFeature('Custom integrations & bulk applicant screening'),
        ],
      ),
    );
  }

  Widget _enterpriseFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.checkmark_alt,
            color: Color(0xFF00E5FF),
            size: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppStyles.customTextStyle(
                size: 11.5,
                color: const Color(0xFFCBD5E1),
                weight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── GST DISCLAIMER ─────────────────────────────────────────────────
  Widget _buildGstDisclaimer() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          '* All prices exclude applicable taxes (18% GST). Upgrades take effect immediately.',
          textAlign: TextAlign.center,
          style: AppStyles.customTextStyle(
            size: 11,
            color: const Color(0xFF64748B),
            weight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ─── BOTTOM UPGRADE BUTTON ──────────────────────────────────────────
  Widget _buildBottomButton(
    BuildContext context,
    UpgradeSubscriptionController controller,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A141E),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF162534).withValues(alpha: 0.7),
            width: 1,
          ),
        ),
      ),
      child: Obx(() {
        final isEnabled = controller.isContinueEnabled;
        final isPaymentLoading = controller.isPaymentLoading.value;

        // Button label with dynamic price if selected
        String buttonText = 'Continue to Payment';
        if (isEnabled) {
          final plan = controller.selectedPlan.value;
          final cycleObj = plan?.getCycle(controller.selectedBillingCycle.value);
          final price = cycleObj?.price ?? plan?.monthlyCycle?.price;
          if (price != null) {
            buttonText =
                'Upgrade to ${controller.selectedPlanName.value} • ₹${_formatCurrency(price)}';
          }
        } else {
          final name = controller.selectedPlanName.value.toLowerCase();
          if (name.contains('explore')) {
            buttonText = 'Choose Launch, Growth, or Scale';
          } else if (controller.isCurrentPlanAndCycleSelected) {
            buttonText = 'Current Active Plan';
          } else {
            buttonText = 'Select a Plan to Upgrade';
          }
        }

        return Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: isEnabled || isPaymentLoading
                ? const LinearGradient(
                    //colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                    colors: [AppColors.buttonGrad1, AppColors.buttonGrad2],
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
              onTap: (isEnabled && !isPaymentLoading)
                  ? () => controller.onContinueToPayment(context)
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
                        buttonText,
                        style: AppStyles.customTextStyle(
                          size: 15,
                          color: isEnabled
                              ? AppColors.blackColor
                              : const Color(0xFF64748B),
                          weight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
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
        '$seats Coordinator Seat',
        '$liveInt Live Internship',
        '$activeInt Active Interns',
        '$credits SharkPoints',
      ];
    }

    if (name.contains('launch')) {
      final seats = plan.coordinatorlimit != null && plan.coordinatorlimit! > 1
          ? plan.coordinatorlimit!
          : 2;
      final liveInt = plan.internshipLimit ?? 3;
      final activeInt = plan.activeInternLimit ?? 15;
      final credits = cycleObj?.creditLimit ?? 1500;
      return [
        '$seats Coordinator Seats',
        '$liveInt Live Internships',
        '$activeInt Active Interns',
        '$credits SharkPoints / $cycleLabel',
      ];
    }

    if (name.contains('growth')) {
      final seats = plan.coordinatorlimit ?? 5;
      final liveInt = plan.internshipLimit ?? 10;
      final activeInt = plan.activeInternLimit ?? 60;
      final credits = cycleObj?.creditLimit ?? 4000;
      return [
        '$seats Coordinator Seats',
        '$liveInt Live Internships',
        '$activeInt Active Interns',
        '$credits SharkPoints / $cycleLabel',
      ];
    }

    if (name.contains('scale')) {
      final seats = plan.coordinatorlimit ?? 15;
      final liveInt = plan.internshipLimit ?? 30;
      final activeInt = plan.activeInternLimit ?? 200;
      final credits = cycleObj?.creditLimit ?? 10000;
      return [
        '$seats Coordinator Seats',
        '$liveInt Live Internships',
        '$activeInt Active Interns',
        '$credits SharkPoints / $cycleLabel',
      ];
    }

    return [
      '${plan.coordinatorlimit ?? 1} Coordinator Seats',
      '${plan.internshipLimit ?? 1} Live Internships',
      '${plan.activeInternLimit ?? 1} Active Interns',
      'Active credit allocation',
    ];
  }

  // ─── HELPERS: VISUAL ATTRIBUTES ──────────────────────────────────────
  LinearGradient _getPlanGradient(String name) {
    final n = name.toLowerCase();
    if (n.contains('explore')) {
      return const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (n.contains('launch')) {
      return const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (n.contains('growth')) {
      return const LinearGradient(
        colors: [Color(0xFF00E5FF), Color(0xFF0284C7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (n.contains('scale')) {
      return const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  IconData _getPlanIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('explore')) return Icons.explore_outlined;
    if (n.contains('launch')) return Icons.rocket_launch_outlined;
    if (n.contains('growth')) return Icons.trending_up_rounded;
    if (n.contains('scale')) return Icons.bar_chart_rounded;
    return Icons.star_border_rounded;
  }

  String _getCycleDisplayName(String cycle) {
    switch (cycle.toLowerCase().trim()) {
      case 'monthly':
        return 'Monthly';
      case '3months':
        return '3 Months';
      case '6months':
        return '6 Months';
      case 'yearly':
      case 'annual':
        return 'Annual';
      default:
        return cycle.capitalizeFirst ?? cycle;
    }
  }

  String _getCycleSubtitle(String cycle) {
    switch (cycle.toLowerCase().trim()) {
      case 'monthly':
        return '/ month';
      case '3months':
        return '/ quarter';
      case '6months':
        return '/ 6 months';
      case 'yearly':
      case 'annual':
        return '/ year';
      default:
        return '/ $cycle';
    }
  }

  String _getCycleLabel(String cycle) {
    switch (cycle.toLowerCase().trim()) {
      case 'monthly':
        return 'mo';
      case '3months':
        return '3mo';
      case '6months':
        return '6mo';
      case 'yearly':
      case 'annual':
        return 'yr';
      default:
        return cycle;
    }
  }

  String _formatCurrency(num value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
