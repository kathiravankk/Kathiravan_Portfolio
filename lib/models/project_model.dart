class Project {
  String title;
  String description;

  Project({
    required this.title,
    required this.description,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
