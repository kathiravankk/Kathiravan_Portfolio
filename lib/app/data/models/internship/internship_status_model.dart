class InternshipStatusModel {
  bool? success;
  StatusData? application;
  bool? isTestTaken;

  InternshipStatusModel({this.success, this.application, this.isTestTaken});

  InternshipStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    application = json['application'] != null
        ? StatusData.fromJson(json['application'])
        : null;
    isTestTaken = json['istesttaken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (application != null) {
      data['application'] = application!.toJson();
    }
    data['istesttaken'] = isTestTaken;
    return data;
  }
}

class StatusData {
  String? id;
  String? job;
  String? student;
  String? recruiter;
  String? status;
  int? currentDay;
  String? jobMessage;
  List<String>? internProjectLink;
  List<DailyProgress>? dailyProgress;
  String? createdAt;
  String? updatedAt;
  int? v;

  StatusData({
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
  });

  StatusData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    job = json['job'];
    student = json['student'];
    recruiter = json['recruiter'];
    status = json['status'];
    currentDay = json['currentDay'];
    jobMessage = json['jobmessage'];

    if (json['internProjectlink'] != null) {
      internProjectLink = List<String>.from(json['internProjectlink']);
    }

    if (json['dailyProgress'] != null) {
      dailyProgress = [];
      json['dailyProgress'].forEach((v) {
        dailyProgress!.add(DailyProgress.fromJson(v));
      });
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['job'] = job;
    data['student'] = student;
    data['recruiter'] = recruiter;
    data['status'] = status;
    data['currentDay'] = currentDay;
    data['jobmessage'] = jobMessage;
    data['internProjectlink'] = internProjectLink;

    if (dailyProgress != null) {
      data['dailyProgress'] = dailyProgress!.map((v) => v.toJson()).toList();
    }

    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;

    return data;
  }
}

class DailyProgress {
  int? dayNumber;
  String? status;
  String? completedAt;
  String? id;
  String? driveLink;

  DailyProgress({
    this.dayNumber,
    this.status,
    this.completedAt,
    this.id,
    this.driveLink,
  });

  DailyProgress.fromJson(Map<String, dynamic> json) {
    dayNumber = json['dayNumber'];
    status = json['status'];
    completedAt = json['completedAt'];
    id = json['_id'];
    driveLink = json['driveLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['dayNumber'] = dayNumber;
    data['status'] = status;
    data['completedAt'] = completedAt;
    data['_id'] = id;
    data['driveLink'] = driveLink;
    return data;
  }
}
