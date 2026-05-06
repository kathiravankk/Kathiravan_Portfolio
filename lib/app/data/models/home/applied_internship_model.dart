import 'package:internsharks/app/data/models/home/recommand_internship_model.dart';

class AppliedInternshipModel {
  String? message;
  int? count;
  List<ApplicationData>? applicationList;

  AppliedInternshipModel({
    this.message,
    this.count,
    this.applicationList,
  });

  factory AppliedInternshipModel.fromJson(Map<String, dynamic> json) {
    return AppliedInternshipModel(
      message: json["message"] ?? "",
      count: json["count"] ?? 0,
      applicationList: json['applications'] != null
          ? List<ApplicationData>.from(
        json['applications'].map((x) => ApplicationData.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "count": count,
      "applications":
      applicationList?.map((x) => x.toJson()).toList() ?? [],
    };
  }
}

class ApplicationData {
  String? id;
  String? status;
  RecommentedData? jobData;

  // NEW FIELDS
  bool? hasFee;
  bool? hasStipend;
  bool? isFree;
  String? jobType;

  ApplicationData({
    this.id,
    this.status,
    this.jobData,
    this.hasFee,
    this.hasStipend,
    this.isFree,
    this.jobType,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    return ApplicationData(
      id: json["id"] ?? "", // ✅ FIXED (was _id)
      status: json["status"] ?? "",
      jobData: json['job'] != null
          ? RecommentedData.fromJson(json['job'])
          : null,
      hasFee: json["hasFee"] ?? false,
      hasStipend: json["hasStipend"] ?? false,
      isFree: json["isFree"] ?? false,
      jobType: json["jobType"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "job": jobData?.toJson(),
      "hasFee": hasFee,
      "hasStipend": hasStipend,
      "isFree": isFree,
      "jobType": jobType,
    };
  }
}