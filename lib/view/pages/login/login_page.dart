// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/provider.dart';
// // // import 'package:internsharks/const_file/app_button.dart';
// // // import 'package:internsharks/const_file/app_colors.dart';
// // // import 'package:internsharks/const_file/app_text_style.dart';
// // // import 'package:internsharks/routes/app_pages.dart';
// // // import 'dart:async';
// // //
// // // import '../../main.dart';
// // // import 'mail_otp.dart';
// // // import 'mobile_otp.dart';
// // // class LoginPage extends StatefulWidget {
// // //   @override
// // //   _LoginPageState createState() => _LoginPageState();
// // // }
// // //
// // // class _LoginPageState extends State<LoginPage> {
// // //   TextEditingController mobile = TextEditingController();
// // //   TextEditingController email = TextEditingController();
// // //
// // //   bool get valid =>
// // //       mobile.text.length == 10 && email.text.contains("@");
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // // backgroundColor: AppColors.appColor,
// // //       body: Container(
// // //         width: double.infinity,
// // //         padding: EdgeInsets.all(16),
// // //         // 👈 இது image load ஆகும்வரை காட்டும்
// // //         decoration: BoxDecoration(color: AppColors.appColor,
// // //           image: DecorationImage(
// // //               image: AssetImage("lib/asset/images/login_bg.png"),
// // //               fit: BoxFit.cover
// // //           ),
// // //         ),
// // //         // ...
// // //
// // //         child: Column(
// // //
// // //           children: [
// // //             SizedBox(height: 30,),
// // //             logoStep("Step 1 of 3"),
// // //             SizedBox(height: 10,),
// // //             progress(1),
// // //
// // //             SizedBox(height: 20),
// // //             Expanded(
// // //               child: SingleChildScrollView(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text("Enter Mobile Number and Email for Verification",
// // //                         style: TextStyle(
// // //                             color: AppColors.appYellow,
// // //                             fontSize: 24,
// // //                             fontWeight: FontWeight.bold)),
// // //
// // //                 SizedBox(height: 10),
// // //                 Text("Let's start with your contact information to secure your account",
// // //                     style: TextStyle(color: Colors.grey,fontSize: 16)),
// // //
// // //                 SizedBox(height: 15),
// // //                 label("Mobile Number"),
// // //                 SizedBox(height: 10),
// // //                 TextFormField(
// // //                   controller: mobile,
// // //                   keyboardType: TextInputType.phone,cursorColor: Colors.white,
// // //                   style: TextStyle(color: Colors.white),
// // // maxLength: 10,  inputFormatters: [
// // //                   FilteringTextInputFormatter.digitsOnly, // 👉 ONLY NUMBERS
// // //                 ],
// // //                   decoration: InputDecoration(
// // //                     hintText: "Enter your mobile number",
// // //                     hintStyle: TextStyle(color: Colors.grey),
// // //
// // //                     filled: true,
// // //                     fillColor: Color(0xFF0E1A1C),
// // //                     counterText: "${mobile.text.length}/10",
// // //                     counterStyle: AppTextStyles.white16bold , // 👉 hides 0/10 text
// // //                     contentPadding: EdgeInsets.symmetric(vertical: 18),
// // //
// // //                     // ✅ +91 inside textform field
// // //                     prefixIcon: Padding(
// // //                       padding: EdgeInsets.only(left: 15, right: 10),
// // //                       child: Text(
// // //                         "+91",
// // //                         style: TextStyle(color: Colors.white, fontSize: 16),
// // //                       ),
// // //                     ),
// // //                     prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
// // //
// // //                     // ✅ default border
// // //                     enabledBorder: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       borderSide: BorderSide(color: Colors.white24, width: 2),
// // //                     ),
// // //
// // //                     // ✅ focused border
// // //                     focusedBorder: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       borderSide: BorderSide(color: Colors.cyan, width: 2.5),
// // //                     ),
// // //
// // //                     // ✅ error border
// // //                     errorBorder: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       borderSide: BorderSide(color: Colors.red, width: 2),
// // //                     ),
// // //
// // //                     focusedErrorBorder: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       borderSide: BorderSide(color: Colors.red, width: 2.5),
// // //                     ),
// // //                   ),
// // //
// // //                   validator: (value) {
// // //                     if (value == null || value.isEmpty) {
// // //                       return "Please enter mobile number";
// // //                     }
// // //                     if (value.length != 10) {
// // //                       return "Mobile number must be 10 digits";
// // //                     }
// // //                     return null;
// // //                   },
// // //
// // //                   onChanged: (_) => setState(() {}),
// // //                 )
// // //                 ,
// // //                 SizedBox(height: 20),
// // //                 label("Email Address"),
// // //                 SizedBox(height: 10),
// // //                 TextFormField(
// // //                   controller: email,cursorColor: Colors.white,
// // //                   keyboardType: TextInputType.emailAddress,
// // //                   style: TextStyle(color: Colors.white),
// // //
// // //                   onChanged: (_) => setState(() {}),
// // //                   decoration: InputDecoration(    filled: true,
// // //                     fillColor: Color(0xFF0E1A1C),
// // //                     hintText: "Enter your email",
// // //                     hintStyle: TextStyle(color: Colors.grey),
// // //
// // //                     // ✅ default border (yellow)
// // //                     enabledBorder: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       borderSide: BorderSide(
// // //                         color: Colors.white24, // starting border color
// // //                         width: 2,
// // //                       ),
// // //                     ),
// // //
// // //                     // ✅ when focused (on tap)
// // //                     focusedBorder: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       borderSide: BorderSide(
// // //                         color: Colors.cyan, // change to app color
// // //                         width: 2.5,
// // //                       ),
// // //                     ),
// // //
// // //                     // ✅ when error
// // //                     errorBorder: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       borderSide: BorderSide(color: Colors.red, width: 2),
// // //                     ),
// // //                     focusedErrorBorder: OutlineInputBorder(
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       borderSide: BorderSide(color: Colors.red, width: 2.5),
// // //                     ),
// // //                   ),
// // //                 )
// // //                 ,
// // //
// // //                 SizedBox(height: 120,),
// // //
// // //                 Center(
// // //                   child: button(
// // //                     text: "Continue",
// // //                     enabled: valid,
// // //                     onTap: () {
// // //                       Navigator.push(
// // //                         context,
// // //                         AppPageRoute(page: MobileOtp(    mobile: mobile.text.trim(),email: email.text.trim())));
// // //                     },
// // //                   ),
// // //                 ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:async';
// // import 'package:flutter/gestures.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import 'package:get/get_instance/src/extension_instance.dart';
// // import 'package:internsharks/controllers/login_controller.dart';
// // import 'package:internsharks/core/const_file/app_button.dart';
// // import 'package:internsharks/core/const_file/app_colors.dart';
// // import 'package:internsharks/core/const_file/app_text_style.dart';
// // import 'package:internsharks/pages/login/register_page.dart';
// // import 'package:internsharks/screens/home_Screen.dart';
// //
// // class LoginPage extends StatefulWidget {
// //  LoginPage({super.key});
// //
// //   @override
// //   State<LoginPage> createState() => _LoginPageState();
// //
// //
// //   /// COMMON INPUT FIELD (DESIGN SAME)
// //   static Widget inputField({
// //     String? prefix,
// //     required String hint,
// //     required TextEditingController controller,
// //     int maxLength = 10,
// //     void Function(String)? onChanged,
// //   }) {
// //     return TextField(
// //       controller: controller,
// //       onChanged: onChanged,
// //       maxLength: maxLength,
// //       style: const TextStyle(color: Colors.white),
// //       keyboardType: TextInputType.number,
// //       decoration: InputDecoration(
// //         counterText: "",
// //         hintText: hint,
// //         hintStyle: const TextStyle(color: Colors.grey),
// //         filled: true,
// //         fillColor: const Color(0xFF1A1F24),
// //         prefixText: prefix != null ? "$prefix  " : null,
// //         prefixStyle: const TextStyle(color: Colors.white),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(14),
// //           borderSide: const BorderSide(color: Colors.white24),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(14),
// //           borderSide: const BorderSide(color: Colors.cyan),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class _LoginPageState extends State<LoginPage> {
// //   final mobileCtrl = TextEditingController();
// //   final otpCtrl = TextEditingController();
// //
// //   bool otpSent = false;
// //   bool canResend = false;
// //   int seconds = 30;
// //   Timer? timer;
// //
// //   bool get isMobileValid => mobileCtrl.text.length == 10;
// //   bool get isOtpValid => otpCtrl.text.length == 6;
// //
// //   void sendOtp() {
// //     setState(() {
// //       otpSent = true;
// //       canResend = false;
// //       seconds = 30;
// //     });
// //     startTimer();
// //     // 👉 Send OTP API here
// //   }
// //
// //   void startTimer() {
// //     timer?.cancel();
// //     timer = Timer.periodic(const Duration(seconds: 1), (t) {
// //       if (seconds == 0) {
// //         t.cancel();
// //         setState(() => canResend = true);
// //       } else {
// //         setState(() => seconds--);
// //       }
// //     });
// //   }
// //
// //   void login() {
// //     // 👉 Verify OTP API
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (_) => const HomeScreen()),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     timer?.cancel();
// //     mobileCtrl.dispose();
// //     otpCtrl.dispose();
// //     super.dispose();
// //   }
// //   final LoginController loginC = Get.find<LoginController>();
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.appColor,
// //       body: Container(
// //         padding: const EdgeInsets.all(16),height: double.infinity,
// //         width: double.infinity,
// //         decoration: const BoxDecoration(
// //           image: DecorationImage(
// //             image: AssetImage("asset/images/login_bg.png"),
// //             fit: BoxFit.cover,
// //           ),
// //         ),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const SizedBox(height: 30),
// //
// //               /// LOGO
// //               Image.asset("asset/images/app_logo.png", height: 40),
// //
// //               const SizedBox(height: 20),
// //
// //               /// TITLE
// //               const Text(
// //                 "Welcome Back!",
// //                 style: TextStyle(
// //                   color: AppColors.appYellow,
// //                   fontSize: 32,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 10),
// //
// //               const Text(
// //                 "secure access portal. please enter your\ncredentials.",
// //                 style: TextStyle(color: Colors.white70, fontSize: 16),
// //               ),
// //
// //               const SizedBox(height: 30),
// //
// //               /// MOBILE
// //               const Text("Mobile Number",
// //                   style: TextStyle(color: Colors.white, fontSize: 16)),
// //               const SizedBox(height: 8),
// //
// //               LoginPage.inputField(
// //                 prefix: "+91",
// //                 hint: "Enter your mobile number",
// //                 controller: loginC.mobileCtrl,
// //
// //                 maxLength: 10,
// //                 onChanged: (_) => setState(() {}),
// //               ),
// //
// //               const SizedBox(height: 25),
// //
// //               /// SEND OTP BUTTON
// //               if (!otpSent)
// //
// //                 AppButton.AppContainerButton(
// //                   onTap: loginC.isMobileValid ? loginC.sendOtp : null,
// //
// //                   bgColor:  isMobileValid
// //                       ? AppColors.appBlue
// //                       :  Colors.grey.shade800,
// //                   borderRadius: 45,borderColor:Colors.white24,borderWidth: 1 ,
// //                   text:  "Send OTP",verticalPadding: 12,
// //                   textStyle: AppTextStyles.white22bold,
// //                 ),
// //               /// OTP SECTION
// //               if (otpSent) ...[
// //                 const Text("OTP",
// //                     style: TextStyle(color: Colors.white, fontSize: 16)),
// //                 const SizedBox(height: 8),
// //
// //                 LoginPage.inputField(
// //                   hint: "Enter your OTP",
// //                   controller: otpCtrl,
// //                   maxLength: 6,
// //                   onChanged: (_) => setState(() {}),
// //                 ),
// //
// //                 const SizedBox(height: 10),
// //
// //                 Row(mainAxisAlignment: MainAxisAlignment.end,
// //                   children: [
// //                     canResend
// //                         ? TextButton(
// //                       onPressed: sendOtp,
// //                       child: const Text("Resend OTP"),
// //                     )
// //                         : Text(
// //                       "Resend OTP in $seconds sec",
// //                       style: const TextStyle(color: Colors.white70),
// //                     ),
// //                   ],
// //                 ),
// //
// //                 const SizedBox(height: 30),
// //
// //                 /// LOGIN BUTTON
// //                 AppButton.AppContainerButton(
// //                   onTap:isOtpValid ? login : null,
// //                   bgColor: isOtpValid
// //                       ? AppColors.appBlue
// //                       :  Colors.grey.shade800,
// //                   borderRadius: 45,borderColor:Colors.white24,borderWidth: 1 ,
// //                   text:  "Login",verticalPadding: 12,
// //                   textStyle: AppTextStyles.white22bold,
// //                 ),
// //
// //
// //               ],
// //
// //           SizedBox(height: 25,),
// //
// //               /// REGISTER
// //               Center(
// //                 child: RichText(
// //                   text: TextSpan(
// //                     text: "If you’re new to Internshark, ",
// //                     style: const TextStyle(color: Colors.white70),
// //                     children: [
// //                       TextSpan(
// //                         text: "Register now",
// //                         style: const TextStyle(
// //                           color: Color(0xFFFFC83D),
// //                           decoration: TextDecoration.underline,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                         recognizer: TapGestureRecognizer()
// //                           ..onTap = () {
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (_) => const RegisterPage(),
// //                               ),
// //                             );
// //                           },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //
// //
// //               const SizedBox(height: 20),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/login_controller.dart';
// import '../../core/const_file/app_button.dart';
// import '../../core/const_file/app_colors.dart';
// import '../../core/const_file/app_text_style.dart';
// import '../login/register_page.dart';
// import '../../screens/home_Screen.dart';
//
// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});
//
//   final LoginController loginC = Get.put(LoginController());
//   final TextEditingController mobileField = TextEditingController();
//   final TextEditingController otpField = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 50),
//               Image.asset("asset/images/app_logo.png", height: 40),
//               const SizedBox(height: 20),
//               const Text("Welcome Back!", style: TextStyle(color: AppColors.appYellow, fontSize: 32, fontWeight: FontWeight.bold)),
//               const Text("Secure access portal. Please enter your credentials.", style: TextStyle(color: Colors.white70)),
//               const SizedBox(height: 30),
//
//               /// MOBILE NUMBER
//               inputFormField(
//                 prefix: "+91",
//                 hint: "Enter your mobile number",
//                 controller: mobileField,
//                 maxLength: 10,
//                 onChanged: (val) => loginC.mobileCtrlStr.value = val,
//                 validator: (v) => (v == null || v.length != 10) ? "Enter valid 10 digit number" : null,
//               ),
//
//               const SizedBox(height: 20),
//
//               /// SEND OTP BUTTON
//               Obx(() => loginC.isLoading.value
//                   ? const Center(child: CircularProgressIndicator(color: AppColors.appYellow))
//                   : AppButton.AppContainerButton(
//                 onTap: loginC.isMobileValid ? () => loginC.sendOtp() : null,
//                 bgColor: loginC.isMobileValid ? AppColors.appBlue : Colors.grey.shade800,
//                 text: "Send OTP",
//                 textStyle: AppTextStyles.white22bold,
//               )),
//
//               const SizedBox(height: 30),
//
//               /// OTP FIELD
//               inputFormField(
//                 hint: "Enter your OTP",
//                 controller: otpField,
//                 maxLength: 6,
//                 onChanged: (val) => loginC.otpCtrlStr.value = val,
//                 validator: (v) => (v == null || v.length != 6) ? "Invalid OTP" : null,
//               ),
//
//               const SizedBox(height: 10),
//
//               /// RESEND TIMER
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Obx(() => loginC.canResend.value
//                     ? TextButton(onPressed: loginC.sendOtp, child: const Text("Resend OTP", style: TextStyle(color: AppColors.appYellow)))
//                     : Text("Resend OTP in ${loginC.seconds.value}s", style: const TextStyle(color: Colors.white70))),
//               ),
//
//               const SizedBox(height: 20),
//
//               /// LOGIN BUTTON
//               Obx(() => AppButton.AppContainerButton(onTap: loginC.isOtpValid
//                   ? () => Get.offAllNamed('/internshipHome')
//                   : null,
//                 bgColor: loginC.isOtpValid ? AppColors.appBlue : Colors.grey.shade800,
//                 text: "Login",
//                 textStyle: AppTextStyles.white22bold,
//               )),
//
//               const SizedBox(height: 30),
//
//               /// REGISTER LINK
//               Center(
//                 child: RichText(
//                   text: TextSpan(
//                     text: "If you’re new to Internshark,",
//                     style: const TextStyle(color: Colors.white70),
//                     children: [
//                       TextSpan(
//                         text: "Register now",
//                         style: const TextStyle(color: Color(0xFFFFC83D), decoration: TextDecoration.underline),
//                         recognizer: TapGestureRecognizer()..onTap = () => Get.to(() => const RegisterPage()),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   static Widget inputFormField({
//     String? prefix,
//     required String hint,
//     required TextEditingController controller,
//     required Function(String) onChanged,
//     int maxLength = 10,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       onChanged: onChanged,
//       maxLength: maxLength,
//       keyboardType: TextInputType.number,
//       validator: validator,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         counterText: "",
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.grey),
//         filled: true,
//         fillColor: const Color(0xFF1A1F24),
//         prefixText: prefix != null ? "$prefix  " : null,
//         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white24)),
//         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.cyan)),
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/login_controller.dart';
import '../../../core/const_file/app_button.dart';
import '../../../core/const_file/app_colors.dart';
import '../../../core/const_file/app_text_style.dart';
import '../../../core/routes/app_pages.dart';
import 'register_page.dart';

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
            image: AssetImage("asset/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Image.asset("asset/images/app_logo.png", height: 40),
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
                            Get.toNamed(Routes.uploadResumePage);
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
      Get.offAllNamed(Routes.internshipHomePage);
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
