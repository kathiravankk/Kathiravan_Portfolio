class Experience {
  String company;
  String role;
  String duration;
  dynamic description;

  Experience({
    required this.company,
    required this.role,
    required this.duration,
    required this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'] ?? '',
      role: json['role'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'],
    );
  }
}
