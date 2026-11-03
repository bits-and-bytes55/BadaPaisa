import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/constants/app_images.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/primary_button.dart';

class OtpView extends GetView<AuthController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: Get.back,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                height: 150,
                width: 150,
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.white, AppColors.lightBlue],
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(AppImages.otpPhone, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 26),
              Text('Verify OTP', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text('Enter the 6-digit code sent to', style: AppTextStyles.body),
              const SizedBox(height: 2),
              Text(controller.formattedPhone, style: AppTextStyles.title),
              const SizedBox(height: 32),
              _OtpInput(controller: controller),
              const SizedBox(height: 26),
              Obx(
                () => controller.secondsLeft.value > 0
                    ? Text.rich(
                        TextSpan(
                          text: 'Resend OTP in ',
                          style: AppTextStyles.body,
                          children: [
                            TextSpan(
                              text: controller.timerText,
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : TextButton.icon(
                        onPressed: controller.resendOtp,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Resend OTP'),
                      ),
              ),
              const SizedBox(height: 48),
              Obx(
                () => PrimaryButton(
                  text: 'Verify & Continue',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.verifyOtp,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Six OTP boxes driven by a single invisible text field.
class _OtpInput extends StatelessWidget {
  const _OtpInput({required this.controller});
  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          final value = controller.otp.value;
          return Row(
            children: List.generate(6, (i) {
              final filled = i < value.length;
              final active = i == value.length;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: filled ? AppColors.paleBlue : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: active || filled
                          ? AppColors.secondary
                          : AppColors.border,
                      width: active ? 1.8 : 1.2,
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: AppColors.secondary.withValues(
                                alpha: 0.15,
                              ),
                              blurRadius: 10,
                            ),
                          ]
                        : null,
                  ),
                  child: Text(filled ? value[i] : '', style: AppTextStyles.h3),
                ),
              );
            }),
          );
        }),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: controller.otpController,
              autofocus: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              showCursor: false,
              enableInteractiveSelection: false,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: controller.onOtpChanged,
              decoration: const InputDecoration(
                counterText: '',
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
