class BannerGenerationModel {
  bool? success;
  String? error;
  BannerStatus? status;

  BannerGenerationModel({this.success, this.status});

  BannerGenerationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'] != null
        ? BannerStatus.fromJson(json['status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class BannerStatus {
  String? taskId;
  String? status;
  String? imageUrl;
  String? code;
  String? message;

  BannerStatus({
    this.taskId,
    this.status,
    this.imageUrl,
    this.code,
    this.message,
  });

  BannerStatus.fromJson(Map<String, dynamic> json) {
    taskId = json['task-id'] ?? "";
    status = json['status'] ?? "";
    imageUrl = json['image_url'] ?? "";
    code = json['code'] ?? "";
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['task-id'] = taskId;
    data['status'] = status;
    data['image_url'] = imageUrl;
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
