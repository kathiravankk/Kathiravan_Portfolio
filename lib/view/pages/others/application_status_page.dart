import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';

class ApplicationStatusPage extends StatefulWidget {
  const ApplicationStatusPage({super.key});

  @override
  State<ApplicationStatusPage> createState() => _ApplicationStatusPageState();
}

class _ApplicationStatusPageState extends State<ApplicationStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
              onPressed: () => Navigator.pop(context),
            ),

            // Job Title & Company Info
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Team Leader', style: AppTextStyles.white24Bold),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text('Infosys', style: AppTextStyles.yellow18Bold),
                            SizedBox(width: 8),
                            Text(
                              '(',
                                style: AppTextStyles.white16
                            ),
                            Icon(
                              Icons.star,
                              color: AppColors.appYellow,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '3.8 Reviews )',
                              style: AppTextStyles.white16
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '1000 Applicants',
                          style: TextStyle(
                            color: AppColors.appYellow,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        // View Description Button
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.appYellow,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'View Describtion',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Your Application Status Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Application Status',
                          style: AppTextStyles.white24Bold
                        ),
                        SizedBox(height: 20),

                        // Status Timeline
                        _buildStatusItem(
                          icon: Icons.check_circle,
                          title: 'Applied',
                          date: '03 March 2025',
                          isCompleted: true,
                          showLine: true,
                        ),

                        _buildStatusItem(
                          icon: Icons.check_circle,
                          title: 'Application Sent',
                          date: '04 March 2025',
                          isCompleted: true,
                          showLine: true,
                        ),

                        _buildStatusItem(
                          icon: Icons.circle_outlined,
                          title: 'Application View by recruiter',
                          date: '',
                          isCompleted: false,
                          showLine: false,
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Similar Internship Section
                    Text(
                      'Similar Internship',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Similar Internship Cards
                    SizedBox(
                      height: 230,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        children: [
                          _buildInternshipCard(
                            title: 'UI/UX DESIGNER',
                            company: 'Cognizant',
                            location: 'Chennai',
                            postedDate: '2 Days Ago',
                            // description: 'To connect this element to content from your collection, select the element and click Connect to Data.',
                            duration: '3 Month',
                            stipend: '10K',
                            education: 'B.Sc',
                            availability: 'Fresher',
                            daysLeft: 12,
                            // logoUrl: 'lib/asset/images/cognizant_logo.png',
                          ),
                          SizedBox(width: 16),
                          _buildInternshipCard(
                            title: 'Web DEVELOPER',
                            postedDate: '2 Days Ago',
                            company: 'HCL',
                            location: 'Chennai',
                            // description: 'To connect this element to content from your collection, select the element and click Connect to Data.',
                            duration: '2 Month',
                            stipend: '10K',
                            education: 'B.Tech',
                            availability: 'Fresher',
                            daysLeft: 12,
                            // logoUrl: 'lib/asset/images/hcl_logo.png',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    required String date,
    required bool isCompleted,
    required bool showLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? Color(0xFF0066FF) : Colors.grey[800],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 60,
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white.withOpacity(0.3)],
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (date.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    date,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ),
              SizedBox(height: showLine ? 20 : 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInternshipCard({
    required String postedDate,
    required String title,
    required String company,
    required String location,
    required String duration,
    required String stipend,
    required String education,
    required String availability,
    required int daysLeft,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posted Date
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Text(
              postedDate,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
          const SizedBox(height: 5),

          // Title & Company
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.appBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        company,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          color: AppColors.appBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
                child: Image(
                  width: 40,
                  image: AssetImage("lib/assets/images/Ellipse 9.png"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Description
          Text(
            'To connect this element to content from your collection, select the element and click Connect to Data.',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          // Duration & Stipend
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.appYellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Duration : $duration',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  // border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.money, size: 14, color: Colors.black),
                    SizedBox(width: 5),
                    Text(
                      'Stipend : $stipend',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Education & Availability
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Education : ',
                        style: TextStyle(
                          color: AppColors.appBlue,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        education,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Available : ',
                        style: TextStyle(
                          color: AppColors.appBlue,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        availability,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$daysLeft Days Left To Apply',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 5),
              InkWell(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.internshipDetailsPage,

                  );

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF042e84),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          // const Spacer(),

          // Footer
        ],
      ),
    );
  }
}
