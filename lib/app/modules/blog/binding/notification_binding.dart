import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/notification_provider.dart';
import 'package:internsharks/app/modules/blog/controller/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(NotificationProvider(client: Dio())),
    );
  }
}
