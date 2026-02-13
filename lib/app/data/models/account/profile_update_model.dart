import 'package:internsharks/app/data/models/account/student_profile_model.dart';

class ProfileUpdateModel {
  String? message;
  StudentProfileModel? profileUpdateData;

  ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    profileUpdateData = json["student"] != null
        ? StudentProfileModel.fromJson(json["student"])
        : null;
  }

  ProfileUpdateModel({this.profileUpdateData, this.message});
}
