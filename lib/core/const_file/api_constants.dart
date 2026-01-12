class ApiConstants {
  // Base URL for the API

  static const String baseUrl =
      "https://fulupo.selfietoons.com/api";

  // AUTH
  static const String requestMobileOtp =
      "$baseUrl/stulogin/request-mobile-otp";
  static const String requestMailOtp =
      "https://fulupo.selfietoons.com/api/student/request-otp";
  static const String verifyMailOtp =
      "http://localhost:5000/api/student/verify-email-otp";

  static const String verifyMobileOtp =
      "$baseUrl/stulogin/verify-mobile-otp";
  // Specific Endpoints
  static const String analyzeResume = "https://internsharks.tcsapec.com/api/resume-extraction";

}

