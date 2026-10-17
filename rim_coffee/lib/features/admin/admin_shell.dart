import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rim_coffee/core/state/pedidos_controller.dart';
import 'package:rim_coffee/features/admin/pedidos_screen.dart';
import 'package:rim_coffee/features/admin/perfil_screen.dart';
import 'package:rim_coffee/features/admin/productos_screen.dart';
import 'package:rim_coffee/features/admin/reportes_screen.dart';
import 'package:rim_coffee/features/admin/widgets/admin_bottom_bar.dart';

/// Contenedor del administrador con sus 4 pestañas.
/// Unos segundos después de entrar simula la llegada de un pedido nuevo
/// con una notificación emergente (patrón Observer del documento).
class AdminShell extends StatefulWidget {
  const AdminShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    if (!PedidosController.instance.yaSimulo) {
      _timer = Timer(const Duration(seconds: 6), _llegaPedido);
    }
  }

  void _llegaPedido() {
    if (!mounted) {
      return;
    }
    final pedido = PedidosController.instance.simularPedidoEntrante();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nuevo pedido · Mesa ${pedido.mesa}'),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Ver',
          textColor: Colors.white,
          onPressed: () {
            if (mounted) {
              setState(() => _index = 0);
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          PedidosScreen(),
          ProductosScreen(),
          ReportesScreen(),
          PerfilScreen(),
        ],
      ),
      bottomNavigationBar: AdminBottomBar(
        index: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
