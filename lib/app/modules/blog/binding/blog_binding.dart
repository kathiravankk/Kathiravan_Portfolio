import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/data/providers/blog_provider.dart';
import 'package:internsharks/app/modules/blog/controller/blog_controller.dart';

class BlogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogController>(
      () => BlogController(BlogProvider(client: Dio())),
    );
  }
}
