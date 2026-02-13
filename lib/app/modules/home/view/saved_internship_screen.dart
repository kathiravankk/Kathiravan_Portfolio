import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_empty_widget.dart';
import 'package:internsharks/app/core/widgets/saved_internship_card.dart';
import 'package:internsharks/app/data/models/home/saved_internship_model.dart';
import 'package:internsharks/app/modules/home/controller/profile_controller.dart';

class SavedInternshipScreen extends StatefulWidget {
  const SavedInternshipScreen({super.key});

  @override
  State<SavedInternshipScreen> createState() => _SavedInternshipScreenState();
}

class _SavedInternshipScreenState extends State<SavedInternshipScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  List<SavedJobData>? savedJobs = [];

  @override
  void initState() {
    super.initState();
    getSavedJobsData();
  }

  Future<void> getSavedJobsData() async {
    await profileController.getSavedJobsData();

    if (profileController.getResponseCode() == 200 ||
        profileController.getResponseCode() == 201) {
      savedJobs = profileController.savedJobModel.jobData ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.loginBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Saved Internships",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => profileController.savedJobsLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.secondaryColor,
                  ),
                )
              : savedJobs!.isNotEmpty
              ? ListView.separated(
                  padding: EdgeInsets.all(15),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: savedJobs!.length,
                  itemBuilder: (context, index) => SavedInternshipCard(
                    jobTitle: savedJobs![index].job!.title ?? "",
                    companyLogo: savedJobs![index].job!.companyLogo ?? "",
                    postedDate: savedJobs![index].job!.createdAt ?? "",
                    companyName: savedJobs![index].job!.companyName ?? "",
                  ),
                )
              : CustomEmptyWidget(),
        ),
      ),
    );
  }
}
