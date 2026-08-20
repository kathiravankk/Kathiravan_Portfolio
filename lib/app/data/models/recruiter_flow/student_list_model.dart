import 'package:internsharks/app/core/utils/app_functions.dart';

class StudentListModel {
  List<StudentDetails>? studentList;

  StudentListModel({this.studentList});

  factory StudentListModel.fromJson(List<dynamic> json) {
    return StudentListModel(
      studentList: json.map((e) => StudentDetails.fromJson(e)).toList(),
    );
  }
}

class StudentDetails {
  String? id;
  String? studProfile;
  String? studName;
  String? stuGender;
  String? studDob;
  String? studEmail;
  String? studMobileNo;

  String? studentaddress;
  String? studentdegree;
  String? studentfieldofstudy;
  String? studentcollegename;
  dynamic studcollegestartyear;
  String? studcollegeendyear;
  String? studcollegelocation;

  String? studhighschollname;
  dynamic studhighschoolpercentage;
  String? studhighschoollocation;

  String? studentsecondaryschoolname;
  dynamic studentsecondaryschoolpercentage;
  String? studsecondaryschoollocation;

  List<String>? studprogramminglang;

  String? studprojectdecription;

  List<StudentCertificate>? studentcertificate;

  String? studentresume;
  String? studentcoverletter;

  String? createdAt;
  String? updatedAt;
  int? v;

  bool? isVerified;
  bool? isFavorite;
  bool? isActive;

  String? studentCreditId;
  String? templateNumber;
  String? location;

  /// Newly Added
  String? github;
  String? linkedIn;
  String? profileSummary;
  String? studentBanner;
  String? deletedAt;
  dynamic referredBy;
  String? role;
  String? referralCode;

  bool? freeBannerUsed;
  bool? isWaterMarkRemoved;

  List<dynamic>? fcmTokens;

  Education? education;

  List<dynamic>? achievements;
  List<dynamic>? areasOfInterest;
  List<dynamic>? experience;
  List<dynamic>? hobbies;
  List<dynamic>? industrialVisits;
  List<dynamic>? internships;
  List<dynamic>? languagesKnown;
  List<dynamic>? leadership;
  List<dynamic>? paperPresentations;
  List<dynamic>? parents;
  List<dynamic>? projects;
  List<dynamic>? publications;
  List<dynamic>? studentAdhar;
  List<dynamic>? studentId;
  List<dynamic>? toolsAndTechnologies;
  List<dynamic>? trainings;
  List<dynamic>? volunteerExperience;
  List<dynamic>? workshops;

  /// Duplicate arrays returned by API
  List<College>? college;
  List<SecondaryEducation>? higherSecondary;
  List<SecondaryEducation>? secondary;

  StudentDetails({
    this.id,
    this.studProfile,
    this.studName,
    this.stuGender,
    this.studDob,
    this.studEmail,
    this.studMobileNo,
    this.studentaddress,
    this.studentdegree,
    this.studentfieldofstudy,
    this.studentcollegename,
    this.studcollegestartyear,
    this.studcollegeendyear,
    this.studcollegelocation,
    this.studhighschollname,
    this.studhighschoolpercentage,
    this.studhighschoollocation,
    this.studentsecondaryschoolname,
    this.studentsecondaryschoolpercentage,
    this.studsecondaryschoollocation,
    this.studprogramminglang,
    this.studprojectdecription,
    this.studentcertificate,
    this.studentresume,
    this.studentcoverletter,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isVerified,
    this.isFavorite,
    this.isActive,
    this.studentCreditId,
    this.templateNumber,
    this.location,
    this.github,
    this.linkedIn,
    this.profileSummary,
    this.studentBanner,
    this.deletedAt,
    this.referredBy,
    this.role,
    this.referralCode,
    this.freeBannerUsed,
    this.isWaterMarkRemoved,
    this.fcmTokens,
    this.education,
    this.achievements,
    this.areasOfInterest,
    this.experience,
    this.hobbies,
    this.industrialVisits,
    this.internships,
    this.languagesKnown,
    this.leadership,
    this.paperPresentations,
    this.parents,
    this.projects,
    this.publications,
    this.studentAdhar,
    this.studentId,
    this.toolsAndTechnologies,
    this.trainings,
    this.volunteerExperience,
    this.workshops,
    this.college,
    this.higherSecondary,
    this.secondary,
  });

  StudentDetails.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    studProfile = json['studprofile'];
    studName = json['studname'];
    stuGender = json['studgender'];
    studDob = json['studdob'];
    studEmail = json['studemail'];
    studMobileNo = json['studmobileno'];

    studentaddress = json['studentaddress'];
    studentdegree = json['studentdegree'];
    studentfieldofstudy = json['studentfieldofstudy'];
    studentcollegename = json['studentcollegename'];

    studcollegestartyear = json['studcollegestartyear'];
    studcollegeendyear = json['studcollegeendyear'];
    studcollegelocation = json['studcollegelocation'];

    studhighschollname = json['studhighschollname'];
    studhighschoolpercentage = json['studhighschoolpercentage'];
    studhighschoollocation = json['studhighschoollocation'];

    studentsecondaryschoolname = json['studentsecondaryschoolname'];

    studentsecondaryschoolpercentage = json['studentsecondaryschoolpercentage'];

    studsecondaryschoollocation = json['studsecondaryschoollocation'];

    studprogramminglang = AppFunctions.parseSkillsList(
      json['studprogramminglang'],
    );

    /// Supports both old and new API
    studentcertificate =
        (json['studentcertificate'] as List?)
            ?.map((e) => StudentCertificate.fromJson(e))
            .toList() ??
        [];

    studentresume = json['studentresume'];
    studentcoverletter = json['studentcoverletter'];
    studprojectdecription = json['studprojectdecription'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];

    isVerified = json['isVerified'];
    isFavorite = json['isFavorite'] ?? false;
    isActive = json['isActive'];

    studentCreditId = json['studentCreditId'];
    templateNumber = json['templateNumber'];
    location = json['location'];

    github = json['github'];
    linkedIn = json['linkedIn'];
    profileSummary = json['profile_summary'];
    studentBanner = json['student_banner'];
    deletedAt = json['deletedAt'];
    referredBy = json['referredBy'];
    role = json['role'];
    referralCode = json['referralCode'];

    freeBannerUsed = json['freeBannerUsed'];
    isWaterMarkRemoved = json['isWaterMarkRemoved'];

    fcmTokens = json['fcmTokens'] ?? [];

    education = json['education'] is Map<String, dynamic>
        ? Education.fromJson(json['education'])
        : null;

    achievements = json['achievements'] ?? [];
    areasOfInterest = json['areas_of_interest'] ?? [];
    experience = json['experience'] ?? [];
    hobbies = json['hobbies'] ?? [];
    industrialVisits = json['industrial_visits'] ?? [];
    internships = json['internships'] ?? [];
    languagesKnown = json['languages_known'] ?? [];
    leadership = json['leadership'] ?? [];
    paperPresentations = json['paper_presentations'] ?? [];
    parents = json['parents'] ?? [];
    projects = json['projects'] ?? [];
    publications = json['publications'] ?? [];

    studentAdhar = json['studentAdhar'] ?? [];
    studentId = json['studentId'] ?? [];

    toolsAndTechnologies = json['tools_and_technologies'] ?? [];

    trainings = json['trainings'] ?? [];
    volunteerExperience = json['volunteer_experience'] ?? [];
    workshops = json['workshops'] ?? [];

    /// Duplicate arrays

    college =
        (json['college'] as List?)?.map((e) => College.fromJson(e)).toList() ??
        [];

    higherSecondary =
        (json['higher_secondary'] as List?)
            ?.map((e) => SecondaryEducation.fromJson(e))
            .toList() ??
        [];

    secondary =
        (json['secondary'] as List?)
            ?.map((e) => SecondaryEducation.fromJson(e))
            .toList() ??
        [];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studprofile': studProfile,
      'studname': studName,
      'studgender': stuGender,
      'studdob': studDob,
      'studemail': studEmail,
      'studmobileno': studMobileNo,
      'studentaddress': studentaddress,
      'studentdegree': studentdegree,
      'studentfieldofstudy': studentfieldofstudy,
      'studentcollegename': studentcollegename,
      'studcollegestartyear': studcollegestartyear,
      'studcollegeendyear': studcollegeendyear,
      'studcollegelocation': studcollegelocation,
      'studhighschollname': studhighschollname,
      'studhighschoolpercentage': studhighschoolpercentage,
      'studhighschoollocation': studhighschoollocation,
      'studentsecondaryschoolname': studentsecondaryschoolname,
      'studentsecondaryschoolpercentage': studentsecondaryschoolpercentage,
      'studsecondaryschoollocation': studsecondaryschoollocation,
      'studprogramminglang': studprogramminglang,
      'studprojectdecription': studprojectdecription,
      'studentcertificate': studentcertificate?.map((e) => e.toJson()).toList(),
      'studentresume': studentresume,
      'studentcoverletter': studentcoverletter,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'isVerified': isVerified,
      'isFavorite': isFavorite,
      'isActive': isActive,
      'studentCreditId': studentCreditId,
      'templateNumber': templateNumber,
      'location': location,

      'github': github,
      'linkedIn': linkedIn,
      'profile_summary': profileSummary,
      'student_banner': studentBanner,
      'deletedAt': deletedAt,
      'referredBy': referredBy,
      'role': role,
      'referralCode': referralCode,
      'freeBannerUsed': freeBannerUsed,
      'isWaterMarkRemoved': isWaterMarkRemoved,
      'fcmTokens': fcmTokens,

      'education': education?.toJson(),

      'achievements': achievements,
      'areas_of_interest': areasOfInterest,
      'experience': experience,
      'hobbies': hobbies,
      'industrial_visits': industrialVisits,
      'internships': internships,
      'languages_known': languagesKnown,
      'leadership': leadership,
      'paper_presentations': paperPresentations,
      'parents': parents,
      'projects': projects,
      'publications': publications,
      'studentAdhar': studentAdhar,
      'studentId': studentId,
      'tools_and_technologies': toolsAndTechnologies,
      'trainings': trainings,
      'volunteer_experience': volunteerExperience,
      'workshops': workshops,

      'college': college?.map((e) => e.toJson()).toList(),

      'higher_secondary': higherSecondary?.map((e) => e.toJson()).toList(),

      'secondary': secondary?.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentCertificate {
  String? name;
  String? issuer;
  String? file;

  StudentCertificate({this.name, this.issuer, this.file});

  factory StudentCertificate.fromJson(dynamic json) {
    if (json is String) {
      return StudentCertificate(file: json);
    }

    return StudentCertificate(
      name: json["name"],
      issuer: json["issuer"],
      file: json["file"],
    );
  }

  dynamic toJson() {
    if (file != null && name == null && issuer == null) {
      return file;
    }

    return {"name": name, "issuer": issuer, "file": file};
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
    degree = json["degree"];
    department = json["department"];
    institution = json["institution"];
    cgpa = json["cgpa"];
    startYear = json["start_year"]?.toString();
    endYear = json["end_year"]?.toString();
    id = json["_id"];
  }

  Map<String, dynamic> toJson() {
    return {
      "degree": degree,
      "department": department,
      "institution": institution,
      "cgpa": cgpa,
      "start_year": startYear,
      "end_year": endYear,
      "_id": id,
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
    institution = json["institution"];
    board = json["board"];
    percentage = json["percentage"]?.toString();
    yearOfPassing = json["year_of_passing"]?.toString();
    id = json["_id"];
  }

  Map<String, dynamic> toJson() {
    return {
      "institution": institution,
      "board": board,
      "percentage": percentage,
      "year_of_passing": yearOfPassing,
      "_id": id,
    };
  }
}

class School {
  SecondaryEducation? higherSecondary;
  SecondaryEducation? secondary;

  School({this.higherSecondary, this.secondary});

  School.fromJson(Map<String, dynamic> json) {
    higherSecondary = json["higher_secondary"] != null
        ? SecondaryEducation.fromJson(json["higher_secondary"])
        : null;

    secondary = json["secondary"] != null
        ? SecondaryEducation.fromJson(json["secondary"])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "higher_secondary": higherSecondary?.toJson(),
      "secondary": secondary?.toJson(),
    };
  }
}

class Education {
  School? school;
  List<College>? college;

  Education({this.school, this.college});

  Education.fromJson(Map<String, dynamic> json) {
    school = json['school'] != null ? School.fromJson(json['school']) : null;

    if (json['college'] is List) {
      college = (json['college'] as List)
          .map((e) => College.fromJson(e))
          .toList();
    } else {
      college = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'school': school?.toJson(),
      'college': college?.map((e) => e.toJson()).toList(),
    };
  }
}
