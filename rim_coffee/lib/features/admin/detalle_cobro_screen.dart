import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/models/pedido.dart';
import 'package:rim_coffee/core/state/pedidos_controller.dart';
import 'package:rim_coffee/core/utils/formato.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';
import 'package:rim_coffee/features/admin/widgets/admin_bottom_bar.dart';

/// 6 · Detalle y cobro (beneficiario): productos, total exacto a cobrar
/// en caja y estado actual del pedido.
class DetalleCobroScreen extends StatelessWidget {
  const DetalleCobroScreen({super.key, required this.pedidoId});

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
              Text(
                '${pedido.cliente} · ${pedido.hora}',
                style: const TextStyle(fontSize: 12.5, color: AppColors.soft),
              ),
              const SizedBox(height: 12),
              for (final item in pedido.items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.cantidad} × ${item.nombre}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        money(item.subtotal),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(color: AppColors.ink, height: 26, thickness: 1.4),
              Row(
                children: [
                  const Text(
                    'Total a cobrar',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  Text(
                    money(pedido.total),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'El cobro se realiza en caja; aquí solo se consulta el monto.',
                style: TextStyle(fontSize: 11.5, color: AppColors.soft),
              ),
              const SizedBox(height: 20),
              const Text(
                'Notas del cliente',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.soft, width: 1.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  pedido.notas.isEmpty ? 'Sin notas' : pedido.notas,
                  style: TextStyle(
                    fontSize: 13,
                    color: pedido.notas.isEmpty ? AppColors.soft : AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Estado actual',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => Navigator.of(context)
                    .pushNamed(Routes.pedidoEstado, arguments: pedido.id),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.ink, width: 1.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        pedido.estado.etiqueta,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Cambiar',
                        style: TextStyle(fontSize: 12, color: AppColors.soft),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RcButton(
                label: pedido.estado.accionSiguiente,
                onPressed: siguiente == null
                    ? null
                    : () {
                        controlador.avanzar(pedido.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pedido ${pedido.numero}: ${siguiente.etiqueta}'),
                          ),
                        );
                      },
              ),
            ],
          ),
          bottomNavigationBar: const AdminBottomBar(index: 0),
        );
      },
    );
  }
}
