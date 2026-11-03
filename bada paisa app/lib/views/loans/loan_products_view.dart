import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/constants/app_data.dart';
import '../../app/routes/app_routes.dart';
import '../../models/loan_product_model.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/tap_card.dart';
import '../widgets/wave_background.dart';

class LoanProductsView extends StatelessWidget {
  const LoanProductsView({super.key, this.embedded = false});

  /// true when shown inside the bottom navigation (no back button).
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WaveBottom(height: 120),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!embedded)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                      onPressed: Get.back,
                    ),
                  )
                else
                  const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Our Loan Products', style: AppTextStyles.h2),
                      const SizedBox(height: 2),
                      Text(
                        'Choose from a wide range of loan solutions',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 130),
                    itemCount: AppData.products.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => FadeSlideIn(
                      index: i,
                      child: _ProductCard(product: AppData.products[i]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final LoanProductModel product;

  @override
  Widget build(BuildContext context) {
    return TapCard(
      onTap: () => Get.toNamed(AppRoutes.applyLoan, arguments: product),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: product.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(product.icon, color: product.color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: AppTextStyles.title),
                const SizedBox(height: 2),
                Text(product.subtitle, style: AppTextStyles.caption),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'From ${product.rate.toStringAsFixed(2)}% p.a.',
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
