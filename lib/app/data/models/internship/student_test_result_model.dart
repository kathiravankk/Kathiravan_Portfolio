class StudentTestResultModel {
  bool? success;
  String? message;
  StudentTestData? studentTestResult;

  StudentTestResultModel({
    this.success,
    this.message,
    this.studentTestResult,
  });

  StudentTestResultModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    message = json["message"] ?? "";
    studentTestResult = json["data"] != null
        ? StudentTestData.fromJson(json["data"])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": studentTestResult?.toJson(),
    };
  }
}

class StudentTestData {
  ResultData? testData;
  TestWeeklyReport? testWeeklyReport;

  StudentTestData({
    this.testData,
    this.testWeeklyReport,
  });

  StudentTestData.fromJson(Map<String, dynamic> json) {
    testData = json["testresult"] != null
        ? ResultData.fromJson(json["testresult"])
        : null;

    testWeeklyReport = json["weeklyreport"] != null
        ? TestWeeklyReport.fromJson(json["weeklyreport"])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "testresult": testData?.toJson(),
      "weeklyreport": testWeeklyReport?.toJson(),
    };
  }
}

class ResultData {
  String? id;
  String? student;
  String? job;
  ResultViewDetails? testViewData;
  String? createdAt;
  String? updatedAt;
  int? v;

  ResultData({
    this.id,
    this.student,
    this.job,
    this.testViewData,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ResultData.fromJson(Map<String, dynamic> json) {
    id = json["_id"] ?? "";
    student = json["student"] ?? "";
    job = json["job"] ?? "";

    testViewData = json["testresult"] != null
        ? ResultViewDetails.fromJson(json["testresult"])
        : null;

    createdAt = json["createdAt"] ?? "";
    updatedAt = json["updatedAt"] ?? "";
    v = json["__v"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "student": student,
      "job": job,
      "testresult": testViewData?.toJson(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}

class ResultViewDetails {
  List<CorrectAnswerList>? correctAnswer;
  int? score;
  double? stars;

  ResultViewDetails({
    this.correctAnswer,
    this.score,
    this.stars,
  });

  ResultViewDetails.fromJson(Map<String, dynamic> json) {
    if (json["correct_answer"] != null) {
      correctAnswer = <CorrectAnswerList>[];
      json["correct_answer"].forEach((v) {
        correctAnswer!.add(CorrectAnswerList.fromJson(v));
      });
    }

    score = json["score"] ?? 0;

    stars = json["stars"] != null
        ? (json["stars"] as num).toDouble()
        : 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      "correct_answer":
      correctAnswer?.map((e) => e.toJson()).toList(),
      "score": score,
      "stars": stars,
    };
  }
}
class CorrectAnswerList {
  String? question;
  Options? options;
  String? answer;
  String? correctAnswer;
  String? selectAnswer;
  String? id;

  CorrectAnswerList({
    this.question,
    this.options,
    this.answer,
    this.correctAnswer,
    this.selectAnswer,
    this.id,
  });

  CorrectAnswerList.fromJson(Map<String, dynamic> json) {
    question = json["question"] ?? "";

    options = json["options"] != null
        ? Options.fromJson(json["options"])
        : null;

    answer = json["answer"] ?? "";
    correctAnswer = json["correct_answer"] ?? "";
    selectAnswer = json["select_answer"] ?? "";
    id = json["_id"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "options": options?.toJson(),
      "answer": answer,
      "correct_answer": correctAnswer,
      "select_answer": selectAnswer,
      "_id": id,
    };
  }
}

class Options {
  String? a;
  String? b;
  String? c;
  String? d;

  Options({
    this.a,
    this.b,
    this.c,
    this.d,
  });

  Options.fromJson(Map<String, dynamic> json) {
    a = json["A"] ?? "";
    b = json["B"] ?? "";
    c = json["C"] ?? "";
    d = json["D"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "A": a,
      "B": b,
      "C": c,
      "D": d,
    };
  }
}

class TestWeeklyReport {
  String? id;
  Job? job;
  String? student;
  String? recruiter;
  String? status;
  int? currentDay;
  String? jobMessage;
  List<String>? internProjectLink;
  List<TestDailyProgress>? dailyProgress;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? selectedAt;

  TestWeeklyReport({
    this.id,
    this.job,
    this.student,
    this.recruiter,
    this.status,
    this.currentDay,
    this.jobMessage,
    this.internProjectLink,
    this.dailyProgress,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.selectedAt,
  });

  TestWeeklyReport.fromJson(Map<String, dynamic> json) {
    id = json["_id"] ?? "";

    job = json["job"] != null
        ? Job.fromJson(json["job"])
        : null;

    student = json["student"] ?? "";
    recruiter = json["recruiter"] ?? "";
    status = json["status"] ?? "";
    currentDay = json["currentDay"] ?? 0;
    jobMessage = json["jobmessage"] ?? "";

    internProjectLink = json["internProjectlink"] != null
        ? List<String>.from(json["internProjectlink"])
        : [];

    if (json["dailyProgress"] != null) {
      dailyProgress = <TestDailyProgress>[];
      json["dailyProgress"].forEach((v) {
        dailyProgress!.add(TestDailyProgress.fromJson(v));
      });
    }

    createdAt = json["createdAt"] ?? "";
    updatedAt = json["updatedAt"] ?? "";
    v = json["__v"] ?? 0;
    selectedAt = json["selectedAt"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "job": job?.toJson(),
      "student": student,
      "recruiter": recruiter,
      "status": status,
      "currentDay": currentDay,
      "jobmessage": jobMessage,
      "internProjectlink": internProjectLink,
      "dailyProgress":
      dailyProgress?.map((e) => e.toJson()).toList(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
      "selectedAt": selectedAt,
    };
  }
}

class Job {
  String? id;
  String? roleType;
  String? internshipStipend;
  String? fee;

  Job({
    this.id,
    this.roleType,
    this.internshipStipend,
    this.fee,
  });

  Job.fromJson(Map<String, dynamic> json) {
    id = json["_id"] ?? "";
    roleType = json["roletype"] ?? "";
    internshipStipend = json["internshipstipend"] ?? "";
    fee = json["fee"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "roletype": roleType,
      "internshipstipend": internshipStipend,
      "fee": fee,
    };
  }
}

class TestDailyProgress {
  int? dayNumber;
  String? status;
  String? driveLink;
  String? completedAt;
  String? id;

  TestDailyProgress({
    this.dayNumber,
    this.status,
    this.driveLink,
    this.completedAt,
    this.id,
  });

  TestDailyProgress.fromJson(Map<String, dynamic> json) {
    dayNumber = json["dayNumber"] ?? 0;
    status = json["status"] ?? "";
    driveLink = json["drivelink"] ?? "";
    completedAt = json["completedAt"] ?? "";
    id = json["_id"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "dayNumber": dayNumber,
      "status": status,
      "drivelink": driveLink,
      "completedAt": completedAt,
      "_id": id,
    };
  }
}