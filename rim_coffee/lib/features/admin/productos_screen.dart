import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/models/producto.dart';
import 'package:rim_coffee/core/state/productos_controller.dart';
import 'package:rim_coffee/core/utils/formato.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';
import 'package:rim_coffee/features/admin/producto_form_sheet.dart';

/// 8 · Gestión de productos (beneficiario): alta, edición y baja del menú.
/// Los cambios se ven al instante en el menú del cliente.
class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  String _consulta = '';

  Future<void> _confirmarBaja(Producto producto) async {
    final eliminar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Eliminar producto'),
        content: Text('¿Seguro que quieres eliminar "${producto.nombre}" del menú?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.ink),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (eliminar == true) {
      ProductosController.instance.eliminar(producto);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controlador = ProductosController.instance;

    return Scaffold(
      appBar: rcAppBar(title: 'Productos'),
      body: ListenableBuilder(
        listenable: controlador,
        builder: (context, _) {
          final lista = _consulta.trim().isEmpty
              ? controlador.todos
              : controlador.buscar(_consulta);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _consulta = v),
                        style: const TextStyle(fontSize: 14),
                        decoration: rcInput(
                          hint: 'Buscar producto',
                          prefixIcon:
                              const Icon(Icons.search, color: AppColors.soft),
                          dense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 48,
                      height: 46,
                      child: FilledButton(
                        onPressed: () => mostrarFormularioProducto(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.ink,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: lista.isEmpty
                    ? const EmptyState(
                        icon: Icons.local_cafe_outlined,
                        title: 'Sin productos',
                        subtitle: 'Agrega uno con el botón +',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: lista.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final p = lista[i];
                          return _ProductoFila(
                            producto: p,
                            onEditar: () =>
                                mostrarFormularioProducto(context, producto: p),
                            onEliminar: () => _confirmarBaja(p),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProductoFila extends StatelessWidget {
  const _ProductoFila({
    required this.producto,
    required this.onEditar,
    required this.onEliminar,
  });

  final Producto producto;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink, width: 1.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const ImagePlaceholder(width: 48, height: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  '${producto.categoria.nombre} · ${money(producto.precio)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.soft),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Editar',
            onPressed: onEditar,
            icon: const Icon(Icons.edit_outlined, size: 20),
          ),
          IconButton(
            tooltip: 'Eliminar',
            onPressed: onEliminar,
            icon: const Icon(Icons.delete_outline, size: 20),
          ),
        ],
      ),
    );
  }
}
