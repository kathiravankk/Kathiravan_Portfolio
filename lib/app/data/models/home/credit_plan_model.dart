class CreditPlanModel {
  bool? success;
  List<PlanData>? creditPlan;

  CreditPlanModel({this.success, this.creditPlan});

  factory CreditPlanModel.fromJson(Map<String, dynamic> json) {
    return CreditPlanModel(
      success: json['success'] ?? false,
      creditPlan: (json['data'] as List?)
          ?.map((e) => PlanData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': creditPlan?.map((e) => e.toJson()).toList(),
    };
  }
}

class PlanData {
  String? id;
  int? amount;
  int? credits;
  String? label;

  PlanData({this.id, this.amount, this.credits, this.label});

  factory PlanData.fromJson(Map<String, dynamic> json) {
    return PlanData(
      id: json['id'] ?? "",
      amount: json['amount'] ?? 0,
      credits: json['credits'] ?? 0,
      label: json['label'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'amount': amount, 'credits': credits, 'label': label};
  }
}
