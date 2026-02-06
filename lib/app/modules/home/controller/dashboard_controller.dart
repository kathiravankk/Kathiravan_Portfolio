import 'package:get/get.dart';
import 'package:internsharks/app/data/models/home/applied_internship_model.dart';
import 'package:internsharks/app/data/models/home/category_list_model.dart';
import 'package:internsharks/app/data/models/home/category_wise_internship_model.dart';
import 'package:internsharks/app/data/models/home/internship_apply_model.dart';
import 'package:internsharks/app/data/models/home/internship_detail_model.dart';
import 'package:internsharks/app/data/models/home/recommand_internship_model.dart';
import 'package:internsharks/app/data/models/home/review_data_model.dart';
import 'package:internsharks/app/data/models/home/similar_internship_model.dart';
import 'package:internsharks/app/data/providers/dashboard_provider.dart';

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
}
