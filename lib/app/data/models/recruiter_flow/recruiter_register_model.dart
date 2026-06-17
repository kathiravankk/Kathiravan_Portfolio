class RecruiterRegisterModel {
  final String? message;
  final RecruiterData? recruiter;
  final String? recToken;

  RecruiterRegisterModel({this.message, this.recruiter, this.recToken});

  factory RecruiterRegisterModel.fromJson(Map<String, dynamic> json) {
    return RecruiterRegisterModel(
      message: json['message'] ?? "",
      recruiter: json['recruiter'] != null
          ? RecruiterData.fromJson(json['recruiter'])
          : null,
      recToken: json['rectoken'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'recruiter': recruiter?.toJson(),
      'rectoken': recToken,
    };
  }
}

class RecruiterData {
  final String? id;
  final String? recName;
  final String? recEmail;
  final String? recMobileNo;
  final String? recSecondaryMobileNo;
  final String? recruiterCreditId;

  RecruiterData({
    this.id,
    this.recName,
    this.recEmail,
    this.recMobileNo,
    this.recSecondaryMobileNo,
    this.recruiterCreditId,
  });

  factory RecruiterData.fromJson(Map<String, dynamic> json) {
    return RecruiterData(
      id: json['id'] ?? "",
      recName: json['recname'] ?? "",
      recEmail: json['recemail'] ?? "",
      recMobileNo: json['recmobileno'] ?? "",
      recSecondaryMobileNo: json['recsecondarymobileno'] ?? "",
      recruiterCreditId: json['recruiterCreditId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recname': recName,
      'recemail': recEmail,
      'recmobileno': recMobileNo,
      'recsecondarymobileno': recSecondaryMobileNo,
      'recruiterCreditId': recruiterCreditId,
    };
  }
}
