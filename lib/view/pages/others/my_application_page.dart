import 'package:flutter/material.dart';import 'package:internsharks/core/const_file/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';
import 'package:internsharks/core/routes/app_pages.dart';
class MyApplicationPage extends StatefulWidget {
  const MyApplicationPage({super.key});

  @override
  State<MyApplicationPage> createState() => _MyApplicationPageState();
}

class _MyApplicationPageState extends State<MyApplicationPage> {
  int selectedTab = 0;

  List<String> tabs = ["All", "Pending", "Reviewed"];

  /// ----------------- JOB DATA (FULL LIST) -----------------
  List<Map<String, dynamic>> jobs = [
    {
      "logo": "lib/asset/images/Ellipse 9.png",
      "title": "Team Leader",
      "company": "Infosys",
      "status": "Pending",
      "color": AppColors.appYellow,
    },
    {
      "logo": "lib/asset/images/Ellipse 9.png",
      "title": "Product Design Intern",
      "company": "Innovate inc",
      "status": "Reviewed",
      "color": AppColors.appYellow,
    },
  ];

  /// ----------------- FILTER LOGIC -----------------
  List<Map<String, dynamic>> get filteredJobs {
    if (selectedTab == 0) return jobs; // All
    if (selectedTab == 1) {
      return jobs.where((job) => job["status"] == "Pending").toList();
    }
    return jobs.where((job) => job["status"] == "Reviewed").toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/asset/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ------- TOP HEADER -------
            const SizedBox(height: 20),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 5),
                const Text("My Application", style: AppTextStyles.yellow24Bold),
              ],
            ),

            const SizedBox(height: 30),

            /// ------- TABS -------
            Row(
              children: List.generate(tabs.length, (index) {
                bool isSelected = selectedTab == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            /// ------- JOB LIST -------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: filteredJobs.map((job) {
                    return Column(
                      children: [
                        _jobCard(
                          logo: job["logo"],
                          jobTitle: job["title"],
                          company: job["company"],
                          status: job["status"],
                          statusColor: job["color"],
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ------- JOB CARD UI -------
  Widget _jobCard({
    required String logo,
    required String jobTitle,
    required String company,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      height: 95,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Logo
          Container(
            padding: EdgeInsets.all(0.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Image(width: 40, image: AssetImage(logo)),
          ),

          const SizedBox(width: 15),

          /// Job details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  company,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff042ed4),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          /// Badge
          Container(width: 80,
            padding: const EdgeInsets.symmetric(vertical: 6,),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
