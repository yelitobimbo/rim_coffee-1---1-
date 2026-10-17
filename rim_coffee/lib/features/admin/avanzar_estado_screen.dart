import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/models/pedido.dart';
import 'package:rim_coffee/core/state/pedidos_controller.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';
import 'package:rim_coffee/features/admin/widgets/admin_bottom_bar.dart';

/// 7 · Avanzar estado (beneficiario): Pendiente → En preparación → Listo →
/// Entregado, un paso a la vez y sin poder retroceder por error.
class AvanzarEstadoScreen extends StatelessWidget {
  const AvanzarEstadoScreen({super.key, required this.pedidoId});

  final String pedidoId;

  @override
  Widget build(BuildContext context) {
    final controlador = PedidosController.instance;

    return ListenableBuilder(
      listenable: controlador,
      builder: (context, _) {
        final pedido = controlador.porId(pedidoId);

        if (pedido == null) {
          return Scaffold(
            appBar: rcAppBar(title: 'Pedido', showBack: true),
            body: const EmptyState(
              icon: Icons.search_off,
              title: 'No encontramos el pedido',
              subtitle: 'Regresa a la lista de pedidos.',
            ),
            bottomNavigationBar: const AdminBottomBar(index: 0),
          );
        }

        final actual = pedido.estado.index;
        final siguiente = pedido.estado.siguiente;

        return Scaffold(
          appBar: rcAppBar(
            title: 'Pedido ${pedido.numero}',
            tag: 'MESA ${pedido.mesa}',
            showBack: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Actualiza el estado conforme avanza',
                style: TextStyle(fontSize: 12.5, color: AppColors.soft),
              ),
              const SizedBox(height: 18),
              VerticalStepper(
                boxed: true,
                steps: [
                  for (final estado in EstadoPedido.values)
                    StepData(
                      label: estado.etiqueta,
                      done: estado.index < actual,
                      current: estado.index == actual,
                    ),
                ],
              ),
              const SizedBox(height: 26),
              RcButton(
                label: siguiente == null
                    ? 'Pedido entregado'
                    : 'Avanzar a: ${siguiente.etiqueta}',
                onPressed: siguiente == null
                    ? null
                    : () {
                        controlador.avanzar(pedido.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Estado actualizado: ${siguiente.etiqueta}'),
                          ),
                        );
                      },
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'El cliente ve este cambio en su pantalla al instante.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.soft),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const AdminBottomBar(index: 0),
        );
      },
    );
  }
}
