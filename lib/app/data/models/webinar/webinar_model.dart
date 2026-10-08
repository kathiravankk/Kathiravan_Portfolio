class WebinarModel {
  bool? success;
  String? message;
  int? count;
  List<WebinarData>? data;
  PaginationData? pagination;

  WebinarModel({
    this.success,
    this.message,
    this.count,
    this.data,
    this.pagination,
  });

  WebinarModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? '';
    count = json['count'] ?? 0;
    if (json['data'] != null && json['data'] is List) {
      data = <WebinarData>[];
      for (var v in json['data']) {
        if (v is Map<String, dynamic>) {
          data!.add(WebinarData.fromJson(v));
        }
      }
    } else {
      data = [];
    }
    pagination = json['pagination'] != null
        ? PaginationData.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    map['count'] = count;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination!.toJson();
    }
    return map;
  }
}

class WebinarData {
  String? sId;
  String? title;
  String? shortDescription;
  String? fullDescription;
  String? bannerImage;
  CategoryData? category;
  String? webinarType;
  num? amount;
  String? language;
  SpeakerData? speaker;
  String? registrationStartDate;
  String? registrationEndDate;
  String? webinarDate;
  String? startTime;
  String? endTime;
  String? timezone;
  int? maximumSeats;
  dynamic joinBeforeMinutes;
  bool? allowRegistration;
  WebinarSettings? settings;
  String? status;
  int? registrationCount;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;
  WebinarPaymentData? payment;

  WebinarData({
    this.sId,
    this.title,
    this.shortDescription,
    this.fullDescription,
    this.bannerImage,
    this.category,
    this.webinarType,
    this.amount,
    this.language,
    this.speaker,
    this.registrationStartDate,
    this.registrationEndDate,
    this.webinarDate,
    this.startTime,
    this.endTime,
    this.timezone,
    this.maximumSeats,
    this.joinBeforeMinutes,
    this.allowRegistration,
    this.settings,
    this.status,
    this.registrationCount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.payment,
  });

  WebinarData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? json['id'];
    title = json['title'] ?? '';
    shortDescription = json['shortDescription'] ?? '';
    fullDescription = json['fullDescription'] ?? '';
    bannerImage = json['bannerImage'];
    if (json['category'] != null) {
      if (json['category'] is Map<String, dynamic>) {
        category = CategoryData.fromJson(json['category']);
      } else if (json['category'] is String) {
        category = CategoryData(name: json['category']);
      }
    }
    webinarType = json['webinarType'] ?? 'free';
    amount = json['amount'] != null ? (json['amount'] as num) : 0;
    language = json['language'] ?? 'english';
    speaker = json['speaker'] != null ? SpeakerData.fromJson(json['speaker']) : null;
    registrationStartDate = json['registrationStartDate'];
    registrationEndDate = json['registrationEndDate'];
    webinarDate = json['webinarDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    timezone = json['timezone'] ?? 'Asia/Kolkata';
    maximumSeats = json['maximumSeats'] != null ? (json['maximumSeats'] as num).toInt() : 0;
    joinBeforeMinutes = json['joinBeforeMinutes'];
    allowRegistration = json['allowRegistration'] ?? true;
    settings = json['settings'] != null ? WebinarSettings.fromJson(json['settings']) : null;
    status = json['status'] ?? '';
    registrationCount = json['registrationCount'] != null ? (json['registrationCount'] as num).toInt() : 0;
    isActive = json['isActive'] ?? true;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    payment = json['payment'] != null ? WebinarPaymentData.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = sId;
    map['title'] = title;
    map['shortDescription'] = shortDescription;
    map['fullDescription'] = fullDescription;
    map['bannerImage'] = bannerImage;
    if (category != null) {
      map['category'] = category!.toJson();
    }
    map['webinarType'] = webinarType;
    map['amount'] = amount;
    map['language'] = language;
    if (speaker != null) {
      map['speaker'] = speaker!.toJson();
    }
    map['registrationStartDate'] = registrationStartDate;
    map['registrationEndDate'] = registrationEndDate;
    map['webinarDate'] = webinarDate;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['timezone'] = timezone;
    map['maximumSeats'] = maximumSeats;
    map['joinBeforeMinutes'] = joinBeforeMinutes;
    map['allowRegistration'] = allowRegistration;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    map['status'] = status;
    map['registrationCount'] = registrationCount;
    map['isActive'] = isActive;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = iV;
    if (payment != null) {
      map['payment'] = payment!.toJson();
    }
    return map;
  }
}

class CategoryData {
  String? sId;
  String? name;

  CategoryData({this.sId, this.name});

  CategoryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = sId;
    map['name'] = name;
    return map;
  }
}

class SpeakerData {
  String? name;
  String? designation;
  String? company;
  String? profileImage;
  String? profileUrl;
  String? bio;
  String? email;

  SpeakerData({
    this.name,
    this.designation,
    this.company,
    this.profileImage,
    this.profileUrl,
    this.bio,
    this.email,
  });

  SpeakerData.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    designation = json['designation'] ?? '';
    company = json['company'] ?? '';
    profileImage = json['profileImage'];
    profileUrl = json['profileUrl'] ?? '';
    bio = json['bio'] ?? '';
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['name'] = name;
    map['designation'] = designation;
    map['company'] = company;
    map['profileImage'] = profileImage;
    map['profileUrl'] = profileUrl;
    map['bio'] = bio;
    map['email'] = email;
    return map;
  }
}

class WebinarSettings {
  bool? registrationRequired;
  bool? loginRequired;
  bool? duplicateRegistration;

  WebinarSettings({
    this.registrationRequired,
    this.loginRequired,
    this.duplicateRegistration,
  });

  WebinarSettings.fromJson(Map<String, dynamic> json) {
    registrationRequired = json['registrationRequired'] ?? true;
    loginRequired = json['loginRequired'] ?? true;
    duplicateRegistration = json['duplicateRegistration'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['registrationRequired'] = registrationRequired;
    map['loginRequired'] = loginRequired;
    map['duplicateRegistration'] = duplicateRegistration;
    return map;
  }
}

class WebinarPaymentData {
  bool? required;
  String? status;
  bool? isPaid;
  String? orderId;
  num? amount;
  String? currency;
  String? paidAt;

  WebinarPaymentData({
    this.required,
    this.status,
    this.isPaid,
    this.orderId,
    this.amount,
    this.currency,
    this.paidAt,
  });

  WebinarPaymentData.fromJson(Map<String, dynamic> json) {
    required = json['required'] ?? false;
    status = json['status'] ?? 'not_required';
    isPaid = json['isPaid'] ?? false;
    orderId = json['orderId'];
    amount = json['amount'] != null ? (json['amount'] as num) : 0;
    currency = json['currency'] ?? 'INR';
    paidAt = json['paidAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['required'] = required;
    map['status'] = status;
    map['isPaid'] = isPaid;
    map['orderId'] = orderId;
    map['amount'] = amount;
    map['currency'] = currency;
    map['paidAt'] = paidAt;
    return map;
  }
}

class PaginationData {
  int? current;
  int? pageSize;
  int? totalRecords;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPreviousPage;

  PaginationData({
    this.current,
    this.pageSize,
    this.totalRecords,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  PaginationData.fromJson(Map<String, dynamic> json) {
    current = json['current'] ?? 1;
    pageSize = json['pageSize'] ?? 10;
    totalRecords = json['totalRecords'] ?? 0;
    totalPages = json['totalPages'] ?? 1;
    hasNextPage = json['hasNextPage'] ?? false;
    hasPreviousPage = json['hasPreviousPage'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['current'] = current;
    map['pageSize'] = pageSize;
    map['totalRecords'] = totalRecords;
    map['totalPages'] = totalPages;
    map['hasNextPage'] = hasNextPage;
    map['hasPreviousPage'] = hasPreviousPage;
    return map;
  }
}
