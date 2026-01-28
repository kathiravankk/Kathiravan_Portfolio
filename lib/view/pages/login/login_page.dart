import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/login_controller.dart';
import '../../../core/const_file/app_button.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import '../../../core/const_file/app_text_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ✅ GetX Controller
  final LoginController loginC = Get.find<LoginController>();

  final TextEditingController mobileField = TextEditingController();
  final TextEditingController otpField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Image.asset("assets/images/app_logo.png", height: 40),
              const SizedBox(height: 20),

              const Text(
                "Welcome Back!",
                style: TextStyle(
                  color: AppColors.appYellow,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "Secure access portal. Please enter your\ncredentials.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const SizedBox(height: 30),

              /// ---------------- MOBILE FIELD ----------------
              const Text(
                "Mobile Number",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),

              inputFormField(
                prefix: "+91",
                hint: "Enter your mobile number",
                controller: mobileField,
                maxLength: 10,
                onChanged: (val) {
                  loginC.mobile.value = val;
                },
              ),

              const SizedBox(height: 25),

              /// ---------------- OTP / BUTTON SECTION ----------------
          Obx(() {
            // ⏳ Loader
            if (loginC.loginLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.appYellow,
                ),
              );
            }

            // 🔐 OTP FIELD (OTP SENT TRUE)
            if (loginC.otpSent == true) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "OTP",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  inputFormField(
                    hint: "Enter your OTP",
                    controller: otpField,
                    maxLength: 4,
                    onChanged: (val) {
                      loginC.otp.value = val;
                    },
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      loginC.canResend.value
                          ? TextButton(
                        onPressed: () => loginC.loginSendMobileOtp(),
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(color: AppColors.appYellow),
                        ),
                      )
                          : Text(
                        "Resend OTP in ${loginC.seconds.value}s",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  AppButton.AppContainerButton(
                    onTap: loginC.verifyLoading
                        ? null
                        : () async {
                      await verifyOtpFunc();
                    },
                    bgColor: loginC.verifyLoading
                        ? Colors.grey.shade800
                        : AppColors.appBlue,
                    borderRadius: 45,
                    borderColor: Colors.white24,
                    borderWidth: 1,
                    text: loginC.verifyLoading
                        ? "Verifying..."
                        : "Verify & Continue",
                    verticalPadding: 12,
                    textStyle: AppTextStyles.white22bold,
                  ),
                ],
              );
            }

            // 📤 SEND OTP BUTTON (OTP NOT SENT)
            return AppButton.AppContainerButton(
              onTap: loginC.mobile.value.length == 10
                  ? () => loginC.loginSendMobileOtp()
                  : null,
              bgColor: loginC.mobile.value.length == 10
                  ? AppColors.appBlue
                  : Colors.grey.shade800,
              borderRadius: 30,
              text: "Send OTP",
              verticalPadding: 12,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            );
          })
,

              const SizedBox(height: 30),

              /// ---------------- REGISTER LINK ----------------
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "If you’re new to Internshark, ",
                    style: const TextStyle(color: Colors.white70),
                    children: [
                      TextSpan(
                        text: "Register now",
                        style: const TextStyle(
                          color: Color(0xFFFFC83D),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoutes.uploadResumePage);
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
    );
  }

  Future<void> verifyOtpFunc() async {
    await loginC.loginVerifyMobileOtp(mobile: mobileField.text, otp: otpField.text);
    if (loginC.getResponseCode() == 200) {
      Get.offAllNamed(AppRoutes.internshipHomePage);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
    }
  }

  /// ---------------- INPUT FIELD HELPER ----------------
  Widget inputFormField(
      {
    String? prefix,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    int maxLength = 10,
  }
  ) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLength: maxLength,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1A1F24),
        prefixText: prefix != null ? "$prefix  " : null,
        prefixStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.cyan),
        ),
      ),
    );
  }
}
