import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/core/widgets/custom_text_field.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/recruiter_login_controller.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';

class RecruiterLoginScreen extends StatefulWidget {
  const RecruiterLoginScreen({super.key});

  @override
  State<RecruiterLoginScreen> createState() => _RecruiterLoginScreenState();
}

class _RecruiterLoginScreenState extends State<RecruiterLoginScreen> {
  final RecruiterLoginController loginController =
  Get.find<RecruiterLoginController>();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appScreenBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Image.asset(AssetImages.appLogoNew, height: 40, width: 160),
                const SizedBox(height: 5),
                Text(
                  "Welcome to",
                  style: AppStyles.customTextStyle(
                    color: AppColors.whiteColor,
                    size: 33,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Hire Talent",
                  style: AppStyles.customTextStyle(
                    color: AppColors.secondaryColor,
                    size: 48,
                    weight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: 100,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.screenDivColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Text(
                  "Find Top Talent and build your dream team. Please login to continue",
                  style: AppStyles.customTextStyle(
                    lineSpace: 1.4,
                    color: AppColors.whiteColor,
                    size: 16,
                    weight: FontWeight.w400,
                  ),
                ),

                /// ---------------- MOBILE FIELD ----------------
                const SizedBox(height: 10),
                Obx(
                  () => CustomTextField(
                    labelText: "Mobile Number",
                    prefixWidget: _buildCountryCodePicker(loginController.otpSent),
                    hintText: loginController.selectedCountryCode.value == "+91"
                        ? "Enter your mobile number"
                        : "Enter mobile number",
                    controller: mobileController,
                    maxLength: loginController.selectedCountryCode.value == "+91" ? 10 : 15,
                    isEnabled: !loginController.otpSent,
                    onChanged: (val) {
                      loginController.mobile.value = val;

                      final error = loginController.validateMobileNumber(val);
                      final expectedLength =
                          loginController.selectedCountryCode.value == "+91" ? 10 : 15;

                      if (error != null && val.length == expectedLength) {
                        AppAlertUtils.showToast(message: error, isError: true);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),

                /// ---------------- OTP / BUTTON SECTION ----------------
                Obx(() {
                  // ⏳ Loader
                  if (loginController.loginOtpLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.secondaryColor,
                      ),
                    );
                  }

                  // 🔐 OTP FIELD (OTP SENT TRUE)
                  if (loginController.otpSent == true) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "OTP sent to ${loginController.selectedCountryCode.value} ${mobileController.text}",
                              style: AppStyles.customTextStyle(
                                size: 13,
                                color: AppColors.lightWhiteCont,
                                weight: FontWeight.w400,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                loginController.otpSent = false;
                                otpController.clear();
                              },
                              child: Text(
                                "Change",
                                style: AppStyles.customTextStyle(
                                  size: 13,
                                  color: AppColors.secondaryColor,
                                  weight: FontWeight.w600,
                                  isUnderlined: true,
                                  underlineColor: AppColors.secondaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        CustomTextField(
                          labelText: "OTP",
                          hintText: "Enter your OTP",
                          prefixWidget: Icon(
                            Icons.lock_outline_sharp,
                            size: 20,
                            color: AppColors.primaryColor,
                          ),
                          controller: otpController,
                          maxLength: 4,
                          onChanged: (val) {
                            loginController.otp.value = val;
                          },
                        ),

                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            loginController.canResend.value
                                ? TextButton(
                              onPressed: () => sendOtpFunc(
                                mobileNumber: mobileController.text,
                              ),
                              child: Text(
                                "Resend OTP",
                                style: AppStyles.customTextStyle(
                                  size: 16,
                                  weight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                  isUnderlined: true,
                                  underlineColor: AppColors.primaryColor,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            )
                                : Text(
                              "Resend OTP in ${loginController.seconds.value}s",
                              style: AppStyles.customTextStyle(
                                size: 16,
                                weight: FontWeight.w500,
                                color: AppColors.primaryColor,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                        CustomButtonWidget(
                          height: 50,
                          buttonFunction: loginController.loginVerifyLoading
                              ? () {}
                              : () async {
                            FocusScope.of(context).unfocus();
                            await verifyOtpFunc();
                          },
                          buttonText: loginController.loginVerifyLoading
                              ? "Verifying..."
                              : "Verify & Continue",
                          disable:
                          loginController.loginVerifyLoading ||
                              otpController.text.length != 4,
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                  final isValid =
                      loginController.validateMobileNumber(
                        loginController.mobile.value,
                      ) ==
                          null;

                  // 📤 SEND OTP BUTTON (OTP NOT SENT)
                  return CustomButtonWidget(
                    height: 50,
                    buttonFunction: isValid
                        ? () => sendOtpFunc(mobileNumber: mobileController.text)
                        : () {},
                    buttonText: "Send OTP",
                    disable: !isValid,
                  );
                }),

                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: AppStyles.customTextStyle(
                          color: Colors.grey,
                          weight: FontWeight.w700,
                          size: 16,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),

                /// ---------------- REGISTER LINK ----------------
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don’t have an account? ",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        lineSpace: 1.4,
                        weight: FontWeight.w300,
                        color: AppColors.lightText,
                      ),
                      children: [
                        TextSpan(
                          text: "Register now",
                          style: AppStyles.customTextStyle(
                            size: 15,
                            weight: FontWeight.w300,
                            lineSpace: 1.4,
                            color: AppColors.secondaryColor,
                            isUnderlined: true,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AppFunctions.navigateScreen(
                                context,
                                AppRoutes.newRecruiterRegisterScreen,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── COUNTRY LIST & PICKER ──────────────────────────────────────────
  final List<Map<String, String>> _countryList = const [
    {"name": "India", "code": "+91", "flag": "🇮🇳"},
    {"name": "United States", "code": "+1", "flag": "🇺🇸"},
    {"name": "United Kingdom", "code": "+44", "flag": "🇬🇧"},
    {"name": "United Arab Emirates", "code": "+971", "flag": "🇦🇪"},
    {"name": "Singapore", "code": "+65", "flag": "🇸🇬"},
    {"name": "Canada", "code": "+1", "flag": "🇨🇦"},
    {"name": "Australia", "code": "+61", "flag": "🇦🇺"},
    {"name": "Germany", "code": "+49", "flag": "🇩🇪"},
    {"name": "France", "code": "+33", "flag": "🇫🇷"},
    {"name": "Malaysia", "code": "+60", "flag": "🇲🇾"},
    {"name": "Saudi Arabia", "code": "+966", "flag": "🇸🇦"},
    {"name": "Qatar", "code": "+974", "flag": "🇶🇦"},
    {"name": "Kuwait", "code": "+965", "flag": "🇰🇼"},
    {"name": "Oman", "code": "+968", "flag": "🇴🇲"},
    {"name": "Bahrain", "code": "+973", "flag": "🇧🇭"},
    {"name": "Philippines", "code": "+63", "flag": "🇵🇭"},
    {"name": "Sri Lanka", "code": "+94", "flag": "🇱🇰"},
    {"name": "Nepal", "code": "+977", "flag": "🇳🇵"},
    {"name": "Bangladesh", "code": "+880", "flag": "🇧🇩"},
    {"name": "Pakistan", "code": "+92", "flag": "🇵🇰"},
    {"name": "Indonesia", "code": "+62", "flag": "🇮🇩"},
    {"name": "Japan", "code": "+81", "flag": "🇯🇵"},
    {"name": "China", "code": "+86", "flag": "🇨🇳"},
    {"name": "South Korea", "code": "+82", "flag": "🇰🇷"},
    {"name": "New Zealand", "code": "+64", "flag": "🇳🇿"},
    {"name": "South Africa", "code": "+27", "flag": "🇿🇦"},
    {"name": "Nigeria", "code": "+234", "flag": "🇳🇬"},
    {"name": "Kenya", "code": "+254", "flag": "🇰🇪"},
    {"name": "Brazil", "code": "+55", "flag": "🇧🇷"},
    {"name": "Mexico", "code": "+52", "flag": "🇲🇽"},
    {"name": "Ireland", "code": "+353", "flag": "🇮🇪"},
    {"name": "Netherlands", "code": "+31", "flag": "🇳🇱"},
    {"name": "Switzerland", "code": "+41", "flag": "🇨🇭"},
    {"name": "Sweden", "code": "+46", "flag": "🇸🇪"},
    {"name": "Spain", "code": "+34", "flag": "🇪🇸"},
    {"name": "Italy", "code": "+39", "flag": "🇮🇹"},
  ];

  Widget _buildCountryCodePicker(bool isOtpSent) {
    return GestureDetector(
      onTap: isOtpSent ? null : () => _showCountryPicker(),
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loginController.selectedCountryFlag.value,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 4),
            Text(
              loginController.selectedCountryCode.value,
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.whiteColor,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 3),
            const Icon(
              CupertinoIcons.chevron_down,
              color: Color(0xFF64748B),
              size: 11,
            ),
            const SizedBox(width: 8),
            Container(
              width: 1,
              height: 22,
              color: const Color(0xFF1E293B),
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker() {
    final searchController = TextEditingController();
    final RxList<Map<String, String>> filteredCountries =
        RxList<Map<String, String>>(_countryList);

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Color(0xFF0F1A28),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 10, bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Country Code',
                    style: AppStyles.customTextStyle(
                      size: 16,
                      color: AppColors.whiteColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      color: Color(0xFF94A3B8),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF162534),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF1E3547)),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: Color(0xFF64748B),
                      size: 16,
                    ),
                    hintText: 'Search country or code...',
                    hintStyle: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (val) {
                    final query = val.toLowerCase().trim();
                    if (query.isEmpty) {
                      filteredCountries.value = _countryList;
                    } else {
                      filteredCountries.value = _countryList.where((c) {
                        return c['name']!.toLowerCase().contains(query) ||
                            c['code']!.toLowerCase().contains(query);
                      }).toList();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  itemCount: filteredCountries.length,
                  separatorBuilder: (_, index) => const Divider(
                    color: Color(0xFF162534),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];
                    final isSelected =
                        loginController.selectedCountryCode.value ==
                            country['code'];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      leading: Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Text(
                        country['name']!,
                        style: AppStyles.customTextStyle(
                          size: 14,
                          color: AppColors.whiteColor,
                          weight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            country['code']!,
                            style: AppStyles.customTextStyle(
                              size: 13,
                              color: isSelected
                                  ? const Color(0xFF00E5FF)
                                  : const Color(0xFF94A3B8),
                              weight: FontWeight.w600,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.check,
                              color: Color(0xFF00E5FF),
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      onTap: () {
                        loginController.setCountryCode(
                          country['code']!,
                          country['flag']!,
                          country['name']!,
                        );
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> sendOtpFunc({required String mobileNumber}) async {
    final error = loginController.validateMobileNumber(mobileNumber);

    if (error != null) {
      AppAlertUtils.showToast(message: error, isError: true);
      return;
    }

    try {
      otpController.text = "";
      await loginController.sendLoginOtp(mobileNumber: mobileNumber.trim());

      if (!mounted) return;

      if (loginController.getResponseCode() == 200 ||
          loginController.getResponseCode() == 201) {
        if (loginController.commonPostModel.userType != "student") {
          final String userType =
              loginController.commonPostModel.userType?.isNotEmpty == true
                  ? loginController.commonPostModel.userType!
                  : "recruiter";
          await LocalStorageService.saveUserType(userType: userType);
          AppAlertUtils.showToast(
            message:
                loginController.commonPostModel.message?.isNotEmpty == true
                    ? loginController.commonPostModel.message!
                    : "OTP sent successfully to your mobile",
            isError: false,
          );
        } else {
          AppAlertUtils.showAppAlert(
            context: context,
            content:
                "Mobile Number already registered as Student. Please use another Number.",
            confirmText: "OKAY",
            onConfirm: () {
              mobileController.text = "";
              Get.back();
            },
          );
        }
      } else {
        AppFunctions.apiErrorHandling(
          loginController.getResponseCode(),
          loginController.commonPostModel.message ?? "Something went wrong!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        loginController.getResponseCode(),
        loginController.commonPostModel.message ?? "Something went wrong!",
      );
    }
  }

  String? fcmToken = "";

  Future<void> verifyOtpFunc() async {
    try {
      fcmToken = await LocalStorageService.getFcmToken() ?? "";
      debugPrint("FCM Token: $fcmToken");
      await loginController.verifyLoginOtp(
        mobileNumber: mobileController.text.trim(),
        otpNumber: otpController.text.trim(),
        userType: loginController.commonPostModel.userType?.isNotEmpty == true
            ? loginController.commonPostModel.userType!
            : "recruiter",
        fcmToken: fcmToken ?? "",
      );
      if (loginController.getResponseCode() == 200 ||
          loginController.getResponseCode() == 201) {
        await LocalStorageService.saveRecruiterToken(
          recruiterToken: loginController.recruiterLoginModel.recToken ?? "",
        );
        final recruiter = loginController.recruiterLoginModel.recruiter;

        if (recruiter?.recruiterInfo != null) {
          // Coordinator Login
          await LocalStorageService.saveRecruiterId(
            recruiterId: recruiter?.coordinatorId ?? "",
          );

          await LocalStorageService.saveRecruiterCreditId(
            creditId: recruiter?.recruiterCreditId ?? "",
          );

          await LocalStorageService.saveUserType(userType: "coordinator");
        } else {
          // Recruiter Login (Old API)
          await LocalStorageService.saveRecruiterId(
            recruiterId: recruiter?.id ?? "",
          );

          await LocalStorageService.saveRecruiterCreditId(
            creditId: recruiter?.recruiterCreditId ?? "",
          );

          final String userType =
              loginController.commonPostModel.userType?.isNotEmpty == true
                  ? loginController.commonPostModel.userType!
                  : "recruiter";
          await LocalStorageService.saveUserType(userType: userType);
        }

        AppAlertUtils.showToast(
          message:
              loginController.recruiterLoginModel.message ??
              "OTP verified & Logged in successfully!",
          isError: false,
        );
        final token = await LocalStorageService.getRecruiterToken();
        debugPrint("Logged in recruiter token: $token");

        // Hide OTP field and reset form state before navigating
        loginController.otpSent = false;
        otpController.clear();

        Get.offAllNamed(AppRoutes.recruiterDashboardScreen);
      } else {
        AppFunctions.apiErrorHandling(
          loginController.getResponseCode(),
          loginController.recruiterLoginModel.message ??
              "Something went wrong!",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        loginController.getResponseCode(),
        loginController.recruiterLoginModel.message ?? "Something went wrong!",
      );
    }
  }
}