import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/upgrade_subscription_provider.dart';
import 'package:internsharks/app/modules/recruiter_flow/subscription/controller/upgrade_subscription_controller.dart';

class UpgradeSubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpgradeSubscriptionController>(
      () => UpgradeSubscriptionController(
        provider: UpgradeSubscriptionProvider(client: Dio()),
      ),
    );
  }
}
