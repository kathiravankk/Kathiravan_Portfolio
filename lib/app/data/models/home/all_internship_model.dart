class AllInternshipModel {
  final String? message;
  final bool? success;
  final int? count;
  final int? page;
  final int? limit;
  final int? totalPages;
  final int? totalJobs;
  final List<InternshipModel>? internship;

  AllInternshipModel({
    this.message,
    this.success,
    this.count,
    this.page,
    this.limit,
    this.totalPages,
    this.totalJobs,
    this.internship,
  });

  factory AllInternshipModel.fromJson(Map<String, dynamic> json) {
    return AllInternshipModel(
      message: json['message'],
      success: json['success'],
      count: json['count'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      totalJobs: json['totalJobs'],
      internship: json['jobs'] != null
          ? List<InternshipModel>.from(
        json['jobs'].map((x) => InternshipModel.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "success": success,
      "count": count,
      "page": page,
      "limit": limit,
      "totalPages": totalPages,
      "totalJobs": totalJobs,
      "jobs": internship?.map((x) => x.toJson()).toList(),
    };
  }
}

class InternshipModel {
  String? id;
  String? companyName;
  String? aboutCompany;
  String? companyWebsite;
  String? companyLogo;
  String? roleType;
  String? title;
  String? aboutInternship;
  String? internshipDescription;
  List<String>? studentQualification;
  List<String>? requiredSkills;
  String? eligibilityCriteria;
  String? companyState;
  String? companyCity;
  String? locationLink;
  String? internshipDuration;
  String? internshipStipend;
  String? fee;
  List<String>? projectDescription;
  String? internshipMode;
  String? days;
  String? recruiter;
  String? industry;
  dynamic syllabusData;
  String? createdAt;
  String? updatedAt;
  int? v;
  bool? isSaved;

  InternshipModel({
    this.id,
    this.companyName,
    this.aboutCompany,
    this.companyWebsite,
    this.companyLogo,
    this.roleType,
    this.title,
    this.aboutInternship,
    this.internshipDescription,
    this.studentQualification,
    this.requiredSkills,
    this.eligibilityCriteria,
    this.companyState,
    this.companyCity,
    this.locationLink,
    this.internshipDuration,
    this.internshipStipend,
    this.fee,
    this.projectDescription,
    this.internshipMode,
    this.days,
    this.recruiter,
    this.industry,
    this.syllabusData,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isSaved,
  });

  factory InternshipModel.fromJson(Map<String, dynamic> json) {
    return InternshipModel(
      id: json['_id'],
      companyName: json['companyname'],
      aboutCompany: json['aboutcompany'],
      companyWebsite: json['companywebsite'],
      companyLogo: json['companylogo'],
      roleType: json['roletype'],
      title: json['title'],
      aboutInternship: json['aboutinternship'],
      internshipDescription: json['internshipdescription'],
      studentQualification: json['studentqualification'] != null
          ? List<String>.from(json['studentqualification'])
          : [],
      requiredSkills: json['requiredskills'] != null
          ? List<String>.from(json['requiredskills'])
          : [],
      eligibilityCriteria: json['eligibilitycriteria'],
      companyState: json['companystate'],
      companyCity: json['companycity'],
      locationLink: json['locationlink'],
      internshipDuration: json['internshipduration'],
      internshipStipend: json['internshipstipend'],
      fee: json['fee'],
      projectDescription: json['project_description'] != null
          ? List<String>.from(json['project_description'])
          : [],
      internshipMode: json['internshipmode'],
      days: json['days'],
      recruiter: json['recruiter'],
      industry: json['industry'],
      syllabusData: json['syllabusdata'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      isSaved: json['isSaved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "companyname": companyName,
      "aboutcompany": aboutCompany,
      "companywebsite": companyWebsite,
      "companylogo": companyLogo,
      "roletype": roleType,
      "title": title,
      "aboutinternship": aboutInternship,
      "internshipdescription": internshipDescription,
      "studentqualification": studentQualification,
      "requiredskills": requiredSkills,
      "eligibilitycriteria": eligibilityCriteria,
      "companystate": companyState,
      "companycity": companyCity,
      "locationlink": locationLink,
      "internshipduration": internshipDuration,
      "internshipstipend": internshipStipend,
      "fee": fee,
      "project_description": projectDescription,
      "internshipmode": internshipMode,
      "days": days,
      "recruiter": recruiter,
      "industry": industry,
      "syllabusdata": syllabusData,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
      "isSaved": isSaved,
    };
  }
}