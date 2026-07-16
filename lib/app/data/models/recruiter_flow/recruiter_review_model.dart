class RecruiterReviewModel {
  final bool? success;
  final int? count;
  final List<RecReviewData>? reviewsList;

  RecruiterReviewModel({
    this.success,
    this.count,
    this.reviewsList,
  });

  factory RecruiterReviewModel.fromJson(Map<String, dynamic> json) {
    return RecruiterReviewModel(
      success: json['success']??false,
      count: json['count']??0,
      reviewsList: json['reviews'] != null
          ? List<RecReviewData>.from(
          json['reviews'].map((e) => RecReviewData.fromJson(e)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'reviews': reviewsList?.map((e) => e.toJson()).toList(),
    };
  }
}

class RecReviewData {
  final String? id;
  final String? job;
  final StudentData? student;
  final String? review;
  final int? rating;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  RecReviewData({
    this.id,
    this.job,
    this.student,
    this.review,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory RecReviewData.fromJson(Map<String, dynamic> json) {
    return RecReviewData(
      id: json['_id']??"",
      job: json['job']??"",
      student: json['student'] != null
          ? StudentData.fromJson(json['student'])
          : null,
      review: json['review']??"",
      rating: json['rating']??0,
      createdAt: json['createdAt'] ??"",
      updatedAt: json['updatedAt'] ??"",
      v: json['__v']??0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'job': job,
      'student': student?.toJson(),
      'review': review,
      'rating': rating,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class StudentData {
  final String? id;
  final String? studProfile;
  final String? studName;
  final String? studMobileNo;

  StudentData({
    this.id,
    this.studProfile,
    this.studName,
    this.studMobileNo,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      id: json['_id']??"",
      studProfile: json['studprofile']??"",
      studName: json['studname']??"",
      studMobileNo: json['studmobileno']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studprofile': studProfile,
      'studname': studName,
      'studmobileno': studMobileNo,
    };
  }
}