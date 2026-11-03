import 'package:flutter/material.dart';

class LoanProductModel {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double rate;
  final String maxAmount;
  final int maxTenure;

  const LoanProductModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.rate,
    required this.maxAmount,
    required this.maxTenure,
  });
}
