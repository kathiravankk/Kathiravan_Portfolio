class PersonalInfoModel {
  String name;
  String? sureName;
  dynamic gender;
  String email;
  String phone;
  String? role;
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
    required this.location,
    this.sureName,
    this.role,
  });

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return PersonalInfoModel(
      name: json['name'] ?? '',
      gender: json['gender']??"",
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      linkedIn: json['linkedIn']??"",
      github: json['github']??"",
      location: json['location']??"",
      sureName: json['surname']??"",
      role: json['role']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "gender": gender ?? "",
      "email": email,
      "phone": phone,
      "linkedIn": linkedIn ?? "",
      "github": github ?? "",
      "location": location,
      "surname": sureName,
      "role": role,
    };
  }
}
