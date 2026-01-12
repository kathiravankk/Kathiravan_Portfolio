class Certification {
  String name;
  String? issuer;
  dynamic date;
  String? type;

  Certification({
    required this.name,
    required this.issuer,
    required this.date,
    required this.type,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      name: json['name'] ?? '',
      issuer: json['issuer'],
      date: json['date'],
      type: json['type'],
    );
  }
}
