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
  });

  final String? status;
  final String? subject;
  final int? totalMonth;
  final int? totalDays;
  final Meta? meta;
  final List<dynamic>? month;
  final List<Day>? days;
  final int? tokenUsage;

  factory SyllabusGenerateModel.fromJson(Map<String, dynamic> json){
    return SyllabusGenerateModel(
      status: json["status"],
      subject: json["subject"],
      totalMonth: json["total_month"],
      totalDays: json["total_days"],
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      month: json["month"] == null ? [] : List<dynamic>.from(json["month"]!.map((x) => x)),
      days: json["days"] == null ? [] : List<Day>.from(json["days"]!.map((x) => Day.fromJson(x))),
      tokenUsage: json["token_usage"],
    );
  }

}

class Day {
  Day({
    required this.title,
    required this.data,
  });

  final String? title;
  final List<Datum> data;

  factory Day.fromJson(Map<String, dynamic> json){
    return Day(
      title: json["title"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
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

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      day: json["day"],
      topics: json["topics"] == null ? [] : List<Topic>.from(json["topics"]!.map((x) => Topic.fromJson(x))),
      projectSchedule: json["project_schedule"] == null ? [] : List<ProjectSchedule>.from(json["project_schedule"]!.map((x) => ProjectSchedule.fromJson(x))),
    );
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

}
