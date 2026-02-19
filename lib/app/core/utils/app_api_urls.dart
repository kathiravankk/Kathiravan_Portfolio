class AppApiUrls {
  // BASE URL
  static const String baseUrl = "https://fulupo.selfietoons.com/api/";
  static const String devServer = "https://fulupo.selfietoons.com/";

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
  static const String chatResumeCreation = "${baseUrl}chatbot";

  //DASHBOARD FLOW
  static const String getCategoryList = "${baseUrl}industry/getindustrylist";
  static const String applyInternship = "${baseUrl}getjob/jobs/apply";
  static const String getRecommandInternship = "${baseUrl}jobpost/student/recommended-jobs";
  static const String getSimilarInternship = "${baseUrl}jobpost/student/similarjobs";
  static  String getCategoryInternship(String categoryId) => "${baseUrl}getjob/industry/$categoryId";
  static  String getInternshipViewData(String internshipId) => "${baseUrl}jobpost/jobbyid/$internshipId";
  static  String getAppliedInternship(String studentId) => "${baseUrl}getjob/appliedjob/$studentId";
  static  String getReviewData(String jobId) => "${baseUrl}job/$jobId/reviews";

  // PROFILE FLOW
  static  String getProfileData = "${baseUrl}student/getById";
  static  String sendUpdateMobileOtp = "${baseUrl}student/update-sendMobileOTP";
  static  String verifyUpdateMobileOtp = "${baseUrl}student/update-verifyMobileOTP";
  static  String sendUpdateEmailOtp = "${baseUrl}student/update-request-otp";
  static  String verifyUpdateEmailOtp = "${baseUrl}student/update-verify-email-otp";
  static  String getSavedJobs = "${baseUrl}savedjob/getsavedjobs";
  static  String addToSavedJobs = "${baseUrl}savedjob/savenewjob";
  static  String removeSavedJobs = "${baseUrl}savedjob/unsavejob";
}
