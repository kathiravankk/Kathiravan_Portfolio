class InternshipStatusModel {
  bool? success;
  StatusData? application;
  bool? isTestTaken;

  InternshipStatusModel({
    this.success,
    this.application,
    this.isTestTaken,
  });

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
  int? currentWeek;
  String? jobMessage;
  List<dynamic>? internProjectLink;
  List<dynamic>? weeklyProgress;
  String? createdAt;
  String? updatedAt;
  int? v;

  StatusData({
    this.id,
    this.job,
    this.student,
    this.recruiter,
    this.status,
    this.currentWeek,
    this.jobMessage,
    this.internProjectLink,
    this.weeklyProgress,
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
    currentWeek = json['currentWeek'];
    jobMessage = json['jobmessage'];
    internProjectLink = json['internProjectlink'];
    weeklyProgress = json['weeklyProgress'];
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
    data['currentWeek'] = currentWeek;
    data['jobmessage'] = jobMessage;
    data['internProjectlink'] = internProjectLink;
    data['weeklyProgress'] = weeklyProgress;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}