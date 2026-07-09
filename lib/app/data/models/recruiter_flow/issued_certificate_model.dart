class IssuedCertificateModel {
  IssuedCertificateModel({
    this.success,
    this.data,
  });

  final bool? success;
  final InternCertificateData? data;

  factory IssuedCertificateModel.fromJson(Map<String, dynamic> json) {
    return IssuedCertificateModel(
      success: json["success"],
      data: json["data"] == null
          ? null
          : InternCertificateData.fromJson(json["data"]),
    );
  }
}

class InternCertificateData {
  InternCertificateData({
    this.id,
    this.student,
    this.recruiter,
    this.job,
    this.certificate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? student;
  final String? recruiter;
  final String? job;
  final String? certificate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory InternCertificateData.fromJson(Map<String, dynamic> json) {
    return InternCertificateData(
      id: json["_id"],
      student: json["student"],
      recruiter: json["recruiter"],
      job: json["job"],
      certificate: json["certificate"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "student": student,
      "recruiter": recruiter,
      "job": job,
      "certificate": certificate,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "__v": v,
    };
  }
}

extension CertificateResponseModelToJson on IssuedCertificateModel {
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.toJson(),
    };
  }
}