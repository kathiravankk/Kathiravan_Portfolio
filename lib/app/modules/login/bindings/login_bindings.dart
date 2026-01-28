import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/login_provider.dart';
import 'package:internsharks/app/data/providers/register_provider.dart';
import 'package:internsharks/app/modules/login/controllers/login_controller.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';


class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(
      LoginController(LoginProvider(client: Dio())),
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