import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/profile_widgets.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/resume_template_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import '../../../core/utils/app_functions.dart' show AppFunctions;
import '../../../core/widgets/resume_thumbnail_card.dart';

class ChatResumeTemplateScreen extends StatefulWidget {
  const ChatResumeTemplateScreen({super.key});

  @override
  State<ChatResumeTemplateScreen> createState() =>
      _ChatResumeTemplateScreenState();
}

class _ChatResumeTemplateScreenState
    extends
        State<ChatResumeTemplateScreen> // {
//   ExtractedResumeDataModel? resumeData;
//
//   int currentTemplateIndex = 0;
//
//   final List<ResumeTemplateModel> templates = List.generate(
//     8,
//         (index) => ResumeTemplateModel(
//       id: 1 + index,
//       htmlPath:
//       'assets/images/html_templates/resume_template_${index + 1}.html',
//       thumbnailPath:
//       'assets/images/templates_thumbnail/resume_thumbnail_${index + 1}.png',
//     ),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     resumeData = Get.arguments["resumeData"];
//   }
//
//   void nextTemplate() {
//     setState(() {
//       currentTemplateIndex =
//           (currentTemplateIndex + 1) % templates.length;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final template = templates[currentTemplateIndex];
//
//     return Scaffold(
//       backgroundColor: AppColors.appBgColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.transparentColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back,
//               size: 25, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           "Resume",
//           style: AppStyles.customTextStyle(
//             size: 18,
//             color: AppColors.whiteColor,
//             weight: FontWeight.w600,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: Row(
//               children: [
//                 const Icon(Icons.monetization_on,
//                     color: Colors.amber, size: 18),
//                 const SizedBox(width: 5),
//                 Text(
//                   "Credit : 100",
//                   style: AppStyles.customTextStyle(
//                     size: 14,
//                     color: AppColors.whiteColor,
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//
//       body: Column(
//         children: [
//
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(25),
//                       child: ShowTemplateView(
//                         htmlAssetPath: template.htmlPath,
//                         resumeData: resumeData!,
//                       ),
//                     ),
//                   ),
//
//                   Positioned(
//                     bottom: 20,
//                     right: 20,
//                     child: FloatingActionButton(
//                       mini: true,
//                       backgroundColor: AppColors.primaryColor,
//                       onPressed: nextTemplate,
//                       child: const Icon(Icons.refresh),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: [
//                 Text(
//                   "Wow! Your Ready to Impress..!",
//                   textAlign: TextAlign.center,
//                   style: AppStyles.customTextStyle(
//                     size: 18,
//                     weight: FontWeight.w600,
//                     color: Colors.yellow,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Your resume shines! It's perfectly crafted to catch employers' eyes, highlighting your unique strengths and achievements. You're ready to make a powerful impression!",
//                   textAlign: TextAlign.center,
//                   style: AppStyles.customTextStyle(
//                     size: 14,
//                     color: AppColors.whiteColor,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: CustomButtonWidget(
//               width: double.infinity,
//               height: 50,
//               buttonText: "Continue",
//               buttonFunction: () {
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
{
  ExtractedResumeDataModel? resumeData;
  bool? isRegisterFlow;

  final RegisterController registerController = Get.find<RegisterController>();

  //final ProfileController profileController = Get.find<ProfileController>();

  int currentTemplateIndex = 0;

  final List<ResumeTemplateModel> templates = List.generate(
    8,
    (index) => ResumeTemplateModel(
      id: 1 + index,
      htmlPath:
          'assets/images/html_templates/resume_template_${index + 1}.html',
      thumbnailPath:
          'assets/images/templates_thumbnail/resume_thumbnail_${index + 1}.png',
    ),
  );

  String studentId = "";

  @override
  void initState() {
    super.initState();
    resumeData = Get.arguments["resumeData"];
    isRegisterFlow = Get.arguments["isRegisterFlow"] ?? true;
    getProfileData();
  }

  Future<void> getProfileData() async {
    studentId = (await LocalStorageService.getStudentId())!;
    await registerController.getStudentProfile(studentId: studentId);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        "Something went wrong!, try again later!",
      );
    }
  }

  void nextTemplate() {
    setState(() {
      currentTemplateIndex = (currentTemplateIndex + 1) % templates.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final template = templates[currentTemplateIndex];

    return Scaffold(
      backgroundColor: AppColors.appBgColor_2,
      appBar: AppBar(
        backgroundColor: AppColors.transparentColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Choose any Resume Template",
          style: AppStyles.customTextStyle(
            size: 18,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => Column(
          spacing: 15,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text(
                //   "🎁 Credit: 100",
                //   style: AppStyles.customTextStyle(
                //     size: 14,
                //     color: AppColors.whiteColor,
                //     weight: FontWeight.w500,
                //   ),
                // ),
                ProfileWidgets.creditContainer(
                  viewFunc: () {},
                  creditCount:
                      registerController
                          .studentProfileModel
                          .studentCreditId!
                          .balance ??
                      0,
                ),
                SizedBox(width: 80),
              ],
            ),
            SizedBox(
              height: 300,
              width: 250,
              child: ResumeThumbnailCard(template: template, onTap: () {}),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blackGradient1, AppColors.blackGradient2],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.heart,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.share,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      AppFunctions.navigateScreen(
                        context,
                        AppRoutes.resumeTemplateViewScreen,
                        arguments: {
                          "templateData": template,
                          "resumeData": resumeData,
                          "isChatFlow": true,
                        },
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.eye,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.arrow_down_doc,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 1.5,
                    color: AppColors.fieldBorderColor,
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: FloatingActionButton(
                      elevation: 0,
                      mini: true,
                      backgroundColor: AppColors.primaryColor,
                      onPressed: () {
                        nextTemplate();
                      },
                      child: const Icon(
                        Icons.refresh,
                        color: AppColors.whiteColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            Text(
              "Wow! Your Ready to Impress..!",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 16,
                weight: FontWeight.w600,
                color: AppColors.secondaryColor,
              ),
            ),
            Text(
              "Your resume shines! It's perfectly crafted to catch employers' eyes.",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),

            CustomButtonWidget(
              width: 200,
              height: 35,
              isLoading: registerController.updateResumeTemplateLoading,
              buttonFunction: () async {
                await updateResumeFunc(template);
              },
              buttonText: "CONTINUE",
              bgColor: AppColors.appBgColor_2,
            ),
            CustomButtonWidget(
              width: 200,
              height: 35,
              buttonFunction: () async {
                AppFunctions.navigateScreen(
                  context,
                  AppRoutes.chatResumeUpdateScreen,
                );
              },
              buttonText: "Update with AI",
              bgColor: AppColors.primaryColor,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> updateResumeFunc(ResumeTemplateModel template) async {
    print(registerController.studentRegisterModel.studentToken ?? "");
    final studentId = await LocalStorageService.getStudentId();

    resumeData!.templateNumber = template.id.toString();
    resumeData!.studentId = studentId;

    await registerController.updateResumeProfileData(updateData: resumeData);

    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message: "Resume updated successfully!",
        isError: false,
      );
      if (isRegisterFlow!) {
        AppFunctions.navigateScreen(
          context,
          AppRoutes.stepUpdateScreen,
          arguments: {"activeStep": 2},
        );
      } else {
        Get.close(2);
      }
    } else {
      AppFunctions.showToast(
        message:
            registerController.updateProfileModel.message ??
            "Something went wrong!",
        isError: true,
      );
    }
  }
}
