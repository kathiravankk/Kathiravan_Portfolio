import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/controllers/resigter_controller.dart';
import 'package:internsharks/provider/login_provider.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(
      LoginController(LoginProvider(client: Dio())),
      permanent: true,
    );
    Get.lazyPut<RegisterFlowController>(() => RegisterFlowController());
    // Get.lazyPut<OtpController>(() => OtpController());
  }
}
