import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/config/theme/app_theme.dart';
import '../app/routes/app_routes.dart';
import '../app/services/notification_service.dart';
import '../app/services/storage_service.dart';

class ProfileController extends GetxController {
  final RxString name = ''.obs;
  final RxString phone = ''.obs;

  String get initials {
    final parts = name.value
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'U';
    return parts.take(2).map((e) => e[0].toUpperCase()).join();
  }

  @override
  void onInit() {
    super.onInit();
    refreshUser();
  }

  void refreshUser() {
    name.value = StorageService.to.userName ?? 'BadaPaisa User';
    final p = StorageService.to.phone ?? '';
    phone.value = p.length == 10
        ? '+91 ${p.substring(0, 5)} ${p.substring(5)}'
        : (p.isEmpty ? '-' : p);
  }

  void testNotification() => NotificationService.to.show(
    title: 'BadaPaisa',
    body: 'Notifications are working! You will receive loan updates here.',
  );

  void logout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Logout', style: AppTextStyles.h3),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await StorageService.to.logout();
              Get.offAllNamed(AppRoutes.login);
            },
            child: Text(
              'Logout',
              style: AppTextStyles.label.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
