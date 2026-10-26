import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_register_provider.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/new_recruiter_company_info_controller.dart';

class NewRecruiterCompanyInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewRecruiterCompanyInfoController>(
      () => NewRecruiterCompanyInfoController(
        recruiterRegisterProvider: RecruiterRegisterProvider(client: Dio()),
      ),
    );
  }
}
