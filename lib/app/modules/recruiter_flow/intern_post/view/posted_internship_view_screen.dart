import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/app_background_widget.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/recruiter_flow/intern_post/controller/internship_post_controller.dart';

class PostedInternshipViewScreen extends StatefulWidget {
  const PostedInternshipViewScreen({super.key});

  @override
  State<PostedInternshipViewScreen> createState() => _PostedInternshipViewScreenState();
}

class _PostedInternshipViewScreenState extends State<PostedInternshipViewScreen> {
  final InternshipPostController postController =
  Get.find<InternshipPostController>();

  @override
  void initState() {
    super.initState();
    getInternshipData();
  }

  String? recruiterId = "";
  // TODO: replace with however you're passing the selected internship
  // e.g. String internshipId = Get.arguments['id'];
  String internshipId = Get.arguments?['id'] ?? "";

  Future<void> getInternshipData() async {
    recruiterId = await LocalStorageService.getRecruiterId();
    try {
      await postController.getPostedInternships(recruiterId: recruiterId!);
      if (postController.getResponseCode() == 200 ||
          postController.getResponseCode() == 201) {
      } else {
        AppFunctions.apiErrorHandling(
          postController.getResponseCode(),
          postController.internPostModel.message ??
              "Something went wrong!, Try again later",
        );
      }
    } catch (error) {
      AppFunctions.apiErrorHandling(
        postController.getResponseCode(),
        postController.internPostModel.message ??
            "Something went wrong!, Try again later",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBarWidget: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparentColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            Expanded(
              child: Text(
                "Internship Details",
                style: AppStyles.customTextStyle(
                  size: 19,
                  color: AppColors.secondaryColor,
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: navigate to full Internship Review section / scroll to it
              },
              icon: const Icon(Icons.rate_review_outlined,
                  size: 16, color: Colors.tealAccent),
              label: Text(
                "Internship Review",
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: Colors.tealAccent,
                  weight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.tealAccent, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      bodyWidget: Obx(() {
        // TODO: replace with your real loading flag from postController
        if (postController.internPostLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // TODO: replace with your actual lookup of the single internship by id
        final internship = postController.internPostModel.jobs?.firstWhere(
              (e) => e.id == internshipId,
          orElse: () => postController.internPostModel.jobs!.first,
        );

        if (internship == null) {
          return const Center(
            child: Text("Internship not found", style: TextStyle(color: Colors.grey)),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            _buildCompanyCard(internship),
            const SizedBox(height: 20),
            _buildSectionCard(
              icon: Icons.description_outlined,
              iconColor: Colors.purpleAccent,
              title: "About This Internship",
              child: Text(
                internship.aboutInternship ??
                    "This internship is designed for students who are passionate about learning and working on real-time projects. You will get hands-on experience and improve your skills.",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14.5,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.person_outline,
              iconColor: Colors.blueAccent,
              title: "Roles & Responsibilities",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // TODO: replace with internship.responsibilities (List<String>)
                children: (internship.studentQualification ??
                    [
                      "Assist in development and testing of applications",
                      "Work on assigned modules and tasks",
                      "Collaborate with the team to deliver quality solutions",
                      "Learn and implement new technologies",
                    ])
                    .map<Widget>((r) => _bulletPoint(r))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.code,
              iconColor: Colors.orangeAccent,
              title: "Skills Required",
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                // TODO: replace with internship.skillsRequired (List<String>)
                children: (internship.requiredSkills ??
                    ["HTML", "CSS", "JavaScript", "React", "Git"])
                    .map<Widget>((s) => _chip(s))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.school_outlined,
              iconColor: Colors.greenAccent,
              title: "Eligibility Criteria",
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                // TODO: replace with internship.eligibility (List<String>)
                children: (internship.studentQualification ?? ["BCA"])
                    .map<Widget>((e) => _chip(e))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildReviewSection(internship),
            const SizedBox(height: 16),
            _buildPostedDeadlineRow(internship),
            const SizedBox(height: 20),
            _buildViewApplicantsButton(internship),
          ],
        );
      }),
    );
  }

  Widget _buildCompanyCard(PostData internship) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: internship.companyLogo != null &&
                internship.companyLogo!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(internship.companyLogo!, fit: BoxFit.cover),
            )
                : const Icon(Icons.touch_app, color: Colors.black54, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  internship.companyName ?? "Company",
                  style: AppStyles.customTextStyle(
                    size: 19,
                    color: Colors.white,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.work_outline, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      internship.roleType ?? "",
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              // TODO: replace with internship.activeApplicantsCount or similar
              "${(internship.selectedApplicants ?? 2).toString().padLeft(2, '0')} ACTIVE",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).let((card) {
      return Column(
        children: [
          card,
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF16215B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _infoTile(
                        icon: Icons.location_on_outlined,
                        iconColor: Colors.redAccent,
                        label: "Location",
                        value: internship.companyCity ?? "-",
                      ),
                    ),
                    Expanded(
                      child: _infoTile(
                        icon: Icons.access_time,
                        iconColor: Colors.lightBlueAccent,
                        label: "Duration",
                        value: internship.internshipDuration ?? "-",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _infoTile(
                        icon: Icons.currency_rupee,
                        iconColor: Colors.greenAccent,
                        label: "Compensation",
                        value: internship.internshipMode ?? "Free Internship",
                      ),
                    ),
                    Expanded(
                      child: _infoTile(
                        icon: Icons.calendar_today_outlined,
                        iconColor: Colors.orangeAccent,
                        label: "Posted",
                        value: internship.createdAt ?? "-",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.school_outlined, size: 16, color: Colors.tealAccent),
                    const SizedBox(width: 8),
                    Text(
                      "Eligibility: ",
                      style: TextStyle(color: Colors.grey.shade300, fontSize: 13.5),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        // TODO: bind to internship.eligibility?.first or a summary field
                        (internship.studentQualification != null &&
                            internship.studentQualification!.isNotEmpty)
                            ? internship.studentQualification![0]
                            : "BCA",
                        style: const TextStyle(color: Colors.white, fontSize: 12.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _infoTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade300, fontSize: 12.5),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppStyles.customTextStyle(
                  size: 16.5,
                  color: Colors.white,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 14.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 13.5),
      ),
    );
  }

  Widget _buildReviewSection(PostData internship) {
    // TODO: replace with internship.reviews (List<ReviewModel>) and internship.rating
    final reviews =
        [
          {
            "name": "Rahul Sharma",
            "rating": 5,
            "comment":
            "Great learning experience with real-time projects. Highly recommended for beginners.",
          },
          {
            "name": "Anjali P.",
            "rating": 4,
            "comment": "The mentors are very supportive and the work culture is amazing.",
          },
        ];
    final double avgRating =  4.8;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "Internship Review",
                    style: AppStyles.customTextStyle(
                      size: 16.5,
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      "$avgRating RATING",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...reviews.map<Widget>((review) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                       "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (i) {
                         0;
                        return Icon(
                            Icons.star ,
                          size: 15,
                          color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPostedDeadlineRow(PostData internship) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Posted On",
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5)),
                    const SizedBox(height: 2),
                    Text(
                      internship.createdAt ?? "-",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(width: 1, height: 36, color: Colors.white.withOpacity(0.1)),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.event_busy_outlined, size: 16, color: Colors.pinkAccent),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Application",
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5)),
                    Text("Deadline",
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12.5)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewApplicantsButton(PostData internship) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          // TODO: navigate to applicants list screen for this internship
          // Get.toNamed(Routes.applicants, arguments: {"jobId": internship.sId});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.tealAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.visibility_outlined, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              // TODO: replace with internship.applicantsCount
              "View Applicants (${(internship.totalApplicants ?? 0).toString().padLeft(2, '0')})",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}