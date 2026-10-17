import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';

/// QR de mentira (solo para el prototipo). Cada [seed] da un patrón distinto,
/// con los tres cuadros de alineación reales de un QR.
class FakeQr extends StatelessWidget {
  const FakeQr({super.key, required this.seed, this.size = 120});

  final int seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _QrPainter(seed));
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.seed);

  final int seed;
  static const int _n = 21;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / _n;
    final ink = Paint()..color = AppColors.ink;
    final white = Paint()..color = Colors.white;

    canvas.drawRect(Offset.zero & size, white);

    var estado = (seed + 7) * 2654435 % 4294967296;
    for (var r = 0; r < _n; r++) {
      for (var c = 0; c < _n; c++) {
        final enEsquina = (r < 8 && c < 8) ||
            (r < 8 && c >= _n - 8) ||
            (r >= _n - 8 && c < 8);
        if (enEsquina) {
          continue;
        }
        estado = (estado * 1664525 + 1013904223) % 4294967296;
        if (((estado >> 16) & 1) == 1) {
          canvas.drawRect(
            Rect.fromLTWH(c * cell, r * cell, cell + 0.4, cell + 0.4),
            ink,
          );
        }
      }
    }

    void finder(int fila, int columna) {
      canvas.drawRect(
        Rect.fromLTWH(columna * cell, fila * cell, 7 * cell, 7 * cell),
        ink,
      );
      canvas.drawRect(
        Rect.fromLTWH(
            (columna + 1) * cell, (fila + 1) * cell, 5 * cell, 5 * cell),
        white,
      );
      canvas.drawRect(
        Rect.fromLTWH(
            (columna + 2) * cell, (fila + 2) * cell, 3 * cell, 3 * cell),
        ink,
      );
    }

    finder(0, 0);
    finder(0, _n - 7);
    finder(_n - 7, 0);
  }

  @override
  bool shouldRepaint(covariant _QrPainter old) => old.seed != seed;
}
