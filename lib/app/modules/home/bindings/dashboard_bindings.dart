import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/dashboard_provider.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(
      DashboardController(DashboardProvider(client: Dio())),
      permanent: true,
    );
  }
}
