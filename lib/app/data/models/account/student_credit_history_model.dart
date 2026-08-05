class StudentCreditHistoryModel {
  bool? success;
  String? message;
  int? count;
  Pagination? pagination;
  List<CreditHistoryData>? historyList;

  StudentCreditHistoryModel({
    this.success,
    this.message,
    this.count,
    this.pagination,
    this.historyList,
  });

  factory StudentCreditHistoryModel.fromJson(
      Map<String, dynamic> json) {
    return StudentCreditHistoryModel(
      success: json["success"],
      message: json["message"],
      count: json["count"],
      pagination: json["pagination"] != null
          ? Pagination.fromJson(json["pagination"])
          : null,
      historyList: json["data"] != null
          ? (json["data"] as List)
          .map((e) => CreditHistoryData.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "count": count,
      "pagination": pagination?.toJson(),
      "data": historyList?.map((e) => e.toJson()).toList(),
    };
  }
}

class Pagination {
  int? current;
  int? pageSize;
  int? total;

  Pagination({
    this.current,
    this.pageSize,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      current: json["current"],
      pageSize: json["pageSize"],
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "current": current,
      "pageSize": pageSize,
      "total": total,
    };
  }
}

class CreditHistoryData {
  String? id;
  Student? student;
  StudentCredit? stuCreditId;
  String? apiName;
  int? credits;
  String? role;
  String? type;
  String? status;
  int? balanceAfter;
  int? freeCreditsUsed;
  int? balanceCreditsUsed;
  int? freeCreditsAfter;
  dynamic referenceTransaction;
  String? createdAt;
  int? v;

  CreditHistoryData({
    this.id,
    this.student,
    this.stuCreditId,
    this.apiName,
    this.credits,
    this.role,
    this.type,
    this.status,
    this.balanceAfter,
    this.freeCreditsUsed,
    this.balanceCreditsUsed,
    this.freeCreditsAfter,
    this.referenceTransaction,
    this.createdAt,
    this.v,
  });

  factory CreditHistoryData.fromJson(Map<String, dynamic> json) {
    return CreditHistoryData(
      id: json["_id"],
      student: json["student"] != null
          ? Student.fromJson(json["student"])
          : null,
      stuCreditId: json["stucreditId"] != null
          ? StudentCredit.fromJson(json["stucreditId"])
          : null,
      apiName: json["apiName"],
      credits: json["credits"],
      role: json["role"],
      type: json["type"],
      status: json["status"],
      balanceAfter: json["balanceAfter"],
      freeCreditsUsed: json["freeCreditsUsed"],
      balanceCreditsUsed: json["balanceCreditsUsed"],
      freeCreditsAfter: json["freeCreditsAfter"],
      referenceTransaction: json["referenceTransaction"],
      createdAt: json["createdAt"],
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "student": student?.toJson(),
      "stucreditId": stuCreditId?.toJson(),
      "apiName": apiName,
      "credits": credits,
      "role": role,
      "type": type,
      "status": status,
      "balanceAfter": balanceAfter,
      "freeCreditsUsed": freeCreditsUsed,
      "balanceCreditsUsed": balanceCreditsUsed,
      "freeCreditsAfter": freeCreditsAfter,
      "referenceTransaction": referenceTransaction,
      "createdAt": createdAt,
      "__v": v,
    };
  }
}

class Student {
  String? id;
  String? studName;
  String? studEmail;
  String? studMobileNo;

  Student({
    this.id,
    this.studName,
    this.studEmail,
    this.studMobileNo,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json["_id"],
      studName: json["studname"],
      studEmail: json["studemail"],
      studMobileNo: json["studmobileno"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "studname": studName,
      "studemail": studEmail,
      "studmobileno": studMobileNo,
    };
  }
}

class StudentCredit {
  String? id;
  int? balance;
  int? freeCredits;
  int? totalUsed;
  String? createdAt;
  String? updatedAt;
  int? v;

  StudentCredit({
    this.id,
    this.balance,
    this.freeCredits,
    this.totalUsed,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory StudentCredit.fromJson(Map<String, dynamic> json) {
    return StudentCredit(
      id: json["_id"],
      balance: json["balance"],
      freeCredits: json["freeCredits"],
      totalUsed: json["totalUsed"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "balance": balance,
      "freeCredits": freeCredits,
      "totalUsed": totalUsed,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}