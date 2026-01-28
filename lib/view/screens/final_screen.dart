import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:share_plus/share_plus.dart';

import 'home_Screen.dart';

class FinalScreen extends StatefulWidget {
  const FinalScreen({super.key});

  @override
  State<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  void _handleShare() {
    Share.share('Check out my resume - Anantha Krishnan\nFull Stack Developer');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
          child: Column(
            children: [
              // Header
              SizedBox(height: 10),
              const Text(
                "Amazing! Your ResDP to\nStandsup!",
                style: TextStyle(
                  color: AppColors.appYellow,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                // height: imf,
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

              SizedBox(height: 20),
              // Continue Button
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(activeStep: 3),
                          ),
                        );
                      },
                      child: Container(
                        // width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.cyan, width: 2),
                          color: Colors.transparent,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Finish',
                          style: AppTextStyles.white24Bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),



                  GestureDetector(onTap:_handleShare ,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      // height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xff01cdcd), Color(0xff81fbfb)],
                          begin: AlignmentGeometry.centerLeft,
                                   end:AlignmentGeometry.centerRight,
                        ),
                        // borderRadius: BorderRadius.circular(30),
                        // border: Border.all(color: Colors.cyan, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.share, color: Colors.white),
                    ),
                  ),
                ],
              ),

              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
