import 'package:flutter/material.dart';

/// Central colour palette for the BadaPaisa app.
/// Every screen reads colours from here - never hard-code them in views.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF0C4A78);
  static const Color primaryDark = Color(0xFF07355A);
  static const Color secondary = Color(0xFF1C7CC0);
  static const Color sky = Color(0xFF5FB4E6);
  static const Color accent = Color(0xFFFFC727);
  static const Color lightBlue = Color(0xFFE7F2FB);
  static const Color paleBlue = Color(0xFFF3F8FD);

  // Neutrals
  static const Color background = Color(0xFFF6FAFD);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF0E2A47);
  static const Color textSecondary = Color(0xFF6B7C93);
  static const Color textHint = Color(0xFFA0AEC0);
  static const Color border = Color(0xFFDDE7F0);
  static const Color shadow = Color(0x1A0C4A78);

  // Status
  static const Color success = Color(0xFF22A45D);
  static const Color successLight = Color(0xFFE9F7EF);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFE5484D);

  // Category accents
  static const Color green = Color(0xFF2BB673);
  static const Color purple = Color(0xFF7B5CFA);
  static const Color teal = Color(0xFF14B8A6);
  static const Color red = Color(0xFFEF4444);
  static const Color orange = Color(0xFFF97316);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color amber = Color(0xFFF59E0B);
  static const Color blue = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF125C93), primaryDark],
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E8AD3), Color(0xFF0C4A78)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34C377), Color(0xFF1E9A52)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color(0xFFEAF4FB)],
  );
}
