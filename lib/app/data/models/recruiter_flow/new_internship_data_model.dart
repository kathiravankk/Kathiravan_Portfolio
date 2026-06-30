class NewInternshipDataModel {
  final String? message;
  final InternshipData? internshipData;

  NewInternshipDataModel({
    this.message,
    this.internshipData,
  });

  factory NewInternshipDataModel.fromJson(Map<String, dynamic> json) {
    return NewInternshipDataModel(
      message: json['message']??"",
      internshipData: json['job'] != null ? InternshipData.fromJson(json['job']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'job': internshipData?.toJson(),
    };
  }
}

class InternshipData {
  final String? companyName;
  final String? aboutCompany;
  final String? companyWebsite;
  final String? companyLogo;
  final String? roleType;
  final String? aboutInternship;
  final List<String>? studentQualification;
  final List<String>? requiredSkills;
  final String? companyState;
  final String? companyCity;
  final String? locationLink;
  final Location? location;
  final String? internshipDuration;
  final String? internshipStipend;
  final String? fee;
  final List<String>? projectDescription;
  final String? internshipMode;
  final String? days;
  final String? recruiter;
  final Industry? industry;
  final int? noOfPosition;
  final int? internPositions;
  final int? filledPositions;
  final dynamic syllabusData;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  InternshipData({
    this.companyName,
    this.aboutCompany,
    this.companyWebsite,
    this.companyLogo,
    this.roleType,
    this.aboutInternship,
    this.studentQualification,
    this.requiredSkills,
    this.companyState,
    this.companyCity,
    this.locationLink,
    this.location,
    this.internshipDuration,
    this.internshipStipend,
    this.fee,
    this.projectDescription,
    this.internshipMode,
    this.days,
    this.recruiter,
    this.industry,
    this.noOfPosition,
    this.internPositions,
    this.filledPositions,
    this.syllabusData,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory InternshipData.fromJson(Map<String, dynamic> json) {
    return InternshipData(
      companyName: json['companyname']??"",
      aboutCompany: json['aboutcompany']??"",
      companyWebsite: json['companywebsite']??"",
      companyLogo: json['companylogo']??"",
      roleType: json['roletype']??"",
      aboutInternship: json['aboutinternship']??"",
      studentQualification: json['studentqualification'] != null
          ? List<String>.from(json['studentqualification'])
          : [],
      requiredSkills: json['requiredskills'] != null
          ? List<String>.from(json['requiredskills'])
          : [],
      companyState: json['companystate']??"",
      companyCity: json['companycity']??"",
      locationLink: json['locationlink']??"",
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      internshipDuration: json['internshipduration']??"",
      internshipStipend: json['internshipstipend']??"",
      fee: json['fee']??"",
      projectDescription: json['project_description'] != null
          ? List<String>.from(json['project_description'])
          : [],
      internshipMode: json['internshipmode']??"",
      days: json['days']??"",
      recruiter: json['recruiter']??"",
      industry: json['industry'] != null
          ? Industry.fromJson(json['industry'])
          : null,
      noOfPosition: json['noofposition']??0,
      internPositions: json['internpositions']??0,
      filledPositions: json['filledpositions']??0,
      syllabusData: json['syllabusdata'],
      id: json['_id']??"",
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      v: json['__v']??0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyname': companyName,
      'aboutcompany': aboutCompany,
      'companywebsite': companyWebsite,
      'companylogo': companyLogo,
      'roletype': roleType,
      'aboutinternship': aboutInternship,
      'studentqualification': studentQualification,
      'requiredskills': requiredSkills,
      'companystate': companyState,
      'companycity': companyCity,
      'locationlink': locationLink,
      'location': location?.toJson(),
      'internshipduration': internshipDuration,
      'internshipstipend': internshipStipend,
      'fee': fee,
      'project_description': projectDescription,
      'internshipmode': internshipMode,
      'days': days,
      'recruiter': recruiter,
      'industry': industry?.toJson(),
      'noofposition': noOfPosition,
      'internpositions': internPositions,
      'filledpositions': filledPositions,
      'syllabusdata': syllabusData,
      '_id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(
          json['coordinates'].map((e) => (e as num).toDouble()))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class Industry {
  final String? id;
  final String? name;
  final String? industryimage;
  final int? v;

  Industry({
    this.id,
    this.name,
    this.industryimage,
    this.v,
  });

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: json['_id'],
      name: json['name'],
      industryimage: json['industryimage'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'industryimage': industryimage,
      '__v': v,
    };
  }
}