class SavedInternshipModel {
  final String? message;
  final int? count;
  final List<SavedJobData>? jobData;

  SavedInternshipModel({this.message, this.count, this.jobData});

  factory SavedInternshipModel.fromJson(Map<String, dynamic> json) {
    return SavedInternshipModel(
      message: json['message'] ?? "",
      count: json['count'] ?? 0,
      jobData: json['data'] != null
          ? List<SavedJobData>.from(
              json['data'].map((x) => SavedJobData.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "count": count,
      "data": jobData?.map((x) => x.toJson()).toList(),
    };
  }
}

class SavedJobData {
  final String? id;
  final JobModel? job;
  final String? student;
  final String? createdAt;
  final String? updatedAt;
  final int? vId;

  SavedJobData({
    this.id,
    this.job,
    this.student,
    this.createdAt,
    this.updatedAt,
    this.vId,
  });

  factory SavedJobData.fromJson(Map<String, dynamic> json) {
    return SavedJobData(
      id: json['_id'] ?? "",
      job: json['job'] != null ? JobModel.fromJson(json['job']) : null,
      student: json['student'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      vId: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "job": job?.toJson(),
      "student": student,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": vId,
    };
  }
}


class JobData {
  final String? id;
  final String? job;
  final String? student;
  final String? createdAt;
  final String? updatedAt;
  final int? vId;

  JobData({
    this.id,
    this.job,
    this.student,
    this.createdAt,
    this.updatedAt,
    this.vId,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      id: json['_id'] ?? "",
      job: json['job'] ??"",
      student: json['student'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      vId: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "job": job,
      "student": student,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": vId,
    };
  }
}

class JobModel {
  final String? id;
  final String? companyName;
  final String? aboutCompany;
  final String? companyWebsite;
  final String? companyLogo;
  final String? roleType;
  final String? title;
  final String? aboutInternship;
  final String? internshipDescription;
  final String? internshipQualification;
  final String? studentQualification;
  final String? fieldOfStudy;
  final List<String>? requiredSkills;
  final String? eligibilityCriteria;
  final String? companyState;
  final String? companyCity;
  final String? locationLink;
  final String? internshipDuration;
  final String? internshipStipend;
  final String? internshipMode;
  final String? recruiter;
  final String? industry;
  final String? syllabusData;
  final String? createdAt;
  final String? updatedAt;
  final int? vId;

  JobModel({
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
    this.internshipMode,
    this.recruiter,
    this.industry,
    this.syllabusData,
    this.createdAt,
    this.updatedAt,
    this.vId,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
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
      studentQualification: json['studentqualification'] ?? "",
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
      internshipMode: json['internshipmode'] ?? "",
      recruiter: json['recruiter'] ?? "",
      industry: json['industry'] ?? "",
      syllabusData: json['syllabusdata'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      vId: json['__v'] ?? 0,
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
      "requiredskills": requiredSkills,
      "eligibilitycriteria": eligibilityCriteria,
      "companystate": companyState,
      "companycity": companyCity,
      "locationlink": locationLink,
      "internshipduration": internshipDuration,
      "internshipstipend": internshipStipend,
      "internshipmode": internshipMode,
      "recruiter": recruiter,
      "industry": industry,
      "syllabusdata": syllabusData,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": vId,
    };
  }
}

class SavedNewInternshipModel {
  final String? message;
  final JobData? data;

  SavedNewInternshipModel({
    this.message,
    this.data,
  });

  factory SavedNewInternshipModel.fromJson(Map<String, dynamic> json) {
    return SavedNewInternshipModel(
      message: json['message'] ??"",
      data: json['data'] != null
          ? JobData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "data": data?.toJson(),
    };
  }
}

