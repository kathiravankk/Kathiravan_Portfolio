import 'package:get/get.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';
import 'package:internsharks/app/data/models/internship/syllabus_data_model.dart';
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

  set syllabusModel(SyllabusDataModel value) =>
      _syllabusModel.value = value;

  Future<void> getSyllabusData({required String jobId}) async {
    try {
      syllabusDataLoading = true;
      syllabusModel = await internshipProvider!.fetchSyllabusData(
        jobId: jobId,
      );
      syllabusDataLoading = false;
    } catch (err) {
      syllabusDataLoading = false;
      rethrow;
    }
  }
}

