class CertificateGenerateModel {
  CertificateGenerateModel({
    this.success,
    this.message,
    this.certificate,
    this.data,
  });

  final bool? success;
  final String? message;
  final CertificateGenerateData? certificate;
  final CertificateInfoData? data;

  factory CertificateGenerateModel.fromJson(
      Map<String, dynamic> json) {
    return CertificateGenerateModel(
      success: json["success"]??false,
      message: json["message"]??"",
      certificate: json["certificate"] == null
          ? null
          : CertificateGenerateData.fromJson(json["certificate"]),
      data: json["data"] == null
          ? null
          : CertificateInfoData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "certificate": certificate?.toJson(),
      "data": data?.toJson(),
    };
  }
}

class CertificateGenerateData {
  CertificateGenerateData({
    this.message,
    this.url,
    this.startDate,
    this.endDate,
    this.issuedDate,
    this.duration,
  });

  final String? message;
  final String? url;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? issuedDate;
  final String? duration;

  factory CertificateGenerateData.fromJson(Map<String, dynamic> json) {
    return CertificateGenerateData(
      message: json["message"]??"",
      url: json["url"]??"",
      startDate: json["start_date"] == null
          ? null
          : DateTime.tryParse(json["start_date"]),
      endDate: json["end_date"] == null
          ? null
          : DateTime.tryParse(json["end_date"]),
      issuedDate: json["issued_date"]??"",
      duration: json["duration"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "url": url,
      "start_date": startDate?.toIso8601String(),
      "end_date": endDate?.toIso8601String(),
      "issued_date": issuedDate,
      "duration": duration,
    };
  }
}

class CertificateInfoData {
  CertificateInfoData({
    this.studentId,
    this.job,
    this.jobType,
    this.paymentStatus,
  });

  final String? studentId;
  final String? job;
  final String? jobType;
  final String? paymentStatus;

  factory CertificateInfoData.fromJson(Map<String, dynamic> json) {
    return CertificateInfoData(
      studentId: json["studentId"]??"",
      job: json["job"]??"",
      jobType: json["jobType"]??"",
      paymentStatus: json["paymentStatus"]??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "studentId": studentId,
      "job": job,
      "jobType": jobType,
      "paymentStatus": paymentStatus,
    };
  }
}