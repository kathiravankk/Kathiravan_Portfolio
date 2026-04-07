class ResumeExtractedDataModel {
  bool? success;
  String? filename;
  ExtractedResumeData? extractedData;
  int? tokenUsage;

  ResumeExtractedDataModel({
    this.success,
    this.filename,
    this.extractedData,
    this.tokenUsage,
  });

  ResumeExtractedDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    filename = json['filename'] ?? "";
    extractedData = json['extracted_data'] != null
        ? ExtractedResumeData.fromJson(json['extracted_data'])
        : null;
    tokenUsage = json['token_usage'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'filename': filename,
      'extracted_data': extractedData?.toJson(),
      'token_usage': tokenUsage,
    };
  }
}

class ExtractedResumeData {
  bool? isResume;
  ResumePersonalInfo? personalInfo;
  List<String>? skills;
  ResumeEducation? education;
  List<ResumeInstitution>? institution;

  ExtractedResumeData({
    this.isResume,
    this.personalInfo,
    this.skills,
    this.education,
    this.institution,
  });

  ExtractedResumeData.fromJson(Map<String, dynamic> json) {
    isResume = json['is_resume'] ?? false;
    personalInfo = json['personal_info'] != null
        ? ResumePersonalInfo.fromJson(json['personal_info'])
        : null;
    skills = json['skills'] != null ? List<String>.from(json['skills']) : [];
    education = json['education'] != null
        ? ResumeEducation.fromJson(json['education'])
        : null;
    institution = json['institution'] != null
        ? (json['institution'] as List)
              .map((e) => ResumeInstitution.fromJson(e))
              .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'is_resume': isResume,
      'personal_info': personalInfo?.toJson(),
      'skills': skills,
      'education': education?.toJson(),
      'institution': institution?.map((e) => e.toJson()).toList(),
    };
  }
}

class ResumePersonalInfo {
  String? name;
  String? email;
  String? phone;

  ResumePersonalInfo({this.name, this.email, this.phone});

  ResumePersonalInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    phone = json['phone'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone};
  }
}

class ResumeEducation {
  List<ResumeCollege>? college;

  ResumeEducation({this.college});

  ResumeEducation.fromJson(Map<String, dynamic> json) {
    college = json['college'] != null
        ? (json['college'] as List)
              .map((e) => ResumeCollege.fromJson(e))
              .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    return {'college': college?.map((e) => e.toJson()).toList()};
  }
}

class ResumeCollege {
  String? degree;
  String? department;
  String? institution;

  ResumeCollege({this.degree, this.department, this.institution});

  ResumeCollege.fromJson(Map<String, dynamic> json) {
    degree = json['degree'] ?? "";
    department = json['department'] ?? "";
    institution = json['institution'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'department': department,
      'institution': institution,
    };
  }
}

class ResumeInstitution {
  String? institution;

  ResumeInstitution({this.institution});

  ResumeInstitution.fromJson(Map<String, dynamic> json) {
    institution = json['institution'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {'institution': institution};
  }
}
