import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import 'primary_button.dart';

/// Shared layout for the 5 loan application steps:
/// app bar, animated progress, "Step x of 5", title, body and bottom CTA.
class LoanStepScaffold extends StatelessWidget {
  const LoanStepScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.child,
    required this.onContinue,
    this.totalSteps = 5,
    this.buttonText = 'Continue',
    this.isLoading = false,
  });

  final int step;
  final int totalSteps;
  final String title;
  final Widget child;
  final VoidCallback? onContinue;
  final String buttonText;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: Get.back,
        ),
        title: const Text('Loan Application'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: (step - 1) / totalSteps,
                      end: step / totalSteps,
                    ),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (_, value, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 6,
                        backgroundColor: AppColors.lightBlue,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Step $step of $totalSteps',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(title, style: AppTextStyles.h2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: child),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: PrimaryButton(
                text: buttonText,
                onPressed: onContinue,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
