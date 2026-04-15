import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/core/const_file/app_button.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  bool isLiked = false;
  bool showAiAssistant = false;
  final TextEditingController _aiController = TextEditingController();

  @override
  void dispose() {
    _aiController.dispose();
    super.dispose();
  }

  void _handleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _handleShare() {
    Share.share('Check out my resume - Anantha Krishnan\nFull Stack Developer');
  }

  void _handleView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FullResumeView()),
    );
  }

  Future<void> _handleDownload() async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(child: pw.Text('Anantha Krishnan - Resume'));
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/resume.pdf");
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resume downloaded to ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download functionality ready!')),
      );
    }
  }

  void _handleAiSubmit() {
    if (_aiController.text.trim().isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('AI Resume Assistant'),
          content: Text(
            'Processing: "${_aiController.text}"\nImproving your resume...',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _aiController.clear();
              },
              child: const Text('OK', style: TextStyle(color: Colors.cyan)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("lib/assets/images/login_bg.png"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text('Resume', style: AppTextStyles.white24Bold),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(Icons.stars, color: AppColors.appYellow, size: 16),
                        SizedBox(width: 4),
                        Text('Credit: 100', style: AppTextStyles.white16),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F1E8),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tech Icons Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text('🌀', style: TextStyle(fontSize: 20)),
                              Text('☕', style: TextStyle(fontSize: 20)),
                              Text('📦', style: TextStyle(fontSize: 20)),
                              Text('📄', style: TextStyle(fontSize: 20)),
                              Text('🔷', style: TextStyle(fontSize: 20)),
                              Text('📱', style: TextStyle(fontSize: 20)),
                              Text('🎨', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Name and Title
                          const Center(
                            child: Column(
                              children: [
                                Text(
                                  'Anantha Krishnan',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Full Stack Developer',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Chennai, Tamil Nadu | ananthak@mail.com | 9876123456',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Profile Summary
                          const Text(
                            'PROFILE SUMMARY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Divider(color: Colors.black38, thickness: 1),
                          const Text(
                            'All Stack Developer with 5+ years of experience in designing and developing scalable enterprise applications in Java, Spring Boot, Hibernate, REST APIs, and microservices. Strong problem-solver with expertise in cloud deployment (AWS), and CI/CD pipelines with a focus on high-quality solutions.',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Skills
                          const Text(
                            'SKILLS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Divider(color: Colors.black38, thickness: 1),
                          const Text(
                            'Lang: Java, Spring Boot, Hibernate, JPA, Microservices, REST APIs\nFront: React.js, NodeJS, JavaScript, TypeScript, HTML5, CSS, Tailwind\nDB: MySQL, PostgreSQL, MongoDB, Oracle\nTools & Platforms: Git, Jenkins, Docker, Maven, AWS, Jenkins, CI/CD',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Experience
                          const Text(
                            'EXPERIENCE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Divider(color: Colors.black38, thickness: 1),
                          const Text(
                            'Tata Chennail\n2023 - Present\n\nJava Full Stack Developer\nLeveraging expertise in full stack development using Java, Spring Boot, and Angular to build and maintain scalable applications. Implemented RESTful APIs and microservices for seamless communication between modules.',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Action Buttons
                  Container(
                    width: 270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: AppColors.thirdColor,
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                          onTap: _handleLike,
                        ),
                        _buildActionButton(
                          icon: Icons.share_outlined,
                          color: Colors.white,
                          onTap: _handleShare,
                        ),
                        _buildActionButton(
                          icon: Icons.remove_red_eye_outlined,
                          color: Colors.white,
                          onTap: _handleView,
                        ),
                        _buildActionButton(
                          icon: Icons.download_outlined,
                          color: Colors.white,
                          onTap: _handleDownload,
                        ),
                        Container(
                          // color: AppColors.appColor,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.appBlue,
                            shape: BoxShape.circle,
                          ),
                          child: _buildActionButton(
                            icon: Icons.refresh,
                            color: Colors.white,
                            onTap: () {
                              setState(() {
                                showAiAssistant = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Success Message
                  const Column(
                    children: [
                      Text(
                        'Wow! Your Ready to Impress..!',
                        style: AppTextStyles.yellow24Bold,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your resume shines! Its perfectly crafted to catch employers eyes,"
                        " highlighting your unique strengths and achievements. "
                        "Youre ready to make a powerful first impression!",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 80),

                  // AI Resume Assistant
                  // Visibility( visible: showAiAssistant, child:
                  //    Column(
                  //      crossAxisAlignment: CrossAxisAlignment.start,
                  //      children: [
                  //        const Text(
                  //          'AI Resume Assistant',
                  //          style: TextStyle(
                  //            fontSize: 16,
                  //            fontWeight: FontWeight.bold,
                  //            color: Colors.white,
                  //          ),
                  //        ),
                  //        const SizedBox(height: 10),
                  //        Container(
                  //          decoration: BoxDecoration(
                  //            borderRadius: BorderRadius.circular(30),
                  //            color: AppColors.thirdColor,
                  //            border: Border.all(color: Colors.white24, width: 1),
                  //          ),
                  //          // padding: const EdgeInsets.symmetric(vertical: 12),
                  //          child: TextFormField(
                  //            controller: _aiController,
                  //            keyboardType: TextInputType.multiline,
                  //            maxLines: null,       // 🔥 unlimited lines
                  //            minLines: 1,          // start with 1 line
                  //            style: const TextStyle(color: Colors.white),
                  //            decoration: InputDecoration(
                  //              hintText: 'Ask AI to improve your resume',
                  //              hintStyle: TextStyle(
                  //                color: Colors.grey[600],
                  //                fontSize: 14,
                  //              ),
                  //              border: InputBorder.none,
                  //              contentPadding: const EdgeInsets.symmetric(
                  //                horizontal: 20,
                  //                vertical: 14,
                  //              ),
                  //              suffixIcon: IconButton(
                  //                icon: Container(
                  //                  padding: const EdgeInsets.all(8),
                  //                  decoration: const BoxDecoration(
                  //                    color: Colors.cyan,
                  //                    shape: BoxShape.circle,
                  //                  ),
                  //                  child: const Icon(
                  //                    Icons.star_border,
                  //                    size: 20,
                  //                    color: Colors.black,
                  //                  ),
                  //                ),
                  //                onPressed: _handleAiSubmit,
                  //              ),
                  //            ),
                  //          )
                  //          ,
                  //        ),
                  //      ],
                  //    ),
                  //  ),
                  const SizedBox(height: 16),

                  AppButton.AppContainerButton(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.homeScreen,
                        arguments: {'activeStep': 2},
                      );


                    },
                    text: "Continue",verticalPadding: 10,
                    borderColor: AppColors.appBlue,
                    borderWidth: 2,
                    borderRadius: 30,
                    bgColor: Colors.transparent,
                    textStyle: AppTextStyles.white24Bold,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       AppPageRoute(page: HomeScreen(activeStep: 2)),
                  //     );
                  //   },
                  //   child: Container(
                  //     width: double.infinity,
                  //     // height: 55,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(30),
                  //       border: Border.all(color: Colors.cyan, width: 2),
                  //       color: Colors.transparent,
                  //     ),
                  //     alignment: Alignment.center,
                  //     child: Text('Continue', style: AppTextStyles.white24Bold),
                  //   ),
                  // ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: color, size: 20),
    );
  }
}

// Full Resume View Screen
class FullResumeView extends StatefulWidget {
  const FullResumeView({super.key});

  @override
  State<FullResumeView> createState() => _FullResumeViewState();
}

class _FullResumeViewState extends State<FullResumeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Full Resume View',style: AppTextStyles.white24Bold,),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F1E8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Anantha Krishnan',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Full Stack Developer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Chennai, Tamil Nadu | ananthakrishnan@mail.com | 9876123456',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'PROFILE SUMMARY',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Divider(color: Colors.black38, thickness: 2),
              const Text(
                'All Stack Developer with 5+ years of experience in designing and developing scalable enterprise applications in Java, Spring Boot, Hibernate, REST APIs, microservices, React, AWS, and MySQL. Strong problem-solver with expertise in full-stack development (OOPs, web development), cloud deployment (AWS), and CI/CD pipelines with a focus on delivering high-quality solutions.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'SKILLS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Divider(color: Colors.black38, thickness: 2),
              const Text(
                'Languages: Java, Spring Boot, Hibernate, JPA, Microservices, REST APIs\n\nFrontend: React.js, NodeJS, JavaScript, TypeScript, HTML5, CSS, Tailwind CSS\n\nDatabases: MySQL, PostgreSQL, MongoDB, Oracle\n\nTools & Platforms: Git, Jenkins, Docker, Maven, AWS, Jenkins, CI/CD pipelines, Eclipse',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'EXPERIENCE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Divider(color: Colors.black38, thickness: 2),
              const Text(
                'Tata Chennai\n2023 - Present\n\nJava Full Stack Developer\n\nLeveraging expertise in full stack development using Java, Spring Boot, and Angular to build and maintain scalable, high-performance enterprise applications. Implemented RESTful APIs and microservices architecture for seamless communication between modules, ensuring application performance by optimizing database queries and reducing API response times. Integrated AWS cloud provider for application deployment.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
