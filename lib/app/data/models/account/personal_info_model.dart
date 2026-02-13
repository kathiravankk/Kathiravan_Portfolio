class PersonalInfo {
  String name;
  dynamic gender;
  String email;
  String phone;
  dynamic linkedIn;
  dynamic github;

  PersonalInfo({
    required this.name,
    required this.gender,
    required this.email,
    required this.phone,
    required this.linkedIn,
    required this.github,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] ?? '',
      gender: json['gender'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      linkedIn: json['linkedin'],
      github: json['github'],
    );
  }
}
