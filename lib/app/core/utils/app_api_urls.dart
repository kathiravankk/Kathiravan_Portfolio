class AppApiUrls {
  // BASE URL
  static const String baseUrl = newBaseUrl;
  static const String oldBaseUrl = "https://fulupo.selfietoons.com/api/";
  static const String newBaseUrl = "https://dev.api.internsharks.ai/api/";
  static const String newProdBaseUrl = "https://api.internsharks.ai/api/";
  static const String devServer = "https://fulupo.selfietoons.com/";
  static const String prodServer = "https://fulupo.selfietoons.com/";

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
  static const String templateRefresh = "${baseUrl}reduceresrefresh";
  static const String chatResumeCredit = "${baseUrl}reduceresumecredit";
  static  String getCreditData(String creditId) => "${baseUrl}credit/$creditId";

  //DASHBOARD FLOW
  static const String getCategoryList = "${baseUrl}industry/getindustrylist";
  static const String applyInternship = "${baseUrl}getjob/jobs/apply";
  static const String getRecommandInternship =
      "${baseUrl}jobpost/student/recommended-jobs";
  static const String getSimilarInternship =
      "${baseUrl}jobpost/student/similarjobs";

  static String getCategoryInternship(String categoryId) =>
      "${baseUrl}getjob/industry/$categoryId";

  static String getInternshipViewData(String internshipId, String studentId) =>
      "${baseUrl}jobpost/jobbyid/$internshipId?studentId=$studentId";

  static String getAppliedInternship(String studentId) =>
      "${baseUrl}getjob/appliedjob/$studentId";

  //static String getReviewData(String jobId) => "${baseUrl}job/$jobId/reviews";
  static String getReviewData(String jobId) =>
      "${baseUrl}job/reviews?jobId=$jobId";
  static String getUpdateChatResumeData = "${baseUrl}updatejsonresume";
  static String updateChatResume = "${baseUrl}updatemessage";

  // BUY CREDITS
  static String getCreditPlans = "${baseUrl}plans";
  static String createCreditOrder = "${baseUrl}student/create-order";
  static String verifyCreditOrder = "${baseUrl}student/verify";

  static String getAllInternship(
    String state,
    String city,
    String qualification,
    String duration,
    String stipend,
    String mode,
    String role,
    int page,
    int limit,
    String days,
  ) =>
      "${baseUrl}jobpost/student/getalljobs?companystate=$state&companycity=$city&studentqualification=$qualification&internshipduration=$duration&internshipstipend=$stipend&internshipmode=$mode&roletype=$role&limit=10&page=$page&days=$days";

  // PROFILE FLOW
  static String getProfileData = "${baseUrl}student/getById";
  static String sendUpdateMobileOtp = "${baseUrl}student/update-sendMobileOTP";
  static String verifyUpdateMobileOtp =
      "${baseUrl}student/update-verifyMobileOTP";
  static String sendUpdateEmailOtp = "${baseUrl}student/update-request-otp";
  static String verifyUpdateEmailOtp =
      "${baseUrl}student/update-verify-email-otp";
  static String getSavedJobs = "${baseUrl}savedjob/getsavedjobs";
  static String addToSavedJobs = "${baseUrl}savedjob/savenewjob";
  static String removeSavedJobs = "${baseUrl}savedjob/unsavejob";
  static String getFilterOption = "${baseUrl}jobpost/getvalue";
  static String generateResDp = "${baseUrl}generate-banner";
  static String removeWaterMark = "${baseUrl}removewater";
  static String bannerLike = "${baseUrl}studentlike";
  static String studentDeleteAccount = "${baseUrl}student/delete";

  // INTERNSHIP FLOW

  static String getInternshipData(String studentId) =>
      "${baseUrl}getall?studentId=$studentId";

  static String getSyllabusData(String jobId) => "${baseUrl}syllabus/$jobId";
  static String getInternshipStatus = "${baseUrl}getjob/getapplicationstatus";
  //static String updateWeeklyStatus = "${baseUrl}getjob/application/update-week";
  static String updateDailyStatus = "${baseUrl}getjob/application/update-day";
  static String generateMcqQuestions = "${baseUrl}generate-mcq";
  static String validateMcqAnswer = "${baseUrl}checktestscore";
  static String addFeedbackReview = "${baseUrl}job/review";
  static String saveTestResult = "${baseUrl}savetestresult";
  static String getAllCertificates = "${baseUrl}getcertificate";

  // INTERNSHIP PAYMENT

  static String paymentCheck = "${baseUrl}checkinternpayment";
  static String createPayment = "${baseUrl}createinternshipfee";
  static String verifyPayment = "${baseUrl}verifyinternshipfee";

  // RECRUITER FLOW API'S:

  static String registerEmailSendOtp = "${baseUrl}email/request-otp";
  static String registerEmailVerifyOtp = "${baseUrl}email/verify-otp";
  static String registerMobileSendOtp = "${baseUrl}student/sendMobileOTP";
  static String registerMobileVerifyOtp = "${baseUrl}student/verifyMobileOTP";
  static String checkExistAccount = "${baseUrl}student/checkExistence";
  static String newRecruiterRegister = "${baseUrl}recruiter/recruiterregister";
  static String getRecruiterProfile = "${baseUrl}recruiter/getrecruiterbyid";
  static String getAllStudentsList = "${baseUrl}student/getallstudentdetail";




}
