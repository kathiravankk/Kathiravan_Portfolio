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
  String? title;
  String? aboutInternship;
  String? internshipDescription;
  String? internshipQualification;
  String? studentQualification;
  String? fieldOfStudy;
  List<String>? requiredSkills;
  String? eligibilityCriteria;
  String? companyState;
  String? companyCity;
  String? locationLink;
  String? internshipDuration;
  String? internshipStipend;
  RecruiterData? recruiter;
  RecruiterData? industry;
  String? createdAt;
  String? updatedAt;
  String? internshipMode;
  int? iV;
  bool? applied;

  InternshipData({
    this.syllabusData,
    this.sId,
    this.companyName,
    this.aboutCompany,
    this.companyWebsite,
    this.companyLogo,
    this.roleType,
    this.title,
    this.aboutInternship,
    this.internshipDescription,
    this.internshipQualification,
    this.studentQualification,
    this.fieldOfStudy,
    this.requiredSkills,
    this.eligibilityCriteria,
    this.companyState,
    this.companyCity,
    this.locationLink,
    this.internshipDuration,
    this.internshipStipend,
    this.recruiter,
    this.industry,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.applied,
    this.internshipMode
  });

  InternshipData.fromJson(Map<String, dynamic> json) {
    syllabusData = json['syllabusdata'] ?? "";
    sId = json['_id'] ?? "";
    companyName = json['companyname'] ?? "";
    aboutCompany = json['aboutcompany'] ?? "";
    companyWebsite = json['companywebsite'] ?? "";
    companyLogo = json['companylogo'] ?? "";
    roleType = json['roletype'] ?? "";
    title = json['title'] ?? "";
    aboutInternship = json['aboutinternship'] ?? "";
    internshipDescription = json['intershipdescription'] ?? "";
    internshipQualification = json['Internshipqualification'] ?? "";
    studentQualification = json['studentqualification'] ?? "";
    fieldOfStudy = json['fieldofstudy'] ?? "";
    requiredSkills = json['requiredskills'].cast<String>();
    eligibilityCriteria = json['eligibilitycriteria'] ?? "";
    companyState = json['companystate'] ?? "";
    companyCity = json['companycity'] ?? "";
    locationLink = json['locationlink'] ?? "";
    internshipDuration = json['internshipduration'] ?? "";
    internshipStipend = json['internshipstipend'] ?? "";
    recruiter = json['recruiter'] != null
        ? RecruiterData.fromJson(json['recruiter'])
        : null;
    industry = json['industry'] != null
        ? RecruiterData.fromJson(json['industry'])
        : null;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    iV = json['__v'] ?? 0;
    applied = json['applied'] ?? false;
    internshipMode = json['internshipmode'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['syllabusdata'] = syllabusData;
    data['internshipmode'] = internshipMode;
    data['_id'] = sId;
    data['companyname'] = companyName;
    data['aboutcompany'] = aboutCompany;
    data['companywebsite'] = companyWebsite;
    data['companylogo'] = companyLogo;
    data['roletype'] = roleType;
    data['title'] = title;
    data['aboutinternship'] = aboutInternship;
    data['intershipdescription'] = internshipDescription;
    data['Internshipqualification'] = internshipQualification;
    data['studentqualification'] = studentQualification;
    data['fieldofstudy'] = fieldOfStudy;
    data['requiredskills'] = requiredSkills;
    data['eligibilitycriteria'] = eligibilityCriteria;
    data['companystate'] = companyState;
    data['companycity'] = companyCity;
    data['locationlink'] = locationLink;
    data['internshipduration'] = internshipDuration;
    data['internshipstipend'] = internshipStipend;
    if (recruiter != null) {
      data['recruiter'] = recruiter!.toJson();
    }
    if (industry != null) {
      data['industry'] = industry!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['applied'] = applied;
    return data;
  }
}

class RecruiterData {
  String? sId;
  String? name;

  RecruiterData({this.sId});

  RecruiterData.fromJson(Map<String, dynamic> json) {
    sId = json['_id']??"";
    sId = json['name']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

