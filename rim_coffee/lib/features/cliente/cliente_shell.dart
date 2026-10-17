import 'package:flutter/material.dart';
import 'package:rim_coffee/features/cliente/menu_screen.dart';
import 'package:rim_coffee/features/cliente/mi_pedido_screen.dart';
import 'package:rim_coffee/features/cliente/widgets/cliente_bottom_bar.dart';

/// Contenedor del cliente: pestañas Menú y Mi pedido; Ayuda abre una hoja.
class ClienteShell extends StatefulWidget {
  const ClienteShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<ClienteShell> createState() => _ClienteShellState();
}

class _ClienteShellState extends State<ClienteShell> {
  late int _index = widget.initialIndex;

  void _irA(int i) {
    if (i == 2) {
      mostrarAyudaCliente(context);
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          MenuScreen(onVerPedido: () => _irA(1)),
          MiPedidoScreen(onIrAlMenu: () => _irA(0)),
        ],
      ),
      bottomNavigationBar: ClienteBottomBar(index: _index, onTap: _irA),
    );
  }
}
