class InternTestResultModel {
  InternTestResultModel({
    this.success,
    this.message,
    this.testData,
    this.isInterview,
    this.interviewDetails,
    this.isPlacement,
    this.placementDetails,
  });

  final bool? success;
  final String? message;
  final InternTestResultData? testData;
  final bool? isInterview;
  final InterviewDecisionDetails? interviewDetails;
  final bool? isPlacement;
  final PlacementDecisionDetails? placementDetails;

  factory InternTestResultModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"] is Map<String, dynamic>
        ? json["data"] as Map<String, dynamic>
        : null;

    Map<String, dynamic>? interviewMap = json["interviewDetails"] is Map<String, dynamic>
        ? json["interviewDetails"] as Map<String, dynamic>
        : (data?["interviewDetails"] is Map<String, dynamic>
            ? data!["interviewDetails"] as Map<String, dynamic>
            : null);

    Map<String, dynamic>? placementMap = json["placementDetails"] is Map<String, dynamic>
        ? json["placementDetails"] as Map<String, dynamic>
        : (data?["placementDetails"] is Map<String, dynamic>
            ? data!["placementDetails"] as Map<String, dynamic>
            : null);

    // If backend returns placement details under interviewDetails key
    if (placementMap == null &&
        interviewMap != null &&
        interviewMap["type"]?.toString().toLowerCase() == "placement") {
      placementMap = interviewMap;
      interviewMap = null;
    } else if (interviewMap == null &&
        placementMap != null &&
        placementMap["type"]?.toString().toLowerCase() == "interview") {
      interviewMap = placementMap;
      placementMap = null;
    }

    final isPlacementDecision = placementMap != null ||
        json["isPlacement"] == true ||
        data?["isPlacement"] == true;
    final isInterviewDecision = !isPlacementDecision &&
        (interviewMap != null ||
            json["isInterview"] == true ||
            data?["isInterview"] == true);

    return InternTestResultModel(
      success: json["success"],
      message: json["message"],
      testData: data == null
          ? null
          : InternTestResultData.fromJson(data),
      isInterview: isInterviewDecision,
      interviewDetails: interviewMap == null
          ? null
          : InterviewDecisionDetails.fromJson(interviewMap),
      isPlacement: isPlacementDecision,
      placementDetails: placementMap == null
          ? null
          : PlacementDecisionDetails.fromJson(placementMap),
    );
  }
}

class InternTestResultData {
  InternTestResultData({
    this.testResult,
    this.weeklyReport,
    this.isCertificate,
    this.isInterview,
    this.interviewDetails,
    this.isPlacement,
    this.placementDetails,
  });

  final TestResult? testResult;
  final WeeklyReport? weeklyReport;
  final bool? isCertificate;
  final bool? isInterview;
  final InterviewDecisionDetails? interviewDetails;
  final bool? isPlacement;
  final PlacementDecisionDetails? placementDetails;

  factory InternTestResultData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? interviewMap = json["interviewDetails"] is Map<String, dynamic>
        ? json["interviewDetails"] as Map<String, dynamic>
        : null;

    Map<String, dynamic>? placementMap = json["placementDetails"] is Map<String, dynamic>
        ? json["placementDetails"] as Map<String, dynamic>
        : null;

    if (placementMap == null &&
        interviewMap != null &&
        interviewMap["type"]?.toString().toLowerCase() == "placement") {
      placementMap = interviewMap;
      interviewMap = null;
    } else if (interviewMap == null &&
        placementMap != null &&
        placementMap["type"]?.toString().toLowerCase() == "interview") {
      interviewMap = placementMap;
      placementMap = null;
    }

    final isPlacementDecision =
        placementMap != null || json["isPlacement"] == true;
    final isInterviewDecision = !isPlacementDecision &&
        (interviewMap != null || json["isInterview"] == true);

    return InternTestResultData(
      testResult: json["testresult"] == null
          ? null
          : TestResult.fromJson(json["testresult"]),
      weeklyReport: json["weeklyreport"] == null
          ? null
          : WeeklyReport.fromJson(json["weeklyreport"]),
      isCertificate: json["iscertificate"],
      isInterview: isInterviewDecision,
      interviewDetails: interviewMap == null
          ? null
          : InterviewDecisionDetails.fromJson(interviewMap),
      isPlacement: isPlacementDecision,
      placementDetails: placementMap == null
          ? null
          : PlacementDecisionDetails.fromJson(placementMap),
    );
  }
}

class TestResult {
  TestResult({
    this.id,
    this.student,
    this.job,
    this.testResultDetails,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final Student? student;
  final Job? job;
  final TestResultDetails? testResultDetails;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json["_id"],
      student: json["student"] == null
          ? null
          : Student.fromJson(json["student"]),
      job: json["job"] == null
          ? null
          : Job.fromJson(json["job"]),
      testResultDetails: json["testresult"] == null
          ? null
          : TestResultDetails.fromJson(json["testresult"]),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}

class Student {
  Student({
    this.id,
    this.studName,
  });

  final String? id;
  final String? studName;

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json["_id"],
      studName: json["studname"],
    );
  }
}

class Job {
  Job({
    this.id,
    this.roleType,
    this.internshipStipend,
    this.fee,
    this.companyname,
  });

  final String? id;
  final String? roleType;
  final String? internshipStipend;
  final String? fee;
  final String? companyname;

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json["_id"],
      roleType: json["roletype"],
      internshipStipend: json["internshipstipend"],
      fee: json["fee"],
      companyname: json["companyname"] ?? json["companyName"],
    );
  }
}

class TestResultDetails {
  TestResultDetails({
    this.correctAnswer = const [],
    this.score,
    this.stars,
  });

  final List<CorrectAnswer> correctAnswer;
  final int? score;
  final double? stars;

  factory TestResultDetails.fromJson(Map<String, dynamic> json) {
    return TestResultDetails(
      correctAnswer: json["correct_answer"] == null
          ? []
          : List<CorrectAnswer>.from(
        json["correct_answer"]
            .map((x) => CorrectAnswer.fromJson(x)),
      ),
      score: json["score"],
      stars: (json["stars"] as num?)?.toDouble(),
    );
  }
}

class CorrectAnswer {
  CorrectAnswer({
    this.question,
    this.options,
    this.answer,
    this.correctAnswer,
    this.selectAnswer,
    this.id,
  });

  final String? question;
  final AnsOptions? options;
  final String? answer;
  final String? correctAnswer;
  final String? selectAnswer;
  final String? id;

  factory CorrectAnswer.fromJson(Map<String, dynamic> json) {
    return CorrectAnswer(
      question: json["question"],
      options: json["options"] == null
          ? null
          : AnsOptions.fromJson(json["options"]),
      answer: json["answer"],
      correctAnswer: json["correct_answer"],
      selectAnswer: json["select_answer"],
      id: json["_id"],
    );
  }
}

class AnsOptions {
  AnsOptions({
    this.a,
    this.b,
    this.c,
    this.d,
  });

  final String? a;
  final String? b;
  final String? c;
  final String? d;

  factory AnsOptions.fromJson(Map<String, dynamic> json) {
    return AnsOptions(
      a: json["A"],
      b: json["B"],
      c: json["C"],
      d: json["D"],
    );
  }
}
class WeeklyReport {
  WeeklyReport({
    this.id,
    this.job,
    this.student,
    this.recruiter,
    this.status,
    this.currentDay,
    this.jobMessage,
    this.internProjectLink = const [],
    this.dailyProgress = const [],
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final WeeklyJob? job;
  final String? student;
  final String? recruiter;
  final String? status;
  final int? currentDay;
  final String? jobMessage;
  final List<String> internProjectLink;
  final List<DailyProgress> dailyProgress;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory WeeklyReport.fromJson(Map<String, dynamic> json) {
    return WeeklyReport(
      id: json["_id"],
      job: json["job"] == null
          ? null
          : WeeklyJob.fromJson(json["job"]),
      student: json["student"],
      recruiter: json["recruiter"],
      status: json["status"],
      currentDay: json["currentDay"],
      jobMessage: json["jobmessage"],
      internProjectLink: json["internProjectlink"] == null
          ? []
          : List<String>.from(json["internProjectlink"]),
      dailyProgress: json["dailyProgress"] == null
          ? []
          : List<DailyProgress>.from(
        json["dailyProgress"]
            .map((x) => DailyProgress.fromJson(x)),
      ),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
}

class WeeklyJob {
  WeeklyJob({
    this.id,
    this.roleType,
    this.internshipStipend,
  });

  final String? id;
  final String? roleType;
  final String? internshipStipend;

  factory WeeklyJob.fromJson(Map<String, dynamic> json) {
    return WeeklyJob(
      id: json["_id"],
      roleType: json["roletype"],
      internshipStipend: json["internshipstipend"],
    );
  }
}

class DailyProgress {
  DailyProgress({
    this.dayNumber,
    this.status,
    this.completedAt,
    this.id,
    this.driveLink
  });

  final int? dayNumber;
  final String? status;
  final DateTime? completedAt;
  final String? id;
  final String? driveLink;

  factory DailyProgress.fromJson(Map<String, dynamic> json) {
    return DailyProgress(
      dayNumber: json["dayNumber"],
      driveLink: json["drivelink"]??"",
      status: json["status"],
      completedAt: DateTime.tryParse(json["completedAt"] ?? ""),
      id: json["_id"],
    );
  }
}

class InterviewDecisionDetails {
  final String? id;
  final String? decisionId;
  final String? type;
  final String? interviewStatus;
  final String? interviewDate;
  final String? interviewTime;
  final String? interviewMode;
  final String? interviewRound;
  final String? meetingLinkOrLocation;
  final String? interviewerName;
  final String? contactEmail;
  final String? interviewInstructions;
  final String? companyName;
  final String? jobTitle;
  final String? offerLetter;
  final RecruiterDecisionInfo? recruiter;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InterviewDecisionDetails({
    this.id,
    this.decisionId,
    this.type,
    this.interviewStatus,
    this.interviewDate,
    this.interviewTime,
    this.interviewMode,
    this.interviewRound,
    this.meetingLinkOrLocation,
    this.interviewerName,
    this.contactEmail,
    this.interviewInstructions,
    this.companyName,
    this.jobTitle,
    this.offerLetter,
    this.recruiter,
    this.createdAt,
    this.updatedAt,
  });

  factory InterviewDecisionDetails.fromJson(Map<String, dynamic> json) {
    return InterviewDecisionDetails(
      id: json["_id"]?.toString(),
      decisionId: json["decisionId"]?.toString(),
      type: json["type"]?.toString(),
      interviewStatus: json["interviewStatus"]?.toString(),
      interviewDate: json["interviewDate"]?.toString(),
      interviewTime: json["interviewTime"]?.toString(),
      interviewMode: json["interviewMode"]?.toString(),
      interviewRound: json["interviewRound"]?.toString(),
      meetingLinkOrLocation: json["meetingLinkOrLocation"]?.toString(),
      interviewerName: json["interviewerName"]?.toString(),
      contactEmail: json["contactEmail"]?.toString(),
      interviewInstructions: json["interviewInstructions"]?.toString(),
      companyName: json["companyName"]?.toString(),
      jobTitle: json["jobTitle"]?.toString(),
      offerLetter: json["offerLetter"]?.toString(),
      recruiter: json["recruiter"] is Map<String, dynamic>
          ? RecruiterDecisionInfo.fromJson(json["recruiter"])
          : null,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString())
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"].toString())
          : null,
    );
  }
}

class PlacementDecisionDetails {
  final String? id;
  final String? decisionId;
  final String? type;
  final String? status;
  final String? jobTitle;
  final String? companyName;
  final String? employmentType;
  final String? workMode;
  final String? joiningDate;
  final String? jobLocation;
  final String? annualSalary;
  final String? offerLetter;
  final String? placementNotes;
  final RecruiterDecisionInfo? recruiter;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlacementDecisionDetails({
    this.id,
    this.decisionId,
    this.type,
    this.status,
    this.jobTitle,
    this.companyName,
    this.employmentType,
    this.workMode,
    this.joiningDate,
    this.jobLocation,
    this.annualSalary,
    this.offerLetter,
    this.placementNotes,
    this.recruiter,
    this.createdAt,
    this.updatedAt,
  });

  factory PlacementDecisionDetails.fromJson(Map<String, dynamic> json) {
    return PlacementDecisionDetails(
      id: json["_id"]?.toString(),
      decisionId: json["decisionId"]?.toString(),
      type: json["type"]?.toString(),
      status: json["status"]?.toString() ?? json["interviewStatus"]?.toString(),
      jobTitle: json["jobTitle"]?.toString(),
      companyName: json["companyName"]?.toString(),
      employmentType: json["employmentType"]?.toString(),
      workMode: json["workMode"]?.toString(),
      joiningDate: json["joiningDate"]?.toString(),
      jobLocation: json["jobLocation"]?.toString(),
      annualSalary: json["annualSalary"]?.toString(),
      offerLetter: json["offerLetter"]?.toString(),
      placementNotes: json["placementNotes"]?.toString(),
      recruiter: json["recruiter"] is Map<String, dynamic>
          ? RecruiterDecisionInfo.fromJson(json["recruiter"])
          : null,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString())
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"].toString())
          : null,
    );
  }
}

class RecruiterDecisionInfo {
  final String? id;
  final String? recName;
  final String? recEmail;
  final String? recMobileNo;
  final String? recCompanyName;
  final String? recCompanyEmail;

  String? get name => recName;
  String? get email => recEmail;
  String? get companyName => recCompanyName;

  RecruiterDecisionInfo({
    this.id,
    this.recName,
    this.recEmail,
    this.recMobileNo,
    this.recCompanyName,
    this.recCompanyEmail,
  });

  factory RecruiterDecisionInfo.fromJson(Map<String, dynamic> json) {
    return RecruiterDecisionInfo(
      id: json["_id"]?.toString() ?? json["userId"]?.toString(),
      recName: json["name"]?.toString() ?? json["recname"]?.toString(),
      recEmail: json["email"]?.toString() ?? json["recemail"]?.toString(),
      recMobileNo: json["recmobileno"]?.toString() ?? json["mobileNo"]?.toString(),
      recCompanyName: json["companyName"]?.toString() ?? json["reccompanyname"]?.toString(),
      recCompanyEmail: json["companyEmail"]?.toString() ?? json["reccompanyemail"]?.toString(),
    );
  }
}
