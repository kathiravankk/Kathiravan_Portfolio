import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

import '../utils/asset_images.dart' show AssetImages;

class ProfileWidgets {

  static List<String> parseSkills(String raw) {
    try {
      String s = raw;
      for (int i = 0; i < 6; i++) {
        if ((s.startsWith('[') || s.startsWith('"')) && s.length > 2) {
          try {
            final decoded = json.decode(s);
            if (decoded is List) {
              return decoded.expand((e) => parseSkills(e.toString())).toList();
            }
            if (decoded is String) { s = decoded; continue; }
          } catch (_) {}
          s = s.replaceAll(RegExp(r'^[\["]+|[\]"]+$'), '').trim();
        } else {
          break;
        }
      }
      return s
          .split(',')
          .map((e) => e.trim().replaceAll(r'\"', '').replaceAll('"', ''))
          .where((e) => e.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

// Shared UI ──────────────────────────────────────────────────────────────────

  static Widget sectionHeader(String emoji, String title,
      {VoidCallback? onAdd, String addLabel = '+ Add'}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text(emoji,
                style: AppStyles.customTextStyle(size: 14, weight: FontWeight.w700)),
            const SizedBox(width: 8),
            Text(title,
                style: AppStyles.customTextStyle(
                    size: 16, color: AppColors.secondaryColor, weight: FontWeight.w700)),
          ]),
          if (onAdd != null)
            GestureDetector(
              onTap: onAdd,
              child: Text(addLabel,
                  style: AppStyles.customTextStyle(
                      size: 12, color: AppColors.secondaryColor, weight: FontWeight.w400)),
            ),
        ],
      ),
    );
  }

  static Widget infoCard(Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: AppColors.fieldBgColor,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: AppColors.fieldBorderColor),
    ),
    child: child,
  );

  static Widget chip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.fieldBorderColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.customTextStyle(
                fontFamily: 'Roboto',
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              color: AppColors.fieldBorderColor,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  static Widget bsDropdown({
    required String? value,
    String? hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final validValue = items.contains(value) ? value : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.fieldBorderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: validValue, // ✅ FIX HERE
          hint: Text(
            hint ?? 'Select',
            style: AppStyles.customTextStyle(
              fontFamily: 'Roboto',
              color: AppColors.whiteColor,
              size: 14,
              weight: FontWeight.w500,
            ),
          ),
          isExpanded: true,
          dropdownColor: AppColors.fieldBgColor,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          items: items
              .toSet() // ✅ prevent duplicates
              .map((e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: AppStyles.customTextStyle(
                fontFamily: 'Roboto',
                color: AppColors.whiteColor,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  static void showBottomSheet({
    required BuildContext context,
    required String title,
    required Widget content,
    required VoidCallback onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.fieldBgColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: AppStyles.customTextStyle(
                          size: 16, color: AppColors.whiteColor, weight: FontWeight.w700)),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: AppColors.failTextColor, size: 25)),
                ],
              ),
              const SizedBox(height: 15),
              content,
              const SizedBox(height: 20),
              CustomButtonWidget(buttonFunction: onSave, buttonText: 'Save Changes'),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  static Widget creditContainer({ int? creditCount, VoidCallback? viewFunc}) {
    return GestureDetector(
      onTap: viewFunc,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.creditContColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryColor,
              blurRadius: 13,
              spreadRadius: -2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          spacing: 10,
          children: [
            Image.asset(
              AssetImages.creditsIconNew,
              height: 22,
              width: 22,
            ),
            Text(
              (creditCount ?? 0)
                  .toString(),
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}