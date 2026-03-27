import 'package:internsharks/app/data/models/account/education_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/home/profile_information_model.dart';

class StudentProfileModel {
  EducationModel? education;
  String? id;
  String? studentName;
  String? studEmail;
  String? studMobileNo;
  List<String>? studProgrammingLang;
  List<dynamic>? studentCertificate;
  String? studentResume;
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
  List<dynamic>? paperPresentations;
  List<dynamic>? toolsAndTechnologies;
  String? linkedIn;
  String? github;
  List<Project>? projects;
  List<ExperienceData>? experience;
  List<Internship>? internships;
  List<dynamic>? industrialVisits;
  List<dynamic>? trainings;
  List<dynamic>? parents;
  List<CollegeData>? college;
  List<Secondary>? higherSecondary;
  List<Secondary>? secondary;
  CreditData? studentCreditId;
  //dynamic studentCreditId;
  bool? isVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? templateNumber;
  String? studProfile;
  String? studentBanner;

  StudentProfileModel({
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
     this.college,
     this.higherSecondary,
     this.secondary,
     this.studentCreditId,
     this.isVerified,
     this.createdAt,
     this.updatedAt,
     this.v,
     this.templateNumber,
     this.studProfile,
     this.studentBanner,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      education: EducationModel.fromJson(json['education'] ?? {}),
      id: json['_id'],
      studentName: json['studname'],
      studEmail: json['studemail'],
      studMobileNo: json['studmobileno'],
      studProgrammingLang: List<String>.from(json['studprogramminglang'] ?? []),
      studentCertificate: json['studentcertificate'] ?? [],
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
      paperPresentations: json['paper_presentations'] ?? [],
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
      industrialVisits: json['industrial_visits'] ?? [],
      trainings: json['trainings'] ?? [],
      parents: json['parents'] ?? [],
      college: (json['college'] ?? [])
          .map<CollegeData>((e) => CollegeData.fromJson(e))
          .toList(),
      higherSecondary: (json['higher_secondary'] ?? [])
          .map<Secondary>((e) => Secondary.fromJson(e))
          .toList(),
      secondary: (json['secondary'] ?? [])
          .map<Secondary>((e) => Secondary.fromJson(e))
          .toList(),
      studentCreditId: CreditData.fromJson(json['studentCreditId'] ?? {}),
      //studentCreditId: json['studentCreditId']?? "",
      isVerified: json['isVerified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
      templateNumber: json['templateNumber'],
      studProfile: json['studprofile'],
      studentBanner: json['student_banner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'education': education?.toJson(),
      '_id': id,
      'studname': studentName,
      'studemail': studEmail,
      'studmobileno': studMobileNo,
      'studprogramminglang': studProgrammingLang,
      'studentcertificate': studentCertificate,
      'studentresume': studentResume,
      'studentAdhar': studentAadhaar,
      'studentId': studentId,
      'areas_of_interest': areasOfInterest,
      'hobbies': hobbies,
      'languages_known': languagesKnown,
      'volunteer_experience': volunteerExperience,
      'leadership': leadership,
      'achievements': achievements,
      'publications': publications,
      'workshops': workshops,
      'paper_presentations': paperPresentations,
      'tools_and_technologies': toolsAndTechnologies,
      'linkedIn': linkedIn,
      'github': github,
      'projects': projects?.map((e) => e.toJson()).toList(),
      'experience': experience?.map((e) => e.toJson()).toList(),
      'internships': internships?.map((e) => e.toJson()).toList(),
      'industrial_visits': industrialVisits,
      'trainings': trainings,
      'parents': parents,
      'college': college?.map((e) => e.toJson()).toList(),
      'higher_secondary': higherSecondary?.map((e) => e.toJson()).toList(),
      'secondary': secondary?.map((e) => e.toJson()).toList(),
      'isVerified': isVerified,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'templateNumber': templateNumber,
      'studprofile': studProfile,
      'student_banner': studentBanner,
      'studentCreditId': studentCreditId,
    };
  }

}

// class Education {
//   List<dynamic>? college;
//
//   Education({ this.college});
//
//   factory Education.fromJson(Map<String, dynamic> json) {
//     return Education(
//       college: json['college'] ?? [],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "college": college,
//   };
// }
class Project {
  String? title;
  dynamic description;
  //String? id;

  Project({
     this.title,
     this.description,
     //this.id,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      //id: json['_id'] ?? "",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      //'_id': id,
    };
  }
}
// class Experience {
//   String? company;
//   String? role;
//   String? duration;
//   String? id;
//
//   Experience({
//      this.company,
//      this.role,
//      this.duration,
//      this.id,
//   });
//
//   factory Experience.fromJson(Map<String, dynamic> json) {
//     return Experience(
//       company: json['company'] ?? "",
//       role: json['role'] ?? "",
//       duration: json['duration']??"",
//       id: json['_id']??"",
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'company': company,
//       'role': role,
//       'duration': duration,
//       '_id': id,
//     };
//   }
// }
class Internship {
  String? company;
  String? role;
  String? duration;
  //String? id;
  dynamic description;


  Internship({
    required this.company,
    this.role,
    required this.duration,
    //required this.id,
    this.description
  });

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      company: json['company']??"",
      role: json['role']??"",
      duration: json['duration']??"",
      //id: json['_id']??"",
        description : json['description'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'role': role,
      'duration': duration,
      //'_id': id,
      "description": description
    };
  }
}
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
      institution: json['institution']??"",
      board: json['board']??"",
      percentage: json['percentage']??"",
      yearOfPassing: json['year_of_passing']??"",
      id: json['_id']??"",
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
//      this.degree,
//      this.department,
//      this.institution,
//     this.startYear,
//     this.endYear,
//      this.id,
//   });
//
//   factory College.fromJson(Map<String, dynamic> json) {
//     return College(
//       degree: json['degree']??"",
//       department: json['department']??"",
//       institution: json['institution']??"",
//       startYear: json['start_year'],
//       endYear: json['end_year'],
//       id: json['_id']??"",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'degree': degree,
//       'department': department,
//       'institution': institution,
//       'start_year': startYear,
//       'end_year': endYear,
//       '_id': id,
//     };
//   }
// }

