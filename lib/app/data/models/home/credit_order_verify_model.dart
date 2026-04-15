class CreditOrderVerifyModel {
  bool? success;
  String? message;
  String? orderStatus;

  CreditOrderVerifyModel({
    this.success,
    this.message,
    this.orderStatus,
  });

  factory CreditOrderVerifyModel.fromJson(Map<String, dynamic> json) {
    return CreditOrderVerifyModel(
      success: json['success']?? false,
      message: json['message']??"",
      orderStatus: json['orderStatus']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'orderStatus': orderStatus,
    };
  }
}