import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_home_provider.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';

class RecruiterHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RecruiterHomeController>(
      RecruiterHomeController(RecruiterHomeProvider(client: Dio())),
      permanent: true,
    );
  }
}