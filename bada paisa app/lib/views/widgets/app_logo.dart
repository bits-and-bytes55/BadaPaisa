import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/config/theme/app_theme.dart';
import '../../app/constants/app_images.dart';

/// BadaPaisa.com brand mark.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 60,
    this.fontSize = 22,
    this.vertical = false,
  });

  final double size;
  final double fontSize;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final mark = Image.asset(
      AppImages.logo,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
    final text = RichText(
      text: TextSpan(
        text: 'BadaPaisa',
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: -0.3,
        ),
        children: [
          TextSpan(
            text: '.com',
            style: GoogleFonts.poppins(
              fontSize: fontSize * 0.6,
              fontWeight: FontWeight.w500,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );

    if (vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          mark,
          SizedBox(height: size * 0.14),
          text,
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [mark, const SizedBox(width: 6), text],
    );
  }
}
