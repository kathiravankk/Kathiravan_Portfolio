class StudentPurchaseHistoryModel {
  bool? success;
  int? totalRecords;
  int? totalPages;
  int? currentPage;
  int? limit;
  int? count;
  List<StudentPurchaseData>? purchaseList;

  StudentPurchaseHistoryModel({
    this.success,
    this.totalRecords,
    this.totalPages,
    this.currentPage,
    this.limit,
    this.count,
    this.purchaseList,
  });

  factory StudentPurchaseHistoryModel.fromJson(
      Map<String, dynamic> json) {
    return StudentPurchaseHistoryModel(
      success: json["success"],
      totalRecords: json["totalRecords"],
      totalPages: json["totalPages"],
      currentPage: json["currentPage"],
      limit: json["limit"],
      count: json["count"],
      purchaseList: json["payment"] != null
          ? (json["payment"] as List)
          .map((e) => StudentPurchaseData.fromJson(e))
          .toList()
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
      "payment": purchaseList?.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentPurchaseData {
  String? id;
  String? orderId;
  StudentInfo? studentId;
  String? creditId;
  int? amount;
  String? currency;
  String? status;
  int? creditsAdded;
  String? planName;
  String? planId;
  bool? isActive;
  dynamic deletedAt;
  dynamic deletedBy;
  String? createdAt;
  int? v;
  String? paidAt;
  String? paymentId;

  StudentPurchaseData({
    this.id,
    this.orderId,
    this.studentId,
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

  factory StudentPurchaseData.fromJson(Map<String, dynamic> json) {
    return StudentPurchaseData(
      id: json["_id"],
      orderId: json["orderId"],
      studentId: json["studentId"] != null
          ? StudentInfo.fromJson(json["studentId"])
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
      "studentId": studentId?.toJson(),
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

class StudentInfo {
  String? id;
  String? studName;
  String? studEmail;
  String? studMobileNo;
  StudentCredit? studentCreditId;

  StudentInfo({
    this.id,
    this.studName,
    this.studEmail,
    this.studMobileNo,
    this.studentCreditId,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: json["_id"],
      studName: json["studname"],
      studEmail: json["studemail"],
      studMobileNo: json["studmobileno"],
      studentCreditId: json["studentCreditId"] != null
          ? StudentCredit.fromJson(json["studentCreditId"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "studname": studName,
      "studemail": studEmail,
      "studmobileno": studMobileNo,
      "studentCreditId": studentCreditId?.toJson(),
    };
  }
}

class StudentCredit {
  String? id;
  int? balance;

  StudentCredit({
    this.id,
    this.balance,
  });

  factory StudentCredit.fromJson(Map<String, dynamic> json) {
    return StudentCredit(
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