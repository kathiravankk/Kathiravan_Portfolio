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
              // Version chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
                ),
                child: Text(
                  "Version 2.0  |  Effective: August 21, 2026",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _bodyText(
                "This Policy explains what personal data InternSharks.ai™ collects, why it is used, how AI features process it, who may receive it, and the choices available to users—including users under 18 and their parents or lawful guardians.",
              ),

              // ── Section 1 ──────────────────────────────────────────────────
              _sectionTitle("1. Scope and Who We Are"),
              _bodyText(
                "This Privacy Policy (\"Policy\") applies to the InternSharks.ai™ website, mobile applications, APIs, communications and related services (together, the \"Platform\") operated by DoubleTap Innovations and Technologies Pvt Ltd. (\"InternSharks\", \"we\", \"us\" or \"our\"). It applies to students, parents or lawful guardians, recruiters, employers, educational institutions, coordinators, mentors and visitors.\n\n"
                "For applicable Indian data-protection law, we act as the Data Fiduciary for personal data for which we determine the purpose and means of processing. Where an institution or recruiter independently decides how to use data received through the Platform, that organisation may also have its own legal obligations.",
              ),

              // ── Section 2 ──────────────────────────────────────────────────
              _sectionTitle("2. Important Definitions"),
              _definitionItem("Personal data",
                  "data about an identifiable individual, including profile, education, identity, application, communication and device data."),
              _definitionItem("AI Services",
                  "features that use artificial intelligence or automated processing, including resume enhancement and analysis, ATS scoring, matching, career assistance, syllabus and assessment generation, KYC support, mock interviews, chatbots and profile-content creation."),
              _definitionItem("Service Provider",
                  "an organisation that processes data for us or supports the Platform—such as cloud hosting, storage, payment, AI, messaging, analytics, security or communications providers."),
              _definitionItem("Minor",
                  "a person who has not reached the age at which they may independently consent or contract under applicable law."),

              // ── Section 3 ──────────────────────────────────────────────────
              _sectionTitle("3. Personal Data We Collect"),

              _subTitle("3.1 Account and Contact Data"),
              _bulletItem("Name, email address, mobile number, date of birth, gender, photograph, city, address and account credentials or one-time-password verification data."),
              _bulletItem("Account role, referral information, verification status, subscription or credit status, notification tokens and preferences."),
              _bulletItem("For a Minor, parent or lawful guardian identity, contact and consent records where required."),

              _subTitle("3.2 Student, Education and Career Data"),
              _bulletItem("School, college, university, degree, field of study, academic records, skills, languages, projects, work experience, internships, training and industrial visits."),
              _bulletItem("Resume, cover letter, portfolio, LinkedIn or GitHub links, achievements, publications, workshops, interests, hobbies, volunteering and leadership information."),
              _bulletItem("Applications, saved internships, assessment answers and results, certificates, interview content, shortlist or selection status, internship start date and daily or project progress."),
              _bulletItem("Documents submitted for identity or eligibility verification, which may include student identity cards and government-issued identity documents."),

              _subTitle("3.3 Recruiter and Institution Data"),
              _bulletItem("Recruiter or coordinator name, designation, contact details and account-verification information."),
              _bulletItem("Company or institution name, address, website, size, industry, description, logo, authorised contact and supporting registration or verification documents."),
              _bulletItem("Internship listings, candidate searches, shortlist and selection actions, communications, progress reviews, assessment use, coordinator activity, credits and payment history."),

              _subTitle("3.4 AI, Communications and User-Content Data"),
              _bulletItem("Prompts, chatbot conversations, resumes, internship descriptions, documents, images, audio, interview transcripts and other content submitted to AI Services."),
              _bulletItem("AI-generated suggestions, scores, summaries, enhanced resumes, questions, recommendations, interview reviews and other outputs."),
              _bulletItem("Support requests, grievance correspondence, emails, notifications, webinar participation, surveys and feedback."),

              _subTitle("3.5 Technical, Usage, Payment and Permission Data"),
              _bulletItem("IP address, device and browser information, operating system, app version, log and diagnostic data, session activity, cookie or similar identifiers and security events."),
              _bulletItem("Camera, photo-library or file access only when a user chooses a related upload or verification function, and notification permission where enabled."),
              _bulletItem("Order identifier, plan, amount, status, invoice and payment-confirmation data. Payment credentials are handled by the payment gateway or applicable app store; we do not intend to store full card details, CVV or UPI PIN."),

              // ── Section 4 ──────────────────────────────────────────────────
              _sectionTitle("4. How We Collect Data"),
              _bulletItem("Directly from you, your parent or guardian, recruiter, institution coordinator or authorised representative."),
              _bulletItem("Automatically from your use of the Platform, devices, cookies, logs and security tools."),
              _bulletItem("From recruiters, institutions or other users when they create opportunities, manage applications, record progress or communicate through the Platform."),
              _bulletItem("From payment, communications, identity-verification, app-store and other Service Providers."),
              _bulletItem("From public or linked professional sources only when you direct us to them or where permitted by law."),

              // ── Section 5 ──────────────────────────────────────────────────
              _sectionTitle("5. Why We Process Personal Data"),
              _definitionItem("Provide and personalise the Platform",
                  "Create accounts and profiles; show relevant internships; manage applications, shortlists, assessments, certificates, training and progress."),
              _definitionItem("Operate AI Services",
                  "Analyse or enhance resumes; score fit; create questions or content; power chat, mock interviews, syllabus, MCQs, career support and recommendations."),
              _definitionItem("Verify users and protect safety",
                  "OTP verification, company or student checks, KYC support, fraud prevention, abuse detection, access control and audit logs."),
              _definitionItem("Process payments and credits",
                  "Create and verify orders, allocate credits, maintain transaction history, issue invoices and resolve payment disputes."),
              _definitionItem("Communicate",
                  "Send service messages, application updates, reminders, support responses and optional promotional communications."),
              _definitionItem("Improve and administer services",
                  "Troubleshoot, monitor performance, test features, aggregate analytics, enforce terms and support business operations."),
              _definitionItem("Meet legal obligations",
                  "Respond to lawful requests, keep required tax or transaction records, manage grievances and establish or defend legal claims."),

              // ── Section 6 ──────────────────────────────────────────────────
              _sectionTitle("6. Notice, Consent and Choices"),
              _bodyText(
                "We process personal data on the basis permitted by applicable law, including consent, a user-requested service, compliance with law, protection against fraud or security threats, and other legitimate uses recognised by law. Where consent is required, we will provide a clear notice describing the data and purpose. You may withdraw consent through available settings or by contacting us. Withdrawal will be as easy as the method used to give consent, where practicable, and will not affect processing already lawfully completed. Some services cannot continue without data essential to provide them.\n\n"
                "Optional permissions—such as camera, photos, files or notifications—may be changed in device settings. Marketing communications may be opted out of using the unsubscribe control or by contacting us, although essential service messages may continue.",
              ),

              // ── Section 7 ──────────────────────────────────────────────────
              _sectionTitle("7. AI Services and Automated Processing"),
              _bodyText(
                "AI Services process the information you provide together with relevant account, profile, internship or application data. Outputs may include resume suggestions, ATS or matching scores, candidate rankings, eligibility checks, generated descriptions, interview questions, transcripts, summaries, recommendations and progress insights.",
              ),
              _bulletItem("AI outputs are decision-support tools and may be incomplete, inaccurate or biased. They are not a guarantee of selection, employability, legal compliance or performance."),
              _bulletItem("Recruiters and institutions must apply meaningful human review before making consequential admission, selection, rejection, discipline or employment decisions."),
              _bulletItem("Users may request correction of inaccurate source data and may contact us to question or seek review of a significant automated score or recommendation."),
              _bulletItem("Do not submit unnecessary sensitive or confidential information in a prompt, resume, document, image or audio recording."),
              _bulletItem("We do not intentionally use personal data submitted to the Platform to train publicly available or general-purpose AI models unless we separately explain that use and obtain any consent required by law."),
              const SizedBox(height: 8),
              _bodyText(
                "Our active implementation may use OpenAI APIs and may use other AI providers configured for a particular feature. AI providers may temporarily retain inputs and outputs for security, abuse prevention or service operation under their applicable contracts and settings.",
              ),

              // ── Section 8 ──────────────────────────────────────────────────
              _sectionTitle("8. Sharing and Service Providers"),
              _bodyText("We do not sell personal data. We share data only as necessary for the purposes described in this Policy, subject to contractual, technical and organisational controls where applicable."),
              _bulletItem("Recruiters and employers: relevant student profile, resume, application, assessment, interview and progress information for genuine internship or recruitment activity."),
              _bulletItem("Educational institutions and authorised coordinators: information about linked or participating students, opportunities, assessments and progress that the institution is authorised to manage."),
              _bulletItem("Cloud and infrastructure providers: hosting, databases, caching, storage, backups, monitoring and content delivery."),
              _bulletItem("AI providers: current features use OpenAI APIs and may use alternate providers for defined AI processing."),
              _bulletItem("Payments and app stores: Cashfree and, where applicable, Apple App Store or Google Play billing and payment services."),
              _bulletItem("Communications and notifications: email, SMS/OTP and Firebase Cloud Messaging providers."),
              _bulletItem("Professional advisers, authorities or counterparties: where required by law, necessary to protect rights or safety, or in connection with a corporate transaction subject to appropriate safeguards."),
              _bulletItem("Other parties: when you direct us to share information or give valid consent."),

              // ── Section 9 ──────────────────────────────────────────────────
              _sectionTitle("9. Recruiter and Institution Access Controls"),
              _bodyText(
                "A valid licence, plan or credit balance is a commercial condition for certain functionality; it does not provide unrestricted access to all personal data. Recruiters and institutions receive role- and purpose-based access to information relevant to authorised recruitment, internship administration or institution management.",
              ),
              _bulletItem("Recruiters may use candidate information only for genuine opportunities represented on the Platform and must not scrape, sell, publish, profile for unrelated purposes, or contact candidates unlawfully."),
              _bulletItem("Institutions and coordinators may access only students and records they are authorised to manage and must keep credentials confidential."),
              _bulletItem("Access may be suspended when credits or licences expire, an account is inactive, consent is withdrawn, or misuse is suspected."),
              _bulletItem("Recipients must delete or securely retain downloaded data according to applicable law and their own disclosed retention obligations."),

              // ── Section 10 ─────────────────────────────────────────────────
              _sectionTitle("10. Children and Users Under 18"),
              _bodyText(
                "School students and other users under 18 may register and use age-appropriate features to gain early exposure to careers and internships. Before processing a Minor's personal data or enabling a Minor to accept binding terms, we require verifiable consent and agreement from a parent or lawful guardian to the extent required by law.",
              ),
              _bulletItem("The parent or guardian must supervise the Minor's account and confirm that submitted information is accurate and appropriate."),
              _bulletItem("Recruiters must verify age and obtain all consents or permissions required for an internship. Any work must be lawful, age-appropriate, non-hazardous, safe and compatible with the student's education."),
              _bulletItem("Registration does not mean every Minor may legally perform every internship. We may restrict, review or remove an opportunity or placement based on age, safety, law or guardian concerns."),
              _bulletItem("We do not knowingly undertake tracking, behavioural monitoring or targeted advertising directed at Minors in a manner prohibited by law."),
              _bulletItem("A parent or guardian may review, correct or request deletion of a Minor's data by contacting grievance@internsharks.ai, subject to identity and authority verification."),

              // ── Section 11 ─────────────────────────────────────────────────
              _sectionTitle("11. Cookies, Device Permissions and Analytics"),
              _bodyText(
                "We use essential cookies, local storage and similar technologies for authentication, preferences, security and service operation. With consent where required, we may use analytics technologies to understand feature use and improve performance. Browser and device settings may block or delete cookies, but essential functions may then be unavailable. The mobile app requests camera, photo, file or notification access only for the related user-initiated functionality; permissions can be withdrawn in device settings.",
              ),

              // ── Section 12 ─────────────────────────────────────────────────
              _sectionTitle("12. Data Retention, Inactivity and Deletion"),
              _bodyText("We retain personal data only for as long as reasonably necessary for the stated purpose, account lifecycle, legal obligations, security, disputes and enforcement."),
              const SizedBox(height: 4),
              _definitionItem("Active account and profile", "Retained while the account is active and as needed to provide requested services."),
              _definitionItem("Inactive for 12 continuous months", "Account may be archived and marked inactive. We will provide notice where reasonably possible. Reactivation requires a written request and identity verification."),
              _definitionItem("Inactive for 24 continuous months", "Account and associated personal data are deleted or irreversibly anonymised, unless law, fraud prevention, security, contract, dispute or an express user request requires limited retention."),
              _definitionItem("User-requested account deletion", "Access is deactivated promptly; deletion or anonymisation is targeted within 30 days after verification, except for data we must retain."),
              _definitionItem("Temporary AI uploads and session caches", "Generally retained from about 24 hours up to 30 days depending on the feature, unless saved by the user or required for security."),
              _definitionItem("Applications, assessments and internship progress", "Retained with the account and opportunity history while needed for administration, records, disputes and lawful reporting."),
              _definitionItem("Payments, tax and fraud records", "Retained for the period required by tax, accounting, payment, anti-fraud and other applicable laws."),
              _definitionItem("Support, grievance and security logs", "Retained for resolution, audit, safety and legal-claim periods, then deleted or anonymised."),

              // ── Section 13 ─────────────────────────────────────────────────
              _sectionTitle("13. Account Deletion and Reactivation"),
              _bodyText(
                "A user may initiate deletion through the mobile app's \"Delete Account\" function where available, or by emailing us from the registered address. We may verify identity, authority and account ownership before completing the request. Deletion may remove access to applications, reports, certificates, progress records and unused promotional credits.\n\n"
                "To reactivate an account archived after one year of inactivity, send a written request to info@internsharks.ai. Reactivation is subject to identity verification, account integrity and availability of data not already deleted under the two-year schedule.",
              ),

              // ── Section 14 ─────────────────────────────────────────────────
              _sectionTitle("14. International Data Transfers"),
              _bodyText(
                "Some Service Providers or their support systems may process data outside India. Where data is transferred across borders, we use contractual and operational safeguards appropriate to the nature of the data and comply with transfer restrictions notified under applicable law.",
              ),

              // ── Section 15 ─────────────────────────────────────────────────
              _sectionTitle("15. Security and Incident Response"),
              _bodyText(
                "We use reasonable administrative, technical and physical safeguards appropriate to risk, including controlled access, authentication, encryption in transit, credential protection, logging, backups and provider oversight. No system is completely secure. Users must protect OTPs, passwords, devices and account access and notify us promptly of suspected misuse. If a personal-data breach creates a notification obligation, we will notify affected users and authorities in the manner and timeframe required by applicable law.",
              ),

              // ── Section 16 ─────────────────────────────────────────────────
              _sectionTitle("16. Your Rights and Grievance Process"),
              _bodyText(
                "Subject to applicable law and verification, you or an authorised representative may request access to a summary of personal data and processing, correction or completion, erasure, withdrawal of consent, account deletion, nomination of another person to exercise rights in specified circumstances, and grievance redressal. We may refuse or limit a request where law permits and will explain the reason where required.",
              ),
              _bulletItem("Send the request from the registered contact channel to grievance@internsharks.ai and describe the account, request and relevant feature."),
              _bulletItem("We may ask for proportionate information to verify identity, guardian status or authority. Do not email unnecessary identity documents."),
              _bulletItem("We aim to acknowledge grievances within 24 hours and resolve them within 15 days, or within another period required by applicable law. Complex requests may require additional time, and we will provide an update."),
              _bulletItem("If you are not satisfied, you may use any escalation or complaint mechanism available under applicable law, including the Data Protection Board of India when the relevant provisions are in force."),

              // ── Section 17 ─────────────────────────────────────────────────
              _sectionTitle("17. Third-Party Links and Independent Practices"),
              _bodyText(
                "The Platform may link to recruiter, institution, payment, app-store or other third-party services. Their privacy practices are governed by their own notices. Review them before submitting information outside InternSharks.ai™.",
              ),

              // ── Section 18 ─────────────────────────────────────────────────
              _sectionTitle("18. Changes to This Policy"),
              _bodyText(
                "We may update this Policy to reflect changes in law, technology, providers or services. Material changes will be communicated through the Platform, email or another appropriate channel before they take effect where required. The version and effective date appear at the beginning of this Policy. Continued use after the effective date is subject to applicable consent requirements.",
              ),

              // ── Section 19 ─────────────────────────────────────────────────
              _sectionTitle("19. Grievance Officer and Contact"),
              _definitionItem("Grievance Officer", "Paul Simson"),
              _definitionItem("Email", "grievance@internsharks.ai"),
              _definitionItem("General support", "info@internsharks.ai"),
              const SizedBox(height: 6),
              _contactBox(),
              const SizedBox(height: 8),
              _bodyText(
                "When contacting us, include your registered email or mobile number and enough detail to identify the request, but do not send passwords, OTPs, CVV, UPI PIN or other unnecessary sensitive credentials.",
              ),
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
        _contactRow(Icons.email_outlined, "grievance@internsharks.ai"),
        const SizedBox(height: 8),
        _contactRow(Icons.support_agent_outlined, "info@internsharks.ai"),
        const SizedBox(height: 8),
        _contactRow(Icons.language_outlined, "www.internsharks.ai"),
        const SizedBox(height: 8),
        _contactRow(Icons.phone_outlined, "+91 9600043880"),
        const SizedBox(height: 8),
        _contactRow(
          Icons.location_on_outlined,
          "DoubleTap Innovations and Technologies Pvt Ltd. (InternSharks)\n78, 2nd Floor, Usman Road, T Nagar, Chennai – 600017, Tamil Nadu, India",
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