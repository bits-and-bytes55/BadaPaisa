import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final IconData icon;
  final Color color;
  final String? productId;
  final bool isRead;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.icon,
    required this.color,
    this.productId,
    this.isRead = false,
  });

  AppNotificationItem copyWith({bool? isRead}) => AppNotificationItem(
    id: id,
    title: title,
    message: message,
    createdAt: createdAt,
    icon: icon,
    color: color,
    productId: productId,
    isRead: isRead ?? this.isRead,
  );
}

class NotificationsController extends GetxController {
  final RxList<AppNotificationItem> notifications = <AppNotificationItem>[].obs;

  int get unreadCount => notifications.where((item) => !item.isRead).length;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    notifications.assignAll([
      AppNotificationItem(
        id: 'home-offer',
        title: 'Home loan offer for you',
        message:
            'Interest rates start at 6.90%* p.a. Apply now for quick approval.',
        createdAt: now.subtract(const Duration(minutes: 18)),
        icon: Icons.home_rounded,
        color: const Color(0xFF2BB673),
        productId: 'home',
      ),
      AppNotificationItem(
        id: 'quick-apply',
        title: 'Your loan journey is now easier',
        message:
            'Complete one simple 5-step application and track it from the app.',
        createdAt: now.subtract(const Duration(hours: 5)),
        icon: Icons.bolt_rounded,
        color: const Color(0xFFF59E0B),
      ),
      AppNotificationItem(
        id: 'security',
        title: 'Your information stays secure',
        message: 'Never share your OTP or account details with anyone.',
        createdAt: now.subtract(const Duration(days: 1)),
        icon: Icons.verified_user_rounded,
        color: const Color(0xFF1C7CC0),
        isRead: true,
      ),
    ]);
  }

  void markRead(String id) {
    final index = notifications.indexWhere((item) => item.id == id);
    if (index == -1 || notifications[index].isRead) return;
    notifications[index] = notifications[index].copyWith(isRead: true);
  }

  void markAllRead() {
    notifications.assignAll(
      notifications.map((item) => item.copyWith(isRead: true)),
    );
  }
}
