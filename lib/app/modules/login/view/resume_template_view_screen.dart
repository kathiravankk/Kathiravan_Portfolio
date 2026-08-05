import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/show_template_view.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/account/resume_template_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class ResumeTemplateViewScreen extends StatefulWidget {
  final ResumeTemplateModel? templateData;
  final ExtractedResumeDataModel? resumeData;
  final bool? isChatFlow;

  const ResumeTemplateViewScreen({
    super.key,
    this.templateData,
    this.resumeData,
    this.isChatFlow,
  });

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
    // Use passed-in constructor parameters first; fall back to Get.arguments if navigated via route
    templateData = widget.templateData ?? Get.arguments?["templateData"];
    resumeData = widget.resumeData ?? Get.arguments?["resumeData"];
    isChatFlow = widget.isChatFlow ?? Get.arguments?["isChatFlow"] ?? false;
  }

  @override
  void didUpdateWidget(covariant ResumeTemplateViewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update state variables when parent passes updated props in Live Preview
    if (widget.templateData != oldWidget.templateData) {
      templateData = widget.templateData;
    }
    if (widget.resumeData != oldWidget.resumeData) {
      resumeData = widget.resumeData;
    }
    if (widget.isChatFlow != oldWidget.isChatFlow) {
      isChatFlow = widget.isChatFlow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (templateData == null || resumeData == null) {
      return const SizedBox();
    }

    return Obx(
          () => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.appBackgroundImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: AppColors.transparentColor,
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
                visible: !(isChatFlow ?? false),
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
              const SizedBox(width: 10),
            ],
          ),
          body: ShowTemplateView(
            htmlAssetPath: templateData!.htmlPath,
            resumeData: resumeData!,
          ),
        ),
      ),
    );
  }

  Future<void> updateResumeFunc() async {
    final studentId = await LocalStorageService.getStudentId();

    resumeData!.templateNumber = templateData!.id.toString();
    resumeData!.studentId = studentId;

    await registerController.updateResumeProfileData(updateData: resumeData);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      AppAlertUtils.showToast(
        message: "Resume updated successfully!",
        isError: false,
      );
      AppFunctions.navigateScreen(
        context,
        AppRoutes.stepUpdateScreen,
        arguments: {"activeStep": 2},
      );
    } else {
      AppAlertUtils.showToast(
        message:
        registerController.updateProfileModel.message ??
            "Something went wrong!,Please try again later!",
        isError: true,
      );
    }
  }
}
