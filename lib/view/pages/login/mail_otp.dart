// // import 'package:flutter/cupertino.dart';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter/material.dart';
// // import 'package:internsharks/const_file/app_colors.dart';
// // import 'package:internsharks/screens/home_Screen.dart';
// // import 'dart:async';
// //
// // import '../../main.dart';
// //
// // class mailOtp extends StatefulWidget {
// //   final String email;
// //
// //   mailOtp({required this.email});
// //
// //   @override
// //   _mailOtpState createState() => _mailOtpState();
// // }
// //
// // class _mailOtpState extends State<mailOtp> {
// //   List<String> otp = ["", "", "", ""];
// //   int time = 45;
// //   Timer? t;
// //   FocusNode otpFocus = FocusNode();
// //   @override
// //   void initState() {
// //     super.initState();
// //     start();
// //   }
// //
// //   void start() {
// //     time = 45;
// //     t?.cancel();
// //     t = Timer.periodic(Duration(seconds: 1), (timer) {
// //       if (time > 0) {
// //         setState(() => time--);
// //       } else {
// //         timer.cancel();
// //       }
// //     });
// //   }
// //
// //   bool get valid => otp.every((e) => e.isNotEmpty);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.appColor,
// //       body: Container( width: double.infinity,
// //         padding: EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           image: DecorationImage(
// //             image: AssetImage("lib/assets/images/login_bg.png"),
// //             fit: BoxFit.cover,
// //           ),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [  SizedBox(height: 30),
// //             logoStep("Step3 of 3"),
// //             SizedBox(height: 10),
// //             progress(1),
// //
// //             SizedBox(height: 20),
// //             Expanded(
// //               child: SingleChildScrollView(
// //                 child: Column(crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "Email Verification",
// //                       style: TextStyle(
// //                         color: AppColors.appYellow,
// //                         fontSize: 24,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //
// //
// //                     SizedBox(height: 10),
// //                     Text(
// //                       "Enter the code sent to your email address to complete verification",
// //                       style: TextStyle(color: Colors.grey, fontSize: 16),
// //                     ),
// //                     SizedBox(height: 20),
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
// //                       child: Row(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [label("Enter the otp")],
// //                       ),
// //                     ),
// //                     SizedBox(height: 15),
// //                     otpRow(otp, () => setState(() {})),
// //                 SizedBox(height: 30),
// //                     Row(mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Text(
// //                           "Didn't receive the code?",
// //                           style: TextStyle(color: Colors.white, fontSize: 16),
// //                         ),SizedBox(width: 5,),
// //                         GestureDetector(
// //                           onTap: start,
// //                           child: Text(
// //                             "Resend OTP",
// //                             style: TextStyle(
// //                               color: AppColors.appBlue,fontSize: 16,
// //                               decoration: TextDecoration.underline,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),       SizedBox(height: 140),
// //                 Center(
// //                   child: button(
// //                     text: "Finish",
// //                     enabled: valid,
// //                     onTap: () {
// //                       Navigator.pushAndRemoveUntil(
// //                         context,
// //                         MaterialPageRoute(builder: (_) => HomePages()),
// //                         (_) => false,
// //                       );
// //                     },
// //                   ),
// //                 ),  ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// // Widget logoStep(String step) => Row(
// //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //   children: [
// //     Row(
// //       children: [
// //         Container(width: 150,height: 60,
// //           padding: EdgeInsets.all(8),
// //           decoration: BoxDecoration(
// //             image: DecorationImage(image: AssetImage("lib/assets/images/app_logo.png")),
// //           ),
// //         ),
// //
// //
// //       ],
// //     ),
// //     Text(step),
// //   ],
// // );
// //
// // Widget progress(int step) => Row(
// //   children: List.generate(
// //     3,
// //     (i) => Expanded(
// //       child: Container(
// //         margin: EdgeInsets.only(right: i == 2 ? 0 : 8),
// //         height: 8,
// //         decoration: BoxDecoration(
// //           color: i < step ? Colors.white : Colors.grey,
// //           borderRadius: BorderRadius.circular(4),
// //         ),
// //       ),
// //     ),
// //   ),
// // );
// //
// // Widget otpRow(List otp, VoidCallback refresh) {
// //   return Row(
// //     mainAxisAlignment: MainAxisAlignment.center,
// //     children: List.generate(
// //       4,
// //           (i) {
// //         return _OtpBox(
// //           index: i,
// //           otp: otp,
// //           refresh: refresh,
// //         );
// //       },
// //     ),
// //   );
// // }
// //
// // class _OtpBox extends StatefulWidget {
// //   final int index;
// //   final List otp;
// //   final VoidCallback refresh;
// //
// //   const _OtpBox({required this.index, required this.otp, required this.refresh});
// //
// //   @override
// //   _OtpBoxState createState() => _OtpBoxState();
// // }
// //
// // class _OtpBoxState extends State<_OtpBox> {
// //   FocusNode focus = FocusNode();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     focus.addListener(() => setState(() {})); // refresh UI when focus changes
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     bool filled = widget.otp[widget.index].isNotEmpty;
// //
// //     return Container(
// //       width: 60,
// //       height: 60,
// //       margin: EdgeInsets.all(6),
// //       decoration: BoxDecoration(
// //         color: Color(0xFF0E1A1C),
// //         border: Border.all(
// //           color: focus.hasFocus || filled ? Colors.cyan : Colors.white24,
// //           width: 2,
// //         ),
// //         borderRadius: BorderRadius.circular(18),
// //       ),
// //       child: Center(
// //         child: TextField(keyboardType: TextInputType.number,
// //
// //           focusNode: focus,
// //           maxLength: 1,cursorColor: Colors.white,
// //           textAlign: TextAlign.center,
// //           style: TextStyle(fontSize: 28, color: Colors.white),
// //           decoration: InputDecoration(
// //             border: InputBorder.none,
// //             counterText: "",
// //           ),
// //           onChanged: (v) {
// //             widget.otp[widget.index] = v;
// //             widget.refresh();
// //
// //             // auto move to next box
// //             if (v.isNotEmpty && widget.index < 3) {
// //               FocusScope.of(context).nextFocus();
// //             }
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // Widget label(String text) =>
// //     Text(text, style: TextStyle(color: Colors.white, fontSize: 18));
// //
// //
// //
// // Widget button({
// //   required String text,
// //   required bool enabled,
// //   required VoidCallback onTap,
// // }) => GestureDetector(
// //   onTap: enabled ? onTap : null,
// //   child: Container(
// //     width: 300,
// //     padding: EdgeInsets.all(18),
// //     decoration: BoxDecoration(
// //       color: enabled ? Colors.cyan : Colors.grey,
// //       borderRadius: BorderRadius.circular(30),
// //     ),
// //     child: Center(
// //       child: Text(
// //         text,
// //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //       ),
// //     ),
// //   ),
// // );
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:internsharks/core/const_file/app_colors.dart';
// import 'package:internsharks/core/routes/app_pages.dart';
// import 'package:internsharks/screens/home_Screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
//
// import '../../main.dart';
//
// class MailOtp extends StatefulWidget {
//   final String email;
//
//   MailOtp({required this.email});
//
//   @override
//   _MailOtpState createState() => _MailOtpState();
// }
//
// class _MailOtpState extends State<MailOtp> {
//   List<String> otp = ["", "", "", ""];
//   int time = 45;
//   Timer? t;
//   FocusNode otpFocus = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     start();
//   }
//
//   void start() {
//     time = 45;
//     t?.cancel();
//     t = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (time > 0) {
//         setState(() => time--);
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   bool get valid => otp.every((e) => e.isNotEmpty);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.appColor,
//       body: Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/login_bg.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 30),
//             logoStep("Step3 of 3"),
//             SizedBox(height: 10),
//             progress(1),
//             SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Email Verification",
//                       style: TextStyle(
//                         color: AppColors.appYellow,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "Enter the code sent to your email address ${widget.email} to complete verification",
//                       style: TextStyle(color: Colors.grey, fontSize: 16),
//                     ),
//                     SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [label("Enter the otp")],
//                       ),
//                     ),
//                     SizedBox(height: 6),
//                     otpRow(otp, () => setState(() {})),
//                     SizedBox(height: 30),
//                     Center(
//                       child: Text(
//                         "00:${time.toString().padLeft(2, '0')}",
//                         style: TextStyle(color: Colors.white, fontSize: 28),
//                       ),
//                     ),
//
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Didn't receive the code?",
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                         SizedBox(width: 5),
//                         GestureDetector(
//                           onTap: start,
//                           child: Text(
//                             "Resend OTP",
//                             style: TextStyle(
//                               color: AppColors.appBlue,
//                               fontSize: 16,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 120),
//                     Center(
//                       child: button(
//                         text: "Verify",
//                         enabled: valid,
//
//                         onTap: () async {
//
//                           // TODO: Here you would normally verify OTP success from API
//                           bool otpSuccess = true;
//
//                           if (otpSuccess) {
//
//                             // SAVE LOGIN STATE
//                             SharedPreferences prefs = await SharedPreferences.getInstance();
//                             await prefs.setBool('isLoggedIn', true);
//
//                             // MOVE TO HOME PAGE (no back)
//                             Navigator.pushReplacement(
//                               context,
//                               AppPageRoute(page: HomeScreen()),
//                             );
//                           }
//                         },
//
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ----------------------
// //  SUPPORT WIDGETS
// // ----------------------
//
// Widget  logoStep(String step) => Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Row(
//       children: [
//         Container(
//           width: 150,
//           height: 60,
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("assets/images/app_logo.png")),
//           ),
//         ),
//       ],
//     ),
//     // Text(step,style: TextStyle(color: Colors.white,fontSize: 16),),
//   ],
// );
//
// Widget progress(int step) => Row(
//   children: List.generate(
//     3,
//         (i) => Expanded(
//       child: Container(
//         margin: EdgeInsets.only(right: i == 2 ? 0 : 8),
//         height: 8,
//         decoration: BoxDecoration(
//           color: i < step ? Colors.white : Colors.grey,
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ),
//     ),
//   ),
// );
//
// Widget otpRow(List otp, VoidCallback refresh) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: List.generate(
//       4,
//           (i) {
//         return _OtpBox(
//           index: i,
//           otp: otp,
//           refresh: refresh,
//         );
//       },
//     ),
//   );
// }
//
// // ----------------------------------------------------
// // 🔥 UPDATED OTP BOX WITH BACKSPACE LOGIC
// // ----------------------------------------------------
// class _OtpBox extends StatefulWidget {
//   final int index;
//   final List otp;
//   final VoidCallback refresh;
//
//   const _OtpBox({required this.index, required this.otp, required this.refresh});
//
//   @override
//   _OtpBoxState createState() => _OtpBoxState();
// }
//
// class _OtpBoxState extends State<_OtpBox> {
//   FocusNode focus = FocusNode();
//   TextEditingController controller = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     focus.addListener(() => setState(() {}));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool filled = widget.otp[widget.index].isNotEmpty;
//
//     return Container(
//       width: 60,
//       height: 60,
//       margin: EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: Color(0xFF0E1A1C),
//         border: Border.all(
//           color: focus.hasFocus || filled ? Colors.cyan : Colors.white24,
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Center(
//         child: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           focusNode: focus,
//           maxLength: 1,
//           cursorColor: Colors.white,
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 28, color: Colors.white),
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             counterText: "",
//           ),
//
//           // ------------------------------
//           // 🔥 MAIN LOGIC
//           // ------------------------------
//           onChanged: (v) {
//             widget.otp[widget.index] = v;
//             widget.refresh();
//
//             // Move next if typed
//             if (v.isNotEmpty && widget.index < 3) {
//               FocusScope.of(context).nextFocus();
//             }
//
//             // BACKSPACE logic
//             if (v.isEmpty && widget.index > 0) {
//               widget.otp[widget.index - 1] = "";
//               widget.refresh();
//               FocusScope.of(context).previousFocus();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
// Widget label(String text) =>
//     Text(text, style: TextStyle(color: Colors.white, fontSize: 18));
//
// Widget button({
//   required String text,
//   required bool enabled,
//   required VoidCallback onTap,
// }) =>
//     GestureDetector(
//       onTap: enabled ? onTap : null,
//       child: Container(
//         width: 300,
//         padding: EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: enabled ? Colors.cyan : Colors.grey,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
