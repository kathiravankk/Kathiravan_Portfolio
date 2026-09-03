class AppApiUrls {
  // BASE URL
  static const String baseUrl = newProdBaseUrl;
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
  static const updateChatProfile =
      "${baseUrl}student/update-new-student-register";
  static const String getStudentProfile = "${baseUrl}student/getById";
  static const String analyzeResumeScore = "${baseUrl}analyze-resume-score";
  static const String updateResumeData = "${baseUrl}enhance-resume";
  static const String verifyKycData = "${baseUrl}verify-kyc";
  static const String chatResumeCreation = "${baseUrl}chatbot";
  static const String createNewChatResume = "${baseUrl}resumechatbot";
  static const String templateRefresh = "${baseUrl}reduceresrefresh";
  static const String chatResumeCredit = "${baseUrl}reduceresumecredit";
  static String getCreditData(String creditId) => "${baseUrl}credit/$creditId";

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
  static String chatMcqQuestion = "${baseUrl}resumechatbotmcq";
  //static String updateChatResume = "${baseUrl}updatemessage";

  // BUY CREDITS
  //static String getCreditPlans = "${baseUrl}plans";
  static String getCreditPlans = "${baseUrl}studentpaln/getallstudentplan";
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
  static String getStudentCreditHistory(String studentId, int page) =>
      "${baseUrl}student/getallfreecredittransaction/$studentId?page=$page&limit=10";
  static String getStudentPurchaseHistory(int page, int limit) =>
      "${baseUrl}getallcreditpayment?page=$page&limit=$limit";

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
  static String getStudentMcqResult(String studentId, String jobId) =>
      "${baseUrl}get/result?studentId=$studentId&jobId=$jobId";

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
  static String getShortlistedStudents = "${baseUrl}favorite/getfavorites";
  static String addToShortlistedStudents = "${baseUrl}favorite/add";
  static String removeShortlistedStudents = "${baseUrl}favorite/deletefavorite";
  static String recruiterUpdateProfile =
      "${baseUrl}recruiter/recruiterregisterupdate";
  static String getPostedInternships(String recruiterId) =>
      "${baseUrl}jobpost/jobs/$recruiterId";
  static String getJobApplicants(String jobId, String status) =>
      "${baseUrl}getjob/jobs/$jobId?status=$status";
  static String getInternStudentProfile(String jobId) =>
      "${baseUrl}student/getstudentdetail?jobId=$jobId";
  static String newInternPost = "${baseUrl}jobpost/recruiter-jobpost";
  static String updateNewInternPost(String jobId) =>
      "${baseUrl}jobpost/job/$jobId";
  static String sendInternshipRequest =
      "${baseUrl}favorite/sendapplicationrequest";
  static String updateApplicationStatus(String applicationId) =>
      "${baseUrl}getjob/updatejobstatus/$applicationId";
  static String getRecruiterReview(String jobId) =>
      "${baseUrl}job/reviews?jobId=$jobId";
  static String generateSyllabus = "${baseUrl}generate-syllabus";
  static String saveSyllabus = "${baseUrl}savesyllabus";
  static String getSyllabus(String studentId, String jobId) =>
      "${baseUrl}syllabus/recruiter/$studentId/$jobId";
  static String getStudentResult(String studentId, String jobId) =>
      "${baseUrl}getresult?jobId=$jobId&studentId=$studentId";
  static String getIssuedCertificate(String studentId, String jobId) =>
      "${baseUrl}viewstudentcertificate?jobId=$jobId&studentId=$studentId";
  static String getRecruiterCreditPlans =
      "${baseUrl}recruiterplan/getallrecruiterplan";
  static String createRecruiterCreditOrder = "${baseUrl}recruiter/create-order";
  static String verifyRecruiterCreditOrder = "${baseUrl}recruiter/verify";
  static String updateSyllabusData = "${baseUrl}updatesyllabus";
  static String syllabusUpdateChat = "${baseUrl}jsonchatsyllabusupdate";
  static String generateAiCertificate = "${baseUrl}generate";
  static String createStipendOrder = "${baseUrl}createstippedpay";
  static String verifyStipendOrder = "${baseUrl}verifystippedpay";
  static String getInternProfile = "${baseUrl}student/getstudentdetail";
  static String getPaymentHistory(int page, int limit) =>
      "${baseUrl}recbuyhistory?page=$page&limit=$limit";
  static String getTransactionHistory(String recruiterId, int page) =>
      "${baseUrl}recruiter/getallcredittransaction/$recruiterId?page=$page&limit=10";
  static String syllabusDataUpdate(String studentId, String jobId) =>
      "${baseUrl}syllabus/updatebyid?studentId=$studentId&jobid=$jobId";
  static String checkStipendStatus(String studentId, String jobId) =>
      "${baseUrl}checkstipendstatus?jobId=$jobId&studentId=$studentId";
  static String recruiterDeleteAccount = "${baseUrl}recruiter/delete";
  static String sendCoordinatorOtp = "${baseUrl}sendcoordinatorotp";
  static String verifyCoordinatorOtp = "${baseUrl}verifycoordinatorotp";
  static String giveRecruiterReview = "${baseUrl}recruiterreview";
  static String getRecruiterReviewForStudent(String jobId) =>
      "${baseUrl}getrecruiterreviewforstudent?jobId=$jobId";
  static String getAllCoordinators = "${baseUrl}coordinators";
  static String deleteCoordinator(String coId) => "${baseUrl}coordinator/$coId";
}
