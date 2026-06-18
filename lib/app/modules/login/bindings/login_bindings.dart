import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/student_login_provider.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_login_provider.dart';
import 'package:internsharks/app/data/providers/register_provider.dart';
import 'package:internsharks/app/modules/login/controllers/student_login_controller.dart';
import 'package:internsharks/app/modules/login/controllers/network_controller.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/recruiter_login_controller.dart';

class AppInitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put<StudentLoginController>(
      StudentLoginController(StudentLoginProvider(client: Dio())),
      permanent: true,
    );
    Get.put<RecruiterLoginController>(
      RecruiterLoginController(RecruiterLoginProvider(client: Dio())),
      permanent: true,
    );
  }
}

class RegisterBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(
      RegisterController(RegisterProvider(client: Dio())),
      permanent: true,
    );
  }
}
