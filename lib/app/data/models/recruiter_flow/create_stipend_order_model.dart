class CreateStipendOrderModel {
  CreateStipendOrderModel({
    this.success,
    this.message,
    this.paymentSessionId,
    this.orderId,
    this.environment,
  });

  final bool? success;
  final String? message;
  final String? paymentSessionId;
  final String? orderId;
  final String? environment;

  factory CreateStipendOrderModel.fromJson(
      Map<String, dynamic> json) {
    return CreateStipendOrderModel(
      success: json["success"]??false,
      message: json["message"]??"",
      paymentSessionId: json["paymentSessionId"]??"",
      orderId: json["orderId"]??"",
      environment: json["environment"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "paymentSessionId": paymentSessionId,
      "orderId": orderId,
      "environment": environment,
    };
  }
}