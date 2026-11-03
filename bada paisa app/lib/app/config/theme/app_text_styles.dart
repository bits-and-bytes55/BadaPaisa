import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(
    double size,
    FontWeight weight,
    Color color, {
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  static TextStyle get h1 =>
      _base(26, FontWeight.w700, AppColors.textPrimary, height: 1.25);
  static TextStyle get h2 =>
      _base(21, FontWeight.w700, AppColors.textPrimary, height: 1.3);
  static TextStyle get h3 => _base(18, FontWeight.w600, AppColors.textPrimary);
  static TextStyle get title =>
      _base(15, FontWeight.w600, AppColors.textPrimary);
  static TextStyle get body =>
      _base(13.5, FontWeight.w400, AppColors.textSecondary, height: 1.5);
  static TextStyle get bodyDark =>
      _base(14, FontWeight.w500, AppColors.textPrimary);
  static TextStyle get label =>
      _base(13, FontWeight.w500, AppColors.textPrimary);
  static TextStyle get caption =>
      _base(12, FontWeight.w400, AppColors.textSecondary);
  static TextStyle get small =>
      _base(10.5, FontWeight.w500, AppColors.textPrimary);
  static TextStyle get button => _base(15.5, FontWeight.w600, Colors.white);
}
