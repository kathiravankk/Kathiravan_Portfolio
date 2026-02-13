class Experience {
  String? company;
  String? role;
  String? duration;
  dynamic description;

  Experience({
     this.company,
     this.role,
     this.duration,
     this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'] ?? '',
      role: json['role'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'] ??"",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "company": company,
      "role": role,
      "duration": duration,
      "description": description,
    };
  }
}
