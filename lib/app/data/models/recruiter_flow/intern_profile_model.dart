// import 'package:internsharks/app/data/models/account/certification_model.dart';
// import 'package:internsharks/app/data/models/account/education_model.dart';
// import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
// import 'package:internsharks/app/data/models/account/student_profile_model.dart';
//
// class InternProfileModel {
//   InternProfileModel({
//     this.message,
//     this.id,
//     this.studProfile,
//     this.studName,
//     this.studEmail,
//     this.studMobileNo,
//     this.role,
//     this.studProgrammingLang,
//     this.studentCertificate,
//     this.studentResume,
//     this.studentAdhar,
//     this.studentId,
//     this.areasOfInterest,
//     this.hobbies,
//     this.languagesKnown,
//     this.volunteerExperience,
//     this.leadership,
//     this.achievements,
//     this.publications,
//     this.workshops,
//     this.paperPresentations,
//     this.toolsAndTechnologies,
//     this.projects,
//     this.experience,
//     this.internships,
//     this.industrialVisits,
//     this.trainings,
//     this.parents,
//     this.college,
//     this.higherSecondary,
//     this.secondary,
//     this.education,
//     this.freeBannerUsed,
//     this.fcmTokens,
//     this.studentCreditId,
//     this.isVerified,
//     this.isWaterMarkRemoved,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     this.github,
//     this.linkedIn,
//     this.location,
//     this.profileSummary,
//     this.studCollegeLocation,
//     this.studCollegeStartYear,
//     this.studentCollegeName,
//     this.studentDegree,
//     this.studentFieldOfStudy,
//     this.studentSecondarySchoolName,
//     this.studentSecondarySchoolPercentage,
//     this.studHighSchoolName,
//     this.studHighSchoolPercentage,
//     this.templateNumber,
//     this.studDob,
//     this.studentBanner,
//     this.isActive,
//     this.referralCode,
//     this.syllabusStatus,
//     this.applicationStatus,
//     this.favoriteStatus,
//   });
//
//   String? message;
//   String? id;
//   String? studProfile;
//   String? studName;
//   String? studEmail;
//   String? studMobileNo;
//   String? role;
//   List<String>? studProgrammingLang;
//   List<Certification>? studentCertificate;
//   dynamic studentResume;
//   List<dynamic>? studentAdhar;
//   List<dynamic>? studentId;
//   List<String>? areasOfInterest;
//   List<String>? hobbies;
//   List<String>? languagesKnown;
//   List<dynamic>? volunteerExperience;
//   List<dynamic>? leadership;
//   List<String>? achievements;
//   List<String>? publications;
//   List<String>? workshops;
//   List<dynamic>? paperPresentations;
//   List<dynamic>? toolsAndTechnologies;
//   List<Project>? projects;
//   List<ExperienceData>? experience;
//   List<InternShipModel>? internships;
//   List<dynamic>? industrialVisits;
//   List<dynamic>? trainings;
//   List<dynamic>? parents;
//   List<CollegeData>? college;
//   List<InternSchoolModel>? higherSecondary;
//   List<InternSchoolModel>? secondary;
//   EducationModel? education;
//   bool? freeBannerUsed;
//   List<String>? fcmTokens;
//   InternCreditModel? studentCreditId;
//   bool? isVerified;
//   bool? isWaterMarkRemoved;
//   String? createdAt;
//   String? updatedAt;
//   int? v;
//   String? github;
//   String? linkedIn;
//   String? location;
//   String? profileSummary;
//   String? studCollegeLocation;
//   String? studCollegeStartYear;
//   String? studentCollegeName;
//   String? studentDegree;
//   String? studentFieldOfStudy;
//   String? studentSecondarySchoolName;
//   String? studentSecondarySchoolPercentage;
//   String? studHighSchoolName;
//   String? studHighSchoolPercentage;
//   String? templateNumber;
//   dynamic studDob;
//   String? studentBanner;
//   bool? isActive;
//   String? referralCode;
//   bool? syllabusStatus;
//   dynamic applicationStatus;
//   bool? favoriteStatus;
//
//   factory InternProfileModel.fromJson(Map<String, dynamic> json) {
//     return InternProfileModel(
//       message: json["message"],
//       id: json["_id"],
//       studProfile: json["studprofile"],
//       studName: json["studname"],
//       studEmail: json["studemail"],
//       studMobileNo: json["studmobileno"],
//       role: json["role"],
//       studProgrammingLang: json["studprogramminglang"] == null
//           ? []
//           : List<String>.from(json["studprogramminglang"].map((x) => x)),
//       studentCertificate: json["studentcertificate"] == null
//           ? []
//           : List<InternCertificate>.from(
//         json["studentcertificate"]
//             .map((x) => InternCertificate.fromJson(x)),
//       ),
//       studentResume: json["studentresume"],
//       studentAdhar: json["studentAdhar"] == null
//           ? []
//           : List<dynamic>.from(json["studentAdhar"]),
//       studentId: json["studentId"] == null
//           ? []
//           : List<dynamic>.from(json["studentId"]),
//       areasOfInterest: json["areas_of_interest"] == null
//           ? []
//           : List<String>.from(json["areas_of_interest"]),
//       hobbies: json["hobbies"] == null
//           ? []
//           : List<String>.from(json["hobbies"]),
//       languagesKnown: json["languages_known"] == null
//           ? []
//           : List<String>.from(json["languages_known"]),
//       volunteerExperience: json["volunteer_experience"] == null
//           ? []
//           : List<dynamic>.from(json["volunteer_experience"]),
//       leadership: json["leadership"] == null
//           ? []
//           : List<dynamic>.from(json["leadership"]),
//       achievements: json["achievements"] == null
//           ? []
//           : List<String>.from(json["achievements"]),
//       publications: json["publications"] == null
//           ? []
//           : List<String>.from(json["publications"]),
//       workshops: json["workshops"] == null
//           ? []
//           : List<String>.from(json["workshops"]),
//       paperPresentations: json["paper_presentations"] == null
//           ? []
//           : List<dynamic>.from(json["paper_presentations"]),
//       toolsAndTechnologies: json["tools_and_technologies"] == null
//           ? []
//           : List<dynamic>.from(json["tools_and_technologies"]),
//       projects: json["projects"] == null
//           ? []
//           : List<InternProjectModel>.from(
//         json["projects"].map((x) => InternProjectModel.fromJson(x)),
//       ),
//       experience: json["experience"] == null
//           ? []
//           : List<dynamic>.from(json["experience"]),
//       internships: json["internships"] == null
//           ? []
//           : List<InternInternshipModel>.from(
//         json["internships"].map((x) => InternInternshipModel.fromJson(x)),
//       ),
//       industrialVisits: json["industrial_visits"] == null
//           ? []
//           : List<dynamic>.from(json["industrial_visits"]),
//       trainings: json["trainings"] == null
//           ? []
//           : List<dynamic>.from(json["trainings"]),
//       parents: json["parents"] == null
//           ? []
//           : List<dynamic>.from(json["parents"]),
//       college: json["college"] == null
//           ? []
//           : List<InternCollegeModel>.from(
//         json["college"].map((x) => InternCollegeModel.fromJson(x)),
//       ),
//       higherSecondary: json["higher_secondary"] == null
//           ? []
//           : List<InternSchoolModel>.from(
//         json["higher_secondary"].map((x) => InternSchoolModel.fromJson(x)),
//       ),
//       secondary: json["secondary"] == null
//           ? []
//           : List<InternSchoolModel>.from(
//         json["secondary"].map((x) => InternSchoolModel.fromJson(x)),
//       ),
//       education: json["education"] == null
//           ? null
//           : InternEducationModel.fromJson(json["education"]),
//       freeBannerUsed: json["freeBannerUsed"],
//       fcmTokens: json["fcmTokens"] == null
//           ? []
//           : List<String>.from(json["fcmTokens"]),
//       studentCreditId: json["studentCreditId"] == null
//           ? null
//           : InternCreditModel.fromJson(json["studentCreditId"]),
//       isVerified: json["isVerified"],
//       isWaterMarkRemoved: json["isWaterMarkRemoved"],
//       createdAt: json["createdAt"],
//       updatedAt: json["updatedAt"],
//       v: json["__v"],
//       github: json["github"],
//       linkedIn: json["linkedIn"],
//       location: json["location"],
//       profileSummary: json["profile_summary"],
//       studCollegeLocation: json["studcollegelocation"],
//       studCollegeStartYear: json["studcollegestartyear"],
//       studentCollegeName: json["studentcollegename"],
//       studentDegree: json["studentdegree"],
//       studentFieldOfStudy: json["studentfieldofstudy"],
//       studentSecondarySchoolName: json["studentsecondaryschoolname"],
//       studentSecondarySchoolPercentage:
//       json["studentsecondaryschoolpercentage"],
//       studHighSchoolName: json["studhighschollname"],
//       studHighSchoolPercentage: json["studhighschoolpercentage"],
//       templateNumber: json["templateNumber"],
//       studDob: json["studdob"],
//       studentBanner: json["student_banner"],
//       isActive: json["isActive"],
//       referralCode: json["referralCode"],
//       syllabusStatus: json["syllabusstatus"],
//       applicationStatus: json["applicationstatus"],
//       favoriteStatus: json["favoriteStatus"],
//     );
//   }
// }
// class InternEducationModel {
//   InternEducationModel({
//     this.school,
//     this.college,
//   });
//
//   InternSchoolEducation? school;
//   List<InternCollegeModel>? college;
//
//   factory InternEducationModel.fromJson(Map<String, dynamic> json) {
//     return InternEducationModel(
//       school: json["school"] == null
//           ? null
//           : InternSchoolEducation.fromJson(json["school"]),
//       college: json["college"] == null
//           ? []
//           : List<InternCollegeModel>.from(
//         json["college"].map((x) => InternCollegeModel.fromJson(x)),
//       ),
//     );
//   }
// }
//
// class InternSchoolEducation {
//   InternSchoolEducation({
//     this.higherSecondary,
//     this.secondary,
//   });
//
//   InternSchoolModel? higherSecondary;
//   InternSchoolModel? secondary;
//
//   factory InternSchoolEducation.fromJson(Map<String, dynamic> json) {
//     return InternSchoolEducation(
//       higherSecondary: json["higher_secondary"] == null
//           ? null
//           : InternSchoolModel.fromJson(json["higher_secondary"]),
//       secondary: json["secondary"] == null
//           ? null
//           : InternSchoolModel.fromJson(json["secondary"]),
//     );
//   }
// }
//
// class InternSchoolModel {
//   InternSchoolModel({
//     this.id,
//     this.institution,
//     this.board,
//     this.percentage,
//     this.yearOfPassing,
//   });
//
//   String? id;
//   String? institution;
//   String? board;
//   String? percentage;
//   String? yearOfPassing;
//
//   factory InternSchoolModel.fromJson(Map<String, dynamic> json) {
//     return InternSchoolModel(
//       id: json["_id"],
//       institution: json["institution"],
//       board: json["board"],
//       percentage: json["percentage"],
//       yearOfPassing: json["year_of_passing"],
//     );
//   }
// }
//
// class InternCollegeModel {
//   InternCollegeModel({
//     this.id,
//     this.degree,
//     this.department,
//     this.institution,
//     this.cgpa,
//     this.startYear,
//     this.endYear,
//   });
//
//   String? id;
//   String? degree;
//   String? department;
//   String? institution;
//   String? cgpa;
//   String? startYear;
//   String? endYear;
//
//   factory InternCollegeModel.fromJson(Map<String, dynamic> json) {
//     return InternCollegeModel(
//       id: json["_id"],
//       degree: json["degree"],
//       department: json["department"],
//       institution: json["institution"],
//       cgpa: json["cgpa"],
//       startYear: json["start_year"],
//       endYear: json["end_year"],
//     );
//   }
// }
// class InternCertificate {
//   InternCertificate({
//     this.name,
//     this.issuer,
//   });
//
//   String? name;
//   String? issuer;
//
//   factory InternCertificate.fromJson(Map<String, dynamic> json) {
//     return InternCertificate(
//       name: json["name"],
//       issuer: json["issuer"],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "name": name,
//       "issuer": issuer,
//     };
//   }
// }
//
// class InternProjectModel {
//   InternProjectModel({
//     this.id,
//     this.title,
//     this.description,
//   });
//
//   String? id;
//   String? title;
//   List<String>? description;
//
//   factory InternProjectModel.fromJson(Map<String, dynamic> json) {
//     return InternProjectModel(
//       id: json["_id"],
//       title: json["title"],
//       description: json["description"] == null
//           ? []
//           : List<String>.from(json["description"].map((x) => x)),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "title": title,
//       "description": description == null
//           ? []
//           : List<dynamic>.from(description!.map((x) => x)),
//     };
//   }
// }
//
// class InternInternshipModel {
//   InternInternshipModel({
//     this.id,
//     this.company,
//     this.role,
//     this.duration,
//     this.description,
//   });
//
//   String? id;
//   String? company;
//   String? role;
//   String? duration;
//   String? description;
//
//   factory InternInternshipModel.fromJson(Map<String, dynamic> json) {
//     return InternInternshipModel(
//       id: json["_id"],
//       company: json["company"],
//       role: json["role"],
//       duration: json["duration"],
//       description: json["description"],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "company": company,
//       "role": role,
//       "duration": duration,
//       "description": description,
//     };
//   }
// }
//
// class InternExperienceModel {
//   InternExperienceModel({
//     this.id,
//     this.company,
//     this.role,
//     this.duration,
//     this.description,
//   });
//
//   String? id;
//   String? company;
//   String? role;
//   String? duration;
//   String? description;
//
//   factory InternExperienceModel.fromJson(Map<String, dynamic> json) {
//     return InternExperienceModel(
//       id: json["_id"],
//       company: json["company"],
//       role: json["role"],
//       duration: json["duration"],
//       description: json["description"],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "company": company,
//       "role": role,
//       "duration": duration,
//       "description": description,
//     };
//   }
// }
//
// class InternVolunteerExperienceModel {
//   InternVolunteerExperienceModel({
//     this.id,
//     this.organization,
//     this.role,
//     this.duration,
//     this.description,
//   });
//
//   String? id;
//   String? organization;
//   String? role;
//   String? duration;
//   String? description;
//
//   factory InternVolunteerExperienceModel.fromJson(Map<String, dynamic> json) {
//     return InternVolunteerExperienceModel(
//       id: json["_id"],
//       organization: json["organization"],
//       role: json["role"],
//       duration: json["duration"],
//       description: json["description"],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "organization": organization,
//       "role": role,
//       "duration": duration,
//       "description": description,
//     };
//   }
// }
//
// class InternTrainingModel {
//   InternTrainingModel({
//     this.id,
//     this.name,
//     this.institute,
//     this.duration,
//   });
//
//   String? id;
//   String? name;
//   String? institute;
//   String? duration;
//
//   factory InternTrainingModel.fromJson(Map<String, dynamic> json) {
//     return InternTrainingModel(
//       id: json["_id"],
//       name: json["name"],
//       institute: json["institute"],
//       duration: json["duration"],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "name": name,
//       "institute": institute,
//       "duration": duration,
//     };
//   }
// }
//
// class InternParentModel {
//   InternParentModel({
//     this.id,
//     this.name,
//     this.relationship,
//     this.occupation,
//     this.mobile,
//   });
//
//   String? id;
//   String? name;
//   String? relationship;
//   String? occupation;
//   String? mobile;
//
//   factory InternParentModel.fromJson(Map<String, dynamic> json) {
//     return InternParentModel(
//       id: json["_id"],
//       name: json["name"],
//       relationship: json["relationship"],
//       occupation: json["occupation"],
//       mobile: json["mobile"],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "name": name,
//       "relationship": relationship,
//       "occupation": occupation,
//       "mobile": mobile,
//     };
//   }
// }
//
// class InternCreditModel {
//   InternCreditModel({
//     this.id,
//     this.balance,
//     this.totalUsed,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });
//
//   String? id;
//   int? balance;
//   int? totalUsed;
//   String? createdAt;
//   String? updatedAt;
//   int? v;
//
//   factory InternCreditModel.fromJson(Map<String, dynamic> json) {
//     return InternCreditModel(
//       id: json["_id"],
//       balance: json["balance"],
//       totalUsed: json["totalUsed"],
//       createdAt: json["createdAt"],
//       updatedAt: json["updatedAt"],
//       v: json["__v"],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "balance": balance,
//       "totalUsed": totalUsed,
//       "createdAt": createdAt,
//       "updatedAt": updatedAt,
//       "__v": v,
//     };
//   }
// }
