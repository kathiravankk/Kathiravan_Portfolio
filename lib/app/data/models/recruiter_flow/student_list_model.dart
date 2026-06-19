import 'package:flutter/cupertino.dart';

class StudentListModel {
  List<StudentDetails>? studentList;

  StudentListModel({
    this.studentList,
  });

  factory StudentListModel.fromJson(List<dynamic> json) {
    return StudentListModel(
      studentList: json
          .map((e) => StudentDetails.fromJson(e))
          .toList(),
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
  String? studcollegelocation;
  String? studhighschollname;
  dynamic studhighschoolpercentage;
  String? studhighschoollocation;
  String? studentsecondaryschoolname;
  dynamic studentsecondaryschoolpercentage;
  String? studsecondaryschoollocation;
  List<String>? studprogramminglang;
  String? studprojectdecription;
  List<String>? studentcertificate;
  String? studentresume;
  String? studentcoverletter;
  String? createdAt;
  String? updatedAt;
  int? v;
  bool? isVerified;
  bool? isActive;
  String? studentCreditId;
  String? studcollegeendyear;
  String? templateNumber;
  String? location;

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
    this.education,
    this.isVerified,
    this.isActive,
    this.studentCreditId,
    this.studcollegeendyear,
    this.templateNumber,
    this.location,
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
  });

  StudentDetails.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      debugPrint("$key --> ${value.runtimeType}");
    });
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
    studcollegelocation = json['studcollegelocation'];
    studhighschollname = json['studhighschollname'];
    studhighschoolpercentage = json['studhighschoolpercentage'];
    studhighschoollocation = json['studhighschoollocation'];
    studentsecondaryschoolname =
    json['studentsecondaryschoolname'];
    studentsecondaryschoolpercentage =
    json['studentsecondaryschoolpercentage'];
    studsecondaryschoollocation =
    json['studsecondaryschoollocation'];

    studprogramminglang =
        (json['studprogramminglang'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
            [];

    studentcertificate =
        (json['studentcertificate'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
            [];

    studentresume = json['studentresume'];
    studentcoverletter = json['studentcoverletter'];
    studprojectdecription =
    json['studprojectdecription'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];

    isVerified = json['isVerified'];
    isActive = json['isActive'];

    studentCreditId = json['studentCreditId'];
    studcollegeendyear = json['studcollegeendyear'];
    templateNumber = json['templateNumber'];
    location = json['location'];

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
    paperPresentations =
        json['paper_presentations'] ?? [];
    parents = json['parents'] ?? [];
    projects = json['projects'] ?? [];
    publications = json['publications'] ?? [];
    studentAdhar =
        (json['studentAdhar'] as List?)
            ?.toList() ??
            [];
    studentId =
        (json['studentId'] as List?)
            ?.toList() ??
            [];
    toolsAndTechnologies =
        json['tools_and_technologies'] ?? [];
    trainings = json['trainings'] ?? [];
    volunteerExperience =
        json['volunteer_experience'] ?? [];
    workshops = json['workshops'] ?? [];
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
      'studcollegelocation': studcollegelocation,
      'studhighschollname': studhighschollname,
      'studhighschoolpercentage':
      studhighschoolpercentage,
      'studhighschoollocation':
      studhighschoollocation,
      'studentsecondaryschoolname':
      studentsecondaryschoolname,
      'studentsecondaryschoolpercentage':
      studentsecondaryschoolpercentage,
      'studsecondaryschoollocation':
      studsecondaryschoollocation,
      'studprogramminglang':
      studprogramminglang,
      'studentcertificate':
      studentcertificate,
      'studentresume': studentresume,
      'studentcoverletter':
      studentcoverletter,
      'studprojectdecription':
      studprojectdecription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'isVerified': isVerified,
      'isActive': isActive,
      'studentCreditId': studentCreditId,
      'studcollegeendyear':
      studcollegeendyear,
      'templateNumber': templateNumber,
      'location': location,
      'education': education?.toJson(),
    };
  }
}

class Education {
  School? school;
  List<College>? college;

  Education({this.school, this.college});

  Education.fromJson(Map<String, dynamic> json) {
    school = json['school'] != null
        ? School.fromJson(json['school'])
        : null;

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
      'college':
      college?.map((e) => e.toJson()).toList(),
    };
  }
}
class School {
  SecondaryEducation? higherSecondary;
  SecondaryEducation? secondary;

  School({
    this.higherSecondary,
    this.secondary,
  });

  School.fromJson(Map<String, dynamic> json) {
    higherSecondary =
    json['higher_secondary'] != null
        ? SecondaryEducation.fromJson(
        json['higher_secondary'])
        : null;

    secondary = json['secondary'] != null
        ? SecondaryEducation.fromJson(
        json['secondary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'higher_secondary':
      higherSecondary?.toJson(),
      'secondary': secondary?.toJson(),
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

  SecondaryEducation.fromJson(
      Map<String, dynamic> json) {
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
class College {
  String? degree;
  String? department;
  String? institution;
  String? startYear;
  String? endYear;
  String? id;

  College({
    this.degree,
    this.department,
    this.institution,
    this.startYear,
    this.endYear,
    this.id,
  });

  College.fromJson(Map<String, dynamic> json) {
    degree = json['degree'];
    department = json['department'];
    institution = json['institution'];
    startYear = json['start_year']?.toString();
    endYear = json['end_year']?.toString();
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'department': department,
      'institution': institution,
      'start_year': startYear,
      'end_year': endYear,
      '_id': id,
    };
  }
}