import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/home/all_internship_model.dart';
import 'package:internsharks/app/data/models/home/applied_internship_model.dart';
import 'package:internsharks/app/data/models/home/category_list_model.dart';
import 'package:internsharks/app/data/models/home/category_wise_internship_model.dart';
import 'package:internsharks/app/data/models/home/credit_order_verify_model.dart';
import 'package:internsharks/app/data/models/home/credit_plan_model.dart';
import 'package:internsharks/app/data/models/home/internship_apply_model.dart';
import 'package:internsharks/app/data/models/home/internship_detail_model.dart';
import 'package:internsharks/app/data/models/home/order_create_credit_model.dart';
import 'package:internsharks/app/data/models/home/recommand_internship_model.dart';
import 'package:internsharks/app/data/models/home/review_data_model.dart';
import 'package:internsharks/app/data/models/home/similar_internship_model.dart';
import 'package:internsharks/app/data/models/home/update_chat_model.dart';
import 'package:internsharks/app/data/providers/dashboard_provider.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';

class DashboardController extends GetxController {
  final DashboardProvider? dashboardProvider;

  DashboardController(this.dashboardProvider);

  int getResponseCode() => dashboardProvider!.responseStatus;

  // GET CATEGORY LIST

  // Loading

  final _getCategoryLoading = false.obs;

  bool get getCategoryLoading => _getCategoryLoading.value;

  set getCategoryLoading(bool value) => _getCategoryLoading.value = value;

  // Model

  final _categoryListModel = CategoryListModel().obs;

  CategoryListModel get categoryListModel => _categoryListModel.value;

  set categoryListModel(CategoryListModel value) =>
      _categoryListModel.value = value;

  Future<void> getCategoryListData() async {
    try {
      getCategoryLoading = true;
      categoryListModel = await dashboardProvider!.fetchCategoryList();
      getCategoryLoading = false;
    } catch (err) {
      getCategoryLoading = false;
      rethrow;
    }
  }

  // GET CATEGORY WISE INTERNSHIP DATA LIST

  // Loading

  final _categoryInternshipLoading = false.obs;

  bool get categoryInternshipLoading => _categoryInternshipLoading.value;

  set categoryInternshipLoading(bool value) =>
      _categoryInternshipLoading.value = value;

  // Model

  final _categoryInternshipModel = CategoryWiseInternshipModel().obs;

  CategoryWiseInternshipModel get categoryInternshipModel =>
      _categoryInternshipModel.value;

  set categoryInternshipModel(CategoryWiseInternshipModel value) =>
      _categoryInternshipModel.value = value;

  Future<void> getCategoryInternshipData({required String categoryId}) async {
    try {
      categoryInternshipLoading = true;
      categoryInternshipModel = await dashboardProvider!
          .fetchCategoryInternship(categoryId: categoryId);
      categoryInternshipLoading = false;
    } catch (err) {
      categoryInternshipLoading = false;
      rethrow;
    }
  }

  // GET INTERNSHIP DETAILS DATA

  // Loading

  final _internshipDetailLoading = false.obs;

  bool get internshipDetailLoading => _internshipDetailLoading.value;

  set internshipDetailLoading(bool value) =>
      _internshipDetailLoading.value = value;

  // Model

  final _internshipDetailModel = InternshipDetailModel().obs;

  InternshipDetailModel get internshipDetailModel =>
      _internshipDetailModel.value;

  set internshipDetailModel(InternshipDetailModel value) =>
      _internshipDetailModel.value = value;

  Future<void> getInternshipViewData({required String internshipId, required String studentId}) async {
    try {
      internshipDetailLoading = true;
      internshipDetailModel = await dashboardProvider!.fetchInternshipViewData(
        internshipId: internshipId,
        studentId: studentId
      );
      internshipDetailLoading = false;
    } catch (err) {
      internshipDetailLoading = false;
      rethrow;
    }
  }

  // APPLY INTERNSHIP

  // Loading

  final _internshipApplyLoading = false.obs;

  bool get internshipApplyLoading => _internshipApplyLoading.value;

  set internshipApplyLoading(bool value) =>
      _internshipApplyLoading.value = value;

  // Model

  final _internshipApplyModel = InternshipApplyModel().obs;

  InternshipApplyModel get internshipApplyModel => _internshipApplyModel.value;

  set internshipApplyModel(InternshipApplyModel value) =>
      _internshipApplyModel.value = value;

  Future<void> applyNewInternship({
    required String internshipId,
    required String studentId,
  }) async {
    try {
      internshipApplyLoading = true;
      internshipApplyModel = await dashboardProvider!.postApplyInternship(
        internshipId: internshipId,
        studentId: studentId,
      );
      internshipApplyLoading = false;
    } catch (err) {
      internshipApplyLoading = false;
      rethrow;
    }
  }

  // GET RECOMMENTED INTERNSHIP

  // Loading

  final _recommentedInternshipLoading = false.obs;

  bool get recommentedInternshipLoading => _recommentedInternshipLoading.value;

  set recommentedInternshipLoading(bool value) =>
      _recommentedInternshipLoading.value = value;

  // Model

  final _recommentedModel = RecommandInternshipModel().obs;

  RecommandInternshipModel get recommentedModel => _recommentedModel.value;

  set recommentedModel(RecommandInternshipModel value) =>
      _recommentedModel.value = value;

  Future<void> getRecommentedInternship() async {
    try {
      recommentedInternshipLoading = true;
      recommentedModel = await dashboardProvider!.fetchRecommandInternship();
      recommentedInternshipLoading = false;
    } catch (err) {
      recommentedInternshipLoading = false;
      rethrow;
    }
  }

  // GET APPLIED INTERNSHIP

  // Loading

  final _appliedInternshipLoading = false.obs;

  bool get appliedInternshipLoading => _appliedInternshipLoading.value;

  set appliedInternshipLoading(bool value) =>
      _appliedInternshipLoading.value = value;

  // Model

  final _appliedModel = AppliedInternshipModel().obs;

  AppliedInternshipModel get appliedModel => _appliedModel.value;

  set appliedModel(AppliedInternshipModel value) => _appliedModel.value = value;

  Future<void> getAppliedInternship({required String studentId}) async {
    try {
      appliedInternshipLoading = true;
      appliedModel = await dashboardProvider!.fetchAppliedInternship(
        studentId: studentId,
      );
      appliedInternshipLoading = false;
    } catch (err) {
      appliedInternshipLoading = false;
      rethrow;
    }
  }

  // GET SIMILAR INTERNSHIP

  // Loading

  final _similarInternshipLoading = false.obs;

  bool get similarInternshipLoading => _similarInternshipLoading.value;

  set similarInternshipLoading(bool value) =>
      _similarInternshipLoading.value = value;

  // Model

  final _similarInternshipModel = SimilarInternshipModel().obs;

  SimilarInternshipModel get similarInternshipModel =>
      _similarInternshipModel.value;

  set similarInternshipModel(SimilarInternshipModel value) =>
      _similarInternshipModel.value = value;

  Future<void> getSimilarInternship({
    required List<String> skillList,
    required String jobId,
  }) async {
    try {
      similarInternshipLoading = true;
      similarInternshipModel = await dashboardProvider!.fetchSimilarInternship(
        skillList: skillList,
        jobId: jobId,
      );
      similarInternshipLoading = false;
    } catch (err) {
      similarInternshipLoading = false;
      rethrow;
    }
  }

  // GET REVIEW DATA

  // Loading

  final _reviewDataLoading = false.obs;

  bool get reviewDataLoading => _reviewDataLoading.value;

  set reviewDataLoading(bool value) => _reviewDataLoading.value = value;

  // Model

  final _reviewModel = ReviewDataModel().obs;

  ReviewDataModel get reviewModel => _reviewModel.value;

  set reviewModel(ReviewDataModel value) => _reviewModel.value = value;

  Future<void> getReviewData({required String jobId}) async {
    try {
      reviewDataLoading = true;
      reviewModel = await dashboardProvider!.fetchReviewData(jobId: jobId);
      reviewDataLoading = false;
    } catch (err) {
      reviewDataLoading = false;
      rethrow;
    }
  }

  // GET UPDATE CHAT DATA

  // Loading

  final _getUpdateChatLoading = false.obs;

  bool get getUpdateChatLoading => _getUpdateChatLoading.value;

  set getUpdateChatLoading(bool value) => _getUpdateChatLoading.value = value;

  // Model

  final _updateChatModel = UpdateChatModel().obs;

  UpdateChatModel get updateChatModel => _updateChatModel.value;

  set updateChatModel(UpdateChatModel value) => _updateChatModel.value = value;

  Future<void> getUpdateResumeData({
    required Map<String, dynamic> resumeData,
  }) async {
    try {
      getUpdateChatLoading = true;
      updateChatModel = await dashboardProvider!.fetchUpdateResumeData(
        resumeData: resumeData,
      );
      getUpdateChatLoading = false;
    } catch (err) {
      getUpdateChatLoading = false;
      rethrow;
    }
  }

  // UPDATE RESUME CHAT

  // Loading

  final _resumeUpdateChatLoading = false.obs;

  bool get resumeUpdateChatLoading => _resumeUpdateChatLoading.value;

  set resumeUpdateChatLoading(bool value) =>
      _resumeUpdateChatLoading.value = value;

  // Model

  final _updateChatResumeModel = UpdateChatResumeModel().obs;

  UpdateChatResumeModel get updateChatResumeModel =>
      _updateChatResumeModel.value;

  set updateChatResumeModel(UpdateChatResumeModel value) =>
      _updateChatResumeModel.value = value;

  Future<void> updateChatResumeData({
    required Map<String, dynamic> resumeData,
  }) async {
    try {
      resumeUpdateChatLoading = true;
      updateChatResumeModel = await dashboardProvider!.updateChatResumeData(
        resumeData: resumeData,
      );
      resumeUpdateChatLoading = false;
    } catch (err) {
      resumeUpdateChatLoading = false;
      rethrow;
    }
  }

  // GET ALL INTERNSHIPS

  // Loading

  final _allInternshipLoading = false.obs;

  bool get allInternshipLoading => _allInternshipLoading.value;

  set allInternshipLoading(bool value) => _allInternshipLoading.value = value;

  // Model

  final _internshipModel = AllInternshipModel().obs;

  AllInternshipModel get internshipModel => _internshipModel.value;

  set internshipModel(AllInternshipModel value) =>
      _internshipModel.value = value;

  Future<void> getAllInternship({
    required String companyState,
    required String companyCity,
    required String qualification,
    required String duration,
    required String stipend,
    required String internshipMode,
    required String roleType,
    required int page,
    required int limit,
    required String days,
  }) async {
    try {
      allInternshipLoading = true;
      internshipModel = await dashboardProvider!.fetchAllInternship(
        duration: duration,
        companyCity: companyCity,
        companyState: companyState,
        internshipMode: internshipMode,
        qualification: qualification,
        stipend: stipend,
        roleType: roleType,
        page: page,
        limit: limit,
        days: days
      );
      allInternshipLoading = false;
    } catch (err) {
      allInternshipLoading = false;
      rethrow;
    }
  }

  // SAVE & UNSAVE FUNCTIONALITY

  final ProfileController profileController = Get.find();

  Future<bool> addToSaved({required String jobId}) async {
    await profileController.addSavedJobsData(jobId: jobId);

    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
            profileController.newSavedJobModel.message ??
            "Internship added to saved!",
      );

      return true;
    }

    AppFunctions.apiErrorHandling(
      profileController.getResponseCode(),
      profileController.newSavedJobModel.message ?? "Something went wrong",
    );

    return false;
  }

  Future<bool> removeToSaved({required String jobId}) async {
    await profileController.removeSavedJobsData(jobId: jobId);

    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message:
            profileController.newSavedJobModel.message ??
            "Internship removed from saved!",
      );

      return true;
    }

    AppFunctions.apiErrorHandling(
      profileController.getResponseCode(),
      profileController.newSavedJobModel.message ?? "Something went wrong",
    );

    return false;
  }

  Future<void> toggleSave(int index) async {
    final internship = recommentedModel.internshipList![index];
    bool oldValue = internship.isSaved ?? false;

    internship.isSaved = !oldValue;
    _recommentedModel.refresh();

    bool success;

    if (!oldValue) {
      success = await addToSaved(jobId: internship.sId!);
    } else {
      success = await removeToSaved(jobId: internship.sId!);
    }

    if (!success) {
      internship.isSaved = oldValue;
      _recommentedModel.refresh();
    }
  }

  Future<void> internshipSaveFunc(int index) async {
    final internship = categoryInternshipModel.jobs![index];
    bool oldValue = internship.isSaved ?? false;

    internship.isSaved = !oldValue;
    _categoryInternshipModel.refresh();

    bool success;

    if (!oldValue) {
      success = await addToSaved(jobId: internship.sId!);
    } else {
      success = await removeToSaved(jobId: internship.sId!);
    }

    if (!success) {
      internship.isSaved = oldValue;
      _categoryInternshipModel.refresh();
    }
  }

  Future<void> searchFilterSaveFunc(
      InternshipModel internship,
      ) async {
    final oldValue = internship.isSaved ?? false;

    internship.isSaved = !oldValue;

    bool success;

    if (!oldValue) {
      success = await addToSaved(jobId: internship.id!);
    } else {
      success = await removeToSaved(jobId: internship.id!);
    }

    if (!success) {
      internship.isSaved = oldValue;
    }
  }

  Future<void> similarSaveFunc(int index) async {
    final internship = similarInternshipModel.similarList![index];
    bool oldValue = internship.isSaved ?? false;

    internship.isSaved = !oldValue;
    _similarInternshipModel.refresh();

    bool success;

    if (!oldValue) {
      success = await addToSaved(jobId: internship.sId!);
    } else {
      success = await removeToSaved(jobId: internship.sId!);
    }

    if (!success) {
      internship.isSaved = oldValue;
      _similarInternshipModel.refresh();
    }
  }

  // GET CREDIT PLAN DATA

  // Loading

  final _creditPlanLoading = false.obs;

  bool get creditPlanLoading => _creditPlanLoading.value;

  set creditPlanLoading(bool value) => _creditPlanLoading.value = value;

  // Model

  final _creditPlanModel = CreditPlanModel().obs;

  CreditPlanModel get creditPlanModel => _creditPlanModel.value;

  set creditPlanModel(CreditPlanModel value) => _creditPlanModel.value = value;

  Future<void> getCreditPlanData() async {
    try {
      creditPlanLoading = true;
      creditPlanModel = await dashboardProvider!.fetchCreditPlanData();
      creditPlanLoading = false;
    } catch (err) {
      creditPlanLoading = false;
      rethrow;
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
      createCreditOrderModel = await dashboardProvider!.newCreditPlanOrder(
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
      verifyCreditOrderModel = await dashboardProvider!.verifyCreditPlanOrder(
        orderId: orderId,
      );
      verifyCreditLoading = false;
    } catch (err) {
      verifyCreditLoading = false;
      rethrow;
    }
  }

  // DELETE ACCOUNT

  // Loading

  final _studentDeleteLoading = false.obs;

  bool get studentDeleteLoading => _studentDeleteLoading.value;

  set studentDeleteLoading(bool value) => _studentDeleteLoading.value = value;

  // Model

  final _commonPostModel = CommonLoginOtpModel().obs;

  CommonLoginOtpModel get commonPostModel =>
      _commonPostModel.value;

  set commonPostModel(CommonLoginOtpModel value) =>
      _commonPostModel.value = value;

  Future<void> deleteStudentAccount() async {
    try {
      studentDeleteLoading = true;
      commonPostModel = await dashboardProvider!.removeStudentAccount(
      );
      studentDeleteLoading = false;
    } catch (err) {
      studentDeleteLoading = false;
      rethrow;
    }
  }
}
