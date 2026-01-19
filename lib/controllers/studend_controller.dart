// /*
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
//
// import '../core/const_file/api_error_handling.dart';
// import '../models/resume_response.dart';
// import '../provider/studentregister_provider.dart';
//
// class studentRegisterController extends GetxController {
//   final StudentRegisterProvider? studentRegisterProvider;
//
//   studentRegisterController(this.studentRegisterProvider);
//
//
//
//
//
//   int? getResponseCode() => studentRegisterProvider!.responseStatus;
//
//
// ///loading
//   final _registerLoading = false.obs;
//
//   bool get registerLoading => _registerLoading.value;
//
//   set registerLoading(bool v) => _registerLoading.value = v;
//   final _resumeResponse = ResumeResponse().obs;
//
//   ResumeResponse get resumeResponse => _resumeResponse.value;
//
//   set resumeResponse(ResumeResponse v) => _resumeResponse.value = v;
//
//   /// Already data iruku – direct POST
//   Future<void> registerStudent() async {
//     registerLoading = true;
//
//     try {
//       /// 🔹 POST API call
//       ResumeResponse =
//       await registerProvider!.registerStudent(
//         name: name.value,
//         email: email.value,
//         mobile: mobile.value,
//         resumeReport: resumeReport,
//       );
//
//       /// 🔹 Common error / success handler
//       ApiErrorHandler.handleApiError(
//         responseCode: getResponseCode(),
//         message: ResumeResponse.message ?? "Something went wrong",
//       );
//
//       /// ✅ IMPORTANT (OTP style)
//       registerSuccess = true;   // 🔥 success flag
//
//     } catch (error) {
//       ApiErrorHandler.handleApiError(
//         responseCode: getResponseCode(),
//         message: commonPostModel.message ?? "Something went wrong",
//       );
//       rethrow;
//     } finally {
//       registerLoading = false;
//     }
//   }
// }
// */
// import 'package:get/get.dart';
//
// import '../core/const_file/api_error_handling.dart';
// import '../models/common_post_model.dart';
// import '../models/resume_response.dart';
// import '../provider/studentregister_provider.dart';
//
// class StudentRegisterController extends GetxController {
//   final StudentRegisterProvider studentRegisterProvider;
//
//   StudentRegisterController(this.studentRegisterProvider);
//
//   // ================= RESPONSE CODE =================
//   int? getResponseCode() => studentRegisterProvider.responseStatus;
//
//   // ================= LOADING =================
//   final RxBool _registerLoading = false.obs;
//   bool get registerLoading => _registerLoading.value;
//   set registerLoading(bool v) => _registerLoading.value = v;
//
//   // ================= SUCCESS FLAG =================
//   final RxBool registerSuccess = false.obs;
//
//   // ================= DATA (ALREADY STORED) =================
//   final RxString name = ''.obs;
//   final RxString email = ''.obs;
//   final RxString mobile = ''.obs;
//
//   /// resume analyze API response
//   final RxMap<String, dynamic> resumeReport = <String, dynamic>{}.obs;
//
//   // ================= API RESPONSE MODEL =================
//   final Rx<CommonPostModel> _commonPostModel = CommonPostModel().obs;
//   CommonPostModel get commonPostModel => _commonPostModel.value;
//   set commonPostModel(CommonPostModel v) => _commonPostModel.value = v;
//
//   // ================= REGISTER API =================
//   Future<void> registerStudent() async {
//     registerLoading = true;
//
//     try {
//       /// 🔹 POST API call
//       commonPostModel =
//       await studentRegisterProvider.registerStudent(
//         name: name.value,
//         email: email.value,
//         mobile: mobile.value,
//         resumeReport: resumeReport,
//       );
//
//       /// 🔹 Common error / success handler (OTP style)
//       ApiErrorHandler.handleApiError(
//         responseCode: getResponseCode(),
//         message: commonPostModel.message ?? "Something went wrong",
//       );
//
//       /// ✅ SUCCESS FLAG
//       registerSuccess.value = true;
//
//     } catch (error) {
//       ApiErrorHandler.handleApiError(
//         responseCode: getResponseCode(),
//         message: commonPostModel.message ?? "Something went wrong",
//       );
//       rethrow;
//     } finally {
//       registerLoading = false;
//     }
//   }
// }
