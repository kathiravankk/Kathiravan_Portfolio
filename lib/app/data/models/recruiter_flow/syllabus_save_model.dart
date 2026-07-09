class SyllabusSaveModel {
  SyllabusSaveModel({
     this.success,
     this.message,
     this.id,
  });

  final bool? success;
  final String? message;
  final String? id;

  factory SyllabusSaveModel.fromJson(Map<String, dynamic> json){
    return SyllabusSaveModel(
      success: json["success"],
      message: json["message"],
      id: json["id"],
    );
  }

}
