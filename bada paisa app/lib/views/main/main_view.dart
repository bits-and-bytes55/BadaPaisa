import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../controllers/main_controller.dart';
import '../applications/applications_view.dart';
import '../emi/emi_calculator_view.dart';
import '../home/home_view.dart';
import '../loans/loan_products_view.dart';
import '../profile/profile_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  static const _pages = [
    HomeView(),
    LoanProductsView(embedded: true),
    EmiCalculatorView(embedded: true),
    ApplicationsView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _NavItemData {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const _NavItemData(this.label, this.icon, this.activeIcon);
}

class _BottomNav extends GetView<MainController> {
  const _BottomNav();

  static const _items = [
    _NavItemData('Home', Icons.home_outlined, Icons.home_rounded),
    _NavItemData(
      'Loans',
      Icons.account_balance_wallet_outlined,
      Icons.account_balance_wallet_rounded,
    ),
    _NavItemData(
      'Calculator',
      Icons.calculate_outlined,
      Icons.calculate_rounded,
    ),
    _NavItemData(
      'Applications',
      Icons.description_outlined,
      Icons.description_rounded,
    ),
    _NavItemData('Profile', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Obx(
            () => Row(
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                final selected = controller.currentIndex.value == i;
                final color = selected
                    ? AppColors.primary
                    : AppColors.textSecondary;
                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => controller.changeTab(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.lightBlue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              selected ? item.activeIcon : item.icon,
                              color: color,
                              size: 23,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.small.copyWith(
                              color: color,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
