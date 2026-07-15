import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/home/credit_order_verify_model.dart';
import 'package:internsharks/app/data/models/home/order_create_credit_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/add_shortlist-students_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/certificate_generate_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_credits_plan_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_transaction_history_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/shortlisted_students_data_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/student_list_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/syllabus_view_data_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/syllabus_generate_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/syllabus_save_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_test_result_model.dart';
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

  final RxList<StudentDetails> allStudents = <StudentDetails>[].obs;

  // --- Filtered Data (This is what the UI will listen to) ---
  final RxList<StudentDetails> filteredStudents = <StudentDetails>[].obs;

  // --- Search State ---
  final RxString searchQuery = "".obs;
  final TextEditingController searchController = TextEditingController();

  // --- Dynamic Filter Dropdown Options ---
  final RxList<String> degreesList = <String>[].obs;
  final RxList<String> collegesList = <String>[].obs;
  final RxList<String> departmentsList = <String>[].obs;

  // --- Selected Filter Selections (Keeps state when sheet reopened) ---
  final RxnString selectedDegree = RxnString();
  final RxnString selectedCollege = RxnString();
  final RxnString selectedDepartment = RxnString();

  // Call this after a successful API fetch to populate the data and options
  void initializeStudentData(List<StudentDetails> rawList) {
    allStudents.assignAll(rawList);

    // Extract unique values dynamically for filters
    degreesList.assignAll(rawList
        .map((s) => s.studentdegree?.trim() ?? "")
        .where((val) => val.isNotEmpty)
        .toSet()
        .toList());

    collegesList.assignAll(rawList
        .map((s) => s.studentcollegename?.trim() ?? "")
        .where((val) => val.isNotEmpty)
        .toSet()
        .toList());

    departmentsList.assignAll(rawList
        .map((s) => s.studentfieldofstudy?.trim() ?? "")
        .where((val) => val.isNotEmpty)
        .toSet()
        .toList());

    // Apply combined local filter
    applySearchAndFilters();
  }

  // --- Core Filtering Engine ---
  void applySearchAndFilters() {
    List<StudentDetails> temp = List.from(allStudents);

    // 1. Apply Filters First
    if (selectedDegree.value != null) {
      temp = temp.where((s) => s.studentdegree == selectedDegree.value).toList();
    }
    if (selectedCollege.value != null) {
      temp = temp.where((s) => s.studentcollegename == selectedCollege.value).toList();
    }
    if (selectedDepartment.value != null) {
      temp = temp.where((s) => s.studentfieldofstudy == selectedDepartment.value).toList();
    }

    // 2. Combine with Search Query (Name search only)
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      temp = temp.where((s) {
        final name = s.studName?.toLowerCase() ?? "";
        return name.contains(query);
      }).toList();
    }

    filteredStudents.assignAll(temp);
  }

  // --- Clear Actions ---
  void clearSearchText() {
    searchQuery.value = "";
    searchController.clear();
    applySearchAndFilters(); // Re-evaluate filters without the search criteria
  }

  void resetFiltersOnly() {
    selectedDegree.value = null;
    selectedCollege.value = null;
    selectedDepartment.value = null;
    applySearchAndFilters(); // Re-evaluate with search text preserved
  }


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

  set shortlistStudentLoading(bool value) =>
      _shortlistStudentLoading.value = value;

  // Model

  final _shortlistModel = ShortlistedStudentDataModel().obs;

  ShortlistedStudentDataModel get shortlistModel => _shortlistModel.value;

  set shortlistModel(ShortlistedStudentDataModel value) =>
      _shortlistModel.value = value;

  Future<void> getShortlistStudentsList() async {
    try {
      shortlistStudentLoading = true;
      shortlistModel = await recruiterHomeProvider!
          .fetchShortlistStudentsList();
    } catch (err) {
      rethrow;
    } finally {
      shortlistStudentLoading = false;
    }
  }

  Future<void> shortlistStudentToggleFunc(
    int index,
    ShortlistedData shortlistedStudent,
  ) async {
    final removedItem = shortlistedStudent;

    shortlistModel.shortlistedData?.removeAt(index);
    update();

    final success = await removeShortlistStudent(
      studentId: removedItem.student?.id ?? "",
    );

    if (!success) {
      shortlistModel.shortlistedData?.insert(index, removedItem);
      update();
    }
  }

  // GET ALL SHORTLISTED STUDENTS LIST

  final _updateProfileLoading = false.obs;

  bool get updateProfileLoading => _updateProfileLoading.value;

  set updateProfileLoading(bool value) =>
      _updateProfileLoading.value = value;


  Future<void> updateRecruiterProfile({required Map<String, dynamic>updateData}) async {
    try {
      updateProfileLoading = true;
      commonPostModel = await recruiterHomeProvider!
          .updateRecruiterProfile(updateData: updateData);
    } catch (err) {
      rethrow;
    } finally {
      updateProfileLoading = false;
    }
  }

  // GENERATE SYLLABUS

  final _syllabusGenerateLoading = false.obs;

  bool get syllabusGenerateLoading => _syllabusGenerateLoading.value;

  set syllabusGenerateLoading(bool value) =>
      _syllabusGenerateLoading.value = value;

  // Model

  final _syllabusGenerateModel = SyllabusGenerateModel().obs;

  SyllabusGenerateModel get syllabusGenerateModel => _syllabusGenerateModel.value;

  set syllabusGenerateModel(SyllabusGenerateModel value) =>
      _syllabusGenerateModel.value = value;

  Future<void> generateSyllabus({required Map<String, dynamic> requireData}) async {
    try {
      syllabusGenerateLoading = true;
      syllabusGenerateModel = await recruiterHomeProvider!
          .generateSyllabus(requireData: requireData);
    } catch (err) {
      rethrow;
    } finally {
      syllabusGenerateLoading = false;
    }
  }

  // SAVE SYLLABUS

  final _syllabusSaveLoading = false.obs;

  bool get syllabusSaveLoading => _syllabusSaveLoading.value;

  set syllabusSaveLoading(bool value) =>
      _syllabusSaveLoading.value = value;

  // Model

  final _syllabusSaveModel = SyllabusSaveModel().obs;

  SyllabusSaveModel get syllabusSaveModel => _syllabusSaveModel.value;

  set syllabusSaveModel(SyllabusSaveModel value) =>
      _syllabusSaveModel.value = value;

  Future<void> saveSyllabus({required SyllabusGenerateModel syllabusData}) async {
    try {
      syllabusSaveLoading = true;
      syllabusSaveModel = await recruiterHomeProvider!
          .saveSyllabus(syllabusData: syllabusData);
    } catch (err) {
      rethrow;
    } finally {
      syllabusSaveLoading = false;
    }
  }

  // GET SYLLABUS

  final _syllabusLoading = false.obs;

  bool get syllabusLoading => _syllabusLoading.value;

  set syllabusLoading(bool value) =>
      _syllabusLoading.value = value;

  // Model

  final _syllabusModel = SyllabusViewDataModel().obs;

  SyllabusViewDataModel get syllabusModel => _syllabusModel.value;

  set syllabusModel(SyllabusViewDataModel value) =>
      _syllabusModel.value = value;

  Future<void> getSyllabus({required String studentId, required String jobId}) async {
    try {
      syllabusLoading = true;
      syllabusModel = await recruiterHomeProvider!
          .fetchSyllabus(studentId: studentId, jobId: jobId);
    } catch (err) {
      rethrow;
    } finally {
      syllabusLoading = false;
    }
  }

  // GET STUDENT RESULT

  final _studentResultLoading = false.obs;

  bool get studentResultLoading => _studentResultLoading.value;

  set studentResultLoading(bool value) =>
      _studentResultLoading.value = value;

  // Model

  final _testResultModel = InternTestResultModel().obs;

  InternTestResultModel get testResultModel => _testResultModel.value;

  set testResultModel(InternTestResultModel value) =>
      _testResultModel.value = value;

  Future<void> getStudentResult({required String studentId, required String jobId}) async {
    try {
      studentResultLoading = true;
      testResultModel = await recruiterHomeProvider!
          .fetchStudentResult(studentId: studentId, jobId: jobId);
    } catch (err) {
      rethrow;
    } finally {
      studentResultLoading = false;
    }
  }

  // GET RECRUITER CREDITS PLANS

  final _recruiterCreditsLoading = false.obs;

  bool get recruiterCreditsLoading => _recruiterCreditsLoading.value;

  set recruiterCreditsLoading(bool value) =>
      _recruiterCreditsLoading.value = value;

  // Model

  final _creditsPlanModel = RecruiterCreditsPlansModel().obs;

  RecruiterCreditsPlansModel get creditsPlanModel => _creditsPlanModel.value;

  set creditsPlanModel(RecruiterCreditsPlansModel value) =>
      _creditsPlanModel.value = value;

  Future<void> getRecruiterCreditPlans() async {
    try {
      recruiterCreditsLoading = true;
      creditsPlanModel = await recruiterHomeProvider!
          .fetchRecruiterCreditPlans();
    } catch (err) {
      rethrow;
    } finally {
      recruiterCreditsLoading = false;
    }
  }

  // CREATE CREDIT ORDER

  // Loading

  final _createCreditLoading = false.obs;

  bool get createCreditLoading => _createCreditLoading.value;

  set createCreditLoading(bool value) => _createCreditLoading.value = value;

  // Model

  final _createCreditOrderModel = OrderCreateCreditModel().obs;

  OrderCreateCreditModel get createCreditOrderModel =>
      _createCreditOrderModel.value;

  set createCreditOrderModel(OrderCreateCreditModel value) =>
      _createCreditOrderModel.value = value;

  Future<void> createCreditPlanOrder({
    required String creditId,
    required String planId,
  }) async {
    try {
      createCreditLoading = true;
      createCreditOrderModel = await recruiterHomeProvider!.newCreditPlanOrder(
        creditId: creditId,
        planId: planId,
      );
      createCreditLoading = false;
    } catch (err) {
      createCreditLoading = false;
      rethrow;
    }
  }

  // VERIFY CREDIT ORDER

  // Loading

  final _verifyCreditLoading = false.obs;

  bool get verifyCreditLoading => _verifyCreditLoading.value;

  set verifyCreditLoading(bool value) => _verifyCreditLoading.value = value;

  // Model

  final _verifyCreditOrderModel = CreditOrderVerifyModel().obs;

  CreditOrderVerifyModel get verifyCreditOrderModel =>
      _verifyCreditOrderModel.value;

  set verifyCreditOrderModel(CreditOrderVerifyModel value) =>
      _verifyCreditOrderModel.value = value;

  Future<void> verifyCreditPlanOrder({
    required String orderId,
  }) async {
    try {
      verifyCreditLoading = true;
      verifyCreditOrderModel = await recruiterHomeProvider!.verifyCreditPlanOrder(
        orderId: orderId,
      );
      verifyCreditLoading = false;
    } catch (err) {
      verifyCreditLoading = false;
      rethrow;
    }
  }

  // VERIFY CREDIT ORDER

  // Loading

  final _generateCertificateLoading = false.obs;

  bool get generateCertificateLoading => _generateCertificateLoading.value;

  set generateCertificateLoading(bool value) => _generateCertificateLoading.value = value;

  // Model

  final _certificateGenerateModel = CertificateGenerateModel().obs;

  CertificateGenerateModel get certificateGenerateModel =>
      _certificateGenerateModel.value;

  set certificateGenerateModel(CertificateGenerateModel value) =>
      _certificateGenerateModel.value = value;

  Future<void> generateAiCertificate({
    required Map<String, dynamic> requireData,
  }) async {
    try {
      generateCertificateLoading = true;
      certificateGenerateModel = await recruiterHomeProvider!.generateAiCertificate(
        requireData: requireData,
      );
      generateCertificateLoading = false;
    } catch (err) {
      generateCertificateLoading = false;
      rethrow;
    }
  }


  //  GET TRANSACTION HISTORY

  final _transactionHistoryLoading = false.obs;

  bool get transactionHistoryLoading => _transactionHistoryLoading.value;

  set transactionHistoryLoading(bool value) => _transactionHistoryLoading.value = value;

  // Model

  final _historyModel = RecruiterTransactionHistoryModel().obs;

  RecruiterTransactionHistoryModel get historyModel => _historyModel.value;

  set historyModel(RecruiterTransactionHistoryModel value) =>
      _historyModel.value = value;

  Future<void> getTransactionHistory({
    required String recruiterId,
  }) async {
    try {
      transactionHistoryLoading = true;
      historyModel = await recruiterHomeProvider!.fetchTransactionHistory(
        recruiterId: recruiterId,
      );
    } catch (err) {
      rethrow;
    } finally {
      transactionHistoryLoading = false;
    }
  }
}
