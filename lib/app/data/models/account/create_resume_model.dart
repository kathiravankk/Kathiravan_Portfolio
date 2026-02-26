import 'package:internsharks/app/data/models/account/certification_model.dart';
import 'package:internsharks/app/data/models/account/education_model.dart';
import 'package:internsharks/app/data/models/account/experience_model.dart' hide Experience;
import 'package:internsharks/app/data/models/account/personal_info_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart' hide Project, ExperienceData;
import 'package:internsharks/app/data/models/account/student_profile_model.dart';
import 'package:internsharks/app/data/models/home/profile_information_model.dart'
    show Experience;

class CreateResumeModel {
  bool? success;
  ReplyData? replyData;

  CreateResumeModel({this.replyData, this.success});

  CreateResumeModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    replyData = json['reply'] != null
        ? ReplyData.fromJson(json['reply'])
        : null;
  }
}



class ReplyData {
  String? userId;
  String? response;
  String? state;
  PersonalInfoModel? personalInfo;
  String? profileSummary;
  List<String>? skills;
  List<Project>? projects;
  List<Experience>? experience;
  List<Internship>? internships;
  List<dynamic>? industrialVisits;
  EducationModel? education;
  List<Certification>? certifications;
  List<PaperData>? paperPresentations;
  List<dynamic>? workshops;
  List<dynamic>? publications;
  List<dynamic>? parents;
  List<dynamic>? achievements;
  List<dynamic>? leadership;
  List<dynamic>? volunteerExperience;
  List<String>? languages;
  List<dynamic>? areasOfInterest;
  List<dynamic>? hobbies;
  SchoolEducation? higherSecondary;
  SchoolEducation? secondary;
  List<CollegeData>? colleges;
  List<Institution>? institution;
  List<Degree>? degree;
  ReplyData({this.response, this.state, this.userId, this.personalInfo});

  ReplyData.fromJson(Map<String, dynamic> json) {
    userId = json["user_id"] ?? "";
    response = json["response"] ?? "";
    state = json["state"] ?? "";
    personalInfo = json['personal_info'] != null
        ? PersonalInfoModel.fromJson(json['personal_info'])
        : null;
    profileSummary = json['profile_summary'] ?? "";

    skills = json['skills'] != null
        ? List<String>.from(json['skills'])
        : <String>[];

    if (json['projects'] != null) {
      projects = <Project>[];
      json['projects'].forEach((e) {
        projects!.add(Project.fromJson(e));
      });
    } else {
      projects = <Project>[];
    }

    if (json['experience'] != null) {
      experience = <Experience>[];
      json['experience'].forEach((e) {
        experience!.add(Experience.fromJson(e));
      });
    } else {
      experience = <Experience>[];
    }

    internships = (json['internships'] ?? [])
        .map<Internship>((e) => Internship.fromJson(e))
        .toList();
    industrialVisits = json['industrial_visits'] ?? [];

    education = json['education'] != null
        ? EducationModel.fromJson(json['education'])
        : null;

    if (json['certifications'] != null) {
      certifications = <Certification>[];
      json['certifications'].forEach((e) {
        certifications!.add(Certification.fromJson(e));
      });
    } else {
      certifications = <Certification>[];
    }

    if (json['paper_presentations'] != null) {
      paperPresentations = <PaperData>[];
      json['paper_presentations'].forEach((e) {
        paperPresentations!.add(PaperData.fromJson(e));
      });
    } else {
      paperPresentations = <PaperData>[];
    }

    //paperPresentations = json['paper_presentations'] ?? [];
    workshops = json['workshops'] ?? [];
    publications = json['publications'] ?? [];
    parents = json['parents'] ?? [];
    achievements = json['achievements'] ?? [];
    leadership = json['leadership'] ?? [];
    volunteerExperience = json['volunteer_experience'] ?? [];

    languages = json['languages'] != null
        ? List<String>.from(json['languages'])
        : <String>[];

    areasOfInterest = json['areas_of_interest'] ?? [];
    hobbies = json['hobbies'] ?? [];

    higherSecondary = json['higher_secondary'] != null
        ? SchoolEducation.fromJson(json['higher_secondary'])
        : null;

    secondary = json['secondary'] != null
        ? SchoolEducation.fromJson(json['secondary'])
        : null;

    if (json['colleges'] != null) {
      colleges = <CollegeData>[];
      json['colleges'].forEach((e) {
        colleges!.add(CollegeData.fromJson(e));
      });
    } else {
      colleges = <CollegeData>[];
    }

    if (json['institution'] != null) {
      institution = <Institution>[];
      json['institution'].forEach((e) {
        institution!.add(Institution.fromJson(e));
      });
    } else {
      institution = <Institution>[];
    }

    if (json['degree'] != null) {
      degree = <Degree>[];
      json['degree'].forEach((e) {
        degree!.add(Degree.fromJson(e));
      });
    } else {
      degree = <Degree>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["user_id"] = userId;
    data["response"] = response;
    data["state"] = state;

    if (personalInfo != null) {
      data["personal_info"] = personalInfo!.toJson();
    }

    data["profile_summary"] = profileSummary;
    data["skills"] = skills ?? [];

    data["projects"] =
    projects != null ? projects!.map((e) => e.toJson()).toList() : [];

    data["experience"] =
    experience != null ? experience!.map((e) => e.toJson()).toList() : [];

    data["internships"] =
    internships != null ? internships!.map((e) => e.toJson()).toList() : [];

    data["industrial_visits"] = industrialVisits ?? [];

    if (education != null) {
      data["education"] = education!.toJson();
    }

    data["certifications"] =
    certifications != null ? certifications!.map((e) => e.toJson()).toList() : [];

    data["paper_presentations"] =
    paperPresentations != null
        ? paperPresentations!.map((e) => e.toJson()).toList()
        : [];

    data["workshops"] = workshops ?? [];
    data["publications"] = publications ?? [];
    data["parents"] = parents ?? [];
    data["achievements"] = achievements ?? [];
    data["leadership"] = leadership ?? [];
    data["volunteer_experience"] = volunteerExperience ?? [];

    data["languages"] = languages ?? [];
    data["areas_of_interest"] = areasOfInterest ?? [];
    data["hobbies"] = hobbies ?? [];

    if (higherSecondary != null) {
      data["higher_secondary"] = higherSecondary!.toJson();
    }

    if (secondary != null) {
      data["secondary"] = secondary!.toJson();
    }

    data["colleges"] =
    colleges != null ? colleges!.map((e) => e.toJson()).toList() : [];

    data["institution"] =
    institution != null ? institution!.map((e) => e.toJson()).toList() : [];

    data["degree"] =
    degree != null ? degree!.map((e) => e.toJson()).toList() : [];

    return data;
  }



}

class ChatMessage {
  final String text;
  final bool isBot;

  ChatMessage({required this.text, required this.isBot});
}

