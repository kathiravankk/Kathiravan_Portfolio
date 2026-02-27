import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:http/http.dart' hide MultipartFile;
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/data/repositories/resume_storage_service.dart';
import 'package:internsharks/app/modules/login/controllers/register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController mobileOtpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailOtpController = TextEditingController();

  final RegisterController registerController = Get.find<RegisterController>();

  @override
  void initState() {
    super.initState();
    setInitialData();
  }

  Future<void> setInitialData() async {
    nameController.text =
        registerController.resumeExtractModel.resumeData!.personalInfo!.name ??
        "";
    emailController.text =
        registerController.resumeExtractModel.resumeData!.personalInfo!.email ??
        "";
    mobileController.text =
        registerController.resumeExtractModel.resumeData!.personalInfo!.phone ??
        "";
  }

  @override
  void dispose() {
    super.dispose();
    registerController.showMobileOtpField.value = false;
    registerController.showEmailOtpField.value = false;
    registerController.mobileResendSeconds.value = 0;
    registerController.emailResendSeconds.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
            "Register",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(),
                Text(
                  "Let's get you\n\nVerified",
                  style: AppStyles.customTextStyle(
                    size: 20,
                    color: AppColors.secondaryColor,
                    weight: FontWeight.w700,
                  ),
                ),

                Text(
                  "Complete the steps below to secure your \n\nIdentity",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: nameController,
                  labelText: "Name",
                  isEnabled: true,
                  onChanged: (value) {
                    nameController.text = value;
                  },
                  prefixWidget: Icon(
                    Icons.person_outline_sharp,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  isNumberKeyboard: false,
                  // suffixWidget: Icon(
                  //   Icons.check_circle,
                  //   color: AppColors.sucTextColor,
                  //   size: 20,
                  // ),
                ),
                Obx(() {
                  final isVerified = registerController.isMobileVerified.value;
                  final seconds = registerController.mobileResendSeconds.value;
                  String text;
                  VoidCallback onTap;

                  if (isVerified) {
                    text = "Verified";
                    onTap = () {};
                  } else if (seconds > 0) {
                    text = "Resend($seconds)";
                    onTap = () {};
                  } else {
                    text = "Send OTP";
                    onTap = () async {
                      await sendMobileOtp();
                    };
                  }

                  return Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: mobileController,
                          prefixWidget: Icon(
                            Icons.phone,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                          labelText: "Mobile Number",
                          isEnabled: isVerified ? false : true,
                          onChanged: (value) {
                            mobileController.text = value;
                            print(value);
                          },
                          suffixWidget: Visibility(
                            visible: isVerified,
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.sucTextColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isVerified,
                        child: Expanded(
                          child: CustomButtonWidget(
                            disable: seconds > 0,
                            buttonText: text,
                            isLoading: registerController.sendMobileOtpLoading,
                            buttonFunction: onTap,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Obx(() {
                  if (!registerController.showMobileOtpField.value ||
                      registerController.isMobileVerified.value) {
                    return const SizedBox();
                  }
                  return Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: mobileOtpController,
                          labelText: "Mobile OTP",
                          hintText: "Enter OTP",
                          //width: 230,
                          onChanged: (value) {
                            mobileOtpController.text = value;
                          },
                          maxLength: 4,
                          prefixWidget: Icon(
                            Icons.lock_person_outlined,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomButtonWidget(
                          width: 140,
                          buttonText: registerController.isMobileVerified.value
                              ? "Verified"
                              : "Verify OTP",
                          disable: registerController.isMobileVerified.value,
                          isLoading: registerController.verifyMobileOtpLoading,
                          buttonFunction:
                              registerController.isMobileVerified.value
                              ? () {}
                              : () async {
                                  await verifyMobileOtp();
                                },
                        ),
                      ),
                    ],
                  );
                }),

                Obx(() {
                  final isVerified = registerController.isEmailVerified.value;
                  final seconds = registerController.emailResendSeconds.value;
                  String text;
                  VoidCallback onTap;

                  if (isVerified) {
                    text = "Verified";
                    onTap = () {};
                  } else if (seconds > 0) {
                    text = "Resend($seconds)";
                    onTap = () {};
                  } else {
                    text = "Send OTP";
                    onTap = () async {
                      await sendEmailOtp();
                    };
                  }
                  return Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: emailController,
                          labelText: "Email Address",
                          isEnabled: isVerified ? false : true,
                          prefixWidget: Icon(
                            Icons.mail_outline_sharp,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                          suffixWidget: Visibility(
                            visible: isVerified,
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.sucTextColor,
                              size: 20,
                            ),
                          ),
                          isNumberKeyboard: false,
                          onChanged: (value) {
                            emailController.text = value;
                          },
                        ),
                      ),
                      Visibility(
                        visible: !isVerified,
                        child: Expanded(
                          child: CustomButtonWidget(
                            disable: seconds > 0,
                            buttonText: text,
                            isLoading: registerController.sendEmailOtpLoading,
                            buttonFunction: onTap,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Obx(() {
                  if (!registerController.showEmailOtpField.value ||
                      registerController.isEmailVerified.value) {
                    return const SizedBox();
                  }

                  return Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: emailOtpController,
                          labelText: "Email OTP",
                          hintText: "Enter OTP here..",
                          width: 230,
                          maxLength: 4,
                          prefixWidget: Icon(
                            Icons.lock_outlined,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                          onChanged: (value) {
                            emailOtpController.text = value;
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomButtonWidget(
                          width: 140,
                          buttonText: registerController.isEmailVerified.value
                              ? "Verified"
                              : "Verify OTP",
                          disable: registerController.isEmailVerified.value,
                          isLoading: registerController.verifyEmailOtpLoading,
                          buttonFunction:
                              registerController.isEmailVerified.value
                              ? () {}
                              : () async {
                                  await verifyEmailOtp();
                                },
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 15),
                Obx(() {
                  final enabled =
                      registerController.isMobileVerified.value &&
                      registerController.isEmailVerified.value;

                  return Center(
                    child: CustomButtonWidget(
                      width: 320,
                      buttonText: "Save & Continue",
                      disable: !enabled,
                      isLoading: registerController.studentRegisterLoading,
                      buttonFunction: enabled
                          ? () async {
                              await studentRegisterFunc();
                            }
                          : () {},
                      // buttonFunction: () async {
                      //   //await studentRegisterFunc();
                      //
                      //   //registerController.getStudentProfile(studentId: "6976f0340c772f260cf0528a");
                      //   //registerController.checkResumeScore(resumeUrl: "https://fulupo.selfietoons.com/uploads/1769402419963-Narmatha M.pdf");
                      //   AppFunctions.navigateScreen(
                      //     context,
                      //     AppRoutes.registerResumeReportScreen,
                      //   );
                      // },
                    ),
                  );
                }),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> studentRegisterFunc() async {
    final resumePath = await ResumeStorageService.getResumePath();
    Map<String, dynamic> registerData = {
      "studmobileno": mobileController.text,

      "studemail": emailController.text,

      "studname": nameController.text,
      "studgender":
          registerController
              .resumeExtractModel
              .resumeData!
              .personalInfo!
              .gender ??
          "",

      "studdob": "",

      "studentaddress":
          registerController
              .resumeExtractModel
              .resumeData!
              .personalInfo!
              .location ??
          "",

      "studentdegree":
          registerController
              .resumeExtractModel
              .resumeData!
              .education!
              .college!
              .first
              .degree ??
          "",

      "studentfieldofstudy":
          registerController
              .resumeExtractModel
              .resumeData!
              .education!
              .college!
              .first
              .department ??
          "",

      "studentcollegename":
          registerController
              .resumeExtractModel
              .resumeData!
              .education!
              .college!
              .first
              .institution ??
          "",

      "studcollegestartyear":
          registerController
              .resumeExtractModel
              .resumeData!
              .education!
              .college!
              .first
              .startYear
              ?.toString() ??
          "",

      "studcollegelocation": "",

      "studhighschollname":
          registerController
              .resumeExtractModel
              .resumeData!
              .education!
              .school!
              .higherSecondary
              .institution ??
          "",

      "studhighschoolpercentage":
          registerController
              .resumeExtractModel
              .resumeData!
              .education!
              .school!
              .higherSecondary
              .percentage
              ?.toString() ??
          "",

      "studentsecondaryschoolname":
          registerController
              .resumeExtractModel
              .resumeData!
              .education!
              .school!
              .secondary
              .institution ??
          "",

      "studentsecondaryschoolpercentage":
          registerController
              .resumeExtractModel
              .resumeData!
              .education!
              .school!
              .secondary
              .percentage
              ?.toString() ??
          "",

      "projects": jsonEncode(
        registerController.resumeExtractModel.resumeData!.projects
                ?.map((e) => e.toJson())
                .toList() ??
            [],
      ),

      "areas_of_interest": jsonEncode(
        registerController.resumeExtractModel.resumeData!.areasOfInterest ?? [],
      ),

      "hobbies": jsonEncode(
        registerController.resumeExtractModel.resumeData!.hobbies ?? [],
      ),

      "languages_known": jsonEncode(
        registerController.resumeExtractModel.resumeData!.languages ?? [],
      ),

      "volunteer_experience": jsonEncode(
        registerController.resumeExtractModel.resumeData!.volunteerExperience ??
            [],
      ),

      "leadership": jsonEncode(
        registerController.resumeExtractModel.resumeData!.leadership ?? [],
      ),
      "studentcertificate": jsonEncode(
        registerController.resumeExtractModel.resumeData!.certifications
                ?.map((e) => e.toJson())
                .toList() ??
            [],
      ),

      "achievements": jsonEncode(
        registerController.resumeExtractModel.resumeData!.achievements ?? [],
      ),

      "publications": jsonEncode(
        registerController.resumeExtractModel.resumeData!.publications ?? [],
      ),

      "workshops": jsonEncode(
        registerController.resumeExtractModel.resumeData!.workshops ?? [],
      ),

      "paper_presentations": [],

      "tools_and_technologies": jsonEncode([]),

      "experience": jsonEncode(
        registerController.resumeExtractModel.resumeData!.experience
                ?.map((e) => e.toJson())
                .toList() ??
            [],
      ),

      "internships": jsonEncode(
        registerController.resumeExtractModel.resumeData!.internships ?? [],
      ),

      "industrial_visits": jsonEncode(
        registerController.resumeExtractModel.resumeData!.industrialVisits ??
            [],
      ),

      "trainings": jsonEncode([]),

      "education": jsonEncode(
        registerController.resumeExtractModel.resumeData!.education!.toJson(),
      ),

      // "studprogramminglang": jsonEncode(
      //   registerController.resumeExtractModel.resumeData!.skills ?? [],
      // ),
      // "studprogramminglang":
      //     registerController.resumeExtractModel.resumeData!.skills!.isEmpty
      //     ? "{}"
      //     : "{${registerController.resumeExtractModel.resumeData!.skills!.map((e) => '["$e"]').join(", ")}}",
      // "studprogramminglang": jsonEncode(
      //   registerController.resumeExtractModel.resumeData?.skills ??
      //       [].map((e) => [e]).toList(),
      // ),
      // "studprogramminglang":
      //   (registerController.resumeExtractModel.resumeData?.skills ?? [])
      //       .map((skill) => [skill])
      //       .toList(),
      "studprogramminglang": registerController.resumeExtractModel.resumeData?.skills ?? [],
      "linkedIn":
          registerController
              .resumeExtractModel
              .resumeData!
              .personalInfo!
              .linkedIn ??
          "",

      "github":
          registerController
              .resumeExtractModel
              .resumeData!
              .personalInfo!
              .github ??
          "",

      "portfolio_website": "",

      "student_banner": "",
      "studentresume": await MultipartFile.fromFile(
        resumePath!,
        filename: resumePath.split('/').last,
        contentType: MediaType(
          "application",
          "pdf", // or doc/docx based on file
        ),
      ),
    };

    debugPrint(registerData.toString(), wrapWidth: 1024);
    await registerController.registerNewStudent(registerData: registerData);
    if (registerController.getResponseCode() == 200 ||
        registerController.getResponseCode() == 201) {
      AppFunctions.showToast(
        message:
            registerController.studentRegisterModel.message ??
            "Student registered successfully!",
        isError: false,
      );
      final prefs = await SharedPreferences.getInstance();
      LocalStorageService.saveStudent(
        token: registerController.studentRegisterModel.studentToken!,
        student: registerController.studentRegisterModel.registerData!,
      );
      await prefs.setString(
        LocalStorageService.studentNameKey,
        registerController.studentRegisterModel.registerData!.studentName ?? "",
      );
      // ResumeStorageService.saveNetworkResume(
      //   resumeFile: studentProfileModel.studentResume!,
      // );
      // AppFunctions.navigateScreen(
      //   context,
      //   AppRoutes.registerResumeReportScreen,
      // );
      showAlertDialog();
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.studentRegisterModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }

  Future<void> sendMobileOtp() async {
    await registerController.sendMobileOtp(mobileNumber: mobileController.text);
    if (registerController.getResponseCode() == 200) {
      AppFunctions.showToast(
        message:
            registerController.commonPostModel.message ??
            "OTP sent to your mobile!",
        isError: false,
      );
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.commonPostModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }

  Future<void> verifyMobileOtp() async {
    registerController.verifyMobileOtp(
      mobileNumber: mobileController.text,
      otpNumber: mobileOtpController.text,
    );
    if (registerController.getResponseCode() == 200) {
      AppFunctions.showToast(
        message:
            registerController.commonPostModel.message ??
            "OTP verified successfully!",
        isError: false,
      );
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.commonPostModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }

  Future<void> sendEmailOtp() async {
    await registerController.sendEmailOtp(emailAddress: emailController.text);
    if (registerController.getResponseCode() == 200) {
      AppFunctions.showToast(
        message:
            registerController.commonPostModel.message ??
            "OTP sent to your Email!",
        isError: false,
      );
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.commonPostModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }

  Future<void> verifyEmailOtp() async {
    registerController.verifyEmailOtp(
      emailAddress: emailController.text,
      otpNumber: emailOtpController.text,
    );
    if (registerController.getResponseCode() == 200) {
      AppFunctions.showToast(
        message:
            registerController.commonPostModel.message ??
            "OTP verified successfully!",
        isError: false,
      );
    } else {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.commonPostModel.message ??
            "Something went wrong. Please try again!",
      );
    }
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 170,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/app_logo.png"),
            ),
          ),
        ),
        Text(
          "Step 1 of 3",
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.whiteColor,
            weight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.fieldBgColor,
        title: Image.asset(AssetImages.appLogoImage, height: 30, width: 30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome to InternShark!",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 18,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
            Text(
              "Registration successful! You can access your dashboard now or complete the remaining steps here.!",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w300,
                lineSpace: 1.3,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          CustomButtonWidget(
            buttonFunction: () {
              Get.back();
              AppFunctions.navigateScreen(
                context,
                AppRoutes.registerResumeReportScreen,
              );
            },
            buttonText: "OKAY",
            width: 150,
            height: 40,
          ),
        ],
      ),
    );
  }
}
