// class CommonPostModel {
//   String? message;
//   String? userType;
//
//   CommonPostModel({
//     this.message,
//     this.userType
// });
//
//   CommonPostModel.fromJson(Map<String, dynamic> json){
//     message = json["message"] ?? "";
//     userType = json["userType"] ?? "";
//   }
// }
class CommonPostModel {
  bool? success;
  String? message;
  String? userType;

  CommonPostModel({
    this.success,
    this.message,
    this.userType,
  });

  CommonPostModel.fromJson(Map<String, dynamic> json) {
    success = json["success"] ?? false;
    message = json["message"] ?? "";
    userType = json["userType"] ?? "";
  }
}
