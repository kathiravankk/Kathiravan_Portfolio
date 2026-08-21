import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBgNew),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Privacy Policy",
            style: AppStyles.customTextStyle(
              size: 18,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Last updated chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
                ),
                child: Text(
                  "Last updated: August 21, 2026",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _bodyText(
                "This Privacy Policy describes Our policies and procedures on the collection, use, and disclosure of Your information when You use the Service and explains Your privacy rights and how the law protects You.\n\n"
                    "We use Your Personal Data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.",
              ),

              _sectionTitle("1. Interpretation and Definitions"),
              _subTitle("Interpretation"),
              _bodyText(
                "Words with initial capital letters have meanings defined under the following conditions. These definitions apply whether they appear in singular or plural.",
              ),
              _subTitle("Definitions"),
              _bodyText("For the purposes of this Privacy Policy:"),
              const SizedBox(height: 8),
              _definitionItem("Account",
                  "means a unique account created for You to access our Service or parts of our Service."),
              _definitionItem("Affiliate",
                  "means an entity that controls, is controlled by, or is under common control with a party."),
              _definitionItem("Application / Platform",
                  "refers to InternSharks, the AI-powered career and recruitment platform operated by the Company."),
              _definitionItem("Company (\"the Company\", \"We\", \"Us\" or \"Our\")",
                  "refers to DoubleTap Innovations and Technologies Pvt Ltd."),
              _definitionItem("Country", "refers to: India."),
              _definitionItem("Device",
                  "means any device that can access the Service, such as a computer, mobile phone, or digital tablet."),
              _definitionItem("Personal Data",
                  "is any information that relates to an identified or identifiable individual."),
              _definitionItem("Service",
                  "refers to the InternSharks platform and related career/recruitment tools."),
              _definitionItem("Service Provider",
                  "refers to third-party individuals or companies (including AI technology providers and payment gateways) that process data on behalf of the Company."),
              _definitionItem("Usage Data",
                  "refers to data collected automatically during Service use."),
              _definitionItem("You",
                  "means the individual (student, candidate, or recruiter) accessing or using the Service."),

              _sectionTitle("2. Collecting and Using Your Personal Data"),
              _subTitle("Types of Data Collected"),
              _subTitle2("Personal Data"),
              _bodyText(
                "While using Our Service, We may ask You to provide certain personally identifiable information, including but not limited to:",
              ),
              _bulletItem("First name and last name"),
              _bulletItem("Phone number and email address"),
              _bulletItem("Education details and academic background"),
              _bulletItem("Resumes, skills, and portfolio links"),
              _bulletItem("Internship preferences and job search criteria"),
              _bulletItem("Recruiter organization details and hiring requirements"),
              _bulletItem("Login credentials and authentication details"),

              _subTitle2("Usage Data"),
              _bodyText(
                "Usage Data is collected automatically when using the Service and may include:",
              ),
              _bulletItem("Your Device's Internet Protocol address (IP address)"),
              _bulletItem("Browser type and version"),
              _bulletItem("Pages visited, time and date of Your visit, and time spent on pages"),
              _bulletItem("Device identifiers and diagnostic data"),

              _subTitle2("Information from AI Services"),
              _bodyText(
                "We offer AI-powered career tools including AI Resume Builder, AI Resume Review, ATS Resume Score, AI Job Matching, AI Career Assistant, AI Skill Recommendations, and AI Syllabus Generation. AI systems only process the specific resume, skill, and career data necessary to provide the requested service.",
              ),

              _sectionTitle("3. Payment Processing & InternSharks Credits"),
              _bulletItem("Certain features and services on the platform operate via the InternSharks Credit System."),
              _bulletItem("All financial transactions and payments are handled exclusively through certified third-party payment gateway providers."),
              _bulletItem("The Company does not store, process, or retain Your sensitive payment instruments, including credit/debit card numbers, CVV codes, UPI PINs, or net banking credentials on our servers."),

              _sectionTitle("4. AI Output & Service Disclaimer"),
              _bulletItem("AI-driven features (including resume reviews, scoring, skill paths, and job matching recommendations) are automated decision-support tools designed for guidance only."),
              _bulletItem("While We strive for high accuracy, AI outputs are generated algorithmically and do not constitute a guarantee of internship placement, interview selection, or employment."),

              _sectionTitle("5. Use of Your Personal Data"),
              _bodyText("The Company may use Personal Data for the following purposes:"),
              const SizedBox(height: 8),
              _definitionItem("To provide and maintain our Service",
                  "Including managing the InternSharks platform and credit balances."),
              _definitionItem("To manage Your Account",
                  "To register You as a user and manage Your access to specific career tools."),
              _definitionItem("To match opportunities",
                  "Connecting students and candidates with recruiters for internships and job openings."),
              _definitionItem("To deliver AI services",
                  "Processing inputs to generate resume feedback, ATS scores, and skill recommendations."),
              _definitionItem("To contact You",
                  "Via Email, SMS, WhatsApp, Push Notifications, and Phone Calls regarding OTPs, internship updates, application status, and service announcements."),
              _definitionItem("To manage Your requests",
                  "Attending to customer support and technical queries."),
              _definitionItem("For business transfers",
                  "Evaluating or conducting mergers, restructuring, or sales of assets."),
              _definitionItem("For platform improvement",
                  "Conducting analytics, preventing fraud, and optimizing system performance."),

              _sectionTitle("6. Sharing and Disclosure of Your Personal Data"),
              _bodyText("We do not sell Your personal data. We may share Your information with:"),
              const SizedBox(height: 8),
              _definitionItem("Recruiters and Employers",
                  "Sharing candidate profiles, resumes, and assessment outcomes for recruitment purposes."),
              _definitionItem("Service & AI Providers",
                  "Trusted third parties assisting with cloud hosting, database management, payment processing, and AI integrations."),
              _definitionItem("Affiliates & Business Partners",
                  "Entities operating under strict compliance with this Privacy Policy."),
              _definitionItem("Law Enforcement & Legal Authorities",
                  "Where required by applicable Indian law or official government requests."),
              _definitionItem("With Your Consent",
                  "For any other specific purpose disclosed at the point of collection."),

              _sectionTitle("7. Cookies and Tracking Technologies"),
              _bodyText(
                "We use cookies and similar tracking technologies to track activity, maintain secure login sessions, store user preferences, and analyze platform performance. You can set Your browser to refuse cookies, though some platform features may become unavailable.",
              ),

              _sectionTitle("8. Retention of Your Personal Data"),
              _bodyText("We retain Personal Data only for as long as required:"),
              _bulletItem("To provide active platform services and internship matching"),
              _bulletItem("To comply with statutory legal obligations and resolve disputes"),
              _bulletItem("To maintain internal security and analytical records"),

              _sectionTitle("9. Transfer of Your Personal Data"),
              _bodyText(
                "Your information may be processed and stored on secure servers located in India and other jurisdictions where our trusted infrastructure and service providers operate. We implement reasonable safeguards to maintain data protection across all locations.",
              ),

              _sectionTitle("10. Delete Your Personal Data"),
              _bodyText("You have the right to:"),
              _bulletItem("Request access to the Personal Data We hold about You"),
              _bulletItem("Correct or update inaccurate details via Your account settings"),
              _bulletItem("Request the complete deletion of Your personal information and account by contacting Us"),
              const SizedBox(height: 6),
              _bodyText(
                "We may retain specific information where necessary to comply with legal retention requirements.",
              ),

              _sectionTitle("11. Security of Your Personal Data"),
              _bodyText(
                "We use HTTPS encryption, encrypted password storage, strict access controls, and secure cloud infrastructure to safeguard Your information. However, no electronic storage or internet transmission method is 100% secure.",
              ),

              _sectionTitle("12. Children's Privacy"),
              _bodyText(
                "Our Service is not intended for individuals under 18 years of age without parental or guardian authorization. We do not knowingly collect personal information from individuals under 18. If We identify that data of a minor has been collected without proper consent, We will remove it promptly.",
              ),

              _sectionTitle("13. Third-Party Links"),
              _bodyText(
                "Our Service may contain links to external sites not operated by Us. We strongly advise You to review the Privacy Policy of every third-party site You visit, as We assume no responsibility for their practices.",
              ),

              _sectionTitle("14. Changes to This Privacy Policy"),
              _bodyText(
                "We may update this Privacy Policy periodically. Any modifications will be posted on this page with an updated \"Last updated\" date, and significant updates will be communicated through platform notifications or email.",
              ),

              _sectionTitle("15. Grievance Officer"),
              _bodyText(
                "In accordance with applicable information technology rules, the name and contact details of the Grievance Officer are provided below:",
              ),
              const SizedBox(height: 8),
              _definitionItem("Designation", "Grievance Officer"),
              _definitionItem("Email", "grievance@internsharks.ai (or info@internsharks.ai)"),
              _definitionItem("Address", "2nd Floor, 78, North Usman Road, T Nagar, Chennai – 600016, India"),

              _sectionTitle("16. Contact Us"),
              _bodyText("If you have any questions about this Privacy Policy, you can contact us:"),
              const SizedBox(height: 8),
              _contactBox(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(
      text,
      style: AppStyles.customTextStyle(
        size: 16,
        color: AppColors.primaryColor,
        weight: FontWeight.w700,
      ),
    ),
  );

  Widget _subTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(
      text,
      style: AppStyles.customTextStyle(
        size: 14,
        color: AppColors.whiteColor,
        weight: FontWeight.w600,
      ),
    ),
  );

  Widget _subTitle2(String text) => Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 4),
    child: Text(
      text,
      style: AppStyles.customTextStyle(
        size: 13,
        color: AppColors.secondaryColor,
        weight: FontWeight.w600,
      ),
    ),
  );

  Widget _bodyText(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: AppStyles.customTextStyle(
        size: 13,
        color: AppColors.whiteColor.withOpacity(0.8),
        weight: FontWeight.w300,
        lineSpace: 1.6,
      ),
    ),
  );

  Widget _bulletItem(String text) => Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "• ",
          style: AppStyles.customTextStyle(
            size: 13,
            color: AppColors.primaryColor,
            weight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.whiteColor.withOpacity(0.8),
              weight: FontWeight.w300,
              lineSpace: 1.5,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _definitionItem(String term, String definition) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$term: ",
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ).copyWith(color: AppColors.secondaryColor),
          ),
          TextSpan(
            text: definition,
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.whiteColor.withOpacity(0.8),
              weight: FontWeight.w300,
              lineSpace: 1.5,
            ).copyWith(color: AppColors.whiteColor.withOpacity(0.8)),
          ),
        ],
      ),
    ),
  );

  Widget _highlightBox(String title, String body) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.contBorderColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.customTextStyle(
            size: 13,
            color: AppColors.primaryColor,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          body,
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.whiteColor.withOpacity(0.75),
            weight: FontWeight.w300,
            lineSpace: 1.5,
          ),
        ),
      ],
    ),
  );

  Widget _cookieBox(String title, String type, String purpose) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.contBorderColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.customTextStyle(
            size: 13,
            color: AppColors.primaryColor,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Type: $type",
          style: AppStyles.customTextStyle(
            size: 11,
            color: AppColors.secondaryColor,
            weight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          purpose,
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.whiteColor.withOpacity(0.75),
            weight: FontWeight.w300,
            lineSpace: 1.5,
          ),
        ),
      ],
    ),
  );

  Widget _contactBox() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.primaryColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.primaryColor.withOpacity(0.35)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _contactRow(Icons.email_outlined, "info@internsharks.ai"),
        const SizedBox(height: 8),
        _contactRow(Icons.language_outlined, "www.internsharks.ai"),
        const SizedBox(height: 8),
        _contactRow(Icons.phone_outlined, "+91 9600043880"),
        const SizedBox(height: 8),
        _contactRow(
          Icons.location_on_outlined,
          "DoubleTap Innovations and Technologies Pvt Ltd. (InternSharks)\n2nd Floor, 78, North Usman Road, T Nagar, Chennai - 600016, India",
        ),
      ],
    ),
  );

  Widget _contactRow(IconData icon, String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: AppColors.primaryColor, size: 16),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.whiteColor.withOpacity(0.85),
            weight: FontWeight.w400,
            lineSpace: 1.5,
          ),
        ),
      ),
    ],
  );
}