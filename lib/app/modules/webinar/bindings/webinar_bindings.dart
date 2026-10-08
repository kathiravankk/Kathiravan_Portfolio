import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/webinar_provider.dart';
import 'package:internsharks/app/modules/webinar/controller/webinar_controller.dart';

class WebinarBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebinarController>(
      () => WebinarController(WebinarProvider(client: Dio())),
    );
  }
}
