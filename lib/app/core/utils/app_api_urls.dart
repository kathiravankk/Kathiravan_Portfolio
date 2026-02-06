class AppApiUrls {
  // BASE URL
  static const String baseUrl = "https://fulupo.selfietoons.com/api/";

  // LOGIN URLS
  static const String sendLoginOtp = "${baseUrl}stulogin/request-mobile-otp";
  static const String verifyLoginOtp = "${baseUrl}stulogin/verify-mobile-otp";

  // REGISTER FLOW URLS
  static const String extractResumeData = "${baseUrl}extract-data-from-resume";
  static const String registerSendOtp = "${baseUrl}student/sendMobileOTP";
  static const String registerVerifyOtp = "${baseUrl}student/verifyMobileOTP";
  static const String registerSendEmailOtp = "${baseUrl}student/request-otp";
  static const String registerVerifyEmailOtp =
      "${baseUrl}student/verify-email-otp";
  static const String newStudentRegister =
      "${baseUrl}student/new-student-register";
  static const String updateStudentRegisterData =
      "${baseUrl}student/update-new-student-register";
  static const String getStudentProfile = "${baseUrl}student/getById";
  static const String analyzeResumeScore = "${baseUrl}analyze-resume-score";
  static const String updateResumeData = "${baseUrl}enhance-resume";
  static const String verifyKycData = "${baseUrl}verify-kyc";

  //DASHBOARD FLOW
  static const String getCategoryList = "${baseUrl}industry/getindustrylist";
  static const String applyInternship = "${baseUrl}getjob/jobs/apply";
  static const String getRecommandInternship = "${baseUrl}jobpost/student/recommended-jobs";
  static const String getSimilarInternship = "${baseUrl}jobpost/student/similarjobs";
  static  String getCategoryInternship(String categoryId) => "${baseUrl}getjob/industry/$categoryId";
  static  String getInternshipViewData(String internshipId) => "${baseUrl}jobpost/jobbyid/$internshipId";
  static  String getAppliedInternship(String studentId) => "${baseUrl}getjob/appliedjob/$studentId";
  static  String getReviewData(String jobId) => "${baseUrl}job/$jobId/reviews";
}
