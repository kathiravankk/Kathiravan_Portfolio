import 'package:internsharks/app/data/models/account/create_resume_model.dart';

class UpdateChatModel {
  final bool? success;
  final AtsResult? atsResult;

  UpdateChatModel({this.success, this.atsResult});

  factory UpdateChatModel.fromJson(Map<String, dynamic> json) {
    return UpdateChatModel(
      success: json['success'],
      atsResult: json['atsResult'] != null
          ? AtsResult.fromJson(json['atsResult'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, "atsResult": atsResult?.toJson()};
  }
}

class AtsResult {
  final String? status;
  final String? message;
  final String? userId;
  final String? response;
  final List<String>? option;
  final bool? multiSelect;
  final ReplyData? collectedData;


  AtsResult({
    this.status,
    this.message,
    this.userId,
    this.response,
    this.option,
    this.multiSelect,
    this.collectedData
  });

  factory AtsResult.fromJson(Map<String, dynamic> json) {
    return AtsResult(
      status: json['status'] ?? "",
      message: json['message'] ?? "",
      userId: json['user_id'] ?? "",
      response: json['responce'] ?? "",
      option: json['option'] != null ? List<String>.from(json['option']) : [],
      multiSelect: json['multiselect'] ?? false,
      collectedData: json['final_data'] != null
          ? ReplyData.fromJson(json['final_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "user_id": userId,
      "responce": response,
      "option": option,
      "multiselect": multiSelect,
      "collected_data": collectedData,
    };
  }
}

class UpdateChatResumeModel {
  final dynamic success;
  final AiResponse? aiResponse;

  UpdateChatResumeModel({this.success, this.aiResponse});

  factory UpdateChatResumeModel.fromJson(Map<String, dynamic> json) {
    return UpdateChatResumeModel(
      success: json['success'] ?? "",
      aiResponse: json['atsResult'] != null
          ? AiResponse.fromJson(json['atsResult'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, "atsResult": aiResponse?.toJson()};
  }
}

class AiResponse {
  final String? response;
  final String? status;
  final List<String>? option;
  final ReplyData? collectedData;
  final ReplyData? finalData;

  AiResponse({this.response, this.option, this.status, this.collectedData, this.finalData});

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      response: json['responce'] ?? "",
      status: json['status'] ?? "",
      option: json['option'] != null ? List<String>.from(json['option']) : [],
      collectedData: json['collected_data'] != null
          ? ReplyData.fromJson(json['collected_data'])
          : null,
      finalData: json['final_data'] != null
          ? ReplyData.fromJson(json['final_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "responce": response,
      "option": option,
      "status": status,
      "collected_data": collectedData,
      "final_data": finalData,
    };
  }
}
