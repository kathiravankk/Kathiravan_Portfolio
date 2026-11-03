class RecruiterProfileModel {
  bool? success;
  RecruiterProfileData? recruiterData;
  List<RecruiterReviewItem>? reviews;

  RecruiterProfileModel({this.recruiterData, this.success, this.reviews});

  RecruiterProfileModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    recruiterData = json['data'] != null
        ? RecruiterProfileData.fromJson(json['data'])
        : null;

    if (json['reviews'] != null && json['reviews'] is List) {
      reviews = (json['reviews'] as List)
          .map((v) => RecruiterReviewItem.fromJson(
              v is Map<String, dynamic> ? v : Map<String, dynamic>.from(v)))
          .toList();
    } else if (json['data'] != null &&
        json['data']['reviews'] != null &&
        json['data']['reviews'] is List) {
      reviews = (json['data']['reviews'] as List)
          .map((v) => RecruiterReviewItem.fromJson(
              v is Map<String, dynamic> ? v : Map<String, dynamic>.from(v)))
          .toList();
    } else if (recruiterData?.reviews != null) {
      reviews = recruiterData!.reviews;
    }
  }
}

class RecruiterProfileData {
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
  String? subscriptionId;
  List<RecruiterReviewItem>? reviews;

  RecruiterProfileData({
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
    this.subscriptionId,
    this.reviews,
  });

  RecruiterProfileData.fromJson(Map<String, dynamic> json) {
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

    subscriptionId = json['subscriptionId'] != null
        ? (json['subscriptionId'] is Map
            ? (json['subscriptionId']['_id'] ?? json['subscriptionId']['id'])
                ?.toString()
            : json['subscriptionId'].toString())
        : null;

    isActive = json['isActive'] ?? false;
    deletedAt = json['deletedAt'] ?? "";
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    vId = json['__v'] ?? 0;

    if (json['reviews'] != null && json['reviews'] is List) {
      reviews = (json['reviews'] as List)
          .map((v) => RecruiterReviewItem.fromJson(
              v is Map<String, dynamic> ? v : Map<String, dynamic>.from(v)))
          .toList();
    }
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
  int? freeCredits;
  int? v;

  RecruiterCredit({
    this.id,
    this.balance,
    this.totalUsed,
    this.v,
    this.freeCredits,
  });

  RecruiterCredit.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    balance = json['balance'];
    totalUsed = json['totalUsed'];
    freeCredits = json['freeCredits'] ?? 0;
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'freeCredits': freeCredits,
      'balance': balance,
      'totalUsed': totalUsed,
      '__v': v,
    };
  }
}

class RecruiterReviewItem {
  final String? id;
  final String? review;
  final dynamic rating;
  final String? studentId;
  final String? studentName;
  final String? studentEmail;
  final String? studentProfile;
  final String? jobRole;
  final String? companyName;
  final String? createdAt;
  final String? updatedAt;

  RecruiterReviewItem({
    this.id,
    this.review,
    this.rating,
    this.studentId,
    this.studentName,
    this.studentEmail,
    this.studentProfile,
    this.jobRole,
    this.companyName,
    this.createdAt,
    this.updatedAt,
  });

  factory RecruiterReviewItem.fromJson(Map<String, dynamic> json) {
    final student = json['student'] is Map
        ? Map<String, dynamic>.from(json['student'])
        : null;
    final job = json['job'] is Map
        ? Map<String, dynamic>.from(json['job'])
        : null;

    return RecruiterReviewItem(
      id: (json['_id'] ?? json['id'])?.toString(),
      review: (json['review'] ?? json['feedback'] ?? json['comment'])?.toString(),
      rating: json['rating'],
      studentId: (student != null
              ? (student['_id'] ?? student['id'])
              : json['studentId'])
          ?.toString(),
      studentName: (student != null
              ? (student['studname'] ?? student['name'] ?? student['studentName'])
              : json['studentName'])
          ?.toString(),
      studentEmail: (student != null
              ? (student['studemail'] ?? student['email'])
              : json['studentEmail'])
          ?.toString(),
      studentProfile: (student != null
              ? (student['studprofile'] ??
                  student['profile'] ??
                  student['studentProfile'])
              : json['studentProfile'])
          ?.toString(),
      jobRole: (job != null
              ? (job['roletype'] ?? job['title'] ?? job['role'])
              : json['jobRole'])
          ?.toString(),
      companyName: (job != null
              ? (job['companyname'] ?? job['companyName'])
              : json['companyName'])
          ?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}
