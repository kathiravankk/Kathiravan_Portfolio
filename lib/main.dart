import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart'; // 👈 Add this import
import 'package:internsharks/app/routes/app_pages.dart';
import 'app/modules/login/bindings/login_bindings.dart';

void main() async { // 👈 Make this async
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for Android using your google-services.json
  await Firebase.initializeApp(); // 👈 Add this line

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        top: false,
        bottom: true,
        child: GetMaterialApp(
          initialBinding: LoginBindings(),
          initialRoute: AppRoutes.splashScreen,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}