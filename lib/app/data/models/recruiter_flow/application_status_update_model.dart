class ApplicationStatusUpdateModel {
  final String? message;
  final ApplicationData? application;

  ApplicationStatusUpdateModel({
    this.message,
    this.application,
  });

  factory ApplicationStatusUpdateModel.fromJson(Map<String, dynamic> json) {
    return ApplicationStatusUpdateModel(
      message: json["message"] ?? "",
      application: json["application"] != null
          ? ApplicationData.fromJson(json["application"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "application": application?.toJson(),
  };
}

class ApplicationData {
  final String? id;
  final ApplicationJob? job;
  final ApplicationStudent? student;
  final ApplicationRecruiter? recruiter;
  final String? status;
  final int? currentDay;
  final String? jobMessage;
  final List<dynamic>? internProjectLink;
  final List<dynamic>? dailyProgress;
  final String? createdAt;
  final String? updatedAt;
  final String? selectedAt;
  final int? v;

  ApplicationData({
    this.id,
    this.job,
    this.student,
    this.recruiter,
    this.status,
    this.currentDay,
    this.jobMessage,
    this.internProjectLink,
    this.dailyProgress,
    this.createdAt,
    this.updatedAt,
    this.selectedAt,
    this.v,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    return ApplicationData(
      id: json["_id"] ?? "",
      job: json["job"] != null
          ? ApplicationJob.fromJson(json["job"])
          : null,
      student: json["student"] != null
          ? ApplicationStudent.fromJson(json["student"])
          : null,
      recruiter: json["recruiter"] != null
          ? ApplicationRecruiter.fromJson(json["recruiter"])
          : null,
      status: json["status"] ?? "",
      currentDay: json["currentDay"] ?? 0,
      jobMessage: json["jobmessage"] ?? "",
      internProjectLink: json["internProjectlink"] != null
          ? List<dynamic>.from(json["internProjectlink"])
          : [],
      dailyProgress: json["dailyProgress"] != null
          ? List<dynamic>.from(json["dailyProgress"])
          : [],
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      selectedAt: json["selectedAt"] ?? "",
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "job": job?.toJson(),
    "student": student?.toJson(),
    "recruiter": recruiter?.toJson(),
    "status": status,
    "currentDay": currentDay,
    "jobmessage": jobMessage,
    "internProjectlink": internProjectLink,
    "dailyProgress": dailyProgress,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "selectedAt": selectedAt,
    "__v": v,
  };
}

class ApplicationJob {
  final String? id;
  final JobLocation? location;
  final String? companyName;
  final String? aboutCompany;
  final String? companyWebsite;
  final String? companyLogo;
  final String? roleType;
  final String? aboutInternship;
  final List<String>? studentQualification;
  final List<String>? requiredSkills;
  final String? companyState;
  final String? companyCity;
  final String? locationLink;
  final String? internshipDuration;
  final String? internshipStipend;
  final String? fee;
  final List<String>? projectDescription;
  final String? internshipMode;
  final String? days;
  final String? recruiter;
  final String? industry;
  final int? noOfPosition;
  final int? internPositions;
  final int? filledPositions;
  final dynamic syllabusData;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  ApplicationJob({
    this.id,
    this.location,
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
    this.noOfPosition,
    this.internPositions,
    this.filledPositions,
    this.syllabusData,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ApplicationJob.fromJson(Map<String, dynamic> json) {
    return ApplicationJob(
      id: json["_id"] ?? "",
      location: json["location"] != null
          ? JobLocation.fromJson(json["location"])
          : null,
      companyName: json["companyname"] ?? "",
      aboutCompany: json["aboutcompany"] ?? "",
      companyWebsite: json["companywebsite"] ?? "",
      companyLogo: json["companylogo"] ?? "",
      roleType: json["roletype"] ?? "",
      aboutInternship: json["aboutinternship"] ?? "",
      studentQualification: json["studentqualification"] != null
          ? List<String>.from(json["studentqualification"])
          : [],
      requiredSkills: json["requiredskills"] != null
          ? List<String>.from(json["requiredskills"])
          : [],
      companyState: json["companystate"] ?? "",
      companyCity: json["companycity"] ?? "",
      locationLink: json["locationlink"] ?? "",
      internshipDuration: json["internshipduration"] ?? "",
      internshipStipend: json["internshipstipend"] ?? "",
      fee: json["fee"] ?? "",
      projectDescription: json["project_description"] != null
          ? List<String>.from(json["project_description"])
          : [],
      internshipMode: json["internshipmode"] ?? "",
      days: json["days"] ?? "",
      recruiter: json["recruiter"] ?? "",
      industry: json["industry"] ?? "",
      noOfPosition: json["noofposition"] ?? 0,
      internPositions: json["internpositions"] ?? 0,
      filledPositions: json["filledpositions"] ?? 0,
      syllabusData: json["syllabusdata"],
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "location": location?.toJson(),
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
    "recruiter": recruiter,
    "industry": industry,
    "noofposition": noOfPosition,
    "internpositions": internPositions,
    "filledpositions": filledPositions,
    "syllabusdata": syllabusData,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };

  int get availableSlots =>
      (internPositions ?? 0) - (filledPositions ?? 0);

  bool get isPaid =>
      internshipStipend != null &&
          internshipStipend!.isNotEmpty &&
          internshipStipend != "N/A";

  bool get hasFee =>
      fee != null &&
          fee!.isNotEmpty &&
          fee != "0";
}

class JobLocation {
  final String? type;
  final List<double>? coordinates;

  JobLocation({
    this.type,
    this.coordinates,
  });

  factory JobLocation.fromJson(Map<String, dynamic> json) {
    return JobLocation(
      type: json["type"] ?? "",
      coordinates: json["coordinates"] != null
          ? List<double>.from(
          json["coordinates"].map((e) => (e as num).toDouble()))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates,
  };

  double? get longitude =>
      coordinates != null && coordinates!.isNotEmpty
          ? coordinates![0]
          : null;

  double? get latitude =>
      coordinates != null && coordinates!.length > 1
          ? coordinates![1]
          : null;
}
class ApplicationStudent {
  final String? id;
  final Education? education;

  final String? studProfile;
  final String? studName;
  final String? studEmail;
  final String? studMobileNo;
  final String? role;

  final List<String>? studProgrammingLang;
  final List<StudentCertificate>? studentCertificate;

  final String? studentResume;
  final String? profileSummary;

  final List<String>? studentAdhar;
  final List<String>? studentIdProof;

  final List<String>? areasOfInterest;
  final List<String>? hobbies;
  final List<String>? languagesKnown;

  final List<dynamic>? volunteerExperience;
  final List<dynamic>? leadership;
  final List<dynamic>? achievements;
  final List<dynamic>? publications;

  final List<String>? workshops;

  final List<dynamic>? paperPresentations;
  final List<dynamic>? toolsAndTechnologies;

  final List<StudentProject>? projects;

  final List<dynamic>? experience;
  final List<dynamic>? internships;
  final List<dynamic>? industrialVisits;
  final List<dynamic>? trainings;
  final List<dynamic>? parents;

  final List<College>? college;
  final List<HigherSecondary>? higherSecondary;
  final List<Secondary>? secondary;

  final bool? freeBannerUsed;

  final List<String>? fcmTokens;

  final String? referralCode;
  final dynamic referredBy;
  final String? studentCreditId;

  final bool? isVerified;
  final bool? isWaterMarkRemoved;
  final bool? isActive;

  final dynamic deletedAt;

  final String? createdAt;
  final String? updatedAt;

  final int? v;

  final String? fontName;
  final String? github;
  final String? linkedIn;
  final String? location;
  final String? studentBanner;

  final String? studCollegeStartYear;
  final String? studDob;

  final String? studentCollegeName;
  final String? studentDegree;
  final String? studentFieldOfStudy;

  final String? studentSecondarySchoolName;
  final String? studentSecondarySchoolPercentage;

  final String? studHighSchoolName;
  final String? studHighSchoolPercentage;

  final String? templateNumber;
  final String? studCollegeLocation;

  ApplicationStudent({
    this.id,
    this.education,
    this.studProfile,
    this.studName,
    this.studEmail,
    this.studMobileNo,
    this.role,
    this.studProgrammingLang,
    this.studentCertificate,
    this.studentResume,
    this.profileSummary,
    this.studentAdhar,
    this.studentIdProof,
    this.areasOfInterest,
    this.hobbies,
    this.languagesKnown,
    this.volunteerExperience,
    this.leadership,
    this.achievements,
    this.publications,
    this.workshops,
    this.paperPresentations,
    this.toolsAndTechnologies,
    this.projects,
    this.experience,
    this.internships,
    this.industrialVisits,
    this.trainings,
    this.parents,
    this.college,
    this.higherSecondary,
    this.secondary,
    this.freeBannerUsed,
    this.fcmTokens,
    this.referralCode,
    this.referredBy,
    this.studentCreditId,
    this.isVerified,
    this.isWaterMarkRemoved,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.fontName,
    this.github,
    this.linkedIn,
    this.location,
    this.studentBanner,
    this.studCollegeStartYear,
    this.studDob,
    this.studentCollegeName,
    this.studentDegree,
    this.studentFieldOfStudy,
    this.studentSecondarySchoolName,
    this.studentSecondarySchoolPercentage,
    this.studHighSchoolName,
    this.studHighSchoolPercentage,
    this.templateNumber,
    this.studCollegeLocation,
  });

  factory ApplicationStudent.fromJson(Map<String, dynamic> json) {
    return ApplicationStudent(
      id: json["_id"] ?? "",
      education: json["education"] != null
          ? Education.fromJson(json["education"])
          : null,
      studProfile: json["studprofile"] ?? "",
      studName: json["studname"] ?? "",
      studEmail: json["studemail"] ?? "",
      studMobileNo: json["studmobileno"] ?? "",
      role: json["role"] ?? "",

      studProgrammingLang: json["studprogramminglang"] != null
          ? List<String>.from(json["studprogramminglang"])
          : [],

      studentCertificate: json["studentcertificate"] != null
          ? List<StudentCertificate>.from(
          json["studentcertificate"]
              .map((e) => StudentCertificate.fromJson(e)))
          : [],

      studentResume: json["studentresume"],
      profileSummary: json["profile_summary"] ?? "",

      studentAdhar: json["studentAdhar"] != null
          ? List<String>.from(json["studentAdhar"])
          : [],

      studentIdProof: json["studentId"] != null
          ? List<String>.from(json["studentId"])
          : [],

      areasOfInterest: json["areas_of_interest"] != null
          ? List<String>.from(json["areas_of_interest"])
          : [],

      hobbies: json["hobbies"] != null
          ? List<String>.from(json["hobbies"])
          : [],

      languagesKnown: json["languages_known"] != null
          ? List<String>.from(json["languages_known"])
          : [],

      volunteerExperience: json["volunteer_experience"] != null
          ? List<dynamic>.from(json["volunteer_experience"])
          : [],

      leadership: json["leadership"] != null
          ? List<dynamic>.from(json["leadership"])
          : [],

      achievements: json["achievements"] != null
          ? List<dynamic>.from(json["achievements"])
          : [],

      publications: json["publications"] != null
          ? List<dynamic>.from(json["publications"])
          : [],

      workshops: json["workshops"] != null
          ? List<String>.from(json["workshops"])
          : [],

      paperPresentations: json["paper_presentations"] != null
          ? List<dynamic>.from(json["paper_presentations"])
          : [],

      toolsAndTechnologies: json["tools_and_technologies"] != null
          ? List<dynamic>.from(json["tools_and_technologies"])
          : [],

      projects: json["projects"] != null
          ? List<StudentProject>.from(
          json["projects"].map((e) => StudentProject.fromJson(e)))
          : [],

      experience: json["experience"] != null
          ? List<dynamic>.from(json["experience"])
          : [],

      internships: json["internships"] != null
          ? List<dynamic>.from(json["internships"])
          : [],

      industrialVisits: json["industrial_visits"] != null
          ? List<dynamic>.from(json["industrial_visits"])
          : [],

      trainings: json["trainings"] != null
          ? List<dynamic>.from(json["trainings"])
          : [],

      parents: json["parents"] != null
          ? List<dynamic>.from(json["parents"])
          : [],

      college: json["college"] != null
          ? List<College>.from(
          json["college"].map((e) => College.fromJson(e)))
          : [],

      higherSecondary: json["higher_secondary"] != null
          ? List<HigherSecondary>.from(json["higher_secondary"]
          .map((e) => HigherSecondary.fromJson(e)))
          : [],

      secondary: json["secondary"] != null
          ? List<Secondary>.from(
          json["secondary"].map((e) => Secondary.fromJson(e)))
          : [],

      freeBannerUsed: json["freeBannerUsed"] ?? false,

      fcmTokens: json["fcmTokens"] != null
          ? List<String>.from(json["fcmTokens"])
          : [],

      referralCode: json["referralCode"] ?? "",
      referredBy: json["referredBy"],
      studentCreditId: json["studentCreditId"] ?? "",

      isVerified: json["isVerified"] ?? false,
      isWaterMarkRemoved: json["isWaterMarkRemoved"] ?? false,
      isActive: json["isActive"] ?? false,

      deletedAt: json["deletedAt"],

      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,

      fontName: json["font_name"] ?? "",
      github: json["github"] ?? "",
      linkedIn: json["linkedIn"] ?? "",
      location: json["location"] ?? "",
      studentBanner: json["student_banner"] ?? "",

      studCollegeStartYear: json["studcollegestartyear"] ?? "",
      studDob: json["studdob"],

      studentCollegeName: json["studentcollegename"] ?? "",
      studentDegree: json["studentdegree"] ?? "",
      studentFieldOfStudy: json["studentfieldofstudy"] ?? "",

      studentSecondarySchoolName:
      json["studentsecondaryschoolname"] ?? "",

      studentSecondarySchoolPercentage:
      json["studentsecondaryschoolpercentage"] ?? "",

      studHighSchoolName: json["studhighschollname"] ?? "",
      studHighSchoolPercentage: json["studhighschoolpercentage"] ?? "",

      templateNumber: json["templateNumber"] ?? "",
      studCollegeLocation: json["studcollegelocation"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {};
}

class Education {
  final School? school;
  final List<College>? college;

  Education({
    this.school,
    this.college,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      school:
      json["school"] != null ? School.fromJson(json["school"]) : null,
      college: json["college"] != null
          ? List<College>.from(
          json["college"].map((e) => College.fromJson(e)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {};
}

class School {
  final HigherSecondary? higherSecondary;
  final Secondary? secondary;

  School({
    this.higherSecondary,
    this.secondary,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      higherSecondary: json["higher_secondary"] != null
          ? HigherSecondary.fromJson(json["higher_secondary"])
          : null,
      secondary: json["secondary"] != null
          ? Secondary.fromJson(json["secondary"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {};
}

class HigherSecondary {
  final String? id;
  final String? institution;
  final String? board;
  final String? percentage;
  final String? yearOfPassing;

  HigherSecondary({
    this.id,
    this.institution,
    this.board,
    this.percentage,
    this.yearOfPassing,
  });

  factory HigherSecondary.fromJson(Map<String, dynamic> json) {
    return HigherSecondary(
      id: json["_id"] ?? "",
      institution: json["institution"] ?? "",
      board: json["board"] ?? "",
      percentage: json["percentage"] ?? "",
      yearOfPassing: json["year_of_passing"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {};
}

class Secondary {
  final String? id;
  final String? institution;
  final String? board;
  final String? percentage;
  final String? yearOfPassing;

  Secondary({
    this.id,
    this.institution,
    this.board,
    this.percentage,
    this.yearOfPassing,
  });

  factory Secondary.fromJson(Map<String, dynamic> json) {
    return Secondary(
      id: json["_id"] ?? "",
      institution: json["institution"] ?? "",
      board: json["board"] ?? "",
      percentage: json["percentage"] ?? "",
      yearOfPassing: json["year_of_passing"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {};
}

class College {
  final String? id;
  final String? degree;
  final String? department;
  final String? institution;
  final String? startYear;
  final String? endYear;

  College({
    this.id,
    this.degree,
    this.department,
    this.institution,
    this.startYear,
    this.endYear,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json["_id"] ?? "",
      degree: json["degree"] ?? "",
      department: json["department"] ?? "",
      institution: json["institution"] ?? "",
      startYear: json["start_year"] ?? "",
      endYear: json["end_year"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {};
}
class StudentCertificate {
  final String? name;
  final String? issuer;

  StudentCertificate({
    this.name,
    this.issuer,
  });

  factory StudentCertificate.fromJson(Map<String, dynamic> json) {
    return StudentCertificate(
      name: json["name"] ?? "",
      issuer: json["issuer"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "issuer": issuer,
  };
}

class StudentProject {
  final String? id;
  final String? title;
  final List<String>? description;

  StudentProject({
    this.id,
    this.title,
    this.description,
  });

  factory StudentProject.fromJson(Map<String, dynamic> json) {
    return StudentProject(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] != null
          ? List<String>.from(json["description"])
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
  };
}

class StudentExperience {
  final String? id;
  final String? companyName;
  final String? designation;
  final String? startDate;
  final String? endDate;
  final String? description;

  StudentExperience({
    this.id,
    this.companyName,
    this.designation,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory StudentExperience.fromJson(Map<String, dynamic> json) {
    return StudentExperience(
      id: json["_id"] ?? "",
      companyName: json["company_name"] ?? "",
      designation: json["designation"] ?? "",
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"] ?? "",
      description: json["description"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "company_name": companyName,
    "designation": designation,
    "start_date": startDate,
    "end_date": endDate,
    "description": description,
  };
}

class StudentInternship {
  final String? id;
  final String? companyName;
  final String? role;
  final String? duration;
  final String? description;

  StudentInternship({
    this.id,
    this.companyName,
    this.role,
    this.duration,
    this.description,
  });

  factory StudentInternship.fromJson(Map<String, dynamic> json) {
    return StudentInternship(
      id: json["_id"] ?? "",
      companyName: json["company_name"] ?? "",
      role: json["role"] ?? "",
      duration: json["duration"] ?? "",
      description: json["description"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "company_name": companyName,
    "role": role,
    "duration": duration,
    "description": description,
  };
}

class StudentTraining {
  final String? id;
  final String? title;
  final String? institute;
  final String? duration;

  StudentTraining({
    this.id,
    this.title,
    this.institute,
    this.duration,
  });

  factory StudentTraining.fromJson(Map<String, dynamic> json) {
    return StudentTraining(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      institute: json["institute"] ?? "",
      duration: json["duration"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "institute": institute,
    "duration": duration,
  };
}

class StudentWorkshop {
  final String? id;
  final String? title;

  StudentWorkshop({
    this.id,
    this.title,
  });

  factory StudentWorkshop.fromJson(Map<String, dynamic> json) {
    return StudentWorkshop(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
  };
}

class StudentVolunteerExperience {
  final String? id;
  final String? organization;
  final String? role;
  final String? description;

  StudentVolunteerExperience({
    this.id,
    this.organization,
    this.role,
    this.description,
  });

  factory StudentVolunteerExperience.fromJson(Map<String, dynamic> json) {
    return StudentVolunteerExperience(
      id: json["_id"] ?? "",
      organization: json["organization"] ?? "",
      role: json["role"] ?? "",
      description: json["description"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "organization": organization,
    "role": role,
    "description": description,
  };
}

class StudentAchievement {
  final String? id;
  final String? title;
  final String? description;

  StudentAchievement({
    this.id,
    this.title,
    this.description,
  });

  factory StudentAchievement.fromJson(Map<String, dynamic> json) {
    return StudentAchievement(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
  };
}

class StudentPublication {
  final String? id;
  final String? title;
  final String? publisher;
  final String? publishedDate;

  StudentPublication({
    this.id,
    this.title,
    this.publisher,
    this.publishedDate,
  });

  factory StudentPublication.fromJson(Map<String, dynamic> json) {
    return StudentPublication(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      publisher: json["publisher"] ?? "",
      publishedDate: json["published_date"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "publisher": publisher,
    "published_date": publishedDate,
  };
}

class StudentPaperPresentation {
  final String? id;
  final String? title;
  final String? event;

  StudentPaperPresentation({
    this.id,
    this.title,
    this.event,
  });

  factory StudentPaperPresentation.fromJson(Map<String, dynamic> json) {
    return StudentPaperPresentation(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      event: json["event"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "event": event,
  };
}

class StudentToolTechnology {
  final String? id;
  final String? name;

  StudentToolTechnology({
    this.id,
    this.name,
  });

  factory StudentToolTechnology.fromJson(Map<String, dynamic> json) {
    return StudentToolTechnology(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
  };
}

class StudentParent {
  final String? id;
  final String? name;
  final String? relation;
  final String? mobile;

  StudentParent({
    this.id,
    this.name,
    this.relation,
    this.mobile,
  });

  factory StudentParent.fromJson(Map<String, dynamic> json) {
    return StudentParent(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      relation: json["relation"] ?? "",
      mobile: json["mobile"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "relation": relation,
    "mobile": mobile,
  };
}
class ApplicationRecruiter {
  final String? id;
  final dynamic referredBy;
  final dynamic deletedAt;

  final String? recName;
  final String? recGender;
  final String? recEmail;
  final String? recMobileNo;
  final String? recSecondaryMobileNo;

  final String? recDesignation;

  final String? recCompanyName;
  final String? recCompanyWebsite;
  final String? recCompanySize;
  final String? recCompanyAddress;
  final String? recCompanyPincode;
  final String? recCompanyEmail;
  final String? recCompanyIndustryType;
  final String? recCompanyDocumentType;
  final String? recCompanyDescription;
  final String? recCompanyContactNo;
  final String? recCompanyDocument;
  final String? recCompanyLogo;

  final String? recruiterCreditId;

  final bool? isActive;

  final List<String>? fcmTokens;

  final String? referralCode;

  final String? createdAt;
  final String? updatedAt;

  final int? v;

  ApplicationRecruiter({
    this.id,
    this.referredBy,
    this.deletedAt,
    this.recName,
    this.recGender,
    this.recEmail,
    this.recMobileNo,
    this.recSecondaryMobileNo,
    this.recDesignation,
    this.recCompanyName,
    this.recCompanyWebsite,
    this.recCompanySize,
    this.recCompanyAddress,
    this.recCompanyPincode,
    this.recCompanyEmail,
    this.recCompanyIndustryType,
    this.recCompanyDocumentType,
    this.recCompanyDescription,
    this.recCompanyContactNo,
    this.recCompanyDocument,
    this.recCompanyLogo,
    this.recruiterCreditId,
    this.isActive,
    this.fcmTokens,
    this.referralCode,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ApplicationRecruiter.fromJson(Map<String, dynamic> json) {
    return ApplicationRecruiter(
      id: json["_id"] ?? "",
      referredBy: json["referredBy"],
      deletedAt: json["deletedAt"],

      recName: json["recname"] ?? "",
      recGender: json["recgender"] ?? "",
      recEmail: json["recemail"] ?? "",
      recMobileNo: json["recmobileno"] ?? "",
      recSecondaryMobileNo: json["recsecondarymobileno"] ?? "",

      recDesignation: json["recdesignation"] ?? "",

      recCompanyName: json["reccompanyname"] ?? "",
      recCompanyWebsite: json["reccompanywebsite"] ?? "",
      recCompanySize: json["reccompanysize"] ?? "",
      recCompanyAddress: json["reccompanyaddress"] ?? "",
      recCompanyPincode: json["reccompanypincode"] ?? "",
      recCompanyEmail: json["reccompanyemail"] ?? "",
      recCompanyIndustryType: json["reccompanyindustrytype"] ?? "",
      recCompanyDocumentType: json["reccompanydocumenttype"] ?? "",
      recCompanyDescription: json["reccompanydescription"] ?? "",
      recCompanyContactNo: json["reccompanycontactno"] ?? "",
      recCompanyDocument: json["reccompanydocument"] ?? "",
      recCompanyLogo: json["reccompanylogo"] ?? "",

      recruiterCreditId: json["recruiterCreditId"] ?? "",

      isActive: json["isActive"] ?? false,

      fcmTokens: json["fcmTokens"] != null
          ? List<String>.from(json["fcmTokens"])
          : [],

      referralCode: json["referralCode"] ?? "",

      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",

      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "referredBy": referredBy,
    "deletedAt": deletedAt,
    "recname": recName,
    "recgender": recGender,
    "recemail": recEmail,
    "recmobileno": recMobileNo,
    "recsecondarymobileno": recSecondaryMobileNo,
    "recdesignation": recDesignation,
    "reccompanyname": recCompanyName,
    "reccompanywebsite": recCompanyWebsite,
    "reccompanysize": recCompanySize,
    "reccompanyaddress": recCompanyAddress,
    "reccompanypincode": recCompanyPincode,
    "reccompanyemail": recCompanyEmail,
    "reccompanyindustrytype": recCompanyIndustryType,
    "reccompanydocumenttype": recCompanyDocumentType,
    "reccompanydescription": recCompanyDescription,
    "reccompanycontactno": recCompanyContactNo,
    "reccompanydocument": recCompanyDocument,
    "reccompanylogo": recCompanyLogo,
    "recruiterCreditId": recruiterCreditId,
    "isActive": isActive,
    "fcmTokens": fcmTokens,
    "referralCode": referralCode,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };
}