class InternshipSyllabusModel {
  bool? success;
  String? message;
  int? interCount;
  List<SyllabusData>? syllabus;

  InternshipSyllabusModel({
    this.success,
    this.message,
    this.interCount,
    this.syllabus,
  });

  InternshipSyllabusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    interCount = json['intercount'];

    if (json['syllabus'] != null) {
      syllabus = (json['syllabus'] as List)
          .map((e) => SyllabusData.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "intercount": interCount,
      "syllabus": syllabus?.map((e) => e.toJson()).toList(),
    };
  }
}

class SyllabusData {
  String? sId;
  String? student;
  String? job;
  String? status;
  String? subject;
  int? months;
  int? totalWeeks;
  int? totalMonth;
  int? totalDays;
  Meta? meta;
  List<WeeklyData>? data;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SyllabusData({
    this.sId,
    this.student,
    this.job,
    this.status,
    this.subject,
    this.months,
    this.totalWeeks,
    this.meta,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.totalDays,
    this.totalMonth,
  });

  SyllabusData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    student = json['student'];
    job = json['job'];
    status = json['status'];
    subject = json['subject'];
    months = json['months'];
    totalWeeks = json['total_weeks'];
    totalMonth = json['total_month'];
    totalDays = json['total_days'];

    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;

    if (json['data'] != null) {
      data = (json['data'] as List).map((e) => WeeklyData.fromJson(e)).toList();
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": sId,
      "student": student,
      "job": job,
      "status": status,
      "subject": subject,
      "months": months,
      "total_weeks": totalWeeks,
      "meta": meta?.toJson(),
      "data": data?.map((e) => e.toJson()).toList(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "total_month": totalMonth,
      "total_days": totalDays,
      "__v": iV,
    };
  }
}

class Meta {
  int? totalTopics;
  int? projectDays;

  Meta({this.totalTopics, this.projectDays});

  Meta.fromJson(Map<String, dynamic> json) {
    totalTopics = json['total_topics'];
    projectDays = json['project_days'];
  }

  Map<String, dynamic> toJson() {
    return {
      "total_topics": totalTopics,
      "project_days": projectDays,
    };
  }
}

class WeeklyData {
  int? week;
  List<DaysData>? days;

  WeeklyData({this.week, this.days});

  WeeklyData.fromJson(Map<String, dynamic> json) {
    week = json['week'];

    if (json['days'] != null) {
      days = (json['days'] as List).map((e) => DaysData.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "week": week,
      "days": days?.map((e) => e.toJson()).toList(),
    };
  }
}

class DaysData {
  int? day;
  List<TopicsData>? topics;
  List<ProjectScheduleData>? projectSchedule;

  DaysData({this.day, this.topics, this.projectSchedule});

  DaysData.fromJson(Map<String, dynamic> json) {
    day = json['day'];

    if (json['topics'] != null) {
      topics = (json['topics'] as List)
          .map((e) => TopicsData.fromJson(e))
          .toList();
    }

    if (json['project_schedule'] != null) {
      projectSchedule = (json['project_schedule'] as List)
          .map((e) => ProjectScheduleData.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "topics": topics?.map((e) => e.toJson()).toList(),
      "project_schedule": projectSchedule?.map((e) => e.toJson()).toList(),
    };
  }
}

class TopicsData {
  String? title;
  String? explanation;
  List<String>? codeExamples;
  List<String>? homework;

  TopicsData({
    this.title,
    this.explanation,
    this.codeExamples,
    this.homework,
  });

  TopicsData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    explanation = json['explanation'];
    codeExamples = (json['code_examples'] as List?)?.cast<String>();
    homework = (json['homework'] as List?)?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "explanation": explanation,
      "code_examples": codeExamples,
      "homework": homework,
    };
  }
}

class ProjectScheduleData {
  int? day;
  String? task;
  String? project;

  ProjectScheduleData({this.day, this.task, this.project});

  ProjectScheduleData.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    task = json['task'];
    project = json['project'];
  }

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "task": task,
      "project": project,
    };
  }
}