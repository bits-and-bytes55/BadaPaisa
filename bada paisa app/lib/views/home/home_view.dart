import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/constants/app_images.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/notifications_controller.dart';
import '../widgets/app_logo.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/tap_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  children: [
                    const AppLogo(size: 32, fontSize: 17),
                    const Spacer(),
                    _BellButton(onTap: controller.onNotificationTap),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => Text.rich(
                    TextSpan(
                      text: 'Hello, ${controller.userName.value} ',
                      style: AppTextStyles.h2,
                      children: const [TextSpan(text: '👋')],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Find the right loan for your needs',
                  style: AppTextStyles.body,
                ),
              ),
              const SizedBox(height: 17),
              FadeSlideIn(child: _BannerCarousel(controller: controller)),
              const SizedBox(height: 21),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Loan Categories',
                      style: AppTextStyles.title.copyWith(fontSize: 17),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => Get.toNamed(AppRoutes.loanProducts),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 5,
                        ),
                        child: Text(
                          'View All',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 11),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 11,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (_, i) => FadeSlideIn(
                    index: i,
                    child: _CategoryTile(category: controller.categories[i]),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FadeSlideIn(
                  index: 4,
                  child: _QuickApplyCard(
                    onTap: () => controller.openProduct('home'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BellButton extends GetView<NotificationsController> {
  const _BellButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: AppColors.shadow,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 42,
          width: 42,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: 23,
              ),
              Obx(
                () => controller.unreadCount == 0
                    ? const SizedBox.shrink()
                    : Positioned(
                        top: 9,
                        right: 10,
                        child: Container(
                          height: 9,
                          width: 9,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel({required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          width: double.infinity,
          child: PageView.builder(
            controller: controller.bannerController,
            onPageChanged: controller.onBannerChanged,
            itemCount: HomeController.banners.length,
            itemBuilder: (_, index) {
              final banner = HomeController.banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _PromoBanner(
                  banner: banner,
                  showHouse: index == 0,
                  onApply: () => controller.openProduct(banner.productId),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 9),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              HomeController.banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: controller.activeBanner.value == index ? 18 : 6,
                decoration: BoxDecoration(
                  color: controller.activeBanner.value == index
                      ? AppColors.primary
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({
    required this.banner,
    required this.showHouse,
    required this.onApply,
  });

  final HomeBanner banner;
  final bool showHouse;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: banner.colors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: banner.colors.last.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: -34,
              top: -56,
              child: Container(
                height: 170,
                width: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.09),
                ),
              ),
            ),
            Positioned(
              right: -16,
              bottom: -42,
              child: Container(
                height: 126,
                width: 126,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            if (showHouse)
              Positioned(
                right: -8,
                top: 0,
                bottom: 0,
                width: 176,
                child: ShaderMask(
                  shaderCallback: (rect) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.transparent, Colors.white],
                    stops: [0, 0.3],
                  ).createShader(rect),
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(AppImages.bannerHouse, fit: BoxFit.cover),
                ),
              )
            else
              Positioned(
                right: 29,
                top: 32,
                child: Container(
                  height: 92,
                  width: 92,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Icon(banner.icon, color: Colors.white, size: 46),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 140, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner.eyebrow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    banner.rate,
                    maxLines: 1,
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Material(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(9),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(9),
                      onTap: onApply,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        child: Text(
                          'Apply Now',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});
  final HomeCategory category;

  @override
  Widget build(BuildContext context) {
    return TapCard(
      onTap: category.onTap,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
      radius: 18,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(category.icon, color: category.color, size: 23),
            ),
            const SizedBox(height: 7),
            Text(
              category.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.small.copyWith(fontSize: 9.6, height: 1.18),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickApplyCard extends StatelessWidget {
  const _QuickApplyCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapCard(
      onTap: onTap,
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.amber,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Apply',
                  style: AppTextStyles.title.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 1),
                Text(
                  'Apply for a loan in just a few steps',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: 26,
          ),
        ],
      ),
    );
  }
}
