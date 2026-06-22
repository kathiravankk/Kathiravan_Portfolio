import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/profile_widgets.dart';
import 'package:internsharks/app/core/widgets/student_detail_card.dart';
import 'package:internsharks/app/data/models/recruiter_flow/student_list_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/controller/recruiter_home_controller.dart';
import 'package:internsharks/app/modules/recruiter_flow/home/view/recruiter_drawer_screen.dart';

class RecruiterHomeScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const RecruiterHomeScreen({super.key, this.onProfileTap});

  @override
  State<RecruiterHomeScreen> createState() => _RecruiterHomeScreenState();
}

class _RecruiterHomeScreenState extends State<RecruiterHomeScreen> {
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();

  @override
  void initState() {
    getProfileData();
    getStudentsListData();
    super.initState();
  }

  String? recruiterId = "";
  List<StudentDetails>? studentsList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getProfileData() async {
    recruiterId = await LocalStorageService.getRecruiterId();
    try {
      await homeController.getRecruiterProfileData(recruiterId: recruiterId!);
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
      rethrow;
    }
  }

  Future<void> getStudentsListData() async {
    try {
      await homeController.getAllStudentsList();

      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        setState(() {
          studentsList = homeController.studentListModel.studentList ?? [];
        });
      } else {
        AppFunctions.apiErrorHandling(
          homeController.getResponseCode(),
          "Something went wrong, Try again later!",
        );
      }
    } catch (error, stackTrace) {
      debugPrint("Student List Error => $error");
      debugPrintStack(stackTrace: stackTrace);

      AppFunctions.apiErrorHandling(
        homeController.getResponseCode(),
        "Something went wrong, Try again later!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.profileLoading || homeController.studentListLoading
          ? AppAlertUtils.customLoader()
          : Scaffold(
              drawer: RecruiterDrawerScreen(),
              backgroundColor: AppColors.transparentColor,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.transparentColor,
                title: Builder(
                  builder: (context) {
                    return Row(
                      spacing: 15,
                      children: [
                        GestureDetector(
                          onTap: widget.onProfileTap,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.whiteColor,
                            backgroundImage: NetworkImage(
                              homeController.profileModel.recCompanyLogo ?? "",
                            ),
                          ),
                        ),
                        Text(
                          homeController.profileModel.recName ?? "",
                          style: AppStyles.customTextStyle(
                            size: 21,
                            weight: FontWeight.w700,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        const Spacer(),
                        ProfileWidgets.creditContainer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications_active_outlined,
                            color: AppColors.secondaryColor,
                            size: 30,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 15,
                  children: [
                    ProfileWidgets.buildSearchBar(
                      buttonFunc: () {
                        //AppFunctions.navigateScreen(context, AppRoutes.allInternshipScreen);
                      },
                    ),
                    titleRow(
                      title: "Recommented Candidates",
                      subTitle: "${studentsList!.length.toString()} Results",
                      buttonFun: () {},
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.only(bottom: 200),
                        itemCount: studentsList!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.68,
                            ),
                        itemBuilder: (context, index) {
                          return StudentDetailCard(
                            isShortList: studentsList![index].isFavorite ?? false,
                            isLoading:
                                homeController.addShortlistLoading ||
                                homeController.removeShortlistLoading,
                            shortlistFunc: () async {
                              setState(() {});
                              await homeController.shortlistToggleFunc(
                                studentsList![index],
                              );
                              setState(() {});
                            },
                            requestFunc: () {},
                            studentName: studentsList![index].studName ?? "",
                            studentProfile:
                                studentsList![index].studProfile ?? "",
                            studentDegree:
                                studentsList![index].studentdegree ?? "",
                            studentCollegeName:
                                studentsList![index].studentcollegename ?? "",
                            studentDepartment:
                                studentsList![index].studentfieldofstudy ?? "",
                            isVerified:
                                studentsList![index].isVerified ?? false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget titleRow({
    required String title,
    required String subTitle,
    required VoidCallback buttonFun,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.customTextStyle(
            size: 21,
            weight: FontWeight.w700,
            color: AppColors.whiteColor,
          ),
        ),
        TextButton(
          onPressed: buttonFun,
          child: Text(
            subTitle,
            style: AppStyles.customTextStyle(
              size: 13,
              weight: FontWeight.w500,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
