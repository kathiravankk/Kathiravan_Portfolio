class ApiConstants {
  // Base URL for the API

  static const String baseUrl =
      "https://fulupo.selfietoons.com/api";

  // AUTH
  static const String loginSendOtp =
      "$baseUrl/stulogin/request-mobile-otp";
  static const String loginVerifyOtp =
      "$baseUrl/stulogin/verify-mobile-otp";
  static const String registerSendMobileOtp =
      "$baseUrl/student/sendMobileOTP";
  static const String registerVerifyMobileOtp =
      "$baseUrl/student/verifyMobileOTP";
  static const String sendMailOtp =
      "$baseUrl/student/request-otp";
  static const String verifyMailOtp =
      "$baseUrl/student/verify-email-otp";

  // Specific Endpoints
  static String
  analyzeResume =
      "https://internsharks.tcsapec.com/api/resume-extraction";
  static String
  registerStudent=
      "$baseUrl/student/new-student-register";

}

