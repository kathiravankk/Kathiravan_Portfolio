import 'package:get/get.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/add_shortlist-students_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/shortlisted_students_data_model.dart';
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
      studentListModel = await recruiterHomeProvider!.fetchStudentListData();
    } catch (err) {
      rethrow;
    } finally {
      studentListLoading = false;
    }
  }

  // ADD TO SHORTLISTED STUDENTS

  final _addShortlistLoading = false.obs;

  bool get addShortlistLoading => _addShortlistLoading.value;

  set addShortlistLoading(bool value) => _addShortlistLoading.value = value;

  // Model

  final _addShortlistModel = AddShortlistStudentModel().obs;

  AddShortlistStudentModel get addShortlistModel => _addShortlistModel.value;

  set addShortlistModel(AddShortlistStudentModel value) =>
      _addShortlistModel.value = value;

  Future<bool> addToShortlistStudent({required String studentId}) async {
    try {
      addShortlistLoading = true;

      addShortlistModel = await recruiterHomeProvider!.addToShortlistStudent(
        studentId: studentId,
      );

      return getResponseCode() == 200 || getResponseCode() == 201;
    } catch (_) {
      return false;
    } finally {
      addShortlistLoading = false;
    }
  }

  // ADD TO SHORTLISTED STUDENTS

  final _removeShortlistLoading = false.obs;

  bool get removeShortlistLoading => _removeShortlistLoading.value;

  set removeShortlistLoading(bool value) =>
      _removeShortlistLoading.value = value;

  // Model

  final _commonPostModel = CommonLoginOtpModel().obs;

  CommonLoginOtpModel get commonPostModel => _commonPostModel.value;

  set commonPostModel(CommonLoginOtpModel value) =>
      _commonPostModel.value = value;

  Future<bool> removeShortlistStudent({required String studentId}) async {
    try {
      removeShortlistLoading = true;

      commonPostModel = await recruiterHomeProvider!.deleteShortlistStudent(
        studentId: studentId,
      );

      return getResponseCode() == 200 || getResponseCode() == 201;
    } catch (_) {
      return false;
    } finally {
      removeShortlistLoading = false;
    }
  }

  Future<void> shortlistToggleFunc(StudentDetails student) async {
    final oldValue = student.isFavorite;

    student.isFavorite = !oldValue!;

    bool success;

    if (!oldValue) {
      success = await addToShortlistStudent(studentId: student.id!);
    } else {
      success = await removeShortlistStudent(studentId: student.id!);
    }

    if (!success) {
      student.isFavorite = oldValue;
    }

    update();
  }

  // GET ALL SHORTLISTED STUDENTS LIST

  final _shortlistStudentLoading = false.obs;

  bool get shortlistStudentLoading => _shortlistStudentLoading.value;

  set shortlistStudentLoading(bool value) => _shortlistStudentLoading.value = value;

  // Model

  final _shortlistModel = ShortlistedStudentDataModel().obs;

  ShortlistedStudentDataModel get shortlistModel => _shortlistModel.value;

  set shortlistModel(ShortlistedStudentDataModel value) =>
      _shortlistModel.value = value;

  Future<void> getShortlistStudentsList() async {
    try {
      shortlistStudentLoading = true;
      shortlistModel = await recruiterHomeProvider!.fetchShortlistStudentsList();
    } catch (err) {
      rethrow;
    } finally {
      shortlistStudentLoading = false;
    }
  }
}
