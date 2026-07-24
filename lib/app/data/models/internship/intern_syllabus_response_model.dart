class InternSyllabusResponseModel {
  final String? message;
  final bool? success;
  final SyllabusViewData? syllabusViewData;
  final List<WeeklyProgressListData>? weeklyProgressList;
  final int? currentWeek;
  final dynamic internStartedAt;

  InternSyllabusResponseModel({
    this.message,
    this.success,
    this.syllabusViewData,
    this.weeklyProgressList,
    this.currentWeek,
    this.internStartedAt,
  });

  factory InternSyllabusResponseModel.fromJson(Map<String, dynamic> json) {
    return InternSyllabusResponseModel(
      message: json['message'],
      success: json['success'],
      syllabusViewData: json['syllabus'] != null && json['syllabus'] is Map
          ? SyllabusViewData.fromJson(json['syllabus'] as Map<String, dynamic>)
          : null,
      weeklyProgressList: _parseList<WeeklyProgressListData>(
        json['weeklyprogress'],
        (e) => WeeklyProgressListData.fromJson(e),
      ),
      currentWeek: json['currentWeek'],
      internStartedAt: json['internstarted'],
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'success': success,
    'syllabus': syllabusViewData?.toJson(),
    'weeklyprogress': weeklyProgressList?.map((e) => e.toJson()).toList(),
    'currentWeek': currentWeek,
    'internstarted': internStartedAt,
  };
}

class SyllabusViewData {
  final SyllabusMeta? meta;
  final String? id;
  final String? student;
  final String? job;
  final String? status;
  final String? subject;
  final int? totalMonth;
  final int? totalDays;
  final List<MonthData>? monthData;
  final List<DayData>? daysData;

  SyllabusViewData({
    this.meta,
    this.id,
    this.student,
    this.job,
    this.status,
    this.subject,
    this.totalMonth,
    this.totalDays,
    this.monthData,
    this.daysData,
  });

  bool get isMonthBased {
    return monthData != null && monthData!.isNotEmpty;
  }

  factory SyllabusViewData.fromJson(Map<String, dynamic> json) {
    // ── month list: skip any null or non-Map entries ──────────────────────
    List<MonthData>? monthList;
    if (json['month'] != null && json['month'] is List) {
      monthList = (json['month'] as List<dynamic>)
          .where((e) => e != null && e is Map)
          .map((e) => MonthData.fromJson(e as Map<String, dynamic>))
          .toList();
      if (monthList.isEmpty) monthList = null;
    }

    // ── days list: skip any null or non-Map entries ───────────────────────
    List<DayData>? dayList;
    if (json['days'] != null && json['days'] is List) {
      dayList = (json['days'] as List<dynamic>)
          .where((e) => e != null && e is Map)
          .map((e) => DayData.fromJson(e as Map<String, dynamic>))
          .toList();
      if (dayList.isEmpty) dayList = null;
    }

    return SyllabusViewData(
      meta: json['meta'] != null && json['meta'] is Map
          ? SyllabusMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      id: json['_id'],
      student: json['student'],
      job: json['job'],
      status: json['status'],
      subject: json['subject'],
      totalMonth: json['total_month'],
      totalDays: json['total_days'],
      monthData: monthList,
      daysData: dayList,
    );
  }

  Map<String, dynamic> toJson() => {
    'meta': meta?.toJson(),
    '_id': id,
    'student': student,
    'job': job,
    'status': status,
    'subject': subject,
    'total_month': totalMonth,
    'total_days': totalDays,
    'month': monthData?.map((e) => e.toJson()).toList(),
    'days': daysData?.map((e) => e.toJson()).toList(),
  };
}

class SyllabusMeta {
  final int? totalTopics;
  final int? projectDays;

  SyllabusMeta({this.totalTopics, this.projectDays});

  factory SyllabusMeta.fromJson(Map<String, dynamic> json) => SyllabusMeta(
    totalTopics: json['total_topics'],
    projectDays: json['project_days'],
  );

  Map<String, dynamic> toJson() => {
    'total_topics': totalTopics,
    'project_days': projectDays,
  };
}

class MonthData {
  final String? title;
  final String? id;
  final List<WeekData>? data;

  MonthData({this.title, this.id, this.data});

  factory MonthData.fromJson(Map<String, dynamic> json) => MonthData(
    title: json['title'],
    id: json['_id'],
    data: _parseList<WeekData>(json['data'], (e) => WeekData.fromJson(e)),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    '_id': id,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class WeekData {
  final String? title;
  final String? id;
  final List<DayData>? daysList;

  WeekData({this.title, this.id, this.daysList});

  factory WeekData.fromJson(Map<String, dynamic> json) => WeekData(
    title: json['title'],
    id: json['_id'],
    daysList: _parseList<DayData>(json['data'], (e) => DayData.fromJson(e)),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    '_id': id,
    'data': daysList?.map((e) => e.toJson()).toList(),
  };
}

class DayData {
  final String? title;
  final String? id;
  final List<DayDetail>? dayList;

  DayData({this.title, this.id, this.dayList});

  factory DayData.fromJson(Map<String, dynamic> json) => DayData(
    title: json['title'],
    id: json['_id'],
    dayList: _parseList<DayDetail>(json['data'], (e) => DayDetail.fromJson(e)),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    '_id': id,
    'data': dayList?.map((e) => e.toJson()).toList(),
    "days": dayList?.map((e) => e.toJson()).toList(),
  };
}

class DayDetail {
  final int? day;
  final String? id;
  final List<TopicData>? topics;
  final List<ProjectSchedule>? projectSchedule;

  DayDetail({this.day, this.id, this.topics, this.projectSchedule});

  factory DayDetail.fromJson(Map<String, dynamic> json) => DayDetail(
    day: json['day'],
    id: json['_id'],
    topics: _parseList<TopicData>(json['topics'], (e) => TopicData.fromJson(e)),
    projectSchedule: _parseList<ProjectSchedule>(
      json['project_schedule'],
      (e) => ProjectSchedule.fromJson(e),
    ),
  );

  Map<String, dynamic> toJson() => {
    'day': day,
    '_id': id,
    'topics': topics?.map((e) => e.toJson()).toList(),
    'project_schedule': projectSchedule?.map((e) => e.toJson()).toList(),
  };
}

class TopicData {
  final String? title;
  final String? explanation;
  final List<String>? codeExamples;
  final List<String>? homework;
  final String? id;
  final String? visualExplanation;
  final String? youtubeUrl;

  factory TopicData.fromJson(Map<String, dynamic> json) => TopicData(
    title: json['title'],
    explanation: json['explanation'],
    visualExplanation: json['visual_explanation'],
    codeExamples: _parseStringList(json['code_examples']),
    homework: _parseStringList(json['homework']),
    id: json['_id'],
    youtubeUrl: json['youtube_url']??"",
  );

  TopicData({
    this.title,
    this.explanation,
    this.codeExamples,
    this.homework,
    this.id,
    this.visualExplanation,
    this.youtubeUrl
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'explanation': explanation,
    'code_examples': codeExamples,
    'homework': homework,
    '_id': id,
    'visual_explanation': visualExplanation,
    "youtube_url": youtubeUrl
  };
}

class ProjectSchedule {
  final int? day;
  final String? task;
  final String? project;
  final String? id;

  ProjectSchedule({this.day, this.task, this.project, this.id});

  factory ProjectSchedule.fromJson(Map<String, dynamic> json) =>
      ProjectSchedule(
        day: json['day'],
        task: json['task'],
        project: json['project'],
        id: json['_id'],
      );

  Map<String, dynamic> toJson() => {
    'day': day,
    'task': task,
    'project': project,
    '_id': id,
  };
}

class WeeklyProgressListData {
  final int? weekNumber;
  final String? status;

  WeeklyProgressListData({this.weekNumber, this.status});

  factory WeeklyProgressListData.fromJson(Map<String, dynamic> json) =>
      WeeklyProgressListData(
        weekNumber: json['weekNumber'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {'weekNumber': weekNumber, 'status': status};
}

List<T>? _parseList<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
  if (raw == null || raw is! List) return null;
  final result = <T>[];
  for (final item in raw) {
    if (item != null && item is Map) {
      try {
        result.add(fromJson(item as Map<String, dynamic>));
      } catch (_) {
        print("EEEEEER");
      }
    }
  }
  return result.isEmpty ? null : result;
}

List<String>? _parseStringList(dynamic raw) {
  if (raw == null || raw is! List) return null;
  final result = raw.where((e) => e != null).map((e) => e.toString()).toList();
  return result.isEmpty ? null : result;
}

