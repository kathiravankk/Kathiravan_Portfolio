import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/dashboard_provider.dart';
import 'package:internsharks/app/data/providers/internship_provider.dart';
import 'package:internsharks/app/data/providers/profile_provider.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/internship/controller/internship_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(
      ProfileController(ProfileProvider(client: Dio())),
      permanent: true,
    );
    Get.put<DashboardController>(
      DashboardController(DashboardProvider(client: Dio())),
      permanent: true,
    );
    Get.put<InternshipController>(
      InternshipController(InternshipProvider(client: Dio())),
      permanent: true,
    );
  }
}

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(
      ProfileController(ProfileProvider(client: Dio())),
      permanent: true,
    );
  }
}
