import 'package:internsharks/app/data/models/internship/test_result_model.dart';

class SaveTestResultModel {
  String? success;
  String? message;
  TestResultData? result;

  SaveTestResultModel({this.success, this.message, this.result});

  SaveTestResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    result =
    json['result'] != null ? TestResultData.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class TestResultData {
  String? student;
  String? job;
  TestResultModel? testResult;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  TestResultData({
    this.student,
    this.job,
    this.testResult,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  TestResultData.fromJson(Map<String, dynamic> json) {
    student = json['student'];
    job = json['job'];
    testResult = json['testresult'] != null
        ? TestResultModel.fromJson(json['testresult'])
        : null;
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['student'] = student;
    data['job'] = job;
    if (testResult != null) {
      data['testresult'] = testResult!.toJson();
    }
    data['_id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
