class NotificationModel {
  final String? id;
  final String? studentId;
  final String? title;
  final String? message;
  final String? senderType;
  final bool? isRead;
  final String? createdAt;
  final String? updatedAt;

  NotificationModel({
    this.id,
    this.studentId,
    this.title,
    this.message,
    this.senderType,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id']?.toString(),
      studentId: json['studentId']?.toString(),
      title: json['title']?.toString(),
      message: json['message']?.toString(),
      senderType: json['senderType']?.toString(),
      isRead: json['isRead'] as bool?,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studentId': studentId,
      'title': title,
      'message': message,
      'senderType': senderType,
      'isRead': isRead,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class NotificationListModel {
  final bool? success;
  final List<NotificationModel>? data;

  NotificationListModel({this.success, this.data});

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    return NotificationListModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
