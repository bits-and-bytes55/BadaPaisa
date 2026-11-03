import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../controllers/splash_controller.dart';
import '../widgets/app_logo.dart';
import '../widgets/wave_background.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.splashGradient),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.28),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutBack,
              builder: (_, v, child) => Opacity(
                opacity: v.clamp(0.0, 1.0),
                child: Transform.scale(scale: 0.75 + 0.25 * v, child: child),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(size: 110, fontSize: 30, vertical: true),
                  const SizedBox(height: 30),
                  Text(
                    'Your Trusted\nLoan Partner',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WaveBottom(height: 250),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: _LoadingBars(),
          ),
        ],
      ),
    );
  }
}

class _LoadingBars extends StatefulWidget {
  const _LoadingBars();

  @override
  State<_LoadingBars> createState() => _LoadingBarsState();
}

class _LoadingBarsState extends State<_LoadingBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _bar(18 + 16 * _c.value, 1),
          const SizedBox(width: 6),
          _bar(34 - 16 * _c.value, 0.5),
        ],
      ),
    );
  }

  Widget _bar(double width, double alpha) => Container(
    height: 4,
    width: width,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: alpha),
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
