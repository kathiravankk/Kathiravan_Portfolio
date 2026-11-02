class StudentRegisterModel {
  bool? success;
  String? message;
  bool? universityTag;
  RegisterData? registerData;
  String? studentToken;

  StudentRegisterModel({
    this.success,
    this.message,
    this.universityTag,
    this.registerData,
    this.studentToken,
  });

  StudentRegisterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? (json['studtoken'] != null);
    message = json['message'] ?? "";
    universityTag = json['universityTag'];
    registerData = json['student'] != null
        ? RegisterData.fromJson(json['student'])
        : (json['data'] != null ? RegisterData.fromJson(json['data']) : null);
    studentToken = json['studtoken'] ?? json['studentToken'] ?? "";
  }
}

class RegisterData {
  String? id;
  String? studentName;
  String? studentMobileNo;
  String? studentMobileNoCode;
  bool? isVerified;
  String? studentCreditId;
  String? universityId;

  RegisterData({
    this.id,
    this.studentName,
    this.studentMobileNo,
    this.studentMobileNoCode,
    this.isVerified,
    this.studentCreditId,
    this.universityId,
  });

  RegisterData.fromJson(Map<String, dynamic> json) {
    id = (json['id'] ?? json['_id'])?.toString() ?? "";
    studentName = json['studname'] ?? "";
    studentMobileNo = json['studmobileno'] ?? "";
    studentMobileNoCode = json['studentmobilenocode'] ?? "";
    isVerified = json['isVerified'] ?? false;
    studentCreditId = json['studentCreditId'] is Map
        ? (json['studentCreditId']['_id'] ?? json['studentCreditId']['id'])
            ?.toString() ??
            ""
        : json['studentCreditId']?.toString() ?? "";
    universityId = json['universityId']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studname': studentName,
      'isVerified': isVerified,
      'studentCreditId': studentCreditId,
      'studmobileno': studentMobileNo,
      'studentmobilenocode': studentMobileNoCode,
      if (universityId != null) 'universityId': universityId,
    };
  }
}
