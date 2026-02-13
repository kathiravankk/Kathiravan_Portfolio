import 'package:internsharks/app/data/models/account/project_model.dart';
import 'package:internsharks/app/data/models/account/resume_response.dart';
import 'certification_model.dart';
import 'education_model.dart';
import 'experience_model.dart';

class ResumeData {
  PersonalInfo? personalInfo;
  String? profileSummary;
  List<String>? skills;
  List<Project>? projects;
  List<Experience>? experience;
  List<dynamic>? internships;
  List<dynamic>? industrialVisits;
  Education? education;
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

  ResumeData({
     this.personalInfo,
     this.profileSummary,
     this.skills,
     this.projects,
     this.experience,
     this.internships,
     this.industrialVisits,
     this.education,
     this.certifications,
     this.paperPresentations,
     this.workshops,
     this.publications,
     this.parents,
     this.achievements,
     this.leadership,
     this.volunteerExperience,
     this.languages,
     this.areasOfInterest,
     this.hobbies,
     this.higherSecondary,
     this.secondary,
     this.colleges,
     this.institution,
     this.degree,
  });

  ResumeData.fromJson(Map<String, dynamic> json) {
    personalInfo = json['personal_info'] != null
        ? PersonalInfo.fromJson(json['personal_info'])
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

    internships = json['internships'] ?? [];
    industrialVisits = json['industrial_visits'] ?? [];

    education = json['education'] != null
        ? Education.fromJson(json['education'])
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

}
