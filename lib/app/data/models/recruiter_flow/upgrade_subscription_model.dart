class UpgradeSubscriptionOrderModel {
  bool? success;
  String? message;
  UpgradeSubscriptionOrderData? data;

  UpgradeSubscriptionOrderModel({
    this.success,
    this.message,
    this.data,
  });

  factory UpgradeSubscriptionOrderModel.fromJson(Map<String, dynamic> json) {
    return UpgradeSubscriptionOrderModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? UpgradeSubscriptionOrderData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class UpgradeSubscriptionOrderData {
  String? upgradeId;
  String? orderId;
  String? paymentSessionId;
  String? oldPlanName;
  String? newPlanName;
  String? billingCycle;
  num? originalPrice;
  num? discountAmount;
  num? finalPrice;
  num? remainingDays;
  String? environment;

  UpgradeSubscriptionOrderData({
    this.upgradeId,
    this.orderId,
    this.paymentSessionId,
    this.oldPlanName,
    this.newPlanName,
    this.billingCycle,
    this.originalPrice,
    this.discountAmount,
    this.finalPrice,
    this.remainingDays,
    this.environment,
  });

  factory UpgradeSubscriptionOrderData.fromJson(Map<String, dynamic> json) {
    return UpgradeSubscriptionOrderData(
      upgradeId: json['upgradeId']?.toString(),
      orderId: json['orderId']?.toString(),
      paymentSessionId: json['paymentSessionId']?.toString(),
      oldPlanName: json['oldPlanName']?.toString(),
      newPlanName: json['newPlanName']?.toString(),
      billingCycle: json['billingCycle']?.toString(),
      originalPrice: json['originalPrice'],
      discountAmount: json['discountAmount'],
      finalPrice: json['finalPrice'],
      remainingDays: json['remainingDays'],
      environment: json['environment']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'upgradeId': upgradeId,
      'orderId': orderId,
      'paymentSessionId': paymentSessionId,
      'oldPlanName': oldPlanName,
      'newPlanName': newPlanName,
      'billingCycle': billingCycle,
      'originalPrice': originalPrice,
      'discountAmount': discountAmount,
      'finalPrice': finalPrice,
      'remainingDays': remainingDays,
      'environment': environment,
    };
  }
}

class UpgradeSubscriptionVerifyModel {
  bool? success;
  String? message;
  dynamic data;
  dynamic error;

  UpgradeSubscriptionVerifyModel({
    this.success,
    this.message,
    this.data,
    this.error,
  });

  factory UpgradeSubscriptionVerifyModel.fromJson(Map<String, dynamic> json) {
    String msg = json['message']?.toString() ?? '';
    if (msg.isEmpty && json['error'] is Map && json['error']['message'] != null) {
      msg = json['error']['message'].toString();
    }
    return UpgradeSubscriptionVerifyModel(
      success: json['success'] ?? false,
      message: msg,
      data: json['data'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'error': error,
    };
  }
}
