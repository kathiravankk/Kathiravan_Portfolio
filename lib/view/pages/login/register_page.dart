import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internsharks/controllers/resigter_controller.dart';
import 'package:internsharks/controllers/resume_controller.dart';
import 'package:internsharks/core/const_file/app_button.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/login_controller.dart';

class RegisterPage extends StatefulWidget {
  final String? preFillMobile;
  final String? preFillEmail;

  const RegisterPage({super.key, this.preFillMobile, this.preFillEmail});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController usertype = TextEditingController();
  final TextEditingController mobileOtp = TextEditingController();
  final TextEditingController emailOtp = TextEditingController();
  final RegisterFlowController controller = Get.find<RegisterFlowController>();

  final RegisterFlowController registerCtrl =
      Get.find<RegisterFlowController>();
  final LoginController loginC = Get.find<LoginController>();
  final ResumeController resumeController = Get.find<ResumeController>();
  String? filePath;

  // Observable states
  final RxBool mobileOtpSent = false.obs;
  final RxBool emailOtpSent = false.obs;
  final RxBool mobileVerified = false.obs;
  final RxBool emailVerified = false.obs;

  final RxInt mobileResendTimer = 0.obs;
  final RxInt emailResendTimer = 0.obs;

  final RxBool isLoadingMobile = false.obs;
  final RxBool isLoadingEmail = false.obs;
  final RxBool isVerifyingMobile = false.obs;
  final RxBool isVerifyingEmail = false.obs;

  Timer? mobileTimer;
  Timer? emailTimer;
  final isSaving = false.obs;
  final ResumeController resumeCtrl = Get.find();

  @override
  void initState() {
    super.initState();
    name.text =
        resumeController.resumeAnalyzeModel.resumeData!.personalInfo!.name!;

    String rawMobile =
        resumeController.resumeAnalyzeModel.resumeData!.personalInfo!.phone!;

    mobile.text = rawMobile.replaceAll("+91", "").replaceAll(" ", "").trim();

    email.text =
        resumeController.resumeAnalyzeModel.resumeData!.personalInfo!.email!;
  }

  @override
  void dispose() {
    mobileTimer?.cancel();
    emailTimer?.cancel();
    name.dispose();
    mobile.dispose();
    email.dispose();
    mobileOtp.dispose();
    emailOtp.dispose();
    super.dispose();
  }

  bool get canSendMobileOtp => mobile.text.length == 10;

  bool get canSendEmailOtp => email.text.contains("@") && email.text.length > 5;

  bool get canVerify =>
      name.text.isNotEmpty && mobileVerified.value && emailVerified.value;

  void startMobileTimer() {
    mobileResendTimer.value = 30;
    mobileTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mobileResendTimer.value > 0) {
        mobileResendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void startEmailTimer() {
    emailResendTimer.value = 30;
    emailTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (emailResendTimer.value > 0) {
        emailResendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // 📤 Send Mobile OTP
  Future<void> sendMobileOtp() async {
    if (!canSendMobileOtp) return;

    isLoadingMobile.value = true;

    try {
      loginC.mobile.value = mobile.text;
      await loginC.sendMobileOtp();

      // Check if user is already registered based on message
      final msg = loginC.commonPostModel.message?.toLowerCase() ?? "";
      if (msg.contains("already") || msg.contains("exist")) {
        _showSnackBar("Mobile number already registered", Colors.red);
        return;
      }

      mobileOtpSent.value = true;
      startMobileTimer();
    } catch (e) {
    } finally {
      isLoadingMobile.value = false;
    }
  }

  // 🔁 Resend Mobile OTP
  void resendMobileOtp() {
    if (mobileResendTimer.value == 0) {
      mobileOtp.clear();
      sendMobileOtp();
    }
  }

  // 🔁 Resend Email OTP
  void resendEmailOtp() {
    if (emailResendTimer.value == 0) {
      emailOtp.clear();
      sendEmailOtp();
    }
  }

  // ✅ Verify Mobile OTP
  Future<void> verifyMobileOtp() async {
    if (mobileOtp.text.length != 4) {
      _showSnackBar("Please enter valid 4-digit OTP", Colors.red);
      return;
    }

    isVerifyingMobile.value = true;

    try {
      await loginC.verifyMobileOtp(mobile: mobile.text, otp: mobileOtp.text);

      if (loginC.getResponseCode() == 200) {
        mobileVerified.value = true;
        mobileTimer?.cancel();
      } else {
        ;
      }
    } catch (e) {
    } finally {
      isVerifyingMobile.value = false;
    }
  }

  Future<void> sendEmailOtp() async {
    if (!canSendEmailOtp) return;

    isLoadingEmail.value = true;
    emailOtpSent.value = false; // 🔴 reset first

    try {
      await loginC.sendEmailOtp(email.text);

      final String msg = (loginC.commonPostModel.message ?? "").toLowerCase();

      /// ✅ SAME AS REACT → OTP SENT SUCCESS
      if (msg.contains("otp sent")) {
        emailOtpSent.value = true; // 🔓 OPEN OTP FIELD
        startEmailTimer();
      } else {
        // ❌ Already registered / error
        emailOtpSent.value = false;
        _showSnackBar(
          loginC.commonPostModel.message ?? "Email already registered",
          Colors.red,
        );
      }
    } catch (e) {
      emailOtpSent.value = false;
      _showSnackBar("Error sending email OTP", Colors.red);
    } finally {
      isLoadingEmail.value = false;
    }
  }


  // ✅ Verify Email OTP
  // Future<void> verifyEmailOtp() async {
  //   if (emailOtp.text.length != 4) {
  //     _showSnackBar("Please enter valid 4-digit OTP", Colors.red);
  //     return;
  //   }
  //
  //   isVerifyingEmail.value = true;
  //
  //   try {
  //     await loginC.verifyEmailOtp(email.text, emailOtp.text);
  //
  //     if (loginC.getResponseCode() == 200) {
  //       emailVerified.value = true;
  //       emailTimer?.cancel();
  //     } else {}
  //   } catch (e) {
  //   } finally {
  //     isVerifyingEmail.value = false;
  //   }
  // }

  // ✅ Verify Email OTP
  Future<void> verifyEmailOtp() async {
    if (emailOtp.text.length != 4) {
      _showSnackBar("Please enter valid 4-digit OTP", Colors.red);
      return;
    }

    isVerifyingEmail.value = true;

    try {
      await loginC.verifyEmailOtp(email.text, emailOtp.text, usertype.text);

      // Wait a bit for response code to be set
      await Future.delayed(const Duration(milliseconds: 300));

      if (loginC.getResponseCode() == 200) {
        emailVerified.value = true;
        emailTimer?.cancel();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        // _showSnackBar("Email verified successfully!", Colors.green);
      } else {
        // _showSnackBar("Invalid OTP. Please try again.", Colors.red);
        emailOtp.clear(); // Clear wrong OTP
      }
    } catch (e) {
      // _showSnackBar("Email verification failed. Please try again.", Colors.red);
      emailOtp.clear();
    } finally {
      isVerifyingEmail.value = false;
    }
  }


  // Future<void> saveAndContinue() async {
  //   isSaving.value = true;
  //
  //   try {
  //     await resumeCtrl.saveResumeData();
  //
  //     await Future.delayed(const Duration(milliseconds: 300));
  //
  //     if (resumeCtrl.resumeAnalyzeModel.success == true) {
  //       // ✅ filename backend-la save aagiduchu
  //       Get.offAllNamed(Routes.homeScreen);
  //     } else {
  //       _showSnackBar(
  //         "Resume save failed",
  //         Colors.red,
  //       );
  //     }
  //   } catch (e) {
  //     _showSnackBar(
  //       "Something went wrong",
  //       Colors.red,
  //     );
  //   } finally {
  //     isSaving.value = false;
  //   }
  // }

  // 🎯 Final Submit
  // Future<void> saveAndContinue() async {
  //   if (!canVerify) return;
  //
  //   // Both verified, proceed to next step
  //   Get.offAllNamed(Routes.homeScreen);
  // }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            height: double.infinity,
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
                  const SizedBox(height: 30),
                  _buildHeader(),
                  const SizedBox(height: 10),

                  const Text(
                    "Let's get you\nVerified",
                    style: TextStyle(
                      color: AppColors.appYellow,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Complete the steps below to secure your Identity",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 25),

                  /// NAME FIELD
                  _buildNameSection(),

                  const SizedBox(height: 20),

                  /// MOBILE SECTION
                  _buildMobileSection(),

                  const SizedBox(height: 20),

                  /// EMAIL SECTION
                  _buildEmailSection(),

                  const SizedBox(height: 40),

                  /// FINAL BUTTON
                  _buildFinalButton(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          /// FULL PAGE LOADER
          Obx(() {
            if (!loginC.loginLoading) return const SizedBox();

            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.appYellow,
                  strokeWidth: 4,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==================== UI SECTIONS ====================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 150,
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/app_logo.png"),
            ),
          ),
        ),
        const Text(
          "Step 1 of 3",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Name"),
        TextField(
          controller: name,
          enabled: false,
          style: const TextStyle(color: Colors.white),
          decoration: _decoration("Name from resume", verified: true),
        ),
      ],
    );
  }

  Widget _buildMobileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Mobile Number"),

        // Mobile + Send OTP Button
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: mobile,
                maxLength: 10,
                keyboardType: TextInputType.number,
                enabled: false,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.white),
                decoration: _decoration(
                  "Mobile from resume",
                  prefix: "+91",
                  verified: mobileVerified.value,
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildMobileSendButton(),
          ],
        ),

        // Mobile OTP Input (if OTP sent)
        Obx(() {
          if (mobileOtpSent.value && !mobileVerified.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: mobileOtp,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration("Enter Code"),
                        onChanged: (val) {
                          if (val.length == 4) {
                            // Auto verify when 4 digits entered
                            verifyMobileOtp();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildMobileVerifyButton(),
                  ],
                ),

                // Resend Option
                // const SizedBox(height: 10),
                // Obx(() => Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     mobileResendTimer.value > 0
                //         ? Text(
                //       "Resend in ${mobileResendTimer.value}s",
                //       style: const TextStyle(color: Colors.white70),
                //     )
                //         : TextButton(
                //       onPressed: resendMobileOtp,
                //       child: const Text(
                //         "Resend OTP",
                //         style: TextStyle(color: AppColors.appYellow),
                //       ),
                //     ),
                //   ],
                // )),
              ],
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Email Address"),

        // Email + Send OTP Button
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: email,
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration(
                  "Email from resume",
                  verified: emailVerified.value,
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildEmailSendButton(),
          ],
        ),

        // Email OTP Input (if OTP sent)
        Obx(() {
          if (emailOtpSent.value && !emailVerified.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailOtp,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration("Enter Code"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildEmailVerifyButton(),
                  ],
                ),
              ],
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }

  // ==================== BUTTONS ====================

  Widget _buildMobileSendButton() {
    return Obx(
      () => SizedBox(
        height: 55,
        child: ElevatedButton(
          onPressed: mobileVerified.value
              ? null
              : (mobileOtpSent.value && mobileResendTimer.value == 0
                    ? resendMobileOtp
                    : (canSendMobileOtp && !isLoadingMobile.value
                          ? sendMobileOtp
                          : null)),
          style: ElevatedButton.styleFrom(
            backgroundColor: mobileVerified.value ? Colors.green : Colors.cyan,
            disabledBackgroundColor: Colors.grey.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoadingMobile.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  mobileVerified.value
                      ? "Verified"
                      : (mobileOtpSent.value && mobileResendTimer.value > 0)
                      ? "${mobileResendTimer.value}s"
                      : (mobileOtpSent.value ? "Resend" : "Send OTP"),
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget _buildMobileVerifyButton() {
    return Obx(
      () => SizedBox(
        height: 55,
        child: ElevatedButton(
          onPressed: isVerifyingMobile.value ? null : verifyMobileOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isVerifyingMobile.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text("Verify", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildEmailSendButton() {
    return Obx(
      () => SizedBox(
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            /// ✅ Already verified → no action
            if (emailVerified.value) return;

            /// 🔄 Resend OTP
            if (emailOtpSent.value && emailResendTimer.value == 0) {
              resendEmailOtp();
              return;
            }

            /// 📩 Send OTP (first time)
            if (!emailOtpSent.value &&
                canSendEmailOtp &&
                !isLoadingEmail.value) {
              sendEmailOtp();
              return;
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: emailVerified.value ? Colors.green : Colors.cyan,
            disabledBackgroundColor: Colors.grey.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoadingEmail.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  emailVerified.value
                      ? "Verified"
                      : emailOtpSent.value && emailResendTimer.value > 0
                      ? "${emailResendTimer.value}s"
                      : emailOtpSent.value
                      ? "Resend"
                      : "Send OTP",
                  style: const TextStyle(color: Colors.white),
                ),
        ),

        // ElevatedButton(
        //   onPressed: emailVerified.value
        //       ? null
        //       : (emailOtpSent.value && emailResendTimer.value == 0
        //       ? resendEmailOtp
        //       : (!emailOtpSent.value &&
        //       canSendEmailOtp &&
        //       !isLoadingEmail.value
        //       ? sendEmailOtp
        //       : null)),
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor:
        //     emailVerified.value ? Colors.green : Colors.cyan,
        //     disabledBackgroundColor: Colors.grey.shade700,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(14),
        //     ),
        //   ),
        //   child: isLoadingEmail.value
        //       ? const SizedBox(
        //     width: 20,
        //     height: 20,
        //     child: CircularProgressIndicator(
        //       color: Colors.white,
        //       strokeWidth: 2,
        //     ),
        //   )
        //       : Text(
        //     emailVerified.value
        //         ? "Verified"
        //         : (emailOtpSent.value && emailResendTimer.value > 0)
        //         ? "${emailResendTimer.value}s"
        //         : (emailOtpSent.value
        //         ? "Resend"
        //         : "Send OTP"),
        //     style: const TextStyle(color: Colors.white),
        //   ),
        // ),
      ),
    );
  }

  Widget _buildEmailVerifyButton() {
    return Obx(
      () => SizedBox(
        height: 55,
        child: ElevatedButton(
          onPressed: isVerifyingEmail.value ? null : verifyEmailOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isVerifyingEmail.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text("Verify", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  // Widget _buildFinalButton() {
  //   return Obx(
  //     () => AppButton.AppContainerButton(
  //       onTap: canVerify ? saveAndContinue : null,
  //       bgColor: canVerify ? AppColors.appBlue : Colors.grey.shade800,
  //       borderRadius: 45,
  //       borderColor: Colors.white24,
  //       borderWidth: 1,
  //       text: "Save & Continue",
  //       verticalPadding: 12,
  //       textStyle: AppTextStyles.white22bold,
  //     ),
  //   );
  // }
  Widget _buildFinalButton() {
    return Obx(() {
      final isDisabled = isSaving.value;

      return AppButton.AppContainerButton(
        onTap: isDisabled
            ? null
            : () async {
                await  controller.onSaveAndContinue();
              },
        bgColor: isDisabled ? Colors.grey.shade800 : AppColors.appBlue,
        borderRadius: 45,
        borderColor: Colors.white24,
        borderWidth: 1,
        text: isSaving.value ? "Saving..." : "Save & Continue",
        verticalPadding: 12,
        textStyle: AppTextStyles.white22bold,
      );
    });
  }

  // ==================== HELPERS ====================

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  InputDecoration _decoration(
    String hint, {
    String? prefix,
    bool verified = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: verified
          ? Colors.green.withOpacity(0.2)
          : const Color(0xFF0E1A1C),
      counterText: "",
      prefixText: prefix != null ? "$prefix " : null,
      prefixStyle: const TextStyle(color: Colors.white),
      suffixIcon: verified
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: verified ? Colors.green : Colors.white24,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.cyan, width: 2.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
    );
  }
}
