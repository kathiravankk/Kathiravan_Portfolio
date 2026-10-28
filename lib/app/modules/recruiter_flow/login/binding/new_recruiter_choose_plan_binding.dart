import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_register_provider.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/new_recruiter_choose_plan_controller.dart';

class NewRecruiterChoosePlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewRecruiterChoosePlanController>(
      () => NewRecruiterChoosePlanController(
        recruiterRegisterProvider: RecruiterRegisterProvider(client: Dio()),
      ),
    );
  }
}
