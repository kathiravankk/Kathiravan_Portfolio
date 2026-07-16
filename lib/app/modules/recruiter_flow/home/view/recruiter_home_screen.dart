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
import 'package:internsharks/app/modules/recruiter_flow/intern_post/view/select_internship_dialog.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class RecruiterHomeScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const RecruiterHomeScreen({super.key, this.onProfileTap});

  @override
  State<RecruiterHomeScreen> createState() => _RecruiterHomeScreenState();
}

class _RecruiterHomeScreenState extends State<RecruiterHomeScreen> {
  final RecruiterHomeController homeController =
      Get.find<RecruiterHomeController>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getProfileData();
    getStudentsListData();
    super.initState();
  }

  Future<void> getProfileData() async {
    String? recruiterId = await LocalStorageService.getRecruiterId();
    try {
      await homeController.getRecruiterProfileData(recruiterId: recruiterId!);
      if (homeController.getResponseCode() != 200 &&
          homeController.getResponseCode() != 201) {
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
    }
  }

  Future<void> getStudentsListData() async {
    try {
      await homeController.getAllStudentsList();
      if (homeController.getResponseCode() == 200 ||
          homeController.getResponseCode() == 201) {
        // Pass the raw API list to our controller's search/filter engine
        final rawList = homeController.studentListModel.studentList ?? [];
        homeController.initializeStudentData(rawList);
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
          : RefreshIndicator(
              color: AppColors.primaryColor,
              backgroundColor: AppColors.appBgColor_2,
              onRefresh: () async {
                await getProfileData();
                await getStudentsListData();
              },
              child: Scaffold(
                key: scaffoldKey,
                drawer: RecruiterDrawerScreen(),
                backgroundColor: AppColors.transparentColor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColors.transparentColor,
                  title: Row(
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
                      ProfileWidgets.creditContainer(
                        creditCount:
                            homeController
                                .profileModel
                                .recruiterCreditId!
                                .balance ??
                            0,
                        viewFunc: () {
                          AppFunctions.navigateScreen(
                            context,
                            AppRoutes.recruiterCreditPlanScreen,
                            arguments: {
                              "creditBalance": homeController
                                  .profileModel
                                  .recruiterCreditId!
                                  .balance,
                              "creditId": homeController
                                  .profileModel
                                  .recruiterCreditId!
                                  .id,
                            },
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_active_outlined,
                          color: AppColors.secondaryColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    spacing: 15,
                    children: [
                      // CUSTOM SEARCH BAR INTEGRATION
                      _buildIntegratedSearchBar(),

                      // RESULT COUNT HEADER
                      Obx(
                        () => titleRow(
                          title: "Recommended Candidates",
                          subTitle: homeController.filteredStudents.isEmpty
                              ? "0 Results"
                              : "${homeController.filteredStudents.length} Results",
                          buttonFun: () {},
                        ),
                      ),

                      // CANDIDATE GRID VIEW
                      Expanded(
                        child: Obx(() {
                          if (homeController.filteredStudents.isEmpty) {
                            return const Center(
                              child: Text(
                                "No students match your criteria.",
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.only(bottom: 200),
                            itemCount: homeController.filteredStudents.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.65,
                                ),
                            itemBuilder: (context, index) {
                              final student =
                                  homeController.filteredStudents[index];
                              return StudentDetailCard(
                                viewFunc: (){
                                  AppFunctions.navigateScreen(context, AppRoutes.internProfileViewScreen,
                                  arguments: {
                                    "studentId": student.id,
                                  });
                                },
                                isShortList: student.isFavorite ?? false,
                                shortlistFunc: () async {
                                  await homeController.shortlistToggleFunc(
                                    student,
                                  );
                                  // Re-sync UI state list
                                  homeController.filteredStudents.refresh();
                                },
                                requestFunc: () {
                                  Get.dialog(
                                    SelectInternshipDialog(
                                      studentId: student.id ?? "",
                                    ),
                                    barrierDismissible: true,
                                  );
                                },
                                studentName: student.studName ?? "",
                                studentProfile: student.studProfile ?? "",
                                studentDegree: student.studentdegree ?? "",
                                studentCollegeName:
                                    student.studentcollegename ?? "",
                                studentDepartment:
                                    student.studentfieldofstudy ?? "",
                                isVerified: student.isVerified ?? false,
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // --- Integrated Search and Filter Row ---
  Widget _buildIntegratedSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Center(
              child: TextField(
                controller: homeController.searchController,
                onChanged: (value) {
                  homeController.searchQuery.value = value;
                  homeController.applySearchAndFilters();
                },
                textAlign: TextAlign.start,
                // style: AppStyles.customTextStyle(
                //   fontFamily: "Roboto",
                //   color: AppColors.blackColor,
                //   size: 14,
                //   weight: FontWeight.w500,
                // ),
                decoration: InputDecoration(
                  hintText: "Search by student name...",
                  hintStyle: AppStyles.customTextStyle(size: 12, color: AppColors.lightHintText, weight: FontWeight.w500),
                  prefixIcon: const Icon(CupertinoIcons.search, color: AppColors.primaryColor),
                  suffixIcon: Obx(
                    () => homeController.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.redColor),
                            onPressed: () => homeController.clearSearchText(),
                          )
                        : const SizedBox.shrink(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Filter button opens bottom sheet
        GestureDetector(
          onTap: () => _showFilterBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.filter_list, color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }

  // --- Dynamic Bottom Sheet ---
  void _showFilterBottomSheet(BuildContext context) {
    // Keep local selection variables synchronized with controller state when opened
    RxnString tempDegree = RxnString(homeController.selectedDegree.value);
    RxnString tempCollege = RxnString(homeController.selectedCollege.value);
    RxnString tempDepartment = RxnString(
      homeController.selectedDepartment.value,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.recContColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filters",
                      style: AppStyles.customTextStyle(
                        size: 18,
                        weight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // 1. Degree Dynamic Dropdown
                _buildDropdown(
                  label: "Degree",
                  value: tempDegree.value,
                  items: homeController.degreesList,
                  onChanged: (val) => tempDegree.value = val,
                ),
                const SizedBox(height: 15),

                // 2. College Dynamic Dropdown
                _buildDropdown(
                  label: "College Name",
                  value: tempCollege.value,
                  items: homeController.collegesList,
                  onChanged: (val) => tempCollege.value = val,
                ),
                const SizedBox(height: 15),

                // 3. Department Dynamic Dropdown
                _buildDropdown(
                  label: "Field of Study / Department",
                  value: tempDepartment.value,
                  items: homeController.departmentsList,
                  onChanged: (val) => tempDepartment.value = val,
                ),
                const SizedBox(height: 25),

                // Actions: Reset & Apply
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          tempDegree.value = null;
                          tempCollege.value = null;
                          tempDepartment.value = null;
                          homeController.resetFiltersOnly();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryColor),
                        ),
                        child: Text(
                          "Reset Filters",
                          style: AppStyles.customTextStyle(size: 14, color: AppColors.primaryColor, weight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Assign localized temp choices back to persistent controller state
                          homeController.selectedDegree.value =
                              tempDegree.value;
                          homeController.selectedCollege.value =
                              tempCollege.value;
                          homeController.selectedDepartment.value =
                              tempDepartment.value;

                          homeController.applySearchAndFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child:  Text(
                          "Apply",
                          style: AppStyles.customTextStyle(size: 14, color: AppColors.recContColor, weight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          label,
          style:AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.fieldBgColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.fieldBorderColor)
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: AppColors.recContColor,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primaryColor,),
              value: value,
              isDense: true,
              isExpanded: true,
              hint: Text(
                "Select $label",
                style: AppStyles.customTextStyle(size: 12, color: AppColors.greyColor, weight: FontWeight.w500),
              ),
              items: items.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val, style: AppStyles.customTextStyle(
                    fontFamily: "Roboto",
                    color: AppColors.whiteColor,
                    size: 14,
                    weight: FontWeight.w500,
                  )),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
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
            size: 16,
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
