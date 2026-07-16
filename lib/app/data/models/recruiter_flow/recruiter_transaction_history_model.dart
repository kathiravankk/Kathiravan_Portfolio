class RecruiterTransactionHistoryModel {
  RecruiterTransactionHistoryModel({
    this.success,
    this.message,
    this.count,
    this.pagination,
    this.transactionData = const [],
  });

  final bool? success;
  final String? message;
  final int? count;
  final Pagination? pagination;
  final List<RecruiterTransactionData> transactionData;

  factory RecruiterTransactionHistoryModel.fromJson(
      Map<String, dynamic> json) {
    return RecruiterTransactionHistoryModel(
      success: json["success"],
      message: json["message"],
      count: json["count"],
      pagination: json["pagination"] == null
          ? null
          : Pagination.fromJson(json["pagination"]),
      transactionData: json["data"] == null
          ? []
          : (json["data"] as List)
          .where((e) => e != null)
          .map((e) => RecruiterTransactionData.fromJson(
          e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "count": count,
      "pagination": pagination?.toJson(),
      "data": transactionData.map((e) => e.toJson()).toList(),
    };
  }
}

class Pagination {
  Pagination({
    this.current,
    this.pageSize,
    this.total,
  });

  final int? current;
  final int? pageSize;
  final int? total;

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

class RecruiterTransactionData {
  RecruiterTransactionData({
    this.id,
    this.recruiter,
    this.recCredit,
    this.apiName,
    this.credits,
    this.role,
    this.type,
    this.status,
    this.balanceAfter,
    this.freeCreditsUsed,
    this.balanceCreditsUsed,
    this.freeCreditsAfter,
    this.createdAt,
    this.v,
  });

  final String? id;
  final dynamic recruiter;
  final RecruiterCredit? recCredit;
  final String? apiName;
  final int? credits;
  final String? role;
  final String? type;
  final String? status;
  final int? balanceAfter;
  final int? freeCreditsUsed;
  final int? balanceCreditsUsed;
  final int? freeCreditsAfter;
  final DateTime? createdAt;
  final int? v;

  factory RecruiterTransactionData.fromJson(Map<String, dynamic> json) {
    return RecruiterTransactionData(
      id: json["_id"],
      recruiter: json["recruiter"],
      recCredit: json["reccreditId"] == null
          ? null
          : RecruiterCredit.fromJson(json["reccreditId"]),
      apiName: json["apiName"],
      credits: json["credits"],
      role: json["role"],
      type: json["type"],
      status: json["status"],
      balanceAfter: json["balanceAfter"],
      freeCreditsUsed: json["freeCreditsUsed"],
      balanceCreditsUsed: json["balanceCreditsUsed"],
      freeCreditsAfter: json["freeCreditsAfter"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "recruiter": recruiter,
      "reccreditId": recCredit?.toJson(),
      "apiName": apiName,
      "credits": credits,
      "role": role,
      "type": type,
      "status": status,
      "balanceAfter": balanceAfter,
      "freeCreditsUsed": freeCreditsUsed,
      "balanceCreditsUsed": balanceCreditsUsed,
      "freeCreditsAfter": freeCreditsAfter,
      "createdAt": createdAt?.toIso8601String(),
      "__v": v,
    };
  }
}

class RecruiterCredit {
  RecruiterCredit({
    this.id,
    this.balance,
    this.totalUsed,
    this.freeCredits,
    this.v,
  });

  final String? id;
  final int? balance;
  final int? totalUsed;
  final int? freeCredits;
  final int? v;

  factory RecruiterCredit.fromJson(Map<String, dynamic> json) {
    return RecruiterCredit(
      id: json["_id"],
      balance: json["balance"],
      totalUsed: json["totalUsed"],
      freeCredits: json["freeCredits"],
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "balance": balance,
      "totalUsed": totalUsed,
      "freeCredits": freeCredits,
      "__v": v,
    };
  }
}