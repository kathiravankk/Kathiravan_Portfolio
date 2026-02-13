class Education {
  School? school;
  List<CollegeData>? college;

  Education({required this.school, required this.college});

   Education.fromJson(Map<String, dynamic> json) {
      school= School.fromJson(json['school'] ?? {});
      college= (json['college'] ?? [])
          .map<CollegeData>((e) => CollegeData.fromJson(e))
          .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "school": school!.toJson(),
      "college": college!.map((e) => e.toJson()).toList(),
    };
  }
}

class School {
  SchoolEducation higherSecondary;
  SchoolEducation secondary;

  School({required this.higherSecondary, required this.secondary});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      higherSecondary: SchoolEducation.fromJson(json['higher_secondary'] ?? {}),
      secondary: SchoolEducation.fromJson(json['secondary'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "higher_secondary": higherSecondary.toJson(),
      "secondary": secondary.toJson(),
    };
  }
}

class SchoolEducation {
  String? institution;
  dynamic board;
  String? percentage;
  String? yearOfPassing;

  SchoolEducation({
    required this.institution,
    required this.board,
    required this.percentage,
    required this.yearOfPassing,
  });

  SchoolEducation.fromJson(Map<String, dynamic> json) {
    institution = json['institution'] ?? "";
    board = json['board'] ?? "";
    percentage = json['percentage'] ?? "";
    yearOfPassing = json['year_of_passing'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "institution": institution,
      "board": board,
      "percentage": percentage,
      "year_of_passing": yearOfPassing,
    };
  }
}

class CollegeData {
  String? degree;
  String? department;
  String? institution;
  dynamic startYear;
  dynamic endYear;

  CollegeData({
    this.degree,
    this.department,
    this.institution,
    this.startYear,
    this.endYear,
  });

  CollegeData.fromJson(Map<String, dynamic> json) {
    degree = json['degree'] ?? '';
    department = json['department'] ?? '';
    institution = json['institution'] ?? '';
    startYear = json['start_year'] ?? '';
    endYear = json['end_year'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      "degree": degree,
      "department": department,
      "institution": institution,
      "start_year": startYear,
      "end_year": endYear,
    };
  }
}

class Degree {
  String degree;

  Degree({required this.degree});

  factory Degree.fromJson(Map<String, dynamic> json) {
    return Degree(degree: json['degree'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {"degree": degree};
  }
}

class Institution {
  String institution;

  Institution({required this.institution});

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(institution: json['institution'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {"institution": institution};
  }
}
