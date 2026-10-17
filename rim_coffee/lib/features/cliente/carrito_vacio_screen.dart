import 'package:flutter/material.dart';
import 'package:rim_coffee/core/state/sesion_cliente.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// 11 · Carrito vacío (cliente).
class CarritoVacioScreen extends StatelessWidget {
  const CarritoVacioScreen({super.key, required this.onIrAlMenu});

  final VoidCallback onIrAlMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rcAppBar(
        title: 'Mi pedido',
        tag: 'MESA ${SesionCliente.instance.mesa}',
      ),
      body: EmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'Aún no has agregado nada',
        subtitle: 'Explora el menú y arma tu pedido',
        buttonLabel: 'Ir al menú',
        onPressed: onIrAlMenu,
      ),
    );
  }
}
