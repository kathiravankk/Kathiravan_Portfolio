import 'package:internsharks/app/data/models/education_model.dart';

class ResumeAnalysisModel {
  bool? success;
  String? filename;
  int? tokenUsage;
  AnalysisData? analysis;
  ExtractedResumeDataModel? extractedData;

  ResumeAnalysisModel({
    this.success,
    this.filename,
    this.tokenUsage,
    this.analysis,
    this.extractedData,
  });

  ResumeAnalysisModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    filename = json['filename'] ?? "";
    tokenUsage = json['token_usage'] ?? 0;
    analysis = json["analysis"] != null
        ? AnalysisData.fromJson(json["analysis"])
        : null;
    extractedData = json["extracted_data"] != null
        ? ExtractedResumeDataModel.fromJson(json['extracted_data'])
        : null;
  }
}

class AnalysisData {
  Sections sections;
  dynamic overallScore;
  dynamic atsScore;
  String grade;
  List<String> strengths;
  List<String> improvements;

  AnalysisData({
    required this.sections,
    required this.overallScore,
    required this.atsScore,
    required this.grade,
    required this.strengths,
    required this.improvements,
  });

  factory AnalysisData.fromJson(Map<String, dynamic> json) {
    return AnalysisData(
      sections: Sections.fromJson(json['sections']),
      overallScore: (json['overallScore'] as num).toDouble(),
      atsScore: (json['atsScore'] as num).toDouble(),
      grade: json['grade'],
      strengths: List<String>.from(json['strengths'] ?? []),
      improvements: List<String>.from(json['improvements'] ?? []),
    );
  }
}

class Sections {
  SectionDetail profileSummary;
  SectionDetail projects;
  SectionDetail internships;
  SectionDetail experience;

  Sections({
    required this.profileSummary,
    required this.projects,
    required this.internships,
    required this.experience,
  });

  factory Sections.fromJson(Map<String, dynamic> json) {
    return Sections(
      profileSummary: SectionDetail.fromJson(json['profile-summary']),
      projects: SectionDetail.fromJson(json['projects']),
      internships: SectionDetail.fromJson(json['internships']),
      experience: SectionDetail.fromJson(json['experience']),
    );
  }

  Map<String, SectionDetail> toMap() {
    return {
      "Profile Summary": profileSummary,
      "Projects": projects,
      "Internships": internships,
      "Experience": experience,
    };
  }
}

class SectionDetail {
  double rating;
  List<String> suggestions;

  SectionDetail({required this.rating, required this.suggestions});

  factory SectionDetail.fromJson(Map<String, dynamic> json) {
    return SectionDetail(
      rating: (json['rating'] as num).toDouble(),
      suggestions: List<String>.from(json['suggestions'] ?? []),
    );
  }
}

class ExtractedResumeDataModel {
  PersonalInfo? personalInfo;
  String? profileSummary;
  List<String>? skills;
  List<Project>? projects;
  List<Experience>? experience;
  List<Internship>? internships;
  List<Training>? trainings;
  List<dynamic>? industrialVisits;
  List<dynamic>? certifications;
  List<dynamic>? paperPresentations;
  List<dynamic>? workShops;
  List<dynamic>? publications;
  List<dynamic>? parents;
  List<dynamic>? achievements;
  List<dynamic>? leaderships;
  List<dynamic>? volunteerExperience;
  List<dynamic>? languages;
  List<dynamic>? areasOfInterest;
  List<dynamic>? hobbies;
  Education? educationData;
  SchoolEducation? higherSecondary;
  SchoolEducation? secondary;
  List<CollegeData>? colleges;
  List<CollegeData>? institution;
  List<CollegeData>? degree;
  List<String>? updatedExperience;
  List<String>? updatedProfileSummary;
  List<String>? updatedProjects;
  List<String>? updatedInternships;

  ExtractedResumeDataModel({
    this.personalInfo,
    this.profileSummary,
    this.skills,
    this.projects,
    this.experience,
    this.internships,
    this.trainings,
    this.industrialVisits,
    this.paperPresentations,
    this.secondary,
    this.higherSecondary,
    this.parents,
    this.publications,
    this.achievements,
    this.volunteerExperience,
    this.languages,
    this.hobbies,
    this.areasOfInterest,
    this.institution,
    this.colleges,
    this.certifications,
    this.educationData,
    this.leaderships,
    this.updatedExperience,
    this.updatedInternships,
    this.updatedProfileSummary,
    this.updatedProjects,
    this.workShops,
    this.degree,
  });

  ExtractedResumeDataModel.fromJson(Map<String, dynamic> json) {
    personalInfo = json["personal_info"] != null
        ? PersonalInfo.fromJson(json["personal_info"])
        : null;
    profileSummary = json['profile_summary'];
    skills = List<String>.from(json['skills'] ?? []);
    projects = (json['projects'] ?? [])
        .map<Project>((e) => Project.fromJson(e))
        .toList();
    experience = (json['experience'] ?? [])
        .map<Experience>((e) => Experience.fromJson(e))
        .toList();
    internships = (json['internships'] ?? [])
        .map<Internship>((e) => Internship.fromJson(e))
        .toList();
    trainings = (json['trainings'] ?? [])
        .map<Training>((e) => Training.fromJson(e))
        .toList();
    workShops = json['workshops'] ?? [];
    publications = json['publications'] ?? [];
    parents = json['parents'] ?? [];
    achievements = json['achievements'] ?? [];
    leaderships = json['leadership'] ?? [];
    volunteerExperience = json['volunteer_experience'] ?? [];
    languages = json['languages'] ?? [];
    areasOfInterest = json['areas_of_interest'] ?? [];
    hobbies = json['hobbies'] ?? [];
    paperPresentations = json['paper_presentations'] ?? [];
    industrialVisits = json['industrial_visits'] ?? [];
    certifications = json['certifications'] ?? [];
    educationData = json["education"] != null
        ? Education.fromJson(json["education"])
        : null;
    secondary = json["secondary"] != null
        ? SchoolEducation.fromJson(json["secondary"])
        : null;
    higherSecondary = json["higher_secondary"] != null
        ? SchoolEducation.fromJson(json["higher_secondary"])
        : null;
    colleges = (json['college'] ?? [])
        .map<CollegeData>((e) => CollegeData.fromJson(e))
        .toList();
    institution = (json['institution'] ?? [])
        .map<CollegeData>((e) => CollegeData.fromJson(e))
        .toList();
    degree = (json['degree'] ?? [])
        .map<CollegeData>((e) => CollegeData.fromJson(e))
        .toList();
    updatedExperience = List<String>.from(json['updatedExperience'] ?? []);
    updatedProfileSummary = List<String>.from(
      json['updatedProfileSummary'] ?? [],
    );
    updatedProjects = List<String>.from(json['updatedProjects'] ?? []);
    updatedInternships = List<String>.from(json['updateInternships'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      "personal_info": personalInfo?.toJson(),
      "profile_summary": profileSummary,
      "skills": skills ?? [],
      "projects": projects?.map((e) => e.toJson()).toList() ?? [],
      "experience": experience?.map((e) => e.toJson()).toList() ?? [],
      "internships": internships?.map((e) => e.toJson()).toList() ?? [],
      "trainings": trainings?.map((e) => e.toJson()).toList() ?? [],

      "workshops": workShops ?? [],
      "publications": publications ?? [],
      "parents": parents ?? [],
      "achievements": achievements ?? [],
      "leadership": leaderships ?? [],
      "volunteer_experience": volunteerExperience ?? [],
      "languages": languages ?? [],
      "areas_of_interest": areasOfInterest ?? [],
      "hobbies": hobbies ?? [],
      "paper_presentations": paperPresentations ?? [],
      "industrial_visits": industrialVisits ?? [],
      "certifications": certifications ?? [],

      "education": educationData?.toJson(),
      "secondary": secondary?.toJson(),
      "higher_secondary": higherSecondary?.toJson(),

      "college": colleges?.map((e) => e.toJson()).toList() ?? [],
      "institution": institution?.map((e) => e.toJson()).toList() ?? [],
      "degree": degree?.map((e) => e.toJson()).toList() ?? [],

      "updatedExperience": updatedExperience ?? [],
      "updatedProfileSummary": updatedProfileSummary ?? [],
      "updatedProjects": updatedProjects ?? [],
      "updateInternships": updatedInternships ?? [],
    };
  }

}

class PersonalInfo {
  String? name;
  String? gender;
  String? email;
  String? phone;
  String? linkedin;
  String? github;

  PersonalInfo({
    this.name,
    this.gender,
    this.email,
    this.phone,
    this.linkedin,
    this.github,
  });

  PersonalInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    gender = json['gender'] ?? "";
    email = json['email'] ?? "";
    phone = json['phone'] ?? "";
    linkedin = json['linkedin'] ?? "";
    github = json['github'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name ?? "",
      "gender": gender ?? "",
      "email": email ?? "",
      "phone": phone ?? "",
      "linkedin": linkedin ?? "",
      "github": github ?? "",
    };
  }

}

class Project {
  String? title;
  List<String>? description;

  Project({this.title, this.description});

  Project.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    description = List<String>.from(json['description'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title ?? "",
      "description": description ?? [],
    };
  }

}

class Experience {
  String? company;
  String? role;
  String? duration;
  List<String>? description;

  Experience({this.company, this.role, this.duration, this.description});

  Experience.fromJson(Map<String, dynamic> json) {
    company = json['company'] ?? "";
    role = json['role'] ?? "";
    duration = json['duration'] ?? "";
    description = List<String>.from(json['description'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      "company": company ?? "",
      "role": role ?? "",
      "duration": duration ?? "",
      "description": description ?? [],
    };
  }

}

class Internship {
  String? company;
  String? role;
  String? duration;
  List<String>? description;

  Internship({this.company, this.role, this.duration, this.description});

  Internship.fromJson(Map<String, dynamic> json) {
    company = json['company'] ?? "";
    role = json['role'] ?? "";
    duration = json['duration'] ?? "";
    description = List<String>.from(json['description'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      "company": company ?? "",
      "role": role ?? "",
      "duration": duration ?? "",
      "description": description ?? [],
    };
  }

}

class Training {
  String? title;
  String? institution;
  String? year;
  List<String>? description;

  Training({this.title, this.institution, this.year, this.description});

  Training.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    institution = json['institution'] ?? "";
    year = json['year'] ?? "";
    description = List<String>.from(json['description'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title ?? "",
      "institution": institution ?? "",
      "year": year ?? "",
      "description": description ?? [],
    };
  }

}
