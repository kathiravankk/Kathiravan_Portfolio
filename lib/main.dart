// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:internsharks/core/routes/app_pages.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
//
// import 'binding/login_binding.dart';
// import 'controllers/login_controller.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
//   Get.put(LoginController()); //
//   runApp(ProviderScope(child: MyApp()));
// }
//
// class MyApp extends StatefulWidget {
//
//
//   const MyApp({super.key, });
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: Routes.splashScreen,
//       getPages: AppPages.routes,
//       initialBinding: LoginBinding(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:internsharks/core/routes/app_pages.dart';
import 'binding/login_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen,
      getPages: AppPages.routes,
      initialBinding: LoginBinding(), // ✅ only here
    );
  }
}
