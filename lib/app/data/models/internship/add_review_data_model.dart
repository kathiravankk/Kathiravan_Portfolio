class AddReviewDataModel {
  bool? success;
  String? message;
  ReviewModelData? reviewData;

  AddReviewDataModel({this.success, this.message, this.reviewData});

  AddReviewDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    reviewData = json['review'] != null
        ? ReviewModelData.fromJson(json['review'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;

    if (reviewData != null) {
      data['review'] = reviewData!.toJson();
    }

    return data;
  }
}

class ReviewModelData {
  String? job;
  String? student;
  String? review;
  int? rating;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  ReviewModelData({
    this.job,
    this.student,
    this.review,
    this.rating,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ReviewModelData.fromJson(Map<String, dynamic> json) {
    job = json['job'];
    student = json['student'];
    review = json['review'];
    rating = json['rating'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['job'] = job;
    data['student'] = student;
    data['review'] = review;
    data['rating'] = rating;
    data['_id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;

    return data;
  }
}
