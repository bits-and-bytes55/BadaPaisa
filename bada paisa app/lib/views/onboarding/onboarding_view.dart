import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../controllers/onboarding_controller.dart';
import '../../models/onboarding_model.dart';
import '../widgets/primary_button.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 4),
                child: TextButton(
                  onPressed: controller.finish,
                  child: Text('Skip', style: AppTextStyles.label),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (_, i) =>
                    _OnboardingPage(model: controller.pages[i]),
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(controller.pages.length, (i) {
                  final active = controller.currentPage.value == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: active ? 22 : 8,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(
                () => PrimaryButton(
                  text: controller.isLastPage ? 'Get Started' : 'Next',
                  onPressed: controller.next,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.model});
  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: ShaderMask(
                // Fades the illustration edges into the white background.
                shaderCallback: (rect) => const RadialGradient(
                  radius: 0.75,
                  colors: [Colors.white, Colors.white, Colors.transparent],
                  stops: [0, 0.78, 1],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: Image.asset(model.image, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            model.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 10),
          Text(
            model.subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
