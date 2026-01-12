class CommonPostModel {
  String? message;
  String? userType;

  CommonPostModel({
    this.message,
    this.userType
});

  CommonPostModel.fromJson(Map<String, dynamic> json){
    message = json["message"] ?? "";
    userType = json["userType"] ?? "";
  }
}