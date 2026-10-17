import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';

/// Etiqueta "MESA 4" del encabezado.
class MesaTag extends StatelessWidget {
  const MesaTag(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink, width: 1.4),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Encabezado estándar de toda la app: título, etiqueta opcional de mesa
/// y línea inferior de 2 px (igual que en los wireframes).
PreferredSizeWidget rcAppBar({
  required String title,
  String? tag,
  bool showBack = false,
  List<Widget>? actions,
}) {
  return AppBar(
    automaticallyImplyLeading: showBack,
    backgroundColor: Colors.white,
    foregroundColor: AppColors.ink,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleSpacing: showBack ? 0 : 16,
    title: Text(
      title,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    ),
    actions: [
      ...?actions,
      if (tag != null)
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(child: MesaTag(tag)),
        ),
    ],
    bottom: const PreferredSize(
      preferredSize: Size.fromHeight(2),
      child: ColoredBox(
        color: AppColors.ink,
        child: SizedBox(height: 2, width: double.infinity),
      ),
    ),
  );
}
