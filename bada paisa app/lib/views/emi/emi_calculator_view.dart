import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/constants/app_data.dart';
import '../../app/routes/app_routes.dart';
import '../../app/utils/formatters.dart';
import '../../controllers/emi_calculator_controller.dart';
import '../widgets/primary_button.dart';

typedef C = EmiCalculatorController;

final _decimalFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d{0,2}(\.\d{0,2})?'),
);
final _intFormatter = FilteringTextInputFormatter.digitsOnly;

class EmiCalculatorView extends GetView<EmiCalculatorController> {
  const EmiCalculatorView({super.key, this.embedded = false});

  /// true when shown inside the bottom navigation (no back button).
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: embedded
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: Get.back,
              ),
        title: const Text('EMI Calculator'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            children: [
              const _TabToggle(),
              const SizedBox(height: 22),
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.tabIndex.value == 0
                      ? const _EmiSection(key: ValueKey('emi'))
                      : const _EligibilitySection(key: ValueKey('elig')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabToggle extends GetView<EmiCalculatorController> {
  const _TabToggle();

  @override
  Widget build(BuildContext context) {
    const tabs = ['Loan EMI', 'Eligibility'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.paleBlue,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Obx(
        () => Row(
          children: List.generate(tabs.length, (i) {
            final selected = controller.tabIndex.value == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: selected ? AppColors.primaryGradient : null,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    tabs[i],
                    style: AppTextStyles.label.copyWith(
                      color: selected ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Label + editable text field + synced slider.
class _SliderField extends StatelessWidget {
  const _SliderField({
    required this.label,
    required this.textController,
    required this.value,
    required this.min,
    required this.max,
    required this.onSlider,
    required this.onTyped,
    required this.formatters,
    this.prefix,
    this.suffix,
    this.divisions,
  });

  final String label;
  final TextEditingController textController;
  final RxDouble value;
  final double min;
  final double max;
  final ValueChanged<double> onSlider;
  final ValueChanged<String> onTyped;
  final List<TextInputFormatter> formatters;
  final String? prefix;
  final String? suffix;
  final int? divisions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: 6),
          TextField(
            controller: textController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: formatters,
            onChanged: onTyped,
            style: AppTextStyles.bodyDark,
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: prefix == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: Text(prefix!, style: AppTextStyles.bodyDark),
                    ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: suffix == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(suffix!, style: AppTextStyles.caption),
                    ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
            ),
          ),
          Obx(
            () => Slider(
              value: value.value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onSlider,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmiSection extends GetView<EmiCalculatorController> {
  const _EmiSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Column(
      children: [
        _SliderField(
          label: 'Loan Amount',
          prefix: '₹',
          textController: c.amountController,
          value: c.loanAmount,
          min: C.minAmount,
          max: C.maxAmount,
          onSlider: c.setAmount,
          onTyped: c.onAmountTyped,
          formatters: const [IndianNumberInputFormatter(maxDigits: 9)],
        ),
        _SliderField(
          label: 'Interest Rate (p.a.)',
          suffix: '%',
          textController: c.rateController,
          value: c.interestRate,
          min: C.minRate,
          max: C.maxRate,
          divisions: 150,
          onSlider: c.setRate,
          onTyped: c.onRateTyped,
          formatters: [_decimalFormatter],
        ),
        _SliderField(
          label: 'Loan Tenure',
          suffix: 'Years',
          textController: c.tenureController,
          value: c.tenureYears,
          min: C.minTenure,
          max: C.maxTenure,
          divisions: 29,
          onSlider: c.setTenure,
          onTyped: c.onTenureTyped,
          formatters: [_intFormatter, LengthLimitingTextInputFormatter(2)],
        ),
        const SizedBox(height: 6),
        Obx(
          () => _ResultCard(
            title: 'Monthly EMI',
            value: AppFormatters.currency(c.emi),
            ratio: c.principalRatio,
            leftLabel: 'Total Interest',
            leftValue: AppFormatters.currency(c.totalInterest),
            rightLabel: 'Total Amount',
            rightValue: AppFormatters.currency(c.totalAmount),
          ),
        ),
      ],
    );
  }
}

class _EligibilitySection extends GetView<EmiCalculatorController> {
  const _EligibilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Column(
      children: [
        _SliderField(
          label: 'Monthly Income',
          prefix: '₹',
          textController: c.incomeController,
          value: c.monthlyIncome,
          min: C.minIncome,
          max: C.maxIncome,
          onSlider: c.setIncome,
          onTyped: c.onIncomeTyped,
          formatters: const [IndianNumberInputFormatter(maxDigits: 8)],
        ),
        _SliderField(
          label: 'Existing EMIs (per month)',
          prefix: '₹',
          textController: c.existingEmiController,
          value: c.existingEmi,
          min: 0,
          max: C.maxExistingEmi,
          onSlider: c.setExistingEmi,
          onTyped: c.onExistingEmiTyped,
          formatters: const [IndianNumberInputFormatter(maxDigits: 7)],
        ),
        _SliderField(
          label: 'Interest Rate (p.a.)',
          suffix: '%',
          textController: c.eligRateController,
          value: c.eligRate,
          min: C.minRate,
          max: C.maxRate,
          divisions: 150,
          onSlider: c.setEligRate,
          onTyped: c.onEligRateTyped,
          formatters: [_decimalFormatter],
        ),
        _SliderField(
          label: 'Loan Tenure',
          suffix: 'Years',
          textController: c.eligTenureController,
          value: c.eligTenure,
          min: C.minTenure,
          max: C.maxTenure,
          divisions: 29,
          onSlider: c.setEligTenure,
          onTyped: c.onEligTenureTyped,
          formatters: [_intFormatter, LengthLimitingTextInputFormatter(2)],
        ),
        const SizedBox(height: 6),
        Obx(
          () => _ResultCard(
            title: 'You are eligible for',
            value: AppFormatters.currency(c.eligibleAmount),
            leftLabel: 'Affordable EMI',
            leftValue: AppFormatters.currency(c.affordableEmi),
            rightLabel: 'Tenure',
            rightValue: '${c.eligTenure.value.toStringAsFixed(0)} Years',
          ),
        ),
        const SizedBox(height: 18),
        PrimaryButton(
          text: 'Apply for Home Loan',
          icon: Icons.arrow_forward_rounded,
          onPressed: () => Get.toNamed(
            AppRoutes.applyLoan,
            arguments: AppData.product('home'),
          ),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.title,
    required this.value,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
    this.ratio,
  });

  final String title;
  final String value;
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;
  final double? ratio;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyDark.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  child: Text(
                    value,
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                if (ratio != null) ...[
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      height: 8,
                      child: Row(
                        children: [
                          Expanded(
                            flex: (ratio! * 1000).round().clamp(1, 1000),
                            child: Container(color: AppColors.sky),
                          ),
                          Expanded(
                            flex: ((1 - ratio!) * 1000).round().clamp(1, 1000),
                            child: Container(color: AppColors.accent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legend(AppColors.sky, 'Principal'),
                      const SizedBox(width: 18),
                      _legend(AppColors.accent, 'Interest'),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _metric(leftLabel, leftValue)),
                const VerticalDivider(width: 1, color: AppColors.border),
                Expanded(child: _metric(rightLabel, rightValue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String text) => Row(
    children: [
      Container(
        height: 8,
        width: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: Colors.white70,
          fontSize: 11,
        ),
      ),
    ],
  );

  Widget _metric(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
    child: Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        FittedBox(child: Text(value, style: AppTextStyles.title)),
      ],
    ),
  );
}
