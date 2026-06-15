class RecruiterLoginModel {
  String? message;
  Recruiter? recruiter;
  String? recToken;

  RecruiterLoginModel({
    this.message,
    this.recruiter,
    this.recToken,
  });

  RecruiterLoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    recruiter = json['recruiter'] != null
        ? Recruiter.fromJson(json['recruiter'])
        : null;
    recToken = json['rectoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['message'] = message;

    if (recruiter != null) {
      data['recruiter'] = recruiter!.toJson();
    }

    data['rectoken'] = recToken;

    return data;
  }
}

class Recruiter {
  String? id;
  String? recruiterName;
  String? recruiterMobileNo;
  String? recruiterCreditId;

  Recruiter({
    this.id,
    this.recruiterName,
    this.recruiterMobileNo,
    this.recruiterCreditId,
  });

  Recruiter.fromJson(Map<String, dynamic> json) {
    id = json['id']??"";
    recruiterName = json['recname']??"";
    recruiterMobileNo = json['recmobileno']??"";
    recruiterCreditId = json['recruiterCreditId']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['recname'] = recruiterName;
    data['recmobileno'] = recruiterMobileNo;
    data['recruiterCreditId'] = recruiterCreditId;

    return data;
  }
}