import 'package:internsharks/app/data/models/account/chat_mcq_question_model.dart';

class ChatMcqResultModel {
  int? score;
  int? total;
  bool? verified;
  List<String>? correctIndices;
  String? completed;
  List<QuizValidation>? questions;

  ChatMcqResultModel({
    this.score,
    this.total,
    this.verified,
    this.correctIndices,
    this.completed,
    this.questions,
  });

  ChatMcqResultModel.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    total = json['total'];
    verified = json['verified'];
    correctIndices = json['correct_indices'] != null
        ? List<String>.from(json['correct_indices'])
        : <String>[];
    completed = json['completed'];

    if (json['questions'] != null) {
      questions = <QuizValidation>[];
      json['questions'].forEach((v) {
        questions!.add(QuizValidation.fromJson(v));
      });
    } else {
      questions = <QuizValidation>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['score'] = score;
    data['total'] = total;
    data['verified'] = verified;
    data['correct_indices'] = correctIndices ?? [];
    data['completed'] = completed;
    data['questions'] =
        questions?.map((e) => e.toJson()).toList() ?? [];

    return data;
  }
}

class QuizValidation {
  String? skill;
  bool? verified;
  List<ValidationQuestion>? questions;

  QuizValidation({
    this.skill,
    this.verified,
    this.questions,
  });

  QuizValidation.fromJson(Map<String, dynamic> json) {
    skill = json['skill'];
    verified = json['verified'];

    if (json['questions'] != null) {
      questions = <ValidationQuestion>[];
      json['questions'].forEach((v) {
        questions!.add(ValidationQuestion.fromJson(v));
      });
    } else {
      questions = <ValidationQuestion>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['skill'] = skill;
    data['verified'] = verified;
    data['questions'] =
        questions?.map((e) => e.toJson()).toList() ?? [];

    return data;
  }
}

class ValidationQuestion {
  String? question;
  QuestionOptions? options;
  String? answer;
  String? correctAnswer;
  String? selectAnswer;

  ValidationQuestion({
    this.question,
    this.options,
    this.answer,
    this.correctAnswer,
    this.selectAnswer,
  });

  ValidationQuestion.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    options = json['options'] != null
        ? QuestionOptions.fromJson(json['options'])
        : null;
    answer = json['answer'];
    correctAnswer = json['correct_answer'];
    selectAnswer = json['select_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['question'] = question;
    data['options'] = options?.toJson();
    data['answer'] = answer;
    data['correct_answer'] = correctAnswer;
    data['select_answer'] = selectAnswer;

    return data;
  }
}

// class QuestionOptions {
//   String? a;
//   String? b;
//   String? c;
//   String? d;
//
//   QuestionOptions({
//     this.a,
//     this.b,
//     this.c,
//     this.d,
//   });
//
//   QuestionOptions.fromJson(Map<String, dynamic> json) {
//     a = json['A'];
//     b = json['B'];
//     c = json['C'];
//     d = json['D'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//
//     data['A'] = a;
//     data['B'] = b;
//     data['C'] = c;
//     data['D'] = d;
//
//     return data;
//   }
// }