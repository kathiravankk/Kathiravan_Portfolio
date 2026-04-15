class TestResultModel {
  bool? success;
  TestResultData? testResult;

  TestResultModel({this.success, this.testResult});

  TestResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    testResult = json['testresult'] != null
        ? TestResultData.fromJson(json['testresult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (testResult != null) {
      data['testresult'] = testResult!.toJson();
    }
    return data;
  }
}

class TestResultData {
  List<AnswerData>? correctAnswer;
  String? score;
  String? stars;

  TestResultData({this.correctAnswer, this.score, this.stars});

  TestResultData.fromJson(Map<String, dynamic> json) {
    if (json['correct answer'] != null) {
      correctAnswer = <AnswerData>[];
      json['correct answer'].forEach((v) {
        correctAnswer!.add(AnswerData.fromJson(v));
      });
    }
    score = json['score'];
    stars = json['stars'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (correctAnswer != null) {
      data['correct answer'] =
          correctAnswer!.map((v) => v.toJson()).toList();
    }

    data['score'] = score;
    data['stars'] = stars;

    return data;
  }
}

class AnswerData {
  String? question;
  OptionsModel? options;
  String? answer;
  String? correctAnswer;
  String? selectAnswer;

  AnswerData({
    this.question,
    this.options,
    this.answer,
    this.correctAnswer,
    this.selectAnswer,
  });

  AnswerData.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    options =
    json['options'] != null ? OptionsModel.fromJson(json['options']) : null;
    answer = json['answer'];
    correctAnswer = json['correct_answer'];
    selectAnswer = json['select_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['question'] = question;
    if (options != null) {
      data['options'] = options!.toJson();
    }
    data['answer'] = answer;
    data['correct_answer'] = correctAnswer;
    data['select_answer'] = selectAnswer;

    return data;
  }
}

class OptionsModel {
  String? a;
  String? b;
  String? c;
  String? d;

  OptionsModel({this.a, this.b, this.c, this.d});

  OptionsModel.fromJson(Map<String, dynamic> json) {
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