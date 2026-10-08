import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';
import 'package:internsharks/app/modules/webinar/controller/webinar_controller.dart';
import 'package:internsharks/app/modules/webinar/widgets/webinar_common_widgets.dart';

/// Function to show the Webinar Registration Modal (Free or Paid)
void showWebinarRegistrationModal({
  required BuildContext context,
  required WebinarDetailData detail,
  required bool isPaid,
  required String? studentId,
  required String? studentName,
  required String? studentEmail,
  required String? studentMobile,
  required String? studentCollege,
  required WebinarController webinarController,
  required Future<void> Function(
    Map<String, dynamic> payload,
    String name,
    String email,
  ) onRegisterFree,
  required Future<void> Function(
    Map<String, dynamic> payload,
    String name,
    String email,
  ) onProceedToPay,
}) {
  final fullNameController = TextEditingController(text: studentName ?? "");
  final emailController = TextEditingController(text: studentEmail ?? "");
  final mobileController = TextEditingController(text: studentMobile ?? "");
  final questionController = TextEditingController();

  String? selectedCollege = studentCollege;
  String? selectedCourse;
  String? selectedYearOfStudy;
  String? selectedRole;

  const List<String> courseOptions = [
    "Course / Degree",
    "BE",
    "B.Tech",
    "B.Sc",
    "BCA",
    "B.Com",
    "BA",
    "ME",
    "M.Tech",
    "M.Sc",
    "MCA",
    "M.Com",
    "MA",
    "MBA",
    "BBA",
    "BBM",
    "PhD",
    "MBBS",
    "Nursing",
    "BDS",
    "Other",
  ];

  const List<String> roleOptions = [
    "Student",
    "Working professional",
    "Job seeker",
    "Freelancer",
  ];

  const List<String> yearOfStudyOptions = [
    "1st Year",
    "2nd Year",
    "3rd Year",
    "4th Year",
    "Graduated",
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      return StatefulBuilder(
        builder: (ctx, setModalState) {
          final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
          return Container(
            height: MediaQuery.of(ctx).size.height * 0.92,
            decoration: BoxDecoration(
              color: const Color(0xFF0A1521),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(
                color: const Color(0xFF1E2E42),
                width: 1.2,
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // TOP BAR: Title & Close Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        const SizedBox(width: 36),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Register for Webinar",
                              style: AppStyles.customTextStyle(
                                size: 18,
                                weight: FontWeight.w700,
                                color: const Color(0xFFFFD44D),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(sheetCtx).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              color: Color(0xFF172637),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // FORM CONTENT SCROLLABLE
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(18, 10, 18, bottomInset + 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. HERO WEBINAR BANNER (Left: Pill + Title + Date/Time, Right: 3D Illustration)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // BADGE PILL (FREE vs PAID)
                                    if (!isPaid)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF063A34),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: const Color(0xFF10B981)
                                                .withValues(alpha: 0.6),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.play_arrow_rounded,
                                              size: 13,
                                              color: Color(0xFF10B981),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "FREE WEBINAR",
                                              style: AppStyles.customTextStyle(
                                                size: 10.5,
                                                weight: FontWeight.w800,
                                                color: const Color(0xFF10B981),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF332005),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: const Color(0xFFF59E0B)
                                                .withValues(alpha: 0.7),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.sell_outlined,
                                              size: 11.5,
                                              color: Color(0xFFF59E0B),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "PAID WEBINAR",
                                              style: AppStyles.customTextStyle(
                                                size: 10.5,
                                                weight: FontWeight.w800,
                                                color: const Color(0xFFF59E0B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    const SizedBox(height: 10),

                                    // TITLE
                                    Text(
                                      detail.title ?? "Webinar Session",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.customTextStyle(
                                        size: 16.5,
                                        weight: FontWeight.w800,
                                        color: Colors.white,
                                        lineSpace: 1.25,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // DATE & TIME ROW
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 12.5,
                                          color: Color(0xFF94A3B8),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          WebinarDateUtils.formatWebinarDate(detail.webinarDate),
                                          style: AppStyles.customTextStyle(
                                            size: 11.5,
                                            weight: FontWeight.w500,
                                            color: const Color(0xFF94A3B8),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          "|",
                                          style: TextStyle(
                                            color: Color(0xFF475569),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.access_time_rounded,
                                          size: 12.5,
                                          color: Color(0xFF94A3B8),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            WebinarDateUtils.formatWebinarTime(detail),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyles.customTextStyle(
                                              size: 11.5,
                                              weight: FontWeight.w500,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // 3D ILLUSTRATION (Calendar for Free, Resume Card for Paid)
                              if (isPaid)
                                const WebinarResume3dIllustration()
                              else
                                const WebinarCalendar3dIllustration(),
                            ],
                          ),

                          // REGISTRATION FEE BOX (FOR PAID WEBINAR)
                          if (isPaid) ...[
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D1722),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFD97706),
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Registration Fee",
                                    style: AppStyles.customTextStyle(
                                      size: 15.5,
                                      weight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "₹${detail.amount ?? 0}",
                                    style: AppStyles.customTextStyle(
                                      size: 21,
                                      weight: FontWeight.w800,
                                      color: const Color(0xFFF59E0B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          // 2. PERSONAL INFORMATION
                          const WebinarSectionHeader(
                            icon: Icons.person_outline_rounded,
                            title: "Personal Information",
                          ),

                          const SizedBox(height: 12),

                          // Side-by-side Full Name & Email Address
                          Row(
                            children: [
                              Expanded(
                                child: WebinarFormField(
                                  controller: fullNameController,
                                  hintText: "Full Name *",
                                  icon: Icons.person_outline_rounded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: WebinarFormField(
                                  controller: emailController,
                                  hintText: "Email Address *",
                                  icon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Mobile Number Full Width
                          WebinarFormField(
                            controller: mobileController,
                            hintText: "Mobile Number *",
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 20),

                          // 3. ACADEMIC / PROFESSIONAL INFORMATION
                          const WebinarSectionHeader(
                            icon: Icons.school_outlined,
                            title: "Academic / Professional Information",
                          ),

                          const SizedBox(height: 12),

                          // Row 1: College/University & Course/Degree
                          Row(
                            children: [
                              Expanded(
                                child: WebinarDropdownSelector(
                                  icon: Icons.apartment_outlined,
                                  text: selectedCollege != null &&
                                          selectedCollege!.isNotEmpty
                                      ? selectedCollege!
                                      : "College / University *",
                                  isSelected: selectedCollege != null &&
                                      selectedCollege!.isNotEmpty,
                                  onTap: () {
                                    showCollegeSelectorSheet(
                                      context: context,
                                      controller: webinarController,
                                      selectedCollege: selectedCollege,
                                      onSelected: (col) {
                                        setModalState(() {
                                          selectedCollege = col;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: WebinarDropdownSelector(
                                  icon: Icons.menu_book_outlined,
                                  text: selectedCourse != null &&
                                          selectedCourse!.isNotEmpty
                                      ? selectedCourse!
                                      : "Course / Degree",
                                  isSelected: selectedCourse != null &&
                                      selectedCourse!.isNotEmpty,
                                  onTap: () {
                                    showSimplePickerSheet(
                                      context: context,
                                      title: "Select Course / Degree",
                                      options: courseOptions,
                                      selectedValue: selectedCourse,
                                      onSelected: (course) {
                                        setModalState(() {
                                          selectedCourse = course;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Row 2: Year of Study & Role
                          Row(
                            children: [
                              Expanded(
                                child: WebinarDropdownSelector(
                                  icon: Icons.calendar_today_outlined,
                                  text: selectedYearOfStudy != null &&
                                          selectedYearOfStudy!.isNotEmpty
                                      ? selectedYearOfStudy!
                                      : "Year of Study *",
                                  isSelected: selectedYearOfStudy != null &&
                                      selectedYearOfStudy!.isNotEmpty,
                                  onTap: () {
                                    showSimplePickerSheet(
                                      context: context,
                                      title: "Select Year of Study",
                                      options: yearOfStudyOptions,
                                      selectedValue: selectedYearOfStudy,
                                      onSelected: (year) {
                                        setModalState(() {
                                          selectedYearOfStudy = year;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: WebinarDropdownSelector(
                                  icon: Icons.work_outline_rounded,
                                  text: selectedRole != null &&
                                          selectedRole!.isNotEmpty
                                      ? selectedRole!
                                      : "Role *",
                                  isSelected: selectedRole != null &&
                                      selectedRole!.isNotEmpty,
                                  onTap: () {
                                    showSimplePickerSheet(
                                      context: context,
                                      title: "Select Role",
                                      options: roleOptions,
                                      selectedValue: selectedRole,
                                      onSelected: (role) {
                                        setModalState(() {
                                          selectedRole = role;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          // 4. ADDITIONAL INFORMATION (FOR FREE WEBINAR)
                          if (!isPaid) ...[
                            const SizedBox(height: 20),
                            const WebinarSectionHeader(
                              icon: Icons.chat_bubble_outline_rounded,
                              title: "Additional Information (Optional)",
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F1E2E),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF1E3046),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: questionController,
                                maxLines: 3,
                                style: AppStyles.customTextStyle(
                                  size: 13.5,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Any question for the speaker?",
                                  hintStyle: AppStyles.customTextStyle(
                                    size: 13,
                                    color: const Color(0xFF64748B),
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(bottom: 36),
                                    child: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: Color(0xFF64748B),
                                      size: 18,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          // ACTION BUTTON: "Register Now" (Free) or "Proceed to Pay ₹..." (Paid)
                          Obx(() {
                            final isLoading = webinarController.registerLoading ||
                                webinarController.paymentCreating;
                            return InkWell(
                              onTap: isLoading
                                  ? null
                                  : () async {
                                      final name = fullNameController.text.trim();
                                      final email = emailController.text.trim();
                                      final mobile = mobileController.text
                                          .trim()
                                          .replaceAll(RegExp(r'\D'), '');

                                      if (name.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Please enter your full name",
                                        );
                                        return;
                                      }
                                      if (email.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Please enter your email address",
                                        );
                                        return;
                                      }
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(email)) {
                                        Fluttertoast.showToast(
                                          msg: "Please enter a valid email address",
                                        );
                                        return;
                                      }
                                      if (mobile.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Please enter your mobile number",
                                        );
                                        return;
                                      }
                                      if (mobile.length != 10) {
                                        Fluttertoast.showToast(
                                          msg: "Please enter a valid 10-digit mobile number",
                                        );
                                        return;
                                      }
                                      if (selectedCollege == null ||
                                          selectedCollege!.trim().isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Please select your College / University",
                                        );
                                        return;
                                      }
                                      if (selectedYearOfStudy == null ||
                                          selectedYearOfStudy!.trim().isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Please select your Year of Study",
                                        );
                                        return;
                                      }
                                      if (selectedRole == null ||
                                          selectedRole!.trim().isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Please select your Role",
                                        );
                                        return;
                                      }

                                      String effectiveCourse = selectedCourse ?? "";
                                      if (effectiveCourse == "Course / Degree") {
                                        effectiveCourse = "";
                                      }

                                      final effectiveStudentId = studentId != null &&
                                              studentId.isNotEmpty
                                          ? studentId
                                          : "6ac5d0d44d541dab863b33b1";

                                      final payload = {
                                        "webinarId": detail.sId ?? '',
                                        "studentId": effectiveStudentId,
                                        "fullName": name,
                                        "email": email,
                                        "mobile": mobile,
                                        "college": selectedCollege!,
                                        "course": effectiveCourse,
                                        "yearOfStudy": selectedYearOfStudy!,
                                        "role": selectedRole!,
                                        "question": questionController.text.trim(),
                                      };

                                      if (!isPaid) {
                                        Navigator.of(sheetCtx).pop();
                                        await onRegisterFree(payload, name, email);
                                      } else {
                                        Navigator.of(sheetCtx).pop();
                                        await onProceedToPay(payload, name, email);
                                      }
                                    },
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF5DFDCB),
                                      Color(0xFF00E5FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00E5FF)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 14,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFF071D22),
                                            ),
                                          ),
                                        )
                                      : (isPaid
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Proceed to Pay ₹${detail.amount ?? 0}",
                                                  style: AppStyles
                                                      .customTextStyle(
                                                    size: 15.5,
                                                    weight: FontWeight.w800,
                                                    color:
                                                        const Color(0xFF071D22),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(
                                                  Icons.arrow_forward_rounded,
                                                  color: Color(0xFF071D22),
                                                  size: 18,
                                                ),
                                              ],
                                            )
                                          : Text(
                                              "Register Now",
                                              style:
                                                  AppStyles.customTextStyle(
                                                size: 15.5,
                                                weight: FontWeight.w800,
                                                color:
                                                    const Color(0xFF071D22),
                                              ),
                                            )),
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 14),

                          // FOOTER BADGES / NOTE
                          if (!isPaid)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 13,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Your information is secure with us.",
                                  style: AppStyles.customTextStyle(
                                    size: 11.5,
                                    weight: FontWeight.w500,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            )
                          else
                            const WebinarPaymentTrustBadges(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
