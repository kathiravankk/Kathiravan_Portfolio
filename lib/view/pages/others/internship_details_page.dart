import 'package:flutter/material.dart';
import 'package:internsharks/core/const_file/app_button.dart';import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';

import '../../../controllers/login_controller.dart';
import '../../../core/const_file/app_button.dart';
import '../../../core/const_file/app_colors.dart';
import '../../../core/const_file/app_text_style.dart';
import '../../../core/routes/app_pages.dart';


import '../kyc/job_apply_successfull.dart';
import '../kyc/successful_page.dart';

class InternshipDetailsPage extends StatefulWidget {
  const InternshipDetailsPage({Key? key}) : super(key: key);

  @override
  State<InternshipDetailsPage> createState() => _InternshipDetailsPageState();
}

class _InternshipDetailsPageState extends State<InternshipDetailsPage> {
  int selectedTab = 0;
  bool isApplied = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/asset/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header with back button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'App Developer Executive',
                      style: AppTextStyles.white24Bold,
                    ),
                    const SizedBox(height: 8),

                    // Company name and rating
                    Row(
                      children: const [
                        Text('Agro', style: AppTextStyles.yellow18Bold),
                        SizedBox(width: 8),
                        Text(
                          ' (',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Icon(Icons.star, color: AppColors.appYellow, size: 18),
                        Text(
                          '3.8 Reviews',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' )',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Applicants count
                    const Text(
                      '1000 Applicants',
                      style: TextStyle(color: Color(0xFFD4A574), fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    // Duration and Stipend chips
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.appYellow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.black,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Duration : 3 Month',
                                style: AppTextStyles.black14bold,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.money, size: 18, color: Colors.black),
                              SizedBox(width: 6),
                              Text(
                                'Stipend : 10K',
                                style: AppTextStyles.black14bold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Apply by date
                    Row(
                      children: const [
                        Icon(Icons.alarm, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Apply by 15 Apr',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tab buttons
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTabButton('Internship Details', 0),
                          const SizedBox(width: 6),
                          _buildTabButton('About Company', 1),
                          const SizedBox(width: 6),
                          _buildTabButton('Reviews', 2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // TAB CONTENT (changes with selectedTab)
                    Column(children: [_buildTabContent()]),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            AppButton.AppContainerButton(
              onTap: () async {
                if (isApplied) return; // Prevent multiple apply

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => JobApplySuccesfull()),
                );

                if (result == true) {
                  setState(() {
                    isApplied = true;   // 🔥 Button changes to APPLIED
                  });
                }
              },

              text: isApplied ? 'Applied' : 'Apply Now',
              verticalPadding: 15,
              bgColor: isApplied ? Colors.grey : AppColors.appBlue,
              borderRadius: 30,
              textStyle: AppTextStyles.white18bold,
            )

          ],
        ),
      ),

      // Apply Now button
    );
  }

  // Returns different content based on selectedTab
  Widget _buildTabContent() {
    switch (selectedTab) {
      case 1:
        // ABOUT COMPANY
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About Internship
            const Text(
              'Who is eligible to apply',
              style: AppTextStyles.white24Bold,
            ),
            const SizedBox(height: 8),

            // Internship points
            _buildInternshipPoint(
              '1.',
              'Students who can join immediately are eligible to apply.',
            ),
            const SizedBox(height: 16),
            _buildInternshipPoint(
              '2.',
              ' who are available for a full-time internship can apply.',
            ),
            const SizedBox(height: 16),
            _buildInternshipPoint(
              '3.',
              ' who are available for Duration of 3 Months',
            ),
            const SizedBox(height: 16),
            _buildInternshipPoint('4.', 'Have relevant skills and interests'),

            const Text('About Company', style: AppTextStyles.white24Bold),
            const SizedBox(height: 8),
            Row(
              children: [
                Image(
                  width: 40,
                  image: AssetImage("lib/asset/images/Ellipse 9.png"),
                ),
                SizedBox(width: 10),
                Text(
                  'Agro',
                  style: TextStyle(color: AppColors.appYellow, fontSize: 18),
                ),
              ],
            ),

            Row(
              children: [
                Text(' (', style: TextStyle(color: Colors.white, fontSize: 16)),
                Icon(Icons.star, color: AppColors.appYellow, size: 18),
                Text(
                  '3.8 Reviews',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(' )', style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),

            const Text(
              'Agro is a leading agri-tech startup focusing on sustainable farming solutions. We build apps and platforms to help farmers increase yield and reduce cost.',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Website: ',
                    style: TextStyle(
                      color: AppColors.appBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'www.agro.example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Company Size: ',
                    style: TextStyle(
                      color: Color(0xFF00CED1),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '50 - 200 employees',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Locations', style: AppTextStyles.white24Bold),
            const SizedBox(height: 8),
            const Text(
              'Chennai, Bangalore, Hyderabad',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        );

      case 2:
        // REVIEWS
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('About Company', style: AppTextStyles.white24Bold),
            const SizedBox(height: 8),
            Row(
              children: [
                Image(
                  width: 40,
                  image: AssetImage("lib/asset/images/Ellipse 9.png"),
                ),
                SizedBox(width: 10),
                Text(
                  'Agro',
                  style: TextStyle(color: AppColors.appYellow, fontSize: 18),
                ),
              ],
            ),

            Row(
              children: [
                Text(' (', style: TextStyle(color: Colors.white, fontSize: 16)),
                Icon(Icons.star, color: AppColors.appYellow, size: 18),
                Text(
                  '3.8 Reviews',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(' )', style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),

            const Text(
              'Agro is a leading agri-tech startup focusing on sustainable farming solutions. We build apps and platforms to help farmers increase yield and reduce cost.',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Website: ',
                    style: TextStyle(
                      color: AppColors.appBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'www.agro.example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Company Size: ',
                    style: TextStyle(
                      color: Color(0xFF00CED1),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '50 - 200 employees',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Locations', style: AppTextStyles.white24Bold),
            const SizedBox(height: 8),
            const Text(
              'Chennai, Bangalore, Hyderabad',
              style: TextStyle(color: Colors.white70),
            ),
            const Text('Reviews', style: AppTextStyles.white24Bold),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  reviewCard(
                    name: "Vicky",
                    message:
                        "Agro provides amazing learning opportunities, a collaborative team culture, and strong job stability.",
                  ),
                  reviewCard(
                    name: "Meera",
                    message:
                        "Very good working environment, supportive mentors and real world exposure.",
                  ),
                  reviewCard(
                    name: "Arun",
                    message: "Great place for freshers to learn and grow fast.",
                  ),
                ],
              ),
            ),
          ],
        );

      case 0:
      default:
        // INTERNSHIP DETAILS (default)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description', style: AppTextStyles.white24Bold),
            const SizedBox(height: 6),
            const Text(
              'I\'m looking for a app developer role at Infosys, focusing on building and maintaining web applications using modern frameworks, ensuring performance and user experience.',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 12),

            // Location
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Location : ',
                    style: TextStyle(
                      color: AppColors.appBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Chennai',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Skills
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Skills : ',
                    style: TextStyle(
                      color: Color(0xFF00CED1),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Html, Css, Javascript, React, Bootstrap, Node.js, MongoDB',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // About Internship
            const Text('About Internship', style: AppTextStyles.white24Bold),
            const SizedBox(height: 8),

            // Internship points
            _buildInternshipPoint(
              '1.',
              'Provide technical expertise and coordinate day-to-day implementation of assigned projects.',
            ),
            const SizedBox(height: 16),
            _buildInternshipPoint(
              '2.',
              'Build products across the stack with a firm understanding of web frameworks, APIs, databases, and multiple back-end languages.',
            ),
            const SizedBox(height: 16),
            _buildInternshipPoint(
              '3.',
              'Provide technical expertise and coordinate day-to-day implementation of assigned projects.',
            ),
            const SizedBox(height: 16),
            _buildInternshipPoint(
              '4.',
              'Build products across the stack with a firm understanding of web frameworks, APIs, databases, and multiple back-end languages.',
            ),
          ],
        );
    }
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E3A8A) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3A8A) : Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildInternshipPoint(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(String name, String comment, int rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(child: Text(name[0]), backgroundColor: Colors.white12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: AppColors.appYellow,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget reviewCard({required String name, required String message}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 150,
      width: 250,

      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header yellow box
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.appYellow, // yellow bg
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: AssetImage(
                        "lib/asset/images/profile_icon.png",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Message
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
