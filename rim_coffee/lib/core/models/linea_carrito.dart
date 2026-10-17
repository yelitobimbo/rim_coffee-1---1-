import 'extra.dart';
import 'producto.dart';

/// Una línea del carrito. Los productos repetidos con la misma
/// configuración se agrupan en una sola línea (regla de negocio del documento).
class LineaCarrito {
  LineaCarrito({
    required this.producto,
    required this.cantidad,
    this.tamano = Tamano.mediano,
    this.extras = const <Extra>[],
  });

  final Producto producto;
  int cantidad;
  final Tamano tamano;
  final List<Extra> extras;

  double get precioUnitario {
    var total = producto.precio;
    if (producto.tieneTamano) {
      total += tamano.ajuste;
    }
    for (final e in extras) {
      total += e.precio;
    }
    return total;
  }

  double get subtotal => precioUnitario * cantidad;

  /// Identifica líneas equivalentes para poder agruparlas.
  String get clave {
    final nombres = extras.map((e) => e.nombre).toList()..sort();
    return '${producto.id}|${tamano.name}|${nombres.join(',')}';
  }

  /// Ej.: "Mediano · Shot extra de espresso"
  String get detalle {
    final partes = <String>[
      if (producto.tieneTamano) tamano.etiqueta,
      ...extras.map((e) => e.nombre),
    ];
    return partes.join(' · ');
  }

  /// Ej.: "Frappé de chocolate (Mediano, Shot extra de espresso)"
  String get nombreConDetalle {
    final partes = <String>[
      if (producto.tieneTamano) tamano.etiqueta,
      ...extras.map((e) => e.nombre),
    ];
    if (partes.isEmpty) {
      return producto.nombre;
    }
    return '${producto.nombre} (${partes.join(', ')})';
  }
}
