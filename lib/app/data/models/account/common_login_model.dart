class  CommonLoginOtpModel {
  bool? success;
  String? message;
  String? userType;

  CommonLoginOtpModel({this.success, this.message, this.userType});

  CommonLoginOtpModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    message = json["message"] ?? "";
    userType = json["userType"] ?? "";
  }
}

class SendMobileOtpModel {
  String? message;
  String? userType;

  SendMobileOtpModel({this.message, this.userType});

  SendMobileOtpModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    userType = json["userType"] ?? "";
  }
}

class VerifyMobileOtpModel {
  String? message;
  bool? mobileVerified;

  VerifyMobileOtpModel({this.message, this.mobileVerified});

  VerifyMobileOtpModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    mobileVerified = json["mobileVerified"] ?? false;
  }
}

class SendEmailOtpModel {
  String? message;

  SendEmailOtpModel({this.message});

  SendEmailOtpModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
  }
}

class VerifyEmailOtpModel {
  String? message;
  String? userType;
  bool? emailVerified;

  VerifyEmailOtpModel({this.message, this.emailVerified});



  VerifyEmailOtpModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    userType = json["userType"] ?? "";
    emailVerified = json["emailVerified"] ?? false;
  }
}
