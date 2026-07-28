class McqQuestionModel {
  List<QuestionDataModel>? page1;
  List<QuestionDataModel>? page2;
  List<QuestionDataModel>? page3;
  int? tokenUsage;
  int? timeDuration;

  McqQuestionModel({this.page1, this.page2, this.page3});

  McqQuestionModel.fromJson(Map<String, dynamic> json) {
    if (json['page1'] != null) {
      page1 = <QuestionDataModel>[];
      json['page1'].forEach((v) {
        page1!.add(QuestionDataModel.fromJson(v));
      });
    }

    if (json['page2'] != null) {
      page2 = <QuestionDataModel>[];
      json['page2'].forEach((v) {
        page2!.add(QuestionDataModel.fromJson(v));
      });
    }

    if (json['page3'] != null) {
      page3 = <QuestionDataModel>[];
      json['page3'].forEach((v) {
        page3!.add(QuestionDataModel.fromJson(v));
      });
    }
    tokenUsage = json['token_usage']??0;
    timeDuration = json['time_duration']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (page1 != null) {
      data['page1'] = page1!.map((v) => v.toJson()).toList();
    }

    if (page2 != null) {
      data['page2'] = page2!.map((v) => v.toJson()).toList();
    }

    if (page3 != null) {
      data['page3'] = page3!.map((v) => v.toJson()).toList();
    }
    data['token_usage'] = tokenUsage;
    data['time_duration'] = timeDuration;
    return data;
  }
}

class QuestionDataModel {
  String? question;
  OptionsModel? options;

  QuestionDataModel({this.question, this.options});

  QuestionDataModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    options =
    json['options'] != null ? OptionsModel.fromJson(json['options']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['question'] = question;

    if (options != null) {
      data['options'] = options!.toJson();
    }

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