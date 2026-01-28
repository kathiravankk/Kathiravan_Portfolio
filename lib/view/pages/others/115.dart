import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';


class InternshipListPage extends StatefulWidget {
  const InternshipListPage({super.key});

  @override
  State<InternshipListPage> createState() => _InternshipListPageState();
}

class _InternshipListPageState extends State<InternshipListPage> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'IT',
    'Marketing',
    'Design',
    'Finance',
  ];
  final List<Map<String, dynamic>> internshipData = [
    {
      'postedDate': '1 Day Ago',
      'title': 'Flutter Developer',
      'company': 'TechSpark',
      'location': 'Chennai',
      'duration': '3 Months',
      'stipend': '8K',
      'education': 'B.Sc / BCA',
      'availability': 'Fresher',
      'daysLeft': 10,
    },
    {
      'postedDate': '3 Days Ago',
      'title': 'Web Developer',
      'company': 'AgroSoft',
      'location': 'Coimbatore',
      'duration': '2 Months',
      'stipend': '12K',
      'education': 'B.Tech',
      'availability': 'Immediate',
      'daysLeft': 7,
    },
    {
      'postedDate': '5 Days Ago',
      'title': 'App Developer',
      'company': 'CodeHive',
      'location': 'Trichy',
      'duration': '4 Months',
      'stipend': '10K',
      'education': 'B.Sc IT',
      'availability': 'Fresher',
      'daysLeft': 15,
    },
    {
      'postedDate': 'Today',
      'title': 'UI/UX Designer',
      'company': 'Bright Labs',
      'location': 'Bangalore',
      'duration': '3 Months',
      'stipend': '6K',
      'education': 'Any Degree',
      'availability': 'Part Time',
      'daysLeft': 5,
    },
    {
      'postedDate': '2 Days Ago',
      'title': 'Backend Developer',
      'company': 'SoftMatrix',
      'location': 'Chennai',
      'duration': '6 Months',
      'education': 'B.E / B.Tech',
      'availability': 'Immediate',
      'daysLeft': 20,      'stipend': '15K',

    },
  ];

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {Navigator.pop(context);},
                ),
                SizedBox(width: 10),
                Text(
                  "IT/Software",
                  style: TextStyle(fontSize: 24, color: AppColors.appYellow),
                ),
              ],
            ),

            SizedBox(height: 10),
            Text(
              "120+ Internships Available",
             style: AppTextStyles.white24Bold,

            ),
            Text(
              "Explore opportunities in IT / Software and success",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),   const SizedBox(height: 10),
            _buildSearchBar(),

            // Search bar
            const SizedBox(height: 10),

            // Internship cards list
            Expanded(
              child: SizedBox(
                height: 180,
                child: ListView.builder(
                  itemCount: internshipData.length,
                  itemBuilder: (context, index) {
                    final item = internshipData[index];

                    return _buildInternshipCard(
                      postedDate: item['postedDate'],
                      title: item['title'],
                      company: item['company'],
                      location: item['location'],
                      duration: item['duration'],
                      stipend: item['stipend'],
                      education: item['education'],
                      availability: item['availability'],
                      daysLeft: item['daysLeft'],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
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
    return Column(
      children: [
        Container(
          // width: 300,

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
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                          ),SizedBox(width: 4,),
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
                  Container(padding: EdgeInsets.all(0.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 0.5                                  ),
                    ),
                    child: Image(
                      width: 40,
                      image: AssetImage("lib/assets/images/Ellipse 9.png"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

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

              const SizedBox(height: 4),

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
                      color: const Color(0xFFFFB800),
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
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.money,
                          size: 14,
                          color: Colors.grey,
                        ),SizedBox(width: 5),
                        Text(
                          'Stipend : $stipend',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),
              // Education & Availability
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Education : ',
                                style: TextStyle(color: AppColors.appBlue, fontSize: 12),
                              ),
                              Text(
                                education,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),   ],
                              ),

                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Text(
                                'Available : ',
                                style: TextStyle(color: AppColors.appBlue, fontSize: 12),
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
                      ),   ],
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
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF042e84),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Apply Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
,
                ],
              ),

              // const Spacer(),

              // Footer
            ],
          ),
        ),
        SizedBox(height: 15,)
      ],
    );
  }
}

Widget _buildSearchBar() {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(28),
    ),
    child: Row(
      children: [
        const SizedBox(width: 20),
        const Icon(Icons.search, color: Colors.grey, size: 24),
        const SizedBox(width: 12),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.grey, size: 24),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    ),
  );
}
