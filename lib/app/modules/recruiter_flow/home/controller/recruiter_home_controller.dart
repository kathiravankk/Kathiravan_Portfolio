import 'package:get/get.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/student_list_model.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_home_provider.dart';

class RecruiterHomeController extends GetxController {
  final RecruiterHomeProvider? recruiterHomeProvider;

  RecruiterHomeController(this.recruiterHomeProvider);

  int getResponseCode() => recruiterHomeProvider!.responseStatus;

  // GET RECRUITER PROFILE

  final _profileLoading = false.obs;

  bool get profileLoading => _profileLoading.value;

  set profileLoading(bool value) => _profileLoading.value = value;

  // Model

  final _profileModel = RecruiterProfileModel().obs;

  RecruiterProfileModel get profileModel => _profileModel.value;

  set profileModel(RecruiterProfileModel value) => _profileModel.value = value;

  Future<void> getRecruiterProfileData({required String recruiterId}) async {
    try {
      profileLoading = true;
      profileModel = await recruiterHomeProvider!.fetchRecruiterProfile(
        recruiterId: recruiterId,
      );
      profileLoading = false;
    } catch (err) {
      profileLoading = false;
      rethrow;
    }
  }

  // GET ALL STUDENTS LIST

  final _studentListLoading = false.obs;

  bool get studentListLoading => _studentListLoading.value;

  set studentListLoading(bool value) => _studentListLoading.value = value;

  // Model

  final _studentListModel = StudentListModel().obs;

  StudentListModel get studentListModel => _studentListModel.value;

  set studentListModel(StudentListModel value) =>
      _studentListModel.value = value;

  Future<void> getAllStudentsList() async {
    try {
      studentListLoading = true;
      studentListModel =
      await recruiterHomeProvider!.fetchStudentListData();
    } catch (err) {
      rethrow;
    } finally {
      studentListLoading = false;
    }
  }
}
