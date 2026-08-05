class RecruiterLoginModel {
  String? message;
  bool? success;
  Recruiter? recruiter;
  String? recToken;

  RecruiterLoginModel({
    this.success,
    this.message,
    this.recruiter,
    this.recToken,
  });

  factory RecruiterLoginModel.fromJson(Map<String, dynamic> json) {
    return RecruiterLoginModel(
      success: json["success"],
      message: json["message"],
      recruiter: json["recruiter"] != null
          ? Recruiter.fromJson(json["recruiter"])
          : null,
      recToken: json["rectoken"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "recruiter": recruiter?.toJson(),
      "rectoken": recToken,
    };
  }
}

class Recruiter {
  String? coordinatorId;

  /// Old API
  String? id;

  /// New API
  RecruiterCompany? recruiterInfo;

  String? recruiterName;
  String? recruiterMobileNo;
  String? recruiterCreditId;

  Recruiter({
    this.coordinatorId,
    this.id,
    this.recruiterInfo,
    this.recruiterName,
    this.recruiterMobileNo,
    this.recruiterCreditId,
  });

  factory Recruiter.fromJson(Map<String, dynamic> json) {
    return Recruiter(
      coordinatorId: json["coordinatorid"],
      recruiterName: json["recname"],
      recruiterMobileNo: json["recmobileno"],
      recruiterCreditId: json["recruiterCreditId"],

      // Supports both old and new API
      id: json["id"] is String ? json["id"] : null,

      recruiterInfo: json["id"] is Map<String, dynamic>
          ? RecruiterCompany.fromJson(json["id"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "coordinatorid": coordinatorId,
      "id": recruiterInfo?.toJson() ?? id,
      "recname": recruiterName,
      "recmobileno": recruiterMobileNo,
      "recruiterCreditId": recruiterCreditId,
    };
  }
}
class RecruiterCompany {
  String? id;
  String? recname;
  String? recgender;
  String? recemail;
  String? recmobileno;
  String? recsecondarymobileno;
  String? recdesignation;
  String? reccompanyname;
  String? reccompanywebsite;
  String? reccompanysize;
  String? reccompanyaddress;
  String? reccompanypincode;
  String? reccompanyemail;
  String? reccompanyindustrytype;
  String? reccompanydocumenttype;
  String? reccompanydescription;
  String? reccompanycontactno;
  String? reccompanydocument;
  String? reccompanylogo;
  String? recruiterCreditId;
  List<String>? fcmTokens;
  String? referralCode;
  String? referredBy;
  bool? isActive;
  String? deletedAt;
  dynamic deletedBy;
  String? createdAt;
  String? updatedAt;
  int? v;

  RecruiterCompany({
    this.id,
    this.recname,
    this.recgender,
    this.recemail,
    this.recmobileno,
    this.recsecondarymobileno,
    this.recdesignation,
    this.reccompanyname,
    this.reccompanywebsite,
    this.reccompanysize,
    this.reccompanyaddress,
    this.reccompanypincode,
    this.reccompanyemail,
    this.reccompanyindustrytype,
    this.reccompanydocumenttype,
    this.reccompanydescription,
    this.reccompanycontactno,
    this.reccompanydocument,
    this.reccompanylogo,
    this.recruiterCreditId,
    this.fcmTokens,
    this.referralCode,
    this.referredBy,
    this.isActive,
    this.deletedAt,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory RecruiterCompany.fromJson(Map<String, dynamic> json) {
    return RecruiterCompany(
      id: json["_id"],
      recname: json["recname"],
      recgender: json["recgender"],
      recemail: json["recemail"],
      recmobileno: json["recmobileno"],
      recsecondarymobileno: json["recsecondarymobileno"],
      recdesignation: json["recdesignation"],
      reccompanyname: json["reccompanyname"],
      reccompanywebsite: json["reccompanywebsite"],
      reccompanysize: json["reccompanysize"],
      reccompanyaddress: json["reccompanyaddress"],
      reccompanypincode: json["reccompanypincode"],
      reccompanyemail: json["reccompanyemail"],
      reccompanyindustrytype: json["reccompanyindustrytype"],
      reccompanydocumenttype: json["reccompanydocumenttype"],
      reccompanydescription: json["reccompanydescription"],
      reccompanycontactno: json["reccompanycontactno"],
      reccompanydocument: json["reccompanydocument"],
      reccompanylogo: json["reccompanylogo"],
      recruiterCreditId: json["recruiterCreditId"],
      fcmTokens: (json["fcmTokens"] as List?)
          ?.map((e) => e.toString())
          .toList(),
      referralCode: json["referralCode"],
      referredBy: json["referredBy"],
      isActive: json["isActive"],
      deletedAt: json["deletedAt"],
      deletedBy: json["deletedBy"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "recname": recname,
      "recgender": recgender,
      "recemail": recemail,
      "recmobileno": recmobileno,
      "recsecondarymobileno": recsecondarymobileno,
      "recdesignation": recdesignation,
      "reccompanyname": reccompanyname,
      "reccompanywebsite": reccompanywebsite,
      "reccompanysize": reccompanysize,
      "reccompanyaddress": reccompanyaddress,
      "reccompanypincode": reccompanypincode,
      "reccompanyemail": reccompanyemail,
      "reccompanyindustrytype": reccompanyindustrytype,
      "reccompanydocumenttype": reccompanydocumenttype,
      "reccompanydescription": reccompanydescription,
      "reccompanycontactno": reccompanycontactno,
      "reccompanydocument": reccompanydocument,
      "reccompanylogo": reccompanylogo,
      "recruiterCreditId": recruiterCreditId,
      "fcmTokens": fcmTokens,
      "referralCode": referralCode,
      "referredBy": referredBy,
      "isActive": isActive,
      "deletedAt": deletedAt,
      "deletedBy": deletedBy,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}