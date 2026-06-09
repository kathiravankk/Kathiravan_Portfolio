class CategoryWiseInternshipModel {
  String? message;
  int? count;
  List<InternshipData>? jobs;

  CategoryWiseInternshipModel({this.message, this.count, this.jobs});

  CategoryWiseInternshipModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    count = json['count'] ?? 0;
    if (json['jobs'] != null) {
      jobs = <InternshipData>[];
      json['jobs'].forEach((v) {
        jobs!.add(InternshipData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['count'] = count;
    if (jobs != null) {
      data['jobs'] = jobs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InternshipData {
  dynamic syllabusData;
  String? sId;
  String? companyName;
  String? aboutCompany;
  String? companyWebsite;
  String? companyLogo;
  String? roleType;
  String? aboutInternship;
  List<String>? studentQualification;
  List<String>? requiredSkills;
  String? companyState;
  String? companyCity;
  String? locationLink;
  String? internshipDuration;
  String? internshipStipend;
  String? fee;
  List<String>? projectDescription;
  String? internshipMode;
  String? days;
  RecruiterData? recruiter;
  IndustryData? industry;
  String? createdAt;
  String? updatedAt;
  int? v;
  bool? isSaved;
  int? noOfPosition;
  bool? isSyllabusGenerated;
  bool? isCertificateGenerated;
  int? totalApplication;
  int? totalReviews;
  dynamic averageRating;
  String? status;

  InternshipData({
    this.syllabusData,
    this.sId,
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
    this.internshipDuration,
    this.internshipStipend,
    this.fee,
    this.projectDescription,
    this.internshipMode,
    this.days,
    this.recruiter,
    this.industry,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isSaved,
    this.isSyllabusGenerated,
    this.isCertificateGenerated,
    this.totalApplication,
    this.totalReviews,
    this.averageRating,
    this.status,
    this.noOfPosition
  });

  factory InternshipData.fromJson(Map<String, dynamic> json) {
    return InternshipData(
      syllabusData: json['syllabusdata'],
      noOfPosition: json['noofposition']??0,
      sId: json['_id'],
      companyName: json['companyname'],
      aboutCompany: json['aboutcompany'],
      companyWebsite: json['companywebsite'],
      companyLogo: json['companylogo'],
      roleType: json['roletype'],
      aboutInternship: json['aboutinternship'],
      studentQualification: json['studentqualification'] != null
          ? List<String>.from(json['studentqualification'])
          : [],
      requiredSkills: json['requiredskills'] != null
          ? List<String>.from(json['requiredskills'])
          : [],
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
      recruiter: json['recruiter'] != null
          ? RecruiterData.fromJson(json['recruiter'])
          : null,
      industry: json['industry'] != null
          ? IndustryData.fromJson(json['industry'])
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      isSaved: json['isSaved'] ?? false,
      isSyllabusGenerated: json['issyllabusgenerated'] ?? false,
      isCertificateGenerated: json['iscertificategenerated'] ?? false,
      totalApplication: json['totalapplication'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: json['averageRating'],
      status: json['status']??"", // can be null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "syllabusdata": syllabusData,
      "_id": sId,
      "companyname": companyName,
      "aboutcompany": aboutCompany,
      "companywebsite": companyWebsite,
      "companylogo": companyLogo,
      "roletype": roleType,
      "aboutinternship": aboutInternship,
      "studentqualification": studentQualification,
      "requiredskills": requiredSkills,
      "companystate": companyState,
      "companycity": companyCity,
      "locationlink": locationLink,
      "internshipduration": internshipDuration,
      "internshipstipend": internshipStipend,
      "fee": fee,
      "project_description": projectDescription,
      "internshipmode": internshipMode,
      "days": days,
      "recruiter": recruiter?.toJson(),
      "industry": industry?.toJson(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
      "isSaved": isSaved,
      "issyllabusgenerated": isSyllabusGenerated,
      "iscertificategenerated": isCertificateGenerated,
      "totalapplication": totalApplication,
      "totalReviews": totalReviews,
      "averageRating": averageRating,
      "status": status,
    };
  }
}

class IndustryData {
  String? id;
  String? name;

  IndustryData({this.id, this.name});

  factory IndustryData.fromJson(Map<String, dynamic> json) {
    return IndustryData(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
    };
  }
}

class RecruiterData {
  String? sId;
  String? name;

  RecruiterData({this.sId});

  RecruiterData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? "";
    sId = json['name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}
