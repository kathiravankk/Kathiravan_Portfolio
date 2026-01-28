import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart' show GetNavigation;
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';

class AppliesPage extends StatefulWidget {
  final bool showBack;

  const AppliesPage({super.key, this.showBack = false});

  @override
  State<AppliesPage> createState() => _AppliesPageState();
}

class _AppliesPageState extends State<AppliesPage> {
  final List<Map<String, String>> sampleData = const [
    {
      'title': 'TEAM LEADER',
      'company': 'Infosys',
      'location': 'Bangalore',
      'desc':
          'To connect this element to content from your collection, select the element and click Connect to Data.',
      'applied': 'Applied Today',
      // Use either asset path or network url
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/6/6e/Infosys_logo.png',
    },
    {
      'title': 'Frontend Developer',
      'company': 'Infosys',
      'location': 'Bangalore',
      'desc':
          'To connect this element to content from your collection, select the element and click Connect to Data.',
      'applied': 'Applied 2 days ago',
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/6/6e/Infosys_logo.png',
    },
    {
      'title': 'Support Associate',
      'company': 'Infosys',
      'location': 'Bangalore',
      'desc':
          'To connect this element to content from your collection, select the element and click Connect to Data.',
      'applied': 'Applied Today',
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/6/6e/Infosys_logo.png',
    },
  ];

  Color get teal => const Color(0xFF08B9B9);

  Color get yellow => const Color(0xFFF2C94C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor, // matches screenshot background
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
          children: [
            SizedBox(height: 20),
            // Header
            Row(
              mainAxisAlignment: widget.showBack
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                if (widget.showBack)
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    splashRadius: 22,
                  ),
                const SizedBox(width: 8),
                Text('Applies', style: AppTextStyles.yellow24Bold),
              ],
            ),

            // Content list
            Expanded(
              child: ListView.separated(
                // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                itemBuilder: (context, index) {
                  final item = sampleData[index];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.applicationStatusPage,

                      );
                    },
                    child: _JobCard(
                      title: item['title']!,
                      company: item['company']!,
                      location: item['location']!,
                      desc: item['desc']!,
                      appliedText: item['applied']!,
                      logoUrl: item['logo']!,
                      teal: teal,
                      yellow: yellow,
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemCount: sampleData.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String desc;
  final String appliedText;
  final String logoUrl;
  final Color teal;
  final Color yellow;

  const _JobCard({
    Key? key,
    required this.title,
    required this.company,
    required this.location,
    required this.desc,
    required this.appliedText,
    required this.logoUrl,
    required this.teal,
    required this.yellow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // white rounded card with big radius like screenshot
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo circle
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
              const SizedBox(width: 16),

              // Details column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: AppColors.appBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // const SizedBox(height: 6),

                    // Company and location row
                    Row(
                      children: [
                        Text(
                          company,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(
                            color: AppColors.appBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    // const SizedBox(height: 12),

                    // Description (small grey)
                  ],
                ),
              ),
            ],
          ),
          Text(desc, style: const TextStyle(color: Colors.black54)),

          const SizedBox(height: 12),

          // Applied pill
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 180,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.appYellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade900,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    appliedText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
