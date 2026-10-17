import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/models/pedido.dart';
import 'package:rim_coffee/core/state/pedidos_controller.dart';
import 'package:rim_coffee/core/state/sesion_cliente.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';
import 'package:rim_coffee/features/cliente/widgets/cliente_bottom_bar.dart';

/// 3 · Estado del pedido (cliente). Se actualiza solo cuando el beneficiario
/// cambia el estado del pedido (patrón Observer).
class EstadoPedidoScreen extends StatelessWidget {
  const EstadoPedidoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controlador = PedidosController.instance;
    final sesion = SesionCliente.instance;

    return ListenableBuilder(
      listenable: controlador,
      builder: (context, _) {
        final pedido = controlador.porId(sesion.pedidoActualId);

        if (pedido == null) {
          return Scaffold(
            appBar: rcAppBar(title: 'Mi pedido', tag: 'MESA ${sesion.mesa}'),
            body: const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Aún no hay un pedido activo',
              subtitle: 'Cuando envíes tu pedido, aquí verás cómo va.',
            ),
            bottomNavigationBar: const ClienteBottomBar(index: 1),
          );
        }

        final idx = pedido.estado.index;
        final listo = idx >= EstadoPedido.listo.index;

        final titulo = idx == 0
            ? 'Pedido recibido'
            : (listo ? '¡Tu pedido está listo!' : 'Estamos preparando tu pedido');
        final subtitulo = listo
            ? 'Pasa a recogerlo a la barra y paga en caja'
            : 'Te avisamos aquí cuando esté listo';

        return Scaffold(
          appBar: rcAppBar(
            title: 'Pedido ${pedido.numero}',
            tag: 'MESA ${pedido.mesa}',
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: listo ? AppColors.ink : Colors.white,
                    border: Border.all(color: AppColors.ink, width: 2),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 38,
                    color: listo ? Colors.white : AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                subtitulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.5, color: AppColors.soft),
              ),
              const SizedBox(height: 28),
              VerticalStepper(
                steps: [
                  StepData(
                    label: 'Recibido',
                    trailing: pedido.hora,
                    done: idx >= 1,
                    current: idx == 0,
                  ),
                  StepData(
                    label: 'En preparación',
                    trailing: idx < 2 ? 'aprox. 6 min' : null,
                    done: idx >= 2,
                    current: idx == 1,
                  ),
                  StepData(
                    label: 'Listo en barra',
                    done: false,
                    current: listo,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              RcButton(
                label: 'Llamar al mesero',
                filled: false,
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Avisamos al mesero de la mesa ${pedido.mesa}'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              RcButton(
                label: 'Agregar algo más',
                filled: false,
                muted: true,
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.cliente,
                  ModalRoute.withName(Routes.launcher),
                  arguments: 0,
                ),
              ),
            ],
          ),
          bottomNavigationBar: const ClienteBottomBar(index: 1),
        );
      },
    );
  }
}
