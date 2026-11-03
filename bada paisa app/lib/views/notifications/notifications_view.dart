import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/constants/app_data.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  String _timeLabel(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hr ago';
    return DateFormat('dd MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Obx(
            () => controller.unreadCount == 0
                ? const SizedBox(width: 12)
                : TextButton(
                    onPressed: controller.markAllRead,
                    child: const Text('Mark all read'),
                  ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Obx(
        () => controller.notifications.isEmpty
            ? const _EmptyNotifications()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                itemCount: controller.notifications.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final item = controller.notifications[index];
                  return _NotificationCard(
                    item: item,
                    timeLabel: _timeLabel(item.createdAt),
                    onTap: () {
                      controller.markRead(item.id);
                      if (item.productId != null) {
                        Get.toNamed(
                          AppRoutes.applyLoan,
                          arguments: AppData.product(item.productId!),
                        );
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.timeLabel,
    required this.onTap,
  });

  final AppNotificationItem item;
  final String timeLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.isRead ? Colors.white : const Color(0xFFF0F7FD),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: item.isRead
                  ? AppColors.border
                  : AppColors.secondary.withValues(alpha: 0.22),
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.color, size: 24),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(item.title, style: AppTextStyles.title),
                        ),
                        if (!item.isRead)
                          Container(
                            margin: const EdgeInsets.only(top: 5, left: 6),
                            height: 8,
                            width: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: AppTextStyles.caption.copyWith(height: 1.45),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeLabel,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 92,
            width: 92,
            decoration: const BoxDecoration(
              color: AppColors.lightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.secondary,
              size: 42,
            ),
          ),
          const SizedBox(height: 18),
          Text('No notifications yet', style: AppTextStyles.h3),
          const SizedBox(height: 5),
          Text(
            'Your updates and offers will appear here.',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
