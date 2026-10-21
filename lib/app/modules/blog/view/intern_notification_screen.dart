import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/providers/notification_provider.dart';
import 'package:internsharks/app/modules/blog/controller/notification_controller.dart';
import 'package:internsharks/app/data/models/notification/notification_model.dart';

class InternNotificationScreen extends StatefulWidget {
  const InternNotificationScreen({super.key});

  @override
  State<InternNotificationScreen> createState() =>
      _InternNotificationScreenState();
}

class _InternNotificationScreenState extends State<InternNotificationScreen>
    with SingleTickerProviderStateMixin {
  late final NotificationController _controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<NotificationController>()) {
      _controller = Get.find<NotificationController>();
    } else {
      _controller = Get.put(
        NotificationController(NotificationProvider(client: Dio())),
        permanent: true,
      );
    }
  }

  /// Relative time label identical to the web app style (e.g. "8h ago", "7 Oct")
  String _formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return DateFormat('d MMM').format(date);
    } catch (_) {
      return '';
    }
  }

  /// Pick an icon based on the notification title / senderType
  IconData _pickIcon(NotificationModel n) {
    final title = (n.title ?? '').toLowerCase();
    final sender = (n.senderType ?? '').toLowerCase();
    if (title.contains('interview') || title.contains('interivew')) {
      return Icons.event_note_rounded;
    }
    if (title.contains('offer') || title.contains('placed')) {
      return Icons.card_giftcard_rounded;
    }
    if (title.contains('scheduled')) return Icons.schedule_rounded;
    if (sender.contains('recruiter')) return Icons.business_center_rounded;
    return Icons.notifications_rounded;
  }

  /// Accent colour based on senderType
  Color _accentColor(NotificationModel n) {
    final sender = (n.senderType ?? '').toLowerCase();
    if (sender.contains('recruiter')) return AppColors.primaryColor;
    if (sender.contains('university') || sender.contains('college')) {
      return AppColors.secondaryColor;
    }
    return AppColors.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: Obx(() {
          if (_controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 2,
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: AppColors.appBgColor,
            onRefresh: _controller.refreshNotifications,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(child: _buildHeader()),

                // Filter Tabs
                SliverToBoxAdapter(child: _buildFilterTabs()),

                // Notification List
                _buildNotificationList(),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        }),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.whiteColor,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Notifications',
        style: AppStyles.customTextStyle(
          size: 18,
          weight: FontWeight.w600,
          color: AppColors.whiteColor,
        ),
      ),
      actions: [
        Obx(() {
          final unread = _controller.unreadCount;
          if (unread == 0) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.4),
              ),
            ),
            child: Text(
              '$unread unread',
              style: AppStyles.customTextStyle(
                size: 11,
                weight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.12),
            AppColors.appBgColor.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay Updated',
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.whiteColor.withOpacity(0.6),
                  ),
                ),
                Text(
                  'Your Notifications',
                  style: AppStyles.customTextStyle(
                    size: 20,
                    weight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                  '${_controller.allNotifications.length} total · ${_controller.unreadCount} unread',
                  style: AppStyles.customTextStyle(
                    size: 12,
                    color: AppColors.whiteColor.withOpacity(0.45),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.primaryColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Obx(() {
      final selected = _controller.selectedFilter.value;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.contColor2.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.contBorderColor2),
          ),
          child: Row(
            children: [
              _FilterTab(
                label: 'All Notifications',
                isSelected: selected == 'all',
                onTap: () => _controller.setFilter('all'),
              ),
              _FilterTab(
                label: 'Unread',
                isSelected: selected == 'unread',
                badge: _controller.unreadCount,
                onTap: () => _controller.setFilter('unread'),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNotificationList() {
    return Obx(() {
      final list = _controller.filteredNotifications;

      if (list.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 56,
                  color: AppColors.lightColorText.withOpacity(0.25),
                ),
                const SizedBox(height: 12),
                Text(
                  _controller.selectedFilter.value == 'unread'
                      ? 'All caught up! No unread notifications.'
                      : 'No notifications yet.',
                  textAlign: TextAlign.center,
                  style: AppStyles.customTextStyle(
                    size: 14,
                    color: AppColors.lightColorText.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final notification = list[index];
              final isLast = index == list.length - 1;
              return _NotificationCard(
                notification: notification,
                timeLabel: _formatTime(notification.createdAt),
                icon: _pickIcon(notification),
                accentColor: _accentColor(notification),
                isLast: isLast,
              );
            },
            childCount: list.length,
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter Tab Widget
// ─────────────────────────────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int badge;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    this.badge = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: isSelected
                ? Border.all(color: AppColors.primaryColor.withOpacity(0.4))
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppStyles.customTextStyle(
                  size: 13,
                  weight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.lightColorText.withOpacity(0.6),
                ),
              ),
              if (badge > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badge',
                    style: AppStyles.customTextStyle(
                      size: 10,
                      weight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final String timeLabel;
  final IconData icon;
  final Color accentColor;
  final bool isLast;

  const _NotificationCard({
    required this.notification,
    required this.timeLabel,
    required this.icon,
    required this.accentColor,
    required this.isLast,
  });

  bool get isUnread => notification.isRead == false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
      decoration: BoxDecoration(
        // Slightly brighter background for unread items (like LinkedIn pattern)
        color: isUnread
            ? AppColors.primaryColor.withOpacity(0.06)
            : AppColors.contColor2.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread
              ? AppColors.primaryColor.withOpacity(0.25)
              : AppColors.contBorderColor2,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Unread indicator dot (LinkedIn style) ──
            Padding(
              padding: const EdgeInsets.only(top: 18, right: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnread
                      ? AppColors.primaryColor
                      : Colors.transparent,
                ),
              ),
            ),

            // ── Icon container ──
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withOpacity(0.25),
                ),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),

            const SizedBox(width: 12),

            // ── Text content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title ?? '',
                          style: AppStyles.customTextStyle(
                            size: 14,
                            weight: isUnread
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isUnread
                                ? AppColors.whiteColor
                                : AppColors.whiteColor.withOpacity(0.85),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeLabel,
                        style: AppStyles.customTextStyle(
                          size: 11,
                          color: AppColors.lightColorText.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message ?? '',
                    style: AppStyles.customTextStyle(
                      size: 12,
                      color: AppColors.lightColorText.withOpacity(0.7),
                      lineSpace: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Sender chip
                  if ((notification.senderType ?? '').isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: accentColor.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        notification.senderType!,
                        style: AppStyles.customTextStyle(
                          size: 10,
                          weight: FontWeight.w500,
                          color: accentColor.withOpacity(0.9),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
