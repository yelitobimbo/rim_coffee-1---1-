import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';

import 'dashed_box.dart';

/// Caja de imagen del lenguaje wireframe: borde punteado con diagonales.
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _PlaceholderPainter()),
    );
  }
}

class _PlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.soft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    drawDashedRRect(canvas, Offset.zero & size, 4, paint, dash: 5, gap: 4);
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
