class ResumeResponse {
  final ExtractedContent? extractedContent;
  final Analysis? analysis;

  ResumeResponse({this.extractedContent, this.analysis});

  factory ResumeResponse.fromJson(Map<String, dynamic> json) {
    return ResumeResponse(
      extractedContent: json['extracted_content'] != null
          ? ExtractedContent.fromJson(json['extracted_content'])
          : null,
      analysis: json['analysis'] != null
          ? Analysis.fromJson(json['analysis'])
          : null,
    );
  }
}

class ExtractedContent {
  final PersonalInfo? personalInfo;
  final String? summary;

  ExtractedContent({this.personalInfo, this.summary});

  factory ExtractedContent.fromJson(Map<String, dynamic> json) {
    return ExtractedContent(
      personalInfo: json['personalInfo'] != null ? PersonalInfo.fromJson(json['personalInfo']) : null,
      summary: json['summary']?.toString(),
    );
  }
}

class PersonalInfo {
  final String? name;
  final String? email;
  final String? phone;
  final String? location;
  final String? gender;
  final String? linkedIn;
  final String? github;
  PersonalInfo({this.name, this.email, this.location, this.phone, this.gender, this.linkedIn, this.github});
  factory PersonalInfo.fromJson(dynamic json) {
    if (json is Map) {
      return PersonalInfo(
        name: json['name']?.toString(),
        email: json['email']?.toString(),
        location: json['location']?.toString(),
        phone: json['phone']?.toString(),
        gender: json['gender']?.toString(),
        linkedIn: json['linkedIn']?.toString(),
        github: json['github']?.toString(),
      );
    }
    return PersonalInfo();
  }
}

class Analysis {
  final int? overallScore;
  final String? grade;
  final Map<String, SectionData>? sections;
  Analysis({this.overallScore, this.grade, this.sections});
  factory Analysis.fromJson(Map<String, dynamic> json) {
    Map<String, SectionData> sectionsMap = {};
    if (json['sections'] != null) {
      (json['sections'] as Map).forEach((key, value) => sectionsMap[key] = SectionData.fromJson(value));
    }
    return Analysis(overallScore: json['overallScore'], grade: json['grade'], sections: sectionsMap);
  }
}

class SectionData {
  final int? rating;
  final List<String>? suggestions1;
  SectionData({this.rating, this.suggestions1});
  factory SectionData.fromJson(Map<String, dynamic> json) {
    return SectionData(
      rating: (json['rating'] as num?)?.toInt(),
      suggestions1: json['suggestions 1'] != null ? List<String>.from(json['suggestions 1']) :
      json['suggestions1'] != null ? List<String>.from(json['suggestions1']) : null,
    );
  }
}