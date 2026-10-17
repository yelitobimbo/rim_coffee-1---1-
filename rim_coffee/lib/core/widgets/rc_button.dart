import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';

/// Botón de ancho completo. [filled] = primario (negro); si no, de contorno.
/// [muted] atenúa el botón de contorno (acciones secundarias).
class RcButton extends StatelessWidget {
  const RcButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
    this.muted = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(6));
    const textStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w700);
    final child = Text(label, textAlign: TextAlign.center);

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: filled
          ? FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.ink,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.line,
                disabledForegroundColor: AppColors.soft,
                shape: shape,
                textStyle: textStyle,
              ),
              child: child,
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: muted ? AppColors.soft : AppColors.ink,
                side: BorderSide(
                  color: muted ? AppColors.soft : AppColors.ink,
                  width: 1.6,
                ),
                shape: shape,
                textStyle: textStyle,
              ),
              child: child,
            ),
    );
  }
}
