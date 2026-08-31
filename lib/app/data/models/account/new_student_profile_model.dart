import 'dart:convert';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/data/models/account/education_model.dart';

class NewStudentProfileModel {
  String? message;
  String? id;
  String? studProfile;
  String? studentName;
  String? studentGender;
  String? studentDob;
  String? studEmail;
  String? studMobileNo;
  String? role;
  List<String>? studProgrammingLang;
  List<StudentCertificate>? studentCertificate;
  String? studentResume;
  String? profileSummary;
  String? sureName;
  List<dynamic>? studentAadhaar;
  List<dynamic>? studentId;
  List<String>? areasOfInterest;
  List<String>? hobbies;
  List<String>? languagesKnown;
  List<String>? volunteerExperience;
  List<String>? leadership;
  List<String>? achievements;
  List<String>? publications;
  List<String>? workshops;
  List<NewPaperPresentation>? paperPresentations;
  List<dynamic>? toolsAndTechnologies;
  String? fontName;
  List<NewProjectData>? projects;
  List<dynamic>? experience;
  List<NewInternshipData>? internships;
  List<NewIndustrialVisit>? industrialVisits;
  List<dynamic>? trainings;
  List<dynamic>? parents;
  int? templateUnlock;
  List<dynamic>? college;
  List<HigherSecondary>? higherSecondary;
  List<Secondary>? secondary;
  NewEducationData? education;
  bool? freeBannerUsed;
  List<dynamic>? fcmTokens;
  String? referralCode;
  String? referredBy;
  StudentCreditId? studentCreditId;
  bool? isVerified;
  bool? isWaterMarkRemoved;
  bool? isActive;
  String? deletedAt;
  String? deletedBy;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? github;
  String? linkedIn;
  String? location;
  bool? syllabusStatus;
  String? applicationStatus;
  int? applicationCount;
  int? recruiterActionCount;
  String? studentBanner;
  String? templateNumber;
  String? collegeLocation;
  String? collegeName;
  List<String>? verifiedItems;

  NewStudentProfileModel({
    this.message,
    this.id,
    this.studProfile,
    this.studentName,
    this.studEmail,
    this.studMobileNo,
    this.role,
    this.studProgrammingLang,
    this.studentCertificate,
    this.studentResume,
    this.profileSummary,
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
    this.fontName,
    this.projects,
    this.experience,
    this.internships,
    this.industrialVisits,
    this.trainings,
    this.parents,
    this.templateUnlock,
    this.college,
    this.higherSecondary,
    this.secondary,
    this.education,
    this.freeBannerUsed,
    this.fcmTokens,
    this.referralCode,
    this.referredBy,
    this.studentCreditId,
    this.isVerified,
    this.isWaterMarkRemoved,
    this.isActive,
    this.deletedAt,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.github,
    this.linkedIn,
    this.location,
    this.syllabusStatus,
    this.applicationStatus,
    this.applicationCount,
    this.recruiterActionCount,
    this.studentBanner,
    this.templateNumber,
    this.studentGender,
    this.collegeLocation,
    this.studentDob,
    this.collegeName,
    this.verifiedItems,
  });

  factory NewStudentProfileModel.fromJson(Map<String, dynamic> json) {
    return NewStudentProfileModel(
      message: json['message']??"",
      id: json['_id']??"",
      studProfile: json['studprofile']??"",
      studentName: json['studname']??"",
      studentDob: json['studdob'] ?? "",
      studEmail: json['studemail']??"",
      studMobileNo: json['studmobileno']??"",
      role: json['role']??"",
      studProgrammingLang: AppFunctions.parseSkillsList(
        json['studprogramminglang'],
      ),
      studentCertificate: (json['studentcertificate'] as List?)
          ?.map((e) => StudentCertificate.fromJson(e))
          .toList(),
      studentResume: json['studentresume']??"",
      profileSummary: json['profile_summary']??"",
      studentAadhaar: json['studentAdhar'] ?? [],
      studentId: json['studentId'] ?? [],
      areasOfInterest: (json['areas_of_interest'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      hobbies: (json['hobbies'] as List?)?.map((e) => e.toString()).toList(),
      languagesKnown: (json['languages_known'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      volunteerExperience: (json['volunteer_experience'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      leadership: (json['leadership'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      achievements: (json['achievements'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      publications: (json['publications'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      workshops: (json['workshops'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      paperPresentations: (json['paper_presentations'] as List?)
          ?.map((e) => NewPaperPresentation.fromJson(e))
          .toList(),
      toolsAndTechnologies: json['tools_and_technologies'] ?? [],
      fontName: json['font_name']??"",
      projects: (json['projects'] as List?)
          ?.map((e) => NewProjectData.fromJson(e))
          .toList(),
      experience: json['experience'] ?? [],
      internships: (json['internships'] as List?)
          ?.map((e) => NewInternshipData.fromJson(e))
          .toList(),
      industrialVisits: (json['industrial_visits'] as List?)
          ?.map((e) => NewIndustrialVisit.fromJson(e))
          .toList(),
      trainings: json['trainings'] ?? [],
      parents: json['parents'] ?? [],
      templateUnlock: json['templateunlock'] != null ? int.tryParse(json['templateunlock'].toString()) : null,
      college: json['college'] ?? [],
      higherSecondary: (json['higher_secondary'] as List?)
          ?.map((e) => HigherSecondary.fromJson(e))
          .toList(),
      secondary: (json['secondary'] as List?)
          ?.map((e) => Secondary.fromJson(e))
          .toList(),
      education: json['education'] != null
          ? NewEducationData.fromJson(json['education'])
          : null,
      freeBannerUsed: json['freeBannerUsed']??false,
      fcmTokens: json['fcmTokens'] ?? [],
      referralCode: json['referralCode']??"",
      referredBy: json['referredBy']??"",
      studentCreditId: json['studentCreditId'] != null
          ? StudentCreditId.fromJson(json['studentCreditId'])
          : null,
      isVerified: json['isVerified']??false,
      isWaterMarkRemoved: json['isWaterMarkRemoved']??false,
      isActive: json['isActive']??false,
      deletedAt: json['deletedAt']??"",
      deletedBy: json['deletedBy']??"",
      createdAt: json['createdAt']??"",
      updatedAt: json['updatedAt']??"",
      v: json['__v']??0,
      github: json['github']??"",
      linkedIn: json['linkedIn']??"",
      location: json['location']??"",
      syllabusStatus: json['syllabusstatus']??false,
      applicationStatus: json['applicationstatus']??"",
      applicationCount: json['applicationcount']??0,
      recruiterActionCount: json['recruiterActionCount']??0,
      studentBanner: json['student_banner'] ?? "",
      templateNumber: json['templateNumber'] ?? "",
      studentGender: json['studgender'] ?? "",
      collegeLocation: json['studcollegelocation'] ?? "",
      collegeName: json['studentcollegename'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      '_id': id,
      'studprofile': studProfile,
      'studname': studentName,
      'studemail': studEmail,
      'studmobileno': studMobileNo,
      'role': role,
      'studprogramminglang': studProgrammingLang,
      'studentcertificate': studentCertificate?.map((e) => e.toJson()).toList(),
      'studentresume': studentResume,
      'profile_summary': profileSummary,
      'studentAdhar': studentAadhaar,
      'studentId': studentId,
      'areas_of_interest': areasOfInterest,
      'hobbies': hobbies,
      'languages_known': languagesKnown,
      'volunteer_experience': volunteerExperience,
      'leadership': leadership,
      'achievements': achievements,
      'publications': publications,
      'workshops': workshops,
      'paper_presentations': paperPresentations
          ?.map((e) => e.toJson())
          .toList(),
      'tools_and_technologies': toolsAndTechnologies,
      'font_name': fontName,
      'projects': projects?.map((e) => e.toJson()).toList(),
      'experience': experience,
      'internships': internships?.map((e) => e.toJson()).toList(),
      'industrial_visits': industrialVisits?.map((e) => e.toJson()).toList(),
      'trainings': trainings,
      'parents': parents,
      'templateunlock': templateUnlock,
      'college': college is List
          ? (college as List)
              .map((e) => e is Map
                  ? e
                  : (e is CollegeEducation
                      ? e.toJson()
                      : (e != null && e.runtimeType.toString().contains('CollegeData')
                          // CollegeData (from education_model.dart) — call toJson via dynamic
                          ? (e as dynamic).toJson() as Map<String, dynamic>
                          : e)))
              .toList()
          : college,
      'higher_secondary': higherSecondary?.map((e) => e.toJson()).toList(),
      'secondary': secondary?.map((e) => e.toJson()).toList(),
      'education': education?.toJson(),
      'freeBannerUsed': freeBannerUsed,
      'fcmTokens': fcmTokens,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'studentCreditId': studentCreditId?.toJson(),
      'isVerified': isVerified,
      'isWaterMarkRemoved': isWaterMarkRemoved,
      'isActive': isActive,
      'deletedAt': deletedAt,
      'deletedBy': deletedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'github': github,
      'linkedIn': linkedIn,
      'location': location,
      'syllabusstatus': syllabusStatus,
      'applicationstatus': applicationStatus,
      'applicationcount': applicationCount,
      'recruiterActionCount': recruiterActionCount,
      'student_banner': studentBanner,
      'templateNumber': templateNumber,
      "studcollegelocation": collegeLocation,
      "studgender": studentGender,
      "studdob": studentDob,
      "studentcollegename": collegeName,
      "verified_items": verifiedItems ?? [],
    };
  }

  Map<String, dynamic> toFormDataJson() {
    // 1. Extract college details (flat & array)
    String studentDegreeVal = '';
    String studentFieldOfStudyVal = '';
    String studentCollegeNameVal = collegeName ?? '';
    String studCollegeStartYearVal = '';
    String studCollegeEndYearVal = '';

    List<Map<String, dynamic>> collegeArray = [];
    if (college != null && college!.isNotEmpty) {
      for (var e in college!) {
        Map<String, dynamic> cMap = {};
        if (e is CollegeEducation) {
          cMap = {
            'degree': e.degree ?? '',
            'department': e.department ?? '',
            'institution': e.institution ?? '',
            'start_year': e.startYear ?? '',
            'end_year': e.endYear ?? '',
          };
        } else if (e is CollegeData) {
          cMap = {
            'degree': e.degree ?? '',
            'department': e.department ?? '',
            'institution': e.institution ?? '',
            'start_year': e.startYear?.toString() ?? '',
            'end_year': e.endYear?.toString() ?? '',
          };
        } else if (e is Map) {
          cMap = {
            'degree': e['degree'] ?? '',
            'department': e['department'] ?? '',
            'institution': e['institution'] ?? '',
            'start_year':
                e['start_year']?.toString() ?? e['startYear']?.toString() ?? '',
            'end_year':
                e['end_year']?.toString() ?? e['endYear']?.toString() ?? '',
          };
        }
        if (cMap.isNotEmpty) {
          collegeArray.add(cMap);
        }
      }
    } else if (education?.college != null && education!.college!.isNotEmpty) {
      for (var e in education!.college!) {
        collegeArray.add({
          'degree': e.degree ?? '',
          'department': e.department ?? '',
          'institution': e.institution ?? '',
          'start_year': e.startYear ?? '',
          'end_year': e.endYear ?? '',
        });
      }
    }

    if (collegeArray.isNotEmpty) {
      final firstC = collegeArray.first;
      studentDegreeVal = firstC['degree'] ?? '';
      studentFieldOfStudyVal = firstC['department'] ?? '';
      if (studentCollegeNameVal.isEmpty) {
        studentCollegeNameVal = firstC['institution'] ?? '';
      }
      studCollegeStartYearVal = firstC['start_year'] ?? '';
      studCollegeEndYearVal = firstC['end_year'] ?? '';
    }

    // 2. Higher Secondary details
    String studHighSchoolNameVal = '';
    String studHighSchoolPercentageVal = '';
    List<Map<String, dynamic>> higherSecArray = [];

    HigherSecondary? hsItem;
    if (higherSecondary != null && higherSecondary!.isNotEmpty) {
      hsItem = higherSecondary!.first;
    } else if (education?.school?.higherSecondary != null) {
      hsItem = education!.school!.higherSecondary;
    }

    if (hsItem != null) {
      studHighSchoolNameVal = hsItem.institution ?? '';
      studHighSchoolPercentageVal = hsItem.percentage ?? '';
      higherSecArray.add({
        'institution': hsItem.institution ?? '',
        'board': hsItem.board ?? '',
        'percentage': hsItem.percentage ?? '',
        'year_of_passing': hsItem.yearOfPassing ?? '',
      });
    }

    // 3. Secondary details
    String studentSecondarySchoolNameVal = '';
    String studentSecondarySchoolPercentageVal = '';
    List<Map<String, dynamic>> secondaryArray = [];

    Secondary? secItem;
    if (secondary != null && secondary!.isNotEmpty) {
      secItem = secondary!.first;
    } else if (education?.school?.secondary != null) {
      secItem = education!.school!.secondary;
    }

    if (secItem != null) {
      studentSecondarySchoolNameVal = secItem.institution ?? '';
      studentSecondarySchoolPercentageVal = secItem.percentage ?? '';
      secondaryArray.add({
        'institution': secItem.institution ?? '',
        'board': secItem.board ?? '',
        'percentage': secItem.percentage ?? '',
        'year_of_passing': secItem.yearOfPassing ?? '',
      });
    }

    // 4. Education Object
    final educationObject = {
      'school': {
        'higher_secondary':
            higherSecArray.isNotEmpty ? higherSecArray.first : {},
        'secondary': secondaryArray.isNotEmpty ? secondaryArray.first : {},
      },
      'college': collegeArray,
    };

    return {
      if (studProfile != null && studProfile!.isNotEmpty)
        'studprofile': studProfile,
      'studname': studentName ?? '',
      'studemail': studEmail ?? '',
      'studmobileno': studMobileNo ?? '',
      'linkedIn': linkedIn ?? '',
      'github': github ?? '',
      'studdob': studentDob ?? '',
      'location': location ?? '',
      'portfolio_website': github ?? '',
      'profile_summary': profileSummary ?? '',

      'studentdegree': studentDegreeVal,
      'studentfieldofstudy': studentFieldOfStudyVal,
      'studentcollegename': studentCollegeNameVal,
      'studcollegestartyear': studCollegeStartYearVal,
      'studcollegeendyear': studCollegeEndYearVal,
      'studcollegelocation': collegeLocation ?? '',

      'studhighschollname': studHighSchoolNameVal,
      'studhighschoolpercentage': studHighSchoolPercentageVal,
      'studhighschoollocation': '',

      'studentsecondaryschoolname': studentSecondarySchoolNameVal,
      'studentsecondaryschoolpercentage': studentSecondarySchoolPercentageVal,
      'studsecondaryschoollocation': '',

      'college': jsonEncode(collegeArray),
      'higher_secondary': jsonEncode(higherSecArray),
      'secondary': jsonEncode(secondaryArray),
      'education': jsonEncode(educationObject),

      'studprogramminglang':
          (studProgrammingLang ?? []).map((e) => [e]).toList(),
      'tools_and_technologies': jsonEncode(toolsAndTechnologies ?? []),

      'projects': jsonEncode(
        (projects ?? [])
            .map(
              (e) => {
                'title': e.title ?? '',
                'description': e.description ?? [],
              },
            )
            .toList(),
      ),
      'experience': jsonEncode(
        (experience ?? [])
            .map(
              (e) => e is Map
                  ? {
                      'role': e['role'] ?? '',
                      'company': e['company'] ?? '',
                      'duration': e['duration'] ?? '',
                      'description': e['description'] ?? '',
                    }
                  : {
                      'role': (e as dynamic).role ?? '',
                      'company': (e as dynamic).company ?? '',
                      'duration': (e as dynamic).duration ?? '',
                      'description': (e as dynamic).description ?? '',
                    },
            )
            .toList(),
      ),
      'studentcertificate': jsonEncode(
        (studentCertificate ?? []).map((e) => e.toJson()).toList(),
      ),
      'internships': jsonEncode(
        (internships ?? []).map((e) => e.toJson()).toList(),
      ),
      'industrial_visits': jsonEncode(
        (industrialVisits ?? [])
            .map((e) => e is Map ? e : (e as dynamic).toJson())
            .toList(),
      ),
      'paper_presentations': jsonEncode(
        (paperPresentations ?? []).map((e) => e.toJson()).toList(),
      ),
      'languages_known': jsonEncode(languagesKnown ?? []),
      'hobbies': jsonEncode(hobbies ?? []),
      'areas_of_interest': jsonEncode(areasOfInterest ?? []),
      'volunteer_experience': jsonEncode(volunteerExperience ?? []),
      'leadership': jsonEncode(leadership ?? []),
      'achievements': jsonEncode(achievements ?? []),
      'publications': jsonEncode(publications ?? []),
      'workshops': jsonEncode(workshops ?? []),

      'studentId': id ?? '',
      'templateNumber': templateNumber ?? '1',
      'message': message ?? '',
      'templateunlock': templateUnlock ?? 1,
    };
  }
}

class StudentCertificate {
  String? name;
  String? issuer;
  String? date;

  StudentCertificate({this.name, this.issuer, this.date});

  factory StudentCertificate.fromJson(Map<String, dynamic> json) {
    return StudentCertificate(
      name: json['name'],
      issuer: json['issuer'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'issuer': issuer, 'date': date};
  }
}

class NewPaperPresentation {
  String? title;
  String? event;
  String? year;
  String? description;
  String? id;

  NewPaperPresentation({
    this.title,
    this.event,
    this.year,
    this.description,
    this.id,
  });

  factory NewPaperPresentation.fromJson(Map<String, dynamic> json) {
    return NewPaperPresentation(
      title: json['title'] ?? json['tittle'] ?? json['paper_title'] ?? json['name'] ?? '',
      event: json['event'],
      year: json['year'],
      description: json['description'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'event': event,
      'year': year,
      'description': description,
      '_id': id,
    };
  }
}

class NewProjectData {
  String? title;
  List<String>? description;
  String? id;

  NewProjectData({this.title, this.description, this.id});

  factory NewProjectData.fromJson(Map<String, dynamic> json) {
    List<String>? parsedDesc;
    if (json['description'] is List) {
      parsedDesc = (json['description'] as List).map((e) => e.toString()).toList();
    } else if (json['description'] is String && (json['description'] as String).isNotEmpty) {
      parsedDesc = [json['description'] as String];
    }

    return NewProjectData(
      title: json['title'] ?? json['project_title'] ?? json['name'] ?? '',
      description: parsedDesc ?? [],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, '_id': id};
  }
}

class NewInternshipData {
  String? company;
  String? role;
  String? duration;
  String? description;
  String? id;

  NewInternshipData({
    this.company,
    this.role,
    this.duration,
    this.description,
    this.id,
  });

  factory NewInternshipData.fromJson(Map<String, dynamic> json) {
    return NewInternshipData(
      company: json['company'],
      role: json['role'],
      duration: json['duration'],
      description: json['description'],
      id: json['_id'],
    );
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

class NewIndustrialVisit {
  String? company;
  String? location;
  String? date;
  String? id;

  NewIndustrialVisit({this.company, this.location, this.date, this.id});

  factory NewIndustrialVisit.fromJson(Map<String, dynamic> json) {
    return NewIndustrialVisit(
      company: json['company'],
      location: json['location'],
      date: json['date'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'company': company, 'location': location, 'date': date, '_id': id};
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

  factory HigherSecondary.fromJson(Map<String, dynamic> json) {
    return HigherSecondary(
      institution: json['institution'],
      board: json['board'],
      percentage: json['percentage'],
      yearOfPassing: json['year_of_passing'],
      id: json['_id'],
    );
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

class Secondary {
  String? institution;
  String? board;
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
      institution: json['institution'],
      board: json['board'],
      percentage: json['percentage'],
      yearOfPassing: json['year_of_passing'],
      id: json['_id'],
    );
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

class NewEducationData {
  School? school;
  List<CollegeEducation>? college;

  NewEducationData({this.school, this.college});

  factory NewEducationData.fromJson(Map<String, dynamic> json) {
    return NewEducationData(
      school: json['school'] != null ? School.fromJson(json['school']) : null,
      college: (json['college'] as List?)
          ?.map((e) => CollegeEducation.fromJson(e))
          .toList(),
    );
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
  Secondary? secondary;

  School({this.higherSecondary, this.secondary});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      higherSecondary: json['higher_secondary'] != null
          ? HigherSecondary.fromJson(json['higher_secondary'])
          : null,
      secondary: json['secondary'] != null
          ? Secondary.fromJson(json['secondary'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'higher_secondary': higherSecondary?.toJson(),
      'secondary': secondary?.toJson(),
    };
  }
}

class CollegeEducation {
  String? degree;
  String? department;
  String? institution;
  String? cgpa;
  String? startYear;
  String? endYear;
  String? id;

  CollegeEducation({
    this.degree,
    this.department,
    this.institution,
    this.cgpa,
    this.startYear,
    this.endYear,
    this.id,
  });

  factory CollegeEducation.fromJson(Map<String, dynamic> json) {
    return CollegeEducation(
      degree: json['degree'],
      department: json['department'],
      institution: json['institution'],
      cgpa: json['cgpa'],
      startYear: json['start_year'],
      endYear: json['end_year'],
      id: json['_id'],
    );
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

class StudentCreditId {
  String? id;
  int? balance;
  int? freeCredits;
  int? totalUsed;
  String? createdAt;
  String? updatedAt;
  int? v;

  StudentCreditId({
    this.id,
    this.balance,
    this.freeCredits,
    this.totalUsed,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory StudentCreditId.fromJson(Map<String, dynamic> json) {
    return StudentCreditId(
      id: json['_id'],
      balance: json['balance'],
      freeCredits: json['freeCredits'],
      totalUsed: json['totalUsed'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'balance': balance,
      'freeCredits': freeCredits,
      'totalUsed': totalUsed,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
