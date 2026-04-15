class OrderCreateCreditModel {
  bool? success;
  String? orderId;
  String? paymentSessionId;
  int? amount;
  String? environment;

  OrderCreateCreditModel({
    this.success,
    this.orderId,
    this.paymentSessionId,
    this.amount,
    this.environment,
  });

  factory OrderCreateCreditModel.fromJson(Map<String, dynamic> json) {
    return OrderCreateCreditModel(
      success: json['success'] ?? false,
      orderId: json['orderId'] ?? "",
      paymentSessionId: json['paymentSessionId'] ?? "",
      amount: json['amount'] ?? 0,
      environment: json['environment'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'orderId': orderId,
      'paymentSessionId': paymentSessionId,
      'amount': amount,
      'environment': environment,
    };
  }
}
