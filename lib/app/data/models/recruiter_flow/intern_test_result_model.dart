class InternTestResultModel {
  InternTestResultModel({
    this.success,
    this.message,
    this.testData,
  });

  final bool? success;
  final String? message;
  final InternTestResultData? testData;

  factory InternTestResultModel.fromJson(Map<String, dynamic> json) {
    return InternTestResultModel(
      success: json["success"],
      message: json["message"],
      testData: json["data"] == null
          ? null
          : InternTestResultData.fromJson(json["data"]),
    );
  }
}

class InternTestResultData {
  InternTestResultData({
    this.testResult,
    this.weeklyReport,
    this.isCertificate,
  });

  final TestResult? testResult;
  final WeeklyReport? weeklyReport;
  final bool? isCertificate;

  factory InternTestResultData.fromJson(Map<String, dynamic> json) {
    return InternTestResultData(
      testResult: json["testresult"] == null
          ? null
          : TestResult.fromJson(json["testresult"]),
      weeklyReport: json["weeklyreport"] == null
          ? null
          : WeeklyReport.fromJson(json["weeklyreport"]),
      isCertificate: json["iscertificate"],
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
  });

  final String? id;
  final String? roleType;
  final String? internshipStipend;
  final String? fee;

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json["_id"],
      roleType: json["roletype"],
      internshipStipend: json["internshipstipend"],
      fee: json["fee"],
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