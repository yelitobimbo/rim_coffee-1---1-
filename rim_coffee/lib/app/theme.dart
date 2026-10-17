import 'package:flutter/material.dart';

/// Paleta del prototipo: blanco y negro como en los wireframes,
/// con un único acento café para estados destacados.
class AppColors {
  AppColors._();

  static const Color ink = Color(0xFF1A1A1A);
  static const Color soft = Color(0xFF8A8A8A);
  static const Color line = Color(0xFFD9D9D9);
  static const Color fill = Color(0xFFEDEDED);
  static const Color accent = Color(0xFF6F4E37);
}

ThemeData buildTheme() {
  const scheme = ColorScheme.light(
    primary: AppColors.ink,
    onPrimary: Colors.white,
    secondary: AppColors.accent,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: AppColors.ink,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );
}

/// Decoración de campo de texto con el estilo de los wireframes
/// (borde negro de 1.4 px, esquinas de 6 px).
InputDecoration rcInput({
  String? hint,
  Widget? prefixIcon,
  bool enabled = true,
  bool dense = false,
}) {
  OutlineInputBorder border(Color color, [double width = 1.4]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.soft, fontSize: 13),
    prefixIcon: prefixIcon,
    isDense: dense,
    filled: !enabled,
    fillColor: AppColors.fill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: border(AppColors.ink),
    enabledBorder: border(AppColors.ink),
    focusedBorder: border(AppColors.ink, 2),
    disabledBorder: border(AppColors.soft, 1.2),
  );
}
