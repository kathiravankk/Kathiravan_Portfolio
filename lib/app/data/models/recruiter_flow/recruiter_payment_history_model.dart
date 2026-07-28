class RecruiterPaymentHistoryModel {
  final bool? success;
  final int? totalRecords;
  final int? totalPages;
  final int? currentPage;
  final int? limit;
  final int? count;
  final List<PaymentHisData>? payment;

  RecruiterPaymentHistoryModel({
    this.success,
    this.totalRecords,
    this.totalPages,
    this.currentPage,
    this.limit,
    this.count,
    this.payment,
  });

  factory RecruiterPaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return RecruiterPaymentHistoryModel(
      success: json["success"],
      totalRecords: json["totalRecords"],
      totalPages: json["totalPages"],
      currentPage: json["currentPage"],
      limit: json["limit"],
      count: json["count"],
      payment: json["payment"] != null
          ? List<PaymentHisData>.from(
        json["payment"].map((x) => PaymentHisData.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "totalRecords": totalRecords,
      "totalPages": totalPages,
      "currentPage": currentPage,
      "limit": limit,
      "count": count,
      "payment": payment?.map((e) => e.toJson()).toList(),
    };
  }
}

class PaymentHisData {
  final String? id;
  final String? orderId;
  final RecruiterData? recruiterId;
  final String? creditId;
  final int? amount;
  final String? currency;
  final String? status;
  final int? creditsAdded;
  final String? planName;
  final String? planId;
  final bool? isActive;
  final dynamic deletedAt;
  final dynamic deletedBy;
  final String? createdAt;
  final int? v;
  final String? paidAt;
  final String? paymentId;

  PaymentHisData({
    this.id,
    this.orderId,
    this.recruiterId,
    this.creditId,
    this.amount,
    this.currency,
    this.status,
    this.creditsAdded,
    this.planName,
    this.planId,
    this.isActive,
    this.deletedAt,
    this.deletedBy,
    this.createdAt,
    this.v,
    this.paidAt,
    this.paymentId,
  });

  factory PaymentHisData.fromJson(Map<String, dynamic> json) {
    return PaymentHisData(
      id: json["_id"],
      orderId: json["orderId"],
      recruiterId: json["recruiterId"] != null
          ? RecruiterData.fromJson(json["recruiterId"])
          : null,
      creditId: json["creditId"],
      amount: json["amount"],
      currency: json["currency"],
      status: json["status"],
      creditsAdded: json["creditsadded"],
      planName: json["planname"],
      planId: json["planid"],
      isActive: json["isActive"],
      deletedAt: json["deletedAt"],
      deletedBy: json["deletedBy"],
      createdAt: json["createdAt"],
      v: json["__v"],
      paidAt: json["paidAt"],
      paymentId: json["paymentId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "orderId": orderId,
      "recruiterId": recruiterId?.toJson(),
      "creditId": creditId,
      "amount": amount,
      "currency": currency,
      "status": status,
      "creditsadded": creditsAdded,
      "planname": planName,
      "planid": planId,
      "isActive": isActive,
      "deletedAt": deletedAt,
      "deletedBy": deletedBy,
      "createdAt": createdAt,
      "__v": v,
      "paidAt": paidAt,
      "paymentId": paymentId,
    };
  }
}

class RecruiterData {
  final String? id;
  final String? recName;
  final String? recEmail;
  final String? recMobileNo;
  final RecruiterCreditData? recruiterCreditId;

  RecruiterData({
    this.id,
    this.recName,
    this.recEmail,
    this.recMobileNo,
    this.recruiterCreditId,
  });

  factory RecruiterData.fromJson(Map<String, dynamic> json) {
    return RecruiterData(
      id: json["_id"],
      recName: json["recname"],
      recEmail: json["recemail"],
      recMobileNo: json["recmobileno"],
      recruiterCreditId: json["recruiterCreditId"] != null
          ? RecruiterCreditData.fromJson(json["recruiterCreditId"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "recname": recName,
      "recemail": recEmail,
      "recmobileno": recMobileNo,
      "recruiterCreditId": recruiterCreditId?.toJson(),
    };
  }
}

class RecruiterCreditData {
  final String? id;
  final int? balance;

  RecruiterCreditData({
    this.id,
    this.balance,
  });

  factory RecruiterCreditData.fromJson(Map<String, dynamic> json) {
    return RecruiterCreditData(
      id: json["_id"],
      balance: json["balance"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "balance": balance,
    };
  }
}