class RecruiterProfileModel {
  String? id;
  String? recName;
  String? recGender;
  String? recEmail;
  String? recMobileNo;
  String? recSecondaryMobileNo;
  String? recDesignation;
  String? recCompanyName;
  String? recCompanyWebsite;
  String? recCompanySize;
  String? recCompanyAddress;
  String? recCompanyPinCode;
  String? recCompanyEmail;
  IndustryType? recCompanyIndustryType;
  String? recCompanyDocumentType;
  String? recCompanyDescription;
  String? recCompanyContactNo;
  dynamic recCompanyDocument;
  String? recCompanyLogo;
  RecruiterCredit? recruiterCreditId;
  List<dynamic>? fcmTokens;
  bool? isActive;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? referCode;
  int? vId;

  RecruiterProfileModel({
    this.id,
    this.recName,
    this.recGender,
    this.recEmail,
    this.recMobileNo,
    this.recSecondaryMobileNo,
    this.recDesignation,
    this.recCompanyName,
    this.recCompanyWebsite,
    this.recCompanySize,
    this.recCompanyAddress,
    this.recCompanyPinCode,
    this.recCompanyEmail,
    this.recCompanyIndustryType,
    this.recCompanyDocumentType,
    this.recCompanyDescription,
    this.recCompanyContactNo,
    this.recCompanyDocument,
    this.recCompanyLogo,
    this.recruiterCreditId,
    this.fcmTokens,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.vId,
    this.referCode,
  });

  RecruiterProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? "";
    recName = json['recname'] ?? "";
    referCode = json['referralCode'] ?? "";
    recGender = json['recgender'] ?? "";
    recEmail = json['recemail'] ?? "";
    recMobileNo = json['recmobileno'] ?? "";
    recSecondaryMobileNo = json['recsecondarymobileno'] ?? "";
    recDesignation = json['recdesignation'] ?? "";
    recCompanyName = json['reccompanyname'] ?? "";
    recCompanyWebsite = json['reccompanywebsite'] ?? "";
    recCompanySize = json['reccompanysize'] ?? "";
    recCompanyAddress = json['reccompanyaddress'] ?? "";
    recCompanyPinCode = json['reccompanypincode'] ?? "";
    recCompanyEmail = json['reccompanyemail'] ?? "";

    recCompanyIndustryType = json['reccompanyindustrytype'] != null
        ? IndustryType.fromJson(json['reccompanyindustrytype'])
        : null;

    recCompanyDocumentType = json['reccompanydocumenttype'] ?? "";
    recCompanyDescription = json['reccompanydescription'] ?? "";
    recCompanyContactNo = json['reccompanycontactno'] ?? "";
    recCompanyDocument = json['reccompanydocument'];
    recCompanyLogo = json['reccompanylogo'] ?? "";

    recruiterCreditId = json['recruiterCreditId'] != null
        ? RecruiterCredit.fromJson(json['recruiterCreditId'])
        : null;

    fcmTokens = json['fcmTokens'] != null
        ? List<dynamic>.from(json['fcmTokens'])
        : [];

    isActive = json['isActive'] ?? false;
    deletedAt = json['deletedAt'] ?? "";
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    vId = json['__v'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recname': recName,
      'referralCode': referCode,
      'recgender': recGender,
      'recemail': recEmail,
      'recmobileno': recMobileNo,
      'recsecondarymobileno': recSecondaryMobileNo,
      'recdesignation': recDesignation,
      'reccompanyname': recCompanyName,
      'reccompanywebsite': recCompanyWebsite,
      'reccompanysize': recCompanySize,
      'reccompanyaddress': recCompanyAddress,
      'reccompanypincode': recCompanyPinCode,
      'reccompanyemail': recCompanyEmail,
      'reccompanyindustrytype': recCompanyIndustryType?.toJson(),
      'reccompanydocumenttype': recCompanyDocumentType,
      'reccompanydescription': recCompanyDescription,
      'reccompanycontactno': recCompanyContactNo,
      'reccompanydocument': recCompanyDocument,
      'reccompanylogo': recCompanyLogo,
      'recruiterCreditId': recruiterCreditId?.toJson(),
      'fcmTokens': fcmTokens,
      'isActive': isActive,
      'deletedAt': deletedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': vId,
    };
  }
}

class IndustryType {
  String? id;
  String? name;

  IndustryType({this.id, this.name});

  IndustryType.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

class RecruiterCredit {
  String? id;
  int? balance;
  int? totalUsed;
  int? v;

  RecruiterCredit({this.id, this.balance, this.totalUsed, this.v});

  RecruiterCredit.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    balance = json['balance'];
    totalUsed = json['totalUsed'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'balance': balance, 'totalUsed': totalUsed, '__v': v};
  }
}
