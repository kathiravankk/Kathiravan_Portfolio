class CreditDataModel {
  bool? success;
  CreditResponseData? creditData;

  CreditDataModel({this.success, this.creditData});

  factory CreditDataModel.fromJson(Map<String, dynamic> json) {
    return CreditDataModel(
      success: json['success'] ?? false,
      creditData: json['data'] != null
          ? CreditResponseData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': creditData?.toJson()};
  }
}

class CreditResponseData {
  String? id;
  int? balance;
  int? totalUsed;
  String? createdAt;
  String? updatedAt;
  int? v;

  CreditResponseData({
    this.id,
    this.balance,
    this.totalUsed,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CreditResponseData.fromJson(Map<String, dynamic> json) {
    return CreditResponseData(
      id: json['_id'] ?? "",
      balance: json['balance'] ?? 0,
      totalUsed: json['totalUsed'] ?? 0,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'balance': balance,
      'totalUsed': totalUsed,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
