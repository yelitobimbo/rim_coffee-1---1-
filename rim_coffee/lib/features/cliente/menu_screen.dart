import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_args.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/models/producto.dart';
import 'package:rim_coffee/core/state/carrito_controller.dart';
import 'package:rim_coffee/core/state/productos_controller.dart';
import 'package:rim_coffee/core/state/sesion_cliente.dart';
import 'package:rim_coffee/core/utils/formato.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// 1 · Menú (cliente): categorías, búsqueda y cantidades directo en la tarjeta.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.onVerPedido});

  final VoidCallback onVerPedido;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _buscador = TextEditingController();
  Categoria _categoria = Categoria.frias;
  String _consulta = '';

  @override
  void dispose() {
    _buscador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoController.instance;
    final productos = ProductosController.instance;

    return Scaffold(
      appBar: rcAppBar(
        title: 'Rim Coffee',
        tag: 'MESA ${SesionCliente.instance.mesa}',
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([carrito, productos]),
        builder: (context, _) {
          final buscando = _consulta.trim().isNotEmpty;
          final lista = buscando
              ? productos.buscar(_consulta)
              : productos.porCategoria(_categoria);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: TextField(
                  controller: _buscador,
                  onChanged: (v) => setState(() => _consulta = v),
                  style: const TextStyle(fontSize: 14),
                  decoration: rcInput(
                    hint: 'Buscar en el menú',
                    prefixIcon: const Icon(Icons.search, color: AppColors.soft),
                    dense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: SegmentedTabs(
                  labels: Categoria.values.map((c) => c.nombre).toList(),
                  selected: _categoria.index,
                  onChanged: (i) => setState(() {
                    _categoria = Categoria.values[i];
                    _buscador.clear();
                    _consulta = '';
                  }),
                ),
              ),
              Expanded(
                child: lista.isEmpty
                    ? const Center(
                        child: Text(
                          'No encontramos productos',
                          style: TextStyle(color: AppColors.soft),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                        itemCount: lista.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _ProductoCard(producto: lista[i]),
                      ),
              ),
              if (!carrito.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: RcButton(
                    label:
                        'Ver mi pedido · ${carrito.totalPiezas} · ${money(carrito.total)}',
                    onPressed: widget.onVerPedido,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  const _ProductoCard({required this.producto});

  final Producto producto;

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoController.instance;

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () => Navigator.of(context).pushNamed(
        Routes.producto,
        arguments: DetalleProductoArgs(producto: producto),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.ink, width: 1.4),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const ImagePlaceholder(width: 66, height: 66),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    producto.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.soft),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        money(producto.precio),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      QtySelector(
                        value: carrito.cantidadDe(producto.id),
                        onAdd: () => carrito.incrementar(producto),
                        onRemove: () => carrito.decrementar(producto),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
