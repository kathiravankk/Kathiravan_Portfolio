import 'dart:io';
import 'package:get/get.dart';
import 'package:internsharks/app/modules/home/bindings/dashboard_bindings.dart';
import 'package:internsharks/app/modules/home/view/buy_credit_screen.dart';
import 'package:internsharks/app/modules/home/view/my_applies_screen.dart';
import 'package:internsharks/app/modules/home/view/privacy_policy_screen.dart';
import 'package:internsharks/app/modules/home/view/terms_and_conditions_screen.dart';
import 'package:internsharks/app/modules/internship/view/internship_syllabus_screen.dart';
import 'package:internsharks/app/modules/internship/view/mcq_result_review_screen.dart';
import 'package:internsharks/app/modules/internship/view/mcq_test_screen.dart';
import 'package:internsharks/app/modules/home/view/resume_template_preview_screen.dart';
import 'package:internsharks/app/modules/home/view/search_all_internship_screen.dart';
import 'package:internsharks/app/modules/home/view/category_wise_internship_screen.dart';
import 'package:internsharks/app/modules/home/view/chat_resume_update_screen.dart';
import 'package:internsharks/app/modules/home/view/dashboard_screen.dart';
import 'package:internsharks/app/modules/home/view/internship_detail_screen.dart';
import 'package:internsharks/app/modules/internship/view/my_certificates_screen.dart';
import 'package:internsharks/app/modules/profile/view/home_profile_screen.dart';
import 'package:internsharks/app/modules/profile/view/profile_edit_screen.dart';
import 'package:internsharks/app/modules/profile/view/profile_screen.dart';
import 'package:internsharks/app/modules/home/view/recommented_internship_screen.dart';
import 'package:internsharks/app/modules/home/view/resume_file_view_screen.dart';
import 'package:internsharks/app/modules/home/view/saved_internship_screen.dart';
import 'package:internsharks/app/modules/internship/view/syllabus_detail_view_screen.dart';
import 'package:internsharks/app/modules/home/view/trendy_category_screen.dart';
import 'package:internsharks/app/modules/login/bindings/login_bindings.dart';
import 'package:internsharks/app/modules/login/view/chat_resume_creation_screen.dart';
import 'package:internsharks/app/modules/login/view/chat_resume_template_screen.dart';
import 'package:internsharks/app/modules/login/view/kyc_verification_screen.dart';
import 'package:internsharks/app/modules/login/view/login_screen.dart';
import 'package:internsharks/app/modules/login/view/register_profile_upload_screen.dart';
import 'package:internsharks/app/modules/login/view/register_resume_report_screen.dart';
import 'package:internsharks/app/modules/login/view/resume_template_selection_screen.dart';
import 'package:internsharks/app/modules/login/view/register_resume_upload_screen.dart';
import 'package:internsharks/app/modules/login/view/resume_template_view_screen.dart';
import 'package:internsharks/app/modules/login/view/step_update_screen.dart';
import 'package:internsharks/app/modules/login/view/student_register_screen.dart';
import 'package:internsharks/binding/auth_binding.dart';
import 'package:internsharks/binding/resume_binding.dart';
import '../../view/pages/kyc/kyc_college_id_page.dart';
import '../../view/pages/login/register_page.dart';
import '../../view/pages/others/115.dart';
import '../../view/pages/others/117.dart';
import '../../view/pages/others/200.dart';
import '../modules/home/view/account_setting_screen.dart';
import '../../view/pages/others/appPreferences_age.dart';
import '../modules/home/view/application_status_screen.dart';
import '../modules/profile/view/email_update_screen.dart';
import '../modules/profile/view/mobile_update_screen.dart';
import '../../view/pages/others/internship_details_page.dart';
import '../modules/home/view/manage_resume_screen.dart';
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
      name: AppRoutes.resumeTemplateSelectionScreen,
      page: () => ResumeTemplateSelectionScreen(),
      bindings: [RegisterBindings()],
    ),
    appPage(
      name: AppRoutes.resumeTemplateViewScreen,
      page: () => ResumeTemplateViewScreen(),
    ),
    appPage(
      name: AppRoutes.chatResumeTemplateScreen,
      page: () => ChatResumeTemplateScreen(),
      bindings: [ProfileBindings()]
    ),
    appPage(
      name: AppRoutes.chatResumeUpdateScreen,
      page: () => ChatResumeUpdateScreen(),
    ),
    appPage(
      name: AppRoutes.kycVerificationScreen,
      page: () => KycVerificationScreen(),
      bindings: [RegisterBindings(), ProfileBindings()],
    ),
    appPage(
      name: AppRoutes.chatResumeCreation,
      page: () => ChatResumeCreationScreen(),
      bindings: [RegisterBindings()],
    ),
    appPage(
      name: AppRoutes.stepUpdateScreen,
      page: () => StepUpdateScreen(),
      bindings: [ProfileBindings()],
    ),
    appPage(
      name: AppRoutes.dashBoardScreen,
      page: () => DashboardScreen(),
      bindings: [DashboardBindings(), RegisterBindings(), ProfileBindings()],
    ),
    appPage(
      name: AppRoutes.trendyCategoryScreen,
      page: () => TrendyCategoryScreen(),
      bindings: [DashboardBindings()],
    ),
    appPage(
      name: AppRoutes.categoryWiseInternshipScreen,
      page: () => CategoryWiseInternshipScreen(),
      bindings: [DashboardBindings()],
    ),
    appPage(
      name: AppRoutes.internshipDetailScreen,
      page: () => InternshipDetailScreen(),
      bindings: [DashboardBindings()],
    ),
    appPage(
      name: AppRoutes.allInternshipScreen,
      page: () => SearchAllInternshipScreen(),
    ),
    appPage(
      name: AppRoutes.recommentedInternshipScreen,
      page: () => RecommentedInternshipScreen(),
      bindings: [DashboardBindings()],
    ),
    appPage(
      name: AppRoutes.applicationStatusScreen,
      page: () => ApplicationStatusScreen(),
      bindings: [DashboardBindings()],
    ),
    appPage(
      name: AppRoutes.studentProfileScreen,
      page: () => ProfileScreen(),
      bindings: [DashboardBindings()],
    ),
    appPage(
      name: AppRoutes.accountSettingScreen,
      page: () => AccountSettingScreen(),
      bindings: [ProfileBindings()],
    ),
    appPage(
      name: AppRoutes.mobileUpdateScreen,
      page: () => MobileUpdateScreen(),
      bindings: [ProfileBindings()],
    ),
    appPage(
      name: AppRoutes.emailUpdateScreen,
      page: () => EmailUpdateScreen(),
      bindings: [ProfileBindings()],
    ),

    appPage(
      name: AppRoutes.manageResumeScreen,
      page: () => ManageResumeScreen(),
      bindings: [ProfileBindings()],
    ),
    appPage(
      name: AppRoutes.resumeTemplatePreviewScreen,
      page: () => ResumeTemplatePreviewScreen(),
      bindings: [ProfileBindings()],
    ),
    appPage(
      name: AppRoutes.savedInternshipScreen,
      page: () => SavedInternshipScreen(),
      bindings: [ProfileBindings()],
    ),

    appPage(
      name: AppRoutes.resumeFileViewScreen,
      page: () => ResumeFileViewScreen(),
      bindings: [ProfileBindings()],
    ),
    appPage(
      name: AppRoutes.internshipSyllabusScreen,
      page: () => InternshipSyllabusScreen(),
    ),
    appPage(
      name: AppRoutes.syllabusViewScreen,
      page: () => SyllabusDetailViewScreen(),
    ),
    appPage(name: AppRoutes.mcqTestScreen, page: () => McqTestScreen()),
    appPage(
      name: AppRoutes.mcqResultReviewScreen,
      page: () => McqResultReviewScreen(),
    ),
    appPage(
      name: AppRoutes.myCertificatesScreen,
      page: () => MyCertificatesScreen(),
    ),
    appPage(
      name: AppRoutes.privacyPolicyScreen,
      page: () => PrivacyPolicyScreen(),
    ),
    appPage(
      name: AppRoutes.termsAndConditionsScreen,
      page: () => TermsAndConditionsScreen(),
    ),
    appPage(
      name: AppRoutes.profileEditScreen,
      page: () => ProfileEditScreen(),
    ),
    appPage(
      name: AppRoutes.buyCreditsScreen,
      page: () => BuyCreditScreen(),
    ),
    appPage(
      name: AppRoutes.homeProfileScreen,
      page: () => HomeProfileScreen(),
    ),
    appPage(
      name: AppRoutes.myAppliesScreen,
      page: () => MyAppliesScreen(),
    ),

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
    appPage(name: AppRoutes.manageResumePage, page: () => ManageResumeScreen()),
    appPage(
      name: AppRoutes.changePhoneNumberPage,
      page: () => MobileUpdateScreen(),
    ),
    appPage(name: AppRoutes.changeEmailPage, page: () => EmailUpdateScreen()),
    appPage(
      name: AppRoutes.manageLinkedAccountsPage,
      page: () => ManageLinkedAccountsPage(),
    ),
    appPage(name: AppRoutes.registerPage, page: () => RegisterPage()),
    appPage(
      name: AppRoutes.applicationStatusPage,
      page: () => ApplicationStatusScreen(),
    ),
    appPage(
      name: AppRoutes.accountSettingsPage,
      page: () => AccountSettingScreen(),
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
