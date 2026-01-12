import 'package:get/get.dart';

class RegisterFlowController extends GetxController {
  RxMap<String, dynamic> resumeData = <String, dynamic>{}.obs;

  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString mobile = ''.obs;
  RxString dob = ''.obs;

  RxBool emailVerified = false.obs;
  RxBool mobileVerified = false.obs;
}
