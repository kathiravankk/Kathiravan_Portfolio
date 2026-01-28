class StudentProfileModel {
  Education? education;
  String? id;
  String? studentName;
  String? studEmail;
  String? studMobileNo;
  List<String>? studProgrammingLang;
  List<dynamic>? studentCertificate;
  String? studentResume;
  List<String>? studentAadhar;
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
  List<Experience>? experience;
  List<Internship>? internships;
  List<dynamic>? industrialVisits;
  List<dynamic>? trainings;
  List<dynamic>? parents;
  List<College>? college;
  List<Secondary>? higherSecondary;
  List<Secondary>? secondary;
  String? studentCreditId;
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
     this.studentAadhar,
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
      education: Education.fromJson(json['education'] ?? {}),
      id: json['_id'],
      studentName: json['studname'],
      studEmail: json['studemail'],
      studMobileNo: json['studmobileno'],
      studProgrammingLang: List<String>.from(json['studprogramminglang'] ?? []),
      studentCertificate: json['studentcertificate'] ?? [],
      studentResume: json['studentresume'],
      studentAadhar: List<String>.from(json['studentAdhar'] ?? []),
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
          .map<Experience>((e) => Experience.fromJson(e))
          .toList(),
      internships: (json['internships'] ?? [])
          .map<Internship>((e) => Internship.fromJson(e))
          .toList(),
      industrialVisits: json['industrial_visits'] ?? [],
      trainings: json['trainings'] ?? [],
      parents: json['parents'] ?? [],
      college: (json['college'] ?? [])
          .map<College>((e) => College.fromJson(e))
          .toList(),
      higherSecondary: (json['higher_secondary'] ?? [])
          .map<Secondary>((e) => Secondary.fromJson(e))
          .toList(),
      secondary: (json['secondary'] ?? [])
          .map<Secondary>((e) => Secondary.fromJson(e))
          .toList(),
      studentCreditId: json['studentCreditId'],
      isVerified: json['isVerified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
      templateNumber: json['templateNumber'],
      studProfile: json['studprofile'],
      studentBanner: json['student_banner'],
    );
  }
}

class Education {
  List<dynamic>? college;

  Education({ this.college});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      college: json['college'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    "college": college,
  };
}
class Project {
  String? title;
  String? description;
  String? id;

  Project({
     this.title,
     this.description,
     this.id,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      id: json['_id'] ?? "",
    );
  }
}
class Experience {
  String? company;
  String? role;
  String? duration;
  String? id;

  Experience({
     this.company,
     this.role,
     this.duration,
     this.id,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'] ?? "",
      role: json['role'] ?? "",
      duration: json['duration']??"",
      id: json['_id']??"",
    );
  }
}
class Internship {
  String? company;
  String? role;
  String? duration;
  String? id;

  Internship({
    required this.company,
    this.role,
    required this.duration,
    required this.id,
  });

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      company: json['company']??"",
      role: json['role']??"",
      duration: json['duration']??"",
      id: json['_id']??"",
    );
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
}
class College {
  String? degree;
  String? department;
  String? institution;
  dynamic startYear;
  dynamic endYear;
  String? id;

  College({
     this.degree,
     this.department,
     this.institution,
    this.startYear,
    this.endYear,
     this.id,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      degree: json['degree']??"",
      department: json['department']??"",
      institution: json['institution']??"",
      startYear: json['start_year'],
      endYear: json['end_year'],
      id: json['_id']??"",
    );
  }
}

