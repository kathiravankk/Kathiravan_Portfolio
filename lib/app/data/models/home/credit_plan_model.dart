class CreditPlanModel {
  bool? success;
  String? message;
  int? count;
  List<PlanData>? creditPlan;

  CreditPlanModel({
    this.success,
    this.message,
    this.count,
    this.creditPlan,
  });

  factory CreditPlanModel.fromJson(Map<String, dynamic> json) {
    return CreditPlanModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      count: json['count'] ?? 0,
      creditPlan: (json['data'] as List?)
          ?.map((e) => PlanData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'count': count,
      'data': creditPlan?.map((e) => e.toJson()).toList(),
    };
  }
}

class PlanData {
  String? id;
  int? amount;
  int? credits;
  String? label;
  String? createdAt;
  String? updatedAt;
  int? v;

  PlanData({
    this.id,
    this.amount,
    this.credits,
    this.label,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PlanData.fromJson(Map<String, dynamic> json) {
    return PlanData(
      id: json['_id'] ?? "",
      amount: json['amount'] ?? 0,
      credits: json['credits'] ?? 0,
      label: json['label'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'amount': amount,
      'credits': credits,
      'label': label,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}