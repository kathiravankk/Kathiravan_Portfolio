class RecruiterCreditsPlansModel {
  RecruiterCreditsPlansModel({
    this.success,
    this.message,
    this.count,
    this.data,
  });

  final bool? success;
  final String? message;
  final int? count;
  final List<RecruiterPlanData>? data;

  factory RecruiterCreditsPlansModel.fromJson(Map<String, dynamic> json) {
    return RecruiterCreditsPlansModel(
      success: json["success"],
      message: json["message"],
      count: json["count"],
      data: json["data"] == null
          ? []
          : List<RecruiterPlanData>.from(
        json["data"].map((x) => RecruiterPlanData.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "count": count,
    "data": data?.map((e) => e.toJson()).toList(),
  };
}

class RecruiterPlanData {
  RecruiterPlanData({
    this.id,
    this.amount,
    this.credits,
    this.label,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final int? amount;
  final int? credits;
  final String? label;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory RecruiterPlanData.fromJson(Map<String, dynamic> json) {
    return RecruiterPlanData(
      id: json["_id"],
      amount: json["amount"],
      credits: json["credits"],
      label: json["label"],
      createdAt: json["createdAt"] == null
          ? null
          : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
          ? null
          : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "amount": amount,
    "credits": credits,
    "label": label,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}