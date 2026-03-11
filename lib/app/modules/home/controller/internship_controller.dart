import 'package:get/get.dart';
import 'package:internsharks/app/data/models/internship/internship_status_model.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';
import 'package:internsharks/app/data/models/internship/mcq_question_model.dart';
import 'package:internsharks/app/data/models/internship/syllabus_data_model.dart';
import 'package:internsharks/app/data/models/internship/weekly_update_model.dart';
import 'package:internsharks/app/data/providers/internship_provider.dart';

class InternshipController extends GetxController {
  final InternshipProvider? internshipProvider;

  InternshipController(this.internshipProvider);

  int getResponseCode() => internshipProvider!.responseStatus;

  // GET INTERNSHIP SYLLABUS DATA

  // Loading

  final _internSyllabusLoading = false.obs;

  bool get internSyllabusLoading => _internSyllabusLoading.value;

  set internSyllabusLoading(bool value) => _internSyllabusLoading.value = value;

  // Model

  final _internSyllabusModel = InternshipSyllabusModel().obs;

  InternshipSyllabusModel get internSyllabusModel => _internSyllabusModel.value;

  set internSyllabusModel(InternshipSyllabusModel value) =>
      _internSyllabusModel.value = value;

  Future<void> getInternshipSyllabus({required String studentId}) async {
    try {
      internSyllabusLoading = true;
      internSyllabusModel = await internshipProvider!.fetchInternshipSyllabus(
        studentId: studentId,
      );
      internSyllabusLoading = false;
    } catch (err) {
      internSyllabusLoading = false;
      rethrow;
    }
  }

  // GET SYLLABUS DETAILS DATA

  // Loading

  final _syllabusDataLoading = false.obs;

  bool get syllabusDataLoading => _syllabusDataLoading.value;

  set syllabusDataLoading(bool value) => _syllabusDataLoading.value = value;

  // Model

  final _syllabusModel = SyllabusDataModel().obs;

  SyllabusDataModel get syllabusModel => _syllabusModel.value;

  set syllabusModel(SyllabusDataModel value) => _syllabusModel.value = value;

  Future<void> getSyllabusData({required String jobId}) async {
    try {
      syllabusDataLoading = true;
      syllabusModel = await internshipProvider!.fetchSyllabusData(jobId: jobId);
      syllabusDataLoading = false;
    } catch (err) {
      syllabusDataLoading = false;
      rethrow;
    }
  }

  // GET INTERNSHIP STATUS

  // Loading

  final _internStatusLoading = false.obs;

  bool get internStatusLoading => _internStatusLoading.value;

  set internStatusLoading(bool value) => _internStatusLoading.value = value;

  // Model

  final _internStatusModel = InternshipStatusModel().obs;

  InternshipStatusModel get internStatusModel => _internStatusModel.value;

  set internStatusModel(InternshipStatusModel value) =>
      _internStatusModel.value = value;

  Future<void> getInternStatus({
    required String jobId,
    required String studentId,
  }) async {
    try {
      internStatusLoading = true;
      internStatusModel = await internshipProvider!.fetchInternStatus(
        jobId: jobId,
        studentId: studentId,
      );
      internStatusLoading = false;
    } catch (err) {
      internStatusLoading = false;
      rethrow;
    }
  }

  // UPDATE INTERNSHIP WEEKLY STATUS

  // Loading

  final _weeklyUpdateLoading = false.obs;

  bool get weeklyUpdateLoading => _weeklyUpdateLoading.value;

  set weeklyUpdateLoading(bool value) => _weeklyUpdateLoading.value = value;

  // Model

  final _weeklyUpdateModel = WeeklyUpdateModel().obs;

  WeeklyUpdateModel get weeklyUpdateModel => _weeklyUpdateModel.value;

  set weeklyUpdateModel(WeeklyUpdateModel value) =>
      _weeklyUpdateModel.value = value;

  Future<void> updateInternWeeklyStatus({
    required Map<String, dynamic> weeklyData,
  }) async {
    try {
      weeklyUpdateLoading = true;
      weeklyUpdateModel = await internshipProvider!.updateWeeklyInternStatus(
        weelyData: weeklyData,
      );
      weeklyUpdateLoading = false;
    } catch (err) {
      weeklyUpdateLoading = false;
      rethrow;
    }
  }

  // GET MCQ QUESTION

  // Loading

  final _getMcqQuestionLoading = false.obs;

  bool get getMcqQuestionLoading => _getMcqQuestionLoading.value;

  set getMcqQuestionLoading(bool value) => _getMcqQuestionLoading.value = value;

  // Model

  final _mcqQuesModel = McqQuestionModel().obs;

  McqQuestionModel get mcqQuesModel => _mcqQuesModel.value;

  set mcqQuesModel(McqQuestionModel value) =>
      _mcqQuesModel.value = value;

  Future<void> getMcqQuestions({
    required List<WeeklyData>? weekData,
  }) async {
    try {
      getMcqQuestionLoading = true;
      mcqQuesModel = await internshipProvider!.fetchMcqQuestions(
        weekData: weekData,
      );
      getMcqQuestionLoading = false;
    } catch (err) {
      getMcqQuestionLoading = false;
      rethrow;
    }
  }
}
