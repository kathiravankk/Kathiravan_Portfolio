class ReviewDataModel {
  bool? success;
  int? count;
  List<ReviewData>? reviewList;

  ReviewDataModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    count = json["count"] ?? 0;
    if (json['jobs'] != null) {
      reviewList = <ReviewData>[];
      json['jobs'].forEach((v) {
        reviewList!.add(ReviewData.fromJson(v));
      });
    }
  }

  ReviewDataModel({this.reviewList, this.count, this.success});
}

class ReviewData {
  String? jId;
  String? job;
  StudentData? studentData;
  String? review;
  double? rating;
  String? createdAt;
  String? updatedAt;
  int? vId;

  ReviewData({
    this.createdAt,
    this.updatedAt,
    this.vId,
    this.job,
    this.rating,
    this.jId,
    this.review,
    this.studentData,
  });

  ReviewData.fromJson(Map<String, dynamic> json) {
    createdAt = json["createdAt"] ?? "";
    updatedAt = json["updatedAt"] ?? "";
    jId = json["_id"] ?? "";
    job = json["job"] ?? "";
    vId = json["__v"] ?? 0;
    review = json["review"] ?? "";
    rating = json["rating"] ?? 0.0;
    studentData = json["student"] != null
        ? StudentData.fromJson(json["student"])
        : null;
  }
}

class StudentData {
  String? studentId;
  String? studentName;
  String? studentMobNum;

  StudentData.fromJson(Map<String, dynamic> json) {
    studentId = json["_id"] ?? "";
    studentName = json["studname"] ?? "";
    studentMobNum = json["studmobileno"] ?? "";
  }

  StudentData({this.studentMobNum, this.studentName, this.studentId});
}
