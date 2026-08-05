class ChatMcqQuestionModel {
  String? validationId;
  String? topicLabel;
  List<ChatQuizQuestion>? questions;

  ChatMcqQuestionModel({
    this.validationId,
    this.topicLabel,
    this.questions,
  });

  ChatMcqQuestionModel.fromJson(Map<String, dynamic> json) {
    validationId = json['validation_id'];
    topicLabel = json['topic_label'];

    if (json['questions'] != null) {
      questions = <ChatQuizQuestion>[];
      json['questions'].forEach((v) {
        questions!.add(ChatQuizQuestion.fromJson(v));
      });
    } else {
      questions = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['validation_id'] = validationId;
    data['topic_label'] = topicLabel;

    data['questions'] = questions != null
        ? questions!.map((e) => e.toJson()).toList()
        : [];

    return data;
  }
}

class ChatQuizQuestion {
  String? skill;
  List<QuizItem>? questions;

  ChatQuizQuestion({
    this.skill,
    this.questions,
  });

  ChatQuizQuestion.fromJson(Map<String, dynamic> json) {
    skill = json['skill'];

    if (json['questions'] != null) {
      questions = <QuizItem>[];
      json['questions'].forEach((v) {
        questions!.add(QuizItem.fromJson(v));
      });
    } else {
      questions = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['skill'] = skill;
    data['questions'] = questions != null
        ? questions!.map((e) => e.toJson()).toList()
        : [];

    return data;
  }
}

class QuizItem {
  String? question;
  QuestionOptions? options;

  QuizItem({
    this.question,
    this.options,
  });

  QuizItem.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    options = json['options'] != null
        ? QuestionOptions.fromJson(json['options'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['question'] = question;
    data['options'] = options?.toJson();

    return data;
  }
}

class QuestionOptions {
  String? a;
  String? b;
  String? c;
  String? d;

  QuestionOptions({
    this.a,
    this.b,
    this.c,
    this.d,
  });

  QuestionOptions.fromJson(Map<String, dynamic> json) {
    a = json['A'];
    b = json['B'];
    c = json['C'];
    d = json['D'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['A'] = a;
    data['B'] = b;
    data['C'] = c;
    data['D'] = d;

    return data;
  }
}