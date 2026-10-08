import 'package:internsharks/app/data/models/webinar/webinar_model.dart';
export 'package:internsharks/app/data/models/webinar/webinar_model.dart'
    show SpeakerData, CategoryData, WebinarPaymentData;

class WebinarDetailModel {
  bool? success;
  String? message;
  WebinarDetailData? data;

  WebinarDetailModel({
    this.success,
    this.message,
    this.data,
  });

  WebinarDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? '';
    data = json['data'] != null && json['data'] is Map<String, dynamic>
        ? WebinarDetailData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class WebinarDetailData {
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
  String? status;
  int? registrationCount;
  int? availableSeats;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;
  WebinarPaymentData? payment;
  WebinarRegistrationInfo? registration;
  WebinarJoinInfo? join;
  bool? isMobileVerified;
  List<SimilarWebinarData>? similarWebinars;

  WebinarDetailData({
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
    this.status,
    this.registrationCount,
    this.availableSeats,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.payment,
    this.registration,
    this.join,
    this.isMobileVerified,
    this.similarWebinars,
  });

  WebinarDetailData.fromJson(Map<String, dynamic> json) {
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
    status = json['status'] ?? '';
    registrationCount = json['registrationCount'] != null ? (json['registrationCount'] as num).toInt() : 0;
    availableSeats = json['availableSeats'] != null
        ? (json['availableSeats'] as num).toInt()
        : ((maximumSeats ?? 0) - (registrationCount ?? 0)).clamp(0, 999999);
    isActive = json['isActive'] ?? true;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    payment = json['payment'] != null ? WebinarPaymentData.fromJson(json['payment']) : null;
    registration = json['registration'] != null ? WebinarRegistrationInfo.fromJson(json['registration']) : null;
    join = json['join'] != null ? WebinarJoinInfo.fromJson(json['join']) : null;
    isMobileVerified = json['isMobileVerified'] ?? false;
    if (json['similarWebinars'] != null && json['similarWebinars'] is List) {
      similarWebinars = <SimilarWebinarData>[];
      for (var v in json['similarWebinars']) {
        if (v is Map<String, dynamic>) {
          similarWebinars!.add(SimilarWebinarData.fromJson(v));
        }
      }
    } else {
      similarWebinars = [];
    }
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
    map['status'] = status;
    map['registrationCount'] = registrationCount;
    map['availableSeats'] = availableSeats;
    map['isActive'] = isActive;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = iV;
    if (payment != null) {
      map['payment'] = payment!.toJson();
    }
    if (registration != null) {
      map['registration'] = registration!.toJson();
    }
    if (join != null) {
      map['join'] = join!.toJson();
    }
    map['isMobileVerified'] = isMobileVerified;
    if (similarWebinars != null) {
      map['similarWebinars'] = similarWebinars!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class WebinarRegistrationInfo {
  bool? isRegistered;
  String? status;
  String? registeredAt;
  String? checkInTime;
  String? checkOutTime;
  int? watchDuration;

  WebinarRegistrationInfo({
    this.isRegistered,
    this.status,
    this.registeredAt,
    this.checkInTime,
    this.checkOutTime,
    this.watchDuration,
  });

  WebinarRegistrationInfo.fromJson(Map<String, dynamic> json) {
    isRegistered = json['isRegistered'] ?? false;
    status = json['status'];
    registeredAt = json['registeredAt'];
    checkInTime = json['checkInTime'];
    checkOutTime = json['checkOutTime'];
    watchDuration = json['watchDuration'] != null ? (json['watchDuration'] as num).toInt() : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['isRegistered'] = isRegistered;
    map['status'] = status;
    map['registeredAt'] = registeredAt;
    map['checkInTime'] = checkInTime;
    map['checkOutTime'] = checkOutTime;
    map['watchDuration'] = watchDuration;
    return map;
  }
}

class WebinarJoinInfo {
  bool? canJoin;
  bool? joinTimeReached;
  String? joinAt;
  dynamic joinBeforeMinutes;
  bool? mobileVerificationRequired;
  String? message;

  WebinarJoinInfo({
    this.canJoin,
    this.joinTimeReached,
    this.joinAt,
    this.joinBeforeMinutes,
    this.mobileVerificationRequired,
    this.message,
  });

  WebinarJoinInfo.fromJson(Map<String, dynamic> json) {
    canJoin = json['canJoin'] ?? false;
    joinTimeReached = json['joinTimeReached'] ?? false;
    joinAt = json['joinAt'];
    joinBeforeMinutes = json['joinBeforeMinutes'];
    mobileVerificationRequired = json['mobileVerificationRequired'] ?? false;
    message = json['message'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['canJoin'] = canJoin;
    map['joinTimeReached'] = joinTimeReached;
    map['joinAt'] = joinAt;
    map['joinBeforeMinutes'] = joinBeforeMinutes;
    map['mobileVerificationRequired'] = mobileVerificationRequired;
    map['message'] = message;
    return map;
  }
}

class SimilarWebinarData {
  String? sId;
  String? id;
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
  String? status;
  int? registrationCount;
  int? availableSeats;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  SimilarWebinarData({
    this.sId,
    this.id,
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
    this.status,
    this.registrationCount,
    this.availableSeats,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  SimilarWebinarData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? json['id'];
    id = json['id'] ?? json['_id'];
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
    status = json['status'] ?? '';
    registrationCount = json['registrationCount'] != null ? (json['registrationCount'] as num).toInt() : 0;
    availableSeats = json['availableSeats'] != null
        ? (json['availableSeats'] as num).toInt()
        : ((maximumSeats ?? 0) - (registrationCount ?? 0)).clamp(0, 999999);
    isActive = json['isActive'] ?? true;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = sId;
    map['id'] = id;
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
    map['status'] = status;
    map['registrationCount'] = registrationCount;
    map['availableSeats'] = availableSeats;
    map['isActive'] = isActive;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}
