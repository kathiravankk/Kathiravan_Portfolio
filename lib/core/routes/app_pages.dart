import 'dart:io';

import 'package:get/get.dart' hide Transition;
import 'package:internsharks/binding/login_binding.dart';
import 'package:internsharks/binding/resume_binding.dart';

import '../../view/pages/kyc/kyc_college_id_page.dart';
import '../../view/pages/login/login_page.dart';
import '../../view/pages/login/register_page.dart';
import '../../view/pages/others/115.dart';
import '../../view/pages/others/117.dart';
import '../../view/pages/others/200.dart';
import '../../view/pages/others/account_settings_page.dart';
import '../../view/pages/others/appPreferences_age.dart';
import '../../view/pages/others/application_status_page.dart';
import '../../view/pages/others/change_email_page.dart.dart';
import '../../view/pages/others/change_phoneNumber_page.dart';
import '../../view/pages/others/internship_details_page.dart';
import '../../view/pages/others/manage_resume_page.dart';
import '../../view/pages/others/my_application_page.dart';
import '../../view/pages/others/settings_page.dart';
import '../../view/pages/upload_resdp/resumeScreen.dart';
import '../../view/pages/upload_resume/22.dart';
import '../../view/pages/upload_resume/resume_loaded_page.dart';
import '../../view/pages/upload_resume/resume_report_page.dart';
import '../../view/pages/upload_resume/upload_resume_page.dart';
import '../../view/pages/upload_selfie/review_upload_selfie.dart';
import '../../view/pages/upload_selfie/upload_selfie_page.dart';
import '../../view/screens/goto_intern_homepage.dart';
import '../../view/screens/home_Screen.dart';
import '../../view/screens/splash_screen.dart';


part 'app_routes.dart';

GetPage appPage({
  required String name,
  required page,
  List<Bindings>? bindings,
}) {
  return GetPage(
    name: name,
    page: page,
    bindings: bindings ?? [LoginBinding()],
    transitionDuration: const Duration(milliseconds: 100),
  );
}

class AppPages {
  static final routes = [
    appPage(name: Routes.homeScreen, page: () => HomeScreen()),
    appPage(
      name: Routes.splashScreen,
      page: () => SplashScreen(),
      bindings: [LoginBinding()],
    ),
    appPage(
      name: Routes.resumeReportPage,bindings: [LoginBinding()],
      page: () => ResumeReportPage(
        resumePath: Get.arguments['resumePath'],
        analysisData: Get.arguments['analysisData'],
      ),
    ),
    appPage(
      name: Routes.resumeViewPage,
      page: () => ResumeViewPage(file: Get.arguments as File),
    ),

    appPage(name: Routes.loginPage, page: () => LoginPage()),
    appPage(name: Routes.internshipHomePage, page: () => InternshipHomePage()),
    appPage(
      name: Routes.uploadResumePage,
      page: () => UploadResumePage(),
      bindings: [ResumeBinding()],
    ),
    appPage(name: Routes.profilePage, page: () => ProfilePage()),
    appPage(name: Routes.myApplicationPage, page: () => MyApplicationPage()),
    appPage(name: Routes.settingsPage, page: () => SettingsPage()),
    appPage(
      name: Routes.internshipDetailsPage,
      page: () => InternshipDetailsPage(),
    ),
    appPage(name: Routes.internshipListPage, page: () => InternshipListPage()),
    appPage(name: Routes.kycCollegeIdPage, page: () => KycCollegeIdPage()),
    appPage(name: Routes.uploadSelfiePage, page: () => UploadSelfiePage()),
    appPage(name: Routes.manageResumePage, page: () => ManageResumePage()),
    appPage(
      name: Routes.changePhoneNumberPage,
      page: () => ChangePhoneNumberPage(),
    ),
    appPage(name: Routes.changeEmailPage, page: () => ChangeEmailPage()),
    appPage(
      name: Routes.manageLinkedAccountsPage,
      page: () => ManageLinkedAccountsPage(),
    ),
    appPage(name: Routes.registerPage, page: () => RegisterPage()),
    appPage(
      name: Routes.applicationStatusPage,
      page: () => ApplicationStatusPage(),
    ),
    appPage(
      name: Routes.accountSettingsPage,
      page: () => AccountSettingsPage(),
    ),
    appPage(name: Routes.resumeScreen, page: () => ResumeScreen()),
    appPage(
      name: Routes.resumeLoadedPage,
      page: () => ResumeLoadedPage(file: Get.arguments as File),
    ),
    appPage(
      name: Routes.reviewUploadSelfie,
      page: () => ReviewUploadSelfie(imagePath: Get.arguments as String),
    ),

    appPage(name: Routes.appPreferencesPage, page: () => AppPreferencesPage()),
  ];
}

// // import 'package:flutter/material.dart';
// //
// // class AppPageRoute extends PageRouteBuilder {
// //   final Widget page;
// //
// //   AppPageRoute({required this.page})
// //       : super(
// //     pageBuilder: (context, animation, secondaryAnimation) => page,
// //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
// //       return FadeTransition(
// //         opacity: animation,
// //         child: child,
// //       );
// //     },
// //     transitionDuration: const Duration(milliseconds: 250),
// //   );
// // }
