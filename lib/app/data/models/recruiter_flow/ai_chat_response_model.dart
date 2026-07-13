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
    this.option = const [],
    this.suggestionTopics = const [],
    this.multiselect,
    this.tokenUsage,
  });

  /// API key is "responce"
  final String? response;

  final List<String> option;

  final List<String> suggestionTopics;

  final bool? multiselect;

  final int? tokenUsage;

  factory AiChatData.fromJson(Map<String, dynamic> json) {
    return AiChatData(
      response: json["responce"],
      option: json["option"] == null
          ? []
          : List<String>.from(json["option"].map((x) => x.toString())),
      suggestionTopics: json["suggestion_topics"] == null
          ? []
          : List<String>.from(
        json["suggestion_topics"].map((x) => x.toString()),
      ),
      multiselect: json["multiselect"],
      tokenUsage: json["token_usage"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "responce": response,
      "option": option,
      "suggestion_topics": suggestionTopics,
      "multiselect": multiselect,
      "token_usage": tokenUsage,
    };
  }
}