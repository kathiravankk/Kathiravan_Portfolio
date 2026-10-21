import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_notification_provider.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_notification_controller.dart';

class RecruiterNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecruiterNotificationController>(
      () => RecruiterNotificationController(
        RecruiterNotificationProvider(client: Dio()),
      ),
    );
  }
}
