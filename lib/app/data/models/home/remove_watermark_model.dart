class RemoveWatermarkModel {
  String? status;
  String? imageUrl;

  RemoveWatermarkModel.fromJson(Map<String, dynamic> json) {
    status = json["status"] ?? "";
    imageUrl = json["image_url"] ?? "";
  }

  RemoveWatermarkModel({this.imageUrl, this.status});
}
