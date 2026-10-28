class RecruiterSubscriptionPlanModel {
  final bool? success;
  final String? message;
  final int? count;
  final List<RecruiterSubscriptionPlanData>? data;

  RecruiterSubscriptionPlanModel({
    this.success,
    this.message,
    this.count,
    this.data,
  });

  factory RecruiterSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return RecruiterSubscriptionPlanModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      count: json['count'] is int
          ? json['count'] as int
          : int.tryParse(json['count']?.toString() ?? ''),
      data: json['data'] == null
          ? []
          : List<RecruiterSubscriptionPlanData>.from(
              (json['data'] as List).map(
                (x) => RecruiterSubscriptionPlanData.fromJson(
                  x as Map<String, dynamic>,
                ),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'count': count,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

class RecruiterSubscriptionPlanData {
  final String? id;
  final String? name;
  final List<SubscriptionBillingCycle>? billingCycles;
  final int? coordinatorlimit;
  final int? internshipLimit;
  final int? activeInternLimit;
  final bool? isActive;
  final bool? isDeleted;
  final int? freeCredits;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  RecruiterSubscriptionPlanData({
    this.id,
    this.name,
    this.billingCycles,
    this.coordinatorlimit,
    this.internshipLimit,
    this.activeInternLimit,
    this.isActive,
    this.isDeleted,
    this.freeCredits,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory RecruiterSubscriptionPlanData.fromJson(Map<String, dynamic> json) {
    return RecruiterSubscriptionPlanData(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      billingCycles: json['billingCycles'] == null
          ? []
          : List<SubscriptionBillingCycle>.from(
              (json['billingCycles'] as List).map(
                (x) => SubscriptionBillingCycle.fromJson(
                  x as Map<String, dynamic>,
                ),
              ),
            ),
      coordinatorlimit: json['coordinatorlimit'] is int
          ? json['coordinatorlimit'] as int
          : int.tryParse(json['coordinatorlimit']?.toString() ?? ''),
      internshipLimit: json['internshipLimit'] is int
          ? json['internshipLimit'] as int
          : int.tryParse(json['internshipLimit']?.toString() ?? ''),
      activeInternLimit: json['activeInternLimit'] is int
          ? json['activeInternLimit'] as int
          : int.tryParse(json['activeInternLimit']?.toString() ?? ''),
      isActive: json['isActive'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      freeCredits: json['freeCredits'] is int
          ? json['freeCredits'] as int
          : int.tryParse(json['freeCredits']?.toString() ?? ''),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] is int
          ? json['__v'] as int
          : int.tryParse(json['__v']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'billingCycles': billingCycles?.map((e) => e.toJson()).toList(),
        'coordinatorlimit': coordinatorlimit,
        'internshipLimit': internshipLimit,
        'activeInternLimit': activeInternLimit,
        'isActive': isActive,
        'isDeleted': isDeleted,
        'freeCredits': freeCredits,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };

  SubscriptionBillingCycle? get monthlyCycle {
    if (billingCycles == null || billingCycles!.isEmpty) return null;
    try {
      return billingCycles!.firstWhere(
        (c) => c.cycle?.toLowerCase().contains('month') == true &&
            !c.cycle!.toLowerCase().contains('3') &&
            !c.cycle!.toLowerCase().contains('6'),
      );
    } catch (_) {
      return billingCycles!.first;
    }
  }

  SubscriptionBillingCycle? get yearlyCycle {
    if (billingCycles == null || billingCycles!.isEmpty) return null;
    try {
      return billingCycles!.firstWhere(
        (c) =>
            c.cycle?.toLowerCase().contains('year') == true ||
            c.cycle?.toLowerCase().contains('annual') == true,
      );
    } catch (_) {
      return billingCycles!.last;
    }
  }

  SubscriptionBillingCycle? getCycle(String cycleName) {
    if (billingCycles == null || billingCycles!.isEmpty) return null;
    final target = cycleName.toLowerCase().trim();
    for (var c in billingCycles!) {
      if (c.cycle?.toLowerCase().trim() == target) {
        return c;
      }
    }
    if (target == 'yearly' || target == 'annual') {
      return yearlyCycle;
    }
    if (target == 'monthly') {
      return monthlyCycle;
    }
    return billingCycles!.first;
  }
}

class SubscriptionBillingCycle {
  final String? id;
  final String? cycle;
  final num? price;
  final int? creditLimit;

  SubscriptionBillingCycle({
    this.id,
    this.cycle,
    this.price,
    this.creditLimit,
  });

  factory SubscriptionBillingCycle.fromJson(Map<String, dynamic> json) {
    return SubscriptionBillingCycle(
      id: json['_id'] as String?,
      cycle: json['cycle'] as String?,
      price: json['price'] as num?,
      creditLimit: json['creditLimit'] is int
          ? json['creditLimit'] as int
          : int.tryParse(json['creditLimit']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'cycle': cycle,
        'price': price,
        'creditLimit': creditLimit,
      };
}
