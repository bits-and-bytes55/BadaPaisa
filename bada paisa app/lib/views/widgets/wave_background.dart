import 'package:flutter/material.dart';

import '../../app/config/theme/app_theme.dart';

/// Layered blue waves used at the bottom of splash / auth / listing screens.
class WaveBottom extends StatelessWidget {
  const WaveBottom({super.key, this.height = 160});
  final double height;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: _WavePainter()),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    Path wave(double startY, double c1y, double c2y, double endY) => Path()
      ..moveTo(0, h * startY)
      ..cubicTo(w * 0.28, h * c1y, w * 0.62, h * c2y, w, h * endY)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(
      wave(0.30, 0.02, 0.62, 0.12),
      Paint()..color = AppColors.sky.withValues(alpha: 0.22),
    );
    canvas.drawPath(
      wave(0.52, 0.22, 0.80, 0.34),
      Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.sky.withValues(alpha: 0.75),
            AppColors.secondary.withValues(alpha: 0.85),
          ],
        ).createShader(rect),
    );
    canvas.drawPath(
      wave(0.74, 0.50, 0.98, 0.60),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.primaryDark],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Clips the bottom edge of an image into a soft wave.
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    return Path()
      ..lineTo(0, h - 28)
      ..quadraticBezierTo(w * 0.25, h, w * 0.52, h - 22)
      ..quadraticBezierTo(w * 0.80, h - 46, w, h - 18)
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
