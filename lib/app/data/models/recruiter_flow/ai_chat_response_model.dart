import 'package:internsharks/app/data/models/recruiter_flow/syllabus_generate_model.dart';

class AiChatResponseModel {
  AiChatResponseModel({
    this.success,
    this.aiResponse,
  });

  final bool? success;
  final AiChatData? aiResponse;

  factory AiChatResponseModel.fromJson(Map<String, dynamic> json) {
    return AiChatResponseModel(
      success: json["success"],
      aiResponse: json["aiResponse"] == null
          ? null
          : AiChatData.fromJson(json["aiResponse"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "aiResponse": aiResponse?.toJson(),
    };
  }
}

class AiChatData {
  AiChatData({
    this.response,
    this.status,
    this.finalData,
    this.option = const [],
    this.suggestionTopics = const [],
    this.multiselect = false,
    this.tokenUsage = 0,
  });

  /// API key is "responce"
  final String? response;

  /// completed / success / etc.
  final String? status;

  /// Final syllabus when chat is completed
  final SyllabusGenerateModel? finalData;

  /// Options
  final List<String> option;

  /// Suggested topics
  final List<String> suggestionTopics;

  /// Multiple selection allowed
  final bool multiselect;

  /// AI token usage
  final int tokenUsage;

  factory AiChatData.fromJson(Map<String, dynamic> json) {
    return AiChatData(
      response: json["responce"]?.toString(),

      status: json["status"]?.toString(),

      finalData: json["final_data"] == null
          ? null
          : SyllabusGenerateModel.fromJson(json["final_data"]),

      option: (json["option"] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],

      suggestionTopics: (json["suggestion_topics"] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],

      multiselect: json["multiselect"] ?? false,

      tokenUsage: json["token_usage"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "responce": response,
      "status": status,
      "final_data": finalData?.toJson(),
      "option": option,
      "suggestion_topics": suggestionTopics,
      "multiselect": multiselect,
      "token_usage": tokenUsage,
    };
  }

  /// Helper getters
  bool get hasOptions => option.isNotEmpty;

  bool get hasSuggestionTopics => suggestionTopics.isNotEmpty;

  bool get hasFinalData => finalData != null;

  bool get isCompleted => status == "completed";

  bool get isMultiSelect => multiselect;
}