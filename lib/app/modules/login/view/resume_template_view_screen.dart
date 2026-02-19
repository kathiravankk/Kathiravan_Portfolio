import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/show_template_view.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/resume_template_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class ResumeTemplateViewScreen extends StatefulWidget {
  const ResumeTemplateViewScreen({super.key});

  @override
  State<ResumeTemplateViewScreen> createState() =>
      _ResumeTemplateViewScreenState();
}

class _ResumeTemplateViewScreenState extends State<ResumeTemplateViewScreen> {
  ResumeTemplateModel? templateData;
  ExtractedResumeDataModel? resumeData;
  bool? isChatFlow;

  final RegisterController registerController = Get.find<RegisterController>();

  @override
  void initState() {
    super.initState();
    templateData = Get.arguments["templateData"];
    resumeData = Get.arguments["resumeData"] ?? {};
    isChatFlow = Get.arguments["isChatFlow"] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.appBgColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Template ${templateData!.id}",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
          actions: [
            Visibility(
              visible: !isChatFlow!,
              child: CustomButtonWidget(
                width: 130,
                height: 35,
                isLoading: registerController.updateResumeTemplateLoading,
                buttonFunction: () async {
                  await updateResumeFunc();
                },
                buttonText: "CONFIRM",
                bgColor: AppColors.appBgColor,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: ShowTemplateView(
          htmlAssetPath: templateData!.htmlPath,
          resumeData: resumeData!,
          //resumeData: ExtractedResumeDataModel(),
        ),
      ),
    );
  }

  Future<void> updateResumeFunc() async {
    // final prefs = await SharedPreferences.getInstance();
    // final studentId = prefs.getString('student_id');
    final studentId = await LocalStorageService.getStudentId();

    resumeData!.templateNumber = templateData!.id.toString();
    resumeData!.studentId = studentId;
    //resumeData!.studentId = "69804fe251caac65dd42e798";
    await registerController.updateResumeProfileData(updateData: resumeData);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message: "Resume updated successfully!",
        isError: false,
      );
      AppFunctions.navigateScreen(
        context,
        AppRoutes.stepUpdateScreen,
        arguments: {"activeStep": 2},
      );
    } else {
      AppFunctions.showToast(
        message:
            registerController.updateProfileModel.message ??
            "Something went wrong!,Please try again later!",
        isError: true,
      );
    }
  }
}
