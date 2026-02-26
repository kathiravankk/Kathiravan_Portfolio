import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/data/models/home/applied_internship_model.dart';
import 'package:internsharks/app/data/models/home/category_list_model.dart';
import 'package:internsharks/app/data/models/home/category_wise_internship_model.dart';
import 'package:internsharks/app/data/models/home/internship_apply_model.dart';
import 'package:internsharks/app/data/models/home/internship_detail_model.dart';
import 'package:internsharks/app/data/models/home/recommand_internship_model.dart';
import 'package:internsharks/app/data/models/home/review_data_model.dart';
import 'package:internsharks/app/data/models/home/similar_internship_model.dart';
import 'package:internsharks/app/data/models/home/update_chat_model.dart';
import 'package:internsharks/app/data/providers/dashboard_provider.dart';
import 'package:internsharks/app/modules/home/controller/profile_controller.dart';

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

  Future<void> getInternshipViewData({required String internshipId}) async {
    try {
      internshipDetailLoading = true;
      internshipDetailModel = await dashboardProvider!.fetchInternshipViewData(
        internshipId: internshipId,
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

  Future<void> getSimilarInternship({required List<String> skillList}) async {
    try {
      similarInternshipLoading = true;
      similarInternshipModel = await dashboardProvider!.fetchSimilarInternship(
        skillList: skillList,
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

  set reviewDataLoading(bool value) =>
      _reviewDataLoading.value = value;

  // Model

  final _reviewModel = ReviewDataModel().obs;

  ReviewDataModel get reviewModel =>
      _reviewModel.value;

  set reviewModel(ReviewDataModel value) =>
      _reviewModel.value = value;

  Future<void> getReviewData({required String jobId}) async {
    try {
      reviewDataLoading = true;
      reviewModel = await dashboardProvider!.fetchReviewData(
        jobId: jobId,
      );
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

  set getUpdateChatLoading(bool value) =>
      _getUpdateChatLoading.value = value;

  // Model

  final _updateChatModel = UpdateChatModel().obs;

  UpdateChatModel get updateChatModel =>
      _updateChatModel.value;

  set updateChatModel(UpdateChatModel value) =>
      _updateChatModel.value = value;

  Future<void> getUpdateResumeData({required Map<String, dynamic> resumeData}) async {
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

  Future<void> updateChatResumeData({required Map<String, dynamic> resumeData}) async {
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

  // SAVE & UNSAVE FUNCTIONALITY

  final ProfileController profileController = Get.find();

  Future<bool> addToSaved({required String jobId}) async {
    await profileController.addSavedJobsData(jobId: jobId);

    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {

      AppFunctions.showToast(
        message: profileController.newSavedJobModel.message ??
            "Internship added to saved!",
      );

      return true;
    }

    AppFunctions.apiErrorHandling(
      profileController.getResponseCode(),
      profileController.newSavedJobModel.message ??
          "Something went wrong",
    );

    return false;
  }

  Future<bool> removeToSaved({required String jobId}) async {
    await profileController.removeSavedJobsData(jobId: jobId);

    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {

      AppFunctions.showToast(
        message: profileController.newSavedJobModel.message ??
            "Internship removed from saved!",
      );

      return true;
    }

    AppFunctions.apiErrorHandling(
      profileController.getResponseCode(),
      profileController.newSavedJobModel.message ??
          "Something went wrong",
    );

    return false;
  }

  Future<void> toggleSave(int index) async {

    final internship = recommentedModel
        .internshipList![index];
    bool oldValue = internship.isSaved ?? false;

    internship.isSaved = !oldValue;
    _recommentedModel
        .refresh();

    bool success;

    if (!oldValue) {
      success = await addToSaved(jobId: internship.sId!);
    } else {
      success = await removeToSaved(jobId: internship.sId!);
    }

    if (!success) {
      internship.isSaved = oldValue;
      _recommentedModel
          .refresh();
    }
  }

  Future<void> internshipSaveFunc(int index) async {

    final internship =
    categoryInternshipModel.jobs![index];
    bool oldValue = internship.isSaved ?? false;

    internship.isSaved = !oldValue;
    _categoryInternshipModel
        .refresh();

    bool success;

    if (!oldValue) {
      success = await addToSaved(jobId: internship.sId!);
    } else {
      success = await removeToSaved(jobId: internship.sId!);
    }

    if (!success) {
      internship.isSaved = oldValue;
      _categoryInternshipModel
          .refresh();
    }
  }

  Future<void> similarSaveFunc(int index) async {

    final internship =
    similarInternshipModel.similarList![index];
    bool oldValue = internship.isSaved ?? false;

    internship.isSaved = !oldValue;
    _similarInternshipModel
        .refresh();

    bool success;

    if (!oldValue) {
      success = await addToSaved(jobId: internship.sId!);
    } else {
      success = await removeToSaved(jobId: internship.sId!);
    }

    if (!success) {
      internship.isSaved = oldValue;
      _similarInternshipModel
          .refresh();
    }
  }




}
