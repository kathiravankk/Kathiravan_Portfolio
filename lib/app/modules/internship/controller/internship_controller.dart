import 'package:get/get.dart';
import 'package:internsharks/app/data/models/internship/add_review_data_model.dart';
import 'package:internsharks/app/data/models/internship/intern_syllabus_response_model.dart';
import 'package:internsharks/app/data/models/internship/internship_status_model.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';
import 'package:internsharks/app/data/models/internship/mcq_question_model.dart';
import 'package:internsharks/app/data/models/internship/payment_create_model.dart';
import 'package:internsharks/app/data/models/internship/payment_status_model.dart';
import 'package:internsharks/app/data/models/internship/save_test_result_model.dart';
import 'package:internsharks/app/data/models/internship/syllabus_data_model.dart';
import 'package:internsharks/app/data/models/internship/test_result_model.dart';
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

  final _syllabusModel = InternSyllabusResponseModel().obs;

  InternSyllabusResponseModel get syllabusModel => _syllabusModel.value;

  set syllabusModel(InternSyllabusResponseModel value) => _syllabusModel.value = value;

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

  Future<void> updateInternDailyStatus({
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
    required List<dynamic>? weekData,
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

  // VALIDATE MCQ TEST

  // Loading

  final _validateMcqAnswerLoading = false.obs;

  bool get validateMcqAnswerLoading => _validateMcqAnswerLoading.value;

  set validateMcqAnswerLoading(bool value) => _validateMcqAnswerLoading.value = value;

  // Model

  final _testResultModel = TestResultModel().obs;

  TestResultModel get testResultModel => _testResultModel.value;

  set testResultModel(TestResultModel value) =>
      _testResultModel.value = value;

  Future<void> validateMcqAnswer({
    required Map<String, dynamic> answerData,
  }) async {
    try {
      validateMcqAnswerLoading = true;
      testResultModel = await internshipProvider!.validateMcqAnswer(
        answerData: answerData,
      );
      validateMcqAnswerLoading = false;
    } catch (err) {
      validateMcqAnswerLoading = false;
      rethrow;
    }
  }

  // GIVE FEEDBACK REVIEW

  // Loading

  final _feedBackLoading = false.obs;

  bool get feedBackLoading => _feedBackLoading.value;

  set feedBackLoading(bool value) => _feedBackLoading.value = value;

  //Model

  final _reviewModel = AddReviewDataModel().obs;

  AddReviewDataModel get reviewModel => _reviewModel.value;

  set reviewModel(AddReviewDataModel value) => _reviewModel.value = value;

  Future<void> giveFeedBackReview({required Map<String, dynamic> feedBackData}) async {
    try {
      feedBackLoading = true;
      reviewModel = await internshipProvider!.giveFeedBackReview(feedBackData: feedBackData);
      feedBackLoading = false;
    } catch (err) {
      feedBackLoading = false;
      rethrow;
    }
  }

  // SAVE TEST RESULT

  // Loading

  final _saveTestLoading = false.obs;

  bool get saveTestLoading => _saveTestLoading.value;

  set saveTestLoading(bool value) => _saveTestLoading.value = value;

  //Model

  final _saveTestModel = SaveTestResultModel().obs;

  SaveTestResultModel get saveTestModel => _saveTestModel.value;

  set saveTestModel(SaveTestResultModel value) => _saveTestModel.value = value;

  Future<void> saveTestResult({required Map<String, dynamic> testData}) async {
    try {
      saveTestLoading = true;
      saveTestModel = await internshipProvider!.saveTestResult(testData: testData);
      saveTestLoading = false;
    } catch (err) {
      saveTestLoading = false;
      rethrow;
    }
  }

  // CHECK PAYMENT STATUS

  // Loading

  final _paymentStatusCheckLoading = false.obs;

  bool get paymentStatusCheckLoading => _paymentStatusCheckLoading.value;

  set paymentStatusCheckLoading(bool value) => _paymentStatusCheckLoading.value = value;

  //Model

  final _paymentStatusModel = PaymentStatusModel().obs;

  PaymentStatusModel get paymentStatusModel => _paymentStatusModel.value;

  set paymentStatusModel(PaymentStatusModel value) => _paymentStatusModel.value = value;

  Future<void> checkPaymentStatus({required Map<String, dynamic> jobData}) async {
    try {
      paymentStatusCheckLoading = true;
      paymentStatusModel = await internshipProvider!.checkPaymentStatus(jobData : jobData);
      paymentStatusCheckLoading = false;
    } catch (err) {
      paymentStatusCheckLoading = false;
      rethrow;
    }
  }

  // CREATE PAYMENT ORDER

  // Loading

  final _paymentCreateLoading = false.obs;

  bool get paymentCreateLoading => _paymentCreateLoading.value;

  set paymentCreateLoading(bool value) => _paymentCreateLoading.value = value;

  //Model

  final _paymentCreateModel = PaymentCreateModel().obs;

  PaymentCreateModel get paymentCreateModel => _paymentCreateModel.value;

  set paymentCreateModel(PaymentCreateModel value) => _paymentCreateModel.value = value;

  Future<void> createPaymentOrder({required Map<String, dynamic> jobData}) async {
    try {
      paymentCreateLoading = true;
      paymentCreateModel = await internshipProvider!.createPaymentOrder(jobData : jobData);
      paymentCreateLoading = false;
    } catch (err) {
      paymentCreateLoading = false;
      rethrow;
    }
  }

  // VERIFY PAYMENT ORDER

  // Loading

  final _paymentVerifyLoading = false.obs;

  bool get paymentVerifyLoading => _paymentVerifyLoading.value;

  set paymentVerifyLoading(bool value) => _paymentVerifyLoading.value = value;


  Future<void> verifyPaymentOrder({required Map<String, dynamic> jobData}) async {
    try {
      paymentCreateLoading = true;
      paymentCreateModel = await internshipProvider!.verifyPaymentOrder(jobData : jobData);
      paymentCreateLoading = false;
    } catch (err) {
      paymentCreateLoading = false;
      rethrow;
    }
  }


}
