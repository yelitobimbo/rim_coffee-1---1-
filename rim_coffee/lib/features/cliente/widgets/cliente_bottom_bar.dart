import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/state/sesion_cliente.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// Barra inferior del cliente: Menú · Mi pedido · Ayuda.
/// [onTap] permite al shell cambiar de pestaña sin navegar; en pantallas
/// que se abren por encima (p. ej. estado del pedido) navega al shell.
class ClienteBottomBar extends StatelessWidget {
  const ClienteBottomBar({super.key, required this.index, this.onTap});

  static const List<BottomItem> items = [
    BottomItem('Menú', Icons.local_cafe_outlined),
    BottomItem('Mi pedido', Icons.receipt_long_outlined),
    BottomItem('Ayuda', Icons.help_outline),
  ];

  final int index;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return AppBottomBar(
      items: items,
      index: index,
      onTap: onTap ??
          (i) {
            if (i == 2) {
              mostrarAyudaCliente(context);
              return;
            }
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.cliente,
              ModalRoute.withName(Routes.launcher),
              arguments: i,
            );
          },
    );
  }
}

/// Hoja inferior de ayuda del cliente.
Future<void> mostrarAyudaCliente(BuildContext context) {
  final mesa = SesionCliente.instance.mesa;

  void avisar(BuildContext ctx, String mensaje) {
    Navigator.of(ctx).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    //surfaceTintColor: Colors.transparent,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ayuda',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                'Mesa $mesa',
                style: const TextStyle(fontSize: 13, color: AppColors.soft),
              ),
              const SizedBox(height: 16),
              RcButton(
                label: 'Llamar al mesero',
                onPressed: () =>
                    avisar(ctx, 'Avisamos al mesero de la mesa $mesa'),
              ),
              const SizedBox(height: 10),
              RcButton(
                label: 'Pedir la cuenta',
                filled: false,
                onPressed: () => avisar(
                  ctx,
                  'El cobro se hace en caja: un mesero te acompañará',
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
