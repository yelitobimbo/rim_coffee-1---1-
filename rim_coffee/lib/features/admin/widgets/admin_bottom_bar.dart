import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// Barra inferior del administrador: Pedidos · Productos · Reportes · Perfil.
/// Sin [onTap] navega al shell con la pestaña elegida (para pantallas que
/// se abren por encima, como el detalle de un pedido).
class AdminBottomBar extends StatelessWidget {
  const AdminBottomBar({super.key, required this.index, this.onTap});

  static const List<BottomItem> items = [
    BottomItem('Pedidos', Icons.receipt_long_outlined),
    BottomItem('Productos', Icons.local_cafe_outlined),
    BottomItem('Reportes', Icons.bar_chart_outlined),
    BottomItem('Perfil', Icons.person_outline),
  ];

  final int index;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return AppBottomBar(
      items: items,
      index: index,
      onTap: onTap ??
          (i) => Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.admin,
                ModalRoute.withName(Routes.launcher),
                arguments: i,
              ),
    );
  }
}
