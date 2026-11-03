import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/utils/formatters.dart';

class EmiCalculatorController extends GetxController {
  // Limits
  static const double minAmount = 100000, maxAmount = 50000000;
  static const double minRate = 5, maxRate = 20;
  static const double minTenure = 1, maxTenure = 30;
  static const double minIncome = 10000, maxIncome = 1000000;
  static const double maxExistingEmi = 500000;

  final RxInt tabIndex = 0.obs;

  // ---- Loan EMI ----
  final RxDouble loanAmount = 5000000.0.obs;
  final RxDouble interestRate = 6.9.obs;
  final RxDouble tenureYears = 20.0.obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();

  // ---- Eligibility ----
  final RxDouble monthlyIncome = 100000.0.obs;
  final RxDouble existingEmi = 0.0.obs;
  final RxDouble eligRate = 6.9.obs;
  final RxDouble eligTenure = 20.0.obs;

  final TextEditingController incomeController = TextEditingController();
  final TextEditingController existingEmiController = TextEditingController();
  final TextEditingController eligRateController = TextEditingController();
  final TextEditingController eligTenureController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    amountController.text = AppFormatters.number(loanAmount.value);
    rateController.text = interestRate.value.toStringAsFixed(2);
    tenureController.text = tenureYears.value.toStringAsFixed(0);
    incomeController.text = AppFormatters.number(monthlyIncome.value);
    existingEmiController.text = '0';
    eligRateController.text = eligRate.value.toStringAsFixed(2);
    eligTenureController.text = eligTenure.value.toStringAsFixed(0);
  }

  static double calculateEmi(
    double principal,
    double annualRate,
    double years,
  ) {
    final n = years * 12;
    if (principal <= 0 || n <= 0) return 0;
    final r = annualRate / 12 / 100;
    if (r == 0) return principal / n;
    final f = pow(1 + r, n);
    return principal * r * f / (f - 1);
  }

  // ---- EMI results ----
  double get emi =>
      calculateEmi(loanAmount.value, interestRate.value, tenureYears.value);
  double get totalAmount => emi * tenureYears.value * 12;
  double get totalInterest => max(0, totalAmount - loanAmount.value);
  double get principalRatio =>
      totalAmount == 0 ? 1 : loanAmount.value / totalAmount;

  // ---- Eligibility results (50% FOIR) ----
  double get affordableEmi =>
      max(0, monthlyIncome.value * 0.5 - existingEmi.value);
  double get eligibleAmount {
    final n = eligTenure.value * 12;
    final r = eligRate.value / 12 / 100;
    if (affordableEmi <= 0 || n <= 0) return 0;
    if (r == 0) return affordableEmi * n;
    final f = pow(1 + r, n);
    return affordableEmi * (f - 1) / (r * f);
  }

  void changeTab(int i) => tabIndex.value = i;

  // ---- Slider handlers (update text) ----
  void setAmount(double v) {
    loanAmount.value = (v / 10000).round() * 10000;
    amountController.text = AppFormatters.number(loanAmount.value);
  }

  void setRate(double v) {
    interestRate.value = double.parse(v.toStringAsFixed(2));
    rateController.text = interestRate.value.toStringAsFixed(2);
  }

  void setTenure(double v) {
    tenureYears.value = v.roundToDouble();
    tenureController.text = tenureYears.value.toStringAsFixed(0);
  }

  void setIncome(double v) {
    monthlyIncome.value = (v / 1000).round() * 1000;
    incomeController.text = AppFormatters.number(monthlyIncome.value);
  }

  void setExistingEmi(double v) {
    existingEmi.value = (v / 500).round() * 500;
    existingEmiController.text = AppFormatters.number(existingEmi.value);
  }

  void setEligRate(double v) {
    eligRate.value = double.parse(v.toStringAsFixed(2));
    eligRateController.text = eligRate.value.toStringAsFixed(2);
  }

  void setEligTenure(double v) {
    eligTenure.value = v.roundToDouble();
    eligTenureController.text = eligTenure.value.toStringAsFixed(0);
  }

  // ---- Text handlers (update value only) ----
  double _clamp(String s, double lo, double hi) =>
      AppFormatters.parse(s).clamp(lo, hi).toDouble();

  void onAmountTyped(String s) => loanAmount.value = _clamp(s, 0, maxAmount);
  void onRateTyped(String s) => interestRate.value = _clamp(s, 0, maxRate);
  void onTenureTyped(String s) => tenureYears.value = _clamp(s, 0, maxTenure);
  void onIncomeTyped(String s) => monthlyIncome.value = _clamp(s, 0, maxIncome);
  void onExistingEmiTyped(String s) =>
      existingEmi.value = _clamp(s, 0, maxExistingEmi);
  void onEligRateTyped(String s) => eligRate.value = _clamp(s, 0, maxRate);
  void onEligTenureTyped(String s) =>
      eligTenure.value = _clamp(s, 0, maxTenure);

  @override
  void onClose() {
    for (final c in [
      amountController,
      rateController,
      tenureController,
      incomeController,
      existingEmiController,
      eligRateController,
      eligTenureController,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
