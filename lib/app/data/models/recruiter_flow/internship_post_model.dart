class InternshipPostModel {
  final bool? success;
  final String? message;
  final String? statusFilter;
  final int? count;
  final int? total;
  final int? totalPages;
  final int? currentPage;
  final int? limit;
  final List<PostData>? jobs;

  InternshipPostModel({
    this.success,
    this.message,
    this.statusFilter,
    this.count,
    this.total,
    this.totalPages,
    this.currentPage,
    this.limit,
    this.jobs,
  });

  factory InternshipPostModel.fromJson(Map<String, dynamic> json) {
    return InternshipPostModel(
      success: json['success'] ?? false,
      message: json['message'],
      statusFilter: json['statusFilter'],
      count: json['count'],
      total: json['total'] is num
          ? (json['total'] as num).toInt()
          : int.tryParse(json['total']?.toString() ?? '0'),
      totalPages: json['totalPages'] is num
          ? (json['totalPages'] as num).toInt()
          : int.tryParse(json['totalPages']?.toString() ?? '1'),
      currentPage: json['currentPage'] is num
          ? (json['currentPage'] as num).toInt()
          : int.tryParse(json['currentPage']?.toString() ?? '1'),
      limit: json['limit'] is num
          ? (json['limit'] as num).toInt()
          : int.tryParse(json['limit']?.toString() ?? '12'),
      jobs: json['jobs'] != null
          ? List<PostData>.from(
          json['jobs'].map((e) => PostData.fromJson(e)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'statusFilter': statusFilter,
    'count': count,
    'total': total,
    'totalPages': totalPages,
    'currentPage': currentPage,
    'limit': limit,
    'jobs': jobs?.map((e) => e.toJson()).toList(),
  };
}

class PostData {
  final String? id;
  final String? companyName;
  final String? aboutCompany;
  final String? companyWebsite;
  final String? companyLogo;
  final String? roleType;
  final String? internshipNameCoordinator;
  final String? internshipMobileCoordinator;
  final String? internshipEmailCoordinator;
  final InternshipCoordinator? internshipCoordinator;
  final String? aboutInternship;
  final List<String>? studentQualification;
  final List<String>? requiredSkills;
  final String? companyState;
  final String? companyCity;
  final String? locationLink;
  final JobLocation? location;
  final String? internshipDuration;
  final String? internshipStipend;
  final String? fee;
  final List<String>? projectDescription;
  final String? internshipMode;
  final String? days;
  final String? recruiter;
  final JobIndustry? industry;
  final int? noOfPosition;
  final int? totalApplicants;
  final int? selectedApplicants;
  final int? rejectedApplicants;
  final int? internPositions;
  final int? filledPositions;
  final dynamic syllabusData;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final bool? isActive;
  final dynamic status;
  final bool? isDeleted;
  final int? views;

  PostData({
    this.internshipNameCoordinator,
    this.id,
    this.companyName,
    this.aboutCompany,
    this.companyWebsite,
    this.companyLogo,
    this.roleType,
    this.aboutInternship,
    this.studentQualification,
    this.requiredSkills,
    this.companyState,
    this.companyCity,
    this.locationLink,
    this.location,
    this.internshipDuration,
    this.internshipStipend,
    this.fee,
    this.projectDescription,
    this.internshipMode,
    this.days,
    this.recruiter,
    this.industry,
    this.noOfPosition,
    this.internPositions,
    this.filledPositions,
    this.syllabusData,
    this.totalApplicants,
    this.selectedApplicants,
    this.rejectedApplicants,
    this.createdAt,
    this.updatedAt,
    this.internshipEmailCoordinator,
    this.internshipMobileCoordinator,
    this.internshipCoordinator,
    this.v,
    this.isActive,
    this.status,
    this.isDeleted,
    this.views,
  });

  /// Helper: returns true when the job is currently active
  bool get isJobActive {
    if (isActive == true) return true;
    if (status == true || status == 'true' || status == 1) return true;
    return false;
  }

  factory PostData.fromJson(Map<String, dynamic> json) {
    // Parse nested internshipCoordinator object
    final coordJson = json['internshipCoordinator'] as Map<String, dynamic>?;
    final InternshipCoordinator? coordinator =
        coordJson != null ? InternshipCoordinator.fromJson(coordJson) : null;

    return PostData(
      id: json['_id'] ?? "",
      companyName: json['companyname'] ?? "",
      aboutCompany: json['aboutcompany'] ?? "",
      companyWebsite: json['companywebsite'] ?? "",
      // Prefer nested coordinator object; fall back to flat fields
      internshipEmailCoordinator:
          coordinator?.email ?? json['coordinatorEmail'] ?? "",
      internshipMobileCoordinator:
          coordinator?.mobile ?? json['coordinatorMobile'] ?? "",
      internshipNameCoordinator:
          coordinator?.name ?? json['internship_coordinator'] ?? "",
      internshipCoordinator: coordinator,
      companyLogo: json['companylogo'] ?? "",
      roleType: json['roletype'] ?? "",
      aboutInternship: json['aboutinternship'] ?? "",
      studentQualification: json['studentqualification'] != null
          ? List<String>.from(json['studentqualification'])
          : null,
      requiredSkills: json['requiredskills'] != null
          ? List<String>.from(json['requiredskills'])
          : null,
      companyState: json['companystate'] ?? "",
      companyCity: json['companycity'] ?? "",
      locationLink: json['locationlink'] ?? "",
      location: json['location'] != null
          ? JobLocation.fromJson(json['location'])
          : null,
      internshipDuration: json['internshipduration'] ?? "",
      internshipStipend: json['internshipstipend'] ?? "",
      fee: json['fee'] ?? "",
      projectDescription: json['project_description'] != null
          ? List<String>.from(json['project_description'])
          : null,
      internshipMode: json['internshipmode'] ?? "",
      days: json['days'] ?? "",
      recruiter: json['recruiter'] ?? "",
      industry: json['industry'] != null
          ? JobIndustry.fromJson(json['industry'])
          : null,
      noOfPosition: json['noofposition'] ?? 0,
      internPositions: json['internpositions'] ?? 0,
      filledPositions: json['filledpositions'] ?? 0,
      totalApplicants: json['totalApplications'] ?? 0,
      selectedApplicants: json['selectedApplications'] ?? 0,
      rejectedApplicants: json['rejectedApplications'] ?? 0,
      syllabusData: json['syllabusdata'],
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      v: json['__v'] ?? 0,
      isActive: json['isActive'] is bool
          ? json['isActive']
          : (json['isActive']?.toString().toLowerCase() == 'true'),
      status: json['status'],
      isDeleted: json['isDeleted'] is bool
          ? json['isDeleted']
          : (json['isDeleted']?.toString().toLowerCase() == 'true'),
      views: json['views'] is num
          ? (json['views'] as num).toInt()
          : int.tryParse(json['views']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'companyname': companyName,
    'aboutcompany': aboutCompany,
    'companywebsite': companyWebsite,
    'companylogo': companyLogo,
    'roletype': roleType,
    'internship_coordinator': internshipNameCoordinator,
    'totalApplications': totalApplicants,
    'aboutinternship': aboutInternship,
    'studentqualification': studentQualification,
    'requiredskills': requiredSkills,
    'companystate': companyState,
    'companycity': companyCity,
    'locationlink': locationLink,
    'location': location?.toJson(),
    'internshipduration': internshipDuration,
    'internshipstipend': internshipStipend,
    'fee': fee,
    'project_description': projectDescription,
    'internshipmode': internshipMode,
    'days': days,
    'recruiter': recruiter,
    'industry': industry?.toJson(),
    'noofposition': noOfPosition,
    'internpositions': internPositions,
    'filledpositions': filledPositions,
    'syllabusdata': syllabusData,
    'isActive': isActive,
    'status': status,
    'isDeleted': isDeleted,
    'views': views,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };

  /// Helper: returns true when there is a coordinator attached
  bool get hasCoordinator =>
      internshipCoordinator != null ||
      (internshipNameCoordinator != null &&
          internshipNameCoordinator!.isNotEmpty);

  /// Available slots = internPositions - filledPositions
  int get availableSlots =>
      (internPositions ?? 0) - (filledPositions ?? 0);

  /// Whether the internship is paid
  bool get isPaid =>
      internshipStipend != null &&
          internshipStipend != 'N/A' &&
          internshipStipend!.isNotEmpty;

  /// Whether there is a fee
  bool get hasFee => fee != null && fee != '0' && fee!.isNotEmpty;
}

/// Coordinator details (nested object from API)
class InternshipCoordinator {
  final String? id;
  final String? name;
  final String? email;
  final String? mobile;
  final String? role;
  final bool? isActive;

  InternshipCoordinator({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.role,
    this.isActive,
  });

  factory InternshipCoordinator.fromJson(Map<String, dynamic> json) {
    return InternshipCoordinator(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      role: json['role'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'mobile': mobile,
    'role': role,
    'isActive': isActive,
  };
}

class JobLocation {
  final String? type;
  final List<double>? coordinates; // [longitude, latitude]

  JobLocation({this.type, this.coordinates});

  factory JobLocation.fromJson(Map<String, dynamic> json) {
    return JobLocation(
      type: json['type']??"",
      coordinates: json['coordinates'] != null
          ? List<double>.from(
          json['coordinates'].map((e) => (e as num).toDouble()))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': coordinates,
  };

  double? get longitude => coordinates?.isNotEmpty == true ? coordinates![0] : null;
  double? get latitude => coordinates?.length == 2 ? coordinates![1] : null;
}

class JobIndustry {
  final String? id;
  final String? name;

  JobIndustry({this.id, this.name});

  factory JobIndustry.fromJson(Map<String, dynamic> json) {
    return JobIndustry(
      id: json['_id']??"",
      name: json['name']??"",
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}