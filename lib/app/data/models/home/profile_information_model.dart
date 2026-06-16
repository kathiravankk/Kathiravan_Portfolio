import 'package:internsharks/app/data/models/account/certification_model.dart';
import 'package:internsharks/app/data/models/account/education_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/student_profile_model.dart';
import 'package:internsharks/app/data/models/account/update_profile_model.dart';

class ProfileInformationModel {
  String? message;
  ProfileDataModel? profileData;

  ProfileInformationModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    profileData = json["student"] != null
        ? ProfileDataModel.fromJson(json["student"])
        : null;
  }

  ProfileInformationModel({this.profileData, this.message});
}

class ProfileDataModel {
  String? message;
  EducationModel? education;
  String? id;
  String? studentName;
  String? studEmail;
  String? studMobileNo;
  List<String>? studProgrammingLang;
  List<Certification>? studentCertificate;
  String? studentResume;
  String? profileSummary;
  List<String>? studentAadhaar;
  List<String>? studentId;
  List<String>? areasOfInterest;
  List<dynamic>? hobbies;
  List<dynamic>? languagesKnown;
  List<dynamic>? volunteerExperience;
  List<dynamic>? leadership;
  List<dynamic>? achievements;
  List<dynamic>? publications;
  List<dynamic>? workshops;
  //List<dynamic>? paperPresentations;
  List<dynamic>? toolsAndTechnologies;
  String? linkedIn;
  String? github;
  List<Project>? projects;
  List<ExperienceData>? experience;
  List<Internship>? internships;
  //List<dynamic>? industrialVisits;
  List<PaperPresentation>? paperPresentations;
  List<IndustrialVisit>? industrialVisits;
  List<dynamic>? trainings;
  List<dynamic>? parents;
  List<CollegeData>? collegeData;
  List<Secondary>? higherSecondary;
  List<Secondary>? secondary;
  CreditData? studentCreditId;
  bool? isVerified;
  String? referralCode;
  bool? isWaterMarkRemoved;
  String? createdAt;
  String? updatedAt;
  int? vId;
  String? portfolioWebsite;
  String? location;
  String? role;
  String? collegeEndYear;
  String? highSchoolLocation;
  String? secondarySchoolLocation;
  bool? syllabusStatus;
  dynamic applicationStatus;
  dynamic collegeStartYear;
  String? templateNumber;
  String? collegeName;
  String? collegeLocation;
  String? highSchoolName;
  String? highSchoolPercentage;
  String? secondarySchoolName;
  String? secondarySchoolPercentage;
  String? studentDegree;
  String? fieldOfStudy;
  String? studProfile;
  String? studentBanner;
  bool? freeBannerUsed;

  //String? studentCreditIdString;
  String? studentGender;
  String? studentDob;

  ProfileDataModel({
    this.education,
    this.id,
    this.studentName,
    this.studEmail,
    this.studMobileNo,
    this.studProgrammingLang,
    this.studentCertificate,
    this.studentResume,
    this.studentAadhaar,
    this.studentId,
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
    this.linkedIn,
    this.github,
    this.projects,
    this.experience,
    this.internships,
    this.industrialVisits,
    this.trainings,
    this.parents,
    this.collegeData,
    this.higherSecondary,
    this.secondary,
    this.studentCreditId,
    this.isVerified,
    this.isWaterMarkRemoved,
    this.createdAt,
    this.updatedAt,
    this.vId,
    this.templateNumber,
    this.studProfile,
    this.studentBanner,
    this.collegeName,
    this.collegeStartYear,
    this.fieldOfStudy,
    this.studentDegree,
    this.profileSummary,
    this.collegeLocation,
    this.freeBannerUsed,
    this.highSchoolName,
    this.highSchoolPercentage,
    this.secondarySchoolName,
    this.secondarySchoolPercentage,
    //this.studentCreditIdString,
    this.studentDob,
    this.studentGender,
    this.message,
    this.portfolioWebsite,
    this.location,
    this.role,
    this.collegeEndYear,
    this.highSchoolLocation,
    this.secondarySchoolLocation,
    this.syllabusStatus,
    this.applicationStatus,
    this.referralCode
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileDataModel(
      education: json['education'] != null
          ? EducationModel.fromJson(json['education'])
          : null,

      studentCreditId: json['studentCreditId'] != null
          ? CreditData.fromJson(json['studentCreditId'])
          : null,
      id: json['_id'],
      message: json['message'],
      referralCode: json['referralCode']??"",
      studentName: json['studname'],
      profileSummary: json['profile_summary'] ?? "",
      studEmail: json['studemail'],
      studMobileNo: json['studmobileno'],
      studProgrammingLang: List<String>.from(json['studprogramminglang'] ?? []),
      //studentCertificate: json['studentcertificate'] ?? [],
      studentCertificate: (json['studentcertificate'] ?? [])
          .map<Certification>((e) => Certification.fromJson(e))
          .toList(),
      studentResume: json['studentresume'],
      studentAadhaar: List<String>.from(json['studentAdhar'] ?? []),
      studentId: List<String>.from(json['studentId'] ?? []),
      areasOfInterest: List<String>.from(json['areas_of_interest'] ?? []),
      hobbies: json['hobbies'] ?? [],
      languagesKnown: json['languages_known'] ?? [],
      volunteerExperience: json['volunteer_experience'] ?? [],
      leadership: json['leadership'] ?? [],
      achievements: json['achievements'] ?? [],
      publications: json['publications'] ?? [],
      workshops: json['workshops'] ?? [],
      //paperPresentations: json['paper_presentations'] ?? [],
      toolsAndTechnologies: json['tools_and_technologies'] ?? [],
      linkedIn: json['linkedIn'],
      github: json['github'],
      projects: (json['projects'] ?? [])
          .map<Project>((e) => Project.fromJson(e))
          .toList(),
      experience: (json['experience'] ?? [])
          .map<ExperienceData>((e) => ExperienceData.fromJson(e))
          .toList(),
      internships: (json['internships'] ?? [])
          .map<Internship>((e) => Internship.fromJson(e))
          .toList(),
      //industrialVisits: json['industrial_visits'] ?? [],
      paperPresentations: (json['paper_presentations'] ?? [])
          .map<PaperPresentation>((e) => PaperPresentation.fromJson(e))
          .toList(),

      industrialVisits: (json['industrial_visits'] ?? [])
          .map<IndustrialVisit>((e) => IndustrialVisit.fromJson(e))
          .toList(),
      trainings: json['trainings'] ?? [],
      parents: json['parents'] ?? [],
      collegeData: (json['college'] ?? [])
          .map<CollegeData>((e) => CollegeData.fromJson(e))
          .toList(),
      higherSecondary: (json['higher_secondary'] ?? [])
          .map<Secondary>((e) => Secondary.fromJson(e))
          .toList(),
      secondary: (json['secondary'] ?? [])
          .map<Secondary>((e) => Secondary.fromJson(e))
          .toList(),
      isVerified: json['isVerified'],
      isWaterMarkRemoved: json['isWaterMarkRemoved'] ?? false,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      vId: json['__v'],
      templateNumber: json['templateNumber'] ?? "1",
      studProfile: json['studprofile'],
      studentBanner: json['student_banner'],
      collegeName: json["studentcollegename"] ?? "",
      collegeStartYear: json["studcollegestartyear"] ?? "",
      fieldOfStudy: json["studentfieldofstudy"] ?? "",
      studentDegree: json["studentdegree"] ?? "",
      collegeLocation: json["studcollegelocation"] ?? "",
      highSchoolName: json["studhighschollname"] ?? "",
      highSchoolPercentage: json["studhighschoolpercentage"] ?? "",
      secondarySchoolName: json["studentsecondaryschoolname"] ?? "",
      secondarySchoolPercentage: json["studentsecondaryschoolpercentage"] ?? "",
      freeBannerUsed: json["freeBannerUsed"] ?? false,
      //studentCreditIdString: json["studentCreditId"] ?? "",
      studentGender: json["studgender"] ?? "",
      portfolioWebsite: json["portfolio_website"] ?? "",
      location: json["location"] ?? "",
      role: json["role"] ?? "",
      collegeEndYear: json["studcollegeendyear"] ?? "",
      highSchoolLocation: json["studhighschoollocation"] ?? "",
      secondarySchoolLocation: json["studsecondaryschoollocation"] ?? "",
      studentDob: json["studdob"]?.toString() ?? "",
      syllabusStatus: json["syllabusstatus"] ?? false,
      applicationStatus: json["applicationstatus"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'education': education?.toJson(),
      'message': message,
      '_id': id,
      'referralCode': referralCode,
      'studname': studentName,
      'profile_summary': profileSummary,
      'studemail': studEmail,
      'studmobileno': studMobileNo,
      'studprogramminglang': studProgrammingLang ?? [],
      //'studentcertificate': studentCertificate ?? [],
      'studentcertificate':
          studentCertificate?.map((e) => e.toJson()).toList() ?? [],
      'studentresume': studentResume,
      'studentAdhar': studentAadhaar ?? [],
      'studentId': studentId ?? [],
      'areas_of_interest': areasOfInterest ?? [],
      'hobbies': hobbies ?? [],
      'languages_known': languagesKnown ?? [],
      'volunteer_experience': volunteerExperience ?? [],
      'leadership': leadership ?? [],
      'achievements': achievements ?? [],
      'publications': publications ?? [],
      'workshops': workshops ?? [],
      //'paper_presentations': paperPresentations ?? [],
      'tools_and_technologies': toolsAndTechnologies ?? [],
      'linkedIn': linkedIn,
      'github': github,
      'portfolio_website': portfolioWebsite,
      'location': location,
      'role': role,
      'studcollegeendyear': collegeEndYear,
      'studhighschoollocation': highSchoolLocation,
      'studsecondaryschoollocation': secondarySchoolLocation,
      'syllabusstatus': syllabusStatus,
      'applicationstatus': applicationStatus,
      'projects': projects?.map((e) => e.toJson()).toList() ?? [],
      'experience': experience?.map((e) => e.toJson()).toList() ?? [],
      'internships': internships?.map((e) => e.toJson()).toList() ?? [],

      //'industrial_visits': industrialVisits ?? [],
      'paper_presentations':
      paperPresentations?.map((e) => e.toJson()).toList() ?? [],

      'industrial_visits':
      industrialVisits?.map((e) => e.toJson()).toList() ?? [],
      'trainings': trainings ?? [],
      'parents': parents ?? [],

      // IMPORTANT FIX (you used collegeData in model but 'college' in API)
      'college': collegeData?.map((e) => e.toJson()).toList() ?? [],

      'higher_secondary':
          higherSecondary?.map((e) => e.toJson()).toList() ?? [],
      'secondary': secondary?.map((e) => e.toJson()).toList() ?? [],

      'studentCreditId': studentCreditId?.toJson(),

      'isVerified': isVerified,
      'isWaterMarkRemoved': isWaterMarkRemoved,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': vId,

      'templateNumber': templateNumber,
      'studprofile': studProfile,
      'student_banner': studentBanner,

      // Additional fields
      'studentcollegename': collegeName,
      'studcollegestartyear': collegeStartYear,
      'studentfieldofstudy': fieldOfStudy,
      'studentdegree': studentDegree,
      'studcollegelocation': collegeLocation,

      'studhighschollname': highSchoolName,
      'studhighschoolpercentage': highSchoolPercentage,
      'studentsecondaryschoolname': secondarySchoolName,
      'studentsecondaryschoolpercentage': secondarySchoolPercentage,

      'freeBannerUsed': freeBannerUsed,

      'studgender': studentGender,
      'studdob': studentDob,
    };
  }
}

class CreditData {
  String? cId;
  String? createdAt;
  String? updatedAt;
  int? balance;
  int? totalUsed;
  int? vId;

  CreditData.fromJson(Map<String, dynamic> json) {
    cId = json["_id"] ?? "";
    createdAt = json["createdAt"] ?? "";
    updatedAt = json["updatedAt"] ?? "";
    balance = json["balance"] ?? 0;
    totalUsed = json["totalUsed"] ?? 0;
    vId = json["__v"] ?? 0;
  }

  Map<String, dynamic> toJson() => {
    "_id": cId,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "balance": balance,
    "totalUsed": totalUsed,
    "__v": vId,
  };

  CreditData({
    this.vId,
    this.totalUsed,
    this.balance,
    this.updatedAt,
    this.createdAt,
    this.cId,
  });
}

class Education {
  List<dynamic>? college;

  Education({this.college});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(college: json['college'] ?? []);
  }

  Map<String, dynamic> toJson() => {"college": college};
}

// class Project {
//   String? title;
//   List<dynamic>? description;
//   String? id;
//
//   Project({this.title, this.description, this.id});
//
//   factory Project.fromJson(Map<String, dynamic> json) {
//     return Project(
//       title: json['title'] ?? "",
//       description: json['description'] ?? [],
//       id: json['_id'] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "title": title ?? "",
//       "description": description ?? [],
//       "_id": id ?? "",
//     };
//   }
// }

class Experience {
  String? company;
  String? role;
  String? duration;
  String? id;

  Experience({this.company, this.role, this.duration, this.id});

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'] ?? "",
      role: json['role'] ?? "",
      duration: json['duration'] ?? "",
      id: json['_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "company": company ?? "",
      "role": role ?? "",
      "duration": duration ?? "",
      "_id": id ?? "",
    };
  }
}

// class Internship {
//   String? company;
//   String? role;
//   String? duration;
//   String? id;
//
//   Internship({
//     required this.company,
//     this.role,
//     required this.duration,
//     required this.id,
//   });
//
//   factory Internship.fromJson(Map<String, dynamic> json) {
//     return Internship(
//       company: json['company'] ?? "",
//       role: json['role'] ?? "",
//       duration: json['duration'] ?? "",
//       id: json['_id'] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "company": company ?? "",
//       "role": role ?? "",
//       "duration": duration ?? "",
//       "_id": id ?? "",
//     };
//   }
// }

class Secondary {
  String? institution;
  dynamic board;
  String? percentage;
  String? yearOfPassing;
  String? id;

  Secondary({
    this.institution,
    this.board,
    this.percentage,
    this.yearOfPassing,
    this.id,
  });

  factory Secondary.fromJson(Map<String, dynamic> json) {
    return Secondary(
      institution: json['institution'] ?? "",
      board: json['board'] ?? "",
      percentage: json['percentage'] ?? "",
      yearOfPassing: json['year_of_passing'] ?? "",
      id: json['_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'board': board,
      'percentage': percentage,
      'year_of_passing': yearOfPassing,
      '_id': id,
    };
  }
}

// class College {
//   String? degree;
//   String? department;
//   String? institution;
//   dynamic startYear;
//   dynamic endYear;
//   String? id;
//
//   College({
//     this.degree,
//     this.department,
//     this.institution,
//     this.startYear,
//     this.endYear,
//     this.id,
//   });
//
//   factory College.fromJson(Map<String, dynamic> json) {
//     return College(
//       degree: json['degree'] ?? "",
//       department: json['department'] ?? "",
//       institution: json['institution'] ?? "",
//       startYear: json['start_year'],
//       endYear: json['end_year'],
//       id: json['_id'] ?? "",
//     );
//   }
// }
