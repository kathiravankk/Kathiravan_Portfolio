import 'package:internsharks/app/data/models/account/certification_model.dart';
import 'package:internsharks/app/data/models/account/education_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/home/profile_information_model.dart';

class StudentProfileModel {
  EducationModel? education;
  String? id;
  String? studentName;
  String? studentGender;
  String? studEmail;
  String? studMobileNo;
  List<String>? studProgrammingLang;
  List<Certification>? studentCertificate;
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
  String? portfolioWebsite;
  List<Project>? projects;
  List<ExperienceData>? experience;
  List<Internship>? internships;
  List<dynamic>? industrialVisits;
  List<Training>? trainings;
  List<dynamic>? parents;
  List<CollegeData>? college;
  List<Secondary>? higherSecondary;
  List<Secondary>? secondary;
  CreditData? studentCreditId;
  bool? isVerified;
  bool? freeBannerUsed;
  bool? syllabusStatus;
  dynamic applicationStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? templateNumber;
  String? studProfile;
  String? studentBanner;
  String? profileSummary;

  StudentProfileModel({
    this.education,
    this.id,
    this.studentName,
    this.studentGender,
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
    this.portfolioWebsite,
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
    this.freeBannerUsed,
    this.syllabusStatus,
    this.applicationStatus,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.templateNumber,
    this.studProfile,
    this.studentBanner,
    this.profileSummary,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      education: json['education'] != null
          ? EducationModel.fromJson(json['education'])
          : null,
      id: json['_id'],
      studentName: json['studname'],
      studentGender: json['studgender'],
      studEmail: json['studemail'],
      studMobileNo: json['studmobileno'],
      profileSummary: json['profile_summary'],
      linkedIn: json['linkedIn'],
      github: json['github'],
      portfolioWebsite: json['portfolio_website'],
      studProfile: json['studprofile'],
      studentBanner: json['student_banner'],
      templateNumber: json['templateNumber']?.toString(),

      /// FIXED programming language parsing
      studProgrammingLang: _parseProgrammingLanguages(
        json['studprogramminglang'],
      ),

      //studentCertificate: json['studentcertificate'] ?? [],
      studentCertificate : (json['studentcertificate'] ?? [])
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
      paperPresentations: json['paper_presentations'] ?? [],
      toolsAndTechnologies: json['tools_and_technologies'] ?? [],
      industrialVisits: json['industrial_visits'] ?? [],
      //trainings: json['trainings'] ?? [],
      trainings :(json['trainings'] ?? [])
          .map<Training>((e) => Training.fromJson(e))
          .toList(),
      parents: json['parents'] ?? [],

      projects: (json['projects'] as List?)
          ?.map((e) => Project.fromJson(e))
          .toList() ??
          [],

      experience: (json['experience'] as List?)
          ?.map((e) => ExperienceData.fromJson(e))
          .toList() ??
          [],

      internships: (json['internships'] as List?)
          ?.map((e) => Internship.fromJson(e))
          .toList() ??
          [],

      college: (json['college'] as List?)
          ?.map((e) => CollegeData.fromJson(e))
          .toList() ??
          [],

      higherSecondary: (json['higher_secondary'] as List?)
          ?.map((e) => Secondary.fromJson(e))
          .toList() ??
          [],

      secondary: (json['secondary'] as List?)
          ?.map((e) => Secondary.fromJson(e))
          .toList() ??
          [],

      studentCreditId: json['studentCreditId'] != null
          ? CreditData.fromJson(json['studentCreditId'])
          : null,

      isVerified: json['isVerified'],
      freeBannerUsed: json['freeBannerUsed'],
      syllabusStatus: json['syllabusstatus'],
      applicationStatus: json['applicationstatus'],

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,

      v: json['__v'],
    );
  }

  static List<String> _parseProgrammingLanguages(dynamic value) {
    if (value == null) return [];

    if (value is List && value.isNotEmpty) {
      final first = value.first;

      if (first is String && first.startsWith('[')) {
        try {
          return List<String>.from(
            (first
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', '')
                .split(',')),
          );
        } catch (_) {}
      }

      return List<String>.from(value.map((e) => e.toString()));
    }

    return [];
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
  List<String>? description;

  Project({
    this.title,
    this.description,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] ?? "",
      description: List<String>.from(json['description'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
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

