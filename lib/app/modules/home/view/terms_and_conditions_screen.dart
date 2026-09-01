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
                  "Version 2.0 · Effective and last updated: August 21, 2026",
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _bodyText(
                "These Terms govern access to InternSharks.ai™ by students, parents or lawful guardians, recruiters, employers, institutions, coordinators and visitors. They also establish special safeguards for Minor users and clear rules for AI-assisted recruitment.",
              ),

              _subTitle("Agreement Overview"),
              const SizedBox(height: 4),
              _definitionItem("Operator", "DoubleTap Innovations and Technologies Pvt Ltd."),
              _definitionItem("Registered office", "78, 2nd Floor, Usman Road, T Nagar, Chennai – 600017, Tamil Nadu, India"),
              _definitionItem("GSTIN", "33AALCD9144Q1ZZ"),
              _definitionItem("Contact", "info@internsharks.ai | +91 9600043880 | www.internsharks.ai"),

              _sectionTitle("1. Acceptance and Operator"),
              _bodyText(
                "These Terms and Conditions (\"Terms\") form a binding agreement between the person or organisation using the Platform (\"you\" or \"User\") and DoubleTap Innovations and Technologies Pvt Ltd. (\"InternSharks\", \"we\", \"us\" or \"our\"). By registering, clicking acceptance, purchasing a plan or credit, or using the Platform, you agree to these Terms and our Privacy Policy. If you act for a company, institution or Minor, you confirm that you have authority to bind that person or organisation.",
              ),
              _bodyText(
                "If you do not agree, do not use the Platform. Consumer and data-protection rights that cannot lawfully be waived remain unaffected.",
              ),

              _sectionTitle("2. Definitions"),
              _definitionItem("Platform",
                  "the InternSharks.ai™ website, mobile apps, APIs, communications and associated services."),
              _definitionItem("Student",
                  "a learner or candidate using the Platform, including a school student where permitted under Section 3."),
              _definitionItem("Recruiter",
                  "an employer, company representative or authorised person creating opportunities or evaluating candidates."),
              _definitionItem("Institution",
                  "a school, college, university, training provider or authorised coordinator using institution functions."),
              _definitionItem("AI Services",
                  "automated or AI-assisted tools for resumes, ATS analysis, matching, content, chat, assessment, KYC support, mock interviews, syllabus, recommendations or related functions."),
              _definitionItem("Credits",
                  "Platform units that may be required to access defined features; Credits are not money, securities or stored value."),

              _sectionTitle("3. Eligibility, Minors and Guardian Agreement"),
              _bodyText(
                "The Platform permits users under 18, including school students, to register for age-appropriate learning, career-exposure and internship opportunities. A Minor may use the Platform only with verifiable consent and supervision of a parent or lawful guardian to the extent required by applicable law. The guardian accepts these Terms on the Minor's behalf and is responsible for supervising the account. Institution approval alone is not a substitute for guardian consent unless applicable law expressly permits it.",
              ),
              _highlightBox(
                "Guardian Consent Required for Minors",
                "A Minor must not falsely state their age or bypass a guardian-consent process, and any placement involving a Minor must be lawful, age-appropriate, non-hazardous, safe, compatible with education and compliant with working-hour, welfare and child or adolescent labour requirements.",
              ),
              _bulletItem("Registration does not establish legal eligibility for every internship. Recruiters must independently verify age and all required permissions before placement."),
              _bulletItem("We may restrict or remove an opportunity, application or placement involving a Minor when safety, legality, consent or suitability is uncertain."),
              const SizedBox(height: 6),
              _bodyText(
                "Users who are legally incapable of entering a contract may not independently purchase paid services or accept an internship agreement; a competent parent, guardian or authorised representative must complete the relevant action.",
              ),

              _sectionTitle("4. Accounts, Verification and Security"),
              _bulletItem("Provide accurate, current and complete information and keep it updated."),
              _bulletItem("Maintain one appropriate account unless we approve otherwise. Do not impersonate another person or organisation."),
              _bulletItem("Keep passwords, OTPs, devices and access links confidential. You are responsible for activity conducted through your account until you notify us of unauthorised access."),
              _bulletItem("Complete reasonable email, mobile, identity, student, company, institution or representative verification when requested."),
              _bulletItem("Provide only documents requested for verification and do not submit forged, altered or unlawfully obtained documents."),
              const SizedBox(height: 6),
              _bodyText(
                "We may refuse registration, require additional verification, limit visibility or suspend access where information is incomplete, inconsistent, unsafe or suspected to be fraudulent.",
              ),

              _sectionTitle("5. Services and Platform Role"),
              _bodyText(
                "The Platform may provide profiles, internship listings, search and matching, applications, shortlists, assessments, certificates, communications, progress tracking, recruiter and institution tools, credits, payments, webinars and AI Services. Features may differ by role, plan, geography, device or release and may change over time.",
              ),
              _bodyText(
                "InternSharks provides technology and facilitation unless expressly agreed otherwise. We are not the employer, educational institution, agent or guarantor of a Student, Recruiter or Institution. A listing, profile, verification badge, score, match or recommendation is not an endorsement or promise of identity, legality, suitability, selection, payment, stipend, academic credit or outcome.",
              ),

              _sectionTitle("6. Student Responsibilities"),
              _bulletItem("Submit truthful qualifications, experience, documents, work samples and application information."),
              _bulletItem("Apply only where genuinely interested and eligible; attend interviews and complete accepted work professionally and safely."),
              _bulletItem("Do not plagiarise, cheat in assessments, misrepresent AI-generated content as independently created where disclosure is required, or upload confidential information without permission."),
              _bulletItem("Use communications respectfully and report demands for unlawful fees, unsafe work, discrimination, harassment or suspicious conduct."),
              _bulletItem("Retain copies of important certificates and outputs before deleting an account or when an opportunity closes."),

              _sectionTitle("7. Recruiter Responsibilities"),
              _bulletItem("Create genuine, accurate and complete internship or project listings, including role, location or remote status, duration, working hours, selection process, stipend or fees, deliverables, supervision and eligibility."),
              _bulletItem("Have authority to recruit for the named organisation and comply with employment, internship, anti-discrimination, accessibility, safety, tax and sector-specific laws."),
              _bulletItem("Do not demand unlawful deposits, security payments, training purchases or off-platform payments from Students. Any permitted fee must be transparent, lawful and clearly disclosed before application."),
              _bulletItem("Use candidate data only for the stated opportunity or another purpose separately authorised by the Student; do not scrape, resell, publish or build unrelated databases."),
              _bulletItem("Apply meaningful human review to AI scores, rankings, recommendations and generated content. Do not make consequential decisions solely because of an automated output."),
              _bulletItem("For Minors, verify age, guardian consent, safety, legality, working hours and supervision before any placement. Prohibited or hazardous work is not allowed."),
              _bulletItem("Maintain accurate application statuses and progress records and promptly communicate material changes or cancellation of an opportunity."),

              _sectionTitle("8. Institutions and Coordinators"),
              _bodyText(
                "An Institution must authorise each coordinator and ensure that student linkage, data access, recommendations, assessments and progress monitoring are lawful and within the Institution's authority. Coordinators must keep credentials confidential and access only records relevant to their assigned responsibilities. An Institution is responsible for its coordinators and for notices or consents it is required to provide independently.",
              ),

              _sectionTitle("9. Access, Licences and Credits"),
              _bodyText(
                "Some functions require an active plan, licence or sufficient Credits. Entitlement may vary by role and feature. A licence or Credit balance gives access only to the functionality shown for that account; it does not override privacy, consent, eligibility, verification or role-based access controls and does not grant unrestricted access to all Platform information.",
              ),
              _bulletItem("Free or promotional Credits may be offered, changed, limited, revoked or expire according to the promotion displayed at the time."),
              _bulletItem("Purchased Credits and plans are usable only for the account and permitted features, have no cash value and may not be transferred, resold or exchanged unless we expressly allow it."),
              _bulletItem("Credit deductions may occur when a feature is successfully requested or delivered as described at the point of use. If a verified technical failure prevents delivery, we may restore the affected Credits."),
              _bulletItem("When a licence, plan or Credits expire or are exhausted, paid functions may stop immediately, although the account and lawful records may remain subject to these Terms and the Privacy Policy."),

              _sectionTitle("10. Plans, Payments, Refunds and Cancellation"),
              _bodyText(
                "Prices, plan duration, included Credits, taxes and feature limits are displayed at checkout and may change for future purchases based on market demand, promotions and product changes. An existing completed purchase is governed by the checkout terms shown for that purchase. Unless checkout clearly states otherwise, plans do not automatically renew.",
              ),
              _bulletItem("Payments may be processed through Cashfree or, where required, an applicable app store or other disclosed payment provider. Their terms and billing rules also apply."),
              _bulletItem("You authorise the payment provider to charge the amount shown, including applicable taxes, and must provide accurate billing information."),
              _bulletItem("Completed purchases, fixed-term plans and allocated Credits are generally non-cancellable and non-refundable. Exceptions apply where required by law, an app-store or payment-provider policy, or for a verified duplicate or unauthorised charge or a service we fail to deliver."),
              _bulletItem("If recurring billing is introduced, the renewal price, frequency and method for stopping future renewals will be disclosed before purchase. Stopping renewal does not ordinarily refund the current paid period."),
              _bulletItem("Chargebacks made without a valid basis may lead to suspension while the dispute is investigated. Nothing in this section limits mandatory consumer remedies."),
              const SizedBox(height: 6),
              _bodyText(
                "Paid services and subscriptions must be completed through approved payment methods. Applicable statutory taxes (including GST) may be charged where required by law.",
              ),

              _sectionTitle("11. Internships, Projects, Stipends and Progress"),
              _bodyText(
                "A Student and Recruiter are responsible for agreeing the specific internship or project terms, including deliverables, ownership, confidentiality, stipend, fee, expenses, schedule, supervision, assessment, certificate and termination. InternSharks is not responsible for off-platform promises or for payment of a stipend unless we expressly accept that obligation in writing.",
              ),
              _bodyText(
                "The Platform may allow daily progress, status, links, assessments, results and completion records. Each party must keep these records accurate and must not falsify completion, attendance, output or performance. Disputes should first be raised through the Platform and with the relevant counterparty; we may preserve records and facilitate communication but are not required to adjudicate private contractual disputes.",
              ),

              _sectionTitle("12. AI Services and Automated Outputs"),
              _bodyText(
                "AI Services may analyse resumes and internship descriptions, generate or improve content, calculate ATS or fit scores, rank or recommend candidates, create syllabi or assessments, support KYC, conduct chat or mock interviews, transcribe audio, generate feedback and provide career assistance. AI outputs are probabilistic and may be inaccurate, incomplete, outdated or biased.",
              ),
              _bulletItem("Review and verify every important output before use. Do not rely on AI as legal, financial, medical, safety, academic or employment advice."),
              _bulletItem("Recruiters remain responsible for final decisions and must consider relevant evidence, reasonable accommodations and applicable non-discrimination duties."),
              _bulletItem("Students remain responsible for the truthfulness of AI-assisted resumes, answers, portfolios and other submissions."),
              _bulletItem("You grant us permission to process submitted content through our AI and infrastructure Service Providers solely to operate, secure and improve the requested service as described in the Privacy Policy."),
              _bulletItem("Do not use AI Services to infer highly sensitive traits unlawfully, create deceptive documents, impersonate people, cheat, harass, discriminate or make prohibited decisions."),
              _bulletItem("A User may request correction of inaccurate source data or raise a concern about a significant automated score through the grievance process."),

              _sectionTitle("13. User Content and Permissions"),
              _bodyText(
                "You retain ownership of content you lawfully own. You grant InternSharks a worldwide, non-exclusive, royalty-free, limited licence to host, copy, format, transmit, display, process and create technical or AI-assisted transformations of that content only as needed to operate, secure, support and improve the Platform, comply with law and exercise these Terms. This licence ends when the content is deleted from active systems, subject to legal retention, backups and content already shared with authorised recipients.",
              ),
              _bodyText(
                "You confirm that you have the rights and permissions needed to upload content and that it does not infringe intellectual property, privacy, confidentiality or other rights. Feedback about the Platform may be used without restriction or payment, but we will not publicly identify you without permission.",
              ),

              _sectionTitle("14. Communications, Notifications and Webinars"),
              _bodyText(
                "You agree to receive transactional communications necessary for registration, security, applications, payments, service operation and grievances. Optional marketing may be withdrawn using available controls. Webinar or event recordings will be disclosed before recording; participation after notice may constitute consent where permitted, and separate consent will be obtained where required.",
              ),

              _sectionTitle("15. Prohibited Conduct"),
              _bodyText("You agree not to:"),
              _bulletItem("break the law, violate another person's rights, exploit or endanger a Minor, discriminate unlawfully, harass, threaten or deceive;"),
              _bulletItem("post fake opportunities, charge undisclosed or unlawful fees, conduct pyramid schemes, facilitate forced labour or offer hazardous work to a Minor;"),
              _bulletItem("scrape, harvest, export, resell or use personal data outside authorised recruitment or institution purposes;"),
              _bulletItem("circumvent Credits, licences, security, access controls, rate limits or account restrictions;"),
              _bulletItem("upload malware, probe vulnerabilities, disrupt systems, reverse engineer protected components or use automated access without written permission;"),
              _bulletItem("impersonate a person or organisation, manipulate assessments or progress, submit forged documents or create misleading AI-generated records;"),
              _bulletItem("infringe intellectual property or confidentiality, upload unlawful content, spam users or use the Platform for an unrelated commercial database; or"),
              _bulletItem("use outputs to train competing models or services where doing so would copy protected Platform content, violate privacy or breach these Terms."),

              _sectionTitle("16. Intellectual Property"),
              _bodyText(
                "The Platform, software, interfaces, designs, branding, databases, documentation and InternSharks-created content are owned by InternSharks or its licensors and protected by applicable law. Subject to these Terms, we grant you a limited, revocable, non-exclusive, non-transferable right to use the Platform for its intended purpose. No other rights are granted.",
              ),

              _sectionTitle("17. Third-Party Services and Links"),
              _bodyText(
                "The Platform depends on or links to payment gateways, app stores, cloud services, AI providers, communication providers, recruiter websites and other third parties. Their terms and privacy notices may apply. We are not responsible for an independent third party's content, availability or conduct, but this does not exclude liability that cannot lawfully be excluded.",
              ),

              _sectionTitle("18. Moderation, Suspension and Termination"),
              _bodyText(
                "We may investigate, limit, remove content, suspend or terminate access when reasonably necessary for safety, suspected fraud, non-payment, expired entitlement, legal compliance, rights protection, material breach or risk to the Platform or users. Where appropriate, we will provide notice and an opportunity to respond, but immediate action may be taken for urgent safety, security or legal reasons.",
              ),
              _bodyText(
                "On termination, rights to use the Platform stop. Provisions that by nature should survive — including payments due, intellectual property, confidentiality, disclaimers, liability, dispute terms and lawful data retention — continue to apply.",
              ),

              _sectionTitle("19. Account Deletion and Inactivity"),
              _bodyText(
                "A user may request deletion through the mobile app's \"Delete Account\" function where available or by contacting us from the registered account. Access is deactivated promptly after verification, and deletion or anonymisation is targeted within 30 days, except for records required by law, tax, fraud prevention, security, contract, rights of other users or legal claims. Account deletion may permanently remove access to applications, reports, certificates, progress and unused promotional Credits.",
              ),
              _bulletItem("After 12 continuous months without meaningful activity, an account may be archived and marked inactive. Reactivation requires a written request and identity verification."),
              _bulletItem("After 24 continuous months without meaningful activity, the account and associated personal data are deleted or irreversibly anonymised, subject to lawful retention exceptions."),
              _bulletItem("We will provide inactivity or deletion notice where reasonably possible using current contact details. Users are responsible for keeping those details updated."),

              _sectionTitle("20. Availability, Changes and Beta Features"),
              _bodyText(
                "We aim to provide reliable service but do not guarantee uninterrupted or error-free availability. Maintenance, provider outages, security events, legal requirements or circumstances beyond our control may affect access. Features may be added, changed or withdrawn. Beta or experimental features may be less reliable and may be subject to additional notices.",
              ),

              _sectionTitle("21. Disclaimers"),
              _bodyText(
                "To the maximum extent permitted by law, the Platform and AI outputs are provided on an \"as is\" and \"as available\" basis without implied warranties of accuracy, fitness, merchantability, non-infringement, selection, placement, stipend, performance, safety or outcome. You must conduct independent diligence on users, opportunities and outputs. Nothing in these Terms excludes a warranty or remedy that cannot be excluded under applicable consumer law.",
              ),

              _sectionTitle("22. Indemnity"),
              _bodyText(
                "To the extent permitted by law, a Recruiter, Institution or business User will defend and indemnify InternSharks and its personnel against third-party claims, losses and reasonable costs arising from that User's listings, candidate-data use, unlawful decisions, Minor placement, content, contractual promises or breach of these Terms or law. An individual consumer's liability under this clause is limited to the extent permitted by applicable law and does not apply to losses caused by our own unlawful conduct.",
              ),

              _sectionTitle("23. Limitation of Liability"),
              _bodyText(
                "To the maximum extent permitted by law, neither party is liable for indirect, incidental, special, punitive or consequential loss, or loss of profits, opportunity or data, arising from the Platform. InternSharks' total aggregate liability for claims relating to a paid service will not exceed the amount you paid to InternSharks for that service during the 12 months before the event giving rise to the claim; for a free service, the cap is INR 5,000.",
              ),
              _bodyText(
                "These limits do not apply to fraud, wilful misconduct, death or personal injury caused by negligence, breach of confidentiality or data-protection duties where liability cannot lawfully be limited, infringement for which the responsible party must indemnify, payment obligations, or any liability that applicable law prohibits us from excluding or limiting.",
              ),

              _sectionTitle("24. Force Majeure"),
              _bodyText(
                "Neither party is responsible for delay or failure caused by events beyond reasonable control, including natural disasters, epidemic, war, civil disorder, government action, telecommunications or power failure, cyberattack or critical provider outage, provided the affected party uses reasonable efforts to mitigate the impact. Payment obligations already due are not excused.",
              ),

              _sectionTitle("25. Governing Law and Disputes"),
              _bodyText(
                "These Terms are governed by the laws of India. Before formal proceedings, the parties should attempt in good faith to resolve a dispute through the grievance process. Subject to mandatory consumer forums and other non-waivable rights, courts at Chennai, Tamil Nadu will have exclusive jurisdiction. Nothing prevents either party from seeking urgent interim relief or using a statutory regulator or complaint mechanism.",
              ),

              _sectionTitle("26. Grievance Process"),
              _bulletItem("Write to grievance@internsharks.ai / info@internsharks.ai from the registered contact channel and identify the account, transaction or listing and the relief requested."),
              _bulletItem("We may request proportionate verification and supporting information. Never send passwords, OTPs, CVV or UPI PIN."),
              _bulletItem("We aim to acknowledge a grievance within 24 hours and resolve it within 15 days, or within another timeframe required by applicable law. Urgent safety or Minor-protection reports receive priority."),
              _bulletItem("A party may pursue available statutory or judicial remedies if the issue remains unresolved."),

              _sectionTitle("27. Changes to These Terms"),
              _bodyText(
                "We may revise these Terms for legal, security, commercial or product changes. We will provide reasonable notice of material changes through the Platform, email or another appropriate channel. Changes do not retroactively alter completed purchase terms unless required by law or agreed by you. Continued use after the effective date constitutes acceptance where permitted; otherwise, we will request fresh acceptance.",
              ),

              _sectionTitle("28. General"),
              _definitionItem("Entire agreement",
                  "These Terms, the Privacy Policy, checkout terms and any feature-specific terms form the agreement for the Platform."),
              _definitionItem("Priority",
                  "Feature-specific or checkout terms control only for their subject matter; mandatory law always prevails."),
              _definitionItem("Severability",
                  "If a provision is unenforceable, it will be limited or removed to the minimum extent necessary and the remainder continues."),
              _definitionItem("No waiver", "Failure to enforce a provision is not a waiver."),
              _definitionItem("Assignment",
                  "You may not transfer your account or these Terms without our consent. We may assign them as part of a reorganisation, financing or transfer of the Platform, subject to law and notice obligations."),
              _definitionItem("No partnership",
                  "These Terms do not create employment, agency, partnership, franchise or joint venture between InternSharks and a User."),

              _sectionTitle("29. Grievance Officer and Contact"),
              _definitionItem("Grievance Officer", "Paul Simson"),
              _definitionItem("Email", "grievance@internsharks.ai"),
              _definitionItem("General support", "info@internsharks.ai"),
              _definitionItem("Telephone", "+91 9600043880"),
              _definitionItem("Registered office", "78, 2nd Floor, Usman Road, T Nagar, Chennai – 600017, Tamil Nadu, India"),
              _definitionItem("GSTIN", "33AALCD9144Q1ZZ"),
              _definitionItem("Website", "www.internsharks.ai"),
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
          "DoubleTap Innovations and Technologies Pvt Ltd.\n78, 2nd Floor, Usman Road, T Nagar, Chennai - 600017, Tamil Nadu, India",
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