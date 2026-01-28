import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/controllers/resigter_controller.dart';
import 'package:internsharks/provider/auth_provider.dart';
import '../controllers/login_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(
      LoginController(AuthProvider(client: Dio())),
      permanent: true,
    );
    Get.lazyPut<RegisterFlowController>(() => RegisterFlowController());
  }
}
