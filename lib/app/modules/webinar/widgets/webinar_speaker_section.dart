import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';

/// ---------------------------------------------------------------------------
/// SPEAKER SECTION
/// ---------------------------------------------------------------------------
class WebinarSpeakerSection extends StatelessWidget {
  final SpeakerData speaker;

  const WebinarSpeakerSection({super.key, required this.speaker});

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Fluttertoast.showToast(msg: "Could not launch: $url");
      }
    } catch (_) {
      Fluttertoast.showToast(msg: "Invalid profile URL");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.person_outline_rounded,
              size: 18,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              "Speaker",
              style: AppStyles.customTextStyle(
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF111D28),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF1E2E42),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with cyan ring
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 2.2,
                  ),
                ),
                child: ClipOval(
                  child: speaker.profileImage != null &&
                          speaker.profileImage!.isNotEmpty
                      ? Image.network(
                          speaker.profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) =>
                              _buildSpeakerAvatarFallback(speaker.name),
                        )
                      : _buildSpeakerAvatarFallback(speaker.name),
                ),
              ),

              const SizedBox(height: 12),

              // Name
              Text(
                speaker.name ?? "Speaker",
                style: AppStyles.customTextStyle(
                  size: 16.5,
                  weight: FontWeight.w800,
                  color: AppColors.whiteColor,
                ),
              ),

              const SizedBox(height: 4),

              // Designation
              Text(
                speaker.designation ?? "Domain Specialist",
                textAlign: TextAlign.center,
                style: AppStyles.customTextStyle(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),

              // Company
              if (speaker.company != null &&
                  speaker.company!.trim().isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  speaker.company!.trim(),
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],

              // Bio
              if (speaker.bio != null && speaker.bio!.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  speaker.bio!.trim(),
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 12.5,
                    color: const Color(0xFFCBD5E1),
                    lineSpace: 1.4,
                  ),
                ),
              ],

              // Profile / LinkedIn Button
              if (speaker.profileUrl != null &&
                  speaker.profileUrl!.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                InkWell(
                  onTap: () => _openUrl(speaker.profileUrl!.trim()),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0077B5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.link_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "View Profile",
                          style: AppStyles.customTextStyle(
                            size: 13,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpeakerAvatarFallback(String? name) {
    final initial = (name != null && name.trim().isNotEmpty)
        ? name.trim()[0].toUpperCase()
        : 'S';

    return Container(
      color: const Color(0xFF162534),
      child: Center(
        child: Text(
          initial,
          style: AppStyles.customTextStyle(
            size: 28,
            weight: FontWeight.w800,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
