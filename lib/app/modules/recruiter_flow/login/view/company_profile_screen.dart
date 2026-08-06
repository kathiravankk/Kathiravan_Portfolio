import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' hide MultipartFile;
import 'package:get/get.dart' hide MultipartFile;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/home/controller/dashboard_controller.dart';
import 'package:internsharks/app/modules/login/view/kyc_verification_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/recruiter-register_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  // ---- Controllers ----
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyDescriptionController =
      TextEditingController();
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyWebsiteController =
      TextEditingController();

  // ---- State ----
  File? _companyLogo;
  MultipartFile? companyLogoMultipartFile;
  MultipartFile? certificateMultipartFile; // Add this line

  static const int maxLogoSizeBytes = 2 * 1024 * 1024; // 2 MB
  String? selectedIndustry;

  File? _certificateFile;
  String? _certificateFileName;
  double? _certificateSizeInMB;

  static const int maxCertificateSizeBytes = 10 * 1024 * 1024; // 10 MB

  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final RecruiterRegisterController registerController =
      Get.find<RecruiterRegisterController>();

  late String recruiterName;
  late String recruiterEmail;
  late String recruiterMobile;
  late String alternateMobile;
  late String designation;
  late String gender;
  late int employeeCount;
  late String refCode;

  @override
  void initState() {
    getIndustryListData();
    super.initState();
    final args = Get.arguments;
    recruiterName = args["name"];
    recruiterEmail = args["email"];
    recruiterMobile = args["mobile"];
    alternateMobile = args["alternateMobile"];
    designation = args["designation"];
    gender = args["gender"];
    employeeCount = args["employeeCount"];
    refCode = args["refCode"];
  }

  List<String> industryList = [];

  Future<void> getIndustryListData() async {
    try {
      await dashboardController.getCategoryListData();
      if (dashboardController.getResponseCode() == 200 ||
          dashboardController.getResponseCode() == 201) {
        industryList = dashboardController.categoryListModel.categoryList!
            .map((category) => category.categoryName!)
            .toList();
      } else {
        AppFunctions.apiErrorHandling(
          dashboardController.getResponseCode(),
          "Something went wrong!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        dashboardController.getResponseCode(),
        "Something went wrong!",
      );
    }
  }

  @override
  void dispose() {
    companyNameController.dispose();
    companyDescriptionController.dispose();
    companyAddressController.dispose();
    pinCodeController.dispose();
    designationController.dispose();
    contactNumberController.dispose();
    companyEmailController.dispose();
    companyWebsiteController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGO PICKER — same Camera / Gallery pattern you're already using
  // ============================================================
  void _showLogoSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.greyIcon,
                size: 20,
              ),
              title: Text(
                'Choose from Gallery',
                style: AppStyles.customTextStyle(
                  fontFamily: 'Roboto',
                  color: AppColors.blackColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                _pickLogo(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_camera,
                color: AppColors.greyIcon,
                size: 20,
              ),
              title: Text(
                'Take a Photo',
                style: AppStyles.customTextStyle(
                  fontFamily: 'Roboto',
                  color: AppColors.blackColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                _pickLogo(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLogo(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (picked == null) return;

      final file = File(picked.path);
      final sizeInBytes = await file.length();

      if (sizeInBytes > maxLogoSizeBytes) {
        AppAlertUtils.showToast(
          message: 'Logo too large (max 2 MB)',
          isError: true,
        );
        return;
      }

      companyLogoMultipartFile = await MultipartFile.fromFile(
        file.path,
        filename: 'company_logo_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType('image', 'jpeg'),
      );

      setState(() {
        _companyLogo = file;
      });
    } catch (e) {
      AppAlertUtils.showToast(
        message: 'Could not open camera/gallery: $e',
        isError: true,
      );
    }
  }

  // ============================================================
  // CERTIFICATE / CIN DOCUMENT PICKER — PDF / DOC, max 10 MB
  // ============================================================
  Future<void> _pickCertificateFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.single;
      final sizeInBytes = pickedFile.size;

      if (sizeInBytes > maxCertificateSizeBytes) {
        AppAlertUtils.showToast(
          message: 'File too large (max 10 MB)',
          isError: true,
        );
        return;
      }

      if (pickedFile.path == null) {
        AppAlertUtils.showToast(
          message: 'Could not read the selected file',
          isError: true,
        );
        return;
      }

      // Convert the File to Dio's MultipartFile for binary upload
      final docMultipart = await MultipartFile.fromFile(
        pickedFile.path!,
        filename: pickedFile.name,
      );

      setState(() {
        _certificateFile = File(pickedFile.path!);
        certificateMultipartFile = docMultipart; // Store the MultipartFile
        _certificateFileName = pickedFile.name;
        _certificateSizeInMB = sizeInBytes / (1024 * 1024);
      });
    } catch (e) {
      AppAlertUtils.showToast(
        message: 'Could not pick file: $e',
        isError: true,
      );
    }
  }

  void _removeCertificateFile() {
    setState(() {
      _certificateFile = null;
      certificateMultipartFile = null; // Add this line
      _certificateFileName = null;
      _certificateSizeInMB = null;
    });
  }

  // ============================================================
  // INDUSTRY SELECTOR
  // ============================================================

  String industryId = "";

  void showIndustryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.fieldBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: List.generate(industryList.length, (index) {
            final industry = industryList[index];

            return ListTile(
              title: Text(
                industry,
                style: AppStyles.customTextStyle(
                  fontFamily: 'Roboto',
                  color: AppColors.whiteColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              trailing: selectedIndustry == industry
                  ? const Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
              onTap: () {
                setState(() {
                  selectedIndustry = industry;

                  industryId =
                      dashboardController
                          .categoryListModel
                          .categoryList?[index]
                          .categoryId ??
                      "";
                });

                Get.back();
              },
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.transparentColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Company Details",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(
          () => dashboardController.getCategoryLoading
              ? AppAlertUtils.customLoader()
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        Text(
                          "Build Your Profile",
                          style: AppStyles.customTextStyle(
                            size: 30,
                            color: AppColors.secondaryColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Tell us more about your organization to help interns find you.",
                          maxLines: 2,
                          style: AppStyles.customTextStyle(
                            size: 16,
                            color: AppColors.greyTextColor,
                            weight: FontWeight.w400,
                            lineSpace: 1.5,
                          ),
                        ),

                        /// COMPANY LOGO
                        _buildLogoPicker(),

                        /// COMPANY NAME
                        CustomTextField(
                          controller: companyNameController,
                          labelText: "Company Name",
                          hintText: "e.g. Alexander Pierce",
                          isNumberKeyboard: false,
                          prefixWidget: const Icon(
                            CupertinoIcons.person,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),

                        /// INDUSTRY TYPE
                        _buildIndustrySelector(),

                        /// COMPANY DESCRIPTION
                        CustomTextField(
                          controller: companyDescriptionController,
                          labelText: "Company Description",
                          hintText:
                              "Briefly describe your company's mission and culture...",
                          isNumberKeyboard: false,
                          maxLines: 5,
                        ),

                        /// COMPANY ADDRESS
                        CustomTextField(
                          controller: companyAddressController,
                          labelText: "Company Address",
                          hintText: "Enter your address",
                          isNumberKeyboard: false,
                          prefixWidget: const Icon(
                            CupertinoIcons.location,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),

                        /// PINCODE
                        CustomTextField(
                          controller: pinCodeController,
                          labelText: "Pincode",
                          hintText: "Enter your pin",
                          isNumberKeyboard: true,
                          prefixWidget: const Icon(
                            CupertinoIcons.location_solid,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),

                        /// RECRUITER DESIGNATION
                        CustomTextField(
                          controller: designationController,
                          labelText: "Recruiter Designation",
                          hintText: "e.g. Talent Acquisition Manager",
                          isNumberKeyboard: false,
                          prefixWidget: const Icon(
                            CupertinoIcons.briefcase,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),

                        /// COMPANY CONTACT NUMBER
                        CustomTextField(
                          controller: contactNumberController,
                          labelText: "Company Contact Number",
                          hintText: "+91 9876543210",
                          isNumberKeyboard: true,
                          prefixWidget: const Icon(
                            CupertinoIcons.phone,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),

                        /// COMPANY EMAIL
                        CustomTextField(
                          controller: companyEmailController,
                          labelText: "Company Email",
                          hintText: "hr@internshark.com",
                          isNumberKeyboard: false,
                          prefixWidget: const Icon(
                            CupertinoIcons.mail,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),

                        /// COMPANY WEBSITE
                        CustomTextField(
                          controller: companyWebsiteController,
                          labelText: "Company Website",
                          hintText: "https://www.internsharks.com",
                          isNumberKeyboard: false,
                          prefixWidget: const Icon(
                            CupertinoIcons.globe,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),

                        /// INCORPORATION CERTIFICATE / CIN
                        _buildCertificateUploader(),

                        const SizedBox(height: 5),

                        /// BUTTON
                        CustomButtonWidget(
                          isLoading: registerController.registerLoading,
                          buttonText: "Continue to Register",
                          buttonFunction: () async {
                            await validateAndContinue();
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // ============================================================
  // UI BUILDERS
  // ============================================================

  Widget _buildLogoPicker() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 15,
        children: [
          Row(
            children: [
              Text(
                "Company Logo",
                style: AppStyles.customTextStyle(
                  color: AppColors.whiteColor,
                  size: 15,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: _showLogoSourceSheet,
            child: SizedBox(
              width: 130,
              height: 130,
              child: _companyLogo != null
                  ? Stack(
                      children: [
                        ClipOval(
                          child: Image.file(
                            _companyLogo!,
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: AppColors.whiteColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  : CustomPaint(
                      painter: DashPainter(
                        color: AppColors.contBorderColor,
                        radius: 100,
                        dash: 8,
                        gap: 5,
                      ),
                      child: Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(20),
                          child: const Icon(
                            CupertinoIcons.cloud_upload,
                            color: AppColors.whiteColor,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "PNG or JPG up to 2MB. Recommended 400*400px",
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.greyTextColor,
              weight: FontWeight.w400,
              lineSpace: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndustrySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Industry Type",
          style: AppStyles.customTextStyle(
            color: AppColors.whiteColor,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        InkWell(
          onTap: showIndustryPicker,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.fieldBgColor,
              border: Border.all(color: AppColors.fieldBorderColor),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.business,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedIndustry ?? "Select Industry",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: selectedIndustry == null
                          ? AppColors.greyTextColor
                          : AppColors.whiteColor,
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.chevron_down,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCertificateUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Row(
          children: [
            Text(
              "Incorporation Certificate / CIN Number",
              style: AppStyles.customTextStyle(
                color: AppColors.whiteColor,
                size: 15,
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.verified, color: AppColors.primaryColor, size: 16),
          ],
        ),
        InkWell(
          onTap: _certificateFile == null ? _pickCertificateFile : null,
          borderRadius: BorderRadius.circular(12),
          child: CustomPaint(
            painter: DashPainter(
              color: AppColors.contBorderColor,
              radius: 20,
              dash: 8,
              gap: 5,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              child: _certificateFile == null
                  ? Column(
                      children: [
                        const Icon(
                          CupertinoIcons.doc_text,
                          color: AppColors.greyTextColor,
                          size: 34,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Click to upload or drag and drop",
                          style: AppStyles.customTextStyle(
                            size: 14,
                            color: AppColors.whiteColor,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "PDF, DOC up to 10MB",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: AppColors.greyTextColor,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const Icon(
                          CupertinoIcons.doc_fill,
                          color: AppColors.primaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _certificateFileName ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.customTextStyle(
                                  size: 13,
                                  color: AppColors.whiteColor,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${_certificateSizeInMB?.toStringAsFixed(2)} MB",
                                style: AppStyles.customTextStyle(
                                  size: 12,
                                  color: AppColors.greyTextColor,
                                  weight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: _removeCertificateFile,
                          child: const Icon(
                            CupertinoIcons.clear_circled_solid,
                            color: AppColors.greyTextColor,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VALIDATION
  // ============================================================
  Future<void> validateAndContinue() async {
    if (_companyLogo == null) {
      AppAlertUtils.showToast(
        message: "Please upload your company logo!",
        isError: true,
      );
      return;
    }
    final nameError = AppFunctions.validateName(companyNameController.text);
    if (nameError != null) {
      AppAlertUtils.showToast(message: nameError, isError: true);
      return;
    }

    if (selectedIndustry == null) {
      AppAlertUtils.showToast(
        message: "Please select an industry type",
        isError: true,
      );
      return;
    }

    if (companyAddressController.text.trim().isEmpty) {
      AppAlertUtils.showToast(
        message: "Company address is required",
        isError: true,
      );
      return;
    }

    final pincode = pinCodeController.text.trim();
    if (pincode.isEmpty ||
        pincode.length != 6 ||
        int.tryParse(pincode) == null) {
      AppAlertUtils.showToast(
        message: "Enter a valid 6-digit pincode",
        isError: true,
      );
      return;
    }

    if (designationController.text.trim().isEmpty) {
      AppAlertUtils.showToast(
        message: "Recruiter designation is required",
        isError: true,
      );
      return;
    }

    final contactError = AppFunctions.validateIndianMobile(
      contactNumberController.text,
    );
    if (contactError != null) {
      AppAlertUtils.showToast(message: contactError, isError: true);
      return;
    }

    final emailError = AppFunctions.validateEmail(
      newEmail: companyEmailController.text,
      currentEmail: null,
    );
    if (emailError != null) {
      AppAlertUtils.showToast(message: emailError, isError: true);
      return;
    }
    if (companyWebsiteController.text.trim().isEmpty) {
      AppAlertUtils.showToast(
        message: "Company website is required",
        isError: true,
      );
      return;
    }

    // if (_certificateFile == null) {
    //   AppAlertUtils.showToast(
    //     message: "Please upload your Incorporation Certificate",
    //     isError: true,
    //   );
    //   return;
    // }
    await recruiterRegisterFunction();
  }

  String? fcmToken = "";

  Future<void> recruiterRegisterFunction() async {
    fcmToken = await LocalStorageService.getFcmToken() ?? "";
    Map<String, dynamic> registerData = {
      "refcode": refCode,
      "fcmToken": fcmToken,
      "recname": recruiterName,
      "recemail": recruiterEmail,
      "recmobileno": recruiterMobile,
      "recgender": gender,
      "recsecondarymobileno": alternateMobile,
      "recdesignation": designationController.text.trim(),
      "reccompanysize": employeeCount,
      if (companyLogoMultipartFile != null)
        "reccompanylogo": companyLogoMultipartFile,
      "reccompanyname": companyNameController.text.trim(),
      "reccompanyindustrytype": industryId,
      "reccompanydescription": companyDescriptionController.text.trim(),
      "reccompanyaddress": companyAddressController.text.trim(),
      "reccompanypincode": pinCodeController.text.trim(),
      "reccompanycontactno": contactNumberController.text.trim(),
      "reccompanyemail": companyEmailController.text.trim(),
      "reccompanywebsite": companyWebsiteController.text.trim(),
      if (certificateMultipartFile != null)
        "reccompanydocument": certificateMultipartFile, // Passed in binary format
    };
    try {
      await registerController.newRecruiterRegister(registerData: registerData);
      if (registerController.getResponseCode() == 200 ||
          registerController.getResponseCode() == 201) {
        debugPrint("*************************");
        await LocalStorageService.saveRecruiterToken(
          recruiterToken: registerController.registerModel.recToken ?? "",
        );
        await LocalStorageService.saveRecruiterId(
          recruiterId: registerController.registerModel.recruiter!.id ?? "",
        );
        await LocalStorageService.saveRecruiterCreditId(
          creditId:
              registerController.registerModel.recruiter!.recruiterCreditId ??
              "",
        );
        final token = await LocalStorageService.getRecruiterToken();
        debugPrint(token);
        AppAlertUtils.showToast(
          message:
          registerController.registerModel.message ??
              "Registration Successful & Logged in Successfully!",
          isError: false,
        );
        debugPrint("+++++++++++++++++++++++++");
        Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
      } else {
        AppFunctions.apiErrorHandling(
          registerController.getResponseCode(),
          registerController.registerModel.message ?? "Something went wrong!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        registerController.getResponseCode(),
        registerController.registerModel.message ?? "Something went wrong!",
      );
    }
  }
}
