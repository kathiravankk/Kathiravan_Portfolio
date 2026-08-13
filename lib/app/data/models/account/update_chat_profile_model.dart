import 'package:internsharks/app/data/models/account/new_student_profile_model.dart';

class UpdateChatProfileModel {
  String? message;
  NewStudentProfileModel? profileUpdateData;

  UpdateChatProfileModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    profileUpdateData = json["student"] != null
        ? NewStudentProfileModel.fromJson(json["student"])
        : null;
  }

  UpdateChatProfileModel({this.profileUpdateData, this.message});
}