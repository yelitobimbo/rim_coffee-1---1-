import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';

import 'rc_button.dart';

/// Estado vacío: círculo con ícono, título, texto de ayuda y botón opcional.
/// Mismo patrón visual para todo vacío de la app.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.soft, width: 1.6),
              ),
              child: Icon(icon, size: 32, color: AppColors.soft),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.soft),
            ),
            if (buttonLabel != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 240,
                child: RcButton(label: buttonLabel!, onPressed: onPressed),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
