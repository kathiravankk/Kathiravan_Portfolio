class CommonLoginOtpModel {
  bool? success;
  String? message;
  String? userType;
  String? otpNumber;

  CommonLoginOtpModel({
    this.success,
    this.message,
    this.userType,
    this.otpNumber,
  });

  CommonLoginOtpModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    message = json["message"] ?? "";
    userType = json["userType"] ?? "";
    otpNumber = json["otp"]?.toString() ?? "";
  }
}

class SendMobileOtpModel {
  String? message;
  String? userType;
  String? otpNumber;

  SendMobileOtpModel({
    this.message,
    this.userType,
    this.otpNumber,
  });

  SendMobileOtpModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    userType = json["userType"] ?? "";
    otpNumber = json["otp"]?.toString() ?? "";
  }
}

class VerifyMobileOtpModel {
  String? message;
  bool? mobileVerified;

  VerifyMobileOtpModel({
    this.message,
    this.mobileVerified,
  });

  VerifyMobileOtpModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    mobileVerified = json["mobileVerified"] ?? false;
  }
}

class SendEmailOtpModel {
  String? message;
  String? otpNumber;

  SendEmailOtpModel({
    this.message,
    this.otpNumber,
  });

  SendEmailOtpModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    otpNumber = json["otp"]?.toString() ?? "";
  }
}

class VerifyEmailOtpModel {
  String? message;
  String? userType;
  bool? emailVerified;

  VerifyEmailOtpModel({
    this.message,
    this.userType,
    this.emailVerified,
  });

  VerifyEmailOtpModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    userType = json["userType"] ?? "";
    emailVerified = json["emailVerified"] ?? false;
  }
}

class CoordinatorOtpModel {
  final bool? success;
  final bool? alreadyVerified;
  final String? message;
  final String? otpNumber;

  CoordinatorOtpModel({
    this.success,
    this.alreadyVerified,
    this.message,
    this.otpNumber,
  });

  factory CoordinatorOtpModel.fromJson(Map<String, dynamic> json) {
    return CoordinatorOtpModel(
      success: json["success"] ?? false,
      alreadyVerified: json["alreadyVerified"] ?? false,
      message: json["message"] ?? "",
      otpNumber: json["otp"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "alreadyVerified": alreadyVerified,
      "message": message,
      "otp": otpNumber,
    };
  }
}