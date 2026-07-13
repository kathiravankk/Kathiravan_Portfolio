class SyllabusGenerateModel {
  SyllabusGenerateModel({
     this.status,
     this.subject,
     this.totalMonth,
     this.totalDays,
     this.meta,
     this.month,
     this.days,
     this.tokenUsage,
    this.studentId,
    this.jobId
  });

  final String? status;
  final String? subject;
  final int? totalMonth;
  final int? totalDays;
  final Meta? meta;
  final List<Month>? month;
  final List<Day>? days;
  final int? tokenUsage;
   String? studentId;
   String? jobId;

  factory SyllabusGenerateModel.fromJson(Map<String, dynamic> json) {
    return SyllabusGenerateModel(
      status: json["status"],
      subject: json["subject"],
      totalMonth: json["total_month"],
      totalDays: json["total_days"],
      meta: json["meta"] == null
          ? null
          : Meta.fromJson(json["meta"]),

      month: (json["month"] as List?)
          ?.where((e) => e != null)
          .map((e) => Month.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],

      days: (json["days"] as List?)
          ?.where((e) => e != null)
          .map((e) => Day.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],

      tokenUsage: json["token_usage"],
      studentId: json["student"]??"",
      jobId: json["job"]??"",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "subject": subject,
      "student": studentId,
      "job": jobId,
      "total_month": totalMonth,
      "total_days": totalDays,
      "meta": meta?.toJson(),
      "month": month?.map((e) => e.toJson()).toList() ?? [],
      "days": days?.map((e) => e.toJson()).toList() ?? [],
      "token_usage": tokenUsage,
    };
  }
}
class Month {
  Month({this.title, this.data = const []});
  final String? title;
  final List<Week> data;

  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      title: json["title"],
      data: (json["data"] as List?)
          ?.where((e) => e != null)
          .map((e) => Week.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "data": data.map((e) => e.toJson()).toList(),
  };
}
class Week {
  Week({this.title, this.data = const []});

  final String? title;
  final List<Day> data; // reuse your existing Day class

  factory Week.fromJson(Map<String, dynamic> json) {
    return Week(
      title: json["title"],
      data: (json["data"] as List?)
          ?.where((e) => e != null)
          .map((e) => Day.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "title": title,
        "data": data.map((e) => e.toJson()).toList(),
      };
}
class MonthData {
  MonthData({
    this.month,
    this.topics = const [],
    this.projectSchedule = const [],
  });

  final int? month;
  final List<Topic> topics;
  final List<ProjectSchedule> projectSchedule;

  factory MonthData.fromJson(Map<String, dynamic> json) {
    return MonthData(
      month: json["month"],

      topics: (json["topics"] as List?)
          ?.where((e) => e != null)
          .map((e) => Topic.fromJson(e))
          .toList() ??
          [],

      projectSchedule: (json["project_schedule"] as List?)
          ?.where((e) => e != null)
          .map((e) => ProjectSchedule.fromJson(e))
          .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "month": month,
      "topics": topics.map((e) => e.toJson()).toList(),
      "project_schedule":
      projectSchedule.map((e) => e.toJson()).toList(),
    };
  }
}

class Day {
  Day({
    required this.title,
    required this.data,
  });

  final String? title;
  final List<Datum> data;

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      title: json["title"],
      data: (json["data"] as List?)
          ?.where((e) => e != null)
          .map((e) => Datum.fromJson(e))
          .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "data": data.map((e) => e.toJson()).toList(),
    };
  }

}

class Datum {
  Datum({
    required this.day,
    required this.topics,
    required this.projectSchedule,
  });

  final int? day;
  final List<Topic> topics;
  final List<ProjectSchedule> projectSchedule;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      day: json["day"],

      topics: (json["topics"] as List?)
          ?.where((e) => e != null)
          .map((e) => Topic.fromJson(e))
          .toList() ??
          [],

      projectSchedule: (json["project_schedule"] as List?)
          ?.where((e) => e != null)
          .map((e) => ProjectSchedule.fromJson(e))
          .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "topics": topics.map((e) => e.toJson()).toList(),
      "project_schedule":
      projectSchedule.map((e) => e.toJson()).toList(),
    };
  }

}

class ProjectSchedule {
  ProjectSchedule({
    required this.day,
    required this.task,
    required this.project,
  });

  final int? day;
  final String? task;
  final String? project;

  factory ProjectSchedule.fromJson(Map<String, dynamic> json){
    return ProjectSchedule(
      day: json["day"],
      task: json["task"],
      project: json["project"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "task": task,
      "project": project,
    };
  }

}

class Topic {
  Topic({
    required this.title,
    required this.explanation,
    required this.codeExamples,
    required this.visualExplanation,
    required this.homework,
    required this.youtubeUrl,
  });

  final String? title;
  final String? explanation;
  final List<String> codeExamples;
  final String? visualExplanation;
  final List<String> homework;
  final String? youtubeUrl;

  factory Topic.fromJson(Map<String, dynamic> json){
    return Topic(
      title: json["title"],
      explanation: json["explanation"],
      codeExamples: json["code_examples"] == null ? [] : List<String>.from(json["code_examples"]!.map((x) => x)),
      visualExplanation: json["visual_explanation"],
      homework: json["homework"] == null ? [] : List<String>.from(json["homework"]!.map((x) => x)),
      youtubeUrl: json["youtube_url"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "explanation": explanation,
      "code_examples": codeExamples,
      "visual_explanation": visualExplanation,
      "homework": homework,
      "youtube_url": youtubeUrl,
    };
  }

}

class Meta {
  Meta({
    required this.totalTopics,
    required this.projectDays,
  });

  final int? totalTopics;
  final int? projectDays;

  factory Meta.fromJson(Map<String, dynamic> json){
    return Meta(
      totalTopics: json["total_topics"],
      projectDays: json["project_days"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "total_topics": totalTopics,
      "project_days": projectDays,
    };
  }

}
