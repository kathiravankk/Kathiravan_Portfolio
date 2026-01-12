// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/provider.dart';
// // //
// // // import 'package:internsharks/core/const_file/app_colors.dart';
// // // import 'package:internsharks/core/routes/app_pages.dart';
// // // import 'package:internsharks/pages/login/mail_otp.dart';
// // // import 'package:internsharks/screens/home_Screen.dart';
// // //
// // // import 'mobile_otp.dart';
// // //
// // // class LoginPage extends StatefulWidget {
// // //   const LoginPage({super.key});
// // //
// // //   @override
// // //   State<LoginPage> createState() => _LoginPageState();
// // // }
// // //
// // // class _LoginPageState extends State<LoginPage> {
// // //   final TextEditingController name = TextEditingController();
// // //   final TextEditingController mobile = TextEditingController();
// // //   final TextEditingController email = TextEditingController();
// // //   final TextEditingController mobileOtp = TextEditingController();
// // //   final TextEditingController emailOtp = TextEditingController();
// // //
// // //   bool get valid =>
// // //       name.text.isNotEmpty &&
// // //       mobile.text.length == 10 &&
// // //       email.text.contains("@");
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: AppColors.appColor,
// // //       body: Container(
// // //         padding: const EdgeInsets.all(16),
// // //         decoration: const BoxDecoration(
// // //           image: DecorationImage(
// // //             image: AssetImage("asset/images/login_bg.png"),
// // //             fit: BoxFit.cover,
// // //           ),
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             const SizedBox(height: 30),
// // //             logoStep("Step 1 of 3"),
// // //
// // //             const SizedBox(height: 30),
// // //
// // //             /// TITLE
// // //             const Text(
// // //               "Let’s get you\nVerified",
// // //               style: TextStyle(
// // //                 color: AppColors.appYellow,
// // //                 fontSize: 32,
// // //                 fontWeight: FontWeight.bold,
// // //               ),
// // //             ),
// // //
// // //             const SizedBox(height: 10),
// // //             const Text(
// // //               "Complete the steps below to secure your Identity",
// // //               style: TextStyle(color: Colors.white70, fontSize: 18),
// // //             ),
// // //
// // //             const SizedBox(height: 25),
// // //
// // //             /// NAME
// // //             _label("Name"),
// // //             _input(controller: name, hint: "Enter your name"),
// // //
// // //             const SizedBox(height: 20),
// // //
// // //             /// MOBILE
// // //             _label("Mobile Number"),
// // //             _otpRow(
// // //               controller: mobile,
// // //               hint: "Enter your mobile number",
// // //               prefix: "+91",
// // //               isNumber: true,
// // //             ),
// // //
// // //             const SizedBox(height: 20),
// // //
// // //             /// EMAIL
// // //             _label("Email Address"),
// // //             _otpRow(controller: email, hint: "Enter your email"),
// // //
// // //             const Spacer(),
// // //
// // //             /// VERIFY BUTTON
// // //             SizedBox(
// // //               width: double.infinity,
// // //               height: 55,
// // //               child: ElevatedButton(
// // //                 onPressed: valid
// // //                     ? () {
// // //                         Navigator.push(
// // //                           context,
// // //                           AppPageRoute(page: HomeScreen()),
// // //                         );
// // //                       }
// // //                     : null,
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: valid
// // //                       ? Colors.grey.shade600
// // //                       : Colors.grey.shade800,
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(30),
// // //                   ),
// // //                 ),
// // //                 child: const Text(
// // //                   "Verify & Continue",
// // //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //                 ),
// // //               ),
// // //             ),
// // //
// // //             const SizedBox(height: 15),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   /// ---------- COMMON WIDGETS ----------
// // //
// // //   Widget _label(String text) {
// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 8),
// // //       child: Text(
// // //         text,
// // //         style: const TextStyle(
// // //           color: Colors.white,
// // //           fontSize: 16,
// // //           fontWeight: FontWeight.w500,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _input({
// // //     required TextEditingController controller,
// // //     required String hint,
// // //   }) {
// // //     return TextField(
// // //       controller: controller,
// // //       style: const TextStyle(color: Colors.white),
// // //       onChanged: (_) => setState(() {}),
// // //       decoration: _decoration(hint),
// // //     );
// // //   }
// // //
// // //   Widget _otpRow({
// // //     required TextEditingController controller,
// // //     required String hint,
// // //     String? prefix,
// // //     bool isNumber = false,
// // //   }) {
// // //     return Row(
// // //       children: [
// // //         Expanded(
// // //           child: TextField(
// // //             controller: controller,
// // //             maxLength: isNumber ? 10 : null,
// // //             keyboardType: isNumber
// // //                 ? TextInputType.number
// // //                 : TextInputType.emailAddress,
// // //             inputFormatters: isNumber
// // //                 ? [FilteringTextInputFormatter.digitsOnly]
// // //                 : null,
// // //             style: const TextStyle(color: Colors.white),
// // //             onChanged: (_) => setState(() {}),
// // //             decoration: _decoration(hint, prefix: prefix),
// // //           ),
// // //         ),
// // //         const SizedBox(width: 10),
// // //         SizedBox(
// // //           height: 55,
// // //           child: ElevatedButton(
// // //             onPressed: controller.text.isNotEmpty ? () {} : null,
// // //             style: ElevatedButton.styleFrom(
// // //               backgroundColor: Colors.cyan,
// // //               shape: RoundedRectangleBorder(
// // //                 borderRadius: BorderRadius.circular(25),
// // //               ),
// // //             ),
// // //             child: const Text("Send OTP"),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   InputDecoration _decoration(String hint, {String? prefix}) {
// // //     return InputDecoration(
// // //       hintText: hint,
// // //       hintStyle: const TextStyle(color: Colors.grey),
// // //       filled: true,
// // //       fillColor: const Color(0xFF0E1A1C),
// // //       counterText: "",
// // //       prefixText: prefix != null ? "$prefix " : null,
// // //       prefixStyle: const TextStyle(color: Colors.white),
// // //       enabledBorder: OutlineInputBorder(
// // //         borderRadius: BorderRadius.circular(25),
// // //         borderSide: const BorderSide(color: Colors.white24, width: 2),
// // //       ),
// // //       focusedBorder: OutlineInputBorder(
// // //         borderRadius: BorderRadius.circular(25),
// // //         borderSide: const BorderSide(color: Colors.cyan, width: 2.5),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // Widget logoStep(String step) => Row(
// // //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //   children: [
// // //     Row(
// // //       children: [
// // //         Container(
// // //           width: 150,
// // //           height: 60,
// // //           padding: EdgeInsets.all(8),
// // //           decoration: BoxDecoration(
// // //             image: DecorationImage(
// // //               image: AssetImage("asset/images/app_logo.png"),
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     ),
// // //     // Text(step,style: TextStyle(color: Colors.white,fontSize: 16),),
// // //   ],
// // // );
// //
// //
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:get/get_instance/src/extension_instance.dart';
// // import 'package:get_x/get_navigation/src/extension_navigation.dart';
// // import 'package:internsharks/controllers/resigter_controller.dart';
// // import 'package:internsharks/core/const_file/app_button.dart';
// // import 'package:internsharks/core/const_file/app_colors.dart';
// // import 'package:internsharks/core/const_file/app_text_style.dart';
// // import 'package:internsharks/core/routes/app_pages.dart';
// // import 'package:internsharks/screens/home_Screen.dart';
// // import 'package:get/get.dart';
// // import '../../controllers/resigter_controller.dart';
// // class RegisterPage extends StatefulWidget {
// //   final String? preFillMobile;
// //   final String? preFillEmail;
// //
// //   const RegisterPage({
// //     super.key,
// //     this.preFillMobile,
// //     this.preFillEmail,
// //   });
// //
// //   @override
// //   State<RegisterPage> createState() => _RegisterPageState();
// // }
// //
// // class _RegisterPageState extends State<RegisterPage> {
// //   final TextEditingController name = TextEditingController();
// //   final TextEditingController mobile = TextEditingController();
// //   final TextEditingController email = TextEditingController();
// //   final TextEditingController mobileOtp = TextEditingController();
// //   final TextEditingController emailOtp = TextEditingController();
// //   final RegisterFlowController registerCtrl =
// //   Get.find<RegisterFlowController>();
// //   bool mobileOtpSent = false;
// //   bool emailOtpSent = false;
// //   bool mobileVerified = false;
// //   bool emailVerified = false;
// //
// //   // Timer for resend OTP
// //   int mobileResendTimer = 0;
// //   int emailResendTimer = 0;
// //   Timer? mobileTimer;
// //   Timer? emailTimer;
// //
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // 🔹 Resume page-la irunthu vandha data
// //     name.text   = registerCtrl.name.value;
// //     mobile.text = registerCtrl.mobile.value;
// //     email.text  = registerCtrl.email.value;
// //   }
// //
// //   @override
// //   void dispose() {
// //     mobileTimer?.cancel();
// //     emailTimer?.cancel();
// //     name.dispose();
// //     mobile.dispose();
// //     email.dispose();
// //     mobileOtp.dispose();
// //     emailOtp.dispose();
// //     super.dispose();
// //   }
// //
// //   bool get canSendMobileOtp => mobile.text.length == 10;
// //   bool get canSendEmailOtp => email.text.contains("@") && email.text.length > 5;
// //   bool get canVerify => name.text.isNotEmpty && mobileVerified && emailVerified;
// //
// //   // Start countdown timer for mobile
// //   void startMobileTimer() {
// //     setState(() {
// //       mobileResendTimer = 30; // 30 seconds countdown
// //     });
// //     mobileTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       if (mobileResendTimer > 0) {
// //         setState(() {
// //           mobileResendTimer--;
// //         });
// //       } else {
// //         timer.cancel();
// //       }
// //     });
// //   }
// //
// //   // Start countdown timer for email
// //   void startEmailTimer() {
// //     setState(() {
// //       emailResendTimer = 30; // 30 seconds countdown
// //     });
// //     emailTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       if (emailResendTimer > 0) {
// //         setState(() {
// //           emailResendTimer--;
// //         });
// //       } else {
// //         timer.cancel();
// //       }
// //     });
// //   }
// //
// //   // Send Mobile OTP
// //   void sendMobileOtp() {
// //     if (canSendMobileOtp) {
// //       setState(() {
// //         mobileOtpSent = true;
// //       });
// //       startMobileTimer();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Mobile OTP sent successfully!")),
// //       );
// //       // In real app, call API to send OTP
// //     }
// //   }
// //
// //   // Resend Mobile OTP
// //   void resendMobileOtp() {
// //     if (mobileResendTimer == 0) {
// //       mobileOtp.clear(); // Clear previous OTP
// //       startMobileTimer();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Mobile OTP resent successfully!")),
// //       );
// //       // In real app, call API to resend OTP
// //     }
// //   }
// //
// //   // Send Email OTP
// //   void sendEmailOtp() {
// //     if (canSendEmailOtp) {
// //       setState(() {
// //         emailOtpSent = true;
// //       });
// //       startEmailTimer();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Email OTP sent successfully!")),
// //       );
// //       // In real app, call API to send OTP
// //     }
// //   }
// //
// //   // Resend Email OTP
// //   void resendEmailOtp() {
// //     if (emailResendTimer == 0) {
// //       emailOtp.clear(); // Clear previous OTP
// //       startEmailTimer();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Email OTP resent successfully!")),
// //       );
// //       // In real app, call API to resend OTP
// //     }
// //   }
// //
// //   // Verify Mobile OTP
// //   void verifyMobileOtp() {
// //     if (mobileOtp.text.length == 4) {
// //       // In real app, verify with API
// //       setState(() {
// //         mobileVerified = true;
// //       });
// //       mobileTimer?.cancel();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("Mobile verified successfully!"),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("Please enter valid 4-digit OTP"),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }
// //
// //   // Verify Email OTP
// //   void verifyEmailOtp() {
// //     if (emailOtp.text.length == 4) {
// //       // In real app, verify with API
// //       setState(() {
// //         emailVerified = true;
// //       });
// //       emailTimer?.cancel();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("Email verified successfully!"),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("Please enter valid 4-digit OTP"),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.appColor,
// //       body: Container(
// //         padding: const EdgeInsets.all(16),width: double.infinity,height: double.infinity,
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
// //               logoStep("Step 1 of 3"),
// //               const SizedBox(height: 10),
// //
// //               /// TITLE
// //               const Text(
// //                 "Let's get you\nVerified",
// //                 style: TextStyle(
// //                   color: AppColors.appYellow,
// //                   fontSize: 32,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               const SizedBox(height: 10),
// //               const Text(
// //                 "Complete the steps below to secure your Identity",
// //                 style: TextStyle(color: Colors.white70, fontSize: 18),
// //               ),
// //               const SizedBox(height: 25),
// //
// //               /// NAME
// //               _label("Name"),
// //               _input(controller: name, hint: "Enter your name"),
// //               const SizedBox(height: 20),
// //
// //               /// MOBILE NUMBER
// //               _label("Mobile Number"),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child:
// //                     TextField(
// //                       controller: mobile,
// //                       maxLength: 10,
// //                       keyboardType: TextInputType.number,
// //
// //                       // 🔴 IMPORTANT: edit block
// //                       enabled: false,
// //
// //                       inputFormatters: [
// //                         FilteringTextInputFormatter.digitsOnly,
// //                       ],
// //                       style: const TextStyle(color: Colors.white),
// //
// //                       decoration: _decoration(
// //                         "Mobile from resume",
// //                         prefix: "+91",
// //                         verified: true, // green tick + green border
// //                       ),
// //                     ),
// //
// //                     // TextField(
// //                     //   controller: mobile,
// //                     //   maxLength: 10,
// //                     //   keyboardType: TextInputType.number,
// //                     //   enabled: !mobileVerified,
// //                     //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
// //                     //   style: const TextStyle(color: Colors.white),
// //                     //   onChanged: (_) => setState(() {}),
// //                     //   decoration: _decoration(
// //                     //     "Enter your mobile number",
// //                     //     prefix: "+91",
// //                     //     verified: mobileVerified,
// //                     //   ),
// //                     // ),
// //                   ),
// //                   const SizedBox(width: 10),
// //                   SizedBox(
// //                     height: 55,
// //                     child: ElevatedButton(
// //                       onPressed: !mobileVerified
// //                           ? (mobileOtpSent && mobileResendTimer == 0 ? resendMobileOtp : (canSendMobileOtp ? sendMobileOtp : null))
// //                           : null,
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.cyan,
// //                         disabledBackgroundColor: Colors.grey.shade700,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(14),
// //                         ),
// //                       ),
// //                       child: Text(
// //                         mobileVerified
// //                             ? "Verified"
// //                             : (mobileOtpSent && mobileResendTimer > 0)
// //                             ? "${mobileResendTimer}s"
// //                             : (mobileOtpSent ? "Resend" : "Send OTP"),
// //                         style: const TextStyle(color: Colors.white),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //
// //               /// MOBILE OTP INPUT (Show after sending OTP)
// //               if (mobileOtpSent && !mobileVerified) ...[
// //                 const SizedBox(height: 15),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: TextField(
// //                         controller: mobileOtp,
// //                         maxLength: 4,
// //                         keyboardType: TextInputType.number,
// //                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
// //                         style: const TextStyle(color: Colors.white),
// //                         decoration: _decoration("Enter Code"),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     SizedBox(
// //                       height: 55,
// //                       child: ElevatedButton(
// //                         onPressed: verifyMobileOtp,
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.green,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(14),
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           "Verify",
// //                           style: TextStyle(color: Colors.white),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //
// //               const SizedBox(height: 20),
// //
// //               /// EMAIL ADDRESS
// //               _label("Email Address"),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child:
// //                     TextField(
// //                       controller: email,
// //                       enabled: false,
// //                       keyboardType: TextInputType.emailAddress,
// //                       style: const TextStyle(color: Colors.white),
// //                       decoration: _decoration(
// //                         "Email from resume",
// //                         verified: true,
// //                       ),
// //                     ),
// //
// //                     // TextField(
// //                     //   controller: email,
// //                     //   keyboardType: TextInputType.emailAddress,
// //                     //   enabled: !emailVerified,
// //                     //   style: const TextStyle(color: Colors.white),
// //                     //   onChanged: (_) => setState(() {}),
// //                     //   decoration: _decoration(
// //                     //     "Enter your email",
// //                     //     verified: emailVerified,
// //                     //   ),
// //                     // ),
// //                   ),
// //                   const SizedBox(width: 10),
// //                   SizedBox(
// //                     height: 55,
// //                     child: ElevatedButton(
// //                       onPressed: !emailVerified
// //                           ? (emailOtpSent && emailResendTimer == 0 ? resendEmailOtp : (canSendEmailOtp ? sendEmailOtp : null))
// //                           : null,
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.cyan,
// //                         disabledBackgroundColor: Colors.grey.shade700,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(14),
// //                         ),
// //                       ),
// //                       child: Text(
// //                         emailVerified
// //                             ? "Verified"
// //                             : (emailOtpSent && emailResendTimer > 0)
// //                             ? "${emailResendTimer}s"
// //                             : (emailOtpSent ? "Resend" : "Send OTP"),
// //                         style: const TextStyle(color: Colors.white),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //
// //               /// EMAIL OTP INPUT (Show after sending OTP)
// //               if (emailOtpSent && !emailVerified) ...[
// //                 const SizedBox(height: 15),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: TextField(
// //                         controller: emailOtp,
// //                         maxLength: 4,
// //                         keyboardType: TextInputType.number,
// //                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
// //                         style: const TextStyle(color: Colors.white),
// //                         decoration: _decoration("Enter Code"),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     SizedBox(
// //                       height: 55,
// //                       child: ElevatedButton(
// //                         onPressed: verifyEmailOtp,
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.green,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(14),
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           "Verify",
// //                           style: TextStyle(color: Colors.white),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //
// //               const SizedBox(height: 40),
// //
// //               /// VERIFY BUTTON
// //     AppButton.AppContainerButton(
// //     onTap: canVerify
// //     ? () {
// //
// //
// //     Get.offAllNamed(Routes.homeScreen);
// //     }
// //         : null,
// //     bgColor: canVerify
// //     ? AppColors.appBlue
// //         : Colors.grey.shade800,
// //     borderRadius: 45,
// //     borderColor: Colors.white24,
// //     borderWidth: 1,
// //     text: "Verify & Continue",
// //     verticalPadding: 12,
// //     textStyle: AppTextStyles.white22bold,
// //     ),
// //
// //               const SizedBox(height: 20),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// ---------- COMMON WIDGETS ----------
// //   Widget _label(String text) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 8),
// //       child: Text(
// //         text,
// //         style: const TextStyle(
// //           color: Colors.white,
// //           fontSize: 16,
// //           fontWeight: FontWeight.w500,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _input({
// //     required TextEditingController controller,
// //     required String hint,
// //   }) {
// //     return
// //       TextField(
// //         controller: name,
// //         enabled: false,
// //         style: const TextStyle(color: Colors.white),
// //         decoration: _decoration(
// //           "Name from resume",
// //           verified: true,
// //         ),
// //       );
// //     //   TextField(
// //     //   controller: controller,
// //     //   style: const TextStyle(color: Colors.white),
// //     //   onChanged: (_) => setState(() {}),
// //     //   decoration: _decoration(hint),
// //     // );
// //   }
// //
// //   InputDecoration _decoration(
// //       String hint, {
// //         String? prefix,
// //         bool verified = false,
// //       }) {
// //     return InputDecoration(
// //       hintText: hint,
// //       hintStyle: const TextStyle(color: Colors.grey),
// //       filled: true,
// //       fillColor: verified ? Colors.green.withOpacity(0.2) : const Color(0xFF0E1A1C),
// //       counterText: "",
// //       prefixText: prefix != null ? "$prefix " : null,
// //       prefixStyle: const TextStyle(color: Colors.white),
// //       suffixIcon: verified
// //           ? const Icon(Icons.check_circle, color: Colors.green)
// //           : null,
// //       enabledBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(14),
// //         borderSide: BorderSide(
// //           color: verified ? Colors.green : Colors.white24,
// //           width: 2,
// //         ),
// //       ),
// //       focusedBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(14),
// //         borderSide: const BorderSide(color: Colors.cyan, width: 2.5),
// //       ),
// //       disabledBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(14),
// //         borderSide: const BorderSide(color: Colors.green, width: 2),
// //       ),
// //     );
// //   }
// // }
// //
// // Widget logoStep(String step) => Row(
// //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //   children: [
// //     Row(
// //       children: [
// //         Container(
// //           width: 150,
// //           height: 60,
// //           padding: const EdgeInsets.all(8),
// //           decoration: const BoxDecoration(
// //             image: DecorationImage(
// //               image: AssetImage("asset/images/app_logo.png"),
// //             ),
// //           ),
// //         ),
// //       ],
// //     ),
// //   ],
// // );
//
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:internsharks/controllers/resigter_controller.dart';
// import 'package:internsharks/controllers/resume_controller.dart';
// import 'package:internsharks/core/const_file/api_constants.dart';
// import 'package:internsharks/core/const_file/app_button.dart';
// import 'package:internsharks/core/const_file/app_colors.dart';
// import 'package:internsharks/core/const_file/app_text_style.dart';
// import 'package:internsharks/core/routes/app_pages.dart';
//
// import '../../controllers/login_controller.dart';
//
//
// class RegisterPage extends StatefulWidget {
//   final String? preFillMobile;
//   final String? preFillEmail;
//
//   const RegisterPage({
//     super.key,
//     this.preFillMobile,
//     this.preFillEmail,
//   });
//
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController name = TextEditingController();
//   final TextEditingController mobile = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController mobileOtp = TextEditingController();
//   final TextEditingController emailOtp = TextEditingController();
//
//   final RegisterFlowController registerCtrl = Get.find<RegisterFlowController>();
//   final LoginController loginC = Get.find<LoginController>();
//
//   final ResumeController resumeController = Get.find<ResumeController>();
//
//   bool mobileOtpSent = false;
//   bool emailOtpSent = false;
//   bool mobileVerified = false;
//   bool emailVerified = false;
//
//   int mobileResendTimer = 0;
//   int emailResendTimer = 0;
//   Timer? mobileTimer;
//   Timer? emailTimer;
//
//   bool isLoadingMobile = false;
//   bool isLoadingEmail = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//
//     name.text = resumeController.resumeAnalyzeModel.resumeData!.personalInfo.name!;
//     mobile.text = resumeController.resumeAnalyzeModel.resumeData!.personalInfo.phone!;
//     email.text = resumeController.resumeAnalyzeModel.resumeData!.personalInfo.email!;
//   }
//
//   @override
//   void dispose() {
//     mobileTimer?.cancel();
//     emailTimer?.cancel();
//     name.dispose();
//     mobile.dispose();
//     email.dispose();
//     mobileOtp.dispose();
//     emailOtp.dispose();
//     super.dispose();
//   }
//
//   bool get canVerify => name.text.isNotEmpty && mobileVerified && emailVerified;
//
//   // ==================== API CALLS ====================
//
//
//
//
//   void startMobileTimer() {
//     setState(() {
//       mobileResendTimer = 30;
//     });
//     mobileTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mobileResendTimer > 0) {
//         setState(() {
//           mobileResendTimer--;
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   void startEmailTimer() {
//     setState(() {
//       emailResendTimer = 30;
//     });
//     emailTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (emailResendTimer > 0) {
//         setState(() {
//           emailResendTimer--;
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   void resendMobileOtp() {
//     if (mobileResendTimer == 0) {
//       mobileOtp.clear();
//       sendMobileOtpApi();
//     }
//   }
//
//   void resendEmailOtp() {
//     if (emailResendTimer == 0) {
//       emailOtp.clear();
//       sendEmailOtpApi();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       body: Stack(
//         children: [
//
//           /// 🔹 MAIN UI
//           Container(
//             padding: const EdgeInsets.all(16),
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("asset/images/login_bg.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 30),
//                   logoStep("Step 1 of 3"),
//                   const SizedBox(height: 10),
//
//                   const Text(
//                     "Let's get you\nVerified",
//                     style: TextStyle(
//                       color: AppColors.appYellow,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Complete the steps below to secure your Identity",
//                     style: TextStyle(color: Colors.white70, fontSize: 18),
//                   ),
//                   const SizedBox(height: 25),
//
//                   /// NAME
//                   _label("Name"),
//                   TextField(
//                     controller: name,
//                     enabled: false,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: _decoration("Name from resume", verified: true),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   /// MOBILE
//                   _label("Mobile Number"),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: mobile,
//                           enabled: false,
//                           maxLength: 10,
//                           style: const TextStyle(color: Colors.white),
//                           decoration: _decoration(
//                             "Mobile from resume",
//                             prefix: "+91",
//                             verified: true,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//         Obx(() {  if (loginC.isLoading.value) {
//           return
//             const Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.appYellow,
//               ),
//             );
//         }
//                       SizedBox(
//                         height: 55,
//                         child: ElevatedButton(
//                   onPressed: loginC.isMobileValid
//                             ? () {
//                       loginC.mobileCtrlStr.value = mobile.text;
//                       loginC.sendOtp();
//                       }
//                         : null,
//
//                         child: const Text("Send OTP"),
//                         ),
//                       );
//         })
//                     ],
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   /// EMAIL
//                   _label("Email Address"),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: email,
//                           enabled: false,
//                           style: const TextStyle(color: Colors.white),
//                           decoration: _decoration(
//                             "Email from resume",
//                             verified: true,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       SizedBox(
//                         height: 55,
//                         child: ElevatedButton(
//                           onPressed: loginC.isMobileValid
//                               ? () => loginC.sendEmailOtp()
//                               : null,
//                           child: const Text("Send OTP"),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 40),
//
//                   AppButton.AppContainerButton(
//                    onTap: loginC.isOtpValid
//                       ? () {
//             loginC.otpCtrlStr.value = mobileOtp.text;
//             loginC.verifyOtp();
//             }
//               : null,
//
//               bgColor:
//                     canVerify ? AppColors.appBlue : Colors.grey.shade800,
//                     borderRadius: 45,
//                     borderColor: Colors.white24,
//                     borderWidth: 1,
//                     text: "Verify & Continue",
//                     verticalPadding: 12,
//                     textStyle: AppTextStyles.white22bold,
//                   ),
//
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//
//           /// 🔥 FULL PAGE LOADER
//           Obx(() {
//             if (!loginC.isLoading.value) return const SizedBox();
//
//             return Container(
//               width: double.infinity,
//               height: double.infinity,
//               color: Colors.black.withOpacity(0.6),
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   color: AppColors.appYellow,
//                   strokeWidth: 4,
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   /// ---------- COMMON WIDGETS ----------
//   Widget _label(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
//
//   InputDecoration _decoration(
//       String hint, {
//         String? prefix,
//         bool verified = false,
//       }) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: const TextStyle(color: Colors.grey),
//       filled: true,
//       fillColor: verified ? Colors.green.withOpacity(0.2) : const Color(0xFF0E1A1C),
//       counterText: "",
//       prefixText: prefix != null ? "$prefix " : null,
//       prefixStyle: const TextStyle(color: Colors.white),
//       suffixIcon: verified ? const Icon(Icons.check_circle, color: Colors.green) : null,
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(
//           color: verified ? Colors.green : Colors.white24,
//           width: 2,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: Colors.cyan, width: 2.5),
//       ),
//       disabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: Colors.green, width: 2),
//       ),
//     );
//   }
// }
//
// Widget logoStep(String step) => Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Row(
//       children: [
//         Container(
//           width: 150,
//           height: 60,
//           padding: const EdgeInsets.all(8),
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("asset/images/app_logo.png"),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ],
// );
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internsharks/controllers/resigter_controller.dart';
import 'package:internsharks/controllers/resume_controller.dart';
import 'package:internsharks/core/const_file/api_constants.dart';
import 'package:internsharks/core/const_file/app_button.dart';
import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';

import '../../../controllers/login_controller.dart';
import '../../../core/const_file/app_button.dart';
import '../../../core/const_file/app_colors.dart';
import '../../../core/const_file/app_text_style.dart';
import '../../../core/routes/app_pages.dart';
import 'register_page.dart';
class RegisterPage extends StatefulWidget {
  final String? preFillMobile;
  final String? preFillEmail;

  const RegisterPage({
    super.key,
    this.preFillMobile,
    this.preFillEmail,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobileOtp = TextEditingController();
  final TextEditingController emailOtp = TextEditingController();

  final RegisterFlowController registerCtrl = Get.find<RegisterFlowController>();
  final LoginController loginC = Get.find<LoginController>();
  final ResumeController resumeController = Get.find<ResumeController>();

  bool mobileOtpSent = false;
  bool emailOtpSent = false;
  bool mobileVerified = false;
  bool emailVerified = false;

  int mobileResendTimer = 0;
  int emailResendTimer = 0;
  Timer? mobileTimer;
  Timer? emailTimer;

  bool isLoadingMobile = false;
  bool isLoadingEmail = false;

  @override
  void initState() {
    super.initState();
    name.text = resumeController.resumeAnalyzeModel.resumeData!.personalInfo.name!;
    mobile.text = resumeController.resumeAnalyzeModel.resumeData!.personalInfo.phone!;
    email.text = resumeController.resumeAnalyzeModel.resumeData!.personalInfo.email!;
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
  bool get canVerify => name.text.isNotEmpty && mobileVerified && emailVerified;

  // Timer functions
  void startMobileTimer() {
    setState(() {
      mobileResendTimer = 30;
    });
    mobileTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mobileResendTimer > 0) {
        setState(() {
          mobileResendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void startEmailTimer() {
    setState(() {
      emailResendTimer = 30;
    });
    emailTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (emailResendTimer > 0) {
        setState(() {
          emailResendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  // Send Mobile OTP
  void sendMobileOtp() {
    if (canSendMobileOtp) {
      setState(() {
        mobileOtpSent = true;
        isLoadingMobile = true;
      });


      loginC.mobile.value = mobile.text;
      loginC.sendMobileOtp();

      startMobileTimer();
      setState(() {
        isLoadingMobile = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mobile OTP sent successfully!")),
      );
    }
  }

  // Resend Mobile OTP
  void resendMobileOtp() {
    if (mobileResendTimer == 0) {
      mobileOtp.clear();
      sendMobileOtp();
    }
  }

  // Send Email OTP
  void sendEmailOtp() {
    if (canSendEmailOtp) {
      setState(() {
        emailOtpSent = true;
        isLoadingEmail = true;
      });

      // Call your API here
      // loginC.sendEmailOtp();

      // LoginController.sendEmailOtp(email.text);

      startEmailTimer();
      setState(() {
        isLoadingEmail = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email OTP sent successfully!")),
      );
    }
  }

  // Resend Email OTP
  void resendEmailOtp() {
    if (emailResendTimer == 0) {
      emailOtp.clear();
      sendEmailOtp();
    }
  }

  // Verify Mobile OTP
  // void verifyMobileOtp() {
  //   if (mobileOtp.text.length == 4) {
  //     setState(() {
  //       mobileVerified = true;
  //     });
  //     mobileTimer?.cancel();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Mobile verified successfully!"),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Please enter valid 4-digit OTP"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Stack(
        children: [
          /// MAIN UI
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            height: double.infinity,
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
                  const SizedBox(height: 30),
                  logoStep("Step 1 of 3"),
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

                  /// NAME
                  _label("Name"),
                  TextField(
                    controller: name,
                    enabled: false,
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoration("Name from resume", verified: true),
                  ),

                  const SizedBox(height: 20),

                  /// MOBILE NUMBER
                  _label("Mobile Number"),
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
                            verified: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: !mobileVerified
                              ? (mobileOtpSent && mobileResendTimer == 0
                              ? resendMobileOtp
                              : (canSendMobileOtp ? sendMobileOtp : null))
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            disabledBackgroundColor: Colors.grey.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isLoadingMobile
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            mobileVerified
                                ? "Verified"
                                : (mobileOtpSent && mobileResendTimer > 0)
                                ? "${mobileResendTimer}s"
                                : (mobileOtpSent ? "Resend" : "Send OTP"),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// MOBILE OTP INPUT
                  if (mobileOtpSent && !mobileVerified) ...[
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: mobileOtp,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: const TextStyle(color: Colors.white),
                            decoration: _decoration("Enter Code"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed:  ()async{
                              await loginC.verifyMobileOtp(emailOtp.text, email.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Verify",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  /// EMAIL ADDRESS
                  _label("Email Address"),
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
                            verified: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: !emailVerified
                              ? (emailOtpSent && emailResendTimer == 0
                              ? resendEmailOtp
                              : (canSendEmailOtp ? sendEmailOtp : null))
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            disabledBackgroundColor: Colors.grey.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isLoadingEmail
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            emailVerified
                                ? "Verified"
                                : (emailOtpSent && emailResendTimer > 0)
                                ? "${emailResendTimer}s"
                                : (emailOtpSent ? "Resend" : "Send OTP"),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// EMAIL OTP INPUT
                  if (emailOtpSent && !emailVerified) ...[
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: emailOtp,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: const TextStyle(color: Colors.white),
                            decoration: _decoration("Enter Code"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: ()async{
                              await loginC.verifyEmailOtp(email.text, emailOtp.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Verify",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 40),

                  /// VERIFY & CONTINUE BUTTON
                  AppButton.AppContainerButton(
                    onTap:


                        () {
                      },
                    // canVerify
                    //     ? () {
                    //   loginC.otpCtrlStr.value = mobileOtp.text;
                    //   loginC.verifyOtp();
                    //   Get.offAllNamed(Routes.homeScreen);
                    // }
                    //     : null,
                    bgColor: canVerify ? AppColors.appBlue : Colors.grey.shade800,
                    borderRadius: 45,
                    borderColor: Colors.white24,
                    borderWidth: 1,
                    text: "Verify & Continue",
                    verticalPadding: 12,
                    textStyle: AppTextStyles.white22bold,
                  ),

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

  /// ---------- COMMON WIDGETS ----------
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
      fillColor: verified ? Colors.green.withOpacity(0.2) : const Color(0xFF0E1A1C),
      counterText: "",
      prefixText: prefix != null ? "$prefix " : null,
      prefixStyle: const TextStyle(color: Colors.white),
      suffixIcon: verified ? const Icon(Icons.check_circle, color: Colors.green) : null,
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

Widget logoStep(String step) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Container(
          width: 150,
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("asset/images/app_logo.png"),
            ),
          ),
        ),
      ],
    ),
  ],
);