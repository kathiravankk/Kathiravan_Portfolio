class RecruiterNotificationModel {
  final String? id;
  final String? recruiterId;
  final String? title;
  final String? message;
  final String? senderType;
  final bool? isRead;
  final String? createdAt;
  final String? updatedAt;

  RecruiterNotificationModel({
    this.id,
    this.recruiterId,
    this.title,
    this.message,
    this.senderType,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory RecruiterNotificationModel.fromJson(Map<String, dynamic> json) {
    return RecruiterNotificationModel(
      id: json['_id']?.toString(),
      recruiterId: json['recruiterId']?.toString(),
      title: json['title']?.toString(),
      message: json['message']?.toString(),
      senderType: json['senderType']?.toString(),
      isRead: json['isRead'] as bool?,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

class RecruiterNotificationListModel {
  final bool? success;
  final String? message;
  final List<RecruiterNotificationModel>? data;

  RecruiterNotificationListModel({this.success, this.message, this.data});

  factory RecruiterNotificationListModel.fromJson(Map<String, dynamic> json) {
    return RecruiterNotificationListModel(
      success: json['success'] as bool?,
      message: json['message']?.toString(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RecruiterNotificationModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );
  }
}
