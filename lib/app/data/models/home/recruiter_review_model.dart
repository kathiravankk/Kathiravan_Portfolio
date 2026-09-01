class RecruiterReviewModel {
  bool? success;
  int? count;
  List<RecruiterReview>? reviews;

  RecruiterReviewModel({this.success, this.count, this.reviews});

  RecruiterReviewModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    count = json['count'] ?? 0;
    if (json['reviews'] != null) {
      reviews = <RecruiterReview>[];
      json['reviews'].forEach((v) {
        reviews!.add(RecruiterReview.fromJson(v));
      });
    }
  }
}

class RecruiterReview {
  String? id;
  String? job;
  String? student;
  RecruiterData? recruiter;
  String? feedbackType;
  String? review;
  dynamic rating;
  String? postedBy;
  String? createdAt;
  String? updatedAt;

  RecruiterReview({
    this.id,
    this.job,
    this.student,
    this.recruiter,
    this.feedbackType,
    this.review,
    this.rating,
    this.postedBy,
    this.createdAt,
    this.updatedAt,
  });

  RecruiterReview.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    job = json['job'] ?? '';
    student = json['student'] ?? '';
    recruiter = json['recruiter'] != null
        ? RecruiterData.fromJson(json['recruiter'])
        : null;
    feedbackType = json['feedbacktype'] ?? '';
    review = json['review'] ?? '';
    rating = json['rating'] ?? 0;
    postedBy = json['postedby'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }
}

class RecruiterData {
  String? id;
  String? recName;
  String? recMobileNo;
  String? recCompanyLogo;

  RecruiterData({this.id, this.recName, this.recMobileNo, this.recCompanyLogo});

  RecruiterData.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    recName = json['recname'] ?? '';
    recMobileNo = json['recmobileno'] ?? '';
    recCompanyLogo = json['reccompanylogo'] ?? '';
  }
}
