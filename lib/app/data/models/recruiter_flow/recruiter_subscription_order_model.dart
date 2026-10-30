class RecruiterSubscriptionOrderModel {
  bool? success;
  String? message;
  RecruiterSubscriptionOrderData? data;

  RecruiterSubscriptionOrderModel({
    this.success,
    this.message,
    this.data,
  });

  factory RecruiterSubscriptionOrderModel.fromJson(Map<String, dynamic> json) {
    return RecruiterSubscriptionOrderModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? RecruiterSubscriptionOrderData.fromJson(json['data'])
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

class RecruiterSubscriptionOrderData {
  String? subscriptionId;
  String? planName;
  String? billingCycle;
  dynamic amount;
  String? orderId;
  String? paymentSessionId;
  String? environment;

  RecruiterSubscriptionOrderData({
    this.subscriptionId,
    this.planName,
    this.billingCycle,
    this.amount,
    this.orderId,
    this.paymentSessionId,
    this.environment,
  });

  factory RecruiterSubscriptionOrderData.fromJson(Map<String, dynamic> json) {
    return RecruiterSubscriptionOrderData(
      subscriptionId: json['subscriptionId'] ?? '',
      planName: json['planName'] ?? '',
      billingCycle: json['billingCycle'] ?? '',
      amount: json['amount'],
      orderId: json['orderId'] ?? '',
      paymentSessionId: json['paymentSessionId'] ?? '',
      environment: json['environment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptionId': subscriptionId,
      'planName': planName,
      'billingCycle': billingCycle,
      'amount': amount,
      'orderId': orderId,
      'paymentSessionId': paymentSessionId,
      'environment': environment,
    };
  }
}

class RecruiterSubscriptionVerifyModel {
  bool? success;
  String? message;
  RecruiterSubscriptionVerifyData? data;

  RecruiterSubscriptionVerifyModel({
    this.success,
    this.message,
    this.data,
  });

  factory RecruiterSubscriptionVerifyModel.fromJson(Map<String, dynamic> json) {
    return RecruiterSubscriptionVerifyModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? RecruiterSubscriptionVerifyData.fromJson(json['data'])
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

class RecruiterSubscriptionVerifyData {
  SubscriptionDetails? subscription;
  SubscriptionWallet? wallet;

  RecruiterSubscriptionVerifyData({this.subscription, this.wallet});

  factory RecruiterSubscriptionVerifyData.fromJson(Map<String, dynamic> json) {
    return RecruiterSubscriptionVerifyData(
      subscription: json['subscription'] != null
          ? SubscriptionDetails.fromJson(json['subscription'])
          : null,
      wallet: json['wallet'] != null
          ? SubscriptionWallet.fromJson(json['wallet'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscription': subscription?.toJson(),
      'wallet': wallet?.toJson(),
    };
  }
}

class SubscriptionDetails {
  String? id;
  String? recruiterId;
  String? planId;
  String? planName;
  String? billingCycle;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  String? nextBillingDate;
  String? subscriptionStatus;
  String? paymentStatus;
  bool? autoRenew;
  num? seatLimit;
  num? internshipLimit;
  num? activeInternLimit;
  num? coordinatorlimit;
  num? creditLimit;
  num? price;
  String? orderId;
  String? paymentId;

  SubscriptionDetails({
    this.id,
    this.recruiterId,
    this.planId,
    this.planName,
    this.billingCycle,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.nextBillingDate,
    this.subscriptionStatus,
    this.paymentStatus,
    this.autoRenew,
    this.seatLimit,
    this.internshipLimit,
    this.activeInternLimit,
    this.coordinatorlimit,
    this.creditLimit,
    this.price,
    this.orderId,
    this.paymentId,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      id: json['_id'] ?? '',
      recruiterId: json['recruiterId'] ?? '',
      planId: json['planId'] ?? '',
      planName: json['planName'] ?? '',
      billingCycle: json['billingCycle'] ?? '',
      subscriptionStartDate: json['subscriptionStartDate'] ?? '',
      subscriptionEndDate: json['subscriptionEndDate'] ?? '',
      nextBillingDate: json['nextBillingDate'] ?? '',
      subscriptionStatus: json['subscriptionStatus'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      autoRenew: json['autoRenew'] ?? false,
      seatLimit: json['seatLimit'],
      internshipLimit: json['internshipLimit'],
      activeInternLimit: json['activeInternLimit'],
      coordinatorlimit: json['coordinatorlimit'],
      creditLimit: json['creditLimit'],
      price: json['price'],
      orderId: json['orderId'] ?? '',
      paymentId: json['paymentId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recruiterId': recruiterId,
      'planId': planId,
      'planName': planName,
      'billingCycle': billingCycle,
      'subscriptionStartDate': subscriptionStartDate,
      'subscriptionEndDate': subscriptionEndDate,
      'nextBillingDate': nextBillingDate,
      'subscriptionStatus': subscriptionStatus,
      'paymentStatus': paymentStatus,
      'autoRenew': autoRenew,
      'seatLimit': seatLimit,
      'internshipLimit': internshipLimit,
      'activeInternLimit': activeInternLimit,
      'coordinatorlimit': coordinatorlimit,
      'creditLimit': creditLimit,
      'price': price,
      'orderId': orderId,
      'paymentId': paymentId,
    };
  }
}

class SubscriptionWallet {
  String? id;
  String? recruiterId;
  num? exploreCredits;
  num? subscriptionCredits;
  num? purchasedCredits;
  num? balance;
  num? totalUsed;

  SubscriptionWallet({
    this.id,
    this.recruiterId,
    this.exploreCredits,
    this.subscriptionCredits,
    this.purchasedCredits,
    this.balance,
    this.totalUsed,
  });

  factory SubscriptionWallet.fromJson(Map<String, dynamic> json) {
    return SubscriptionWallet(
      id: json['_id'] ?? '',
      recruiterId: json['recruiterId'] ?? '',
      exploreCredits: json['exploreCredits'] ?? 0,
      subscriptionCredits: json['subscriptionCredits'] ?? 0,
      purchasedCredits: json['purchasedCredits'] ?? 0,
      balance: json['balance'] ?? 0,
      totalUsed: json['totalUsed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recruiterId': recruiterId,
      'exploreCredits': exploreCredits,
      'subscriptionCredits': subscriptionCredits,
      'purchasedCredits': purchasedCredits,
      'balance': balance,
      'totalUsed': totalUsed,
    };
  }
}
