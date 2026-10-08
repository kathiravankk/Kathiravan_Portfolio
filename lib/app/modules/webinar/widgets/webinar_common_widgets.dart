import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';
import 'package:internsharks/app/modules/webinar/controller/webinar_controller.dart';
export 'webinar_3d_illustrations.dart';

/// ---------------------------------------------------------------------------
/// WEBINAR DATE & TIME UTILITY HELPERS
/// ---------------------------------------------------------------------------
class WebinarDateUtils {
  static String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "Upcoming";
    try {
      final parsed = DateTime.tryParse(rawDate);
      if (parsed != null) {
        return DateFormat("dd MMM yyyy").format(parsed);
      }
    } catch (_) {}
    return rawDate;
  }

  static String formatSingleTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "";
    try {
      final clean = timeStr.trim();
      final parts = clean.split(":");
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        final period = hour >= 12 ? "PM" : "AM";
        int displayHour = hour % 12;
        if (displayHour == 0) displayHour = 12;
        final minuteStr = minute.toString().padLeft(2, '0');
        return "$displayHour:$minuteStr $period";
      }
    } catch (_) {}
    return timeStr;
  }

  static String formatTimeRange(String? start, String? end) {
    final s = formatSingleTime(start);
    final e = formatSingleTime(end);

    if (s.isNotEmpty && e.isNotEmpty) {
      return "$s – $e";
    } else if (s.isNotEmpty) {
      return s;
    }
    return "Time TBA";
  }

  static String formatWebinarDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "Upcoming";
    try {
      final parsed = DateTime.tryParse(rawDate);
      if (parsed != null) {
        return DateFormat("dd MMM yyyy").format(parsed);
      }
    } catch (_) {}
    return rawDate;
  }

  static String formatWebinarTime(WebinarDetailData detail) {
    final start = detail.startTime ?? '';
    final end = detail.endTime ?? '';
    final tz = detail.timezone ?? 'IST';
    if (start.isNotEmpty && end.isNotEmpty) {
      return "$start – $end $tz";
    } else if (start.isNotEmpty) {
      return "$start $tz";
    }
    return "11:00 AM – 12:30 PM IST";
  }

  static int getJoinBeforeMinutes(WebinarDetailData detail) {
    final val = detail.join?.joinBeforeMinutes ?? detail.joinBeforeMinutes;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 10;
    return 10;
  }

  static DateTime? getWebinarJoinStartTime(WebinarDetailData detail) {
    if (detail.join?.joinAt != null && detail.join!.joinAt!.trim().isNotEmpty) {
      final parsed = DateTime.tryParse(detail.join!.joinAt!.trim());
      if (parsed != null) return parsed.toLocal();
    }

    if (detail.webinarDate != null && detail.webinarDate!.isNotEmpty) {
      DateTime? baseDate = DateTime.tryParse(detail.webinarDate!)?.toLocal();
      if (baseDate == null) {
        const formats = [
          'dd-MM-yyyy',
          'dd/MM/yyyy',
          'yyyy/MM/dd',
          'yyyy-MM-dd',
          'dd MMM yyyy',
          'd MMM yyyy',
        ];
        for (final f in formats) {
          try {
            baseDate = DateFormat(f).parseLoose(detail.webinarDate!);
            break;
          } catch (_) {}
        }
      }

      if (baseDate != null) {
        int hour = 0;
        int minute = 0;
        if (detail.startTime != null && detail.startTime!.contains(':')) {
          final parts = detail.startTime!.split(':');
          hour = int.tryParse(parts[0]) ?? 0;
          minute = int.tryParse(parts[1]) ?? 0;
        }
        final webinarStart = DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          hour,
          minute,
        );
        final int minutesBefore = getJoinBeforeMinutes(detail);
        return webinarStart.subtract(Duration(minutes: minutesBefore));
      }
    }
    return null;
  }

  static bool canJoinWebinar(WebinarDetailData detail) {
    if ((detail.status ?? '').toLowerCase() == 'completed') {
      return false;
    }
    if (detail.join?.canJoin == true || detail.join?.joinTimeReached == true) {
      return true;
    }
    final joinStartTime = getWebinarJoinStartTime(detail);
    if (joinStartTime != null) {
      return DateTime.now().isAfter(joinStartTime) ||
          DateTime.now().isAtSameMomentAs(joinStartTime);
    }
    return false;
  }
}

/// ---------------------------------------------------------------------------
/// SECTION HEADER & FORM FIELD COMPONENTS
/// ---------------------------------------------------------------------------
class WebinarSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const WebinarSectionHeader({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF00E5FF)),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppStyles.customTextStyle(
            size: 13.5,
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class WebinarFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;

  const WebinarFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3046), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppStyles.customTextStyle(
          size: 13.5,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyles.customTextStyle(
            size: 12.5,
            color: const Color(0xFF64748B),
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class WebinarDropdownSelector extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const WebinarDropdownSelector({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1E2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E3046), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF64748B), size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.customTextStyle(
                  size: 12.5,
                  weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class WebinarBadgePill extends StatelessWidget {
  final Widget child;

  const WebinarBadgePill({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1E2E),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF1E3046),
          width: 0.8,
        ),
      ),
      child: child,
    );
  }
}

class WebinarPaymentTrustBadges extends StatelessWidget {
  const WebinarPaymentTrustBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 13,
              color: Color(0xFF22D3EE),
            ),
            const SizedBox(width: 6),
            Text(
              "Secure payment. Your data is safe.",
              style: AppStyles.customTextStyle(
                size: 11,
                weight: FontWeight.w500,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            WebinarBadgePill(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.flash_on_rounded, size: 12, color: Color(0xFF38BDF8)),
                  const SizedBox(width: 3),
                  Text(
                    "Razorpay",
                    style: AppStyles.customTextStyle(
                      size: 10,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            WebinarBadgePill(
              child: Text(
                "UPI",
                style: AppStyles.customTextStyle(
                  size: 10,
                  weight: FontWeight.w800,
                  color: const Color(0xFF10B981),
                ),
              ),
            ),
            const WebinarBadgePill(
              child: Text(
                "VISA",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF60A5FA),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            WebinarBadgePill(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEB001B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(-3, 0),
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF79E1B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WebinarBadgePill(
              child: Text(
                "RuPay",
                style: AppStyles.customTextStyle(
                  size: 10,
                  weight: FontWeight.w800,
                  color: const Color(0xFF38BDF8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// SELECTOR BOTTOM SHEETS & DIALOGS
/// ---------------------------------------------------------------------------
Future<void> showCollegeSelectorSheet({
  required BuildContext context,
  required WebinarController controller,
  required String? selectedCollege,
  required ValueChanged<String> onSelected,
}) async {
  final colleges = await controller.fetchColleges();
  if (!context.mounted) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      String searchQuery = "";
      return StatefulBuilder(
        builder: (ctx, setSheetState) {
          final filtered = colleges
              .where((c) => c.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Color(0xFF0F1E2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(
                top: BorderSide(color: Color(0xFF1E3046), width: 1.5),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select College / University",
                        style: AppStyles.customTextStyle(
                          size: 16,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(sheetCtx),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF142436),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF22374E)),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setSheetState(() {
                          searchQuery = val.trim();
                        });
                      },
                      style: const TextStyle(color: Colors.white, fontSize: 13.5),
                      decoration: const InputDecoration(
                        hintText: "Search college or university...",
                        hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 19),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            "No colleges found",
                            style: AppStyles.customTextStyle(
                              size: 13,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const Divider(
                            height: 1,
                            color: Color(0xFF162536),
                          ),
                          itemBuilder: (ctx, idx) {
                            final collegeName = filtered[idx];
                            final isSelected = collegeName == selectedCollege;
                            return ListTile(
                              onTap: () {
                                onSelected(collegeName);
                                Navigator.pop(sheetCtx);
                              },
                              title: Text(
                                collegeName,
                                style: AppStyles.customTextStyle(
                                  size: 13.5,
                                  weight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                  color: isSelected ? const Color(0xFF00E5FF) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF00E5FF),
                                      size: 18,
                                    )
                                  : null,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void showSimplePickerSheet({
  required BuildContext context,
  required String title,
  required List<String> options,
  required String? selectedValue,
  required ValueChanged<String> onSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F1E2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: Color(0xFF1E3046), width: 1.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppStyles.customTextStyle(
                      size: 16,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(sheetCtx),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  color: Color(0xFF162536),
                ),
                itemBuilder: (ctx, idx) {
                  final item = options[idx];
                  final isSelected = item == selectedValue;
                  return ListTile(
                    onTap: () {
                      onSelected(item);
                      Navigator.pop(sheetCtx);
                    },
                    title: Text(
                      item,
                      style: AppStyles.customTextStyle(
                        size: 14,
                        weight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFF00E5FF)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF00E5FF),
                            size: 18,
                          )
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

Future<String?> promptWebinarMobileNumber(BuildContext context) async {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: const Color(0xFF0D1824),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1E2E42)),
        ),
        title: Text(
          "Enter Mobile Number",
          style: AppStyles.customTextStyle(
            size: 17,
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please provide your 10-digit mobile number to verify and get the webinar link.",
              style: AppStyles.customTextStyle(
                size: 13,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "10-digit Mobile Number",
                hintStyle: const TextStyle(color: Color(0xFF64748B)),
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF00E5FF)),
                filled: true,
                fillColor: const Color(0xFF071420),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1E3046)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              foregroundColor: const Color(0xFF071D22),
            ),
            onPressed: () {
              final text = controller.text.trim().replaceAll(RegExp(r'\D'), '');
              if (text.length == 10) {
                Navigator.pop(ctx, text);
              } else {
                Fluttertoast.showToast(msg: "Please enter valid 10 digits");
              }
            },
            child: const Text("Continue"),
          ),
        ],
      );
    },
  );
}
