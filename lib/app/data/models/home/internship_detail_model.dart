import 'package:internsharks/app/data/models/home/category_wise_internship_model.dart';

class InternshipDetailModel {
  String? message;
  InternshipData? internshipData;

  InternshipDetailModel({this.message, this.internshipData});

  factory InternshipDetailModel.fromJson(Map<String, dynamic> json) {
    return InternshipDetailModel(
      message: json["message"] ?? "",
      internshipData: json["job"] != null
          ? InternshipData.fromJson(json["job"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "job": internshipData?.toJson(),
    };
  }
}