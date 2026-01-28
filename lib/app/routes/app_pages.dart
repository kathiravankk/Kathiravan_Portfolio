import 'dart:io';
import 'package:get/get.dart';
import 'package:internsharks/app/modules/home/view/dashboard_screen.dart';
import 'package:internsharks/app/modules/login/bindings/login_bindings.dart';
import 'package:internsharks/app/modules/login/view/kyc_verification_screen.dart';
import 'package:internsharks/app/modules/login/view/login_screen.dart';
import 'package:internsharks/app/modules/login/view/register_profile_upload_screen.dart';
import 'package:internsharks/app/modules/login/view/register_resume_report_screen.dart';
import 'package:internsharks/app/modules/login/view/register_resume_upload_screen.dart';
import 'package:internsharks/app/modules/login/view/step_update_screen.dart';
import 'package:internsharks/app/modules/login/view/student_register_screen.dart';
import 'package:internsharks/binding/auth_binding.dart';
import 'package:internsharks/binding/resume_binding.dart';
import '../../view/pages/kyc/kyc_college_id_page.dart';
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
import '../modules/login/view/register_selfie_preview_screen.dart';
import '../../view/pages/upload_selfie/upload_selfie_page.dart';
import '../../view/screens/goto_intern_homepage.dart';
import '../../view/screens/home_Screen.dart';
import '../modules/login/view/splash_screen.dart';

part 'app_routes.dart';

GetPage appPage({
  required String name,
  required page,
  List<Bindings>? bindings,
}) {
  return GetPage(
    name: name,
    page: page,
    bindings: bindings ?? [LoginBindings()],
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 300),
  );
}

class AppPages {
  static final routes = [
    appPage(name: AppRoutes.homeScreen, page: () => HomeScreen()),
    appPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
      bindings: [LoginBindings()],
    ),
    appPage(name: AppRoutes.loginScreen, page: () => LoginScreen()),

    appPage(
      name: AppRoutes.registerResumeUploadScreen,
      page: () => RegisterResumeUploadScreen(),
      bindings: [RegisterBindings()],
    ),
    appPage(
      name: AppRoutes.studentRegisterScreen,
      page: () => StudentRegisterScreen(),
      bindings: [RegisterBindings()],
    ),
    appPage(
      name: AppRoutes.registerResumeReportScreen,
      page: () => RegisterResumeReportScreen(),
      bindings: [RegisterBindings()],
    ),
    appPage(
      name: AppRoutes.registerProfileUpdateScreen,
      page: () => RegisterProfileUploadScreen(),
      bindings: [RegisterBindings()],
    ),
    appPage(
      name: AppRoutes.registerSelfiePreviewScreen,
      page: () => RegisterSelfiePreviewScreen(),
      bindings: [RegisterBindings()],
    ),
    appPage(
      name: AppRoutes.kycVerificationScreen,
      page: () => KycVerificationScreen(),
      bindings: [RegisterBindings()],
    ),
    appPage(name: AppRoutes.stepUpdateScreen, page: () => StepUpdateScreen()),
    appPage(name: AppRoutes.dashBoardScreen, page: () => DashboardScreen()),

    // OTHER SCREEN
    appPage(
      name: AppRoutes.resumeReportPage,
      bindings: [AuthBinding()],
      page: () => ResumeReportPage(
        resumePath: Get.arguments['resumePath'],
        analysisData: Get.arguments['analysisData'],
      ),
    ),
    appPage(
      name: AppRoutes.resumeViewPage,
      page: () => ResumeViewPage(file: Get.arguments as File),
    ),

    appPage(
      name: AppRoutes.internshipHomePage,
      page: () => InternshipHomePage(),
    ),
    appPage(
      name: AppRoutes.uploadResumePage,
      page: () => UploadResumePage(),
      bindings: [ResumeBinding()],
    ),
    appPage(name: AppRoutes.profilePage, page: () => ProfilePage()),
    appPage(name: AppRoutes.myApplicationPage, page: () => MyApplicationPage()),
    appPage(name: AppRoutes.settingsPage, page: () => SettingsPage()),
    appPage(
      name: AppRoutes.internshipDetailsPage,
      page: () => InternshipDetailsPage(),
    ),
    appPage(
      name: AppRoutes.internshipListPage,
      page: () => InternshipListPage(),
    ),
    appPage(name: AppRoutes.kycCollegeIdPage, page: () => KycCollegeIdPage()),
    appPage(name: AppRoutes.uploadSelfiePage, page: () => UploadSelfiePage()),
    appPage(name: AppRoutes.manageResumePage, page: () => ManageResumePage()),
    appPage(
      name: AppRoutes.changePhoneNumberPage,
      page: () => ChangePhoneNumberPage(),
    ),
    appPage(name: AppRoutes.changeEmailPage, page: () => ChangeEmailPage()),
    appPage(
      name: AppRoutes.manageLinkedAccountsPage,
      page: () => ManageLinkedAccountsPage(),
    ),
    appPage(name: AppRoutes.registerPage, page: () => RegisterPage()),
    appPage(
      name: AppRoutes.applicationStatusPage,
      page: () => ApplicationStatusPage(),
    ),
    appPage(
      name: AppRoutes.accountSettingsPage,
      page: () => AccountSettingsPage(),
    ),
    appPage(name: AppRoutes.resumeScreen, page: () => ResumeScreen()),
    appPage(
      name: AppRoutes.resumeLoadedPage,
      page: () => ResumeLoadedPage(file: Get.arguments as File),
    ),
    appPage(
      name: AppRoutes.reviewUploadSelfie,
      page: () => RegisterSelfiePreviewScreen(),
    ),

    appPage(
      name: AppRoutes.appPreferencesPage,
      page: () => AppPreferencesPage(),
    ),
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
