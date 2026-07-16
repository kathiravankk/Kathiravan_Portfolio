class SyllabusChatResponseModel {
  SyllabusChatResponseModel({
    this.success,
    this.syllabus,
  });

  final bool? success;
  final SyllabusOptionData? syllabus;

  factory SyllabusChatResponseModel.fromJson(Map<String, dynamic> json) {
    return SyllabusChatResponseModel(
      success: json["success"],
      syllabus: json["syllabus"] == null
          ? null
          : SyllabusOptionData.fromJson(json["syllabus"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "syllabus": syllabus?.toJson(),
    };
  }
}

class SyllabusOptionData {
  SyllabusOptionData({
    this.status,
    this.message,
    this.userId,
    this.response,
    this.option,
    this.multiselect,
  });

  final String? status;
  final String? message;
  final String? userId;
  final String? response;
  final List<String>? option;
  final bool? multiselect;

  factory SyllabusOptionData.fromJson(Map<String, dynamic> json) {
    return SyllabusOptionData(
      status: json["status"],
      message: json["message"],
      userId: json["user_id"],
      response: json["responce"], // API key is "responce"
      option: json["option"] == null
          ? []
          : List<String>.from(json["option"].map((x) => x)),
      multiselect: json["multiselect"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "user_id": userId,
      "responce": response,
      "option": option ?? [],
      "multiselect": multiselect,
    };
  }
}