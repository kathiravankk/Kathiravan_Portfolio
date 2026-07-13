class SyllabusViewDataModel {
  SyllabusViewDataModel({this.message, this.success, this.syllabus});

  final String? message;
  final dynamic success;
  final SyllabusViewData? syllabus;

  factory SyllabusViewDataModel.fromJson(Map<String, dynamic> json) {
    return SyllabusViewDataModel(
      message: json["message"],
      success: json["success"],
      syllabus:
      json["syllabus"] == null ? null : SyllabusViewData.fromJson(json["syllabus"]),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "success": success,
      "syllabus": syllabus?.toJson(),
    };
  }
}

class SyllabusViewData {
  SyllabusViewData({
    this.meta,
    this.id,
    this.student,
    this.job,
    this.status,
    this.subject,
    this.totalMonth,
    this.totalDays,
    this.days = const [],
    this.month = const [],
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final Meta? meta;
  final String? id;
  final String? student;
  final String? job;
  final String? status;
  final String? subject;
  final int? totalMonth;
  final int? totalDays;

  /// Day-wise syllabus (single level: Day -> topics)
  final List<ScheduleGroup> days;

  /// Month-wise syllabus (nested: Month -> Week -> Day -> topics)
  final List<ScheduleGroup> month;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory SyllabusViewData.fromJson(Map<String, dynamic> json) {
    return SyllabusViewData(
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      id: json["_id"],
      student: json["student"],
      job: json["job"],
      status: json["status"],
      subject: json["subject"],
      totalMonth: json["total_month"],
      totalDays: json["total_days"],
      days: _parseGroupList(json["days"]),
      month: _parseGroupList(json["month"]),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "meta": meta?.toJson(),
      "_id": id,
      "student": student,
      "job": job,
      "status": status,
      "subject": subject,
      "total_month": totalMonth,
      "total_days": totalDays,
      "days": days.map((e) => e.toJson()).toList(),
      "month": month.map((e) => e.toJson()).toList(),
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "__v": v,
    };
  }
}

/// Filters out stray nulls before mapping — the API is known to send
/// things like `"days": [null]` for a month-based response, which used
/// to blow up parsing before this guard was added.
List<ScheduleGroup> _parseGroupList(dynamic raw) {
  if (raw == null || raw is! List) return [];
  return raw
      .where((x) => x != null && x is Map<String, dynamic>)
      .map((x) => ScheduleGroup.fromJson(x as Map<String, dynamic>))
      .toList();
}

/// A node in the syllabus tree.
///
/// The API nests groups to a different depth depending on the plan type:
///   Month-based: Month -> Week -> Day -> [ScheduleData with topics]
///   Day-based:   Day -> [ScheduleData with topics]
///
/// Instead of hardcoding a fixed depth, [ScheduleGroup] is recursive: each
/// raw item under "data" is inspected — if it carries a "topics" key it's
/// treated as a *leaf* ([ScheduleData]); otherwise it's another nested
/// [ScheduleGroup] (e.g. a Week inside a Month, or a Day inside a Week).
/// This makes the same class work for both day-wise and month-wise plans,
/// and for any extra nesting the backend might add later.
class ScheduleGroup {
  ScheduleGroup({
    this.title,
    this.id,
    this.children = const [],
    this.data = const [],
  });

  final String? title;
  final String? id;

  /// Nested sub-groups (e.g. Weeks under a Month, Days under a Week).
  /// Empty once you've reached the deepest level.
  final List<ScheduleGroup> children;

  /// Leaf schedule entries (topics/project tasks). Only populated at the
  /// deepest level of nesting.
  final List<ScheduleData> data;

  bool get hasChildren => children.isNotEmpty;

  factory ScheduleGroup.fromJson(Map<String, dynamic> json) {
    final rawList = json["data"];
    final children = <ScheduleGroup>[];
    final leafData = <ScheduleData>[];

    if (rawList is List) {
      for (final item in rawList) {
        if (item == null || item is! Map<String, dynamic>) continue;
        if (item.containsKey("topics")) {
          // Leaf entry: {"day": 1, "topics": [...], "project_schedule": [...]}
          leafData.add(ScheduleData.fromJson(item));
        } else {
          // Nested group: {"title": "Week 1", "data": [...]}
          children.add(ScheduleGroup.fromJson(item));
        }
      }

    }

    return ScheduleGroup(
      title: json["title"],
      id: json["_id"],
      children: children,
      data: leafData,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "_id": id,
      "data": hasChildren
          ? children.map((e) => e.toJson()).toList()
          : data.map((e) => e.toJson()).toList(),
    };
  }
}

class ScheduleData {
  ScheduleData({
    this.day,
    this.month,
    this.topics = const [],
    this.projectSchedule = const [],
    this.id,
  });

  /// Present only in Day-wise leaf entries
  final int? day;

  /// Present only in Month-wise leaf entries
  final int? month;

  final List<Topic> topics;
  final List<ProjectSchedule> projectSchedule;
  final String? id;

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      day: json["day"],
      month: json["month"],
      topics: json["topics"] == null
          ? []
          : (json["topics"] as List)
          .where((x) => x != null)
          .map((x) => Topic.fromJson(x as Map<String, dynamic>))
          .toList(),
      projectSchedule: json["project_schedule"] == null
          ? []
          : (json["project_schedule"] as List)
          .where((x) => x != null)
          .map((x) => ProjectSchedule.fromJson(x as Map<String, dynamic>))
          .toList(),
      id: json["_id"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "month": month,
      "topics": topics.map((e) => e.toJson()).toList(),
      "project_schedule":
      projectSchedule.map((e) => e.toJson()).toList(),
      "_id": id,
    };
  }
}

class ProjectSchedule {
  ProjectSchedule({this.day, this.month, this.task, this.project, this.id});

  /// Day-wise
  final int? day;

  /// Month-wise
  final int? month;

  final String? task;
  final String? project;
  final String? id;

  factory ProjectSchedule.fromJson(Map<String, dynamic> json) {
    return ProjectSchedule(
      day: json["day"],
      month: json["month"],
      task: json["task"],
      project: json["project"],
      id: json["_id"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "month": month,
      "task": task,
      "project": project,
      "_id": id,
    };
  }
}

class Topic {
  Topic({
    this.title,
    this.explanation,
    this.visualExplanation,
    this.youtubeUrl,
    this.codeExamples = const [],
    this.homework = const [],
    this.id,
  });

  final String? title;
  final String? explanation;
  final String? visualExplanation;
  final String? youtubeUrl;
  final List<String> codeExamples;
  final List<String> homework;
  final String? id;

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      title: json["title"],
      explanation: json["explanation"],
      visualExplanation: json["visual_explanation"],
      youtubeUrl: json["youtube_url"],
      codeExamples: json["code_examples"] == null
          ? []
          : (json["code_examples"] as List)
          .where((x) => x != null)
          .map((x) => x.toString())
          .toList(),
      homework: json["homework"] == null
          ? []
          : (json["homework"] as List)
          .where((x) => x != null)
          .map((x) => x.toString())
          .toList(),
      id: json["_id"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "explanation": explanation,
      "visual_explanation": visualExplanation,
      "youtube_url": youtubeUrl,
      "code_examples": codeExamples,
      "homework": homework,
      "_id": id,
    };
  }
}

class Meta {
  Meta({this.totalTopics, this.projectDays});

  final int? totalTopics;
  final int? projectDays;

  factory Meta.fromJson(Map<String, dynamic> json) {
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