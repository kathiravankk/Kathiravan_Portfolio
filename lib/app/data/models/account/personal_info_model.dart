class PersonalInfoModel {
  String name;
  dynamic gender;
  String email;
  String phone;
  String location;
  dynamic linkedIn;
  dynamic github;

  PersonalInfoModel({
    required this.name,
    required this.gender,
    required this.email,
    required this.phone,
    required this.linkedIn,
    required this.github,
    required this.location
  });

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return PersonalInfoModel(
      name: json['name'] ?? '',
      gender: json['gender'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      linkedIn: json['linkedIn'],
      github: json['github'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name ?? "",
      "gender": gender ?? "",
      "email": email ?? "",
      "phone": phone ?? "",
      "linkedIn": linkedIn ?? "",
      "github": github ?? "",
      "location": location ?? "",
    };
  }
}
