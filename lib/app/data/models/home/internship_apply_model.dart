class InternshipApplyModel {
  String? message;
  Application? application;

  InternshipApplyModel({this.message, this.application});

  InternshipApplyModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    application = json['application'] != null
        ? Application.fromJson(json['application'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (application != null) {
      data['application'] = application!.toJson();
    }
    return data;
  }
}

class Application {
  String? job;
  String? student;
  String? recruiter;
  String? status;
  int? currentWeek;
  String? sId;
  List<dynamic>? weeklyProgress;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Application({
    this.job,
    this.student,
    this.recruiter,
    this.status,
    this.currentWeek,
    this.sId,
    this.weeklyProgress,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Application.fromJson(Map<String, dynamic> json) {
    job = json['job'] ?? "";
    student = json['student'] ?? "";
    recruiter = json['recruiter'] ?? "";
    status = json['status'] ?? "";
    currentWeek = json['currentWeek'] ?? 0;
    sId = json['_id'] ?? "";
    weeklyProgress = json['weeklyProgress'] ?? [];
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    iV = json['__v'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job'] = job;
    data['student'] = student;
    data['recruiter'] = recruiter;
    data['status'] = status;
    data['currentWeek'] = currentWeek;
    data['_id'] = sId;
    if (weeklyProgress != null) {
      data['weeklyProgress'] = weeklyProgress!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
