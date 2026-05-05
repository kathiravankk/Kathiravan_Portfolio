class AllCertificationsModel {
  final bool? success;
  final int? count;
  final List<CertificateListData>? certificatesList;

  AllCertificationsModel({
    this.success,
    this.count,
    this.certificatesList,
  });

  factory AllCertificationsModel.fromJson(Map<String, dynamic> json) {
    return AllCertificationsModel(
      success: json['success'],
      count: json['count'],
      certificatesList: json['data'] != null
          ? List<CertificateListData>.from(
        json['data'].map((x) => CertificateListData.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': certificatesList?.map((x) => x.toJson()).toList(),
    };
  }
}

class CertificateListData {
  final String? id;
  final String? student;
  final String? recruiter;
  final String? job;
  final String? certificate;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  CertificateListData({
    this.id,
    this.student,
    this.recruiter,
    this.job,
    this.certificate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CertificateListData.fromJson(Map<String, dynamic> json) {
    return CertificateListData(
      id: json['_id'],
      student: json['student'],
      recruiter: json['recruiter'],
      job: json['job'],
      certificate: json['certificate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'student': student,
      'recruiter': recruiter,
      'job': job,
      'certificate': certificate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}