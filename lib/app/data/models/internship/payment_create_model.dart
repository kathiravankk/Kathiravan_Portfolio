class PaymentCreateModel {
  bool? success;
  String? message;
  String? orderId;
  String? paymentSessionId;

  PaymentCreateModel({
    this.success,
    this.message,
    this.orderId,
    this.paymentSessionId,
  });

  factory PaymentCreateModel.fromJson(Map<String, dynamic> json) {
    return PaymentCreateModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      orderId: json["orderId"] ?? "",
      paymentSessionId: json["paymentSessionId"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "orderId": orderId,
      "paymentSessionId": paymentSessionId,
    };
  }
}
