import 'package:internsharks/app/data/models/account/student_profile_model.dart';
import 'package:internsharks/app/data/models/home/profile_information_model.dart';

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

class TemplateRefreshModel {
  bool? success;
  ProfileDataModel? studentProfileData;

  TemplateRefreshModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    studentProfileData = json["student"] != null
        ? ProfileDataModel.fromJson(json["student"])
        : null;
  }

  TemplateRefreshModel({
    this.studentProfileData,
    this.success
});
}
