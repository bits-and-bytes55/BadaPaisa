import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/utils/app_snackbar.dart';
import '../../controllers/main_controller.dart';
import '../../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Header(controller: controller),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                children: [
                  _MenuGroup(
                    items: [
                      _MenuItem(
                        Icons.description_outlined,
                        'My Applications',
                        () => main.changeTab(3),
                      ),
                      _MenuItem(
                        Icons.calculate_outlined,
                        'EMI Calculator',
                        () => main.changeTab(2),
                      ),
                      _MenuItem(
                        Icons.account_balance_wallet_outlined,
                        'Loan Products',
                        () => main.changeTab(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuGroup(
                    items: [
                      _MenuItem(
                        Icons.notifications_none_rounded,
                        'Test Notification',
                        controller.testNotification,
                      ),
                      _MenuItem(
                        Icons.headset_mic_outlined,
                        'Help & Support',
                        () => AppSnackbar.info(
                          'Support',
                          'Call us at 1800-123-4567 (toll free)',
                        ),
                      ),
                      _MenuItem(
                        Icons.privacy_tip_outlined,
                        'Terms & Privacy Policy',
                        () => AppSnackbar.info(
                          'Privacy',
                          'Your data is 100% safe and confidential.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuGroup(
                    items: [
                      _MenuItem(
                        Icons.logout_rounded,
                        'Logout',
                        controller.logout,
                        color: AppColors.error,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'BadaPaisa.com  •  v1.0.0',
                    style: AppTextStyles.caption,
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

class _Header extends StatelessWidget {
  const _Header({required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.bannerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Obx(
            () => Column(
              children: [
                Text(
                  'Profile',
                  style: AppTextStyles.h3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 86,
                  width: 86,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 4,
                    ),
                  ),
                  child: Text(
                    controller.initials,
                    style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  controller.name.value,
                  style: AppTextStyles.h3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.phone.value,
                  style: AppTextStyles.body.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  const _MenuItem(this.icon, this.title, this.onTap, {this.color});
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final color = item.color ?? AppColors.textPrimary;
          return Column(
            children: [
              ListTile(
                onTap: item.onTap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: (item.color ?? AppColors.secondary).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color ?? AppColors.secondary,
                    size: 20,
                  ),
                ),
                title: Text(
                  item.title,
                  style: AppTextStyles.bodyDark.copyWith(color: color),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
              ),
              if (i != items.length - 1)
                const Divider(height: 1, indent: 68, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }
}
