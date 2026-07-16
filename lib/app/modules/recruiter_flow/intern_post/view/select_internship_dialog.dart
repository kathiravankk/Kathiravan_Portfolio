import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class SelectInternshipDialog extends StatefulWidget {
  final String studentId;

  const SelectInternshipDialog({super.key, required this.studentId});

  @override
  State<SelectInternshipDialog> createState() => _SelectInternshipDialogState();
}

class _SelectInternshipDialogState extends State<SelectInternshipDialog> {
  final InternshipPostController postController =
      Get.find<InternshipPostController>();

  final RxSet<String> selectedJobIds = <String>{}.obs;

  @override
  void initState() {
    super.initState();
    getInternshipData();
  }

  String? recruiterId = "";

  Future<void> getInternshipData() async {
    recruiterId = await LocalStorageService.getRecruiterId();
    try {
      await postController.getPostedInternships(recruiterId: recruiterId!);
      if (postController.getResponseCode() == 200 ||
          postController.getResponseCode() == 201) {
      } else {
        AppFunctions.apiErrorHandling(
          postController.getResponseCode(),
          postController.internPostModel.message ??
              "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        postController.getResponseCode(),
        postController.internPostModel.message ??
            "Something went wrong!, Try again later",
      );
    }
  }

  void toggleSelection(String jobId) {
    if (jobId.isEmpty) return;
    if (selectedJobIds.contains(jobId)) {
      selectedJobIds.remove(jobId);
    } else {
      selectedJobIds.add(jobId);
    }
  }

  Future<void> sendRequest() async {
    if (selectedJobIds.isEmpty) {
      AppAlertUtils.showToast(
        message: "Please select at least one internship",
        isError: true,
      );
      return;
    }
    try {
      await postController.sendInternshipRequest(
        internshipData: {
          "studentId": widget.studentId,
          "jobIds": selectedJobIds.toList(),
        },
      );
      if (postController.getResponseCode() == 200 ||
          postController.getResponseCode() == 201) {
        Get.back();
        AppAlertUtils.showToast(message: "Request sent successfully");
      } else {
        AppFunctions.apiErrorHandling(
          postController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        postController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparentColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),

        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.alertGradColor, AppColors.alertGradColor2],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.whiteColor.withOpacity(0.08)),
        ),
        child: Obx(() {
          if (postController.internPostLoading) {
            return AppAlertUtils.customLoader();
          }

          final jobs = postController.internPostModel.jobs ?? [];

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              headerRow(),
              const SizedBox(height: 18),
              if (jobs.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CustomEmptyWidget(),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: jobs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return Obx(
                        () => internshipTile(
                          job: job,
                          isSelected: selectedJobIds.contains(job.id),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              actionRow(),
            ],
          );
        }),
      ),
    );
  }

  Widget headerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Select Internship",
          style: AppStyles.customTextStyle(
            size: 18,
            weight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        CustomButtonWidget(
          width: 100,
          height: 35,
          bgColor: AppColors.secondaryColor,
          buttonFunction: () {
            Get.back();
            AppFunctions.navigateScreen(context, AppRoutes.postNewInternshipScreen);
          },
          buttonWidget: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              const Icon(Icons.add, size: 16, color: AppColors.blackColor),
              Text(
                "New Post",
                style: AppStyles.customTextStyle(
                  size: 12,
                  weight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget internshipTile({required PostData job, required bool isSelected}) {
    return GestureDetector(
      onTap: () => toggleSelection(job.id ?? ""),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.cardColor2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.whiteColor,
              backgroundImage:
                  (job.companyLogo != null && job.companyLogo!.isNotEmpty)
                  ? NetworkImage(job.companyLogo!)
                  : null,
              child: (job.companyLogo == null || job.companyLogo!.isEmpty)
                  ? const Icon(Icons.business, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                spacing: 7,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.companyName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.customTextStyle(
                      size: 16,
                      weight: FontWeight.w700,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.work_outline,
                        size: 14,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 200,
                        child: Text(
                          job.roleType ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.customTextStyle(
                            size: 12,
                            weight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        job.companyCity ?? "",
                        style: AppStyles.customTextStyle(
                          size: 12,
                          weight: FontWeight.w500,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            selectionIndicator(isSelected),
          ],
        ),
      ),
    );
  }

  Widget selectionIndicator(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primaryColor : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : Colors.white38,
          width: 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
    );
  }

  Widget actionRow() {
    return Obx(
      () => Row(
        spacing: 15,
        children: [
          Expanded(
            child: CustomButtonWidget(
              height: 45,
              buttonFunction: () async {
                await sendRequest();
              },
              isLoading: postController.sendRequestLoading,
              buttonWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.location_fill,
                    size: 18,
                    color: AppColors.blackColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Send Request",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CustomButtonWidget(
              buttonFunction: () {
                Get.back();
              },
              bgColor: AppColors.appBgColor_2,
              buttonText: "Cancel",
              height: 45,
            ),
          ),
        ],
      ),
    );
  }
}
