// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:internsharks/core/const_file/app_colors.dart';
// import 'package:internsharks/core/routes/app_pages.dart';
// import 'package:internsharks/pages/login/mail_otp.dart';
// import 'dart:async';
//
// import '../../main.dart';
//
//
// class MobileOtp extends StatefulWidget {
//   final String mobile, email;
//
//   MobileOtp({required this.mobile, required this.email});
//
//   @override
//   _MobileOtpState createState() => _MobileOtpState();
// }
//
// class _MobileOtpState extends State<MobileOtp> {
//   List<String> otp = ["", "", "", ""];
//   int time = 45;
//   Timer? t;
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
//     return Scaffold(backgroundColor: AppColors.appColor,
//       body: Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("lib/asset/images/login_bg.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 30),
//             logoStep("Step1 of 3"),
//             SizedBox(height: 10),
//             progress(1),
//
//             SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Mobile Verification",
//                       style: TextStyle(
//                         color: AppColors.appYellow,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//
//                     SizedBox(height: 10),
//                     Text(
//                       "Enter the One-Time password (OTP) sent to your mobile number +91 ${widget.mobile}",
//                       style: TextStyle(color: Colors.grey, fontSize: 16),
//                     ),
//
//                     SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [label("Enter the otp")],
//                       ),
//                     ),
//                     SizedBox(height: 6),
//
//                     otpRow(otp, () => setState(() {})),
//
//                     SizedBox(height: 30),
//                     Center(
//                       child: Text(
//                         "00:${time.toString().padLeft(2, '0')}",
//                         style: TextStyle(color: Colors.white, fontSize: 28),
//                       ),
//                     ),
//
//                     SizedBox(height: 20),
//                     Row(mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Didn't receive the code?",
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),SizedBox(width: 5,),
//                         GestureDetector(
//                           onTap: start,
//                           child: Text(
//                             "Resend OTP",
//                             style: TextStyle(
//                               color: AppColors.appBlue,fontSize: 16,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 120),
//
//                     Center(
//                       child: button(
//                         text: "Verify",
//                         enabled: valid,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             AppPageRoute(
//                            page: MailOtp(email: widget.email)
//                             ),
//                           );
//                         },
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
// //
// // Scaffold(
// //
// // body: SafeArea(
// // child: SingleChildScrollView(
// // padding: EdgeInsets.all(24),
// // child: Column(
// // crossAxisAlignment: CrossAxisAlignment.start,
// // children: [
// // logoStep("Step2 of 3"),
// // progress(2),
// //
// // SizedBox(height: 40),
// // Text("Mobile Verification",
// // style: TextStyle(
// // color: Colors.amber,
// // fontSize: 28,
// // fontWeight: FontWeight.bold)),
// //
// // SizedBox(height: 20),
// // Text("Enter OTP sent to your mobile",
// // style: TextStyle(color: Colors.grey)),
// //
// // SizedBox(height: 40),
// // otpRow(otp, () => setState(() {})),
// //
// // SizedBox(height: 30),
// // Center(
// // child: Text(
// // "00:${time.toString().padLeft(2, '0')}",
// // style: TextStyle(color: Colors.white, fontSize: 28),
// // )),
// //
// // SizedBox(height: 20),
// // Center(
// // child: GestureDetector(
// // onTap: start,
// // child: Text("Resend OTP",
// // style: TextStyle(
// // color: Colors.cyan,
// // decoration: TextDecoration.underline))),
// // ),
// //
// // SizedBox(height: 40),
// //
// // button(
// // text: "Verify",
// // enabled: valid,
// // onTap: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (_) => mailOtp(email: widget.email),
// // ),
// // );
// // },
// // )
// // ],
// // ),
// // ),
// // ),
// // );
