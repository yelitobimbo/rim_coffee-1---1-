import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/models/producto.dart';
import 'package:rim_coffee/core/state/productos_controller.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// Hoja inferior para dar de alta o editar un producto.
/// Si [producto] es null, crea uno nuevo.
Future<void> mostrarFormularioProducto(
  BuildContext context, {
  Producto? producto,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    //surfaceTintColor: Colors.transparent,
    builder: (_) => _ProductoForm(producto: producto),
  );
}

class _ProductoForm extends StatefulWidget {
  const _ProductoForm({this.producto});

  final Producto? producto;

  @override
  State<_ProductoForm> createState() => _ProductoFormState();
}

class _ProductoFormState extends State<_ProductoForm> {
  late final TextEditingController _nombre;
  late final TextEditingController _descripcion;
  late final TextEditingController _precio;
  late Categoria _categoria;
  String? _error;

  bool get _editando => widget.producto != null;

  @override
  void initState() {
    super.initState();
    final p = widget.producto;
    _nombre = TextEditingController(text: p?.nombre ?? '');
    _descripcion = TextEditingController(text: p?.descripcion ?? '');
    _precio = TextEditingController(
      text: p == null ? '' : p.precio.toStringAsFixed(p.precio % 1 == 0 ? 0 : 2),
    );
    _categoria = p?.categoria ?? Categoria.frias;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _descripcion.dispose();
    _precio.dispose();
    super.dispose();
  }

  void _guardar() {
    final nombre = _nombre.text.trim();
    final precio = double.tryParse(_precio.text.trim().replaceAll(',', '.'));

    if (nombre.isEmpty) {
      setState(() => _error = 'Escribe el nombre del producto');
      return;
    }
    if (precio == null || precio <= 0) {
      setState(() => _error = 'Escribe un precio válido');
      return;
    }

    final controlador = ProductosController.instance;
    final descripcion = _descripcion.text.trim();

    if (_editando) {
      controlador.actualizar(
        widget.producto!,
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        categoria: _categoria,
      );
    } else {
      controlador.agregar(
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        categoria: _categoria,
      );
    }

    final mensaje = _editando ? 'Producto actualizado' : 'Producto agregado';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _editando ? 'Editar producto' : 'Nuevo producto',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const ImagePlaceholder(width: 64, height: 64),
                const SizedBox(width: 14),
                Expanded(
                  child: RcButton(
                    label: 'Agregar foto',
                    filled: false,
                    muted: true,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Simulación: aquí se elige la foto')),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            RcTextField(label: 'Nombre', controller: _nombre),
            const SizedBox(height: 12),
            RcTextField(
              label: 'Descripción',
              controller: _descripcion,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            RcTextField(
              label: 'Precio',
              controller: _precio,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              hint: 'Ej. 65',
            ),
            const SizedBox(height: 14),
            const Text(
              'Categoría',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            SegmentedTabs(
              labels: Categoria.values.map((c) => c.nombre).toList(),
              selected: _categoria.index,
              onChanged: (i) => setState(() => _categoria = Categoria.values[i]),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: const TextStyle(fontSize: 12, color: AppColors.accent),
              ),
            ],
            const SizedBox(height: 18),
            RcButton(label: 'Guardar', onPressed: _guardar),
          ],
        ),
      ),
    );
  }
}
