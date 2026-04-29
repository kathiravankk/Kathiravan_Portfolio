import 'package:internsharks/app/data/models/account/update_profile_model.dart';

class ProfileUpdateModel {
  String? message;
  UpdateProfileDataModel? profileUpdateData;

  ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    profileUpdateData = json["student"] != null
        ? UpdateProfileDataModel.fromJson(json["student"])
        : null;
  }

  ProfileUpdateModel({this.profileUpdateData, this.message});
}

class TemplateRefreshModel {
  bool? success;
  UpdateProfileDataModel? studentProfileData;

  TemplateRefreshModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    studentProfileData = json["student"] != null
        ? UpdateProfileDataModel.fromJson(json["student"])
        : null;
  }

  TemplateRefreshModel({
    this.studentProfileData,
    this.success
});
}
