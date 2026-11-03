class RecruiterPlacementResultModel {
  final bool? success;
  final List<RecruiterResultItem>? data;
  final PaginationData? pagination;
  final String? message;

  RecruiterPlacementResultModel({
    this.success,
    this.data,
    this.pagination,
    this.message,
  });

  factory RecruiterPlacementResultModel.fromJson(Map<String, dynamic> json) {
    return RecruiterPlacementResultModel(
      success: json['success'] ?? false,
      message: json['message']?.toString(),
      data: json['data'] != null && json['data'] is List
          ? (json['data'] as List)
              .map((e) => RecruiterResultItem.fromJson(
                  e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e)))
              .toList()
          : [],
      pagination: json['pagination'] != null && json['pagination'] is Map
          ? PaginationData.fromJson(
              Map<String, dynamic>.from(json['pagination']))
          : null,
    );
  }
}

class RecruiterResultItem {
  final String? id;
  final String? recruiter;
  final RecruiterResultStudent? student;
  final RecruiterResultJob? job;
  final String? type;
  final String? interviewStatus;
  final String? status;
  final String? interviewDate;
  final String? interviewTime;
  final String? interviewMode;
  final String? interviewRound;
  final String? meetingLinkOrLocation;
  final String? interviewerName;
  final String? contactEmail;
  final String? interviewInstructions;
  final String? companyName;
  final String? offerLetter;
  final String? createdAt;
  final String? updatedAt;

  RecruiterResultItem({
    this.id,
    this.recruiter,
    this.student,
    this.job,
    this.type,
    this.interviewStatus,
    this.status,
    this.interviewDate,
    this.interviewTime,
    this.interviewMode,
    this.interviewRound,
    this.meetingLinkOrLocation,
    this.interviewerName,
    this.contactEmail,
    this.interviewInstructions,
    this.companyName,
    this.offerLetter,
    this.createdAt,
    this.updatedAt,
  });

  String get displayStatus =>
      (interviewStatus ?? status ?? '').trim();

  factory RecruiterResultItem.fromJson(Map<String, dynamic> json) {
    return RecruiterResultItem(
      id: (json['_id'] ?? json['id'])?.toString(),
      recruiter: json['recruiter'] is Map
          ? json['recruiter']['_id']?.toString()
          : json['recruiter']?.toString(),
      student: json['student'] != null && json['student'] is Map
          ? RecruiterResultStudent.fromJson(
              Map<String, dynamic>.from(json['student']))
          : null,
      job: json['job'] != null && json['job'] is Map
          ? RecruiterResultJob.fromJson(Map<String, dynamic>.from(json['job']))
          : null,
      type: json['type']?.toString(),
      interviewStatus: json['interviewStatus']?.toString(),
      status: json['status']?.toString(),
      interviewDate: json['interviewDate']?.toString(),
      interviewTime: json['interviewTime']?.toString(),
      interviewMode: json['interviewMode']?.toString(),
      interviewRound: json['interviewRound']?.toString(),
      meetingLinkOrLocation: json['meetingLinkOrLocation']?.toString(),
      interviewerName: json['interviewerName']?.toString(),
      contactEmail: json['contactEmail']?.toString(),
      interviewInstructions: json['interviewInstructions']?.toString(),
      companyName: (json['companyName'] ?? json['companyname'])?.toString(),
      offerLetter: json['offerLetter']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

class RecruiterResultStudent {
  final String? id;
  final String? studprofile;
  final String? studname;
  final String? studemail;
  final String? studmobileno;

  RecruiterResultStudent({
    this.id,
    this.studprofile,
    this.studname,
    this.studemail,
    this.studmobileno,
  });

  factory RecruiterResultStudent.fromJson(Map<String, dynamic> json) {
    return RecruiterResultStudent(
      id: (json['_id'] ?? json['id'])?.toString(),
      studprofile: json['studprofile']?.toString(),
      studname: (json['studname'] ?? json['name'])?.toString(),
      studemail: (json['studemail'] ?? json['email'])?.toString(),
      studmobileno: (json['studmobileno'] ?? json['mobile'])?.toString(),
    );
  }
}

class RecruiterResultJob {
  final String? id;
  final String? companyname;
  final String? companylogo;
  final String? roletype;

  RecruiterResultJob({
    this.id,
    this.companyname,
    this.companylogo,
    this.roletype,
  });

  factory RecruiterResultJob.fromJson(Map<String, dynamic> json) {
    return RecruiterResultJob(
      id: (json['_id'] ?? json['id'])?.toString(),
      companyname: (json['companyname'] ?? json['companyName'])?.toString(),
      companylogo: (json['companylogo'] ?? json['companyLogo'])?.toString(),
      roletype: (json['roletype'] ?? json['roleType'] ?? json['title'])?.toString(),
    );
  }
}

class PaginationData {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationData({
    this.total = 0,
    this.page = 1,
    this.limit = 12,
    this.totalPages = 1,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      total: json['total'] is num
          ? (json['total'] as num).toInt()
          : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      page: json['page'] is num
          ? (json['page'] as num).toInt()
          : int.tryParse(json['page']?.toString() ?? '1') ?? 1,
      limit: json['limit'] is num
          ? (json['limit'] as num).toInt()
          : int.tryParse(json['limit']?.toString() ?? '12') ?? 12,
      totalPages: json['totalPages'] is num
          ? (json['totalPages'] as num).toInt()
          : int.tryParse(json['totalPages']?.toString() ?? '1') ?? 1,
    );
  }
}

