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
                  "Last updated: November 17, 2025",
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
              _definitionItem("Affiliate",
                  "means an entity that controls, is controlled by, or is under common control with a party, where \"control\" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority."),
              _definitionItem("Country", "refers to: Tamil Nadu, India."),
              _definitionItem("Company",
                  "refers to DoubleTap Innovations and Technologies Pvt Ltd. 2nd Floor, 78, North Usan Road, T Nagar, Chennai – 600016."),
              _definitionItem("Device",
                  "means any device that can access the Service such as a computer, a cell phone or a digital tablet."),
              _definitionItem("Service", "refers to the Website."),
              _definitionItem("Terms and Conditions",
                  "mean these Terms and Conditions that form the entire agreement between You and the Company regarding the use of the Service."),
              _definitionItem("Third-party Social Media Service",
                  "means any services or content provided by a third-party that may be displayed, included or made available by the Service."),
              _definitionItem("Website", "refers to internsharks.ai."),
              _definitionItem("You",
                  "means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service."),

              _sectionTitle("Acknowledgment"),
              _bodyText(
                "These are the Terms and Conditions governing the use of this Service and the agreement that operates between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service.",
              ),
              _bodyText(
                "Your access to and use of the Service is conditioned on Your acceptance of and compliance with these Terms and Conditions. These Terms and Conditions apply to all visitors, users and others who access or use the Service.",
              ),
              _bodyText(
                "By accessing or using the Service You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions then You may not access the Service.",
              ),
              _highlightBox(
                "Age Requirement",
                "You represent that you are over the age of 18. The Company does not permit those under 18 to use the Service.",
              ),

              _sectionTitle("Create Account"),
              _bodyText(
                "To access certain features of the Service, you may be required to create an Account.",
              ),
              _subTitle("Account Registration"),
              _bodyText("By creating an Account, you agree to:"),
              _bulletItem("Provide accurate, complete, and up-to-date information during registration."),
              _bulletItem("Maintain the confidentiality of Your login details."),
              _bulletItem("Accept responsibility for all activities performed under Your Account."),
              _bulletItem("Notify Us immediately if You suspect any unauthorized access or breach of security."),

              _subTitle("Account Security"),
              _bodyText(
                "You are responsible for safeguarding Your password and any actions performed under Your Account. The Company shall not be liable for any loss or damage arising from Your failure to comply with this security obligation.",
              ),

              _subTitle("Account Termination"),
              _bodyText(
                "The Company reserves the right to suspend or terminate Your Account if You violate these Terms or engage in fraudulent or unlawful behavior. You may request to delete Your Account at any time by contacting Us.",
              ),

              _sectionTitle("Links to Other Websites"),
              _bodyText(
                "Our Service may contain links to third-party web sites or services that are not owned or controlled by the Company. The Company has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services.",
              ),
              _bodyText(
                "We strongly advise You to read the terms and conditions and privacy policies of any third-party web sites or services that You visit.",
              ),

              _sectionTitle("Limitation of Liability"),
              _bodyText(
                "Notwithstanding any damages that You might incur, the entire liability of the Company and any of its suppliers under any provision of this Terms and Your exclusive remedy for all of the foregoing shall be limited to the amount actually paid by You through the Service or 100 USD if You haven't purchased anything through the Service.",
              ),
              _bodyText(
                "To the maximum extent permitted by applicable law, in no event shall the Company or its suppliers be liable for any special, incidental, indirect, or consequential damages whatsoever, even if the Company or any supplier has been advised of the possibility of such damages.",
              ),

              _sectionTitle("\"AS IS\" and \"AS AVAILABLE\" Disclaimer"),
              _bodyText(
                "The Service is provided to You \"AS IS\" and \"AS AVAILABLE\" and with all faults and defects without warranty of any kind. To the maximum extent permitted under applicable law, the Company expressly disclaims all warranties, whether express, implied, statutory or otherwise, with respect to the Service.",
              ),
              _bodyText(
                "The Company provides no warranty or undertaking, and makes no representation of any kind that the Service will meet Your requirements, achieve any intended results, be compatible or work with any other software, applications, systems or services, or operate without interruption.",
              ),

              _sectionTitle("Governing Law"),
              _bodyText(
                "The laws of the Country, excluding its conflicts of law rules, shall govern this Terms and Your use of the Service. Your use of the Application may also be subject to other local, state, national, or international laws.",
              ),

              _sectionTitle("Disputes Resolution"),
              _bodyText(
                "If You have any concern or dispute about the Service, you agree to first try to resolve the dispute informally by contacting the Company.",
              ),

              _sectionTitle("Severability and Waiver"),
              _subTitle("Severability"),
              _bodyText(
                "If any provision of these Terms is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.",
              ),
              _subTitle("Waiver"),
              _bodyText(
                "Except as provided herein, the failure to exercise a right or to require performance of an obligation under these Terms shall not affect a party's ability to exercise such right or require such performance at any time thereafter.",
              ),

              _sectionTitle("Translation Interpretation"),
              _bodyText(
                "These Terms and Conditions may have been translated if We have made them available to You on our Service. You agree that the original English text shall prevail in the case of a dispute.",
              ),

              _sectionTitle("Changes to These Terms and Conditions"),
              _bodyText(
                "We reserve the right, at Our sole discretion, to modify or replace these Terms at any time. If a revision is material We will make reasonable efforts to provide at least 30 days' notice prior to any new terms taking effect.",
              ),
              _bodyText(
                "By continuing to access or use Our Service after those revisions become effective, You agree to be bound by the revised terms. If You do not agree to the new terms, please stop using the website and the Service.",
              ),

              _sectionTitle("Contact Us"),
              _bodyText("If you have any questions about these Terms and Conditions, You can contact us:"),
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
        _contactRow(Icons.email_outlined, "info@internsharks.com"),
        const SizedBox(height: 8),
        _contactRow(Icons.language_outlined, "internsharks.ai"),
        const SizedBox(height: 8),
        _contactRow(Icons.phone_outlined, "9600043880"),
        const SizedBox(height: 8),
        _contactRow(
          Icons.location_on_outlined,
          "DoubleTap Innovations and Technologies Pvt Ltd.\n2nd Floor, 78, North Usan Road, T Nagar, Chennai - 600016",
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