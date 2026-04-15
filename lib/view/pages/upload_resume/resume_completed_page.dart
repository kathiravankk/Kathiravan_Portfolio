// // // import 'package:flutter/material.dart';
// // // import 'package:internsharks/const_file/app_colors.dart';
// // //
// // // class ResumeCompletedPage extends StatefulWidget {
// // //   const ResumeCompletedPage({super.key});
// // //
// // //   @override
// // //   State<ResumeCompletedPage> createState() => _ResumeCompletedPageState();
// // // }
// // //
// // // class _ResumeCompletedPageState extends State<ResumeCompletedPage> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: AppColors.appColor,
// // //       body: Container(
// // //         padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
// // //         height: double.infinity,
// // //         width: double.infinity,
// // //
// // //         child: SingleChildScrollView(
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Row(
// // //                 children: [
// // //                   IconButton(
// // //                     onPressed: () => Navigator.pop(context),
// // //                     icon: const Icon(
// // //                       Icons.arrow_back,
// // //                       color: Colors.white,
// // //                       size: 25,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 20),
// // //                   const Text(
// // //                     "Upload Resume",
// // //                     style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 24,
// // //                       fontWeight: FontWeight.bold,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //
// // //               const SizedBox(height: 20),
// // //
// // //               // ---------------- MAIN CARD BOX ----------------
// // //               Container(
// // //                 padding: const EdgeInsets.symmetric(
// // //                   vertical: 30,
// // //                   horizontal: 16,
// // //                 ),
// // //                 decoration: BoxDecoration(
// // //                   gradient: const LinearGradient(
// // //                     colors: [
// // //                       Color(0xff181713),
// // //                       Color(0xff181714),
// // //                       Color(0xff181618),
// // //                       Color(0xff15201c),
// // //                       Color(0xff15201c),
// // //                       Color(0xff15201c),
// // //                       Color(0xff15201c),
// // //                       Color(0xff161e16),
// // //                       Color(0xff181814),
// // //                       Color(0xff181814),
// // //                     ],
// // //                     begin: AlignmentGeometry.topRight,
// // //                     end: AlignmentGeometry.bottomLeft,
// // //                   ),
// // //                   borderRadius: BorderRadius.circular(30),
// // //                 ),
// // //                 width: double.infinity,
// // //
// // //                 child: Column(
// // //                   children: [
// // //                     // RESUME ILLUSTRATION
// // //                     Container(
// // //                       width: 180,
// // //                       height: 180,
// // //                       decoration: const BoxDecoration(
// // //                         image: DecorationImage(
// // //                           image: AssetImage("lib/assets/images/resume_upload_img.png"),
// // //                           fit: BoxFit.cover,
// // //                         ),
// // //                       ),
// // //                     ),
// // //
// // //                     const SizedBox(height: 15),
// // //
// // //                     const Text(
// // //                       "Resume Uploaded",
// // //                       style: TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 24,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),
// // //
// // //                     const SizedBox(height: 10),
// // //
// // //                     const Padding(
// // //                       padding: EdgeInsets.symmetric(horizontal: 15),
// // //                       child: Text(
// // //                         "Your resume is now part of your profile. Good luck with your applications!",
// // //                         textAlign: TextAlign.center,
// // //                         style: TextStyle(color: Colors.white70, fontSize: 16),
// // //                       ),
// // //                     ),
// // //
// // //                     const SizedBox(height: 25),
// // //
// // //                     Container(
// // //                       width: double.infinity,
// // //                       decoration: BoxDecoration(
// // //                         borderRadius: BorderRadius.circular(45),
// // //                         color: AppColors.thirdColor,
// // //                         border: Border.all(color: Colors.white10, width: 1),
// // //
// // //                       ),
// // //                       padding: const EdgeInsets.symmetric(vertical: 16),
// // //                       child: const Center(
// // //                         child: Text(
// // //                           "my_resume_final.pdf",
// // //                           style: TextStyle(
// // //                             color: Colors.white,
// // //                             fontSize: 24,
// // //                             fontWeight: FontWeight.bold,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     SizedBox(height: 20,),
// // //                     InkWell(
// // //                       onTap: () {
// // //                         // startUpload();   // Start upload + show box
// // //                       },
// // //                       child: Container(
// // //                         width: double.infinity,
// // //                         padding: const EdgeInsets.symmetric(
// // //                           vertical: 10,
// // //                           horizontal: 24,
// // //                         ),
// // //                         decoration: BoxDecoration(
// // //                           borderRadius: BorderRadius.circular(30),
// // //                           border: Border.all(
// // //                             color: AppColors.appBlue,
// // //                             width: 0.5,
// // //                           ),
// // //                         ),
// // //                         child: const Text(
// // //                           "Replace Resume",
// // //                           textAlign: TextAlign.center,
// // //                           style: TextStyle(
// // //                             color: Colors.white,
// // //                             fontSize: 24,
// // //                             fontWeight: FontWeight.w600,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),SizedBox(height: 20,),
// // //                     InkWell(
// // //                       onTap: () {
// // //                         // startUpload();   // Start upload + show box
// // //                       },
// // //                       child: Container(
// // //                         width: double.infinity,
// // //                         padding: const EdgeInsets.symmetric(
// // //                           vertical: 10,
// // //                           horizontal: 24,
// // //                         ),
// // //                         decoration: BoxDecoration(
// // //                           color: AppColors.appBlue,
// // //                           borderRadius: BorderRadius.circular(30),
// // //                           // border: Border.all(
// // //                           //   color: AppColors.appBlue,
// // //                           //   width: 1.5,
// // //                           // ),
// // //                         ),
// // //                         child: const Text(
// // //                           "Continue",
// // //                           textAlign: TextAlign.center,
// // //                           style: TextStyle(
// // //                             color: Colors.white,
// // //                             fontSize: 24,
// // //                             fontWeight: FontWeight.w600,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:internsharks/const_file/app_colors.dart';
// // import 'package:internsharks/const_file/app_text_style.dart';
// // import 'package:internsharks/screens/home_Screen.dart';
// //
// // class ResumeCompletedPage extends StatefulWidget {
// //   const ResumeCompletedPage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<ResumeCompletedPage> createState() => _ResumeCompletedPageState();
// // }
// //
// // class _ResumeCompletedPageState extends State<ResumeCompletedPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       body: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 30.0),
// //         height: double.infinity,
// //         width: double.infinity,
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             // Success Check Icon
// //             Container(
// //               width: 200,
// //               height: 150,
// //               decoration: const BoxDecoration(
// //                 shape: BoxShape.circle,
// //               ),
// //               child: ClipOval(
// //                 child: Image.assets(
// //                   'lib/assets/images/icons/verified.gif',   // 🔥 your gif path
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //             ),
// //
// //             const SizedBox(height: 32),
// //
// //             // Congratulations Title
// //             const Text(
// //               'Congratulations!',
// //               style: TextStyle(
// //                 color: Color(0xffffde5f),
// //                 fontSize: 28,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //
// //             // Description Text
// //             SizedBox(
// //               width: 280,
// //               child: const Text(
// //                 'Your resume is now successfully created.It is formatted, professional, and ready to use for job applications.',
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(color: Colors.white70, fontSize: 16),
// //               ),
// //             ),
// //             const SizedBox(height: 40),
// //
// //             // File Name Container
// //             Container(
// //               width: double.infinity,
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //               decoration: BoxDecoration(
// //                 color: AppColors.appBlue.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(40),
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: const [
// //                   Icon(Icons.description, color: Colors.white70, size: 20),
// //                   SizedBox(width: 12),
// //                   Text('my_resume_final.pdf', style: AppTextStyles.white20bold),
// //                 ],
// //               ),
// //             ),
// //
// //             const SizedBox(height: 35),
// //
// //             // View Resume Button
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //
// //               width: double.infinity,
// //
// //               decoration: BoxDecoration(
// //                 // Change to your desired color
// //                 borderRadius: BorderRadius.circular(40),
// //                 border: Border.all(color: AppColors.appBlue, width: 0.5),
// //               ),
// //               child: Center(
// //                 child: const Text(
// //                   'View Resume',
// //                   style: AppTextStyles.white24Bold,
// //                 ),
// //               ),
// //             ),
// //
// //             const SizedBox(height: 15),
// //
// //             // Continue Button
// //             InkWell(
// //               onTap: () {
// //                 Navigator.push(
// //                   context,MaterialPageRoute(
// //                   builder: (context) => HomePages(activeStep: 2,),
// //                 ),
// //                 );
// //               },
// //               child: Container(
// //                 width: double.infinity,
// //                 padding: const EdgeInsets.symmetric(
// //                   horizontal: 20,
// //                   vertical: 10,
// //                 ),
// //
// //                 decoration: BoxDecoration(
// //                   color: AppColors.appBlue, // Button background color
// //                   borderRadius: BorderRadius.circular(40),
// //                   // Optional: add border if needed
// //                   // border: Border.all(color: Colors.white, width: 1.5),
// //                 ),
// //                 child: Center(
// //                   child: const Text(
// //                     'Continue',
// //                     style: AppTextStyles.white24Bold,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 40),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:internsharks/const_file/app_colors.dart';
// import 'package:internsharks/const_file/app_text_style.dart';
// import 'package:internsharks/screens/home_Screen.dart';
//
// class ResumeCompletedPage extends StatefulWidget {
//   const ResumeCompletedPage({Key? key}) : super(key: key);
//
//   @override
//   State<ResumeCompletedPage> createState() => _ResumeCompletedPageState();
// }
//
// class _ResumeCompletedPageState extends State<ResumeCompletedPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             width: double.infinity,
//
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//
//                 const SizedBox(height: 50),
//
//                 // GIF
//                 Container(
//                   width: 200,
//                   height: 150,
//                   child: ClipOval(
//                     child: Image.assets(
//                       'lib/assets/images/icons/verified.gif',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 32),
//
//                 const Text(
//                   'Congratulations!',
//                   style: TextStyle(
//                     color: Color(0xffffde5f),
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 SizedBox(
//                   width: 280,
//                   child: const Text(
//                     'Your resume is now successfully created. It is professional and ready to use for job applications.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.white70, fontSize: 16),
//                   ),
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 // File Name
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                   decoration: BoxDecoration(
//                     color: AppColors.appBlue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Icon(Icons.description, color: Colors.white70, size: 20),
//                       SizedBox(width: 12),
//                       Text('my_resume_final.pdf', style: AppTextStyles.white20bold),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 35),
//
//                 // View Resume Button
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(40),
//                     border: Border.all(color: AppColors.appBlue, width: 0.5),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       'View Resume',
//                       style: AppTextStyles.white24Bold,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 15),
//
//                 // Continue Button
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => HomeScreen(activeStep: 2),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: AppColors.appBlue,
//                       borderRadius: BorderRadius.circular(40),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Continue',
//                         style: AppTextStyles.white24Bold,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 50),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:math';

class ResumeCompletedPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  ResumeCompletedPage({required this.userData});

  @override
  _ResumeCompletedPageState createState() => _ResumeCompletedPageState();
}

class _ResumeCompletedPageState extends State<ResumeCompletedPage> {
  int currentTemplateIndex = 0;

  void refreshTemplate() {
    setState(() {
      currentTemplateIndex = Random().nextInt(5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101820),
      appBar: AppBar(
        title: const Text("Choose Template", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.cyanAccent, size: 28),
            onPressed: refreshTemplate,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Style #${currentTemplateIndex + 1} Selected",
                style: const TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: getTemplate(currentTemplateIndex),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  // Download Logic (PDF Generation)
                },
                icon: const Icon(Icons.download, color: Colors.black),
                label: const Text("Download PDF", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getTemplate(int index) {
    // Keys matched with Chat Page
    final String name = widget.userData['name'] ?? 'Your Name';
    final String role = widget.userData['role'] ?? 'Your Role';
    final String email = widget.userData['email'] ?? 'email@example.com';
    final String phone = widget.userData['phone'] ?? '0000000000';
    final String summary = widget.userData['profile_summary'] ?? 'Professional Summary';

    // Convert projects/education lists to text for simple display
    final List projects = widget.userData['projects'] ?? [];
    final List education = widget.userData['education'] ?? [];

    switch (index) {
      case 0: return _modernTemplate(name, role, email, phone, summary, projects, education, index);
      case 1: return _classicTemplate(name, role, email, phone, summary, projects, education, index);
      case 2: return _creativeTemplate(name, role, email, phone, summary, projects, education, index);
      case 3: return _minimalistTemplate(name, role, email, phone, summary, projects, education, index);
      case 4: return _darkElegantTemplate(name, role, email, phone, summary, projects, education, index);
      default: return _modernTemplate(name, role, email, phone, summary, projects, education, index);
    }
  }

  // --- TEMPLATE 1: MODERN ---
  Widget _modernTemplate(String name, String role, String email, String phone, String summary, List projs, List edu, int idx) {
    return Container(
      key: ValueKey("temp_$idx"),
      padding: const EdgeInsets.all(25),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[900])),
          Text(role, style: TextStyle(fontSize: 16, color: Colors.blue[600], fontWeight: FontWeight.w500)),
          const Divider(thickness: 2, height: 30),
          _title("CONTACT"),
          Text("📧 $email\n📞 $phone"),
          _title("SUMMARY"),
          Text(summary),
          _title("EDUCATION"),
          ...edu.map((e) => Text("• ${e['college']} (${e['percentage']}%)")),
          _title("PROJECTS"),
          ...projs.map((p) => Text("• ${p['title']}: ${p['tech']}")),
        ],
      ),
    );
  }

  // --- TEMPLATE 2: CLASSIC ---
  Widget _classicTemplate(String name, String role, String email, String phone, String summary, List projs, List edu, int idx) {
    return Container(
      key: ValueKey("temp_$idx"),
      padding: const EdgeInsets.all(25),
      color: Colors.white,
      child: Column(
        children: [
          Text(name.toUpperCase(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
          Text(role),
          const SizedBox(height: 10),
          Text("$email | $phone", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          const Divider(color: Colors.black, thickness: 1),
          _classicSection("SUMMARY", summary),
          _classicSection("EDUCATION", edu.isEmpty ? "No data" : edu.first['college']),
          _classicSection("PROJECTS", projs.isEmpty ? "No data" : projs.first['title']),
        ],
      ),
    );
  }

  // --- TEMPLATE 3: CREATIVE ---
  Widget _creativeTemplate(String name, String role, String email, String phone, String summary, List projs, List edu, int idx) {
    return Container(
      key: ValueKey("temp_$idx"),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.cyanAccent, width: 2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            color: const Color(0xFF101820),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const CircleAvatar(backgroundColor: Colors.cyanAccent, radius: 30, child: Icon(Icons.person, color: Colors.black)),
                const SizedBox(height: 20),
                const Text("CONTACT", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 10)),
                Text(email, style: const TextStyle(color: Colors.white, fontSize: 8), textAlign: TextAlign.center),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(role, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 15),
                  const Text("ABOUT ME", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  Text(summary, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- TEMPLATE 4: MINIMALIST ---
  Widget _minimalistTemplate(String name, String role, String email, String phone, String summary, List projs, List edu, int idx) {
    return Container(
      key: ValueKey("temp_$idx"),
      padding: const EdgeInsets.all(30),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontSize: 28, letterSpacing: -1, fontWeight: FontWeight.w300)),
          Text(role.toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 2)),
          const SizedBox(height: 30),
          Text(summary, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[800])),
          const SizedBox(height: 20),
          const Text("CONTACT", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("$email\n$phone"),
        ],
      ),
    );
  }

  // --- TEMPLATE 5: DARK ELEGANT ---
  Widget _darkElegantTemplate(String name, String role, String email, String phone, String summary, List projs, List edu, int idx) {
    return Container(
      key: ValueKey("temp_$idx"),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontSize: 24, color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
          Text(role, style: const TextStyle(color: Colors.white70)),
          const Divider(color: Colors.white24, height: 30),
          const Text("SUMMARY", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold)),
          Text(summary, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          const Text("LATEST PROJECT", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold)),
          Text(projs.isEmpty ? "None" : projs.first['title'], style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // Helpers
  Widget _title(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 5),
    child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 13)),
  );

  Widget _classicSection(String title, String content) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 15),
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      Text(content, style: const TextStyle(fontSize: 13)),
    ],
  );
}