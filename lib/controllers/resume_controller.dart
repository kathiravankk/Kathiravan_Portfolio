import 'package:get/get.dart';
import 'package:internsharks/models/resume_analyze_model.dart';
import 'package:internsharks/provider/resume_provider.dart';

class ResumeController extends GetxController {
  final ResumeProvider? resumeProvider;

  ResumeController(this.resumeProvider);

  // Get response code

  int getResponseCode() => resumeProvider!.responseStatus;

  // Set model


  final _resumeAnalyzeModel = ResumeAnalyzeModel().obs;

  ResumeAnalyzeModel get resumeAnalyzeModel => _resumeAnalyzeModel.value;

  set resumeAnalyzeModel(ResumeAnalyzeModel value) =>
      _resumeAnalyzeModel.value = value;

  //Set loading

  final _resumeUploadLoading = false.obs;

  bool get resumeUploadLoading =>
      _resumeUploadLoading.value;

  set resumeUploadLoading(bool value) =>
      _resumeUploadLoading.value = value;

  Future<void> uploadResume(
      String? filePath) async {
    resumeUploadLoading = true;
    try {
      resumeAnalyzeModel = await resumeProvider!
          .uploadResumePdf(filePath!);
      resumeUploadLoading = false;
    } catch (error) {
      resumeUploadLoading = false;
      rethrow;
    }
  }
}