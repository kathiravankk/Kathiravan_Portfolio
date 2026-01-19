// import 'package:get/get.dart';
// import '../models/extracted_data_model.dart';
// import '../provider/1215.dart';
//
// class RegisterFlowController extends GetxController {
//
//   final RegisterProvider _provider = RegisterProvider();
//
//   ResumeData? resumeData;
//
//   RxBool emailVerified = false.obs;
//   RxBool mobileVerified = false.obs;
//   RxBool isLoading = false.obs;
//
//   Future<void> onSaveAndContinue() async {
//     if (resumeData == null) return;
//
//     isLoading.value = true;
//
//     try {
//       final statusCode = await _provider.registerStudent(
//         resume: resumeData!,
//         emailVerified: emailVerified.value,
//         mobileVerified: mobileVerified.value,
//       );
//
//       if (statusCode == 200 || statusCode == 201) {
//         print("✅ Register success");
//       } else {
//         print("❌ Register failed");
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
