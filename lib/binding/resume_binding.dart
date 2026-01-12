import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:internsharks/controllers/resume_controller.dart';
import 'package:internsharks/provider/resume_provider.dart';

class ResumeBinding extends Bindings {
  @override

  @override
  void dependencies() {
    Get.put<ResumeController>(
        ResumeController(ResumeProvider(client: Dio())),
        permanent: true);
  }
}
