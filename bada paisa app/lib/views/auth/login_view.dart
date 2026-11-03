import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/app_logo.dart';
import '../widgets/primary_button.dart';
import '../widgets/wave_background.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WaveBottom(height: 140),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 44),
                  const AppLogo(size: 76, fontSize: 24, vertical: true),
                  const SizedBox(height: 30),
                  Text('Welcome Back', style: AppTextStyles.h1),
                  const SizedBox(height: 8),
                  Text(
                    'Login to apply for loans, calculate\nEMI and track your application.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 34),
                  TextField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: AppTextStyles.bodyDark.copyWith(letterSpacing: 1),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Enter Mobile Number',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 14, right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.phone_android_rounded,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text('+91', style: AppTextStyles.bodyDark),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              height: 22,
                              width: 1,
                              color: AppColors.border,
                            ),
                          ],
                        ),
                      ),
                      suffixIcon: Obx(
                        () => AnimatedScale(
                          scale: controller.isPhoneValid.value ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.success,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Obx(
                    () => PrimaryButton(
                      text: 'Get OTP',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.sendOtp,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or', style: AppTextStyles.caption),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => _GoogleButton(
                      isLoading: controller.isGoogleLoading.value,
                      onTap: controller.continueWithGoogle,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text.rich(
                    TextSpan(
                      text: 'By continuing, you agree to our\n',
                      style: AppTextStyles.caption,
                      children: [
                        TextSpan(
                          text: 'Terms & Privacy Policy',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.isLoading, required this.onTap});
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isLoading ? null : onTap,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.2),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CustomPaint(painter: _GoogleLogoPainter()),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Continue with Google',
                        style: AppTextStyles.bodyDark,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Draws the multi-colour "G" without needing an image asset.
class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.2;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );
    Paint p(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    double rad(double deg) => deg * pi / 180;

    canvas.drawArc(rect, rad(-40), rad(85), false, p(const Color(0xFF4285F4)));
    canvas.drawArc(rect, rad(45), rad(90), false, p(const Color(0xFF34A853)));
    canvas.drawArc(rect, rad(135), rad(70), false, p(const Color(0xFFFBBC05)));
    canvas.drawArc(rect, rad(205), rad(110), false, p(const Color(0xFFEA4335)));
    final cy = size.height / 2;
    canvas.drawLine(
      Offset(size.width / 2, cy),
      Offset(size.width - stroke / 2, cy),
      p(const Color(0xFF4285F4)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
