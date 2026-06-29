import 'package:get/get.dart';
import 'package:internsharks/app/data/models/recruiter_flow/applicants_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';

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

  // GET APPLICANTS
  final _applicantsLoading = false.obs;
  bool get applicantsLoading => _applicantsLoading.value;
  set applicantsLoading(bool value) => _applicantsLoading.value = value;

  final _applicantsList = <ApplicantsModel>[].obs;
  List<ApplicantsModel> get applicantsList => _applicantsList;
  set applicantsList(List<ApplicantsModel> value) =>
      _applicantsList.assignAll(value);

  Future<void> getApplicants({required String jobId}) async {
    try {
      applicantsLoading = true;
      final result = await internshipPostProvider!.fetchApplicants(
        jobId: jobId,
      );
      applicantsList = result;
      applicantsLoading = false;
    } catch (err) {
      applicantsLoading = false;
      rethrow;
    }
  }

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
}
