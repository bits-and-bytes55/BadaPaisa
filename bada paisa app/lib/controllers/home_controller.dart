import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/config/theme/app_colors.dart';
import '../app/constants/app_data.dart';
import '../app/routes/app_routes.dart';
import '../app/services/storage_service.dart';
import '../app/utils/app_snackbar.dart';
import 'main_controller.dart';

class HomeBanner {
  final String productId;
  final String eyebrow;
  final String rate;
  final String caption;
  final IconData icon;
  final List<Color> colors;

  const HomeBanner({
    required this.productId,
    required this.eyebrow,
    required this.rate,
    required this.caption,
    required this.icon,
    required this.colors,
  });
}

class HomeCategory {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const HomeCategory(this.title, this.icon, this.color, this.onTap);
}

class HomeController extends GetxController {
  final RxString userName = 'there'.obs;
  final RxInt activeBanner = 0.obs;
  late final PageController bannerController;
  Timer? _bannerTimer;
  late final List<HomeCategory> categories;

  static const banners = [
    HomeBanner(
      productId: 'home',
      eyebrow: 'Get Home Loan',
      rate: '@ 6.90%*',
      caption: 'Make your dream home a reality',
      icon: Icons.home_rounded,
      colors: [Color(0xFF1596D2), Color(0xFF07517D)],
    ),
    HomeBanner(
      productId: 'personal',
      eyebrow: 'Instant Personal Loan',
      rate: '@ 10.50%*',
      caption: 'Quick funds for every big moment',
      icon: Icons.auto_awesome_rounded,
      colors: [Color(0xFF7657E8), Color(0xFF3E278E)],
    ),
    HomeBanner(
      productId: 'business',
      eyebrow: 'Grow Your Business',
      rate: 'Up to ₹2 Cr',
      caption: 'Flexible finance for your next move',
      icon: Icons.business_center_rounded,
      colors: [Color(0xFF16A77E), Color(0xFF08634F)],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    bannerController = PageController();
    userName.value = StorageService.to.userName ?? 'there';
    categories = [
      HomeCategory(
        'Home\nLoan',
        Icons.house_rounded,
        AppColors.green,
        () => openProduct('home'),
      ),
      HomeCategory(
        'Business\nLoan',
        Icons.business_center_rounded,
        AppColors.purple,
        () => openProduct('business'),
      ),
      HomeCategory(
        'Personal\nLoan',
        Icons.person_rounded,
        AppColors.teal,
        () => openProduct('personal'),
      ),
      HomeCategory(
        'Auto\nLoan',
        Icons.directions_car_filled_rounded,
        AppColors.red,
        () => openProduct('auto'),
      ),
      HomeCategory(
        'Loan Against\nProperty',
        Icons.home_work_rounded,
        AppColors.orange,
        () => openProduct('lap'),
      ),
      HomeCategory(
        'Insurance',
        Icons.shield_rounded,
        AppColors.violet,
        () => AppSnackbar.info(
          'Coming soon',
          'Insurance plans will be available shortly.',
        ),
      ),
      HomeCategory(
        'EMI\nCalculator',
        Icons.calculate_rounded,
        AppColors.amber,
        () => Get.find<MainController>().changeTab(2),
      ),
      HomeCategory(
        'More',
        Icons.more_horiz_rounded,
        AppColors.blue,
        () => Get.toNamed(AppRoutes.loanProducts),
      ),
    ];
  }

  @override
  void onReady() {
    super.onReady();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!bannerController.hasClients) return;
      final next = (activeBanner.value + 1) % banners.length;
      bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void onBannerChanged(int index) => activeBanner.value = index;

  void openProduct(String id) =>
      Get.toNamed(AppRoutes.applyLoan, arguments: AppData.product(id));

  void onNotificationTap() => Get.toNamed(AppRoutes.notifications);

  @override
  void onClose() {
    _bannerTimer?.cancel();
    bannerController.dispose();
    super.onClose();
  }
}
