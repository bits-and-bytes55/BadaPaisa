import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/routes/app_routes.dart';
import '../../app/utils/app_snackbar.dart';
import '../../controllers/loan_application_controller.dart';
import '../../controllers/main_controller.dart';
import '../widgets/primary_button.dart';

class SuccessView extends GetView<LoanApplicationController> {
  const SuccessView({super.key});

  void _backToHome() {
    if (Get.isRegistered<MainController>()) {
      Get.find<MainController>().changeTab(0);
    }
    Get.until((route) => route.settings.name == AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    final app = controller.lastApplication.value;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _backToHome();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                SizedBox(
                  height: 220,
                  width: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeOutCubic,
                        builder: (_, v, _) => CustomPaint(
                          size: const Size(260, 220),
                          painter: _ConfettiPainter(progress: v),
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.elasticOut,
                        builder: (_, v, child) =>
                            Transform.scale(scale: v, child: child),
                        child: Container(
                          height: 104,
                          width: 104,
                          decoration: BoxDecoration(
                            gradient: AppColors.successGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 62,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Application\nSubmitted Successfully!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your ${app?.loanType ?? 'loan'} application has been submitted to BadaPaisa.com, we will contact you soon.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () {
                    if (app == null) return;
                    Clipboard.setData(ClipboardData(text: app.id));
                    AppSnackbar.success(
                      'Copied',
                      'Application ID copied to clipboard',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text('Application ID', style: AppTextStyles.caption),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              app?.id ?? '-',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primaryDark,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                PrimaryButton(text: 'Back to Home', onPressed: _backToHome),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress});
  final double progress;

  static const _colors = [
    AppColors.success,
    AppColors.accent,
    AppColors.secondary,
    AppColors.error,
    AppColors.sky,
    AppColors.violet,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(11);
    final center = size.center(Offset.zero);
    for (var i = 0; i < 34; i++) {
      final angle = rnd.nextDouble() * 2 * pi;
      final dist = (70 + rnd.nextDouble() * 50) * progress;
      final pos =
          center + Offset(cos(angle) * dist * 1.15, sin(angle) * dist * 0.9);
      final paint = Paint()
        ..color = _colors[i % _colors.length].withValues(alpha: progress);
      if (i.isEven) {
        canvas.drawCircle(pos, 2 + rnd.nextDouble() * 2, paint);
      } else {
        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        canvas.rotate(angle);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(-4, -1.5, 8, 3),
            const Radius.circular(2),
          ),
          paint,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
