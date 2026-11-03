import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/theme/app_theme.dart';

class AppSnackbar {
  AppSnackbar._();

  static void _show(String title, String message, Color color, IconData icon) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      icon: Icon(icon, color: Colors.white),
      duration: const Duration(seconds: 3),
      titleText: Text(
        title,
        style: AppTextStyles.title.copyWith(color: Colors.white),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.caption.copyWith(color: Colors.white),
      ),
    );
  }

  static void success(String title, String message) =>
      _show(title, message, AppColors.success, Icons.check_circle_rounded);

  static void error(String title, String message) =>
      _show(title, message, AppColors.error, Icons.error_rounded);

  static void info(String title, String message) =>
      _show(title, message, AppColors.primary, Icons.info_rounded);
}
