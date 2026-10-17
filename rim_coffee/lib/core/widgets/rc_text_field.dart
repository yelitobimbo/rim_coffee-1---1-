import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';

/// Campo de texto con etiqueta en negritas arriba, como en los wireframes.
class RcTextField extends StatelessWidget {
  const RcTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.obscure = false,
    this.maxLines = 1,
    this.enabled = true,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool obscure;
  final int maxLines;
  final bool enabled;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          maxLines: obscure ? 1 : maxLines,
          enabled: enabled,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14),
          decoration: rcInput(
            hint: hint,
            prefixIcon: prefixIcon,
            enabled: enabled,
          ),
        ),
      ],
    );
  }
}
