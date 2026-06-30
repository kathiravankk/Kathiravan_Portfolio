import 'package:internsharks/app/data/models/account/education_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/student_profile_model.dart' hide Secondary;
import 'package:internsharks/app/data/models/home/profile_information_model.dart';

class UpdateProfileDataModel {
  EducationModel? education;
  String? id;
  String? studentName;
  String? studEmail;
  String? studMobileNo;
  List<String>? studProgrammingLang;
  List<dynamic>? studentCertificate;
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
   List<dynamic>? toolsAndTechnologies;
  String? linkedIn;
  String? github;
  List<Project>? projects;
  List<ExperienceData>? experience;
  List<InternShipModel>? internships;
  List<PaperPresentation>? paperPresentations;
  List<IndustrialVisit>? industrialVisits;
  List<dynamic>? trainings;
  List<dynamic>? parents;
  List<CollegeData>? collegeData;
  List<Secondary>? higherSecondary;
  List<Secondary>? secondary;
  String? studentCreditId;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;
  int? vId;

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

  UpdateProfileDataModel({
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
    this.studentDob,
    this.studentGender,
  });

  factory UpdateProfileDataModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileDataModel(
      education: EducationModel.fromJson(json['education'] ?? {}),
      id: json['_id'],
      studentName: json['studname'],
      profileSummary: json['profile_summary'] ?? "",
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
          .map<InternShipModel>((e) => InternShipModel.fromJson(e))
          .toList(),
      //industrialVisits: json['industrial_visits'] ?? [],
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
      studentCreditId: json["studentCreditId"] ?? "",
      studentGender: json["studgender"] ?? "",
      studentDob: json["studdob"] ?? "",
      paperPresentations: (json['paper_presentations'] ?? [])
          .map<PaperPresentation>((e) => PaperPresentation.fromJson(e))
          .toList(),

      industrialVisits: (json['industrial_visits'] ?? [])
          .map<IndustrialVisit>((e) => IndustrialVisit.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'education': education?.toJson(),
      '_id': id,
      'studname': studentName,
      'profile_summary': profileSummary,
      'studemail': studEmail,
      'studmobileno': studMobileNo,
      'studprogramminglang': studProgrammingLang ?? [],
      'studentcertificate': studentCertificate ?? [],
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
      'paper_presentations': paperPresentations ?? [],
      'tools_and_technologies': toolsAndTechnologies ?? [],
      'linkedIn': linkedIn,
      'github': github,

      'projects': projects?.map((e) => e.toJson()).toList() ?? [],
      'experience': experience?.map((e) => e.toJson()).toList() ?? [],
      'internships': internships?.map((e) => e.toJson()).toList() ?? [],

      'industrial_visits': industrialVisits ?? [],
      'trainings': trainings ?? [],
      'parents': parents ?? [],

      // IMPORTANT FIX (you used collegeData in model but 'college' in API)
      'college': collegeData?.map((e) => e.toJson()).toList() ?? [],

      'higher_secondary': higherSecondary?.map((e) => e.toJson()).toList() ?? [],
      'secondary': secondary?.map((e) => e.toJson()).toList() ?? [],

      'studentCreditId': studentCreditId,

      'isVerified': isVerified,
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

class PaperPresentation {
  String? title;
  String? event;
  String? year;
  String? description;
  String? id;

  PaperPresentation({
    this.title,
    this.event,
    this.year,
    this.description,
    this.id,
  });

  factory PaperPresentation.fromJson(Map<String, dynamic> json) {
    return PaperPresentation(
      title: json['title'] ?? "",
      event: json['event'] ?? "",
      year: json['year'] ?? "",
      description: json['description'] ?? "",
      id: json['_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title ?? "",
      "event": event ?? "",
      "year": year ?? "",
      "description": description ?? "",
      "_id": id ?? "",
    };
  }
}

class IndustrialVisit {
  String? company;
  String? location;
  String? date;
  String? id;

  IndustrialVisit({
    this.company,
    this.location,
    this.date,
    this.id,
  });

  factory IndustrialVisit.fromJson(Map<String, dynamic> json) {
    return IndustrialVisit(
      company: json['company'] ?? "",
      location: json['location'] ?? "",
      date: json['date'] ?? "",
      id: json['_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "company": company ?? "",
      "location": location ?? "",
      "date": date ?? "",
      "_id": id ?? "",
    };
  }
}