import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/internship_post_provider.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';

class InternshipPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<InternshipPostController>(
      InternshipPostController(InternshipPostProvider(client: Dio())),
      permanent: true,
    );
  }
}