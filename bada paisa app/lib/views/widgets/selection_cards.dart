import 'package:flutter/material.dart';

import '../../app/config/theme/app_theme.dart';
import '../../models/option_model.dart';

const _duration = Duration(milliseconds: 220);

BoxDecoration _cardDecoration(bool selected) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(
    color: selected ? AppColors.primary : AppColors.border,
    width: selected ? 2 : 1,
  ),
  boxShadow: [
    BoxShadow(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.16)
          : AppColors.shadow,
      blurRadius: selected ? 18 : 10,
      offset: const Offset(0, 6),
    ),
  ],
);

class CheckBadge extends StatelessWidget {
  const CheckBadge({super.key, required this.visible, this.size = 24});
  final bool visible;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: visible ? 1 : 0,
      duration: _duration,
      curve: Curves.easeOutBack,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(Icons.check_rounded, color: Colors.white, size: size * 0.6),
      ),
    );
  }
}

/// Tall card: image on top, label below (gender).
class VerticalOptionCard extends StatelessWidget {
  const VerticalOptionCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });
  final OptionModel option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _duration,
        decoration: _cardDecoration(selected),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: AppColors.paleBlue,
                      padding: const EdgeInsets.only(top: 12),
                      child: Image.asset(option.image, fit: BoxFit.contain),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    option.title,
                    style: AppTextStyles.title.copyWith(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(top: 8, right: 8, child: CheckBadge(visible: selected)),
          ],
        ),
      ),
    );
  }
}

/// Wide card: image on the left, text on the right (purpose, employment).
class HorizontalOptionCard extends StatelessWidget {
  const HorizontalOptionCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
    this.height = 84,
  });
  final OptionModel option;
  final bool selected;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _duration,
        height: height,
        decoration: _cardDecoration(selected),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14),
                  ),
                  child: Image.asset(
                    option.image,
                    width: height * 1.25,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 36),
                    child: Text(
                      option.title,
                      style: AppTextStyles.title.copyWith(
                        color: selected
                            ? AppColors.secondary
                            : AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(top: 8, right: 8, child: CheckBadge(visible: selected)),
          ],
        ),
      ),
    );
  }
}

/// Circular image option with caption (city).
class CircleOptionCard extends StatelessWidget {
  const CircleOptionCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
    this.size = 110,
  });
  final OptionModel option;
  final bool selected;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              AnimatedContainer(
                duration: _duration,
                height: size,
                width: size,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: selected ? AppColors.primary : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.22)
                          : AppColors.shadow,
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(option.image, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: CheckBadge(visible: selected),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            option.title,
            style: AppTextStyles.label.copyWith(
              color: selected ? AppColors.primary : AppColors.textPrimary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
