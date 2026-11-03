import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/constants/app_data.dart';
import '../../app/constants/app_images.dart';
import '../../controllers/loan_application_controller.dart';
import '../../models/loan_product_model.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/primary_button.dart';
import '../widgets/wave_background.dart';

class ApplyLoanView extends StatelessWidget {
  const ApplyLoanView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final LoanProductModel product = args is LoanProductModel
        ? args
        : AppData.products.first;

    final features = [
      (
        Icons.percent_rounded,
        'Interest Rate',
        'Starting @ ${product.rate.toStringAsFixed(2)}%*',
      ),
      (
        Icons.stacked_line_chart_rounded,
        'Loan Amount',
        'Up to ${product.maxAmount}',
      ),
      (
        Icons.calendar_month_rounded,
        'Tenure',
        'Up to ${product.maxTenure} Years',
      ),
      (Icons.bolt_rounded, 'Quick Approval', 'Minimum Documentation'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                        onPressed: Get.back,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Text(
                      'Apply for ${product.title}',
                      style: AppTextStyles.h1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Hero(
                    tag: 'loan-hero',
                    child: ClipPath(
                      clipper: BottomWaveClipper(),
                      child: Image.asset(
                        AppImages.homeLoanHouse,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: List.generate(features.length, (i) {
                        final f = features[i];
                        return FadeSlideIn(
                          index: i,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Container(
                                  height: 46,
                                  width: 46,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightBlue,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    f.$1,
                                    color: AppColors.secondary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(f.$2, style: AppTextStyles.label),
                                    Text(f.$3, style: AppTextStyles.caption),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
              child: PrimaryButton(
                text: 'Apply Now',
                onPressed: () => Get.find<LoanApplicationController>()
                    .startApplication(product),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
