class PaymentStatusModel {
  bool? success;
  String? status;
  String? message;
  int? feeAmount;

  PaymentStatusModel({
    this.success,
    this.status,
    this.message,
    this.feeAmount,
  });

  PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['success']?? false;
    status = json['status']??"";
    message = json['message']??"";
    feeAmount = json['feeAmount']??0;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'message': message,
      'feeAmount': feeAmount,
    };
  }
}