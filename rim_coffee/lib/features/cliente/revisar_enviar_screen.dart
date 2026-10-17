import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_args.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/models/linea_carrito.dart';
import 'package:rim_coffee/core/state/carrito_controller.dart';
import 'package:rim_coffee/core/state/pedidos_controller.dart';
import 'package:rim_coffee/core/state/sesion_cliente.dart';
import 'package:rim_coffee/core/utils/formato.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// 2 · Revisar y enviar (cliente): ticket de referencia, nombre y notas.
/// Aquí no se cobra nada: el pago se hace en caja.
class RevisarEnviarScreen extends StatefulWidget {
  const RevisarEnviarScreen({super.key});

  @override
  State<RevisarEnviarScreen> createState() => _RevisarEnviarScreenState();
}

class _RevisarEnviarScreenState extends State<RevisarEnviarScreen> {
  final TextEditingController _nombre =
      TextEditingController(text: 'Alexandra Camacho');
  final TextEditingController _notas = TextEditingController();

  @override
  void dispose() {
    _nombre.dispose();
    _notas.dispose();
    super.dispose();
  }

  void _enviar() {
    final carrito = CarritoController.instance;
    final sesion = SesionCliente.instance;
    final nombre = _nombre.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe tu nombre para el ticket')),
      );
      return;
    }

    final pedido = PedidosController.instance.crearDesdeCarrito(
      mesa: sesion.mesa,
      cliente: nombre,
      notas: _notas.text.trim(),
      lineas: List<LineaCarrito>.of(carrito.lineas),
    );
    sesion.pedidoActualId = pedido.id;

    Navigator.of(context).pushNamed(Routes.estado);
    carrito.vaciar();
  }

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoController.instance;

    return Scaffold(
      appBar: rcAppBar(
        title: 'Mi pedido',
        tag: 'MESA ${SesionCliente.instance.mesa}',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DashedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ticket de referencia',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
                const Divider(color: AppColors.line, height: 20),
                for (final linea in carrito.lineas) _LineaTicket(linea: linea),
                const Divider(color: AppColors.ink, height: 20),
                Row(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    Text(
                      money(carrito.total),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          RcTextField(label: 'Nombre', controller: _nombre),
          const SizedBox(height: 14),
          RcTextField(
            label: 'Notas para barista',
            controller: _notas,
            maxLines: 3,
            hint: 'Ej. sin azúcar, leche deslactosada…',
          ),
          const SizedBox(height: 18),
          RcButton(label: 'Enviar pedido a barra', onPressed: _enviar),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'El cobro se hace en caja al retirar',
              style: TextStyle(fontSize: 12, color: AppColors.soft),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineaTicket extends StatelessWidget {
  const _LineaTicket({required this.linea});

  final LineaCarrito linea;

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoController.instance;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${linea.cantidad} × ${linea.producto.nombre}',
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                if (linea.detalle.isNotEmpty)
                  Text(
                    linea.detalle,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.soft),
                  ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _AccionPequena(
                      texto: 'Editar',
                      onTap: () => Navigator.of(context).pushNamed(
                        Routes.producto,
                        arguments: DetalleProductoArgs(
                          producto: linea.producto,
                          editar: linea,
                        ),
                      ),
                    ),
                    const Text(
                      '  ·  ',
                      style: TextStyle(fontSize: 11.5, color: AppColors.soft),
                    ),
                    _AccionPequena(
                      texto: 'Quitar',
                      onTap: () => carrito.quitar(linea),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            money(linea.subtotal),
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _AccionPequena extends StatelessWidget {
  const _AccionPequena({required this.texto, required this.onTap});

  final String texto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 11.5,
            color: AppColors.soft,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
