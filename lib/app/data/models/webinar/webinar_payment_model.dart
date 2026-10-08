class WebinarPaymentOrderResponse {
  bool? success;
  String? message;
  WebinarPaymentOrderData? data;

  WebinarPaymentOrderResponse({this.success, this.message, this.data});

  WebinarPaymentOrderResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? '';
    data = json['data'] != null && json['data'] is Map<String, dynamic>
        ? WebinarPaymentOrderData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class WebinarPaymentOrderData {
  String? paymentId;
  String? orderId;
  String? paymentSessionId;
  dynamic amount;
  String? currency;
  String? webinarId;
  String? environment;

  WebinarPaymentOrderData({
    this.paymentId,
    this.orderId,
    this.paymentSessionId,
    this.amount,
    this.currency,
    this.webinarId,
    this.environment,
  });

  WebinarPaymentOrderData.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'] ?? json['_id'];
    orderId = json['orderId'] ?? '';
    paymentSessionId = json['paymentSessionId'] ?? '';
    amount = json['amount'];
    currency = json['currency'] ?? 'INR';
    webinarId = json['webinarId'] ?? '';
    environment = json['environment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['paymentId'] = paymentId;
    map['orderId'] = orderId;
    map['paymentSessionId'] = paymentSessionId;
    map['amount'] = amount;
    map['currency'] = currency;
    map['webinarId'] = webinarId;
    map['environment'] = environment;
    return map;
  }
}

class WebinarPaymentVerifyResponse {
  bool? success;
  String? message;
  WebinarPaymentVerifyData? data;

  WebinarPaymentVerifyResponse({this.success, this.message, this.data});

  WebinarPaymentVerifyResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? '';
    data = json['data'] != null && json['data'] is Map<String, dynamic>
        ? WebinarPaymentVerifyData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class WebinarPaymentVerifyData {
  String? paymentId;
  String? orderId;
  String? webinarId;
  dynamic amount;
  String? currency;
  String? paymentStatus;
  String? registrationStatus;

  WebinarPaymentVerifyData({
    this.paymentId,
    this.orderId,
    this.webinarId,
    this.amount,
    this.currency,
    this.paymentStatus,
    this.registrationStatus,
  });

  WebinarPaymentVerifyData.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'] ?? json['_id'];
    orderId = json['orderId'] ?? '';
    webinarId = json['webinarId'] ?? '';
    amount = json['amount'];
    currency = json['currency'] ?? 'INR';
    paymentStatus = json['paymentStatus'];
    registrationStatus = json['registrationStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['paymentId'] = paymentId;
    map['orderId'] = orderId;
    map['webinarId'] = webinarId;
    map['amount'] = amount;
    map['currency'] = currency;
    map['paymentStatus'] = paymentStatus;
    map['registrationStatus'] = registrationStatus;
    return map;
  }
}
