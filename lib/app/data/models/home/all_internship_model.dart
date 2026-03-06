class AllInternshipModel {
  final String? message;
  final bool? success;
  final int? count;
  final int? page;
  final int? limit;
  final int? totalPages;
  final int? totalJobs;
  final List<InternshipModel>? internship;

  AllInternshipModel({this.message, this.count, this.internship, this.success,
  this.limit,this.page,
  this.totalJobs,
  this.totalPages});

  factory AllInternshipModel.fromJson(Map<String, dynamic> json) {
    return AllInternshipModel(
      message: json['message'] ?? "",
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalJobs: json['totalJobs'] ?? 0,
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
      "totalJobs": totalJobs,
      "totalPages": totalPages,
      "limit": limit,
      "page": page,
      "success": success,
      "count": count,
      "jobs": internship != null
          ? List<dynamic>.from(internship!.map((x) => x.toJson()))
          : [],
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
   dynamic projectDescription;
   String? internshipMode;
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
    this.projectDescription,
    this.internshipMode,
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
      id: json['_id'] ?? "",
      companyName: json['companyname'] ?? "",
      aboutCompany: json['aboutcompany'] ?? "",
      companyWebsite: json['companywebsite'] ?? "",
      companyLogo: json['companylogo'] ?? "",
      roleType: json['roletype'] ?? "",
      title: json['title'] ?? "",
      aboutInternship: json['aboutinternship'] ?? "",
      internshipDescription: json['intershipdescription'] ?? "",
      internshipQualification: json['Internshipqualification'] ?? "",
      //studentQualification: json['studentqualification'] ?? "",
      studentQualification: json['studentqualification'] != null
          ? List<String>.from(json['studentqualification'])
          : [],
      fieldOfStudy: json['fieldofstudy'] ?? "",
      requiredSkills: json['requiredskills'] != null
          ? List<String>.from(json['requiredskills'])
          : [],
      eligibilityCriteria: json['eligibilitycriteria'] ?? "",
      companyState: json['companystate'] ?? "",
      companyCity: json['companycity'] ?? "",
      locationLink: json['locationlink'] ?? "",
      internshipDuration: json['internshipduration'] ?? "",
      internshipStipend: json['internshipstipend'] ?? "",
      // projectDescription: json['project_description'] != null
      //     ? List<String>.from(json['project_description'])
      //     : [],
      projectDescription: json["project_description"] ?? "",
      internshipMode: json['internshipmode'] ?? "",
      recruiter: json['recruiter'] ?? "",
      industry: json['industry'] ?? "",
      syllabusData: json['syllabusdata'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      v: json['__v'] ?? 0,
      isSaved: json['isSaved'] ?? false,
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
      "intershipdescription": internshipDescription,
      "Internshipqualification": internshipQualification,
      "studentqualification": studentQualification,
      "fieldofstudy": fieldOfStudy,
      "requiredskills": requiredSkills ?? [],
      "eligibilitycriteria": eligibilityCriteria,
      "companystate": companyState,
      "companycity": companyCity,
      "locationlink": locationLink,
      "internshipduration": internshipDuration,
      "internshipstipend": internshipStipend,
      "project_description": projectDescription ?? [],
      "internshipmode": internshipMode,
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
