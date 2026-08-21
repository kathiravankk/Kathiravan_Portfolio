import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
            "Terms & Conditions",
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
              const SizedBox(height: 16),

              _bodyText(
                "Please read these terms and conditions carefully before using Our Service.",
              ),

              _sectionTitle("Interpretation and Definitions"),
              _subTitle("Interpretation"),
              _bodyText(
                "The words whose initial letters are capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.",
              ),
              _subTitle("Definitions"),
              _bodyText("For the purposes of these Terms and Conditions:"),
              const SizedBox(height: 8),
              _definitionItem("Company (\"the Company\", \"We\", \"Us\" or \"Our\")",
                  "refers to DoubleTap Innovations and Technologies Pvt Ltd, 2nd Floor, 78, North Usman Road, T Nagar, Chennai – 600016, Tamil Nadu, India."),
              _definitionItem("Application / Platform",
                  "means the software program, web platform, or mobile application provided by the Company named InternSharks."),
              _definitionItem("Country", "refers to: India."),
              _definitionItem("Credits",
                  "refers to InternSharks Credits used to access and consume specific AI-powered tools and features on the Platform."),
              _definitionItem("Device",
                  "means any device that can access the Service, such as a computer, a mobile phone, or a digital tablet."),
              _definitionItem("Service",
                  "refers to the Application, the website (www.internsharks.ai), and all associated AI-powered career tools, assessments, webinars, and recruitment services provided by the Company."),
              _definitionItem("Terms and Conditions (\"Terms\")",
                  "mean these Terms and Conditions that form the entire agreement between You and the Company regarding the use of the Service."),
              _definitionItem("Third-party Service",
                  "means any services, content (including data, information, or software), cloud hosting providers, payment gateways, analytics platforms, or AI services provided by a third party that may be displayed, included, integrated, or made available by the Service."),
              _definitionItem("You",
                  "means the individual accessing or using the Service (including Students, Recruiters, and University Representatives), or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable."),

              _sectionTitle("Acknowledgment and Eligibility"),
              _bodyText(
                "These are the Terms and Conditions governing the use of this Service and the agreement that operates between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service.",
              ),
              _bodyText(
                "Your access to and use of the Service is conditioned on Your acceptance of and compliance with these Terms and Conditions. These Terms and Conditions apply to all visitors, users, students, recruiters, universities, and others who access or use the Service.",
              ),
              _bodyText(
                "By accessing or using the Service You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions then You may not access the Service.",
              ),
              _highlightBox(
                "Age and Legal Capacity",
                "You represent that You are at least 18 years of age and possess the legal capacity to enter into this binding agreement. The Company does not permit individuals under 18 to use the Service without verifiable parental or legal guardian consent where permitted by law.",
              ),
              _bodyText(
                "Your access to and use of the Service is also conditioned on Your acceptance of and compliance with the Privacy Policy of the Company. Our Privacy Policy describes Our policies and procedures on the collection, use, and disclosure of Your personal information when You use the Application or the Website and tells You about Your privacy rights and how the law protects You. Please read Our Privacy Policy carefully before using Our Service.",
              ),

              _sectionTitle("User Categories and Responsibilities"),
              _definitionItem("Student Responsibilities",
                  "Students must provide truthful academic, skill, and career information and must not submit misleading, fraudulent, or copyrighted materials without authorization."),
              _definitionItem("Recruiter Responsibilities",
                  "Recruiters are solely responsible for lawful internship and job postings, adherence to fair hiring practices, and the accuracy of job descriptions and company credentials."),
              _definitionItem("University Responsibilities",
                  "Universities and designated coordinators must use institutional accounts responsibly, maintain strict confidentiality, and protect student data and privacy."),
              _definitionItem("Account Security",
                  "You are responsible for all activities conducted under Your account credentials and must immediately notify the Company of any unauthorized access or breach of security."),

              _sectionTitle("User-Generated Content and License"),
              _bodyText(
                "You retain ownership of any text, resumes, portfolio files, job descriptions, assessments, or other content (\"User Content\") that You upload, submit, or transmit to the Service.",
              ),
              _bodyText(
                "By submitting User Content to InternSharks, You grant the Company a worldwide, non-exclusive, royalty-free license to use, host, store, process, reproduce, adapt, and display such content solely for the purposes of operating, improving, analyzing, and providing the Service (including resume scoring, job matching, and recruiter forwarding).",
              ),

              _sectionTitle("AI Services and Disclaimer"),
              _bodyText(
                "The Service provides AI-driven features, including but not limited to Resume Builder, Resume Review, ATS Resume Score, Job Matching, Mock Interview, Career Assistant, Skill Recommendations, and Syllabus Generation.",
              ),
              _bodyText(
                "AI outputs and recommendations are generated algorithmically for assistance and career development purposes only. The Company does not guarantee employment, internship offers, job interviews, or university admissions through the use of these tools.",
              ),

              _sectionTitle("InternSharks Credits and Payments"),
              _definitionItem("InternSharks Credits",
                  "Certain AI features consume InternSharks Credits. Credits are non-refundable and non-transferable unless explicitly required by applicable law or stated in an active written refund policy."),
              _definitionItem("Payments & Taxes",
                  "Paid services and subscriptions must be completed through approved payment methods. Applicable statutory taxes (including GST) may be charged where required by law."),

              _sectionTitle("Webinars and Events"),
              _bodyText(
                "Registration may be required for webinars and virtual sessions hosted through the Service. The Company reserves the right to record and process attendance records for certification verification, platform administration, and event management.",
              ),

              _sectionTitle("Prohibited Activities"),
              _bodyText(
                "You agree not to misuse the Service or engage in unlawful or disruptive conduct, including but not limited to:",
              ),
              _bulletItem("Misusing AI features, reverse-engineering platform algorithms, or attempting unauthorized model extraction."),
              _bulletItem("Creating fake, misleading, or multiple fraudulent accounts."),
              _bulletItem("Attempting unauthorized access to the Service, connected servers, databases, or user accounts."),
              _bulletItem("Distributing malware, viruses, trojans, worms, timebombs, or other malicious components."),
              _bulletItem("Scraping, harvesting, crawling, or extracting platform data through automated or manual processes."),
              _bulletItem("Violating any applicable local, national, or international laws or regulations."),

              _sectionTitle("Intellectual Property"),
              _bodyText(
                "The Service and its original content, software, AI models, UI designs, graphics, and the InternSharks brand name and logos remain the exclusive intellectual property of DoubleTap Innovations and Technologies Pvt Ltd. You may not copy, modify, distribute, or create derivative works without prior express written authorization.",
              ),

              _sectionTitle("Third-Party Services and Links"),
              _bodyText(
                "Our Service may integrate with or contain links to third-party web sites or services (such as cloud hosting providers, payment gateways, email/SMS/WhatsApp providers, analytics platforms, and AI service providers) that are not owned or controlled by the Company.",
              ),
              _bodyText(
                "The Company has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third-party websites or services. You further acknowledge and agree that the Company shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services.",
              ),

              _sectionTitle("Indemnification"),
              _bodyText(
                "You agree to defend, indemnify, and hold harmless DoubleTap Innovations and Technologies Pvt Ltd, its directors, employees, affiliates, licensors, and agents from and against any claims, liabilities, damages, losses, and expenses (including reasonable legal and accounting fees) arising out of or in any way connected with (i) Your access to or use of the Service; (ii) Your violation of these Terms; (iii) Your User Content; or (iv) Your infringement of any third-party intellectual property or privacy rights.",
              ),

              _sectionTitle("Termination and Account Suspension"),
              _bodyText(
                "We may terminate or suspend Your access and account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if You breach these Terms and Conditions, engage in fraudulent activities, or abuse AI services.",
              ),
              _bodyText("Upon termination, Your right to use the Service will cease immediately."),

              _sectionTitle("Account Deletion (Delete Account)"),
              _bodyText(
                "InternSharks allows users to permanently delete their account and personal information, subject to applicable legal, regulatory, and operational requirements.",
              ),
              _subTitle("How to Delete Your Account"),
              _bulletItem("Navigate to Profile → Settings → Delete Account within the InternSharks App or Website; or"),
              _bulletItem("Contact our support team directly at info@internsharks.ai with your registered account details."),
              _subTitle("What Happens After Deletion"),
              _bulletItem("Your account will be permanently deleted and profile data removed from active systems."),
              _bulletItem("Your AI history, saved preferences, and non-essential personal data will be erased where technically feasible."),
              _bulletItem("You will immediately forfeit all unused InternSharks Credits, saved resumes, internship history, and AI-generated content."),
              _subTitle("Information We May Retain & Processing Time"),
              _bodyText(
                "We may retain certain transaction records, security logs, or identification details where strictly necessary to comply with legal obligations, prevent fraud, resolve disputes, or enforce agreements. Verified account deletion requests are generally processed within thirty (30) days.",
              ),

              _sectionTitle("Limitation of Liability"),
              _bodyText(
                "Notwithstanding any damages that You might incur, the entire liability of the Company and any of its suppliers under any provision of these Terms and Your exclusive remedy for all of the foregoing shall be limited to the amount actually paid by You through the Service or 100 USD (or equivalent INR) if You haven't purchased anything through the Service.",
              ),
              _bodyText(
                "To the maximum extent permitted by applicable law, in no event shall the Company or its suppliers be liable for any special, incidental, indirect, or consequential damages whatsoever (including, but not limited to, damages for loss of profits, loss of data, loss of career opportunities, business interruption, or personal injury arising out of or in any way related to the use of or inability to use the Service).",
              ),

              _sectionTitle("\"AS IS\" and \"AS AVAILABLE\" Disclaimer"),
              _bodyText(
                "The Service is provided to You \"AS IS\" and \"AS AVAILABLE\" with all faults and defects without warranty of any kind. To the maximum extent permitted under applicable law, the Company expressly disclaims all warranties, whether express, implied, statutory, or otherwise, including all implied warranties of merchantability, fitness for a particular purpose, title, non-infringement, and accuracy of AI outputs.",
              ),
              _bodyText(
                "Without limiting the foregoing, neither the Company nor any provider makes any warranty that the Service will meet Your requirements, operate without interruption, be error-free, or that defects can or will be corrected.",
              ),

              _sectionTitle("Force Majeure"),
              _bodyText(
                "Neither the Company nor You shall be liable for any failure or delay in performing obligations under these Terms if such failure or delay arises from circumstances beyond reasonable control, including but not limited to acts of God, natural disasters, epidemics, internet outages, cyber-attacks, telecommunications failures, government actions, war, or civil unrest.",
              ),

              _sectionTitle("Governing Law and Dispute Resolution"),
              _subTitle("Governing Law"),
              _bodyText(
                "The laws of India, excluding its conflicts of law rules, shall govern these Terms and Your use of the Service.",
              ),
              _subTitle("Disputes Resolution"),
              _bodyText(
                "If You have any concern or dispute about the Service, You agree to first try to resolve the dispute informally by contacting the Company. Any formal dispute, claim, or controversy arising out of or relating to these Terms shall be subject to the exclusive jurisdiction of the competent courts in Chennai, Tamil Nadu, India.",
              ),
              _subTitle("Grievance Redressal Mechanism"),
              _bodyText(
                "In compliance with the Information Technology Act, 2000 and the Information Technology (Intermediary Guidelines and Digital Media Ethics Code) Rules, 2021, the contact details of the Grievance Officer for InternSharks are provided below:",
              ),
              const SizedBox(height: 8),
              _definitionItem("Designation", "Grievance Officer, InternSharks"),
              _definitionItem("Company", "DoubleTap Innovations and Technologies Pvt Ltd"),
              _definitionItem("Address", "2nd Floor, 78, North Usman Road, T Nagar, Chennai – 600016, Tamil Nadu, India"),
              _definitionItem("Email", "grievance@internsharks.ai / info@internsharks.ai"),
              _definitionItem("Turnaround Time", "Complaints will be acknowledged within 24 hours and addressed within 15 days of receipt."),

              _sectionTitle("Severability and Waiver"),
              _subTitle("Severability"),
              _bodyText(
                "If any provision of these Terms is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.",
              ),
              _subTitle("Waiver"),
              _bodyText(
                "Except as provided herein, the failure to exercise a right or to require performance of an obligation under these Terms shall not affect a party's ability to exercise such right or require such performance at any time thereafter nor shall the waiver of a breach constitute a waiver of any subsequent breach.",
              ),

              _sectionTitle("Changes to These Terms and Conditions"),
              _bodyText(
                "We reserve the right, at Our sole discretion, to modify or replace these Terms at any time. Significant changes will be communicated through our website, email, or application notifications prior to taking effect.",
              ),
              _bodyText(
                "By continuing to access or use Our Service after those revisions become effective, You agree to be bound by the revised terms. If You do not agree to the new terms, please stop using the website and the Service.",
              ),

              _sectionTitle("Contact Us"),
              _bodyText("If you have any questions about these Terms and Conditions, you can contact us:"),
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
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.primaryColor.withOpacity(0.12),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
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
            color: AppColors.whiteColor.withOpacity(0.8),
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
          "DoubleTap Innovations and Technologies Pvt Ltd.\n2nd Floor, 78, North Usman Road, T Nagar, Chennai - 600016, Tamil Nadu, India",
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