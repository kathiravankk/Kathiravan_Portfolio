import 'package:internsharks/app/data/models/account/certification_model.dart';
import 'package:internsharks/app/data/models/account/education_model.dart';
import 'package:internsharks/app/data/models/account/new_student_profile_model.dart';
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
import 'package:internsharks/app/data/models/account/student_profile_model.dart';

class CreateNewChatResumeModel {
  String? message;
  String? oldMessage;
  String? userId;
  String? nextField;
  String? completedSection;
  ResumeCollectedData? collectedData;
  String? motivationMessage;

  CreateNewChatResumeModel({
    this.message,
    this.oldMessage,
    this.nextField,
    this.completedSection,
    this.collectedData,
    this.motivationMessage,
    this.userId
  });

  factory CreateNewChatResumeModel.fromJson(
      Map<String, dynamic> json) {
    return CreateNewChatResumeModel(
      message: json["message"],
      oldMessage: json["old_message"],
      userId: json["user_id"]??"",
      nextField: json["next_field"],
      completedSection: json["completed_section"],
      collectedData: json["collected_data"] != null
          ? ResumeCollectedData.fromJson(json["collected_data"])
          : null,
      motivationMessage: json["motivation_message"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "old_message": oldMessage,
      "user_id": userId,
      "next_field": nextField,
      "completed_section": completedSection,
      "collected_data": collectedData?.toJson(),
      "motivation_message": motivationMessage,
    };
  }
}

class ResumeCollectedData {
  String? profileSummary;
  PersonalInfoModel? personalInfo;
  String? refCode;

  List<String>? skills;
  List<NewInternshipData>? internships;
  List<NewProjectData>? projects;
  List<NewIndustrialVisit>? industrialVisits;

  NewEducationData? education;

  List<Certification>? certifications;
  List<NewPaperPresentation>? paperPresentations;

  List<String>? workshops;
  List<String>? publications;
  List<String>? achievements;
  List<String>? leadership;
  List<String>? volunteerExperience;

  List<String>? languages;
  List<String>? areasOfInterest;
  List<String>? hobbies;

  List<CollegeData>? colleges1;
  List<CollegeData>? colleges2;
  List<CollegeData>? colleges3;

  List<CollegeData>? institution;
  List<CollegeData>? degree;

  ResumeCollectedData({
    this.profileSummary,
    this.personalInfo,
    this.refCode,
    this.skills,
    this.internships,
    this.projects,
    this.industrialVisits,
    this.education,
    this.certifications,
    this.paperPresentations,
    this.workshops,
    this.publications,
    this.achievements,
    this.leadership,
    this.volunteerExperience,
    this.languages,
    this.areasOfInterest,
    this.hobbies,
    this.colleges1,
    this.colleges2,
    this.colleges3,
    this.institution,
    this.degree,
  });

  factory ResumeCollectedData.fromJson(Map<String, dynamic> json) {
    return ResumeCollectedData(
      profileSummary: json["profile_summary"]??"",
      personalInfo: json["personal_info"] != null
          ? PersonalInfoModel.fromJson(json["personal_info"])
          : null,
      refCode: json["refcode"],

      skills: List<String>.from(json["skills"] ?? []),

      internships: (json["internships"] as List? ?? [])
          .map<NewInternshipData>((e) => NewInternshipData.fromJson(e))
          .toList(),

      projects: (json["projects"] as List? ?? [])
          .map<NewProjectData>((e) => NewProjectData.fromJson(e))
          .toList(),

      //industrialVisits: List.from(json["industrial_visits"] ?? []),
      industrialVisits:
      (json['industrial_visits'] as List?)
          ?.map((e) => NewIndustrialVisit.fromJson(e))
          .toList(),

      education: json["education"] != null
          ? NewEducationData.fromJson(json["education"])
          : null,

      certifications: (json["certifications"] as List? ?? [])
          .map<Certification>((e) => Certification.fromJson(e))
          .toList(),

      paperPresentations: (json["paper_presentations"] as List? ?? [])
          .map<NewPaperPresentation>((e) => NewPaperPresentation.fromJson(e))
          .toList(),

      workshops: List.from(json["workshops"] ?? []),
      publications: List.from(json["publications"] ?? []),
      achievements: List.from(json["achievements"] ?? []),
      leadership: List.from(json["leadership"] ?? []),
      volunteerExperience: List.from(json["volunteer_experience"] ?? []),

      languages: List<String>.from(json["languages"] ?? []),
      areasOfInterest: List<String>.from(json["areas_of_interest"] ?? []),
      hobbies: List<String>.from(json["hobbies"] ?? []),

      colleges1: (json["colleges1"] as List? ?? [])
          .map<CollegeData>((e) => CollegeData.fromJson(e))
          .toList(),

      colleges2: (json["colleges2"] as List? ?? [])
          .map<CollegeData>((e) => CollegeData.fromJson(e))
          .toList(),

      colleges3: (json["colleges3"] as List? ?? [])
          .map<CollegeData>((e) => CollegeData.fromJson(e))
          .toList(),

      institution: (json["institution"] as List? ?? [])
          .map<CollegeData>((e) => CollegeData.fromJson(e))
          .toList(),

      degree: (json["degree"] as List? ?? [])
          .map<CollegeData>((e) => CollegeData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "profile_summary": profileSummary,
      "personal_info": personalInfo?.toJson(),
      "refcode": refCode,
      "skills": skills,
      "internships": internships?.map((e) => e.toJson()).toList(),
      "projects": projects?.map((e) => e.toJson()).toList(),
      "industrial_visits": industrialVisits,
      "education": education?.toJson(),
      "certifications":
      certifications?.map((e) => e.toJson()).toList(),
      "paper_presentations":
      paperPresentations?.map((e) => e.toJson()).toList(),
      "workshops": workshops,
      "publications": publications,
      "achievements": achievements,
      "leadership": leadership,
      "volunteer_experience": volunteerExperience,
      "languages": languages,
      "areas_of_interest": areasOfInterest,
      "hobbies": hobbies,
      "colleges1": colleges1?.map((e) => e.toJson()).toList(),
      "colleges2": colleges2?.map((e) => e.toJson()).toList(),
      "colleges3": colleges3?.map((e) => e.toJson()).toList(),
      "institution": institution?.map((e) => e.toJson()).toList(),
      "degree": degree?.map((e) => e.toJson()).toList(),
    };
  }
}