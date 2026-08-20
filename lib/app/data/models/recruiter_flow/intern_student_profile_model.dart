import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/data/models/account/certification_model.dart';
import 'package:internsharks/app/data/models/account/education_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/student_profile_model.dart';

class InternStudentProfileModel {
  String? message;
  String? id;

  String? studProfile;
  String? studName;
  String? studEmail;
  String? studMobileNo;
  String? role;

  List<String>? studProgrammingLang;

  List<Certification>? studentCertificate;

  String? studentResume;

  List<dynamic>? studentAdhaar;
  List<dynamic>? studentId;

  List<dynamic>? areasOfInterest;
  List<dynamic>? hobbies;
  List<dynamic>? languagesKnown;
  List<dynamic>? volunteerExperience;
  List<dynamic>? leadership;
  List<dynamic>? achievements;
  List<dynamic>? publications;
  List<dynamic>? workshops;
  List<dynamic>? paperPresentations;
  List<dynamic>? toolsAndTechnologies;
  List<Project>? projects;
  List<ExperienceData>? experience;
  List<InternShipModel>? internships;
  List<dynamic>? industrialVisits;
  List<dynamic>? trainings;
  List<dynamic>? parents;

  List<CollegeData>? college;
  List<HigherSecondary>? higherSecondary;
  List<SecondaryEducation>? secondary;

  EducationModel? education;

  bool? freeBannerUsed;
  List<String>? fcmTokens;

  StudentCreditModel? studentCredit;

  bool? isVerified;
  bool? isWaterMarkRemoved;

  String? createdAt;
  String? updatedAt;

  int? v;

  String? github;
  String? linkedIn;
  String? location;
  String? profileSummary;

  String? studCollegeLocation;
  String? studCollegeStartYear;
  String? studentCollegeName;
  String? studentDegree;
  String? studentFieldOfStudy;

  String? studentSecondarySchoolName;
  String? studentSecondarySchoolPercentage;

  String? studHighSchoolName;
  String? studHighSchoolPercentage;

  String? templateNumber;
  String? studDob;
  String? studentBanner;

  bool? isActive;

  String? referralCode;

  bool? syllabusStatus;
  String? applicationStatus;
  bool? favoriteStatus;

  InternStudentProfileModel({
    this.message,
    this.id,
    this.studProfile,
    this.studName,
    this.studEmail,
    this.studMobileNo,
    this.role,
    this.studProgrammingLang,
    this.studentCertificate,
    this.studentResume,
    this.studentAdhaar,
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
    this.projects,
    this.experience,
    this.internships,
    this.industrialVisits,
    this.trainings,
    this.parents,
    this.college,
    this.higherSecondary,
    this.secondary,
    this.education,
    this.freeBannerUsed,
    this.fcmTokens,
    this.studentCredit,
    this.isVerified,
    this.isWaterMarkRemoved,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.github,
    this.linkedIn,
    this.location,
    this.profileSummary,
    this.studCollegeLocation,
    this.studCollegeStartYear,
    this.studentCollegeName,
    this.studentDegree,
    this.studentFieldOfStudy,
    this.studentSecondarySchoolName,
    this.studentSecondarySchoolPercentage,
    this.studHighSchoolName,
    this.studHighSchoolPercentage,
    this.templateNumber,
    this.studDob,
    this.studentBanner,
    this.isActive,
    this.referralCode,
    this.syllabusStatus,
    this.applicationStatus,
    this.favoriteStatus,
  });

  InternStudentProfileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['_id'];

    studProfile = json['studprofile'];
    studName = json['studname'];
    studEmail = json['studemail'];
    studMobileNo = json['studmobileno'];
    role = json['role'];

    studProgrammingLang = AppFunctions.parseSkillsList(
      json['studprogramminglang'],
    );

    studentCertificate =
        (json['studentcertificate'] as List?)
            ?.map((e) => Certification.fromJson(e))
            .toList() ??
        [];

    studentResume = json['studentresume'];

    studentAdhaar = json['studentAdhar'] ?? [];
    studentId = json['studentId'] ?? [];

    areasOfInterest = json['areas_of_interest'] ?? [];
    hobbies = json['hobbies'] ?? [];
    languagesKnown = json['languages_known'] ?? [];
    volunteerExperience = json['volunteer_experience'] ?? [];
    leadership = json['leadership'] ?? [];
    achievements = json['achievements'] ?? [];
    publications = json['publications'] ?? [];
    workshops = json['workshops'] ?? [];
    paperPresentations = json['paper_presentations'] ?? [];
    toolsAndTechnologies = json['tools_and_technologies'] ?? [];

    projects =
        (json['projects'] as List?)?.map((e) => Project.fromJson(e)).toList() ??
        [];

    experience =
        (json['experience'] as List?)
            ?.map((e) => ExperienceData.fromJson(e))
            .toList() ??
            [];

    internships =
        (json['internships'] as List?)
            ?.map((e) => InternShipModel.fromJson(e))
            .toList() ??
        [];

    industrialVisits = json['industrial_visits'] ?? [];
    trainings = json['trainings'] ?? [];
    parents = json['parents'] ?? [];

    college =
        (json['college'] as List?)?.map((e) => CollegeData.fromJson(e)).toList() ??
        [];

    higherSecondary =
        (json['higher_secondary'] as List?)
            ?.map((e) => HigherSecondary.fromJson(e))
            .toList() ??
        [];

    secondary =
        (json['secondary'] as List?)
            ?.map((e) => SecondaryEducation.fromJson(e))
            .toList() ??
        [];

    education = json['education'] != null
        ? EducationModel.fromJson(json['education'])
        : null;

    freeBannerUsed = json['freeBannerUsed'];

    fcmTokens =
        (json['fcmTokens'] as List?)?.map((e) => e.toString()).toList() ?? [];

    studentCredit = json['studentCreditId'] != null
        ? StudentCreditModel.fromJson(json['studentCreditId'])
        : null;

    isVerified = json['isVerified'];
    isWaterMarkRemoved = json['isWaterMarkRemoved'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];

    github = json['github'];
    linkedIn = json['linkedIn'];
    location = json['location'];
    profileSummary = json['profile_summary'];

    studCollegeLocation = json['studcollegelocation'];
    studCollegeStartYear = json['studcollegestartyear'];
    studentCollegeName = json['studentcollegename'];
    studentDegree = json['studentdegree'];
    studentFieldOfStudy = json['studentfieldofstudy'];

    studentSecondarySchoolName = json['studentsecondaryschoolname'];

    studentSecondarySchoolPercentage = json['studentsecondaryschoolpercentage'];

    studHighSchoolName = json['studhighschollname'];
    studHighSchoolPercentage = json['studhighschoolpercentage'];

    templateNumber = json['templateNumber'];
    studDob = json['studdob'];
    studentBanner = json['student_banner'] ??"";

    isActive = json['isActive'];
    referralCode = json['referralCode'];

    syllabusStatus = json['syllabusstatus'];
    applicationStatus = json['applicationstatus'];
    favoriteStatus = json['favoriteStatus'];
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "_id": id,
      "studprofile": studProfile,
      "studname": studName,
      "studemail": studEmail,
      "studmobileno": studMobileNo,
      "role": role,
      "studprogramminglang": studProgrammingLang,
      "studentcertificate": studentCertificate?.map((e) => e.toJson()).toList(),
      "studentresume": studentResume,
      "studentAdhar": studentAdhaar,
      "studentId": studentId,
      "areas_of_interest": areasOfInterest,
      "hobbies": hobbies,
      "languages_known": languagesKnown,
      "volunteer_experience": volunteerExperience,
      "leadership": leadership,
      "achievements": achievements,
      "publications": publications,
      "workshops": workshops,
      "paper_presentations": paperPresentations,
      "tools_and_technologies": toolsAndTechnologies,
      "projects": projects?.map((e) => e.toJson()).toList(),
      "experience": experience,
      "internships": internships?.map((e) => e.toJson()).toList(),
      "industrial_visits": industrialVisits,
      "trainings": trainings,
      "parents": parents,
      "college": college?.map((e) => e.toJson()).toList(),
      "higher_secondary": higherSecondary?.map((e) => e.toJson()).toList(),
      "secondary": secondary?.map((e) => e.toJson()).toList(),
      "education": education?.toJson(),
      "freeBannerUsed": freeBannerUsed,
      "fcmTokens": fcmTokens,
      "studentCreditId": studentCredit?.toJson(),
      "isVerified": isVerified,
      "isWaterMarkRemoved": isWaterMarkRemoved,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
      "github": github,
      "linkedIn": linkedIn,
      "location": location,
      "profile_summary": profileSummary,
      "studcollegelocation": studCollegeLocation,
      "studcollegestartyear": studCollegeStartYear,
      "studentcollegename": studentCollegeName,
      "studentdegree": studentDegree,
      "studentfieldofstudy": studentFieldOfStudy,
      "studentsecondaryschoolname": studentSecondarySchoolName,
      "studentsecondaryschoolpercentage": studentSecondarySchoolPercentage,
      "studhighschollname": studHighSchoolName,
      "studhighschoolpercentage": studHighSchoolPercentage,
      "templateNumber": templateNumber,
      "studdob": studDob,
      "student_banner": studentBanner,
      "isActive": isActive,
      "referralCode": referralCode,
      "syllabusstatus": syllabusStatus,
      "applicationstatus": applicationStatus,
      "favoriteStatus": favoriteStatus,
    };
  }
}

class StudentCreditModel {
  String? id;
  int? balance;
  int? totalUsed;
  String? createdAt;
  String? updatedAt;
  int? v;

  StudentCreditModel({
    this.id,
    this.balance,
    this.totalUsed,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  StudentCreditModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    balance = json['balance'];
    totalUsed = json['totalUsed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "balance": balance,
      "totalUsed": totalUsed,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}

class StudentCertificate {
  String? name;
  String? issuer;

  StudentCertificate({this.name, this.issuer});

  StudentCertificate.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    issuer = json['issuer'];
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'issuer': issuer};
  }
}

class StudentCredit {
  String? id;
  int? balance;
  int? totalUsed;
  String? createdAt;
  String? updatedAt;
  int? v;

  StudentCredit({
    this.id,
    this.balance,
    this.totalUsed,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  StudentCredit.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    balance = json['balance'];
    totalUsed = json['totalUsed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'balance': balance,
      'totalUsed': totalUsed,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class ProjectModelData {
  String? title;
  List<String>? description;
  String? id;

  ProjectModelData({this.title, this.description, this.id});

  ProjectModelData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = (json['description'] as List?)
        ?.map((e) => e.toString())
        .toList();
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, '_id': id};
  }
}

class Internship {
  String? company;
  String? role;
  String? duration;
  String? description;
  String? id;

  Internship({
    this.company,
    this.role,
    this.duration,
    this.description,
    this.id,
  });

  Internship.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    role = json['role'];
    duration = json['duration'];
    description = json['description'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'role': role,
      'duration': duration,
      'description': description,
      '_id': id,
    };
  }
}

class College {
  String? degree;
  String? department;
  String? institution;
  String? cgpa;
  String? startYear;
  String? endYear;
  String? id;

  College({
    this.degree,
    this.department,
    this.institution,
    this.cgpa,
    this.startYear,
    this.endYear,
    this.id,
  });

  College.fromJson(Map<String, dynamic> json) {
    degree = json['degree'];
    department = json['department'];
    institution = json['institution'];
    cgpa = json['cgpa'];
    startYear = json['start_year'];
    endYear = json['end_year'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'department': department,
      'institution': institution,
      'cgpa': cgpa,
      'start_year': startYear,
      'end_year': endYear,
      '_id': id,
    };
  }
}

class HigherSecondary {
  String? institution;
  String? board;
  String? percentage;
  String? yearOfPassing;
  String? id;

  HigherSecondary({
    this.institution,
    this.board,
    this.percentage,
    this.yearOfPassing,
    this.id,
  });

  HigherSecondary.fromJson(Map<String, dynamic> json) {
    institution = json['institution'];
    board = json['board'];
    percentage = json['percentage'];
    yearOfPassing = json['year_of_passing'];
    id = json['_id'];
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

class SecondaryEducation {
  String? institution;
  String? board;
  String? percentage;
  String? yearOfPassing;
  String? id;

  SecondaryEducation({
    this.institution,
    this.board,
    this.percentage,
    this.yearOfPassing,
    this.id,
  });

  SecondaryEducation.fromJson(Map<String, dynamic> json) {
    institution = json['institution'];
    board = json['board'];
    percentage = json['percentage'];
    yearOfPassing = json['year_of_passing'];
    id = json['_id'];
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

class Education {
  School? school;
  List<College>? college;

  Education({this.school, this.college});

  Education.fromJson(Map<String, dynamic> json) {
    school = json['school'] != null ? School.fromJson(json['school']) : null;

    college =
        (json['college'] as List?)?.map((e) => College.fromJson(e)).toList() ??
        [];
  }

  Map<String, dynamic> toJson() {
    return {
      'school': school?.toJson(),
      'college': college?.map((e) => e.toJson()).toList(),
    };
  }
}

class School {
  HigherSecondary? higherSecondary;
  SecondaryEducation? secondary;

  School({this.higherSecondary, this.secondary});

  School.fromJson(Map<String, dynamic> json) {
    higherSecondary = json['higher_secondary'] != null
        ? HigherSecondary.fromJson(json['higher_secondary'])
        : null;

    secondary = json['secondary'] != null
        ? SecondaryEducation.fromJson(json['secondary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'higher_secondary': higherSecondary?.toJson(),
      'secondary': secondary?.toJson(),
    };
  }
}

class Experience {
  String? company;
  String? role;
  String? duration;
  String? description;
  String? id;

  Experience({
    this.company,
    this.role,
    this.duration,
    this.description,
    this.id,
  });

  Experience.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    role = json['role'];
    duration = json['duration'];
    description = json['description'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'role': role,
      'duration': duration,
      'description': description,
      '_id': id,
    };
  }
}

class Training {
  String? title;
  String? organization;
  String? duration;
  String? description;
  String? id;

  Training({
    this.title,
    this.organization,
    this.duration,
    this.description,
    this.id,
  });

  Training.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    organization = json['organization'];
    duration = json['duration'];
    description = json['description'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'organization': organization,
      'duration': duration,
      'description': description,
      '_id': id,
    };
  }
}

class VolunteerExperience {
  String? organization;
  String? role;
  String? duration;
  String? description;
  String? id;

  VolunteerExperience({
    this.organization,
    this.role,
    this.duration,
    this.description,
    this.id,
  });

  VolunteerExperience.fromJson(Map<String, dynamic> json) {
    organization = json['organization'];
    role = json['role'];
    duration = json['duration'];
    description = json['description'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'organization': organization,
      'role': role,
      'duration': duration,
      'description': description,
      '_id': id,
    };
  }
}

class IndustrialVisit {
  String? company;
  String? location;
  String? date;
  String? description;
  String? id;

  IndustrialVisit({
    this.company,
    this.location,
    this.date,
    this.description,
    this.id,
  });

  IndustrialVisit.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    location = json['location'];
    date = json['date'];
    description = json['description'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'location': location,
      'date': date,
      'description': description,
      '_id': id,
    };
  }
}

class Parent {
  String? fatherName;
  String? motherName;
  String? phone;
  String? occupation;
  String? id;

  Parent({
    this.fatherName,
    this.motherName,
    this.phone,
    this.occupation,
    this.id,
  });

  Parent.fromJson(Map<String, dynamic> json) {
    fatherName = json['fatherName'];
    motherName = json['motherName'];
    phone = json['phone'];
    occupation = json['occupation'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'fatherName': fatherName,
      'motherName': motherName,
      'phone': phone,
      'occupation': occupation,
      '_id': id,
    };
  }
}

class LanguageKnown {
  String? language;

  LanguageKnown({this.language});

  LanguageKnown.fromJson(dynamic json) {
    language = json.toString();
  }

  dynamic toJson() => language;
}

class Achievement {
  String? title;

  Achievement({this.title});

  Achievement.fromJson(dynamic json) {
    title = json.toString();
  }

  dynamic toJson() => title;
}

class Publication {
  String? title;

  Publication({this.title});

  Publication.fromJson(dynamic json) {
    title = json.toString();
  }

  dynamic toJson() => title;
}
