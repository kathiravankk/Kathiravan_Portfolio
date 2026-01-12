import 'package:internsharks/models/project_model.dart';
import 'package:internsharks/models/resume_response.dart';

import 'certification_model.dart';
import 'education_model.dart';
import 'experience_model.dart';

class ResumeData {
  PersonalInfo personalInfo;
  String profileSummary;
  List<String> skills;
  List<Project> projects;
  List<Experience> experience;
  List<dynamic> internships;
  List<dynamic> industrialVisits;
  Education education;
  List<Certification> certifications;
  List<dynamic> paperPresentations;
  List<dynamic> workshops;
  List<dynamic> publications;
  List<dynamic> parents;
  List<dynamic> achievements;
  List<dynamic> leadership;
  List<dynamic> volunteerExperience;
  List<String> languages;
  List<dynamic> areasOfInterest;
  List<dynamic> hobbies;
  Secondary higherSecondary;
  Secondary secondary;
  List<College> colleges;
  List<Institution> institution;
  List<Degree> degree;

  ResumeData({
    required this.personalInfo,
    required this.profileSummary,
    required this.skills,
    required this.projects,
    required this.experience,
    required this.internships,
    required this.industrialVisits,
    required this.education,
    required this.certifications,
    required this.paperPresentations,
    required this.workshops,
    required this.publications,
    required this.parents,
    required this.achievements,
    required this.leadership,
    required this.volunteerExperience,
    required this.languages,
    required this.areasOfInterest,
    required this.hobbies,
    required this.higherSecondary,
    required this.secondary,
    required this.colleges,
    required this.institution,
    required this.degree,
  });

  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      personalInfo: PersonalInfo.fromJson(json['personal_info'] ?? {}),
      profileSummary: json['profile_summary'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      projects: (json['projects'] ?? [])
          .map<Project>((e) => Project.fromJson(e))
          .toList(),
      experience: (json['experience'] ?? [])
          .map<Experience>((e) => Experience.fromJson(e))
          .toList(),
      internships: json['internships'] ?? [],
      industrialVisits: json['industrial_visits'] ?? [],
      education: Education.fromJson(json['education'] ?? {}),
      certifications: (json['certifications'] ?? [])
          .map<Certification>((e) => Certification.fromJson(e))
          .toList(),
      paperPresentations: json['paper_presentations'] ?? [],
      workshops: json['workshops'] ?? [],
      publications: json['publications'] ?? [],
      parents: json['parents'] ?? [],
      achievements: json['achievements'] ?? [],
      leadership: json['leadership'] ?? [],
      volunteerExperience: json['volunteer_experience'] ?? [],
      languages: List<String>.from(json['languages'] ?? []),
      areasOfInterest: json['areas_of_interest'] ?? [],
      hobbies: json['hobbies'] ?? [],
      higherSecondary:
      Secondary.fromJson(json['higher_secondary'] ?? {}),
      secondary: Secondary.fromJson(json['secondary'] ?? {}),
      colleges: (json['colleges'] ?? [])
          .map<College>((e) => College.fromJson(e))
          .toList(),
      institution: (json['institution'] ?? [])
          .map<Institution>((e) => Institution.fromJson(e))
          .toList(),
      degree: (json['degree'] ?? [])
          .map<Degree>((e) => Degree.fromJson(e))
          .toList(),
    );
  }
}
