import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_register_provider.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/new_recruiter_register_controller.dart';

class NewRecruiterRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NewRecruiterRegisterController>(
      NewRecruiterRegisterController(
        RecruiterRegisterProvider(client: Dio()),
      ),
      permanent: true,
    );
  }
}
