import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/models/pedido.dart';
import 'package:rim_coffee/core/state/pedidos_controller.dart';
import 'package:rim_coffee/core/utils/formato.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// 5 · Pedidos entrantes (beneficiario).
/// Cuando el filtro no tiene resultados muestra la pantalla
/// 12 · Sin pedidos pendientes.
class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  static const List<String> _filtros = ['Todos', 'Pendientes', 'En prep.'];
  int _filtro = 0;

  List<Pedido> _filtrar(List<Pedido> todos) {
    switch (_filtro) {
      case 1:
        return todos.where((p) => p.estado == EstadoPedido.pendiente).toList();
      case 2:
        return todos
            .where((p) => p.estado == EstadoPedido.enPreparacion)
            .toList();
      default:
        return todos;
    }
  }

  String get _tituloVacio {
    switch (_filtro) {
      case 1:
        return 'Sin pedidos pendientes';
      case 2:
        return 'Nada en preparación';
      default:
        return 'Sin pedidos por ahora';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controlador = PedidosController.instance;

    return Scaffold(
      appBar: rcAppBar(
        title: 'Pedidos',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: ListenableBuilder(
              listenable: controlador,
              builder: (context, _) {
                final n = controlador.totalPendientes;
                return Badge(
                  label: Text('$n'),
                  isLabelVisible: n > 0,
                  backgroundColor: AppColors.ink,
                  child: const Icon(Icons.notifications_none, size: 26),
                );
              },
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controlador,
        builder: (context, _) {
          final lista = _filtrar(controlador.todos);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: SegmentedTabs(
                  labels: _filtros,
                  selected: _filtro,
                  onChanged: (i) => setState(() => _filtro = i),
                ),
              ),
              Expanded(
                child: lista.isEmpty
                    ? EmptyState(
                        icon: Icons.check,
                        title: _tituloVacio,
                        subtitle: 'Los nuevos pedidos aparecerán aquí',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: lista.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _PedidoCard(pedido: lista[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PedidoCard extends StatelessWidget {
  const _PedidoCard({required this.pedido});

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        PedidosController.instance.marcarVisto(pedido.id);
        Navigator.of(context).pushNamed(Routes.pedidoDetalle, arguments: pedido.id);
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.ink, width: 1.4),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mesa ${pedido.mesa}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${pedido.cliente} · ${pedido.hora}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.soft,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      money(pedido.total),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    StatusChip.deEstado(pedido),
                  ],
                ),
              ],
            ),
          ),
          if (pedido.nuevo)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
