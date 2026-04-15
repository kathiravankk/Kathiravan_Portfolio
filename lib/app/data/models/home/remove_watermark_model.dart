class RemoveWatermarkModel {
  final bool? success;
  final String? message;
  final WatermarkRemovedData? watermarkData;

  RemoveWatermarkModel({this.success, this.message, this.watermarkData});

  factory RemoveWatermarkModel.fromJson(Map<String, dynamic> json) {
    return RemoveWatermarkModel(
      success: json['success']??false,
      message: json['message']??"",
      watermarkData: json['data'] != null
          ? WatermarkRemovedData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': watermarkData?.toJson()};
  }
}

class WatermarkRemovedData {
  final String? status;
  final String? imageUrl;

  WatermarkRemovedData({this.status, this.imageUrl});

  factory WatermarkRemovedData.fromJson(Map<String, dynamic> json) {
    return WatermarkRemovedData(
      status: json['status']??false,
      imageUrl: json['image_url']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'image_url': imageUrl};
  }
}
