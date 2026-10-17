import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';

/// Dibuja un rectángulo redondeado con borde punteado.
void drawDashedRRect(
  Canvas canvas,
  Rect rect,
  double radius,
  Paint paint, {
  double dash = 6,
  double gap = 4,
}) {
  final path = Path()
    ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
  for (final metric in path.computeMetrics()) {
    var distance = 0.0;
    while (distance < metric.length) {
      final end = distance + dash > metric.length ? metric.length : distance + dash;
      canvas.drawPath(metric.extractPath(distance, end), paint);
      distance += dash + gap;
    }
  }
}

/// Contenedor con borde punteado (ticket, tarjetas de apoyo).
class DashedBox extends StatelessWidget {
  const DashedBox({
    super.key,
    required this.child,
    this.radius = 6,
    this.color = AppColors.ink,
    this.strokeWidth = 1.5,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final double radius;
  final Color color;
  final double strokeWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPainter(radius, color, strokeWidth),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _DashedPainter extends CustomPainter {
  _DashedPainter(this.radius, this.color, this.strokeWidth);

  final double radius;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    drawDashedRRect(canvas, Offset.zero & size, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedPainter old) {
    return old.radius != radius ||
        old.color != color ||
        old.strokeWidth != strokeWidth;
  }
}
