import 'package:internsharks/app/data/models/home/category_wise_internship_model.dart';

class InternshipDetailModel {
  String? message;
  InternshipData? internshipData;

  InternshipDetailModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    internshipData = json["job"] != null
        ? InternshipData.fromJson(json["job"])
        : null;
  }

  InternshipDetailModel({this.internshipData, this.message});
}
