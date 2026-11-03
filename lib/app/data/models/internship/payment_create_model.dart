class PaymentCreateModel {
  bool? success;
  String? message;
  String? orderId;
  String? paymentSessionId;
  String? environment;

  PaymentCreateModel({
    this.success,
    this.message,
    this.orderId,
    this.paymentSessionId,
    this.environment,
  });

  factory PaymentCreateModel.fromJson(Map<String, dynamic> json) {
    return PaymentCreateModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      orderId: json["orderId"] ?? "",
      paymentSessionId: json["paymentSessionId"] ?? "",
      environment: json["environment"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "orderId": orderId,
      "paymentSessionId": paymentSessionId,
      "environment": environment,
    };
  }
}
