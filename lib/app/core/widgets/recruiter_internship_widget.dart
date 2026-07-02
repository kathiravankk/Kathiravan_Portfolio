import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/account/certification_model.dart';
import 'package:internsharks/app/data/models/account/resume_analyze_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_student_profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  Color get _bg {
    switch (status.toLowerCase()) {
      case 'selected':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'applied':
      default:
        return const Color(0xFF00C896);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _bg.withValues(alpha: 0.2),
        border: Border.all(color: _bg),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        capitalize(status),
        style: AppStyles.customTextStyle(
          size: 12,
          color: _bg,
          weight: FontWeight.w600,
        ),
      ),
    );
  }

  String capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}

// ─────────────────────────────────────────────────────────────────────────────
// Accept / Reject strip
// ─────────────────────────────────────────────────────────────────────────────
class ActionStrip extends StatelessWidget {
  const ActionStrip({super.key, required this.applicant, required this.onAccept, required this.onReject});

  final InternStudentProfileModel applicant;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final isAccepted = applicant.applicationStatus!.toLowerCase() == 'accepted';
    final isRejected = applicant.applicationStatus!.toLowerCase() == 'rejected';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16,0, 16, 16),
      child: Row(
        spacing: 12,
        children: [
          // Accept
          Expanded(
            child: StripButton(
              label: "Accept",
              icon: Icons.check_rounded,
              background: isAccepted
                  ? Colors.green
                  : Colors.green.withValues(alpha: 0.5),
              textColor: Colors.white,
              onTap: onAccept,
            ),
          ),

          // Reject
          Expanded(
            child: StripButton(
              label: "Reject",
              icon: Icons.close_rounded,
              background: isRejected
                  ? Colors.red
                  : Colors.red.withValues(alpha: 0.5),
              textColor: Colors.white,
              onTap: onReject,
            ),
          ),
        ],
      ),
    );
  }
}

class StripButton extends StatelessWidget {
  const StripButton({super.key,
    required this.label,
    required this.icon,
    required this.background,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            Icon(icon, size: 18, color: textColor),
            Text(
              label,
              style: AppStyles.customTextStyle(
                size: 15,
                color: textColor,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile banner (gradient bg + avatar + tech stack icons)
// ─────────────────────────────────────────────────────────────────────────────
class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key, required this.student});

  final InternStudentProfileModel student;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2137), Color(0xFF1A3A2A)],
        ),
      ),
      child: Stack(
        children: [
          // Tech icons top-right
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              spacing: 6,
              children: [
                TechIcon(color: const Color(0xFF61DAFB), label: "⚛"),
                TechIcon(color: const Color(0xFF8CC84B), label: "JS"),
              ],
            ),
          ),

          // Avatar bottom-left
          Positioned(
            bottom: 12,
            left: 16,
            child: Avatar(imageUrl: student.studProfile, radius: 40),
          ),
        ],
      ),
    );
  }
}

class TechIcon extends StatelessWidget {
  const TechIcon({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.imageUrl, required this.radius});

  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryColor, width: 2.5),
        color: AppColors.primaryColor.withValues(alpha: 0.12),
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder(),
        )
            : placeholder(),
      ),
    );
  }

  Widget placeholder() =>
      Icon(CupertinoIcons.person_fill, color: AppColors.primaryColor, size: 36);
}

class IdentityCard extends StatelessWidget {
  const IdentityCard({super.key, required this.student});

  final InternStudentProfileModel student;

  @override
  Widget build(BuildContext context) {
    return CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          // Name + role
          Text(
            student.studName ?? "—",
            style: AppStyles.customTextStyle(
              size: 22,
              color: AppColors.whiteColor,
              weight: FontWeight.w700,
            ),
          ),
          Text(
            //student.role ??
            "Student",
            style: AppStyles.customTextStyle(
              size: 14,
              color: AppColors.secondaryColor,
              weight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 2),

          // Email + Phone
          Row(
            children: [
              Expanded(
                child: ContactItem(
                  icon: Icons.email_outlined,
                  label: student.studEmail ?? "—",
                ),
              ),
              Expanded(
                child: ContactItem(
                  icon: Icons.phone_outlined,
                  label: student.studMobileNo ?? "—",
                ),
              ),
            ],
          ),

          Row(
            spacing: 20,
            children: [
              if ((student.linkedIn ?? "").isNotEmpty)
                SocialItem(
                  icon: Icons.link_rounded,
                  label: "LinkedIn",
                  url: student.linkedIn!,
                ),
              if ((student.github ?? "").isNotEmpty)
                SocialItem(
                  icon: Icons.code_rounded,
                  label: "GitHub",
                  url: student.github!,
                ),
            ],
          ),

          // Location
          if ((student.location ?? "").isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                const Icon(
                  CupertinoIcons.location_solid,
                  size: 14,
                  color: AppColors.greyTextColor,
                ),
                Text(
                  student.location!,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    color: AppColors.greyTextColor,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  const ContactItem({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        Icon(icon, size: 14, color: AppColors.greyTextColor),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: 12,
              color: AppColors.greyTextColor,
              weight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class SocialItem extends StatelessWidget {
  const SocialItem({super.key,
    required this.icon,
    required this.label,
    required this.url,
  });

  final IconData icon;
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.tryParse(url);
        if (uri != null) await launchUrl(uri);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryColor),
          Text(
            label,
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.primaryColor,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkExperienceCard extends StatelessWidget {
  const WorkExperienceCard({super.key, required this.student});

  final InternStudentProfileModel student;

  @override
  Widget build(BuildContext context) {
    final experiences = student.experience ?? [];

    return SectionCard(
      icon: CupertinoIcons.briefcase_fill,
      iconColor: const Color(0xFF4A90E2),
      title: "WORK EXPERIENCE",
      child: experiences.isEmpty
          ? const BodyText("—")
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: experiences
            .map((exp) => WorkExpItem(exp: exp))
            .toList(),
      ),
    );
  }
}

class WorkExpItem extends StatelessWidget {
  const WorkExpItem({super.key, required this.exp});

  final ExperienceData exp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                exp.role ?? "—",
                style: AppStyles.customTextStyle(
                  size: 13,
                  color: AppColors.whiteColor,
                  weight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              formatDateRange(exp.duration, exp.duration),
              style: AppStyles.customTextStyle(
                size: 10,
                color: AppColors.secondaryColor,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          exp.company ?? "—",
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.secondaryColor,
            weight: FontWeight.w500,
          ),
        ),
        if ((exp.description ?? "").isNotEmpty)
          Text(
            exp.description!,
            style: AppStyles.customTextStyle(
              size: 11,
              color: AppColors.greyTextColor,
              weight: FontWeight.w400,
              lineSpace: 1.4,
            ),
          ),
      ],
    );
  }

  String formatDateRange(String? start, String? end) {
    if (start == null && end == null) return "";
    final s = fmt(start);
    final e = end == null || end.isEmpty ? "Present" : fmt(end);
    return "$s - $e";
  }

  String fmt(String? iso) {
    if (iso == null || iso.isEmpty) return "";
    try {
      final dt = DateTime.parse(iso);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return "${months[dt.month - 1]} ${dt.year}";
    } catch (_) {
      return iso;
    }
  }
}

class CertificationsCard extends StatelessWidget {
  const CertificationsCard({super.key, required this.student});

  final InternStudentProfileModel student;

  @override
  Widget build(BuildContext context) {
    final certs = student.studentCertificate ?? [];

    return SectionCard(
      icon: Icons.workspace_premium_rounded,
      iconColor: const Color(0xFFFF6B6B),
      title: "CERTIFICATIONS",
      child: certs.isEmpty
          ? const BodyText("—")
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: certs
            .map((c) => CertItem(cert: c))
            .toList(),
      ),
    );
  }
}

class CertItem extends StatelessWidget {
  const CertItem({super.key, required this.cert});

  final Certification cert;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(
          cert.name ?? "—",
          style: AppStyles.customTextStyle(
            size: 12,
            color: AppColors.primaryColor,
            weight: FontWeight.w600,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                cert.issuer ?? "—",
                style: AppStyles.customTextStyle(
                  size: 11,
                  color: AppColors.greyTextColor,
                  weight: FontWeight.w400,
                ),
              ),
            ),
            // if ((cert.date ?? "").isNotEmpty)
            //   Text(
            //     _fmt(cert.date),
            //     style: AppStyles.customTextStyle(
            //       size: 10,
            //       color: AppColors.greyTextColor,
            //       weight: FontWeight.w400,
            //     ),
            //   ),
          ],
        ),
      ],
    );
  }

  String fmt(String? iso) {
    if (iso == null || iso.isEmpty) return "";
    try {
      final dt = DateTime.parse(iso);
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year.toString().substring(2)}";
    } catch (_) {
      return iso ?? "";
    }
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.student, required this.viewFunc, required this.downloadFunc});

  final InternStudentProfileModel student;
  final VoidCallback viewFunc;
  final VoidCallback downloadFunc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.fieldBorderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomBarItem(
            icon: CupertinoIcons.heart,
            label: "Like",
            onTap: () {
              // controller.likeApplicant(applicant.id);
            },
          ),
          BottomBarItem(
            icon: CupertinoIcons.eye,
            label: "View",
            onTap: viewFunc,
          ),
          BottomBarItem(
            icon: CupertinoIcons.arrow_down_to_line,
            label: "Download",
            onTap: downloadFunc,
          ),
        ],
      ),
    );
  }
}

class BottomBarItem extends StatelessWidget {
  const BottomBarItem({super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(icon, color: AppColors.whiteColor, size: 22),
            Text(
              label,
              style: AppStyles.customTextStyle(
                size: 10,
                color: AppColors.greyTextColor,
                weight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TwoColRow extends StatelessWidget {
  const TwoColRow({super.key, required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Expanded(child: left),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class CardShell extends StatelessWidget {
  const CardShell({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: child,
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
    this.fullWidth = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          // Header
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Icon(icon, size: 15, color: iconColor),
              Flexible(
                child: Text(
                  title,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.whiteColor,
                    weight: FontWeight.w700,
                    lineSpace: 0.8,
                  ),
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class BodyText extends StatelessWidget {
  const BodyText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty ? "—" : text,
      style: AppStyles.customTextStyle(
        size: 12,
        color: AppColors.greyTextColor,
        weight: FontWeight.w400,
        lineSpace: 1.5,
      ),
    );
  }
}