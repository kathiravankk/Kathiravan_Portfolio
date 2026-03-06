import 'package:get/get.dart';
import 'package:internsharks/app/data/models/internship/internship_syllabus_model.dart';
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

  final _syllabusModel = InternshipSyllabusModel().obs;

  InternshipSyllabusModel get syllabusModel => _syllabusModel.value;

  set syllabusModel(InternshipSyllabusModel value) =>
      _syllabusModel.value = value;

  Future<void> getInternshipSyllabus({required String studentId}) async {
    try {
      internSyllabusLoading = true;
      syllabusModel = await internshipProvider!.fetchInternshipSyllabus(
        studentId: studentId,
      );
      internSyllabusLoading = false;
    } catch (err) {
      internSyllabusLoading = false;
      rethrow;
    }
  }
}

