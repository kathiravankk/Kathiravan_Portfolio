import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/core/utils/app_alert_utils.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';
import 'package:internsharks/app/modules/login/view/kyc_verification_screen.dart';
import 'package:internsharks/app/modules/recruiter_flow/login/controller/new_recruiter_company_info_controller.dart';

class NewRecruiterCompanyInfoScreen extends StatefulWidget {
  const NewRecruiterCompanyInfoScreen({super.key});

  @override
  State<NewRecruiterCompanyInfoScreen> createState() =>
      _NewRecruiterCompanyInfoScreenState();
}

class _NewRecruiterCompanyInfoScreenState
    extends State<NewRecruiterCompanyInfoScreen> {
  final NewRecruiterCompanyInfoController controller =
      Get.find<NewRecruiterCompanyInfoController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        body: SafeArea(
          child: Column(
            children: [
              /// TOP BAR
              _buildTopBar(),

              /// SCROLLABLE FORM
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      /// STEP INDICATOR
                      _buildStepIndicator(),

                      const SizedBox(height: 22),

                      /// TOP AI EXTRACTION CARD
                      _buildExtractionCard(),

                      const SizedBox(height: 20),

                      /// OR DIVIDER
                      _buildOrDivider(),

                      const SizedBox(height: 20),

                      /// SECTION TITLE: FILL COMPANY DETAILS
                      Text(
                        "Fill Company Details",
                        style: AppStyles.customTextStyle(
                          size: 18,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// COMPANY NAME *
                      _buildInputField(
                        label: "Company Name",
                        isRequired: true,
                        controller: controller.companyNameController,
                        hintText: "Enter company name",
                        prefixIcon: CupertinoIcons.bookmark,
                      ),

                      const SizedBox(height: 18),

                      /// COMPANY EMAIL *
                      _buildInputField(
                        label: "Company Email",
                        isRequired: true,
                        controller: controller.companyEmailController,
                        hintText: "Enter company email",
                        prefixIcon: CupertinoIcons.mail,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 18),

                      /// COMPANY CONTACT NUMBER *
                      _buildContactNumberField(),

                      const SizedBox(height: 18),

                      /// COMPANY ADDRESS *
                      _buildInputField(
                        label: "Company Address",
                        isRequired: true,
                        controller: controller.companyAddressController,
                        hintText: "Enter complete address",
                        prefixIcon: CupertinoIcons.location,
                      ),

                      const SizedBox(height: 18),

                      /// PINCODE
                      _buildInputField(
                        label: "Pincode",
                        isRequired: false,
                        controller: controller.pinCodeController,
                        hintText: "Enter pincode",
                        prefixIcon: CupertinoIcons.tag,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),

                      const SizedBox(height: 18),

                      /// COMPANY WEBSITE *
                      _buildInputField(
                        label: "Company Website",
                        isRequired: true,
                        controller: controller.companyWebsiteController,
                        hintText: "https://www.company.com",
                        prefixIcon: CupertinoIcons.globe,
                        keyboardType: TextInputType.url,
                      ),

                      const SizedBox(height: 18),

                      /// INDUSTRY TYPE *
                      _buildIndustryTypeSelector(),

                      const SizedBox(height: 18),

                      /// NUMBER OF EMPLOYEES *
                      _buildNumberOfEmployeesSelector(),

                      const SizedBox(height: 18),

                      /// EMPLOYEE RANGE
                      _buildInputField(
                        label: "Employee Range",
                        isRequired: false,
                        controller: controller.employeeRangeController,
                        hintText: "e.g. 11-50",
                        prefixIcon: CupertinoIcons.person_3,
                      ),

                      const SizedBox(height: 18),

                      /// COMPANY DESCRIPTION *
                      _buildMultilineField(
                        label: "Company Description",
                        isRequired: true,
                        controller: controller.companyDescriptionController,
                        hintText: "Enter company description",
                        prefixIcon: CupertinoIcons.doc_text,
                        maxLines: 4,
                        maxLength: 500,
                        lengthObservable: controller.descriptionLength,
                      ),

                      const SizedBox(height: 18),

                      /// COMPANY TYPE
                      _buildInputField(
                        label: "Company Type",
                        isRequired: false,
                        controller: controller.companyTypeController,
                        hintText: "e.g. Startup, MNC, Agency",
                        prefixIcon: CupertinoIcons.briefcase,
                      ),

                      const SizedBox(height: 18),

                      /// FOUNDED YEAR
                      _buildInputField(
                        label: "Founded Year",
                        isRequired: false,
                        controller: controller.foundedYearController,
                        hintText: "e.g. 2015",
                        prefixIcon: CupertinoIcons.calendar,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                      ),

                      const SizedBox(height: 18),

                      /// GST OR CIN NUMBER
                      _buildInputField(
                        label: "GST or CIN Number",
                        isRequired: false,
                        controller: controller.gstCinController,
                        hintText: "Enter GST or CIN (Optional)",
                        prefixIcon: CupertinoIcons.doc_text,
                      ),

                      const SizedBox(height: 18),

                      /// WORKING MODEL
                      _buildWorkingModelSelector(),

                      const SizedBox(height: 18),

                      /// COMPANY MISSION
                      _buildMultilineField(
                        label: "Company Mission",
                        isRequired: false,
                        controller: controller.companyMissionController,
                        hintText: "Enter company mission",
                        prefixIcon: CupertinoIcons.doc_text,
                        maxLines: 3,
                        maxLength: 300,
                        lengthObservable: controller.missionLength,
                      ),

                      const SizedBox(height: 18),

                      /// COMPANY VISION
                      _buildMultilineField(
                        label: "Company Vision",
                        isRequired: false,
                        controller: controller.companyVisionController,
                        hintText: "Enter company vision",
                        prefixIcon: CupertinoIcons.doc_text,
                        maxLines: 3,
                        maxLength: 300,
                        lengthObservable: controller.visionLength,
                      ),

                      const SizedBox(height: 18),

                      /// CORE SERVICES
                      _buildInputField(
                        label: "Core Services",
                        isRequired: false,
                        controller: controller.coreServicesController,
                        hintText: "e.g. Web Development, AI, Cloud",
                        prefixIcon: CupertinoIcons.tag,
                      ),

                      const SizedBox(height: 18),

                      /// WHY INTERN WITH US?
                      _buildMultilineField(
                        label: "Why Intern With Us?",
                        isRequired: false,
                        controller: controller.whyInternWithUsController,
                        hintText: "Comma separated reasons",
                        prefixIcon: CupertinoIcons.star,
                        maxLines: 3,
                        maxLength: 300,
                        lengthObservable: controller.whyInternLength,
                      ),

                      const SizedBox(height: 24),

                      /// SOCIAL MEDIA LINKS (OPTIONAL)
                      _buildSocialMediaSection(),

                      const SizedBox(height: 24),

                      /// DOCUMENT UPLOAD CARDS
                      _buildDocumentUploadCards(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              /// FIXED BOTTOM CONTINUE BUTTON
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── TOP BAR ────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.whiteColor,
              size: 26,
            ),
            onPressed: () => Get.back(),
          ),
          const Spacer(),
          Text(
            "Step 2 of 3",
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.secondaryColor,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  // ─── STEP INDICATOR ─────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Row(
      children: [
        /// STEP 1: COMPLETED
        Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check,
                  color: AppColors.blackColor,
                  size: 18,
                  weight: 700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Personal Details",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Tell us about yourself",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 9,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        /// CONNECTOR 1 -> 2
        Container(
          width: 28,
          height: 1.5,
          color: AppColors.primaryColor,
          margin: const EdgeInsets.only(bottom: 24),
        ),

        /// STEP 2: ACTIVE
        Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  "2",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.blackColor,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Company Information",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.secondaryColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Add your company details",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 9,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        /// CONNECTOR 2 -> 3
        Container(
          width: 28,
          height: 1.5,
          color: AppColors.greyTextColor.withValues(alpha: 0.3),
          margin: const EdgeInsets.only(bottom: 24),
        ),

        /// STEP 3: UPCOMING
        Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.fieldBgColor,
                  border: Border.all(
                    color: AppColors.greyTextColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "3",
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.greyTextColor,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose Plan",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Select your plan",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 9,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── AI EXTRACTION CARD ─────────────────────────────────────────
  Widget _buildExtractionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1726),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Company Information",
            style: AppStyles.customTextStyle(
              size: 16,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Upload your company profile and let AI extract the details or fill manually.",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.greyTextColor,
              weight: FontWeight.w400,
              lineSpace: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          /// TABS: Upload File / Paste Link
          Obx(
            () => Container(
              height: 42,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0F1D),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFF1E293B),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectedTab.value = 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.selectedTab.value == 0
                              ? const Color(0xFFFFD56B)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Upload File",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: controller.selectedTab.value == 0
                                ? AppColors.blackColor
                                : AppColors.greyTextColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectedTab.value = 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.selectedTab.value == 1
                              ? const Color(0xFFFFD56B)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Paste Link",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: controller.selectedTab.value == 1
                                ? AppColors.blackColor
                                : AppColors.greyTextColor,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// TAB CONTENT
          Obx(
            () => controller.selectedTab.value == 0
                ? _buildUploadFileTabContent()
                : _buildPasteLinkTabContent(),
          ),
        ],
      ),
    );
  }

  /// TAB 1: UPLOAD FILE
  Widget _buildUploadFileTabContent() {
    return CustomPaint(
      painter: DashPainter(
        color: AppColors.primaryColor.withValues(alpha: 0.6),
        radius: 14,
        strokeWidth: 1.2,
        gap: 5,
        dash: 7,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF0A0F1D).withValues(alpha: 0.5),
        ),
        child: Column(
          children: [
            /// ICON WITH BADGE
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF132338),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.doc_text,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: AppColors.blackColor,
                      size: 11,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// TITLE
            Text(
              "Upload Company Profile",
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),

            /// RECOMMENDED
            Text(
              "(Recommended)",
              style: AppStyles.customTextStyle(
                size: 11,
                color: AppColors.primaryColor,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            /// DESCRIPTION
            Text(
              "Drag & drop your company profile (PDF, DOC, DOCX, JPG, PNG)",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 10,
                color: AppColors.greyTextColor,
                weight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 16),

            /// CHOSEN FILE BADGE (IF EXTRACTED)
            Obx(() {
              if (controller.extractedFileName.value != null &&
                  controller.extractedFileName.value!.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.correctBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.correctBorder,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.correctText,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            controller.extractedFileName.value!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.customTextStyle(
                              size: 11,
                              color: AppColors.correctText,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            /// UPLOAD BUTTON OR LOADER
            Obx(
              () => controller.isExtracting.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "AI is extracting details...",
                          style: AppStyles.customTextStyle(
                            size: 12,
                            color: AppColors.primaryColor,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: controller.pickAndExtractFile,
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.buttonGrad1,
                              AppColors.buttonGrad2,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.arrow_up_to_line,
                              color: AppColors.blackColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Upload File",
                              style: AppStyles.customTextStyle(
                                size: 14,
                                color: AppColors.blackColor,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// TAB 2: PASTE LINK
  Widget _buildPasteLinkTabContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1D).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Paste Company Website or Profile Link",
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.whiteColor,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1527),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF1E293B),
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller.pasteLinkController,
              keyboardType: TextInputType.url,
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.whiteColor,
                weight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "https://www.company.com",
                hintStyle: AppStyles.customTextStyle(
                  size: 12,
                  color: const Color(0xFF64748B),
                  weight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  CupertinoIcons.link,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => controller.isExtracting.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "AI is extracting details...",
                        style: AppStyles.customTextStyle(
                          size: 12,
                          color: AppColors.primaryColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: controller.extractFromLink,
                    child: Container(
                      width: double.infinity,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.buttonGrad1,
                            AppColors.buttonGrad2,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.sparkles,
                            color: AppColors.blackColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Extract Details",
                            style: AppStyles.customTextStyle(
                              size: 13,
                              color: AppColors.blackColor,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ─── OR DIVIDER ─────────────────────────────────────────────────
  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFF1E293B),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1726),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF1E293B),
              width: 1,
            ),
          ),
          child: Text(
            "OR",
            style: AppStyles.customTextStyle(
              size: 11,
              color: AppColors.greyTextColor,
              weight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  // ─── GENERIC INPUT FIELD ────────────────────────────────────────
  Widget _buildInputField({
    required String label,
    required bool isRequired,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label: label, isRequired: isRequired),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1527),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF1E293B),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.whiteColor,
              weight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              counterText: "",
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: AppStyles.customTextStyle(
                size: 13,
                color: const Color(0xFF64748B),
                weight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: const Color(0xFF64748B),
                size: 18,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── CONTACT NUMBER FIELD (+91 PREFIX) ──────────────────────────
  Widget _buildContactNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label: "Company Contact Number", isRequired: true),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1527),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF1E293B),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              /// COUNTRY CODE +91
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      "+91",
                      style: AppStyles.customTextStyle(
                        size: 13,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      CupertinoIcons.chevron_down,
                      color: Color(0xFF64748B),
                      size: 12,
                    ),
                  ],
                ),
              ),

              /// VERTICAL DIVIDER
              Container(
                width: 1,
                height: 24,
                color: const Color(0xFF1E293B),
              ),

              const SizedBox(width: 8),

              /// PHONE ICON
              const Icon(
                CupertinoIcons.phone,
                color: Color(0xFF64748B),
                size: 18,
              ),

              const SizedBox(width: 8),

              /// TEXT INPUT
              Expanded(
                child: TextField(
                  controller: controller.contactNumberController,
                  keyboardType: TextInputType.phone,
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter contact number",
                    hintStyle: AppStyles.customTextStyle(
                      size: 13,
                      color: const Color(0xFF64748B),
                      weight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── INDUSTRY TYPE SELECTOR ─────────────────────────────────────
  Widget _buildIndustryTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label: "Industry Type", isRequired: true),
        const SizedBox(height: 8),
        Obx(
          () => GestureDetector(
            onTap: _showIndustryPicker,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1527),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1E293B),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.selectedIndustry.value ?? "Select industry type",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.customTextStyle(
                        size: 13,
                        color: controller.selectedIndustry.value == null
                            ? const Color(0xFF64748B)
                            : AppColors.whiteColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_down,
                    color: Color(0xFF64748B),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showIndustryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F1726),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Industry Type",
                        style: AppStyles.customTextStyle(
                          size: 16,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.whiteColor),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF1E293B), height: 1),
                Expanded(
                  child: Obx(
                    () => controller.industryList.isEmpty
                        ? Center(
                            child: Text(
                              "No industries found",
                              style: AppStyles.customTextStyle(
                                size: 14,
                                color: AppColors.greyTextColor,
                                weight: FontWeight.w400,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: controller.industryList.length,
                            separatorBuilder: (context, index) => const Divider(
                              color: Color(0xFF1E293B),
                              height: 1,
                            ),
                            itemBuilder: (context, index) {
                              final item = controller.industryList[index];
                              final isSelected =
                                  controller.selectedIndustry.value == item;

                              return ListTile(
                                title: Text(
                                  item,
                                  style: AppStyles.customTextStyle(
                                    size: 14,
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.whiteColor,
                                    weight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: AppColors.primaryColor,
                                        size: 18,
                                      )
                                    : null,
                                onTap: () {
                                  controller.selectedIndustry.value = item;
                                  Get.back();
                                },
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── NUMBER OF EMPLOYEES SELECTOR ───────────────────────────────
  Widget _buildNumberOfEmployeesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label: "Number of Employees", isRequired: true),
        const SizedBox(height: 8),
        Obx(
          () => GestureDetector(
            onTap: _showEmployeeCountPicker,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1527),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1E293B),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.person_3,
                    color: Color(0xFF64748B),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      controller.selectedEmployeeCount.value ??
                          "Select number of employees",
                      style: AppStyles.customTextStyle(
                        size: 13,
                        color: controller.selectedEmployeeCount.value == null
                            ? const Color(0xFF64748B)
                            : AppColors.whiteColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_down,
                    color: Color(0xFF64748B),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEmployeeCountPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F1726),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Number of Employees",
                      style: AppStyles.customTextStyle(
                        size: 16,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.whiteColor),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFF1E293B), height: 1),
              ...controller.employeeCountOptions.map((option) {
                final isSelected =
                    controller.selectedEmployeeCount.value == option;
                return ListTile(
                  title: Text(
                    option,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,
                      weight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check,
                          color: AppColors.primaryColor,
                          size: 18,
                        )
                      : null,
                  onTap: () {
                    controller.selectedEmployeeCount.value = option;
                    Get.back();
                  },
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // ─── WORKING MODEL SELECTOR ─────────────────────────────────────
  Widget _buildWorkingModelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label: "Working Model", isRequired: false),
        const SizedBox(height: 8),
        Obx(
          () => GestureDetector(
            onTap: _showWorkingModelPicker,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1527),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1E293B),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.selectedWorkingModel.value ??
                          "Select working model",
                      style: AppStyles.customTextStyle(
                        size: 13,
                        color: controller.selectedWorkingModel.value == null
                            ? const Color(0xFF64748B)
                            : AppColors.whiteColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_down,
                    color: Color(0xFF64748B),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showWorkingModelPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F1726),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Working Model",
                      style: AppStyles.customTextStyle(
                        size: 16,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.whiteColor),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFF1E293B), height: 1),
              ...controller.workingModelOptions.map((option) {
                final isSelected =
                    controller.selectedWorkingModel.value == option;
                return ListTile(
                  title: Text(
                    option,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,
                      weight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check,
                          color: AppColors.primaryColor,
                          size: 18,
                        )
                      : null,
                  onTap: () {
                    controller.selectedWorkingModel.value = option;
                    Get.back();
                  },
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // ─── MULTILINE FIELD WITH CHARACTER COUNTER ─────────────────────
  Widget _buildMultilineField({
    required String label,
    required bool isRequired,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required int maxLines,
    required int maxLength,
    required RxInt lengthObservable,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label: label, isRequired: isRequired),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1527),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF1E293B),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 8),
                    child: Icon(
                      prefixIcon,
                      color: const Color(0xFF64748B),
                      size: 18,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      maxLines: maxLines,
                      maxLength: maxLength,
                      style: AppStyles.customTextStyle(
                        size: 13,
                        color: AppColors.whiteColor,
                        weight: FontWeight.w400,
                        lineSpace: 1.4,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: "",
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: AppStyles.customTextStyle(
                          size: 13,
                          color: const Color(0xFF64748B),
                          weight: FontWeight.w400,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Obx(
                  () => Text(
                    "${lengthObservable.value} / $maxLength",
                    style: AppStyles.customTextStyle(
                      size: 10,
                      color: const Color(0xFF64748B),
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── SOCIAL MEDIA SECTION ───────────────────────────────────────
  Widget _buildSocialMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Social Media Links (Optional)",
          style: AppStyles.customTextStyle(
            size: 15,
            color: AppColors.whiteColor,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),

        /// ROW 1: LinkedIn & X
        Row(
          children: [
            Expanded(
              child: _buildSocialField(
                label: "LinkedIn",
                controller: controller.linkedInController,
                hintText: "LinkedIn URL",
                icon: CupertinoIcons.link,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSocialField(
                label: "X",
                controller: controller.xController,
                hintText: "X URL",
                icon: CupertinoIcons.clear_thick,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        /// ROW 2: Facebook & Instagram
        Row(
          children: [
            Expanded(
              child: _buildSocialField(
                label: "Facebook",
                controller: controller.facebookController,
                hintText: "Facebook URL",
                icon: Icons.facebook,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSocialField(
                label: "Instagram",
                controller: controller.instagramController,
                hintText: "Instagram URL",
                icon: CupertinoIcons.camera,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        /// ROW 3: YouTube
        _buildSocialField(
          label: "YouTube",
          controller: controller.youtubeController,
          hintText: "YouTube URL",
          icon: CupertinoIcons.play_rectangle,
        ),
      ],
    );
  }

  Widget _buildSocialField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1527),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF1E293B),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.url,
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.whiteColor,
              weight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: AppStyles.customTextStyle(
                size: 12,
                color: const Color(0xFF64748B),
                weight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF64748B),
                size: 16,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  // ─── DOCUMENT UPLOAD CARDS ──────────────────────────────────────
  Widget _buildDocumentUploadCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 1. COMPANY LOGO *
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadCardHeader(
                label: "Company Logo",
                isRequired: true,
                subtitle: "JPG, PNG (Max 2MB)",
              ),
              const SizedBox(height: 8),
              Obx(
                () => _buildUploadBox(
                  hasFile: controller.companyLogo.value != null,
                  fileName: controller.companyLogo.value != null
                      ? "Logo Selected"
                      : "No file chosen",
                  previewFile: controller.companyLogo.value,
                  onTap: _showLogoPickerSheet,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        /// 2. REGISTRATION DOCUMENT *
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadCardHeader(
                label: "Company Registration Document",
                isRequired: true,
                subtitle: "PDF, DOC, DOCX (Max 5MB)",
              ),
              const SizedBox(height: 8),
              Obx(
                () => _buildUploadBox(
                  hasFile: controller.registrationDocFile.value != null,
                  fileName: controller.registrationDocName.value ??
                      "No file chosen",
                  onTap: controller.pickRegistrationDoc,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        /// 3. OTHER SUPPORTING DOCUMENT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadCardHeader(
                label: "Other Supporting Document (Optional)",
                isRequired: false,
                subtitle: "PDF, DOC, DOCX (Max 5MB)",
              ),
              const SizedBox(height: 8),
              Obx(
                () => _buildUploadBox(
                  hasFile: controller.supportingDocFile.value != null,
                  fileName: controller.supportingDocName.value ??
                      "No file chosen",
                  onTap: controller.pickSupportingDoc,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCardHeader({
    required String label,
    required bool isRequired,
    required String subtitle,
  }) {
    return SizedBox(
      height: 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customTextStyle(
                    size: 11,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                    lineSpace: 1.1,
                  ),
                ),
              ),
              if (isRequired)
                Text(
                  " *",
                  style: AppStyles.customTextStyle(
                    size: 11,
                    color: AppColors.redColor,
                    weight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: 9,
              color: const Color(0xFF64748B),
              weight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox({
    required bool hasFile,
    required String fileName,
    required VoidCallback onTap,
    dynamic previewFile,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 72,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1527),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasFile
                    ? AppColors.primaryColor
                    : const Color(0xFF1E293B),
                width: 1,
              ),
            ),
            child: previewFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(
                      previewFile,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.cloud_upload,
                        color: AppColors.primaryColor,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Choose File",
                        style: AppStyles.customTextStyle(
                          size: 10,
                          color: AppColors.whiteColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppStyles.customTextStyle(
            size: 9,
            color: hasFile ? AppColors.correctText : const Color(0xFF64748B),
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _showLogoPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F1726),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primaryColor,
                size: 22,
              ),
              title: Text(
                'Choose from Gallery',
                style: AppStyles.customTextStyle(
                  color: AppColors.whiteColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                controller.pickCompanyLogo(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_camera,
                color: AppColors.primaryColor,
                size: 22,
              ),
              title: Text(
                'Take a Photo',
                style: AppStyles.customTextStyle(
                  color: AppColors.whiteColor,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Get.back();
                controller.pickCompanyLogo(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── LABEL BUILDER ──────────────────────────────────────────────
  Widget _buildLabel({required String label, required bool isRequired}) {
    return Row(
      children: [
        Text(
          label,
          style: AppStyles.customTextStyle(
            size: 13,
            color: AppColors.whiteColor,
            weight: FontWeight.w600,
          ),
        ),
        if (isRequired)
          Text(
            " *",
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.redColor,
              weight: FontWeight.w700,
            ),
          ),
      ],
    );
  }

  // ─── FIXED BOTTOM CONTINUE BUTTON ───────────────────────────────
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF070B14).withValues(alpha: 0.9),
        border: const Border(
          top: BorderSide(
            color: Color(0xFF1E293B),
            width: 0.5,
          ),
        ),
      ),
      child: CustomButtonWidget(
        buttonText: "Continue",
        buttonFunction: () {
          final error = controller.validateStep2();
          if (error != null) {
            AppAlertUtils.showToast(message: error, isError: true);
            return;
          }

          final step2Data = controller.getCombinedRegisterData();
          debugPrint("Step 2 Collected Data: $step2Data");

          AppAlertUtils.showToast(
            message: "Company details saved successfully!",
            isError: false,
          );

          /// TODO: Next step will be called here (Step 3: Choose Plan)
        },
      ),
    );
  }
}
