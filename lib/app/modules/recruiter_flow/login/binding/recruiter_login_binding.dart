import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_login_provider.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/recruiter_login_controller.dart';

class RecruiterLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RecruiterLoginController>(
      RecruiterLoginController(RecruiterLoginProvider(client: Dio())),
      permanent: true,
    );
  }
}