class AddShortlistStudentModel {
  bool? success;
  String? message;
  ShortlistStudentData? data;

  AddShortlistStudentModel({
    this.success,
    this.message,
    this.data,
  });

  AddShortlistStudentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? ShortlistStudentData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ShortlistStudentData {
  String? student;
  String? recruiter;
  String? status;
  String? note;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  ShortlistStudentData({
    this.student,
    this.recruiter,
    this.status,
    this.note,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ShortlistStudentData.fromJson(Map<String, dynamic> json) {
    student = json['student'];
    recruiter = json['recruiter'];
    status = json['status'];
    note = json['note'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      'student': student,
      'recruiter': recruiter,
      'status': status,
      'note': note,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}