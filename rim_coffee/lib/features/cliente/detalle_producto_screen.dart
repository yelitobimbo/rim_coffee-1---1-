import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_args.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/models/extra.dart';
import 'package:rim_coffee/core/models/linea_carrito.dart';
import 'package:rim_coffee/core/models/producto.dart';
import 'package:rim_coffee/core/state/carrito_controller.dart';
import 'package:rim_coffee/core/utils/formato.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// 10 · Detalle de producto (cliente): tamaño, extras y cantidad.
/// El precio se recalcula en vivo y se refleja en el botón.
class DetalleProductoScreen extends StatefulWidget {
  const DetalleProductoScreen({super.key, required this.args});

  final DetalleProductoArgs args;

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  late Tamano _tamano;
  late Set<String> _extras;
  late int _cantidad;

  Producto get _producto => widget.args.producto;
  bool get _editando => widget.args.editar != null;

  @override
  void initState() {
    super.initState();
    final editar = widget.args.editar;
    _tamano = editar?.tamano ?? Tamano.mediano;
    _extras = editar == null
        ? <String>{}
        : editar.extras.map((e) => e.nombre).toSet();
    _cantidad = editar?.cantidad ?? 1;
  }

  LineaCarrito _construirLinea() {
    return LineaCarrito(
      producto: _producto,
      cantidad: _cantidad,
      tamano: _tamano,
      extras: extrasDisponibles.where((e) => _extras.contains(e.nombre)).toList(),
    );
  }

  void _confirmar() {
    final carrito = CarritoController.instance;
    final editar = widget.args.editar;
    final linea = _construirLinea();

    if (editar != null) {
      carrito.reemplazar(editar, linea);
    } else {
      carrito.agregarLinea(linea);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _editando
              ? 'Pedido actualizado'
              : '${_producto.nombre} agregado a tu pedido',
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _construirLinea().subtotal;

    return Scaffold(
      appBar: rcAppBar(title: _producto.nombre, showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ImagePlaceholder(width: double.infinity, height: 170),
          const SizedBox(height: 14),
          Text(
            _producto.descripcion,
            style: const TextStyle(fontSize: 13.5, color: AppColors.soft),
          ),
          if (_producto.tieneTamano) ...[
            const SizedBox(height: 20),
            const _Etiqueta('Tamaño'),
            const SizedBox(height: 8),
            SegmentedTabs(
              labels: Tamano.values.map((t) => t.etiqueta).toList(),
              selected: _tamano.index,
              onChanged: (i) => setState(() => _tamano = Tamano.values[i]),
            ),
          ],
          const SizedBox(height: 20),
          const _Etiqueta('Extras'),
          const SizedBox(height: 6),
          for (final extra in extrasDisponibles)
            _ExtraFila(
              extra: extra,
              marcado: _extras.contains(extra.nombre),
              onTap: () => setState(() {
                if (!_extras.add(extra.nombre)) {
                  _extras.remove(extra.nombre);
                }
              }),
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              const _Etiqueta('Cantidad'),
              const Spacer(),
              QtySelector(
                value: _cantidad,
                onAdd: () => setState(() => _cantidad++),
                onRemove: () {
                  if (_cantidad > 1) {
                    setState(() => _cantidad--);
                  }
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: RcButton(
            label: '${_editando ? 'Actualizar' : 'Agregar'} · ${money(subtotal)}',
            onPressed: _confirmar,
          ),
        ),
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
    );
  }
}

class _ExtraFila extends StatelessWidget {
  const _ExtraFila({
    required this.extra,
    required this.marcado,
    required this.onTap,
  });

  final Extra extra;
  final bool marcado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: marcado ? AppColors.ink : Colors.white,
                border: Border.all(color: AppColors.ink, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: marcado
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(extra.nombre, style: const TextStyle(fontSize: 14)),
            ),
            Text(
              '+${money(extra.precio)}',
              style: const TextStyle(fontSize: 13, color: AppColors.soft),
            ),
          ],
        ),
      ),
    );
  }
}
