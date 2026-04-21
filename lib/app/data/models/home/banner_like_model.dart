class BannerLikeModel {
  bool? success;
  String? message;
  LikeActivityData? activityData;

  BannerLikeModel({this.success, this.message, this.activityData});

  BannerLikeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    activityData = json['data'] != null ? LikeActivityData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['success'] = success;
    dataMap['message'] = message;
    if (activityData != null) {
      dataMap['data'] = activityData!.toJson();
    }
    return dataMap;
  }
}

class LikeActivityData {
  String? id;
  String? studentId;
  List<TemplateData>? templates;
  bool? enhance;
  bool? resDb;
  String? createdAt;
  String? updatedAt;
  int? v;

  LikeActivityData({
    this.id,
    this.studentId,
    this.templates,
    this.enhance,
    this.resDb,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  LikeActivityData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    studentId = json['studentId'];
    enhance = json['enhance'];
    resDb = json['resdb'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];

    if (json['templates'] != null) {
      templates = (json['templates'] as List)
          .map((e) => TemplateData.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['_id'] = id;
    dataMap['studentId'] = studentId;
    dataMap['enhance'] = enhance;
    dataMap['resdb'] = resDb;
    dataMap['createdAt'] = createdAt;
    dataMap['updatedAt'] = updatedAt;
    dataMap['__v'] = v;

    if (templates != null) {
      dataMap['templates'] = templates!.map((e) => e.toJson()).toList();
    }

    return dataMap;
  }
}

class TemplateData {
  int? templateId;
  bool? isLiked;

  TemplateData({this.templateId, this.isLiked});

  TemplateData.fromJson(Map<String, dynamic> json) {
    templateId = json['templateId'];
    isLiked = json['liked'];
  }

  Map<String, dynamic> toJson() {
    return {
      'templateId': templateId,
      'liked': isLiked,
    };
  }
}