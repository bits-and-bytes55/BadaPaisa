import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/constants/app_images.dart';
import '../app/routes/app_routes.dart';
import '../app/services/storage_service.dart';
import '../models/onboarding_model.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingModel> pages = const [
    OnboardingModel(
      image: AppImages.onboardFamily,
      title: 'Easy & Fast Loans',
      subtitle: 'Get personalized loan offers with\nlow interest rates.',
    ),
    OnboardingModel(
      image: AppImages.onboardEmi,
      title: 'EMI Calculator',
      subtitle: 'Plan your loan with our easy\nEMI & eligibility calculator.',
    ),
    OnboardingModel(
      image: AppImages.onboardSecure,
      title: 'Safe & Secure',
      subtitle: 'Your data is 100% safe\nand always confidential.',
    ),
  ];

  bool get isLastPage => currentPage.value == pages.length - 1;

  void onPageChanged(int index) => currentPage.value = index;

  void next() {
    if (isLastPage) {
      finish();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> finish() async {
    await StorageService.to.setOnboardingSeen();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
