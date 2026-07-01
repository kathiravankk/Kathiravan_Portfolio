import 'package:get/get.dart';
import 'package:internsharks/app/data/models/recruiter_flow/applicants_list_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_student_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/new_internship_data_model.dart';

import '../../../../data/providers/recruiter_flow/internship_post_provider.dart';

class InternshipPostController extends GetxController {
  final InternshipPostProvider? internshipPostProvider;

  InternshipPostController(this.internshipPostProvider);

  int getResponseCode() => internshipPostProvider!.responseStatus;

  // GET RECRUITER PROFILE

  final _internPostLoading = false.obs;

  bool get internPostLoading => _internPostLoading.value;

  set internPostLoading(bool value) => _internPostLoading.value = value;

  // Model

  final _internPostModel = InternshipPostModel().obs;

  InternshipPostModel get internPostModel => _internPostModel.value;

  set internPostModel(InternshipPostModel value) =>
      _internPostModel.value = value;


  Future<void> getPostedInternships({required String recruiterId}) async {
    try {
      internPostLoading = true;
      internPostModel = await internshipPostProvider!.fetchPostedInternships(
        recruiterId: recruiterId,
      );
      internPostLoading = false;
    } catch (err) {
      internPostLoading = false;
      rethrow;
    }
  }

  // GET APPLICANTS

  final _applicantsLoading = false.obs;
  bool get applicantsLoading => _applicantsLoading.value;
  set applicantsLoading(bool value) => _applicantsLoading.value = value;

  // Model

  final _applicantsModel = ApplicantsListModel().obs;

  ApplicantsListModel get applicantsModel => _applicantsModel.value;

  set applicantsModel(ApplicantsListModel value) =>
      _applicantsModel.value = value;

  Future<void> getApplicants({required String jobId}) async {
    try {
      applicantsLoading = true;
      applicantsModel = await internshipPostProvider!.fetchApplicants(
        jobId: jobId,
      );
      applicantsLoading = false;
    } catch (err) {
      applicantsLoading = false;
      rethrow;
    }
  }

  // GET INTERNS PROFILE DATA

  final _studentProfileLoading = false.obs;
  bool get studentProfileLoading => _studentProfileLoading.value;
  set studentProfileLoading(bool value) => _studentProfileLoading.value = value;

  // Model

  final _internStudentProfileModel = InternStudentProfileModel().obs;

  InternStudentProfileModel get internStudentProfileModel => _internStudentProfileModel.value;

  set internStudentProfileModel(InternStudentProfileModel value) =>
      _internStudentProfileModel.value = value;

  Future<void> getInternStudentProfile({required String jobId, required String studentId}) async {
    try {
      studentProfileLoading = true;
      internStudentProfileModel = await internshipPostProvider!.fetchInternStudentProfile(
        jobId: jobId,
        studentId: studentId
      );
      studentProfileLoading = false;
    } catch (err) {
      studentProfileLoading = false;
      rethrow;
    }
  }

  //  CREATE NEW INTERNSHIP

  final _createInternshipLoading = false.obs;

  bool get createInternshipLoading => _createInternshipLoading.value;

  set createInternshipLoading(bool value) =>
      _createInternshipLoading.value = value;

  // Model

  final _createInternshipModel = NewInternshipDataModel().obs;

  NewInternshipDataModel get createInternshipModel => _createInternshipModel.value;

  set createInternshipModel(NewInternshipDataModel value) =>
      _createInternshipModel.value = value;


  Future<void> createNewInternship({required Map<String, dynamic>internshipData}) async {
    try {
      createInternshipLoading = true;
      createInternshipModel = await internshipPostProvider!
          .createNewInternship(internshipData: internshipData);
    } catch (err) {
      rethrow;
    } finally {
      createInternshipLoading = false;
    }
  }

  //  UPDATE NEW INTERNSHIP

  final _updateInternshipLoading = false.obs;

  bool get updateInternshipLoading => _updateInternshipLoading.value;

  set updateInternshipLoading(bool value) =>
      _updateInternshipLoading.value = value;

  Future<void> updateNewInternship({required Map<String, dynamic>internshipData, required String jobId}) async {
    try {
      updateInternshipLoading = true;
      createInternshipModel = await internshipPostProvider!
          .updateNewInternship(internshipData: internshipData, jobId: jobId);
    } catch (err) {
      rethrow;
    } finally {
      updateInternshipLoading = false;
    }
  }
}
