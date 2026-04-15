class WeeklyUpdateModel {
  bool? success;
  String? message;
  String? internStartDate;
  List<WeeklyProgress>? weeklyProgress;
  int? currentWeek;
  List<dynamic>? internProjectLink;

  WeeklyUpdateModel({
    this.success,
    this.message,
    this.weeklyProgress,
    this.currentWeek,
    this.internProjectLink,
    this.internStartDate
  });

  WeeklyUpdateModel.fromJson(Map<String, dynamic> json) {
    success = json['success']??false;
    message = json['message']??"";
    internStartDate = json['intershipstartdate']??"";
    currentWeek = json['currentWeek']??0;
    internProjectLink = json['internProjectlink']??[];

    if (json['weeklyProgress'] != null) {
      weeklyProgress = <WeeklyProgress>[];
      json['weeklyProgress'].forEach((v) {
        weeklyProgress!.add(WeeklyProgress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    data['currentWeek'] = currentWeek;
    data['internProjectlink'] = internProjectLink;

    if (weeklyProgress != null) {
      data['weeklyProgress'] =
          weeklyProgress!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class WeeklyProgress {
  int? weekNumber;
  String? status;
  String? completedAt;
  String? id;

  WeeklyProgress({
    this.weekNumber,
    this.status,
    this.completedAt,
    this.id,
  });

  WeeklyProgress.fromJson(Map<String, dynamic> json) {
    weekNumber = json['weekNumber']??0;
    status = json['status']??"";
    completedAt = json['completedAt']??"";
    id = json['_id']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['weekNumber'] = weekNumber;
    data['status'] = status;
    data['completedAt'] = completedAt;
    data['_id'] = id;
    return data;
  }
}