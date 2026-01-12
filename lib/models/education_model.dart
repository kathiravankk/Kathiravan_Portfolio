class Education {
  School school;
  List<College> college;

  Education({
    required this.school,
    required this.college,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      school: School.fromJson(json['school'] ?? {}),
      college: (json['college'] ?? [])
          .map<College>((e) => College.fromJson(e))
          .toList(),
    );
  }
}

class School {
  Secondary higherSecondary;
  Secondary secondary;

  School({
    required this.higherSecondary,
    required this.secondary,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      higherSecondary:
      Secondary.fromJson(json['higher_secondary'] ?? {}),
      secondary: Secondary.fromJson(json['secondary'] ?? {}),
    );
  }
}

class Secondary {
  String? institution;
  dynamic board;
  String? percentage;
  String? yearOfPassing;

  Secondary({
    required this.institution,
    required this.board,
    required this.percentage,
    required this.yearOfPassing,
  });

  factory Secondary.fromJson(Map<String, dynamic> json) {
    return Secondary(
      institution: json['institution'],
      board: json['board'],
      percentage: json['percentage'],
      yearOfPassing: json['year_of_passing'],
    );
  }
}
class College {
  String degree;
  String department;
  String institution;
  String startYear;
  String endYear;

  College({
    required this.degree,
    required this.department,
    required this.institution,
    required this.startYear,
    required this.endYear,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      degree: json['degree'] ?? '',
      department: json['department'] ?? '',
      institution: json['institution'] ?? '',
      startYear: json['start_year'] ?? '',
      endYear: json['end_year'] ?? '',
    );
  }
}

class Degree {
  String degree;

  Degree({required this.degree});

  factory Degree.fromJson(Map<String, dynamic> json) {
    return Degree(degree: json['degree'] ?? '');
  }
}

class Institution {
  String institution;

  Institution({required this.institution});

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(institution: json['institution'] ?? '');
  }
}
