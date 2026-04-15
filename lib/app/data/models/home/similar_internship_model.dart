import 'package:internsharks/app/data/models/home/recommand_internship_model.dart';

class SimilarInternshipModel {
  bool? success;
  List<String>? inputSkills;
  int? count;
  List<RecommentedData>? similarList;

  SimilarInternshipModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    inputSkills = json['inputSkills'] != null
        ? List<String>.from(json['inputSkills'])
        : <String>[];
    count = json["count"] ?? 0;
    if (json['jobs'] != null) {
      similarList = <RecommentedData>[];
      json['jobs'].forEach((v) {
        similarList!.add(RecommentedData.fromJson(v));
      });
    }
  }

  SimilarInternshipModel({
    this.similarList,
    this.count,
    this.inputSkills,
    this.success,
  });
}
