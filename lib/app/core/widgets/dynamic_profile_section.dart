import 'package:flutter/material.dart';
import 'package:internsharks/app/core/widgets/profile_widgets.dart';
import 'package:internsharks/app/core/widgets/item_card_widget.dart';
import 'package:internsharks/app/core/widgets/experience_card.dart';

class DynamicProfileSection extends StatelessWidget {
  final String emoji;
  final String title;
  final List<Map<String, dynamic>> items;
  final VoidCallback onAdd;
  final Function(int index) onEdit;
  final Function(int index)? onDelete;

  /// card title key
  final String titleKey;

  /// card subtitle key
  final String subtitleKey;

  /// optional third line
  final String? metaKey;

  /// if true uses ExperienceCard
  final bool useExperienceCard;

  const DynamicProfileSection({
    super.key,
    required this.emoji,
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onEdit,
    this.onDelete,
    required this.titleKey,
    required this.subtitleKey,
    this.metaKey,
    this.useExperienceCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileWidgets.sectionHeader(emoji, title, onAdd: onAdd),

        if (items.isNotEmpty)
          ProfileWidgets.infoCard(
            Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                if (useExperienceCard) {
                  return Column(
                    children: [
                      ExperienceCard(
                        role: item[titleKey] ?? '',
                        company: item[subtitleKey] ?? '',
                        meta: metaKey != null ? item[metaKey] ?? '' : '',
                        onEdit: () => onEdit(index),
                        onDelete: onDelete != null ? onDelete!(index) : null,
                      ),
                      if (index < items.length - 1)
                        const Divider(color: Colors.white12),
                    ],
                  );
                }

                return Column(
                  children: [
                    ItemCard(
                      title: item[titleKey] ?? '',
                      subtitle: metaKey != null
                          ? "${item[subtitleKey] ?? ''}\n${item[metaKey] ?? ''}"
                          : item[subtitleKey] ?? '',
                      onEdit: () => onEdit(index),
                    ),
                    if (index < items.length - 1)
                      const Divider(color: Colors.white12),
                  ],
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 20),
      ],
    );
  }
}
