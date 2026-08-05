class RecruiterFeedbackModel {
  RecruiterFeedbackModel({
    this.success,
    this.message,
    this.review,
  });

  bool? success;
  String? message;
  ReviewData? review;

  factory RecruiterFeedbackModel.fromJson(Map<String, dynamic> json) {
    return RecruiterFeedbackModel(
      success: json["success"],
      message: json["message"],
      review: json["review"] == null
          ? null
          : ReviewData.fromJson(json["review"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "review": review?.toJson(),
    };
  }
}

class ReviewData {
  ReviewData({
    this.job,
    this.student,
    this.recruiter,
    this.feedbackType,
    this.review,
    this.rating,
    this.postedBy,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? job;
  String? student;
  String? recruiter;
  String? feedbackType;
  String? review;
  int? rating;
  String? postedBy;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      job: json["job"],
      student: json["student"],
      recruiter: json["recruiter"],
      feedbackType: json["feedbacktype"],
      review: json["review"],
      rating: json["rating"],
      postedBy: json["postedby"],
      id: json["_id"],
      createdAt: json["createdAt"] == null
          ? null
          : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
          ? null
          : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "job": job,
      "student": student,
      "recruiter": recruiter,
      "feedbacktype": feedbackType,
      "review": review,
      "rating": rating,
      "postedby": postedBy,
      "_id": id,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "__v": v,
    };
  }
}