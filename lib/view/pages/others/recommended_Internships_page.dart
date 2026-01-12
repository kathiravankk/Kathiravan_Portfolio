import 'package:flutter/material.dart';import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';

class RecommendedInternshipsPage extends StatefulWidget {
  const RecommendedInternshipsPage({super.key});

  @override
  State<RecommendedInternshipsPage> createState() => _RecommendedInternshipsPageState();
}

class _RecommendedInternshipsPageState extends State<RecommendedInternshipsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/asset/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          children: [SizedBox(height: 20,),
            Row(
              children: [    IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () {Navigator.pop(context);},
              ),
                const SizedBox(width: 6),

                Text(
                  "Recommended Internships",
                  style: AppTextStyles.white24Bold,
                ),

              ],
            ),

            Expanded(
              child: ListView.builder(
                // padding: const EdgeInsets.all(16),
                itemCount: 15, // show 15 cards
                itemBuilder: (context, index) {
                  return _buildInternshipCard(
                    postedDate: "2 Days Ago",
                    title: index % 2 == 0 ? "APP DEVELOPER" : "WEB DEVELOPER",
                    company: index % 2 == 0 ? "Agro" : "HCL",
                    location: index % 2 == 0 ? "Trichy" : "Chennai",
                    duration: index % 2 == 0 ? "3 Month" : "2 Month",
                    stipend: "10K",
                    education: index % 2 == 0 ? "B.Sc" : "B.Tech",
                    availability: "Fresher",
                    daysLeft: 12,
                  );
                },
              ),
            ),
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posted
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              postedDate,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),

          const SizedBox(height: 6),

          // Title row
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
                  Row(
                    children: [
                      Text(
                        company,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),SizedBox(width: 4,),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.appBlue,
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
                  image: AssetImage("lib/asset/images/Ellipse 9.png"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Description dummy
          Text(
            "To connect this element to content from your collection...",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),

          const SizedBox(height: 8),

          // Duration + stipend
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:AppColors.appYellow,
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
                      "Duration : $duration",
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
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(color: Colors.grey.shade300,
                  // border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      size: 14,
                      color: Colors.black,
                    ),
                    Text(
                      "Stipend : $stipend",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Education + Availability
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(      crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(

                    children: [
                      Row(
                        children: [
                          Text(
                            "Education: ",
                            style: TextStyle(color: AppColors.appBlue, fontSize: 12),
                          ),
                          Text(
                            education,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),SizedBox(width: 10,),
                      Row(
                        children: [
                          Text(
                            "Available: ",
                            style: TextStyle(color: AppColors.appBlue, fontSize: 12),
                          ),
                          Text(
                            availability,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),                  Text(
                    "$daysLeft Days Left To Apply",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),

              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   AppPageRoute(page: InternshipDetailsPage()),
                  // );
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
        ],
      ),
    );
  }
}
