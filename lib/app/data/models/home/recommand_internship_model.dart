class RecommandInternshipModel {
  bool? success;
  List<String>? skillList;
  int? count;
  List<RecommentedData>? internshipList;

  RecommandInternshipModel({
    this.count,
    this.internshipList,
    this.skillList,
    this.success,
  });

  RecommandInternshipModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    count = json["count"] ?? 0;
    if (json['jobs'] != null) {
      internshipList = <RecommentedData>[];
      json['jobs'].forEach((v) {
        internshipList!.add(RecommentedData.fromJson(v));
      });
    }
    skillList = json['studentSkills'] != null
        ? List<String>.from(json['studentSkills'])
        : <String>[];
  }
}

class RecommentedData {
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
  List<String>? studentQualification;
  String? fieldOfStudy;
  List<String>? requiredSkills;
  String? eligibilityCriteria;
  String? companyState;
  String? companyCity;
  String? locationLink;
  String? internshipDuration;
  String? internshipStipend;
  String? recruiter;
  String? industry;
  String? createdAt;
  String? updatedAt;
  String? internshipMode;
  int? iV;
  bool? applied;
  bool? isSaved;

  RecommentedData({
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
    this.internshipMode,
    this.isSaved
  });

  RecommentedData.fromJson(Map<String, dynamic> json) {
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
    //studentQualification = json['studentqualification'] ?? "";
    studentQualification = json['studentqualification'].cast<String>();

    fieldOfStudy = json['fieldofstudy'] ?? "";
    requiredSkills = json['requiredskills'].cast<String>();
    eligibilityCriteria = json['eligibilitycriteria'] ?? "";
    companyState = json['companystate'] ?? "";
    companyCity = json['companycity'] ?? "";
    locationLink = json['locationlink'] ?? "";
    internshipDuration = json['internshipduration'] ?? "";
    internshipStipend = json['internshipstipend'] ?? "";
    recruiter = json['recruiter'] ?? "";
    industry = json['industry'] ?? "";
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    iV = json['__v'] ?? 0;
    applied = json['applied'] ?? false;
    internshipMode = json['internshipmode'] ?? "";
    isSaved = json['isSaved'] ?? false;
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
    data['recruiter'] = recruiter!;

    data['industry'] = industry!;

    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['applied'] = applied;
    return data;
  }
}
